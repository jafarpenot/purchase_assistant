from typing import Dict, Any, List, Optional, Tuple
from datetime import datetime, timedelta, timezone
from decimal import Decimal
from statistics import mean, stdev
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
from langchain_openai import ChatOpenAI
from langchain.output_parsers import PydanticOutputParser
from pydantic import BaseModel, Field, validator
from sqlalchemy import select, and_, or_, func, desc
from sqlalchemy.ext.asyncio import AsyncSession
from ..models.schema import PurchaseRequestCreate, RecommendationResponse, Supplier, RecentPurchaseHistory
from ..models.company import Supplier as CompanySupplier, SupplierPerformance, PurchaseOrder, PurchaseOrderItem
from ..config import settings
from ..services.db_interface import db
from langchain_core.callbacks import BaseCallbackHandler

SYSTEM_PROMPT = """
You are a sophisticated procurement assistant with expertise in sustainable procurement, cost analysis, and risk management. Always follow these rules:

Core Procurement Rules:
- Only recommend suppliers with a rating above 4.0
- Never exceed the specified budget
- Prioritize sustainable and local suppliers
- Flag purchases above $10,000 for human approval
- Always check for recent similar purchases before making a recommendation

Analysis Requirements:
- Perform detailed cost-benefit analysis
- Assess environmental impact and sustainability factors
- Evaluate supplier reliability and historical performance
- Consider total cost of ownership (TCO)
- Identify potential supply chain risks
- Analyze market trends and price stability
- Consider quality and compliance requirements

Decision Making:
- Provide clear reasoning for each recommendation
- Include alternative options with pros and cons
- Flag any assumptions or uncertainties
- Consider both short-term and long-term implications
- Evaluate supplier diversity and market competition
"""

class SustainabilityMetrics(BaseModel):
    """Metrics for sustainability analysis"""
    environmental_impact: float = Field(description="Environmental impact score (0-1)", ge=0, le=1)
    local_sourcing_score: float = Field(description="Local sourcing score (0-1)", ge=0, le=1)
    sustainability_certifications: List[str] = Field(description="List of relevant sustainability certifications")
    carbon_footprint_estimate: Optional[float] = Field(description="Estimated carbon footprint in CO2e")
    sustainable_practices: List[str] = Field(description="List of sustainable practices identified")

class CostAnalysis(BaseModel):
    """Detailed cost analysis"""
    estimated_unit_cost: Optional[Decimal] = Field(description="Estimated cost per unit")
    total_cost_estimate: Optional[Decimal] = Field(description="Total cost estimate")
    cost_confidence: float = Field(description="Confidence in cost estimate (0-1)", ge=0, le=1)
    cost_breakdown: Dict[str, Decimal] = Field(description="Breakdown of costs by component")
    price_trend: str = Field(description="Price trend analysis (Stable/Increasing/Decreasing)")
    market_competition_level: str = Field(description="Level of market competition")

class RiskAssessment(BaseModel):
    """Comprehensive risk assessment"""
    supply_chain_risks: List[str] = Field(description="Identified supply chain risks")
    quality_risks: List[str] = Field(description="Potential quality-related risks")
    compliance_risks: List[str] = Field(description="Compliance and regulatory risks")
    financial_risks: List[str] = Field(description="Financial and budgetary risks")
    risk_severity: Dict[str, str] = Field(description="Severity of each risk (Low/Medium/High)")
    mitigation_strategies: Dict[str, str] = Field(description="Suggested mitigation strategies")

class PurchaseAnalysis(BaseModel):
    """Enhanced structured output for purchase request analysis"""
    category: str = Field(description="Main product/service category")
    specifications: List[str] = Field(description="Key specifications or requirements")
    estimated_quantity: Optional[int] = Field(description="Estimated quantity if mentioned")
    requirements: List[str] = Field(description="Any specific requirements or constraints")
    confidence_score: float = Field(description="Overall confidence score of the analysis (0-1)", ge=0, le=1)
    reasoning_steps: List[str] = Field(description="Step-by-step reasoning process")
    potential_risks: List[str] = Field(description="Potential risks or concerns identified")
    suggested_questions: List[str] = Field(description="Suggested questions to clarify requirements")
    
    # New fields for enhanced analysis
    sustainability: SustainabilityMetrics = Field(description="Sustainability analysis metrics")
    cost_analysis: CostAnalysis = Field(description="Detailed cost analysis")
    risk_assessment: RiskAssessment = Field(description="Comprehensive risk assessment")
    market_analysis: Dict[str, Any] = Field(description="Market analysis and trends")
    quality_requirements: List[str] = Field(description="Quality and compliance requirements")
    alternative_options: List[Dict[str, Any]] = Field(description="Alternative options considered")
    
    @validator('confidence_score')
    def validate_confidence_score(cls, v):
        if not 0 <= v <= 1:
            raise ValueError('Confidence score must be between 0 and 1')
        return v

class SupplierScore(BaseModel):
    """Scoring model for supplier matching"""
    supplier: Supplier
    category_match_score: float = Field(description="Score for category matching (0-1)", ge=0, le=1)
    rating_score: float = Field(description="Score based on supplier rating (0-1)", ge=0, le=1)
    performance_score: float = Field(description="Score based on historical performance (0-1)", ge=0, le=1)
    sustainability_score: float = Field(description="Score for sustainability factors (0-1)", ge=0, le=1)
    cost_score: float = Field(description="Score based on cost effectiveness (0-1)", ge=0, le=1)
    delivery_score: float = Field(description="Score based on delivery performance (0-1)", ge=0, le=1)
    total_score: float = Field(description="Total weighted score (0-1)", ge=0, le=1)
    reasoning: List[str] = Field(description="Reasoning for each score component")
    
    @validator('total_score')
    def validate_total_score(cls, v, values):
        # Calculate total score as weighted average
        weights = {
            'category_match_score': 0.25,
            'rating_score': 0.20,
            'performance_score': 0.20,
            'sustainability_score': 0.15,
            'cost_score': 0.10,
            'delivery_score': 0.10
        }
        
        total = sum(
            values.get(field, 0) * weight 
            for field, weight in weights.items()
        )
        
        if abs(v - total) > 0.001:  # Allow for small floating point differences
            raise ValueError(f'Total score {v} does not match calculated weighted average {total}')
        return v

class PriceTrend(BaseModel):
    """Analysis of price trends from historical data"""
    average_price: Decimal = Field(description="Average unit price from historical data")
    price_std_dev: Decimal = Field(description="Standard deviation of unit prices")
    price_trend: str = Field(description="Price trend (Increasing/Stable/Decreasing)")
    price_volatility: float = Field(description="Price volatility score (0-1)", ge=0, le=1)
    recent_price_change: Optional[float] = Field(description="Recent price change percentage")
    price_range: Tuple[Decimal, Decimal] = Field(description="Min and max prices observed")
    confidence_score: float = Field(description="Confidence in price analysis (0-1)", ge=0, le=1)

class PurchaseHistoryAnalysis(BaseModel):
    """Analysis of historical purchase data"""
    similar_purchases: List[RecentPurchaseHistory] = Field(description="List of similar historical purchases")
    total_purchases: int = Field(description="Total number of similar purchases found")
    price_trend: PriceTrend = Field(description="Analysis of price trends")
    common_suppliers: List[Dict[str, Any]] = Field(description="Most common suppliers with their stats")
    success_rate: float = Field(description="Success rate of similar purchases (0-1)", ge=0, le=1)
    average_delivery_time: Optional[int] = Field(description="Average delivery time in days")
    risk_factors: List[str] = Field(description="Risk factors identified from history")
    recommendations: List[str] = Field(description="Recommendations based on history")

class PurchaseAgent:
    """
    Purchase Agent Service using LangChain for intelligent purchase analysis
    """
    
    def __init__(self):
        self.llm = ChatOpenAI(
            temperature=0,
            model_name="gpt-3.5-turbo",
            openai_api_key=settings.OPENAI_API_KEY,
            verbose=True  # Enable verbose logging
        )
        
        # Initialize the output parser
        self.output_parser = PydanticOutputParser(pydantic_object=PurchaseAnalysis)
        
        # Create the enhanced prompt template with format instructions
        template = SYSTEM_PROMPT + """
        Analyze this purchase request and provide a comprehensive analysis in the following JSON format:

        {
            "category": "string (main product/service category)",
            "specifications": ["string (key specification 1)", "string (key specification 2)", ...],
            "estimated_quantity": number (or null if not specified),
            "requirements": ["string (requirement 1)", "string (requirement 2)", ...],
            "confidence_score": number (between 0 and 1),
            "reasoning_steps": ["string (step 1)", "string (step 2)", ...],
            "potential_risks": ["string (risk 1)", "string (risk 2)", ...],
            "suggested_questions": ["string (question 1)", "string (question 2)", ...],
            "sustainability": {
                "environmental_impact": number (between 0 and 1),
                "local_sourcing_score": number (between 0 and 1),
                "sustainability_certifications": ["string (cert 1)", "string (cert 2)", ...],
                "carbon_footprint_estimate": number (or null),
                "sustainable_practices": ["string (practice 1)", "string (practice 2)", ...]
            },
            "cost_analysis": {
                "estimated_unit_cost": number (or null),
                "total_cost_estimate": number (or null),
                "cost_confidence": number (between 0 and 1),
                "cost_breakdown": {"component1": number, "component2": number, ...},
                "price_trend": "Stable" | "Increasing" | "Decreasing",
                "market_competition_level": "Low" | "Moderate" | "High"
            },
            "risk_assessment": {
                "supply_chain_risks": ["string (risk 1)", "string (risk 2)", ...],
                "quality_risks": ["string (risk 1)", "string (risk 2)", ...],
                "compliance_risks": ["string (risk 1)", "string (risk 2)", ...],
                "financial_risks": ["string (risk 1)", "string (risk 2)", ...],
                "risk_severity": {"risk1": "Low" | "Medium" | "High", ...},
                "mitigation_strategies": {"risk1": "string (strategy)", ...}
            },
            "market_analysis": {
                "market_conditions": "string",
                "price_stability": "string",
                "supplier_availability": "string",
                "market_trends": "string"
            },
            "quality_requirements": ["string (requirement 1)", "string (requirement 2)", ...],
            "alternative_options": [
                {
                    "name": "string",
                    "pros": ["string (pro 1)", "string (pro 2)", ...],
                    "cons": ["string (con 1)", "string (con 2)", ...],
                    "estimated_cost": number
                },
                ...
            ]
        }

        Example output for a notebook purchase:
        {
            "category": "Office Supplies",
            "specifications": [
                "A4 size (210mm x 297mm)",
                "80 sheets per notebook",
                "Lined paper",
                "Hard cover"
            ],
            "estimated_quantity": 3,
            "requirements": [
                "Must be acid-free paper",
                "Must have durable binding",
                "Must be recyclable"
            ],
            "confidence_score": 0.85,
            "reasoning_steps": [
                "Analyzed product category and specifications",
                "Evaluated quantity based on request",
                "Assessed quality requirements",
                "Calculated cost estimates"
            ],
            "potential_risks": [
                "Supply chain delays",
                "Price fluctuations",
                "Quality variations between suppliers"
            ],
            "suggested_questions": [
                "Preferred paper weight?",
                "Any specific brand preferences?",
                "Required delivery timeline?"
            ],
            "sustainability": {
                "environmental_impact": 0.7,
                "local_sourcing_score": 0.6,
                "sustainability_certifications": [
                    "FSC Certified",
                    "Recycled Paper"
                ],
                "carbon_footprint_estimate": 2.5,
                "sustainable_practices": [
                    "Recycled materials",
                    "Eco-friendly packaging"
                ]
            },
            "cost_analysis": {
                "estimated_unit_cost": 12.99,
                "total_cost_estimate": 38.97,
                "cost_confidence": 0.9,
                "cost_breakdown": {
                    "materials": 8.50,
                    "manufacturing": 2.50,
                    "shipping": 1.99
                },
                "price_trend": "Stable",
                "market_competition_level": "High"
            },
            "risk_assessment": {
                "supply_chain_risks": [
                    "Potential paper supply delays",
                    "Shipping disruptions"
                ],
                "quality_risks": [
                    "Paper quality variations",
                    "Binding durability"
                ],
                "compliance_risks": [
                    "Environmental certification requirements",
                    "Import regulations"
                ],
                "financial_risks": [
                    "Currency fluctuations",
                    "Price increases"
                ],
                "risk_severity": {
                    "supply_chain": "Low",
                    "quality": "Medium",
                    "compliance": "Low",
                    "financial": "Low"
                },
                "mitigation_strategies": {
                    "supply_chain": "Order in advance",
                    "quality": "Request samples",
                    "compliance": "Verify certifications",
                    "financial": "Lock in prices"
                }
            },
            "market_analysis": {
                "market_conditions": "Stable with good supplier availability",
                "price_stability": "High",
                "supplier_availability": "Good",
                "market_trends": "Increasing focus on sustainability"
            },
            "quality_requirements": [
                "Paper must be acid-free",
                "Binding must be durable",
                "Cover must be hard and water-resistant",
                "Must meet FSC certification standards"
            ],
            "alternative_options": [
                {
                    "name": "Premium Recycled Notebook",
                    "pros": [
                        "100% recycled materials",
                        "Higher quality paper",
                        "More durable binding"
                    ],
                    "cons": [
                        "Higher cost",
                        "Limited color options"
                    ],
                    "estimated_cost": 15.99
                },
                {
                    "name": "Basic Office Notebook",
                    "pros": [
                        "Lower cost",
                        "Wide availability",
                        "Standard quality"
                    ],
                    "cons": [
                        "Lower paper quality",
                        "Less durable binding"
                    ],
                    "estimated_cost": 9.99
                }
            ]
        }
        
        Purchase Request Details:
        Description: {description}
        Category: {category}
        Quantity: {quantity}
        Budget: {budget}
        Urgency: {urgency_level}
        
        Important Notes:
        1. ALL fields in the example above are REQUIRED
        2. Use proper JSON types (numbers, strings, arrays, objects)
        3. Do not include units in numeric values
        4. All scores should be between 0 and 1
        5. quality_requirements MUST be a list of strings
        6. alternative_options MUST be a list of dictionaries with 'name', 'pros', 'cons', and 'estimated_cost'
        7. Follow the exact structure shown in the example
        
        {format_instructions}
        """
        
        # Initialize the purchase analysis chain with the enhanced prompt template
        self.purchase_analysis_prompt = PromptTemplate(
            template=template,
            input_variables=["description", "category", "quantity", "budget", "urgency_level"],
            partial_variables={"format_instructions": self.output_parser.get_format_instructions()}
        )
        
        self.purchase_analysis_chain = LLMChain(
            llm=self.llm,
            prompt=self.purchase_analysis_prompt,
            output_parser=self.output_parser,
            verbose=True  # Enable verbose logging for the chain
        )

    async def analyze_purchase_request(self, request: PurchaseRequestCreate) -> Tuple[PurchaseAnalysis, str]:
        """
        Enhanced analysis of a purchase request using LangChain to extract structured information.
        
        Args:
            request: PurchaseRequestCreate object containing the purchase request details
            
        Returns:
            Tuple of (PurchaseAnalysis object, reasoning log)
        """
        try:
            # Create a string buffer to capture the chain's reasoning
            reasoning_log = []
            
            # Custom callback to capture the chain's reasoning
            class ReasoningCallback(BaseCallbackHandler):
                def on_chain_start(self, serialized, inputs, **kwargs):
                    reasoning_log.append(f"\nStarting analysis for request: {inputs}")
                
                def on_chain_end(self, outputs, **kwargs):
                    reasoning_log.append(f"\nAnalysis complete. Output: {outputs}")
                
                def on_llm_start(self, serialized, prompts, **kwargs):
                    reasoning_log.append(f"\nLLM processing prompt: {prompts[0]}")
                
                def on_llm_end(self, response, **kwargs):
                    reasoning_log.append(f"\nLLM response: {response.generations[0][0].text}")
                
                def on_llm_error(self, error, **kwargs):
                    reasoning_log.append(f"\nLLM error: {str(error)}")
            
            # Add the callback to the chain
            self.purchase_analysis_chain.callbacks = [ReasoningCallback()]
            
            # Run the chain with all request details
            raw_result = await self.purchase_analysis_chain.ainvoke(
                {
                    "description": request.description,
                    "category": request.category or "Unspecified",
                    "quantity": str(request.quantity),
                    "budget": str(request.budget) if request.budget else "Unspecified",
                    "urgency_level": request.urgency_level or "Medium"
                }
            )
            
            # Ensure we have a dictionary result
            if isinstance(raw_result, dict):
                result = PurchaseAnalysis(**raw_result)
            else:
                # If the result is already a PurchaseAnalysis object, use it directly
                result = raw_result
            
            # Validate and enhance the analysis
            if result.confidence_score < 0.5:
                result.suggested_questions.append(
                    "The analysis has low confidence. Please provide more specific details about your requirements."
                )
            
            # Add budget-specific validation if budget is provided
            if request.budget and result.cost_analysis.total_cost_estimate:
                if isinstance(result.cost_analysis.total_cost_estimate, str):
                    try:
                        total_cost = Decimal(result.cost_analysis.total_cost_estimate)
                    except:
                        total_cost = Decimal('0')
                else:
                    total_cost = Decimal(str(result.cost_analysis.total_cost_estimate))
                
                if total_cost > request.budget:
                    result.risk_assessment.financial_risks.append(
                        f"Estimated cost (${total_cost}) exceeds budget (${request.budget})"
                    )
                    result.cost_analysis.cost_confidence = min(
                        result.cost_analysis.cost_confidence,
                        0.7  # Reduce confidence when budget is exceeded
                    )
            
            return result, "\n".join(reasoning_log)
        except Exception as e:
            # Enhanced error handling with more detailed fallback
            error_msg = f"Error in purchase analysis: {str(e)}"
            print(error_msg)
            reasoning_log.append(error_msg)
            
            # Create a minimal valid PurchaseAnalysis object
            return (
                PurchaseAnalysis(
                    category=request.category or "Unknown",
                    specifications=["Basic office chair requirements"],
                    estimated_quantity=request.quantity,
                    requirements=["Standard office chair specifications"],
                    confidence_score=0.0,
                    reasoning_steps=["Error occurred during analysis"],
                    potential_risks=["Unable to analyze risks due to error"],
                    suggested_questions=["Please provide more details about your requirements"],
                    sustainability=SustainabilityMetrics(
                        environmental_impact=0.0,
                        local_sourcing_score=0.0,
                        sustainability_certifications=[],
                        carbon_footprint_estimate=None,
                        sustainable_practices=[]
                    ),
                    cost_analysis=CostAnalysis(
                        estimated_unit_cost=None,
                        total_cost_estimate=None,
                        cost_confidence=0.0,
                        cost_breakdown={},
                        price_trend="Unknown",
                        market_competition_level="Unknown"
                    ),
                    risk_assessment=RiskAssessment(
                        supply_chain_risks=["Unable to assess due to error"],
                        quality_risks=["Unable to assess due to error"],
                        compliance_risks=["Unable to assess due to error"],
                        financial_risks=["Unable to assess due to error"],
                        risk_severity={},
                        mitigation_strategies={}
                    ),
                    market_analysis={},
                    quality_requirements=[],
                    alternative_options=[]
                ),
                "\n".join(reasoning_log)
            )

    async def _get_supplier_performance(self, session: AsyncSession, supplier_id: int) -> Tuple[float, Dict[str, float]]:
        """
        Get supplier performance metrics from historical data.
        
        Args:
            session: Database session
            supplier_id: ID of the supplier
            
        Returns:
            Tuple of (average performance score, detailed metrics)
        """
        # Get performance records for the last 6 months
        six_months_ago = datetime.now(timezone.utc) - timedelta(days=180)
        
        query = select(
            func.avg(SupplierPerformance.delivery_rating).label('avg_delivery'),
            func.avg(SupplierPerformance.quality_rating).label('avg_quality'),
            func.avg(SupplierPerformance.communication_rating).label('avg_communication'),
            func.count(SupplierPerformance.id).label('total_orders')
        ).where(
            and_(
                SupplierPerformance.supplier_id == supplier_id,
                SupplierPerformance.created_at >= six_months_ago
            )
        )
        
        result = await session.execute(query)
        metrics = result.first()
        
        if not metrics or not metrics.total_orders:
            return 0.0, {
                'delivery': 0.0,
                'quality': 0.0,
                'communication': 0.0,
                'total_orders': 0
            }
        
        # Calculate weighted average performance
        weights = {'delivery': 0.4, 'quality': 0.4, 'communication': 0.2}
        avg_scores = {
            'delivery': float(metrics.avg_delivery or 0),
            'quality': float(metrics.avg_quality or 0),
            'communication': float(metrics.avg_communication or 0),
            'total_orders': metrics.total_orders
        }
        
        performance_score = sum(
            avg_scores[metric] * weight / 5.0  # Normalize to 0-1 range
            for metric, weight in weights.items()
        )
        
        return performance_score, avg_scores

    async def _calculate_supplier_scores(
        self,
        session: AsyncSession,
        analysis: PurchaseAnalysis,
        request: PurchaseRequestCreate
    ) -> List[SupplierScore]:
        """
        Calculate scores for all matching suppliers.
        
        Args:
            session: Database session
            analysis: Purchase request analysis
            request: Original purchase request
            
        Returns:
            List of scored suppliers
        """
        # Get all active suppliers in the category
        query = select(CompanySupplier).where(
            and_(
                CompanySupplier.is_active == True,
                CompanySupplier.category == analysis.category
            )
        )
        
        result = await session.execute(query)
        suppliers = result.scalars().all()
        
        if not suppliers:
            return []
        
        scored_suppliers = []
        for supplier in suppliers:
            # Get performance metrics
            performance_score, performance_metrics = await self._get_supplier_performance(
                session, supplier.id
            )
            
            # Calculate individual scores
            category_match_score = 1.0  # Already filtered by category
            rating_score = float(supplier.rating or 0) / 5.0  # Normalize to 0-1
            
            # Calculate sustainability score based on analysis
            sustainability_score = (
                analysis.sustainability.environmental_impact * 0.6 +
                analysis.sustainability.local_sourcing_score * 0.4
            )
            
            # Calculate cost score based on budget
            cost_score = 1.0
            if request.budget and analysis.cost_analysis.total_cost_estimate:
                if isinstance(analysis.cost_analysis.total_cost_estimate, str):
                    try:
                        total_cost = Decimal(analysis.cost_analysis.total_cost_estimate)
                    except:
                        total_cost = Decimal('0')
                else:
                    total_cost = Decimal(str(analysis.cost_analysis.total_cost_estimate))
                
                cost_ratio = float(total_cost / request.budget)
                cost_score = max(0, 1 - (cost_ratio - 1))  # Penalize if over budget
            
            # Calculate delivery score
            delivery_score = performance_metrics['delivery'] / 5.0  # Normalize to 0-1
            
            # Create reasoning for each score
            reasoning = [
                f"Category match: Perfect match for {analysis.category}",
                f"Rating: {supplier.rating}/5.0",
                f"Performance: {performance_score:.2%} based on {performance_metrics['total_orders']} orders",
                f"Sustainability: {sustainability_score:.2%} (Environmental: {analysis.sustainability.environmental_impact:.2%}, Local: {analysis.sustainability.local_sourcing_score:.2%})",
                f"Cost effectiveness: {cost_score:.2%}",
                f"Delivery performance: {delivery_score:.2%}"
            ]
            
            # Calculate total score using weights
            weights = {
                'category_match_score': 0.25,
                'rating_score': 0.20,
                'performance_score': 0.20,
                'sustainability_score': 0.15,
                'cost_score': 0.10,
                'delivery_score': 0.10
            }
            
            total_score = sum(
                score * weight 
                for score, weight in [
                    (category_match_score, weights['category_match_score']),
                    (rating_score, weights['rating_score']),
                    (performance_score, weights['performance_score']),
                    (sustainability_score, weights['sustainability_score']),
                    (cost_score, weights['cost_score']),
                    (delivery_score, weights['delivery_score'])
                ]
            )
            
            # Create supplier score
            score = SupplierScore(
                supplier=Supplier.model_validate(supplier),
                category_match_score=category_match_score,
                rating_score=rating_score,
                performance_score=performance_score,
                sustainability_score=sustainability_score,
                cost_score=cost_score,
                delivery_score=delivery_score,
                total_score=total_score,  # Now calculated correctly
                reasoning=reasoning
            )
            
            scored_suppliers.append(score)
        
        # Sort by total score
        return sorted(scored_suppliers, key=lambda x: x.total_score, reverse=True)

    async def _analyze_price_trend(
        self,
        purchases: List[RecentPurchaseHistory],
        months: int = 3
    ) -> PriceTrend:
        """
        Analyze price trends from historical purchase data.
        
        Args:
            purchases: List of historical purchases
            months: Number of months to analyze
            
        Returns:
            PriceTrend object with analysis results
        """
        if not purchases:
            return PriceTrend(
                average_price=Decimal("0"),
                price_std_dev=Decimal("0"),
                price_trend="Unknown",
                price_volatility=0.0,
                recent_price_change=None,
                price_range=(Decimal("0"), Decimal("0")),
                confidence_score=0.0
            )
        
        # Extract prices and dates
        prices = [float(p.unit_price) for p in purchases]
        dates = [p.order_date for p in purchases]
        
        # Calculate basic statistics
        avg_price = Decimal(str(mean(prices))).quantize(Decimal("0.01"))
        std_dev = Decimal(str(stdev(prices))).quantize(Decimal("0.01")) if len(prices) > 1 else Decimal("0")
        min_price = Decimal(str(min(prices))).quantize(Decimal("0.01"))
        max_price = Decimal(str(max(prices))).quantize(Decimal("0.01"))
        
        # Calculate price trend
        if len(prices) >= 2:
            # Split data into two periods
            mid_point = len(prices) // 2
            first_half_avg = mean(prices[:mid_point])
            second_half_avg = mean(prices[mid_point:])
            
            # Calculate trend
            if second_half_avg > first_half_avg * 1.05:
                trend = "Increasing"
                recent_change = ((second_half_avg - first_half_avg) / first_half_avg) * 100
            elif second_half_avg < first_half_avg * 0.95:
                trend = "Decreasing"
                recent_change = ((first_half_avg - second_half_avg) / first_half_avg) * 100
            else:
                trend = "Stable"
                recent_change = 0.0
        else:
            trend = "Insufficient Data"
            recent_change = None
        
        # Calculate volatility
        volatility = min(1.0, float(std_dev) / float(avg_price)) if avg_price > 0 else 0.0
        
        # Calculate confidence score
        confidence = min(1.0, len(prices) / 10)  # More data = higher confidence, max at 10 purchases
        
        return PriceTrend(
            average_price=avg_price,
            price_std_dev=std_dev,
            price_trend=trend,
            price_volatility=volatility,
            recent_price_change=recent_change,
            price_range=(min_price, max_price),
            confidence_score=confidence
        )

    async def _analyze_purchase_history(
        self,
        session: AsyncSession,
        analysis: PurchaseAnalysis,
        request: PurchaseRequestCreate,
        months: int = 3
    ) -> PurchaseHistoryAnalysis:
        """
        Analyze historical purchase data for similar items.
        
        Args:
            session: Database session
            analysis: Purchase request analysis
            request: Original purchase request
            months: Number of months to look back
            
        Returns:
            PurchaseHistoryAnalysis object with historical insights
        """
        # Get similar purchases
        purchases = await db.get_recent_similar_purchases(
            session=session,
            description=request.description,
            category=analysis.category,
            months=months
        )
        
        # Analyze price trends
        price_trend = await self._analyze_price_trend(purchases, months)
        
        # Analyze supplier performance
        supplier_stats = {}
        for purchase in purchases:
            if purchase.supplier_name not in supplier_stats:
                supplier_stats[purchase.supplier_name] = {
                    'count': 0,
                    'total_amount': Decimal('0'),
                    'successful_orders': 0
                }
            
            stats = supplier_stats[purchase.supplier_name]
            stats['count'] += 1
            stats['total_amount'] += purchase.total_price
            if purchase.status == 'Delivered':
                stats['successful_orders'] += 1
        
        # Calculate success rates and format supplier stats
        common_suppliers = []
        for name, stats in supplier_stats.items():
            success_rate = stats['successful_orders'] / stats['count'] if stats['count'] > 0 else 0
            common_suppliers.append({
                'name': name,
                'order_count': stats['count'],
                'total_spend': stats['total_amount'],
                'success_rate': success_rate,
                'average_order_value': (stats['total_amount'] / stats['count']).quantize(Decimal('0.01'))
            })
        
        # Sort suppliers by order count
        common_suppliers.sort(key=lambda x: x['order_count'], reverse=True)
        
        # Calculate overall success rate
        total_orders = len(purchases)
        successful_orders = sum(1 for p in purchases if p.status == 'Delivered')
        success_rate = successful_orders / total_orders if total_orders > 0 else 0.0
        
        # Calculate average delivery time
        delivery_times = []
        for purchase in purchases:
            if purchase.status == 'Delivered':
                # Find the corresponding purchase order
                query = select(PurchaseOrder).join(
                    CompanySupplier
                ).where(
                    and_(
                        CompanySupplier.name == purchase.supplier_name,
                        PurchaseOrder.order_date == purchase.order_date
                    )
                )
                result = await session.execute(query)
                order = result.scalar_one_or_none()
                
                if order and order.actual_delivery_date:
                    delivery_time = (order.actual_delivery_date - order.order_date).days
                    delivery_times.append(delivery_time)
        
        avg_delivery_time = int(mean(delivery_times)) if delivery_times else None
        
        # Identify risk factors
        risk_factors = []
        if price_trend.price_volatility > 0.3:
            risk_factors.append(f"High price volatility ({price_trend.price_volatility:.0%})")
        if success_rate < 0.8:
            risk_factors.append(f"Low success rate ({success_rate:.0%})")
        if avg_delivery_time and avg_delivery_time > 14:
            risk_factors.append(f"Long average delivery time ({avg_delivery_time} days)")
        
        # Generate recommendations
        recommendations = []
        if price_trend.price_trend == "Increasing":
            recommendations.append("Consider negotiating prices or exploring alternative suppliers due to increasing prices")
        if price_trend.price_volatility > 0.3:
            recommendations.append("Consider setting up a price agreement to manage volatility")
        if success_rate < 0.8:
            recommendations.append("Consider additional quality checks or supplier evaluation")
        if avg_delivery_time and avg_delivery_time > 14:
            recommendations.append("Consider ordering earlier or exploring faster delivery options")
        
        return PurchaseHistoryAnalysis(
            similar_purchases=purchases,
            total_purchases=total_orders,
            price_trend=price_trend,
            common_suppliers=common_suppliers,
            success_rate=success_rate,
            average_delivery_time=avg_delivery_time,
            risk_factors=risk_factors,
            recommendations=recommendations
        )

    async def get_recommendation(self, request: PurchaseRequestCreate) -> RecommendationResponse:
        """
        Get a supplier recommendation based on the purchase request.
        Now includes comprehensive historical analysis and reasoning log.
        
        Args:
            request: PurchaseRequestCreate object containing the purchase need description
            
        Returns:
            RecommendationResponse object with supplier recommendation and reasoning log
        """
        # First, analyze the purchase request
        analysis, reasoning_log = await self.analyze_purchase_request(request)
        
        # Get database session
        async with await db.get_session() as session:
            # Analyze purchase history
            history_analysis = await self._analyze_purchase_history(
                session=session,
                analysis=analysis,
                request=request
            )
            
            # Calculate supplier scores
            scored_suppliers = await self._calculate_supplier_scores(
                session=session,
                analysis=analysis,
                request=request
            )
            
            if not scored_suppliers:
                # Fallback to dummy data if no suppliers found
                dummy_supplier = Supplier(
                    id=1,
                    name="No matching suppliers found",
                    category=analysis.category,
                    rating=0.0,
                    created_at=datetime.utcnow()
                )
                
                return RecommendationResponse(
                    supplier=dummy_supplier,
                    confidence_score=0.0,
                    reasoning="No active suppliers found in the requested category.",
                    alternative_suppliers=[],
                    reasoning_log=reasoning_log  # Include the reasoning log
                )
            
            # Adjust supplier scores based on historical performance
            for score in scored_suppliers:
                # Find supplier in history analysis
                supplier_history = next(
                    (s for s in history_analysis.common_suppliers if s['name'] == score.supplier.name),
                    None
                )
                
                if supplier_history:
                    # Adjust performance score based on historical success
                    score.performance_score = (
                        score.performance_score * 0.7 +  # Current performance
                        supplier_history['success_rate'] * 0.3  # Historical success
                    )
                    
                    # Add historical reasoning
                    score.reasoning.append(
                        f"Historical Performance: {supplier_history['success_rate']:.0%} success rate "
                        f"over {supplier_history['order_count']} orders"
                    )
            
            # Re-sort suppliers with adjusted scores
            scored_suppliers.sort(key=lambda x: x.total_score, reverse=True)
            
            # Get top supplier and alternatives
            top_supplier = scored_suppliers[0]
            alternative_suppliers = [
                score.supplier for score in scored_suppliers[1:4]  # Get next 3 suppliers
            ]
            
            # Create detailed reasoning
            reasoning = f"""
Analysis Results:
----------------
Category: {analysis.category}
Confidence Score: {analysis.confidence_score:.2%}

Key Specifications:
{chr(10).join(f"- {spec}" for spec in analysis.specifications)}

Requirements:
{chr(10).join(f"- {req}" for req in analysis.requirements)}

Historical Analysis:
------------------
Total Similar Purchases: {history_analysis.total_purchases}
Price Trend: {history_analysis.price_trend.price_trend}
Average Price: ${history_analysis.price_trend.average_price}
Price Volatility: {history_analysis.price_trend.price_volatility:.0%}
Success Rate: {history_analysis.success_rate:.0%}
Average Delivery Time: {history_analysis.average_delivery_time or 'N/A'} days

Risk Factors:
{chr(10).join(f"- {risk}" for risk in history_analysis.risk_factors)}

Historical Recommendations:
{chr(10).join(f"- {rec}" for rec in history_analysis.recommendations)}

Supplier Selection Reasoning:
{chr(10).join(f"- {reason}" for reason in top_supplier.reasoning)}

Performance Metrics:
- Category Match: {top_supplier.category_match_score:.2%}
- Rating Score: {top_supplier.rating_score:.2%}
- Performance Score: {top_supplier.performance_score:.2%}
- Sustainability Score: {top_supplier.sustainability_score:.2%}
- Cost Score: {top_supplier.cost_score:.2%}
- Delivery Score: {top_supplier.delivery_score:.2%}
- Total Score: {top_supplier.total_score:.2%}

Potential Risks:
{chr(10).join(f"- {risk}" for risk in analysis.risk_assessment.supply_chain_risks)}

Suggested Questions:
{chr(10).join(f"- {q}" for q in analysis.suggested_questions)}
"""
            
            return RecommendationResponse(
                supplier=top_supplier.supplier,
                confidence_score=top_supplier.total_score,
                reasoning=reasoning,
                alternative_suppliers=alternative_suppliers,
                reasoning_log=reasoning_log  # Include the reasoning log
            )

# Create a singleton instance
agent = PurchaseAgent() 
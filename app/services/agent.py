from typing import Dict, Any, List, Optional
from datetime import datetime
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
from langchain_openai import ChatOpenAI
from langchain.output_parsers import PydanticOutputParser
from pydantic import BaseModel, Field
from ..models.schema import PurchaseRequestCreate, RecommendationResponse, Supplier
from ..config import settings

class PurchaseAnalysis(BaseModel):
    """Structured output for purchase request analysis"""
    category: str = Field(description="Main product/service category")
    specifications: List[str] = Field(description="Key specifications or requirements")
    estimated_quantity: Optional[int] = Field(description="Estimated quantity if mentioned")
    requirements: List[str] = Field(description="Any specific requirements or constraints")
    confidence_score: float = Field(description="Confidence score of the analysis (0-1)")
    reasoning_steps: List[str] = Field(description="Step-by-step reasoning process")
    potential_risks: List[str] = Field(description="Potential risks or concerns identified")
    suggested_questions: List[str] = Field(description="Suggested questions to clarify requirements")

class PurchaseAgent:
    """
    Purchase Agent Service using LangChain for intelligent purchase analysis
    """
    
    def __init__(self):
        self.llm = ChatOpenAI(
            temperature=0,
            model_name="gpt-3.5-turbo",
            openai_api_key=settings.OPENAI_API_KEY
        )
        
        # Initialize the output parser
        self.output_parser = PydanticOutputParser(pydantic_object=PurchaseAnalysis)
        
        # Create the prompt template with format instructions
        template = """
        Analyze this purchase request and provide a detailed analysis:
        Description: {description}
        
        Please provide:
        1. Main product/service category
        2. Key specifications and requirements
        3. Estimated quantity if mentioned
        4. Any specific requirements or constraints
        5. Step-by-step reasoning process
        6. Potential risks or concerns
        7. Suggested questions to clarify requirements
        
        Think through this step by step and explain your reasoning.
        
        {format_instructions}
        """
        
        # Initialize the purchase analysis chain with the prompt template
        self.purchase_analysis_prompt = PromptTemplate(
            template=template,
            input_variables=["description"],
            partial_variables={"format_instructions": self.output_parser.get_format_instructions()}
        )
        
        self.purchase_analysis_chain = LLMChain(
            llm=self.llm,
            prompt=self.purchase_analysis_prompt,
            output_parser=self.output_parser
        )

    async def analyze_purchase_request(self, description: str) -> PurchaseAnalysis:
        """
        Analyze a purchase request using LangChain to extract structured information.
        
        Args:
            description: The purchase request description
            
        Returns:
            PurchaseAnalysis object containing structured information about the request
        """
        try:
            # Run the chain with the description
            result = await self.purchase_analysis_chain.arun(description=description)
            return result
        except Exception as e:
            # Log the error and return a basic analysis
            print(f"Error in purchase analysis: {str(e)}")
            return PurchaseAnalysis(
                category="Unknown",
                specifications=[],
                estimated_quantity=None,
                requirements=[],
                confidence_score=0.0,
                reasoning_steps=["Error occurred during analysis"],
                potential_risks=["Unable to analyze risks due to error"],
                suggested_questions=["Please provide more details about your requirements"]
            )

    async def get_recommendation(self, request: PurchaseRequestCreate) -> RecommendationResponse:
        """
        Get a supplier recommendation based on the purchase request.
        Now includes detailed analysis using LangChain.
        
        Args:
            request: PurchaseRequestCreate object containing the purchase need description
            
        Returns:
            RecommendationResponse object with supplier recommendation
        """
        # First, analyze the purchase request
        analysis = await self.analyze_purchase_request(request.description)
        
        # For now, still return dummy data, but we'll use the analysis in the next step
        dummy_supplier = Supplier(
            id=1,
            name="Sample Supplier Co.",
            category=analysis.category,  # Use the analyzed category
            rating=4.5,
            created_at=datetime.utcnow()
        )
        
        alt_suppliers = [
            Supplier(
                id=2,
                name="Alternative Supplier Inc.",
                category=analysis.category,  # Use the analyzed category
                rating=4.2,
                created_at=datetime.utcnow()
            )
        ]
        
        # Create a detailed reasoning string that includes all analysis components
        reasoning = f"""
Analysis Results:
----------------
Category: {analysis.category}
Confidence Score: {analysis.confidence_score:.2%}

Key Specifications:
{chr(10).join(f"- {spec}" for spec in analysis.specifications)}

Requirements:
{chr(10).join(f"- {req}" for req in analysis.requirements)}

Reasoning Process:
{chr(10).join(f"{i+1}. {step}" for i, step in enumerate(analysis.reasoning_steps))}

Potential Risks:
{chr(10).join(f"- {risk}" for risk in analysis.potential_risks)}

Suggested Questions:
{chr(10).join(f"- {q}" for q in analysis.suggested_questions)}
"""
        
        return RecommendationResponse(
            supplier=dummy_supplier,
            confidence_score=analysis.confidence_score,
            reasoning=reasoning,
            alternative_suppliers=alt_suppliers
        )

# Create a singleton instance
agent = PurchaseAgent() 
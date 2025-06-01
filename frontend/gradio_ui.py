import gradio as gr
import requests
import json
from typing import Dict, Any, List
import os
from datetime import datetime
from decimal import Decimal

# Update the API_URL to use environment variable
API_URL = os.getenv("API_URL", "http://localhost:8000/api/v1")
print(f"Using API_URL: {API_URL}")  # Debug log

def get_recommendation(
    description: str,
    requester_name: str,
    quantity: int,
    category: str = "",
    department: str = "",
    unit: str = "",
    budget: float = None,
    urgency_level: str = "Medium"
) -> Dict[str, Any]:
    """
    Get a supplier recommendation from the API.
    """
    try:
        # Prepare request data
        request_data = {
            "description": description,
            "requester_name": requester_name,
            "quantity": quantity,
            "category": category if category else None,
            "department": department if department else None,
            "unit": unit if unit else None,
            "budget": budget,
            "urgency_level": urgency_level
        }
        
        # Make API call
        url = f"{API_URL}/recommend"
        print(f"Making recommendation request to: {url}")  # Debug log
        response = requests.post(url, json=request_data)
        response.raise_for_status()
        
        # Get the response
        result = response.json()
        
        # Format the markdown output with detailed analysis
        markdown_output = f"""
# Supplier Recommendation

## Recommended Supplier
**Name:** {result['supplier']['name']}
**Category:** {result['supplier']['category']}
**Rating:** {result['supplier']['rating']}/5.0
**Confidence Score:** {result['confidence_score']:.0%}

## Alternative Suppliers
{chr(10).join(f"- {supplier['name']} (Rating: {supplier['rating']}/5.0)" for supplier in result['alternative_suppliers'])}

## Detailed Analysis
{result['reasoning']}
"""
        
        return {
            "markdown": markdown_output,
            "json": result  # Keep the raw JSON for debugging
        }
    except requests.exceptions.RequestException as e:
        return {
            "markdown": f"Error: Failed to get recommendation: {str(e)}",
            "json": {"error": str(e)}
        }

def get_recent_purchases(description: str, category: str = "") -> Dict[str, Any]:
    """
    Call the recent purchases API and format the response for display.
    """
    try:
        # Prepare query parameters
        params = {
            "description": description,
            "category": category if category else None,
            "months": 3  # Default to 3 months
        }
        
        # Make API call
        url = f"{API_URL}/recent-purchases"
        print(f"Making recent purchases request to: {url}")  # Debug log
        response = requests.get(url, params=params)
        print(f"Full request URL: {response.url}")  # Debug log
        response.raise_for_status()
        
        # Format response for display
        result = response.json()
        
        # Format the purchases into a readable string
        purchases_text = []
        for purchase in result["similar_purchases"]:
            purchase_date = datetime.fromisoformat(purchase["order_date"].replace("Z", "+00:00"))
            formatted_date = purchase_date.strftime("%Y-%m-%d")
            purchases_text.append(
                f"• {purchase['description']}\n"
                f"  - Quantity: {purchase['quantity']} {purchase['unit'] or 'units'}\n"
                f"  - Price: ${purchase['unit_price']} per unit\n"
                f"  - Total: ${purchase['total_price']}\n"
                f"  - Supplier: {purchase['supplier_name']}\n"
                f"  - Date: {formatted_date}\n"
                f"  - Status: {purchase['status']}\n"
            )
        
        return {
            "Total Similar Purchases": result["total_count"],
            "Average Price": f"${result['average_price']}" if result["average_price"] else "N/A",
            "Most Common Supplier": result["most_common_supplier"] or "N/A",
            "Recent Purchases": "\n".join(purchases_text) if purchases_text else "No similar purchases found"
        }
    except requests.exceptions.RequestException as e:
        return {"Error": f"Failed to get recent purchases: {str(e)}"}

def process_purchase_request(
    description: str,
    requester_name: str,
    quantity: int,
    category: str = "",
    department: str = "",
    unit: str = "",
    budget: float = None,
    urgency_level: str = "Medium"
) -> Dict[str, Any]:
    """
    Process a purchase request by getting both recommendations and recent purchases.
    """
    # Get both recommendations and recent purchases
    recommendation = get_recommendation(
        description=description,
        requester_name=requester_name,
        quantity=quantity,
        category=category,
        department=department,
        unit=unit,
        budget=budget,
        urgency_level=urgency_level
    )
    recent_purchases = get_recent_purchases(description, category)
    
    # Combine the results
    return {
        "Recommendation": recommendation,
        "Recent Purchases": recent_purchases
    }

# Create Gradio interface
with gr.Blocks(title="K-Tech Demo - Purchase Assisting Agent") as interface:
    # Logo centered at the top
    gr.Image("frontend/assets/KPMG_logo.jpg", show_label=False, height=100)
    
    gr.Markdown("# K-Tech Demo - Purchase Assisting Agent")
    gr.Markdown("Enter your purchase requirements to get supplier recommendations and recent purchase history.")
    
    with gr.Row():
        with gr.Column():
            # Required fields
            requester_name = gr.Textbox(
                label="Requester Name *",
                placeholder="Your name..."
            )
            description = gr.Textbox(
                label="Purchase Description * (example: notebook, chair etc.)",
                placeholder="Describe what you need to purchase...",
                lines=3
            )
            quantity = gr.Number(
                label="Quantity *",
                minimum=1,
                step=1
            )
            
            # Optional fields
            category = gr.Textbox(
                label="Category (optional)",
                placeholder="e.g., Electronics, Office Supplies"
            )
            department = gr.Textbox(
                label="Department (optional)",
                placeholder="e.g., IT, Finance"
            )
            unit = gr.Textbox(
                label="Unit (optional)",
                placeholder="e.g., pieces, kg, hours"
            )
            budget = gr.Number(
                label="Budget (optional)",
                minimum=0
            )
            urgency_level = gr.Dropdown(
                label="Urgency Level",
                choices=["Low", "Medium", "High"],
                value="Medium"
            )
            
            submit_btn = gr.Button("Get Recommendations & History")
        
        with gr.Column():
            with gr.Tabs():
                with gr.Tab("Recommendation"):
                    recommendation_md = gr.Markdown(label="Agent Analysis & Recommendation")
                    with gr.Accordion("Raw Response (for debugging)", open=False):
                        recommendation_json = gr.JSON(label="Raw Response")
                with gr.Tab("Recent Purchases"):
                    recent_purchases_output = gr.JSON(label="Recent Purchase History")
                with gr.Tab("Analysis Details"):
                    with gr.Accordion("Purchase Analysis", open=True):
                        analysis_md = gr.Markdown(label="Detailed Purchase Analysis")
                    with gr.Accordion("Historical Analysis", open=True):
                        history_md = gr.Markdown(label="Historical Purchase Analysis")
                    with gr.Accordion("Risk Assessment", open=True):
                        risk_md = gr.Markdown(label="Risk Analysis")
                    with gr.Accordion("Supplier Performance", open=True):
                        supplier_md = gr.Markdown(label="Supplier Performance Analysis")
                with gr.Tab("Agent Reasoning"):
                    with gr.Accordion("Live Reasoning Log", open=True):
                        reasoning_log = gr.Markdown(label="Agent's Step-by-Step Reasoning")
    
    def validate_and_update_outputs(
        description: str,
        requester_name: str,
        quantity: int,
        category: str,
        department: str,
        unit: str,
        budget: float,
        urgency_level: str
    ) -> tuple[Dict[str, Any], Dict[str, Any], Dict[str, Any], str, str, str, str, str]:
        # Validate required fields
        if not description.strip():
            raise gr.Error("Purchase Description is required")
        if not requester_name.strip():
            raise gr.Error("Requester Name is required")
        if not quantity or quantity < 1:
            raise gr.Error("Quantity must be at least 1")
            
        # Get recommendation
        recommendation = get_recommendation(
            description=description,
            requester_name=requester_name,
            quantity=quantity,
            category=category,
            department=department,
            unit=unit,
            budget=budget,
            urgency_level=urgency_level
        )
        
        # Get recent purchases
        recent_purchases = get_recent_purchases(description, category)
        
        # Extract detailed analysis sections from the recommendation
        json_data = recommendation["json"]
        
        # Format analysis sections
        analysis_text = f"""
## Purchase Analysis
**Category:** {json_data.get('category', 'N/A')}
**Confidence Score:** {json_data.get('confidence_score', 0):.0%}

### Key Specifications
{chr(10).join(f"- {spec}" for spec in json_data.get('specifications', []))}

### Requirements
{chr(10).join(f"- {req}" for req in json_data.get('requirements', []))}

### Sustainability Analysis
- Environmental Impact: {json_data.get('sustainability', {}).get('environmental_impact', 0):.0%}
- Local Sourcing Score: {json_data.get('sustainability', {}).get('local_sourcing_score', 0):.0%}
- Sustainable Practices: {', '.join(json_data.get('sustainability', {}).get('sustainable_practices', []))}

### Cost Analysis
- Estimated Unit Cost: ${json_data.get('cost_analysis', {}).get('estimated_unit_cost', 'N/A')}
- Total Cost Estimate: ${json_data.get('cost_analysis', {}).get('total_cost_estimate', 'N/A')}
- Cost Confidence: {json_data.get('cost_analysis', {}).get('cost_confidence', 0):.0%}
- Price Trend: {json_data.get('cost_analysis', {}).get('price_trend', 'N/A')}
"""

        history_text = f"""
## Historical Analysis
**Total Similar Purchases:** {json_data.get('total_purchases', 0)}
**Success Rate:** {json_data.get('success_rate', 0):.0%}
**Average Delivery Time:** {json_data.get('average_delivery_time', 'N/A')} days

### Price Trends
- Average Price: ${json_data.get('price_trend', {}).get('average_price', 'N/A')}
- Price Volatility: {json_data.get('price_trend', {}).get('price_volatility', 0):.0%}
- Price Trend: {json_data.get('price_trend', {}).get('price_trend', 'N/A')}

### Common Suppliers
{chr(10).join(f"- {supplier['name']}: {supplier['order_count']} orders, {supplier['success_rate']:.0%} success rate" 
              for supplier in json_data.get('common_suppliers', []))}

### Historical Recommendations
{chr(10).join(f"- {rec}" for rec in json_data.get('recommendations', []))}
"""

        risk_text = f"""
## Risk Assessment
### Supply Chain Risks
{chr(10).join(f"- {risk}" for risk in json_data.get('risk_assessment', {}).get('supply_chain_risks', []))}

### Quality Risks
{chr(10).join(f"- {risk}" for risk in json_data.get('risk_assessment', {}).get('quality_risks', []))}

### Compliance Risks
{chr(10).join(f"- {risk}" for risk in json_data.get('risk_assessment', {}).get('compliance_risks', []))}

### Financial Risks
{chr(10).join(f"- {risk}" for risk in json_data.get('risk_assessment', {}).get('financial_risks', []))}

### Risk Mitigation Strategies
{chr(10).join(f"- {risk}: {strategy}" for risk, strategy in json_data.get('risk_assessment', {}).get('mitigation_strategies', {}).items())}
"""

        supplier_text = f"""
## Supplier Performance Analysis
### Top Supplier Performance
**Name:** {json_data.get('supplier', {}).get('name', 'N/A')}
**Category Match:** {json_data.get('category_match_score', 0):.0%}
**Rating Score:** {json_data.get('rating_score', 0):.0%}
**Performance Score:** {json_data.get('performance_score', 0):.0%}
**Sustainability Score:** {json_data.get('sustainability_score', 0):.0%}
**Cost Score:** {json_data.get('cost_score', 0):.0%}
**Delivery Score:** {json_data.get('delivery_score', 0):.0%}
**Total Score:** {json_data.get('total_score', 0):.0%}

### Performance Reasoning
{chr(10).join(f"- {reason}" for reason in json_data.get('reasoning', []))}

### Alternative Suppliers
{chr(10).join(f"- {supplier['name']} (Rating: {supplier['rating']}/5.0)" for supplier in json_data.get('alternative_suppliers', []))}
"""
        
        # Format the reasoning log
        reasoning_log_text = f"""
# Agent Reasoning Log

## Step-by-Step Analysis
{json_data.get('reasoning_log', 'No reasoning log available')}
"""
        
        return (
            recommendation["markdown"],
            recommendation["json"],
            recent_purchases,
            analysis_text,
            history_text,
            risk_text,
            supplier_text,
            reasoning_log_text
        )
    
    submit_btn.click(
        fn=validate_and_update_outputs,
        inputs=[
            description,
            requester_name,
            quantity,
            category,
            department,
            unit,
            budget,
            urgency_level
        ],
        outputs=[
            recommendation_md,
            recommendation_json,
            recent_purchases_output,
            analysis_md,
            history_md,
            risk_md,
            supplier_md,
            reasoning_log
        ]
    )

if __name__ == "__main__":
    interface.launch(server_name="0.0.0.0", server_port=7860) 
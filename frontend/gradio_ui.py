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
    Call the recommendation API and format the response for display.
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
            "budget": str(budget) if budget else None,  # Convert to string to avoid Decimal serialization
            "urgency_level": urgency_level
        }
        
        # Make API call
        url = f"{API_URL}/recommend"
        print(f"Making recommendation request to: {url}")  # Debug log
        print(f"Request data: {json.dumps(request_data)}")  # Debug log
        response = requests.post(url, json=request_data)
        
        if response.status_code == 422:
            error_detail = response.json()
            print(f"Validation error details: {error_detail}")  # Debug log
            raise requests.exceptions.RequestException(f"Validation error: {error_detail}")
            
        response.raise_for_status()
        
        # Format response for display
        result = response.json()
        
        # Create a formatted markdown string for the reasoning
        reasoning_md = f"""
### Analysis Results

**Category:** {result["supplier"]["category"]}  
**Confidence Score:** {result["confidence_score"]:.2%}

{result["reasoning"]}

### Recommended Supplier
- **Name:** {result["supplier"]["name"]}
- **Rating:** {result["supplier"]["rating"]}/5.0

### Alternative Suppliers
{chr(10).join([f"- {s['name']} (Rating: {s['rating']}/5.0)" for s in result["alternative_suppliers"]])}
"""
        
        return {
            "markdown": reasoning_md,
            "json": result  # Keep the raw JSON for reference
        }
    except requests.exceptions.RequestException as e:
        print(f"Recommendation request failed: {str(e)}")  # Debug log
        if hasattr(e.response, 'json'):
            error_detail = e.response.json()
            print(f"Error details: {error_detail}")  # Debug log
        return {
            "markdown": f"### Error\nFailed to get recommendation: {str(e)}",
            "json": {"Error": str(e)}
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
with gr.Blocks(title="Purchase Assistant") as interface:
    # Logo centered at the top
    gr.Image("frontend/assets/KPMG_logo.jpg", show_label=False, height=100)
    
    gr.Markdown("# Purchase Assistant")
    gr.Markdown("Enter your purchase requirements to get supplier recommendations and recent purchase history.")
    
    with gr.Row():
        with gr.Column():
            # Required fields
            requester_name = gr.Textbox(
                label="Requester Name *",
                placeholder="Your name..."
            )
            description = gr.Textbox(
                label="Purchase Description *",
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
            with gr.Tab("Recommendation"):
                recommendation_md = gr.Markdown(label="Agent Analysis & Recommendation")
                recommendation_json = gr.JSON(label="Raw Response", visible=False)  # Hidden but available for debugging
            with gr.Tab("Recent Purchases"):
                recent_purchases_output = gr.JSON(label="Recent Purchase History")
    
    def validate_and_update_outputs(
        description: str,
        requester_name: str,
        quantity: int,
        category: str,
        department: str,
        unit: str,
        budget: float,
        urgency_level: str
    ) -> tuple[Dict[str, Any], Dict[str, Any], Dict[str, Any]]:
        # Validate required fields
        if not description.strip():
            raise gr.Error("Purchase Description is required")
        if not requester_name.strip():
            raise gr.Error("Requester Name is required")
        if not quantity or quantity < 1:
            raise gr.Error("Quantity must be at least 1")
            
        result = process_purchase_request(
            description=description,
            requester_name=requester_name,
            quantity=quantity,
            category=category,
            department=department,
            unit=unit,
            budget=budget,
            urgency_level=urgency_level
        )
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
        return recommendation["markdown"], recommendation["json"], result["Recent Purchases"]
    
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
        outputs=[recommendation_md, recommendation_json, recent_purchases_output]
    )

if __name__ == "__main__":
    interface.launch(server_name="0.0.0.0", server_port=7860) 
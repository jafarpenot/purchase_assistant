import gradio as gr
import requests
import json
from typing import Dict, Any, List
import os
from datetime import datetime

# Update the API_URL to use environment variable
API_URL = os.getenv("API_URL", "http://localhost:8000/api/v1")
print(f"Using API_URL: {API_URL}")  # Debug log

def get_recommendation(description: str, category: str = "", budget: float = None) -> Dict[str, Any]:
    """
    Call the recommendation API and format the response for display.
    """
    try:
        # Prepare request data
        request_data = {
            "description": description,
            "category": category if category else None,
            "budget": budget if budget else None
        }
        
        # Make API call
        url = f"{API_URL}/recommend"
        print(f"Making recommendation request to: {url}")  # Debug log
        response = requests.post(url, json=request_data)
        response.raise_for_status()
        
        # Format response for display
        result = response.json()
        return {
            "Recommended Supplier": result["supplier"]["name"],
            "Category": result["supplier"]["category"],
            "Rating": f"{result['supplier']['rating']}/5.0",
            "Confidence Score": f"{result['confidence_score']:.2%}",
            "Reasoning": result["reasoning"],
            "Alternative Suppliers": "\n".join([
                f"- {s['name']} (Rating: {s['rating']}/5.0)"
                for s in result["alternative_suppliers"]
            ])
        }
    except requests.exceptions.RequestException as e:
        print(f"Recommendation request failed: {str(e)}")  # Debug log
        return {"Error": f"Failed to get recommendation: {str(e)}"}

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

def process_purchase_request(description: str, category: str = "", budget: float = None) -> Dict[str, Any]:
    """
    Process a purchase request by getting both recommendations and recent purchases.
    """
    # Get both recommendations and recent purchases
    recommendation = get_recommendation(description, category, budget)
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
            description = gr.Textbox(
                label="Purchase Description",
                placeholder="Describe what you need to purchase...",
                lines=3
            )
            category = gr.Textbox(
                label="Category (optional)",
                placeholder="e.g., Electronics, Office Supplies"
            )
            budget = gr.Number(
                label="Budget (optional)",
            )
            submit_btn = gr.Button("Get Recommendations & History")
        
        with gr.Column():
            with gr.Tab("Recommendation"):
                recommendation_output = gr.JSON(label="Supplier Recommendation")
            with gr.Tab("Recent Purchases"):
                recent_purchases_output = gr.JSON(label="Recent Purchase History")
    
    def update_outputs(description: str, category: str, budget: float) -> tuple[Dict[str, Any], Dict[str, Any]]:
        result = process_purchase_request(description, category, budget)
        return result["Recommendation"], result["Recent Purchases"]
    
    submit_btn.click(
        fn=update_outputs,
        inputs=[description, category, budget],
        outputs=[recommendation_output, recent_purchases_output]
    )

if __name__ == "__main__":
    interface.launch(server_name="0.0.0.0", server_port=7860) 
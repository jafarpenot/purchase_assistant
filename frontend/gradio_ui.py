import gradio as gr
import requests
import json
from typing import Dict, Any
import os

# Update the API_URL to use environment variable
API_URL = os.getenv("API_URL", "http://localhost:8000")

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
        response = requests.post(f"{API_URL}/recommend", json=request_data)
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
        return {"Error": f"Failed to get recommendation: {str(e)}"}

# Create Gradio interface
with gr.Blocks(title="Purchase Assistant") as interface:
    # Logo centered at the top
    gr.Image("frontend/assets/KPMG_logo.jpg", show_label=False, height=100)
    
    gr.Markdown("# Purchase Assistant")
    gr.Markdown("Enter your purchase requirements to get supplier recommendations.")
    
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
            submit_btn = gr.Button("Get Recommendation")
        
        with gr.Column():
            output = gr.JSON(label="Recommendation Results")
    
    submit_btn.click(
        fn=get_recommendation,
        inputs=[description, category, budget],
        outputs=output
    )

if __name__ == "__main__":
    interface.launch(server_name="0.0.0.0", server_port=7860) 
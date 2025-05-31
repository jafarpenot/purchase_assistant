from typing import Dict, List, Any
import random
import logging
from datetime import datetime

logger = logging.getLogger(__name__)

class SupplierAPIConnector:
    def __init__(self):
        # Dummy supplier data for simulation
        self._suppliers = {
            "supplier1": {
                "name": "Global Electronics Ltd",
                "categories": ["Electronics", "Computer Parts"],
                "response_time": 0.5,  # seconds
                "success_rate": 0.95
            },
            "supplier2": {
                "name": "Office Solutions Pro",
                "categories": ["Office Supplies", "Furniture"],
                "response_time": 0.3,
                "success_rate": 0.98
            }
        }

    async def get_supplier_quote(self, supplier_id: str, request_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Simulate getting a quote from a supplier API.
        
        Args:
            supplier_id: Identifier for the supplier
            request_data: Dictionary containing request details
            
        Returns:
            Dictionary containing the simulated quote response
        """
        if supplier_id not in self._suppliers:
            raise ValueError(f"Unknown supplier: {supplier_id}")

        supplier = self._suppliers[supplier_id]
        
        # Simulate API call delay
        await asyncio.sleep(supplier["response_time"])
        
        # Simulate random success/failure
        if random.random() > supplier["success_rate"]:
            raise Exception("Supplier API temporarily unavailable")

        # Generate dummy quote
        return {
            "supplier_id": supplier_id,
            "supplier_name": supplier["name"],
            "quote_id": f"Q{random.randint(1000, 9999)}",
            "timestamp": datetime.utcnow().isoformat(),
            "price": round(random.uniform(100, 1000), 2),
            "delivery_time": random.randint(1, 14),
            "currency": "USD"
        }

    async def get_supplier_catalog(self, supplier_id: str) -> List[Dict[str, Any]]:
        """
        Simulate getting a supplier's product catalog.
        
        Args:
            supplier_id: Identifier for the supplier
            
        Returns:
            List of dictionaries containing product information
        """
        if supplier_id not in self._suppliers:
            raise ValueError(f"Unknown supplier: {supplier_id}")

        # Generate dummy catalog
        return [
            {
                "product_id": f"P{random.randint(100, 999)}",
                "name": f"Product {i}",
                "category": random.choice(self._suppliers[supplier_id]["categories"]),
                "price": round(random.uniform(10, 500), 2)
            }
            for i in range(5)  # Generate 5 dummy products
        ]

# Create a singleton instance
supplier_api = SupplierAPIConnector() 
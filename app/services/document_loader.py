import pandas as pd
from typing import List, Dict, Any
import logging

logger = logging.getLogger(__name__)

class DocumentLoader:
    @staticmethod
    def load_csv(file_path: str) -> List[Dict[str, Any]]:
        """
        Load and parse a CSV file into a list of dictionaries.
        
        Args:
            file_path: Path to the CSV file
            
        Returns:
            List of dictionaries containing the CSV data
        """
        try:
            df = pd.read_csv(file_path)
            return df.to_dict('records')
        except Exception as e:
            logger.error(f"Error loading CSV file {file_path}: {str(e)}")
            raise

    @staticmethod
    def load_pdf(file_path: str) -> str:
        """
        Placeholder for PDF loading functionality.
        To be implemented in the future.
        
        Args:
            file_path: Path to the PDF file
            
        Returns:
            Extracted text from the PDF
        """
        # TODO: Implement PDF loading using PyMuPDF
        raise NotImplementedError("PDF loading not yet implemented")

# Create a singleton instance
document_loader = DocumentLoader() 
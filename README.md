# Purchase Assistant

A FastAPI-based purchase recommendation system with a Gradio interface for supplier recommendations.

## Features

- FastAPI backend with async PostgreSQL database
- Gradio web interface for easy interaction
- Supplier recommendation system (stub implementation)
- Document loading support (CSV implemented, PDF placeholder)
- Dockerized deployment with docker-compose
- RESTful API endpoints for supplier and purchase history management

## Project Structure

```
purchase_assistant/
├── app/
│   ├── api/
│   │   └── endpoints.py
│   ├── models/
│   │   └── schema.py
│   └── services/
│       ├── agent.py
│       ├── api_connector.py
│       ├── db_interface.py
│       └── document_loader.py
├── frontend/
│   └── gradio_ui.py
├── db/
│   └── init.sql
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── main.py
```

## Prerequisites

- Docker and docker-compose
- Python 3.11+ (for local development)

## Getting Started

1. Clone the repository:
```bash
git clone <repository-url>
cd purchase_assistant
```

2. Start the services using docker-compose:
```bash
docker-compose up --build
```

3. Access the services:
- FastAPI backend: http://localhost:8000
- Gradio interface: http://localhost:7860
- API documentation: http://localhost:8000/docs

## API Endpoints

- `POST /api/v1/recommend`: Get supplier recommendations
- `GET /api/v1/suppliers`: List all suppliers
- `GET /api/v1/suppliers/{supplier_id}`: Get supplier details
- `GET /api/v1/purchase-history`: Get purchase history

## Development

For local development without Docker:

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Start the FastAPI server:
```bash
uvicorn main:app --reload
```

4. Start the Gradio interface:
```bash
python frontend/gradio_ui.py
```

## Environment Variables

The following environment variables are used in the application:

- `POSTGRES_USER`: PostgreSQL username
- `POSTGRES_PASSWORD`: PostgreSQL password
- `POSTGRES_DB`: PostgreSQL database name
- `POSTGRES_HOST`: PostgreSQL host
- `POSTGRES_PORT`: PostgreSQL port
- `DATABASE_URL`: Full database connection URL

These are configured in the docker-compose.yml file.

## License

MIT License 
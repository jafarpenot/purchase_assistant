# Purchase Assistant

A FastAPI-based purchase recommendation system with a Gradio interface for supplier recommendations.

## Features

- FastAPI backend with async PostgreSQL database
- Gradio web interface for easy interaction
- Supplier recommendation system
- Dockerized deployment with docker-compose
- RESTful API endpoints for supplier management

## Project Structure

```
purchase_assistant/
├── app/
│   ├── api/
│   │   └── endpoints.py      # API routes
│   ├── models/
│   │   └── schema.py        # Pydantic models
│   ├── services/
│   │   ├── agent.py         # Recommendation agent
│   │   └── db_interface.py  # Database operations
│   ├── db/
│   │   └── init_db.py       # Database initialization
│   ├── config.py            # Application settings
│   └── main.py             # FastAPI application
├── frontend/
│   └── gradio_ui.py        # Gradio interface
├── db/
│   ├── init_company.sql    # Company database schema
│   └── init_app.sql        # App database schema
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── README.md
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
uvicorn app.main:app --reload
```

4. Start the Gradio interface:
```bash
python frontend/gradio_ui.py
```

## Environment Variables

The following environment variables are configured in docker-compose.yml:

### Company Database (purchase_db)
- `COMPANY_DB_USER`: company_user
- `COMPANY_DB_PASSWORD`: company_password
- `COMPANY_DB_HOST`: company_postgres
- `COMPANY_DB_PORT`: 5432
- `COMPANY_DB_NAME`: purchase_db

### App Database (app_db)
- `APP_DB_USER`: app_user
- `APP_DB_PASSWORD`: app_password
- `APP_DB_HOST`: app_postgres
- `APP_DB_PORT`: 5432
- `APP_DB_NAME`: app_db

## License

MIT License 
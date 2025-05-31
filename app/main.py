from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.endpoints import router
from app.services.db_interface import db
import uvicorn

app = FastAPI(
    title="Purchase Assistant API",
    description="API for supplier recommendations and purchase management",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API routes
app.include_router(router, prefix="/api/v1")

@app.on_event("startup")
async def startup_event():
    """Initialize database connection on startup."""
    await db.connect()

@app.on_event("shutdown")
async def shutdown_event():
    """Close database connection on shutdown."""
    await db.disconnect()

@app.get("/")
async def root():
    """Root endpoint returning API information."""
    return {
        "name": "Purchase Assistant API",
        "version": "1.0.0",
        "status": "operational",
        "endpoints": {
            "recommend": "/api/v1/recommend",
            "suppliers": "/api/v1/suppliers",
            "purchase_history": "/api/v1/purchase-history"
        }
    }

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True) 
from fastapi import FastAPI
from app.core.app_setup import setup_app
import uvicorn


def create_app() -> FastAPI:
    """
    Creates and configures the FastAPI application.
    """
    app = FastAPI(
        title="Spotify Clone API",
        version="1.0",
        description="Backend API for Spotify Clone using FastAPI + MongoDB"
    )

    setup_app(app)  # Register routes, DB, middleware
    return app


app = create_app()


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )

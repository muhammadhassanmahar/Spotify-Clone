from fastapi import FastAPI
from app.routes import (
    auth_routes,
    user_routes,
    artist_routes,
    album_routes,
    song_routes,
    playlist_routes,
    search_routes,
    upload_routes
)
from app.middleware.error_handler import add_exception_handlers
from app.middleware.logger_middleware import LoggerMiddleware
from app.database.connection import connect_to_mongo, close_mongo_connection


def setup_app(app: FastAPI):
    """
    Setup FastAPI application:
    - Register routes
    - Register middleware
    - Connect database
    - Handle app events
    """

    # -------------------------------
    # Database Connection Events
    # -------------------------------
    @app.on_event("startup")
    async def startup_event():
        await connect_to_mongo()

    @app.on_event("shutdown")
    async def shutdown_event():
        await close_mongo_connection()

    # -------------------------------
    # Middlewares
    # -------------------------------
    app.add_middleware(LoggerMiddleware)  # Request logs

    # -------------------------------
    # Exception Handlers
    # -------------------------------
    add_exception_handlers(app)

    # -------------------------------
    # API Routes Register
    # -------------------------------
    app.include_router(auth_routes.router, prefix="/auth", tags=["Auth"])
    app.include_router(user_routes.router, prefix="/users", tags=["Users"])
    app.include_router(artist_routes.router, prefix="/artists", tags=["Artists"])
    app.include_router(album_routes.router, prefix="/albums", tags=["Albums"])
    app.include_router(song_routes.router, prefix="/songs", tags=["Songs"])
    app.include_router(playlist_routes.router, prefix="/playlists", tags=["Playlists"])
    app.include_router(search_routes.router, prefix="/search", tags=["Search"])
    app.include_router(upload_routes.router, prefix="/upload", tags=["Upload"])

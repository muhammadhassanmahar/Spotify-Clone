import os
from dotenv import load_dotenv

# Load .env file
load_dotenv()


class Settings:
    """
    Global application settings loaded from .env file
    """

    # -----------------------------
    # App Config
    # -----------------------------
    APP_NAME: str = "Spotify Clone API"
    APP_VERSION: str = "1.0"

    # -----------------------------
    # MongoDB
    # -----------------------------
    MONGO_URI: str = os.getenv("MONGO_URI", "mongodb://localhost:27017")
    DATABASE_NAME: str = os.getenv("DATABASE_NAME", "spotify_clone")

    # -----------------------------
    # JWT
    # -----------------------------
    JWT_SECRET: str = os.getenv("JWT_SECRET", "supersecret")
    JWT_ALGORITHM: str = "HS256"
    JWT_EXPIRATION_MINUTES: int = 60 * 24  # 24 hr token expiry

    # -----------------------------
    # File Uploads
    # -----------------------------
    UPLOAD_FOLDER: str = "app/storage"
    SONGS_FOLDER: str = "app/storage/songs"
    IMAGES_FOLDER: str = "app/storage/images"


# Create a single settings instance
settings = Settings()

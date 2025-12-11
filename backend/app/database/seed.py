from app.database.connection import db
from backend.app.database.collection import GENRES_COLLECTION

# Default genres for Spotify-like experience
DEFAULT_GENRES = [
    "Pop", "Rock", "Hip Hop", "Jazz", "Classical",
    "Electronic", "Lo-Fi", "Indie", "R&B", "Country"
]


async def seed_database():
    """
    Seeds initial data into the database (genres, etc.)
    Call this manually or during app startup if needed.
    """

    genre_count = await db[GENRES_COLLECTION].count_documents({})

    if genre_count == 0:
        genres = [{"name": g} for g in DEFAULT_GENRES]
        await db[GENRES_COLLECTION].insert_many(genres)
        print("✔ Default genres added.")
    else:
        print("✔ Genres already exist. Skipping seed.")

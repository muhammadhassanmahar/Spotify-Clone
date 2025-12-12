# app/controllers/dashboard_controller.py

from fastapi import HTTPException
from app.database.collection import (
    users_collection,
    artists_collection,
    albums_collection,
    songs_collection,
    playlists_collection,
    genres_collection,
    history_collection,
    liked_songs_collection,
    recent_collection,
    likes_collection
)

async def get_dashboard_stats():
    try:
        stats = {
            "total_users": await users_collection.count_documents({}),
            "total_artists": await artists_collection.count_documents({}),
            "total_albums": await albums_collection.count_documents({}),
            "total_songs": await songs_collection.count_documents({}),
            "total_playlists": await playlists_collection.count_documents({}),
            "total_genres": await genres_collection.count_documents({}),
            "total_histories": await history_collection.count_documents({}),
            "total_liked_songs": await liked_songs_collection.count_documents({}),
            "total_recent": await recent_collection.count_documents({}),
            "total_likes": await likes_collection.count_documents({}),
        }

        return stats

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

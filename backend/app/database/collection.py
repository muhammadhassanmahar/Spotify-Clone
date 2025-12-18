from motor.motor_asyncio import AsyncIOMotorClient

# ------------------------------
# MongoDB Connection
# ------------------------------
MONGO_URL = "mongodb://localhost:27017"

client = AsyncIOMotorClient(MONGO_URL)
db = client.spotify_db  # Database name

# ------------------------------
# Collection Name Constants
# ------------------------------
USERS_COLLECTION = "users"
ARTISTS_COLLECTION = "artists"
ALBUMS_COLLECTION = "albums"
SONGS_COLLECTION = "songs"
PLAYLISTS_COLLECTION = "playlists"
GENRES_COLLECTION = "genres"
HISTORY_COLLECTION = "history"
LIKED_SONGS_COLLECTION = "liked_songs"
RECENT_COLLECTION = "recent"
LIKES_COLLECTION = "likes"   # ✅ NEW

# ------------------------------
# Actual MongoDB Collection Objects
# ------------------------------
users_collection = db[USERS_COLLECTION]
artists_collection = db[ARTISTS_COLLECTION]
albums_collection = db[ALBUMS_COLLECTION]
songs_collection = db[SONGS_COLLECTION]
playlists_collection = db[PLAYLISTS_COLLECTION]
genres_collection = db[GENRES_COLLECTION]
history_collection = db[HISTORY_COLLECTION]
liked_songs_collection = db[LIKED_SONGS_COLLECTION]
recent_collection = db[RECENT_COLLECTION]
likes_collection = db[LIKES_COLLECTION]   # ✅ NEW

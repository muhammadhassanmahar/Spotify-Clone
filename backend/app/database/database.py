from motor.motor_asyncio import AsyncIOMotorClient

MONGO_URL = "mongodb://localhost:27017"

client = AsyncIOMotorClient(MONGO_URL)

db = client.spotify_db

# Collections
users_collection = db.users
artists_collection = db.artists
albums_collection = db.albums
songs_collection = db.songs
playlists_collection = db.playlists
genres_collection = db.genres
history_collection = db.history
likes_collection = db.likes
from motor.motor_asyncio import AsyncIOMotorClient

MONGO_URL = "mongodb://localhost:27017"

client = AsyncIOMotorClient(MONGO_URL)

db = client.spotify_db

# Collections
users_collection = db.users
artists_collection = db.artists
albums_collection = db.albums
songs_collection = db.songs
playlists_collection = db.playlists
genres_collection = db.genres
history_collection = db.history
likes_collection = db.likes

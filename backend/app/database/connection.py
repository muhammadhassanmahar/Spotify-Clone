from motor.motor_asyncio import AsyncIOMotorClient
from app.config.config import settings

# MongoDB client placeholder
mongo_client: AsyncIOMotorClient = None
db = None


async def connect_to_mongo():
    """
    Connect to MongoDB using Motor (async driver)
    """
    global mongo_client, db

    mongo_client = AsyncIOMotorClient(settings.MONGO_URI)
    db = mongo_client[settings.DATABASE_NAME]

    print("✔ MongoDB Connected:", settings.DATABASE_NAME)


async def close_mongo_connection():
    """
    Close MongoDB connection on app shutdown
    """
    global mongo_client

    if mongo_client:
        mongo_client.close()
        print("✖ MongoDB Connection Closed")

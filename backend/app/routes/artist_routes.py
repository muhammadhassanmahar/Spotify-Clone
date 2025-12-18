from fastapi import APIRouter, HTTPException, Request
from bson import ObjectId
from app.database import artists_collection

router = APIRouter(
    prefix="/artists",
    tags=["Artists"]
)

# ----------------------------------------
# GET ALL ARTISTS (with full URL for images)
# ----------------------------------------
@router.get("")
@router.get("/")
async def get_all_artists(request: Request):
    try:
        artists = []

        if artists_collection is None:
            return []

        async for artist in artists_collection.find():
            image_path = artist.get("image")
            if image_path:
                # Build full URL
                image_url = f"{request.base_url}{image_path}"
            else:
                image_url = None

            artists.append({
                "id": str(artist.get("_id")),
                "name": artist.get("name"),
                "image": image_url,
            })

        return artists

    except Exception as e:
        print("❌ Error fetching artists:", e)
        return []


# ----------------------------------------
# GET ARTIST BY ID (with full URL)
# ----------------------------------------
@router.get("/{artist_id}")
async def get_artist_by_id(artist_id: str, request: Request):
    try:
        if not ObjectId.is_valid(artist_id):
            raise HTTPException(status_code=400, detail="Invalid artist ID")

        if artists_collection is None:
            raise HTTPException(status_code=503, detail="Database not connected")

        artist = await artists_collection.find_one({"_id": ObjectId(artist_id)})

        if not artist:
            raise HTTPException(status_code=404, detail="Artist not found")

        image_path = artist.get("image")
        if image_path:
            image_url = f"{request.base_url}{image_path}"
        else:
            image_url = None

        return {
            "id": str(artist.get("_id")),
            "name": artist.get("name"),
            "image": image_url,
        }

    except HTTPException:
        raise
    except Exception as e:
        print("❌ Error fetching artist:", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")


# ----------------------------------------
# TEST ROUTE
# ----------------------------------------
@router.get("/test/ping")
def test_artist():
    return {"message": "Artist route working!"}

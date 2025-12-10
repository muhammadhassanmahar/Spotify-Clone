from fastapi import APIRouter

router = APIRouter(prefix="/artists", tags=["Artists"])

@router.get("/test")
def test_artist():
    return {"message": "Artist route working!"}

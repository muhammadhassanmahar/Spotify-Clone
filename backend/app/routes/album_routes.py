from fastapi import APIRouter

router = APIRouter(prefix="/albums", tags=["Albums"])

@router.get("/test")
def test_album():
    return {"message": "Album route working!"}

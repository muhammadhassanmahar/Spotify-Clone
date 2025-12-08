from fastapi import APIRouter, HTTPException
from app.schemas.genre_schema import GenreCreateSchema, GenreUpdateSchema
from app.services.genre_service import GenreService

router = APIRouter(prefix="/genres", tags=["Genres"])


# -------------------------------
# CREATE GENRE
# -------------------------------
@router.post("/create")
async def create_genre(payload: GenreCreateSchema):
    genre_id = await GenreService.create_genre(payload.dict())

    if not genre_id:
        raise HTTPException(status_code=400, detail="Genre creation failed")

    return {"message": "Genre created", "genre_id": genre_id}


# -------------------------------
# GET ALL GENRES
# -------------------------------
@router.get("/")
async def get_genres():
    genres = await GenreService.get_all_genres()
    return genres


# -------------------------------
# GET GENRE BY ID
# -------------------------------
@router.get("/{genre_id}")
async def get_genre(genre_id: str):
    genre = await GenreService.get_genre_by_id(genre_id)

    if not genre:
        raise HTTPException(status_code=404, detail="Genre not found")

    return genre


# -------------------------------
# UPDATE GENRE
# -------------------------------
@router.put("/update/{genre_id}")
async def update_genre(genre_id: str, payload: GenreUpdateSchema):
    updated = await GenreService.update_genre(
        genre_id, payload.dict(exclude_unset=True)
    )

    if not updated:
        raise HTTPException(status_code=400, detail="Update failed")

    return {"message": "Genre updated successfully"}


# -------------------------------
# DELETE GENRE
# -------------------------------
@router.delete("/delete/{genre_id}")
async def delete_genre(genre_id: str):
    deleted = await GenreService.delete_genre(genre_id)

    if not deleted:
        raise HTTPException(status_code=400, detail="Delete failed")

    return {"message": "Genre deleted successfully"}

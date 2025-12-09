from fastapi import APIRouter
from app.controllers.genre_controller import (
    create_genre,
    get_all_genres,
    update_genre,
    delete_genre,
)
from app.schemas.genre_schema import GenreCreateSchema, GenreUpdateSchema


router = APIRouter(prefix="/genres", tags=["Genres"])


# ----------------------------------------
# CREATE GENRE
# ----------------------------------------
@router.post("/")
async def create_new_genre(data: GenreCreateSchema):
    return await create_genre(data)


# ----------------------------------------
# GET ALL GENRES
# ----------------------------------------
@router.get("/")
async def fetch_all_genres():
    return await get_all_genres()


# ----------------------------------------
# UPDATE GENRE
# ----------------------------------------
@router.put("/{genre_id}")
async def modify_genre(genre_id: str, data: GenreUpdateSchema):
    return await update_genre(genre_id, data)


# ----------------------------------------
# DELETE GENRE
# ----------------------------------------
@router.delete("/{genre_id}")
async def remove_genre(genre_id: str):
    return await delete_genre(genre_id)

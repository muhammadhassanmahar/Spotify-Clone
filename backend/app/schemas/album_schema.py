from pydantic import BaseModel, Field
from typing import Optional


# ----------------------------------------
# CREATE ALBUM SCHEMA
# ----------------------------------------
class AlbumCreateSchema(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    artist_id: str
    release_year: Optional[int] = None
    cover_image: Optional[str] = None


# ----------------------------------------
# UPDATE ALBUM SCHEMA
# ----------------------------------------
class AlbumUpdateSchema(BaseModel):
    title: Optional[str] = Field(None, min_length=1, max_length=100)
    release_year: Optional[int] = None
    cover_image: Optional[str] = None

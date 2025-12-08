from pydantic import BaseModel, Field
from typing import Optional


# ----------------------------------------
# CREATE SONG SCHEMA
# ----------------------------------------
class SongCreateSchema(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    artist_id: str
    album_id: Optional[str] = None
    duration: int = Field(..., description="Song duration in seconds")
    audio_url: str
    cover_image: Optional[str] = None
    genre_id: Optional[str] = None


# ----------------------------------------
# UPDATE SONG SCHEMA
# ----------------------------------------
class SongUpdateSchema(BaseModel):
    title: Optional[str] = Field(None, min_length=1, max_length=100)
    album_id: Optional[str] = None
    duration: Optional[int] = None
    audio_url: Optional[str] = None
    cover_image: Optional[str] = None
    genre_id: Optional[str] = None

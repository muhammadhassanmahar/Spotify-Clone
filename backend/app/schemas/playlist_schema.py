from pydantic import BaseModel, Field
from typing import Optional, List


# ----------------------------------------
# CREATE PLAYLIST SCHEMA
# ----------------------------------------
class PlaylistCreateSchema(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = None
    songs: Optional[List[str]] = []
    cover_image: Optional[str] = None
    is_public: bool = False


# ----------------------------------------
# UPDATE PLAYLIST SCHEMA
# ----------------------------------------
class PlaylistUpdateSchema(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=100)
    description: Optional[str] = None
    cover_image: Optional[str] = None
    is_public: Optional[bool] = None

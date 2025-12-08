from pydantic import BaseModel, Field
from typing import Optional


# ----------------------------------------
# CREATE ARTIST SCHEMA
# ----------------------------------------
class ArtistCreateSchema(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    bio: Optional[str] = None
    image: Optional[str] = None


# ----------------------------------------
# UPDATE ARTIST SCHEMA
# ----------------------------------------
class ArtistUpdateSchema(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=100)
    bio: Optional[str] = None
    image: Optional[str] = None

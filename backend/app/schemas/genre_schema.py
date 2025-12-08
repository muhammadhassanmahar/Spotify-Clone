from pydantic import BaseModel, Field
from typing import Optional


# ----------------------------------------
# CREATE GENRE SCHEMA
# ----------------------------------------
class GenreCreateSchema(BaseModel):
    name: str = Field(..., min_length=1, max_length=50)
    description: Optional[str] = None


# ----------------------------------------
# UPDATE GENRE SCHEMA
# ----------------------------------------
class GenreUpdateSchema(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=50)
    description: Optional[str] = None

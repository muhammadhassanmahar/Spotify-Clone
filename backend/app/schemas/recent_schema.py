from pydantic import BaseModel


class RecentCreateSchema(BaseModel):
    song_id: int


class RecentResponseSchema(BaseModel):
    id: int
    user_id: int
    song_id: int
    played_at: str

    class Config:
        orm_mode = True

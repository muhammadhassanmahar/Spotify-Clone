from pydantic import BaseModel
from datetime import datetime


class RecentSong(BaseModel):
    id: str | None = None
    user_id: int
    song_id: int
    played_at: datetime | None = None

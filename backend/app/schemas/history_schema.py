from pydantic import BaseModel

# Schema used when adding a song to history
class HistoryCreateSchema(BaseModel):
    song_id: str

# Optional: Schema to return history items
class HistoryResponseSchema(BaseModel):
    id: str
    user_id: str
    song_id: str
    timestamp: str

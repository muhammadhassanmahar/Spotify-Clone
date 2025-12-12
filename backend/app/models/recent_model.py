from sqlalchemy import Column, Integer, DateTime
from sqlalchemy.sql import func
from app.database import Base


class RecentSong(Base):
    __tablename__ = "recent_songs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True, nullable=False)
    song_id = Column(Integer, index=True, nullable=False)
    played_at = Column(DateTime(timezone=True), server_default=func.now())

from sqlalchemy.future import select
from app.database import async_session
from app.models.recent_model import RecentSong


# --------------------------------------------------
# ADD SONG TO RECENT LIST (when user plays a song)
# --------------------------------------------------
async def add_recent_song(user_id: int, song_id: int):
    async with async_session() as session:
        new_row = RecentSong(
            user_id=user_id,
            song_id=song_id
        )

        session.add(new_row)
        await session.commit()
        await session.refresh(new_row)

        return {
            "id": new_row.id,
            "user_id": new_row.user_id,
            "song_id": new_row.song_id,
            "played_at": new_row.played_at
        }


# --------------------------------------------------
# GET USER'S RECENT SONG LIST
# --------------------------------------------------
async def get_recent_songs(user_id: int):
    async with async_session() as session:
        query = await session.execute(
            select(RecentSong)
            .where(RecentSong.user_id == user_id)
            .order_by(RecentSong.played_at.desc())
        )

        rows = query.scalars().all()

        return [
            {
                "id": r.id,
                "user_id": r.user_id,
                "song_id": r.song_id,
                "played_at": r.played_at
            }
            for r in rows
        ]

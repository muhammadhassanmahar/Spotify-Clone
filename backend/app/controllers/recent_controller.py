from datetime import datetime
from typing import List
from sqlalchemy.orm import Session

from app.models.recent_model import RecentItem
from app.schemas.recent_schema import RecentCreate, RecentResponse


# Fetch all recent items
def get_all_recent_items(db: Session) -> List[RecentItem]:
    return db.query(RecentItem).order_by(RecentItem.created_at.desc()).all()


# Fetch single item by ID
def get_recent_item_by_id(db: Session, item_id: int) -> RecentItem | None:
    return db.query(RecentItem).filter(RecentItem.id == item_id).first()


# Create a new recent item
def create_recent_item(db: Session, data: RecentCreate) -> RecentItem:
    new_item = RecentItem(
        title=data.title,
        artist=data.artist,
        duration=data.duration,
        created_at=datetime.utcnow()
    )
    db.add(new_item)
    db.commit()
    db.refresh(new_item)
    return new_item


# Delete a recent item
def delete_recent_item(db: Session, item_id: int) -> bool:
    item = db.query(RecentItem).filter(RecentItem.id == item_id).first()
    if not item:
        return False

    db.delete(item)
    db.commit()
    return True


# Update a recent item
def update_recent_item(db: Session, item_id: int, data: RecentCreate) -> RecentItem | None:
    item = db.query(RecentItem).filter(RecentItem.id == item_id).first()
    if not item:
        return None

    item.title = data.title
    item.artist = data.artist
    item.duration = data.duration
    db.commit()
    db.refresh(item)
    return item

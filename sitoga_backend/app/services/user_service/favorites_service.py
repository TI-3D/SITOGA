from typing import Optional
from sqlalchemy.orm import Session
from app.models.models import Favorite, Plants

def get_user_favorites(user_id: int, limit: Optional[int], db: Session):
    """
    Mengambil daftar tanaman favorit berdasarkan user_id dan limit.

    Returns:
        list: Daftar favorit dalam bentuk dictionary.
    """
    query = db.query(Favorite).join(Plants, Favorite.plant_id == Plants.plant_id).filter(Favorite.user_id == user_id)

    if limit is not None:  # Terapkan batas jika limit tidak None
        query = query.limit(limit)
    
    result = query.all()

    return [
        {
            "favorite_id": row.favorite_id,
            "user_id": row.user_id,
            "plant_id": row.plant_id,
            "plant_name": row.plant.plant_name,
            "description": row.plant.description,
            "image_path": row.plant.image_path,
            "added_at": row.added_at
        }
        for row in result
    ]

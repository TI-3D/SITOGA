from typing import Optional
from sqlalchemy.orm import Session
from app.models.models import Favorite, Plants, User
from datetime import datetime

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
            "nama_latin": row.plant.nama_latin,
            "manfaat": row.plant.manfaat,
            "image_path": row.plant.image_path,
            "added_at": row.added_at
        }
        for row in result
    ]

def add_favorite(db: Session, user_id: int, plant_id: int):
    user = db.query(User).filter(User.user_id == user_id).first()
    plant = db.query(Plants).filter(Plants.plant_id == plant_id).first()

    if not user:
        raise ValueError("User not found.")
    if not plant:
        raise ValueError("Plant not found.")

    # Cek apakah favorit sudah ada
    existing_favorite = db.query(Favorite).filter(
        Favorite.user_id == user_id,
        Favorite.plant_id == plant_id,
    ).first()

    if existing_favorite:
        raise ValueError("Favorite already exists.")

    # Tambahkan data favorite
    new_favorite = Favorite(
        user_id=user_id,
        plant_id=plant_id,
        added_at=datetime.utcnow() 
    )
    db.add(new_favorite)
    db.commit()
    db.refresh(new_favorite)

    return new_favorite

def delete_favorite(db: Session, user_id: int, plant_id: int):
    favorite = db.query(Favorite).filter(
        Favorite.user_id == user_id,
        Favorite.plant_id == plant_id
    ).first()

    if not favorite:
        raise ValueError("Favorite not found.")

    # Hapus favorite
    db.delete(favorite)
    db.commit()
    return {"message": "Favorite deleted successfully."}
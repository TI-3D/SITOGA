from typing import Optional
from app.models import models
from sqlalchemy.orm import Session
from app.models.models import History, Plants

def get_user_history(user_id: int, limit: Optional[int], db: Session):
    """
    Mengambil data riwayat pemindaian tanaman berdasarkan user_id dengan batasan limit.
    
    Returns:
        list: Daftar riwayat pemindaian berupa dictionary.
    """
    if limit is None:
        limit = 100  
    
    # Query tabel history berdasarkan user_id dengan limit
    history_records = (
        db.query(models.History)
        .filter(models.History.user_id == user_id)
        .limit(limit)
        .all()
    )

    # Ambil semua plants yang relevan untuk menghindari query berulang di dalam loop
    plant_ids = [record.plant_id for record in history_records]
    plants = db.query(Plants).filter(Plants.plant_id.in_(plant_ids)).all()
    
    # Buat dictionary untuk memetakan plant_id ke data tanaman (name, image_path, dll)
    plant_dict = {plant.plant_id: {'name': plant.plant_name, 'image_path': plant.image_path, 'description': plant.description, 'nama_latin': plant.nama_latin, 'manfaat': plant.manfaat} for plant in plants}
    
    # log = print(f"History Query: {db.query(History).filter(History.user_id == user_id).limit(limit).all()}")
    result = []
    for record in history_records:
        plant_info = plant_dict.get(record.plant_id, {})
        result.append({
            "history_id": record.history_id,
            "user_id": record.user_id,
            "plant_id": record.plant_id,
            "plant_name": plant_info.get('name', None),
            "scan_date": record.scan_date,
            "image_path": plant_info.get('image_path', None),
            "manfaat": plant_info.get('manfaat', None),
            "nama_latin": plant_info.get('nama_latin', None),
            "description": plant_info.get('description', None),
        })

    return result

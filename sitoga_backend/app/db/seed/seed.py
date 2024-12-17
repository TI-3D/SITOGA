# from sqlalchemy.orm import sessionmaker
# from sqlalchemy import create_engine

from sqlalchemy.orm import Session
from app.db.database import SessionLocal, Base, engine
from app.models.models import ScannedImage, Favorite, History
from datetime import datetime

scannedImage = [
    {'user_id':2, 'image_url':'kemangi_scan.jpeg', 'uploaded_at':datetime.now(), 'detected_plant_id':4},
    {'user_id':2, 'image_url':'Sirih_scan_1.jpeg', 'uploaded_at':datetime.now(), 'detected_plant_id':10},
]

favorite = [
    {'user_id': 2, 'plant_id': 4, 'added_at': datetime.now()},
    {'user_id': 2, 'plant_id': 10, 'added_at': datetime.now()},
]

history = [
    {'user_id':2, 'plant_id':4, 'scan_date':datetime.now(), 'image_url':'kemangi_scan.jpeg'},
    {'user_id':2, 'plant_id':10, 'scan_date':datetime.now(), 'image_url':'Sirih_scan_1.jpeg'},
]



def seed_another_data(db: Session):
    """Seeds plant data, scanned images, favorites, history, recipe, and ingredients."""

    # Seed scanned images (assuming a ScannedImage model exists)
    for scan_data in scannedImage:
        db_scan = ScannedImage(**scan_data)
        db.add(db_scan)

    # Seed favorites (assuming a Favorite model exists)
    for fav_data in favorite:
        db_fav = Favorite(**fav_data)
        db.add(db_fav)

    # Seed history (assuming a History model exists)
    for history_data in history:
        db_history = History(**history_data)
        db.add(db_history)

    db.commit()
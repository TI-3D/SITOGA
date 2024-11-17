from sqlalchemy.orm import Session
from sqlalchemy.sql import text
from app.db.database import engine ,SessionLocal
from app.models.models import Role, User, Plants, ScannedImage, Favorite, History, Recipe, Ingredients

def truncate_data(db: Session):
    
    db.execute(text("SET FOREIGN_KEY_CHECKS = 0"))
   
    db.execute(text("TRUNCATE TABLE roles"))
    db.execute(text("TRUNCATE TABLE users"))
    db.execute(text("TRUNCATE TABLE plants"))
    db.execute(text("TRUNCATE TABLE scanned_images"))
    db.execute(text("TRUNCATE TABLE favorites"))
    db.execute(text("TRUNCATE TABLE history"))
    db.execute(text("TRUNCATE TABLE recipe"))
    db.execute(text("TRUNCATE TABLE ingredients"))
    
    db.execute(text("SET FOREIGN_KEY_CHECKS = 1"))
    
    db.commit()
    print("Semua data telah dihapus dari tabel-tabel.")

if __name__ == "__main__":
    db = SessionLocal()
    try:
        truncate_data(db)
    except Exception as e:
        print(f"Error while truncating: {e}")
    finally:
        db.close()

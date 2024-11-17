from sqlalchemy.orm import Session
from app.db.database import SessionLocal, Base, engine
from app.models.models import Role, User  
from sitoga_backend.app.schemas.user_schemas import RoleBase, UserCreate
from sitoga_backend.app.crud.user_crud import create_role, create_user  
import bcrypt  
from datetime import datetime

# Contoh data awal
roles = [
    {"role_id": "0", "role_name": "Admin"},
    {"role_id": "1", "role_name": "User"},
]

users = [
    {"username": "admin", "email": "kemboet2@gmail.com", "password": "admin123", "role_id": "0"},
    {"username": "user", "email": "kemboet2@gmail.com", "password": "user123", "role_id": "1"},
]

def hash_password(password: str) -> str:
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(password.encode(), salt)
    return hashed_password.decode()

def seed_data(db: Session):

    # Menambahkan roles
    for role in roles:
        db_role = Role(**role)
        db.add(db_role)

    # Menambahkan users dengan password yang sudah di-hash
    for user in users:
        hashed_password = hash_password(user["password"])  
        user["password"] = hashed_password  
        db_user = User(**user)
        db.add(db_user)

    db.commit()

if __name__ == "__main__":
    db = SessionLocal()
    try:
        seed_data(db)
        print("Database seeded successfully!")
    except Exception as e:
        print(f"Error while seeding: {e}")
    finally:
        db.close()

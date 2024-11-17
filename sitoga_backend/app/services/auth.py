from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
from typing import Union
from app.schemas.user_schemas import Token
from app.db.database import SessionLocal

# Inisialisasi password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Secret key untuk JWT
SECRET_KEY = "S1T0G4K3Y"  # Ganti dengan secret key yang lebih aman
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Fungsi untuk meng-hash password
def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

# Fungsi untuk memverifikasi password
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

# Fungsi untuk membuat access token JWT
def create_access_token(data: dict, expires_delta: timedelta = timedelta(minutes=15)):
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

# Fungsi untuk memverifikasi token JWT
def verify_token(token: str) -> Union[dict, None]:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload if payload["exp"] >= datetime.utcnow() else None
    except JWTError:
        return None

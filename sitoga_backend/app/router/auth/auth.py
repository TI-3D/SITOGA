from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.schemas.user_schemas import UserCreate, Token, User
from app.crud.user_crud import get_user_by_username, create_user
from app.services.auth import verify_password, create_access_token
from app.db.database import get_db
from fastapi.security import OAuth2PasswordRequestForm

router = APIRouter()

@router.post("/login", response_model=Token)
def login_user(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    db_user = get_user_by_username(db, username=form_data.username)
    
    # Validasi apakah pengguna ada dan password sesuai
    if db_user is None or not verify_password(form_data.password, db_user.password): 
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    access_token = create_access_token(data={"sub": form_data.username})
    
    return {
        "message": "Login berhasil",
        "access_token": access_token,
        "token_type": "bearer",
        "user_id": db_user.user_id,
    }
    
@router.post("/register", response_model=User)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = get_user_by_username(db, username=user.username)
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    return create_user(db=db, user=user)

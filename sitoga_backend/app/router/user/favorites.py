from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Form
from sqlalchemy.orm import Session
from app.services.user_service.favorites_service import get_user_favorites
from app.db.database import get_db

router = APIRouter()

@router.post("/favorites/")
def get_favorites(user_id: int = Form(...), limit: Optional[int] = Form(None), db: Session = Depends(get_db)):
    """
    Endpoint untuk mengambil daftar favorit berdasarkan user_id dan limit.

    Returns:
        dict: Daftar favorit berupa dictionary.
    """
    try:
        favorites_data = get_user_favorites(user_id=user_id, limit=limit, db=db)

        if not favorites_data:
            raise HTTPException(status_code=404, detail="No favorites found for this user.")

        return {"status": "success", "data": favorites_data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Form
from sqlalchemy.orm import Session
from app.services.user_service.history_service import get_user_history
from app.db.database import get_db

router = APIRouter()

@router.post("/history/")
def get_history(user_id: int = Form(...), limit: Optional[int] = Form(None), db: Session = Depends(get_db)):
    """
    Endpoint untuk mengambil data riwayat pemindaian berdasarkan user_id dan limit.

    Returns:
        dict: Daftar riwayat pemindaian berupa dictionary.
    """
    try:
        history_data = get_user_history(user_id=user_id, limit=limit, db=db)

        if not history_data:
            raise HTTPException(status_code=404, detail="No history found for this user.")

        return {"status": "success", "data": history_data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

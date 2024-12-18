from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Form, status
from sqlalchemy.orm import Session
from app.services.user_service.favorites_service import get_user_favorites, add_favorite, delete_favorite
from app.db.database import get_db
from app.schemas.user_schemas import FavoriteBase


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

@router.post("/favorite/add", status_code=status.HTTP_201_CREATED)
def add_favorite_route(request: FavoriteBase, db: Session = Depends(get_db)):
    try:
        favorite = add_favorite(db, user_id=request.user_id, plant_id=request.plant_id)
        return {"message": "Favorite added successfully.", "favorite": favorite}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/favorite/delete", status_code=status.HTTP_200_OK)
def delete_favorite_route(
    user_id: int = Form(...),  # menerima user_id dari form sebagai int
    plant_id: int = Form(...),  # menerima plant_id dari form sebagai int
    db: Session = Depends(get_db)
):
    try:
        result = delete_favorite(db, user_id=user_id, plant_id=plant_id)
        return {"status": "success", "message": "Favorite deleted successfully."}
    except ValueError as e:
        raise HTTPException(status_code=404, detail="Invalid ID format")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
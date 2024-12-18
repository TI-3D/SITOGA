from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.services.user_service.recipes_service import get_all_recipes_with_ingredients

router = APIRouter()

@router.get("/recipes")
def get_recipes(db: Session = Depends(get_db)):
    """
    Endpoint untuk mengambil semua data resep beserta bahan-bahannya.

    Returns:
        dict: Daftar resep dan bahan-bahannya.
    """
    try:
        recipes = get_all_recipes_with_ingredients(db)
        if not recipes:
            raise HTTPException(status_code=404, detail="No recipes found.")
        return {"status": "success", "data": recipes}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
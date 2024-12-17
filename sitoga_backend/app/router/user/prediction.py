from fastapi import APIRouter, File, Form, UploadFile, HTTPException, Depends
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.services.user_service.prediction_service import predict_image
import os
import shutil
from datetime import datetime

UPLOAD_DIR = "app/uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

router = APIRouter()

@router.post("/predict/")
async def predict(file: UploadFile = File(...), user_id: int = Form(...), db: Session = Depends(get_db)):
    """
    Endpoint untuk memprediksi gambar.
    Argumen:
    - file: file gambar yang diunggah
    - user_id: ID pengguna
    - db: sesi database
    """
    try:
        # Simpan file yang diunggah
        file_path = os.path.join(UPLOAD_DIR, f"{datetime.utcnow().timestamp()}_{file.filename}")
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        result = predict_image(image_path=file_path, user_id=user_id, db=db)

        os.remove(file_path)

        return {
            "success": True,
            "data": result,
            "user_id": user_id
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

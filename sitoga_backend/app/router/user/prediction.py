from fastapi import APIRouter, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse
from app.services.user_service.prediction_service import predict_plant

router = APIRouter()

@router.post("/predict/")
async def predict(file: UploadFile = File(...)):
    try:
        image_data = await file.read()
        prediction = predict_plant(image_data)
        return JSONResponse(content=prediction)
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=500)
        

from fastapi import FastAPI, Request
from app.router.user import prediction
from app.router.globals.db import router as db_router
from fastapi.responses import JSONResponse
import os 
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'

app = FastAPI()

@app.exception_handler(Exception)
async def custom_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "detail": str(exc)
        },
    )
    
#global
app.include_router(db_router, prefix="/db", tags=["db"])
#auth

#user
app.include_router(prediction.router, prefix="/predict", tags=["prediction"])

#admin

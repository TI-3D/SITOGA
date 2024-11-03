from fastapi import FastAPI, Request
from app.api.api_v1.endpoints import prediction
from fastapi.responses import JSONResponse

app = FastAPI()

@app.exception_handler(Exception)
async def custom_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "detail": str(exc)
        },
    )

app.include_router(prediction.router, prefix="/predict", tags=["prediction"])

# @app.get("/")
# async def root():
#     return {"message": "Hello World"}
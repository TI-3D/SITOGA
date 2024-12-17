from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from app.router.user import prediction
from app.router.globals.db import router as db_router
from app.router.auth.auth import router as auth_router
from app.router.user.favorites import router as favorite_router
from app.router.user.history import router as history_router

from app.db.seed import seed, user_seed, plant_seed, recipe_seed, ingredients_seed
from app.models.models import Role, User, Plants, ScannedImage, Favorite, History, Recipe, Ingredients
from fastapi.responses import JSONResponse
import os 
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'

app = FastAPI()

# Menambahkan middleware CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Mengizinkan semua origin, bisa diganti dengan domain tertentu
    allow_credentials=True,
    allow_methods=["*"],  # Mengizinkan semua metode HTTP
    allow_headers=["*"],  # Mengizinkan semua header
)

@app.exception_handler(Exception)
async def custom_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "detail": str(exc)
        },
    )
    
# Include routers
app.include_router(db_router, prefix="/db", tags=["db"])
app.include_router(auth_router, prefix="/auth", tags=["auth"])
app.include_router(prediction.router, prefix="/predict", tags=["prediction"])
app.include_router(history_router, prefix="/history", tags=["History"])
app.include_router(favorite_router, prefix="/favorite", tags=["Favorites"])

# Seeder
@app.on_event("startup")
async def startup_event():
    try:
        from app.db.database import SessionLocal
        with SessionLocal() as db:
            if not db.query(User).first():
                user_seed.seed_role_and_user(db)
            
            if not db.query(Plants).first():
                plant_seed.seed_plants_data(db)

            if not db.query(ScannedImage).first():
                seed.seed_another_data(db)
            
            if not db.query(Recipe).first():
                recipe_seed.seed_recipe_data(db)
                
            if not db.query(Ingredients).first():
                ingredients_seed.seed_ingridient_data(db)
            print("Database seeded successfully!")
    except Exception as e:
        print(f"Error while seeding: {e}")
    finally:
        db.close()

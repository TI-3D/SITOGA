from fastapi import FastAPI, Request, Depends, HTTPException
from app.api.api_v1.endpoints import prediction
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from typing import List

# Import your local modules
from app import schemas, models, crud
from app.database import SessionLocal, engine

# Create tables if they don't exist
models.Base.metadata.create_all(bind=engine)

# Create FastAPI app
app = FastAPI()

# Handle Machine Learning
@app.exception_handler(Exception)
async def custom_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "detail": str(exc)
        },
    )

app.include_router(prediction.router, prefix="/predict", tags=["prediction"])


# Dependency to get database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Role Endpoints
@app.post("/roles/", response_model=schemas.RoleBase)
def create_role(role: schemas.RoleBase, db: Session = Depends(get_db)):
    return crud.create_role(db=db, role=role)

@app.get("/roles/", response_model=List[schemas.RoleBase])
def read_roles(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    roles = crud.get_roles(db, skip=skip, limit=limit)
    return roles

# User Endpoints
@app.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    return crud.create_user(db=db, user=user)

@app.get("/users/", response_model=List[schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users

# Plant Endpoints
@app.post("/plants/", response_model=schemas.Plant)
def create_plant(plant: schemas.PlantBase, db: Session = Depends(get_db)):
    return crud.create_plant(db=db, plant=plant)

@app.get("/plants/", response_model=List[schemas.Plant])
def read_plants(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    plants = crud.get_plants(db, skip=skip, limit=limit)
    return plants

# Scanned Image Endpoints
@app.post("/scanned-images/", response_model=schemas.ScannedImage)
def create_scanned_image(scanned_image: schemas.ScannedImageBase, db: Session = Depends(get_db)):
    return crud.create_scanned_image(db=db, scanned_image=scanned_image)

@app.get("/scanned-images/", response_model=List[schemas.ScannedImage])
def read_scanned_images(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    scanned_images = crud.get_scanned_images(db, skip=skip, limit=limit)
    return scanned_images

# Favorite Endpoints
@app.post("/favorites/", response_model=schemas.Favorite)
def create_favorite(favorite: schemas.FavoriteBase, db: Session = Depends(get_db)):
    return crud.create_favorite(db=db, favorite=favorite)

@app.get("/favorites/", response_model=List[schemas.Favorite])
def read_favorites(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    favorites = crud.get_favorites(db, skip=skip, limit=limit)
    return favorites

# History Endpoints
@app.post("/history/", response_model=schemas.History)
def create_history(history: schemas.HistoryBase, db: Session = Depends(get_db)):
    return crud.create_history(db=db, history=history)

@app.get("/history/", response_model=List[schemas.History])
def read_history(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    history = crud.get_history(db, skip=skip, limit=limit)
    return history

# Recipe Endpoints
@app.post("/recipes/", response_model=schemas.Recipe)
def create_recipe(recipe: schemas.RecipeBase, db: Session = Depends(get_db)):
    return crud.create_recipe(db=db, recipe=recipe)

@app.get("/recipes/", response_model=List[schemas.Recipe])
def read_recipes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    recipes = crud.get_recipes(db, skip=skip, limit=limit)
    return recipes

# Ingredients Endpoints
@app.post("/ingredients/", response_model=schemas.Ingredients)
def create_ingredients(ingredients: schemas.IngredientsBase, db: Session = Depends(get_db)):
    return crud.create_ingredients(db=db, ingredients=ingredients)

@app.get("/ingredients/", response_model=List[schemas.Ingredients])
def read_ingredients(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    ingredients = crud.get_ingredients(db, skip=skip, limit=limit)
    return ingredients
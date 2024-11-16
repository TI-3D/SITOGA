from fastapi import APIRouter, File, UploadFile, HTTPException, Request, Depends
from fastapi.responses import JSONResponse
from app.models import models
from app.schemas import schemas
from sqlalchemy.orm import Session
from app.crud.crud import get_db
from app.crud import crud
from typing import List

router = APIRouter()

# Role Endpoints
@router.post("/roles/", response_model=schemas.RoleBase)
def create_role(role: schemas.RoleBase, db: Session = Depends(get_db)):
    return crud.create_role(db=db, role=role)

@router.get("/roles/", response_model=List[schemas.RoleBase])
def read_roles(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    roles = crud.get_roles(db, skip=skip, limit=limit)
    return roles

# User Endpoints
@router.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    return crud.create_user(db=db, user=user)

@router.get("/users/", response_model=List[schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users

# Plant Endpoints
@router.post("/plants/", response_model=schemas.Plant)
def create_plant(plant: schemas.PlantBase, db: Session = Depends(get_db)):
    return crud.create_plant(db=db, plant=plant)

@router.get("/plants/", response_model=List[schemas.Plant])
def read_plants(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    plants = crud.get_plants(db, skip=skip, limit=limit)
    return plants

# Scanned Image Endpoints
@router.post("/scanned-images/", response_model=schemas.ScannedImage)
def create_scanned_image(scanned_image: schemas.ScannedImageBase, db: Session = Depends(get_db)):
    return crud.create_scanned_image(db=db, scanned_image=scanned_image)

@router.get("/scanned-images/", response_model=List[schemas.ScannedImage])
def read_scanned_images(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    scanned_images = crud.get_scanned_images(db, skip=skip, limit=limit)
    return scanned_images

# Favorite Endpoints
@router.post("/favorites/", response_model=schemas.Favorite)
def create_favorite(favorite: schemas.FavoriteBase, db: Session = Depends(get_db)):
    return crud.create_favorite(db=db, favorite=favorite)

@router.get("/favorites/", response_model=List[schemas.Favorite])
def read_favorites(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    favorites = crud.get_favorites(db, skip=skip, limit=limit)
    return favorites

# History Endpoints
@router.post("/history/", response_model=schemas.History)
def create_history(history: schemas.HistoryBase, db: Session = Depends(get_db)):
    return crud.create_history(db=db, history=history)

@router.get("/history/", response_model=List[schemas.History])
def read_history(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    history = crud.get_history(db, skip=skip, limit=limit)
    return history

# Recipe Endpoints
@router.post("/recipes/", response_model=schemas.Recipe)
def create_recipe(recipe: schemas.RecipeBase, db: Session = Depends(get_db)):
    return crud.create_recipe(db=db, recipe=recipe)

@router.get("/recipes/", response_model=List[schemas.Recipe])
def read_recipes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    recipes = crud.get_recipes(db, skip=skip, limit=limit)
    return recipes

# Ingredients Endpoints
@router.post("/ingredients/", response_model=schemas.Ingredients)
def create_ingredients(ingredients: schemas.IngredientsBase, db: Session = Depends(get_db)):
    return crud.create_ingredients(db=db, ingredients=ingredients)

@router.get("/ingredients/", response_model=List[schemas.Ingredients])
def read_ingredients(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    ingredients = crud.get_ingredients(db, skip=skip, limit=limit)
    return ingredients
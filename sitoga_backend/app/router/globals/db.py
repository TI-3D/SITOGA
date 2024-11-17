from fastapi import APIRouter, File, UploadFile, HTTPException, Request, Depends
from fastapi.responses import JSONResponse
from app.models import models
from app.schemas import user_schemas
from sqlalchemy.orm import Session
from app.crud.user_crud import get_db
from app.crud import user_crud
from typing import List

router = APIRouter()

# Role Endpoints
@router.post("/roles/", response_model=user_schemas.RoleBase)
def create_role(role: user_schemas.RoleBase, db: Session = Depends(get_db)):
    return user_crud.create_role(db=db, role=role)

@router.get("/roles/", response_model=List[user_schemas.RoleBase])
def read_roles(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    roles = user_crud.get_roles(db, skip=skip, limit=limit)
    return roles

# User Endpoints
@router.post("/users/", response_model=user_schemas.User)
def create_user(user: user_schemas.UserCreate, db: Session = Depends(get_db)):
    return user_crud.create_user(db=db, user=user)

@router.get("/users/", response_model=List[user_schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = user_crud.get_users(db, skip=skip, limit=limit)
    return users

# Plant Endpoints
@router.post("/plants/", response_model=user_schemas.Plant)
def create_plant(plant: user_schemas.PlantBase, db: Session = Depends(get_db)):
    return user_crud.create_plant(db=db, plant=plant)

@router.get("/plants/", response_model=List[user_schemas.Plant])
def read_plants(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    plants = user_crud.get_plants(db, skip=skip, limit=limit)
    return plants

# Scanned Image Endpoints
@router.post("/scanned-images/", response_model=user_schemas.ScannedImage)
def create_scanned_image(scanned_image: user_schemas.ScannedImageBase, db: Session = Depends(get_db)):
    return user_crud.create_scanned_image(db=db, scanned_image=scanned_image)

@router.get("/scanned-images/", response_model=List[user_schemas.ScannedImage])
def read_scanned_images(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    scanned_images = user_crud.get_scanned_images(db, skip=skip, limit=limit)
    return scanned_images

# Favorite Endpoints
@router.post("/favorites/", response_model=user_schemas.Favorite)
def create_favorite(favorite: user_schemas.FavoriteBase, db: Session = Depends(get_db)):
    return user_crud.create_favorite(db=db, favorite=favorite)

@router.get("/favorites/", response_model=List[user_schemas.Favorite])
def read_favorites(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    favorites = user_crud.get_favorites(db, skip=skip, limit=limit)
    return favorites

# History Endpoints
@router.post("/history/", response_model=user_schemas.History)
def create_history(history: user_schemas.HistoryBase, db: Session = Depends(get_db)):
    return user_crud.create_history(db=db, history=history)

@router.get("/history/", response_model=List[user_schemas.History])
def read_history(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    history = user_crud.get_history(db, skip=skip, limit=limit)
    return history

# Recipe Endpoints
@router.post("/recipes/", response_model=user_schemas.Recipe)
def create_recipe(recipe: user_schemas.RecipeBase, db: Session = Depends(get_db)):
    return user_crud.create_recipe(db=db, recipe=recipe)

@router.get("/recipes/", response_model=List[user_schemas.Recipe])
def read_recipes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    recipes = user_crud.get_recipes(db, skip=skip, limit=limit)
    return recipes

# Ingredients Endpoints
@router.post("/ingredients/", response_model=user_schemas.Ingredients)
def create_ingredients(ingredients: user_schemas.IngredientsBase, db: Session = Depends(get_db)):
    return user_crud.create_ingredients(db=db, ingredients=ingredients)

@router.get("/ingredients/", response_model=List[user_schemas.Ingredients])
def read_ingredients(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    ingredients = user_crud.get_ingredients(db, skip=skip, limit=limit)
    return ingredients
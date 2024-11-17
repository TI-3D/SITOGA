from app.models import models
from sqlalchemy.orm import Session
from app.db.database import SessionLocal
from app.schemas import user_schemas 
from app.services.auth import get_password_hash
from app.db.database import get_db

# CRUD operations for Role
def create_role(db: Session, role: user_schemas.RoleBase):
    db_role = models.Role(**role.dict())
    db.add(db_role)
    db.commit()
    db.refresh(db_role)
    return db_role

def get_role(db: Session, role_id: str):
    return db.query(models.Role).filter(models.Role.role_id == role_id).first()

def get_roles(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Role).offset(skip).limit(limit).all()

# CRUD operations for User
def create_user(db: Session, user: user_schemas.UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = models.User(username=user.username, email=user.email, hashed_password=hashed_password, role_id="1")
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_user_by_username(db: Session, username: str):
    return db.query(models.User).filter(models.User.username == username).first()

def get_user_by_username(db: Session, username: str):
    return db.query(models.User).filter(models.User.username == username).first()

def get_users(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.User).offset(skip).limit(limit).all()

# CRUD operations for Plants
def create_plant(db: Session, plant: user_schemas.PlantBase):
    db_plant = models.Plants(**plant.dict())
    db.add(db_plant)
    db.commit()
    db.refresh(db_plant)
    return db_plant

def get_plant(db: Session, plant_id: int):
    return db.query(models.Plants).filter(models.Plants.plant_id == plant_id).first()

def get_plants(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Plants).offset(skip).limit(limit).all()

# CRUD operations for Scanned Images
def create_scanned_image(db: Session, scanned_image: user_schemas.ScannedImageBase):
    db_image = models.ScannedImage(**scanned_image.dict())
    db.add(db_image)
    db.commit()
    db.refresh(db_image)
    return db_image

def get_scanned_image(db: Session, image_id: int):
    return db.query(models.ScannedImage).filter(models.ScannedImage.image_id == image_id).first()

def get_scanned_images(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.ScannedImage).offset(skip).limit(limit).all()

# CRUD operations for Favorite
def create_favorite(db: Session, favorite: user_schemas.FavoriteBase):
    db_favorite = models.Favorite(**favorite.dict())
    db.add(db_favorite)
    db.commit()
    db.refresh(db_favorite)
    return db_favorite

def get_favorite(db: Session, favorite_id: int):
    return db.query(models.Favorite).filter(models.Favorite.favorite_id == favorite_id).first()

def get_favorites(db: Session, user_id: int, skip: int = 0, limit: int = 10):
    return db.query(models.Favorite).filter(models.Favorite.user_id == user_id).offset(skip).limit(limit).all()

# CRUD operations for History
def create_history(db: Session, history: user_schemas.HistoryBase):
    db_history = models.History(**history.dict())
    db.add(db_history)
    db.commit()
    db.refresh(db_history)
    return db_history

def get_history(db: Session, history_id: int):
    return db.query(models.History).filter(models.History.history_id == history_id).first()

def get_histories(db: Session, user_id: int, skip: int = 0, limit: int = 10):
    return db.query(models.History).filter(models.History.user_id == user_id).offset(skip).limit(limit).all()

# CRUD operations for Recipe
def create_recipe(db: Session, recipe: user_schemas.RecipeBase):
    db_recipe = models.Recipe(**recipe.dict())
    db.add(db_recipe)
    db.commit()
    db.refresh(db_recipe)
    return db_recipe

def get_recipe(db: Session, recipe_id: int):
    return db.query(models.Recipe).filter(models.Recipe.recipe_id == recipe_id).first()

def get_recipes(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.Recipe).offset(skip).limit(limit).all()

# CRUD operations for Ingredients
def create_ingredient(db: Session, ingredient: user_schemas.IngredientsBase):
    db_ingredient = models.Ingredients(**ingredient.dict())
    db.add(db_ingredient)
    db.commit()
    db.refresh(db_ingredient)
    return db_ingredient

def get_ingredient(db : Session, ingredient_id: int):
    return db.query(models.Ingredients).filter(models.Ingredients.ingredient_id == ingredient_id).first()

def get_ingredients(db: Session, recipe_id: int, skip: int = 0, limit: int = 10):
    return db.query(models.Ingredients).filter(models.Ingredients.recipe_id == recipe_id).offset(skip).limit(limit).all()
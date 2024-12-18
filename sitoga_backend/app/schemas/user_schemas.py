from pydantic import BaseModel
from datetime import datetime
# from typing import Optional, List

# Role Schema
class RoleBase(BaseModel):
    role_id: int
    role_name: str

    class Config:
        from_attributes = True

# User Schema
class UserBase(BaseModel):
    username: str
    email: str
    role_id: int

class UserCreate(UserBase):
    password: str

class User(UserBase):
    user_id: int
    role_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str
    message: str
    user_id: int
    
# Plants Schema
class PlantBase(BaseModel):
    plant_name: str
    nama_latin: str
    description: str
    manfaat: str
    image_path: str

class Plant(PlantBase):
    plant_id: int

    class Config:
        from_attributes = True

# Scanned Image Schema
class ScannedImageBase(BaseModel):
    user_id: int
    image_url: str
    detected_plant_id: int

class ScannedImage(ScannedImageBase):
    image_id: int
    uploaded_at: datetime

    class Config:
        from_attributes = True

# Favorite Schema
class FavoriteBase(BaseModel):
    user_id: int
    plant_id: int

class Favorite(FavoriteBase):
    favorite_id: int
    added_at: datetime

    class Config:
        from_attributes = True

# History Schema
class HistoryBase(BaseModel):
    user_id: int
    plant_id: int
    image_url: str

class History(HistoryBase):
    history_id: int
    scan_date: datetime

    class Config:
        from_attributes = True

# Recipe Schema
class RecipeBase(BaseModel):
    recipe_name: str
    instructions: str

class Recipe(RecipeBase):
    recipe_id: int

    class Config:
        from_attributes = True

# Ingredients Schema
class IngredientsBase(BaseModel):
    recipe_id: int
    plant_id: int
    quantity: str

class Ingredients(IngredientsBase):
    ingredient_id: int

    class Config:
        from_attributes = True
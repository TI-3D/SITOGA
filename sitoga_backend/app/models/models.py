from sqlalchemy import create_engine, Column, Integer, String, Enum, DateTime, Text, ForeignKey, func
from sqlalchemy.orm import relationship
from app.db.database import Base, engine
from sqlalchemy.ext.declarative import declarative_base

# Membuat struktur model / tabel database SITOGA_DB
Base = declarative_base()

# Role
class Role(Base):
    __tablename__ = "roles"
    role_id = Column(Enum('0', '1'), primary_key=True)
    role_name = Column(String(50))

# Users
class User(Base):
    __tablename__ = "users"
    user_id = Column(Integer, primary_key=True)
    username = Column(String(100))
    password = Column(String(255))
    email = Column(String(100))
    role_id = Column(Enum('0', '1'), ForeignKey('roles.role_id'))
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())
    
    histories = relationship("History", back_populates="user")

# Plants
class Plants(Base):
    __tablename__ = "plants"
    plant_id = Column(Integer, primary_key=True)
    plant_name = Column(String(100))
    nama_latin = Column(String(100))
    description = Column(Text)
    manfaat = Column(Text)
    image_path = Column(Text)

    # Relasi ke Favorite dan History
    favorites = relationship("Favorite", back_populates="plant")
    histories = relationship("History", back_populates="plant")
    ingredients = relationship("Ingredients", back_populates="plant")

# Scanned Images
class ScannedImage(Base):
    __tablename__ = "scanned_images"
    image_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.user_id'))
    image_url = Column(String(255))
    uploaded_at = Column(DateTime)
    detected_plant_id = Column(Integer, ForeignKey('plants.plant_id'))

# Favorite
class Favorite(Base):
    __tablename__ = "favorites"
    favorite_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.user_id'))
    plant_id = Column(Integer, ForeignKey('plants.plant_id'))
    added_at = Column(DateTime)
    
    # Relasi ke Plants
    plant = relationship("Plants", back_populates="favorites")

# History
class History(Base):
    __tablename__ = "history"
    history_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.user_id'))
    plant_id = Column(Integer, ForeignKey('plants.plant_id'))
    scan_date = Column(DateTime)
    image_url = Column(String(255))
    
    # Relasi ke Plants
    plant = relationship("Plants", back_populates="histories")

    # Relasi ke User
    user = relationship("User", back_populates="histories")
# Recipe
class Recipe(Base):
    __tablename__ = "recipe"
    recipe_id = Column(Integer, primary_key=True)
    recipe_name = Column(String(100))
    instructions = Column(Text)

    ingredients = relationship("Ingredients", back_populates="recipe")
# Ingredients
class Ingredients(Base):
    __tablename__ = "ingredients"
    ingredient_id = Column(Integer, primary_key=True)
    recipe_id = Column(Integer, ForeignKey('recipe.recipe_id'))
    plant_id = Column(Integer, ForeignKey('plants.plant_id'))
    quantity = Column(String(50))

    plant = relationship("Plants", back_populates="ingredients")
    recipe = relationship("Recipe", back_populates="ingredients")
# Create the database tables
Base.metadata.create_all(bind=engine)
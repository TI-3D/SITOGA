from sqlalchemy import create_engine, Column, Integer, String, Enum, DateTime, Text, ForeignKey
# from sqlalchemy.orm import relationship

from ..db.database import Base, engine

# Membuat struktur model / tabel database SITOGA_DB

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
    created_at = Column(DateTime)
    updated_at = Column(DateTime)

# Plants
class Plants(Base):
    __tablename__ = "plants"
    plant_id = Column(Integer, primary_key=True)
    plant_name = Column(String(100))
    description = Column(Text)


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

# History
class History(Base):
    __tablename__ = "history"
    history_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.user_id'))
    plant_id = Column(Integer, ForeignKey('plants.plant_id'))
    scan_date = Column(DateTime)
    image_url = Column(String(255))

# Recipe
class Recipe(Base):
    __tablename__ = "recipe"
    recipe_id = Column(Integer, primary_key=True)
    recipe_name = Column(String(100))
    instructions = Column(Text)

# Ingredients
class Ingredients(Base):
    __tablename__ = "ingredients"
    ingredient_id = Column(Integer, primary_key=True)
    recipe_id = Column(Integer, ForeignKey('recipe.recipe_id'))
    plant_id = Column(Integer, ForeignKey('plants.plant_id'))
    quantity = Column(String(50))


# Create the database tables
Base.metadata.create_all(bind=engine)

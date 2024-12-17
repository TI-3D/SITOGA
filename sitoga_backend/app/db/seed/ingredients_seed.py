from sqlalchemy.orm import Session
from app.db.database import SessionLocal, Base, engine
from app.models.models import Ingredients

# Recipe jika tidak dibutuhkan Gemini
ingredients = [
    {'recipe_id': 1, 'plant_id': 10, 'quantity': 'Fresh betel leaves, Water, Honey (optional)'}
]

# Recipe jika butuh, maka kosongan
# recipe = [{}]
# ingredients = [{}]

def seed_ingridient_data(db: Session):

    # Seed ingredients (assuming a Recipe model and Ingredient model exist)
    for ingredient_data in ingredients:
        db_ingredient = Ingredients(**ingredient_data)
        db.add(db_ingredient)

    db.commit()
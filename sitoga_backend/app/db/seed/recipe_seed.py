from sqlalchemy.orm import Session
from app.db.database import SessionLocal, Base, engine
from app.models.models import Recipe

# Recipe jika tidak dibutuhkan Gemini
recipe = [
    {'recipe_name': 'Betel Leaf Tea (Teh Daun Sirih)', 'instructions': 'Wash the betel leaves thoroughly, Boil the leaves in water for about 10 minutes, Strain the tea and add honey to taste.'},
]

# Recipe jika butuh, maka kosongan
# recipe = [{}]
# ingredients = [{}]

def seed_recipe_data(db: Session):

    # Seed recipe
    for recipe_data in recipe:
        db_recipe = Recipe(**recipe_data)
        db.add(db_recipe)

    db.commit()
from sqlalchemy.orm import Session
from app.models.models import Recipe, Ingredients, Plants

def get_all_recipes_with_ingredients(db: Session):
    """
    Mengambil semua data resep beserta bahan-bahannya.

    Returns:
        list: Daftar resep dengan bahan-bahannya dalam bentuk dictionary.
    """
    # Query semua resep
    recipes = db.query(Recipe).all()

    # Format hasil dengan bahan-bahan
    result = []
    for recipe in recipes:
        # Ambil bahan-bahan yang terkait dengan resep ini
        ingredients = (
            db.query(Ingredients)
            .join(Plants, Ingredients.plant_id == Plants.plant_id)
            .filter(Ingredients.recipe_id == recipe.recipe_id)
            .all()
        )

        # Format data bahan
        ingredients_data = [
            {
                "ingredient_id": ingredient.ingredient_id,
                "plant_id": ingredient.plant_id,
                "plant_name": ingredient.plant.plant_name,
                "quantity": ingredient.quantity
            }
            for ingredient in ingredients
        ]

        # Tambahkan data resep ke hasil
        result.append({
            "recipe_id": recipe.recipe_id,
            "recipe_name": recipe.recipe_name,
            "instructions": recipe.instructions,
            "ingredients": ingredients_data
        })

    return result
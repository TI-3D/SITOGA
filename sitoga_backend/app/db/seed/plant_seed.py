from sqlalchemy.orm import Session
from app.db.database import SessionLocal, Base, engine
from app.models.models import Plants

# Data
plants = [
    {
        "plant_name": "Belimbing Wuluh",
        "description": "Belimbing wuluh, also known as cucumber tree, is a tropical fruit-bearing tree native to the Malay Archipelago. Its small, oblong fruits have a unique, tart flavor, often compared to a blend of lime and cucumber. The tree can grow up to 10 meters tall and is widely used in Southeast Asian cuisine, especially in curries, salads, and pickles.",
        "image_path": "assets/belimbing_wuluh.jpg"
    },
    {
        "plant_name": "Jambu Biji",
        "description": "Jambu biji, or guava, is a tropical fruit tree native to Mexico and Central America. Its fruits are known for their sweet and slightly acidic taste, and soft, aromatic flesh. They can be round or oval, with a thin, edible skin that ranges from green to yellow or pink. Jambu biji is rich in vitamins C and A, as well as dietary fiber, making it a popular and nutritious fruit.",
        "image_path": "assets/jambu_biji.jpg"
    },
    {
        "plant_name": "Jeruk Nipis",
        "description": "Jeruk nipis, or lime, is a small, citrus fruit with a sour taste. It is commonly used in both culinary and non-culinary applications. The fruit is oval or round, with a thin, aromatic rind. Lime juice is highly acidic and rich in vitamin C, making it a key ingredient in many cuisines around the world, especially in Southeast Asian and Latin American dishes.",
        "image_path": "assets/jeruk_nipis.jpg"
    },
    {
        "plant_name": "Kemangi",
        "description": "Kemangi, or basil, is an aromatic herb with a distinctive sweet, slightly spicy flavor. It is a popular ingredient in many cuisines, particularly Italian cooking. Basil plants typically grow to be about 1 to 2 feet tall and have green, oval-shaped leaves. The leaves are often used fresh in salads, sauces, and pestos, while the dried leaves can be used as a seasoning.",
        "image_path": "assets/kemangi.jpg"
    },
    {
        "plant_name": "Lidah Buaya",
        "description": "Lidah buaya, or aloe vera, is a succulent plant native to the Arabian Peninsula. It is known for its thick, fleshy leaves containing a clear gel. This gel has been used for centuries for its medicinal and cosmetic properties, such as soothing skin irritations and promoting healing.",
        "image_path": "assets/lidah_buaya.jpg"
    },
    {
        "plant_name": "Nangka",
        "description": "Nangka, or jackfruit, is a tropical fruit tree native to South and Southeast Asia. Its large, spiky fruits are known for their sweet and slightly savory flavor. Nangka leaves are large, simple, and alternate, often used in traditional medicine and as animal fodder.",
        "image_path": "assets/nangka.jpg"
    },
    {
        "plant_name": "Pandan",
        "description": "Pandan is a tropical plant with long, fragrant leaves. It's often used in Southeast Asian cuisine to add a distinctive sweet aroma to dishes. Pandan leaves are typically long, narrow, and have a slightly spiky edge. They are often tied into knots and added to cooking liquids to infuse their flavor.",
        "image_path": "assets/pandan.jpg"
    },
    {
        "plant_name": "Pepaya",
        "description": "Pepaya, or papaya, is a tropical fruit tree native to Central America. Its fruits are large, fleshy, and have a sweet taste. Papaya leaves are large and lobed, often used in traditional medicine for their potential health benefits.",
        "image_path": "assets/pepaya.jpg"
    },
    {
        "plant_name": "Seledri",
        "description": "Seledri, or celery, is a vegetable with long, crisp stalks and aromatic leaves. It belongs to the Apiaceae family, which also includes carrots and parsley. Celery is often used in salads, soups, and stews, and is known for its refreshing taste and potential health benefits.",
        "image_path": "assets/seledri.jpg"
    },
    {
        "plant_name": "Sirih",
        "description": "Sirih, or betel leaf, is a climbing vine native to Southeast Asia. Its heart-shaped leaves are often used in traditional ceremonies and for their medicinal properties. Betel leaves are traditionally chewed with areca nut and lime paste, a practice common in many Southeast Asian cultures.",
        "image_path": "assets/toga_sirih.jpg"
    }
]

def seed_plants_data(db: Session):

    # Seed plants
    for plant_data in plants:
        db_plant = Plants(**plant_data)
        db.add(db_plant)

    db.commit()
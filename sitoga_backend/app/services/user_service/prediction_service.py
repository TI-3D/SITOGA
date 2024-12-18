import os
import numpy as np
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import img_to_array, load_img
from datetime import datetime
from sqlalchemy.orm import Session
from app.models.models import ScannedImage, Plants, History
from app.db.database import get_db

# Memuat model dan label encoder
model = load_model('app/ml/plant_models_CNN.h5')
label_encoder = np.load('app/ml/label_encoder.pkl', allow_pickle=True)
if not isinstance(label_encoder, dict):
    raise ValueError("Loaded label encoder is not a dictionary. Please check the saved file.")

def preprocess_image(image_path: str, image_size: tuple = (128, 128)):
    """Memproses gambar tanpa menghapus latar belakang"""
    if not os.path.exists(image_path):
        raise FileNotFoundError(f"Image file not found at {image_path}")
    
    # Memuat dan mengubah ukuran gambar
    image = load_img(image_path, target_size=image_size)
    image_array = img_to_array(image)
    normalized_image = image_array / 255.0  # Normalisasi piksel
    return np.expand_dims(normalized_image, axis=0)

def predict_image(image_path: str, user_id: int, db: Session, image_size: tuple = (128, 128)):
    """Memproses gambar, melakukan prediksi, dan menyimpan hasil ke database"""
    # Preprocessing gambar
    image_array = preprocess_image(image_path, image_size)

    if image_array.shape[1:] != (image_size[0], image_size[1], 3):
        raise ValueError(f"Unexpected input shape {image_array.shape}, expected {(1, *image_size, 3)}")

    # Prediksi
    predictions = model.predict(image_array)
    predicted_class_index = np.argmax(predictions)
    predicted_label = [label for label, index in label_encoder.items() if index == predicted_class_index][0]

    # Cari detected_plant_id berdasarkan predicted_label
    detected_plant = db.query(Plants).filter(Plants.plant_name == predicted_label).first()
    if not detected_plant:
        raise ValueError(f"Plant with name '{predicted_label}' not found in database.")

    # Simpan hasil ke tabel scanned_images
    image_url = os.path.basename(image_path)  # Simpan nama file
    scanned_image = ScannedImage(
        user_id=user_id,
        image_url=image_url,
        uploaded_at=datetime.utcnow(),
        detected_plant_id=detected_plant.plant_id
    )
    db.add(scanned_image)
    db.commit()

    # Simpan hasil ke tabel history
    history_entry = History(
        user_id=user_id,
        plant_id=detected_plant.plant_id,
        scan_date=datetime.utcnow(),
        image_url=image_url
    )
    db.add(history_entry)
    db.commit()

    return {
        "predicted_label": predicted_label,
        "confidence": float(np.max(predictions)),
    }
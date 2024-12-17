import os
import numpy as np
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import img_to_array, load_img
from rembg import remove  
import cv2  
from datetime import datetime
from sqlalchemy.orm import Session
from app.models.models import ScannedImage, Plants, History
from app.db.database import get_db  

model = load_model('app/ml/plant_models_CNN.h5')
label_encoder = np.load('app/ml/label_encoder.pkl', allow_pickle=True)
if not isinstance(label_encoder, dict):
    raise ValueError("Loaded label encoder is not a dictionary. Please check the saved file.")

def preprocess_image(image_path: str, image_size: tuple = (128, 128)):
    if not os.path.exists(image_path):
        raise FileNotFoundError(f"Image file not found at {image_path}")

    # Membaca gambar asli
    with open(image_path, "rb") as image_file:
        input_image = image_file.read()
    
    # Menghapus latar belakang menggunakan rembg
    processed_image = remove(input_image)

    # Membaca hasil sebagai array OpenCV
    np_image = np.frombuffer(processed_image, np.uint8)
    image = cv2.imdecode(np_image, cv2.IMREAD_UNCHANGED)

    # Jika gambar memiliki kanal alpha, gunakan sebagai mask
    if image.shape[-1] == 4:  
        alpha_channel = image[:, :, 3]  # Kanal alpha sebagai mask
        mask = cv2.threshold(alpha_channel, 0, 255, cv2.THRESH_BINARY)[1]
        image = cv2.bitwise_and(image[:, :, :3], image[:, :, :3], mask=mask)

    resized_image = cv2.resize(image, image_size)
    normalized_image = resized_image / 255.0  
    return np.expand_dims(normalized_image, axis=0)  

# Fungsi untuk memprediksi gambar dan menyimpan hasil ke database
def predict_image(image_path: str, user_id: int, db: Session, image_size: tuple = (128, 128)):
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
    image_url = os.path.basename(image_path)  
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
        # "scanned_image_id": scanned_image.image_id,
        # "history_id": history_entry.history_id
    }


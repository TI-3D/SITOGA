import os
import cv2
from app.models import models
import numpy as np
from sqlalchemy.orm import Session
from app.schemas import user_schemas 
from tensorflow.keras.models import load_model
from sklearn.preprocessing import LabelEncoder

# Load model dan label encoder
model = load_model('app/ml/plant_models_CNN.h5')
label_encoder = np.load('app/ml/label_encoder.npy', allow_pickle=True)

# Fungsi untuk memproses gambar dan melakukan prediksi
def predict_plant(image_data: bytes):
    # Mengonversi bytes menjadi array gambar
    image = np.frombuffer(image_data, np.uint8)
    image = cv2.imdecode(image, cv2.IMREAD_COLOR)

    img = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    img = cv2.resize(img, (64, 64))
    img = img / 255.0  # Normalisasi
    img = np.expand_dims(img, axis=-1)  # Tambah channel dimension
    img = np.expand_dims(img, axis=0)    # Tambahkan batch dimension

    # Prediksi
    prediction = model.predict(img)
    label = label_encoder[np.argmax(prediction)]
    confidence = float(np.max(prediction) * 100)  # Konversi ke float

    return {
        "label": label,
        "confidence": confidence  # Kembalikan sebagai float
    }

def create_scanned_image(db: Session, scanned_image: user_schemas.ScannedImageBase):
    db_image = models.ScannedImage(**scanned_image.model_dump())
    db.add(db_image)
    db.commit()
    db.refresh(db_image)
    return db_image

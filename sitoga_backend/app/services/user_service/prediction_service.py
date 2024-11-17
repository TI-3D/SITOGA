import os
import cv2
import numpy as np
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

# app/ml/model_loader.py
import numpy as np
import os
from tensorflow.keras.models import load_model

def load_trained_model(model_path: str):
    return load_model(model_path)

def load_label_encoder(encoder_path: str):
    if not os.path.exists(encoder_path):
        raise FileNotFoundError(f"Label encoder file not found at path: {encoder_path}")
    
    label_encoder = np.load(encoder_path, allow_pickle=True)
    
    # Debug print untuk memastikan label encoder dimuat
    print(f"Loaded label encoder: {label_encoder}")

    return label_encoder

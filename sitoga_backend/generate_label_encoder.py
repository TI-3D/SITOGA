# # generate_label_encoder.py
# import numpy as np

# # Contoh label encoder
# label_encoder = np.array(['Belimbing Wuluh', 'Jambu Biji', 'Jeruk Nipis', 'Kemangi', 'Lidah Buaya', 'Nangka', 'Pandan', 'Pepaya', 'Seledri', 'Sirih'])

# # Simpan label encoder ke file .npy
# np.save("app/ml/label_encoder.npy", label_encoder)
# print("Label encoder saved successfully.")

from app.ml.model_loader import load_trained_model, load_label_encoder
label_encoder = load_label_encoder("app/ml/label_encoder.npy")

# Debug print untuk melihat isi label_encoder
print(f"Label Encoder: {label_encoder}")
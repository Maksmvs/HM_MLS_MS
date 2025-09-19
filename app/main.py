from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import logging
from prometheus_fastapi_instrumentator import Instrumentator
from app.drift import drift_detector

# Логування
logging.basicConfig(level=logging.INFO)

# Ініціалізація FastAPI
app = FastAPI(title="AIOps Quality Project")

# Завантаження моделі
model = joblib.load("model/model.pkl")

# Prometheus метрики
Instrumentator().instrument(app).expose(app)

# Схема вхідних даних
class InputData(BaseModel):
    features: list

@app.get("/")
def root():
    return {"message": "AIOps Quality Project API"}

@app.post("/predict")
def predict(data: InputData):
    logging.info(f"Received request: {data.features}")
    prediction = model.predict([data.features])[0]

    # Drift detection
    drift = drift_detector(data.features)
    if drift:
        logging.warning("Drift detected!")

    return {"prediction": int(prediction), "drift_detected": drift}

from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import os

app = FastAPI(title="AI Quality Service")

MODEL_PATH = "model.pkl"

class InputData(BaseModel):
    input: float

@app.on_event("startup")
def load_model():
    global model
    if os.path.exists(MODEL_PATH):
        model = joblib.load(MODEL_PATH)
    else:
        # мок-модель, якщо немає файлу
        model = lambda x: x * 2

@app.post("/predict")
def predict(data: InputData):
    result = model(data.input)
    return {"prediction": result}

import joblib

def train():
    # Проста "модель": множення на 3
    model = lambda x: x * 3
    joblib.dump(model, "model.pkl")
    print("✅ Model trained and saved as model.pkl")

if __name__ == "__main__":
    train()

from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
import joblib

def train_and_save():
    X, y = load_iris(return_X_y=True)
    model = LogisticRegression(max_iter=200)
    model.fit(X, y)
    joblib.dump(model, "model/model.pkl")
    print("✅ Model trained and saved to model/model.pkl")

if __name__ == "__main__":
    train_and_save()

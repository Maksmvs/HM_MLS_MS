import mlflow
import mlflow.sklearn
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway
import os

# Підключення до PushGateway
registry = CollectorRegistry()
accuracy_g = Gauge('mlflow_accuracy', 'Accuracy metric', ['run_id'], registry=registry)
loss_g = Gauge('mlflow_loss', 'Loss metric', ['run_id'], registry=registry)

mlflow.set_tracking_uri(os.environ.get("MLFLOW_TRACKING_URI", "http://localhost:5000"))

data = load_iris()
X_train, X_test, y_train, y_test = train_test_split(data.data, data.target, test_size=0.2)

best_acc = 0
best_model = None
best_run_id = None

for lr in [0.01, 0.1, 0.2]:
    for n_estimators in [10, 50]:
        with mlflow.start_run() as run:
            clf = RandomForestClassifier(n_estimators=n_estimators)
            clf.fit(X_train, y_train)
            acc = clf.score(X_test, y_test)
            loss = 1 - acc

            mlflow.log_params({"learning_rate": lr, "n_estimators": n_estimators})
            mlflow.log_metrics({"accuracy": acc, "loss": loss})
            mlflow.sklearn.log_model(clf, "model")

            # Push metrics to PushGateway
            accuracy_g.labels(run_id=run.info.run_id).set(acc)
            loss_g.labels(run_id=run.info.run_id).set(loss)
            push_to_gateway('pushgateway.monitoring.svc.cluster.local:9091', job='mlflow_job', registry=registry)

            if acc > best_acc:
                best_acc = acc
                best_model = clf
                best_run_id = run.info.run_id

# Save best model locally
import joblib
os.makedirs("best_model", exist_ok=True)
joblib.dump(best_model, "best_model/best_model.pkl")
print(f"Best run_id: {best_run_id} with accuracy: {best_acc}")

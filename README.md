# HM_MLS_MS — Final Project

## Архітектура
- FastAPI сервіс (`app/main.py`) — інференс моделі
- Training script (`model/train.py`) — retrain
- Helm (`helm/`) — деплой у Kubernetes
- ArgoCD (`argocd/application.yaml`) — GitOps
- Prometheus + Grafana (`prometheus/`, `grafana/`) — моніторинг
- GitLab CI (`.gitlab-ci.yml`) — retrain пайплайн

---

## Як запустити локально
```bash
pip install fastapi uvicorn joblib
python model/train.py   # створить model.pkl
uvicorn app.main:app --reload

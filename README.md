# AIOps Quality Project

## 🚀 Компоненти
- FastAPI + модель
- Drift detector (Alibi Detect)
- Helm + ArgoCD
- Prometheus + Grafana
- Loki + Promtail
- GitLab CI retrain pipeline

## ▶ Запуск локально
```bash
python model/train.py
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload


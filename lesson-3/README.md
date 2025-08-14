# Перехід у папку lesson-3
cd lesson-3

# Запуск скрипта експорту моделі
python3 export_model.py

# Запуск inference на тестовому зображенні
python3 inference.py --image_path test_image.jpg

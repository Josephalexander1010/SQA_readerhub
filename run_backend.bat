@echo off
echo Starting Reader-HUB Backend...
cd backend
.\venv\Scripts\python manage.py runserver 0.0.0.0:8000
pause

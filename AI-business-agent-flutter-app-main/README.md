# AI Business Agent

This repository contains a Flutter mobile app and a FastAPI backend for an AI-powered business agent platform.

## Stack
- Frontend: Flutter
- Backend: FastAPI (Python)
- AI: GPT-5.5 + Claude 4 Sonnet (ready for integration)
- Agent: LangGraph + OpenAI Agents SDK (ready for integration)
- Database: PostgreSQL + pgvector + Redis (ready for integration)
- Maps: Google Maps + Places API + OpenStreetMap (ready for integration)
- Authentication: Firebase Authentication + WhatsApp Business API (ready for integration)

## Run backend
```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## Run frontend
```bash
cd ..
export PATH="/tmp/flutter/bin:$PATH"
flutter pub get
flutter test
flutter run
```

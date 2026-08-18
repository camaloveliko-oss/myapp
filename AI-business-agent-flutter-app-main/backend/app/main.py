from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
import os
import httpx

load_dotenv()

app = FastAPI(title="AI Business Agent API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ChatRequest(BaseModel):
    prompt: str


class LocationAnalysisRequest(BaseModel):
    city: str
    business_type: str
    address: str = ""


class RoiRequest(BaseModel):
    rent: float
    average_ticket: float
    margin: float = 0.35


class NegotiationRequest(BaseModel):
    address: str
    risks: list[str] = []


@app.get("/health")
def health_check():
    return {"status": "ok"}


@app.post("/chat")
def chat(payload: ChatRequest | None = None, prompt: str | None = None):
    effective_prompt = prompt or (payload.prompt if payload else "")
    provider = os.getenv("AI_PROVIDER", "gemini").lower()
    if provider == "gemini" and os.getenv("GEMINI_API_KEY"):
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
        response = httpx.post(
            endpoint,
            params={"key": os.environ["GEMINI_API_KEY"]},
            json={"contents": [{"parts": [{"text": effective_prompt}]}]},
            timeout=30,
        )
        response.raise_for_status()
        data = response.json()
        text = data["candidates"][0]["content"]["parts"][0]["text"]
        return {"response": text, "model": "gemini-1.5-flash", "prompt": effective_prompt}

    if provider == "openai" and os.getenv("OPENAI_API_KEY"):
        response = httpx.post(
            "https://api.openai.com/v1/chat/completions",
            headers={"Authorization": f"Bearer {os.environ['OPENAI_API_KEY']}"},
            json={"model": os.getenv("OPENAI_MODEL", "gpt-4o-mini"), "messages": [{"role": "user", "content": effective_prompt}]},
            timeout=30,
        )
        response.raise_for_status()
        data = response.json()
        return {"response": data["choices"][0]["message"]["content"], "model": data["model"], "prompt": effective_prompt}

    return {
        "response": (
            f"AI backend is ready. You asked: {effective_prompt or 'nothing'}"
        ),
        "model": "placeholder",
        "prompt": effective_prompt,
    }


@app.post("/analysis/location")
def location_analysis(payload: LocationAnalysisRequest):
    return {
        "city": payload.city,
        "business_type": payload.business_type,
        "address": payload.address,
        "score": 7.8,
        "survival_rate": 68,
        "pedestrian_traffic": "high",
        "competitors_500m": 6,
        "risks": ["Rəqib sıxlığı yenidən yoxlanmalıdır", "Mövsümi trafik dəyişə bilər"],
        "verdict": "Məkan ilkin mərhələ üçün uyğundur.",
    }


@app.post("/analysis/roi")
def roi_analysis(payload: RoiRequest):
    contribution = payload.average_ticket * max(payload.margin, 0)
    monthly_customers = 0 if contribution <= 0 else round(payload.rent / contribution)
    return {
        "monthly_customers": monthly_customers,
        "daily_customers": round(monthly_customers / 30),
        "margin": payload.margin,
        "break_even_note": "Bu, ilkin planlama hesabıdır; real xərclər ayrıca təsdiqlənməlidir.",
    }


@app.post("/analysis/negotiate")
def negotiate(payload: NegotiationRequest):
    risks = ", ".join(payload.risks) if payload.risks else "məkanın ilkin riskləri"
    return {
        "message": f"Salam. {payload.address} məkanı ilə maraqlanıram. {risks} nəzərə alınaraq icarə qiymətində güzəşt müzakirə edə bilərikmi?"
    }

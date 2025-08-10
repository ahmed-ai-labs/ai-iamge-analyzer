# main.py

"""
Entry point for the AI Image Analyzer backend service.
"""

from fastapi import FastAPI

app = FastAPI(title="AI Image Analyzer Backend")

@app.get("/")
def read_root():
    return {"message": "Welcome to the AI Image Analyzer Backend API!"}

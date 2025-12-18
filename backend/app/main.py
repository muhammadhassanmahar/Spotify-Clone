from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

# Routes
from app.routes.auth_routes import router as auth_router
from app.routes.user_routes import router as user_router
from app.routes.artist_routes import router as artist_router
from app.routes.album_routes import router as album_router
from app.routes.song_routes import router as song_router
from app.routes.playlist_routes import router as playlist_router
from app.routes.genre_routes import router as genre_router
from app.routes.history_routes import router as history_router
from app.routes.like_routes import router as like_router
from app.routes.dashboard_routes import router as dashboard_router
from app.routes.search_routes import router as search_router
from app.routes.recent_routes import router as recent_router
from app.routes.admin_routes import router as admin_router
from app.routes.upload_routes import router as upload_router

# Services
from app.services.auto_scan_service import auto_scan_uploads

# -------------------------------------------------
# APP
# -------------------------------------------------
app = FastAPI(
    title="Spotify Clone API",
    version="1.0.0",
    redirect_slashes=False
)

# -------------------------------------------------
# CORS — OPEN (DEV)
# -------------------------------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# -------------------------------------------------
# STATIC FILES
# -------------------------------------------------
app.mount(
    "/uploads",
    StaticFiles(directory="uploads"),
    name="uploads"
)

# -------------------------------------------------
# ROUTES
# -------------------------------------------------
app.include_router(auth_router)
app.include_router(user_router)
app.include_router(artist_router)
app.include_router(album_router)
app.include_router(song_router)
app.include_router(playlist_router)
app.include_router(genre_router)
app.include_router(history_router)
app.include_router(like_router)
app.include_router(dashboard_router)
app.include_router(search_router)
app.include_router(recent_router)
app.include_router(admin_router)
app.include_router(upload_router)

# -------------------------------------------------
# STARTUP — Auto Scan Enabled
# -------------------------------------------------
@app.on_event("startup")
async def startup_event():
    print("🔁 Backend started, running auto scan...")
    await auto_scan_uploads()
    print("✅ Auto scan completed")

# -------------------------------------------------
# ROOT
# -------------------------------------------------
@app.get("/")
async def root():
    return {
        "status": "OK",
        "message": "Spotify Clone Backend Running!",
        "cors": "OPEN (DEV MODE)"
    }

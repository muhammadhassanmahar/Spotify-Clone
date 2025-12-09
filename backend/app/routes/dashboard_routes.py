from fastapi import APIRouter, Depends
from app.controllers.dashboard_controller import get_dashboard_stats
from app.middlewares.auth_middleware import get_current_user


router = APIRouter(prefix="/dashboard", tags=["Dashboard"])


# ----------------------------------------
# GET DASHBOARD STATS (ADMIN ONLY)
# ----------------------------------------
@router.get("/")
async def fetch_dashboard_stats(current_user: dict = Depends(get_current_user)):
    # Only admin can access dashboard
    if current_user["role"] != "admin":
        return {"error": "Access denied. Admins only."}

    return await get_dashboard_stats()

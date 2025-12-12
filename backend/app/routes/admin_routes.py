from fastapi import APIRouter, Depends
from app.middlewares.auth_middleware import get_current_user
from app.controllers.admin_controller import (
    get_all_users,
    delete_user,
    promote_to_admin
)

router = APIRouter(prefix="/admin", tags=["Admin"])


# ----------------------------------------
# CHECK ADMIN ACCESS
# ----------------------------------------
def admin_only(user):
    if user.get("role") != "admin":
        return {"error": "Access denied. Admin only."}
    return None


# ----------------------------------------
# GET ALL USERS (ADMIN ONLY)
# ----------------------------------------
@router.get("/users")
async def fetch_all_users(current_user: dict = Depends(get_current_user)):
    check = admin_only(current_user)
    if check:
        return check

    return await get_all_users()


# ----------------------------------------
# DELETE USER (ADMIN ONLY)
# ----------------------------------------
@router.delete("/user/{user_id}")
async def remove_user(user_id: str, current_user: dict = Depends(get_current_user)):
    check = admin_only(current_user)
    if check:
        return check

    return await delete_user(user_id)


# ----------------------------------------
# PROMOTE USER TO ADMIN
# ----------------------------------------
@router.post("/promote/{user_id}")
async def promote_user_to_admin(user_id: str, current_user: dict = Depends(get_current_user)):
    check = admin_only(current_user)
    if check:
        return check

    return await promote_to_admin(user_id)

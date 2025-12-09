from fastapi import APIRouter, Depends
from app.controllers.user_controller import get_user_by_id, update_user
from app.schemas.user_schema import UpdateUserSchema
from app.middlewares.auth_middleware import get_current_user


router = APIRouter(prefix="/users", tags=["Users"])


# ----------------------------------------
# GET LOGGED-IN USER PROFILE
# ----------------------------------------
@router.get("/me")
async def get_my_profile(current_user: dict = Depends(get_current_user)):
    return await get_user_by_id(current_user["id"])


# ----------------------------------------
# UPDATE LOGGED-IN USER PROFILE
# ----------------------------------------
@router.put("/update")
async def update_profile(data: UpdateUserSchema, current_user: dict = Depends(get_current_user)):
    return await update_user(current_user["id"], data)

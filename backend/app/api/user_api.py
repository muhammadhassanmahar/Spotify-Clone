from fastapi import APIRouter, HTTPException, Depends
from app.schemas.user_schema import UpdateUserSchema
from app.services.user_service import UserService
from app.utils.oauth2 import get_current_user

router = APIRouter(prefix="/user", tags=["User"])


# -------------------------------
# GET USER PROFILE (JWT Protected)
# -------------------------------
@router.get("/profile")
async def get_profile(user=Depends(get_current_user)):
    user_data = await UserService.get_user_by_id(user["_id"])
    if not user_data:
        raise HTTPException(status_code=404, detail="User not found")
    return user_data


# -------------------------------
# UPDATE USER PROFILE
# -------------------------------
@router.put("/update")
async def update_profile(payload: UpdateUserSchema, user=Depends(get_current_user)):
    updated = await UserService.update_user(user["_id"], payload.dict(exclude_unset=True))
    if not updated:
        raise HTTPException(status_code=400, detail="Update failed")
    return {"message": "Profile updated successfully"}


# -------------------------------
# DELETE USER ACCOUNT
# -------------------------------
@router.delete("/delete")
async def delete_account(user=Depends(get_current_user)):
    deleted = await UserService.delete_user(user["_id"])
    if not deleted:
        raise HTTPException(status_code=400, detail="Account deletion failed")
    return {"message": "Account deleted successfully"}

import os
from fastapi import UploadFile
from uuid import uuid4

# Base upload folder
BASE_UPLOAD_FOLDER = "uploads"

# Sub folders
SONGS_FOLDER = os.path.join(BASE_UPLOAD_FOLDER, "songs")
IMAGES_FOLDER = os.path.join(BASE_UPLOAD_FOLDER, "images")

# -------------------------------------------------
# Ensure folders exist
# -------------------------------------------------
os.makedirs(SONGS_FOLDER, exist_ok=True)
os.makedirs(IMAGES_FOLDER, exist_ok=True)


# -------------------------------------------------
# Save uploaded file (audio / image)
# -------------------------------------------------
async def save_uploaded_file(file: UploadFile):
    try:
        ext = file.filename.split(".")[-1].lower()
        file_name = f"{uuid4()}.{ext}"

        # Detect file type
        if ext in ["mp3", "wav", "m4a", "aac"]:
            save_folder = SONGS_FOLDER
            file_type = "audio"
        elif ext in ["jpg", "jpeg", "png", "webp"]:
            save_folder = IMAGES_FOLDER
            file_type = "image"
        else:
            return {
                "success": False,
                "message": "Unsupported file type"
            }

        file_path = os.path.join(save_folder, file_name)

        # Save file
        with open(file_path, "wb") as f:
            f.write(await file.read())

        # VERY IMPORTANT: return RELATIVE path
        relative_path = file_path.replace("\\", "/")

        return {
            "success": True,
            "type": file_type,
            "file_name": file_name,
            "path": relative_path
        }

    except Exception as e:
        return {
            "success": False,
            "message": str(e)
        }

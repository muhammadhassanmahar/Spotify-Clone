from datetime import datetime


# -------------------------------------------------
# GET CURRENT TIMESTAMP
# -------------------------------------------------
def current_timestamp():
    return datetime.utcnow().isoformat()

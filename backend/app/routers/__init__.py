from .auth import router as auth_router
from .schedule import router as schedule_router

__all__ = ["auth_router", "schedule_router"]

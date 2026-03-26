from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field, field_validator


class RegisterRequest(BaseModel):
    model_config = ConfigDict(str_strip_whitespace=True)

    username: str = Field(min_length=3, max_length=50)
    password: str = Field(min_length=6, max_length=128)

    @field_validator("username")
    @classmethod
    def validate_username(cls, value: str) -> str:
        allowed = set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-.@")
        if any(ch not in allowed for ch in value):
            raise ValueError("Username contains unsupported characters")
        return value


class LoginRequest(BaseModel):
    model_config = ConfigDict(str_strip_whitespace=True)

    username: str = Field(min_length=3, max_length=50)
    password: str = Field(min_length=6, max_length=128)


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserResponse(BaseModel):
    id: int
    username: str
    created_at: datetime = Field(alias="createdAt")

    model_config = ConfigDict(populate_by_name=True)


class EventIn(BaseModel):
    model_config = ConfigDict(populate_by_name=True, str_strip_whitespace=True)

    id: str = Field(min_length=1, max_length=80)
    title: str = Field(min_length=1, max_length=200)
    date_time: datetime = Field(alias="dateTime")
    is_recurring: bool = Field(default=False, alias="isRecurring")
    note: str | None = Field(default=None, max_length=1000)


class EventOut(BaseModel):
    model_config = ConfigDict(populate_by_name=True)

    id: str
    title: str
    date_time: datetime = Field(alias="dateTime")
    is_recurring: bool = Field(alias="isRecurring")
    note: str | None = None


class ScheduleReplaceRequest(BaseModel):
    events: list[EventIn]


class ScheduleReplaceResponse(BaseModel):
    replaced_count: int = Field(alias="replacedCount")

    model_config = ConfigDict(populate_by_name=True)

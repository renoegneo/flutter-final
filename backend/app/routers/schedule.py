from fastapi import APIRouter, Depends, HTTPException, status

from ..db import get_db_connection
from ..dependencies import get_current_user
from ..models import EventIn, EventOut, ScheduleReplaceRequest, ScheduleReplaceResponse

router = APIRouter(prefix="/schedule", tags=["schedule"])


@router.get("/events", response_model=list[EventOut])
def get_events(current_user: dict = Depends(get_current_user)) -> list[EventOut]:
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, title, date_time, is_recurring, note
                FROM events
                WHERE user_id = %s
                ORDER BY date_time ASC
                """,
                (current_user["id"],),
            )
            rows = cur.fetchall()

    return [
        EventOut(
            id=row["id"],
            title=row["title"],
            dateTime=row["date_time"],
            isRecurring=bool(row["is_recurring"]),
            note=row["note"],
        )
        for row in rows
    ]


@router.put("/events", response_model=ScheduleReplaceResponse)
def replace_events(
    payload: ScheduleReplaceRequest,
    current_user: dict = Depends(get_current_user),
) -> ScheduleReplaceResponse:
    user_id = current_user["id"]

    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM events WHERE user_id = %s", (user_id,))

            if payload.events:
                params = [
                    (
                        event.id,
                        user_id,
                        event.title,
                        event.date_time,
                        event.is_recurring,
                        event.note,
                    )
                    for event in payload.events
                ]
                cur.executemany(
                    """
                    INSERT INTO events (id, user_id, title, date_time, is_recurring, note)
                    VALUES (%s, %s, %s, %s, %s, %s)
                    """,
                    params,
                )
        conn.commit()

    return ScheduleReplaceResponse(replacedCount=len(payload.events))


@router.post("/events", response_model=EventOut, status_code=status.HTTP_201_CREATED)
def upsert_event(
    payload: EventIn,
    current_user: dict = Depends(get_current_user),
) -> EventOut:
    user_id = current_user["id"]

    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO events (id, user_id, title, date_time, is_recurring, note)
                VALUES (%s, %s, %s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE
                    title = VALUES(title),
                    date_time = VALUES(date_time),
                    is_recurring = VALUES(is_recurring),
                    note = VALUES(note)
                """,
                (
                    payload.id,
                    user_id,
                    payload.title,
                    payload.date_time,
                    payload.is_recurring,
                    payload.note,
                ),
            )
            cur.execute(
                """
                SELECT id, title, date_time, is_recurring, note
                FROM events
                WHERE user_id = %s AND id = %s
                """,
                (user_id, payload.id),
            )
            row = cur.fetchone()
        conn.commit()

    return EventOut(
        id=row["id"],
        title=row["title"],
        dateTime=row["date_time"],
        isRecurring=bool(row["is_recurring"]),
        note=row["note"],
    )


@router.delete("/events/{event_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_event(event_id: str, current_user: dict = Depends(get_current_user)) -> None:
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "DELETE FROM events WHERE user_id = %s AND id = %s",
                (current_user["id"], event_id),
            )
            deleted = cur.rowcount
        conn.commit()

    if deleted == 0:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Event not found")

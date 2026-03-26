from contextlib import contextmanager

import pymysql
from pymysql.cursors import DictCursor

from .config import settings


@contextmanager
def get_db_connection():
    conn = pymysql.connect(
        host=settings.mysql_host,
        port=settings.mysql_port,
        user=settings.mysql_user,
        password=settings.mysql_password,
        database=settings.mysql_database,
        charset="utf8mb4",
        cursorclass=DictCursor,
        autocommit=False,
    )
    try:
        yield conn
    finally:
        conn.close()


def init_db() -> None:
    users_sql = """
    CREATE TABLE IF NOT EXISTS users (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password_hash VARCHAR(255) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    """

    events_sql = """
    CREATE TABLE IF NOT EXISTS events (
        id VARCHAR(80) NOT NULL,
        user_id BIGINT NOT NULL,
        title VARCHAR(200) NOT NULL,
        date_time DATETIME NOT NULL,
        is_recurring BOOLEAN NOT NULL DEFAULT FALSE,
        note TEXT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (user_id, id),
        CONSTRAINT fk_events_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        INDEX idx_events_user_date_time (user_id, date_time)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    """

    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(users_sql)
            cur.execute(events_sql)
        conn.commit()

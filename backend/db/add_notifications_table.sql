-- Standalone migration: add notifications table and indexes

BEGIN;

CREATE TABLE IF NOT EXISTS notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    telegram_id BIGINT NOT NULL,
    channel VARCHAR(32) NOT NULL DEFAULT 'telegram',
    message TEXT NOT NULL,
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE,
    status VARCHAR(16) NOT NULL DEFAULT 'pending',
    error TEXT,
    attempts INT NOT NULL DEFAULT 0,
    max_attempts INT NOT NULL DEFAULT 5,
    dedup_key VARCHAR(128),
    ext_data TEXT DEFAULT '{}',
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS notifications_scheduled_idx
  ON notifications (scheduled_at)
  WHERE status = 'pending';

CREATE INDEX IF NOT EXISTS notifications_status_idx
  ON notifications (status);

CREATE INDEX IF NOT EXISTS notifications_telegram_idx
  ON notifications (telegram_id);

CREATE UNIQUE INDEX IF NOT EXISTS notifications_dedup_idx
  ON notifications (dedup_key)
  WHERE dedup_key IS NOT NULL;

COMMIT;



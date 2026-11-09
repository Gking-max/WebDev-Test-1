CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL CHECK (length(title) > 0),
    description TEXT NOT NULL,
    requester_name TEXT NOT NULL CHECK (length(requester_name) > 0),
    requester_type TEXT NOT NULL CHECK (requester_type IN ('Student', 'Faculty', 'Staff')),
    location_name TEXT NOT NULL,
    location_code TEXT NOT NULL,
    status_id INTEGER NOT NULL REFERENCES statuses(id),
    priority_id INTEGER NOT NULL REFERENCES priorities(id),
    category_id INTEGER NOT NULL REFERENCES categories(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_tickets_status_id ON tickets(status_id);
CREATE INDEX idx_tickets_priority_id ON tickets(priority_id);
CREATE INDEX idx_tickets_category_id ON tickets(category_id);
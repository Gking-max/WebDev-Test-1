
INSERT INTO statuses (name) VALUES
  ('New'),
  ('Assigned'),
  ('In progress'),
  ('Waiting for you'),
  ('Resolved');

INSERT INTO priorities (name) VALUES
  ('Low'),
  ('Medium'),
  ('High'),
  ('Urgent');

INSERT INTO categories (name) VALUES
  ('Wi-Fi'),
  ('Email'),
  ('Printer'),
  ('Laptop'),
  ('Software');

-- ----------------------------------------------------------------------------
-- 2. Record rows (at least 2 tickets), IDs pulled by unique lookup name
-- ----------------------------------------------------------------------------
INSERT INTO tickets
  (title, description, requester_name, requester_type,
   location_name, location_code, status_id, priority_id, category_id)
VALUES
  (
    'Wi-Fi not working in Library',
    'Cannot connect to campus Wi-Fi.',
    'Alex Smith', 'Student',
    'Main Library', 'LIB-001',
    (SELECT id FROM statuses   WHERE name = 'New'),
    (SELECT id FROM priorities WHERE name = 'High'),
    (SELECT id FROM categories WHERE name = 'Wi-Fi')
  ),
  (
    'Cannot access email',
    'Getting authentication error on Outlook.',
    'Janelle Brown', 'Student',
    'Student Center', 'STU-201',
    (SELECT id FROM statuses   WHERE name = 'Assigned'),
    (SELECT id FROM priorities WHERE name = 'Medium'),
    (SELECT id FROM categories WHERE name = 'Email')
  ),
  (
    'Printer not printing',
    'Paper jam error on display.',
    'Marcus Lee', 'Faculty',
    'ICT Building', 'ICT-105',
    (SELECT id FROM statuses   WHERE name = 'In progress'),
    (SELECT id FROM priorities WHERE name = 'Medium'),
    (SELECT id FROM categories WHERE name = 'Printer')
  ),
  (
    'Request for software license',
    'Need access to MATLAB for course.',
    'Daniel Roberts', 'Student',
    'Online', 'Remote',
    (SELECT id FROM statuses   WHERE name = 'Resolved'),
    (SELECT id FROM priorities WHERE name = 'Low'),
    (SELECT id FROM categories WHERE name = 'Software')
  );

-- ----------------------------------------------------------------------------
-- 3. Inspect — one query per table
-- ----------------------------------------------------------------------------
SELECT * FROM statuses   ORDER BY name;
SELECT * FROM priorities ORDER BY name;
SELECT * FROM categories ORDER BY name;
SELECT * FROM tickets    ORDER BY created_at DESC;

-- ----------------------------------------------------------------------------
-- 4. Filter example — tickets that are high priority or above
-- ----------------------------------------------------------------------------
SELECT title, requester_name, created_at
FROM tickets
WHERE priority_id IN (
  SELECT id FROM priorities WHERE name IN ('High', 'Urgent')
)
ORDER BY created_at DESC;

-- ----------------------------------------------------------------------------
-- 5. Newest-first ordering (explicit LIMIT to keep output small)
-- ----------------------------------------------------------------------------
SELECT id, title, created_at
FROM tickets
ORDER BY created_at DESC
LIMIT 5;

-- ----------------------------------------------------------------------------
-- 6. JOIN — show lookup names alongside each ticket
-- ----------------------------------------------------------------------------
SELECT
  t.id,
  t.title,
  s.name AS status,
  p.name AS priority,
  c.name AS category,
  t.requester_name,
  t.location_name
FROM tickets AS t
JOIN statuses   AS s ON s.id = t.status_id
JOIN priorities AS p ON p.id = t.priority_id
JOIN categories AS c ON c.id = t.category_id
ORDER BY t.created_at DESC;

-- ----------------------------------------------------------------------------
-- 7. Grouped count — how many tickets per category (LEFT JOIN keeps
--    categories with zero tickets visible)
-- ----------------------------------------------------------------------------
SELECT
  c.name AS category,
  COUNT(t.id) AS ticket_count
FROM categories AS c
LEFT JOIN tickets AS t ON t.category_id = c.id
GROUP BY c.id, c.name
ORDER BY c.name;


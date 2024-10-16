CREATE TABLE IF NOT EXISTS users (
    email         text PRIMARY KEY,
    name          text NOT NULL CHECK (name <> ''),
    active        bool DEFAULT TRUE,
    created_at    timestamp DEFAULT NOW() NOT NULL,
    deleted_at    timestamp DEFAULT NULL -- soft-delete
);

INSERT INTO users (email, name)
VALUES ('john@gmail.com', 'John'),
       ('mary@gmail.com', 'Mary'),
       ('joe@gmail.com', 'Joe');

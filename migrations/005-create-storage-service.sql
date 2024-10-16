-- ==================================================
-- STORAGE
--
-- Service that let's you manage storage

CREATE TABLE IF NOT EXISTS storage_types (
    id                     text PRIMARY KEY,
    name                   text UNIQUE NOT NULL CHECK(name <> ''),
    description            text NOT NULL,
    resource_max_gib       int NOT NULL,
    resource_max_io_gib_s  int NOT NULL -- gib/s
);

INSERT INTO storage_types (id, name, description, resource_max_gib, resource_max_io_gib_s)
VALUES ('blob', 'Blob Storage', 'Solution for storing large amounts of unstructured data', 5_000, 2_400),
       ('file', 'File Share', 'Storage acessible using SMB and NFS protocols', 1_000, 1_000);

CREATE TABLE IF NOT EXISTS storage_service (
    id            text PRIMARY KEY,
    rg_owner      text NOT NULL REFERENCES resource_groups(id),
    storage_type  text REFERENCEs storage_types(id),
    metadata      text DEFAULT NULL,
    tags          text[],
    created_at    timestamp NOT NULL DEFAULT NOW(),
    deleted_at    timestamp DEFAULT NULL -- soft-delete
);

INSERT INTO storage_service (id, rg_owner, storage_type)
VALUES ('stor1', 'rg2', 'blob');

CREATE TABLE IF NOT EXISTS storage_service_permissions (
    permission    text PRIMARY KEY,
    description   text NOT NULL
);

INSERT INTO storage_service_permissions (permission, description)
VALUES ('Reader', 'Read a resource'),
       ('User', 'Use this resource'),
       ('Updater', 'Update this resource settings'),
       ('Deleter', 'Delete this resource');

CREATE TABLE storage_service_user_permissions (
    storage_service_id  text REFERENCES storage_service(id),
    user_email          text REFERENCES users(email),
    permission          text REFERENCES storage_service_permissions(permission),
    added_by            text REFERENCES users(email), -- rastreability
    created_at          timestamp NOT NULL DEFAULT NOW()
);

INSERT INTO storage_service_user_permissions (storage_service_id, user_email, permission, added_by)
VALUES ('stor1', 'joe@gmail.com', 'User', 'mary@gmail.com');

-- TODO billing table

-- ==================================================
-- TENANTS
--
-- They are the highest level at this authorization structure. After it, we have
-- resource groups, and inside resource groups we have the services, like
-- virtual machine, blob storage, managed kubernetes, etc.

CREATE TABLE IF NOT EXISTS tenants (
    id            text PRIMARY KEY,
    name          text UNIQUE NOT NULL CHECK (name <> ''),
    owner         text NOT NULL REFERENCES users(email),
    metadata      text, -- description for example
    tags          text[], -- 'key1:val1', 'key2:val2'
    active        bool DEFAULT TRUE,
    created_at    timestamp DEFAULT NOW() NOT NULL,
    deleted_at    timestamp DEFAULT NULL -- soft-delete
);

INSERT INTO tenants (id, name, owner, metadata, tags)
VALUES ('micr', 'Microsoft', 'john@gmail.com', '', ARRAY ['team:operations', 'org:microsoft']),
       ('amaz', 'Amazon', 'mary@gmail.com', '', ARRAY ['team:machine-learning', 'org:amazon']);

CREATE TABLE IF NOT EXISTS tenant_permissions (
    id            serial PRIMARY KEY,
    permission    text UNIQUE NOT NULL,
    description   text NOT NULL
);

INSERT INTO tenant_permissions (permission, description)
VALUES ('Creator', 'Create or update resources (not permissions or users) at the tenant'),
       ('Reader', 'Read the resources from the tenant'),
       ('Deleter', 'Delete resources at the tenant'),
       ('Admin', 'Add or remove users or permissions from the tenant');

CREATE TABLE tenant_user_permissions (
    tenant       text REFERENCES tenants(id),
    email        text REFERENCES users(email),
    permissions  text REFERENCES tenant_permissions(permission)
);

INSERT INTO tenant_user_permissions (tenant, email, permissions)
VALUES ('micr', 'john@gmail.com', 'Admin'),
       ('micr', 'joe@gmail.com', 'Reader'),
       ('amaz', 'mary@gmail.com', 'Admin'),
       ('amaz', 'joe@gmail.com', 'Creator'),
       ('amaz', 'joe@gmail.com', 'Deleter');

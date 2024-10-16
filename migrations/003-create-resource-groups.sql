-- RESOURCE GROUPS
--
-- We use this structure to group together some services. It makes our client's
-- life easier, by making it easier to look for resources associated with a
-- specific project for example.

-- TODO make the combination of name + tenant_owner unique instead of only name
CREATE TABLE IF NOT EXISTS resource_groups (
    id            text PRIMARY KEY,
    name          text UNIQUE NOT NULL CHECK (name <> ''),
    tenant_owner  text NOT NULL REFERENCES tenants(id),
    metadata      text DEFAULT NULL, -- description for example
    tags          text[], -- 'key1:val1', 'key2:val2'
    active        bool DEFAULT TRUE,
    created_at    timestamp DEFAULT NOW() NOT NULL,
    deleted_at    timestamp DEFAULT NULL -- soft-delete
);

INSERT INTO resource_groups (id, name, tenant_owner)
VALUES ('rg1', 'rg-micr-project-01', 'micr'),
       ('rg2', 'rg-amaz-project-01', 'amaz');

CREATE TABLE IF NOT EXISTS resource_group_permissions (
    id            serial PRIMARY KEY,
    permission    text UNIQUE NOT NULL,
    description   text NOT NULL
);

INSERT INTO resource_group_permissions (permission, description)
VALUES ('Creator', 'Create or update resources (not permissions or users) at the resource group level'),
       ('Reader', 'Read the resources from the resource group'), -- member may be better
       ('Deleter', 'Delete resources at the resource group'),
       ('Admin', 'Add or remove users or permissions from the resource group'),
       ('User', 'Use any resource at the resource group'),
       -- If we need a fine-grained control, we could expand these permissions
       -- to be resource specific, like:
       ('VM-Creator', 'Can create VM services inside the resource group');

CREATE TABLE resource_group_user_permissions (
    resource_group  text REFERENCES resource_groups(id),
    user_email      text REFERENCES users(email),
    permission      text REFERENCES resource_group_permissions(permission),
    added_by        text REFERENCES users(email), -- rastreability
    created_at      timestamp NOT NULL DEFAULT NOW()
);

INSERT INTO resource_group_user_permissions (resource_group, user_email, permission, added_by)
VALUES ('rg1', 'joe@gmail.com', 'Deleter', 'john@gmail.com'),
       ('rg2', 'joe@gmail.com', 'Admin', 'mary@gmail.com');

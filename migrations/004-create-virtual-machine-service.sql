-- ==================================================
-- VIRTUAL MACHINES
--
-- Service that let's you manage virtual machines

CREATE TABLE IF NOT EXISTS virtual_machine_types (
    id                 text PRIMARY KEY,
    name               text UNIQUE NOT NULL CHECK(name <> ''),
    family             text NOT NULL, -- could be extracted to another table
    description        text NOT NULL,
    resource_vcpu      int NOT NULL, -- to use less resources, we'll store as int,
                                     -- and divide by 100 later
    resource_mem_gib   int NOT NULL
    -- ... storage io, network io, etc.
);

INSERT INTO virtual_machine_types (id, name, family, description, resource_vcpu, resource_mem_gib)
VALUES ('d2v6', 'Standard_D2ps_v6', 'Dpsv6', 'General-purpose workloads', 200, 800),
       ('d4v6', 'Standard_D4ps_v6', 'Dpsv6', 'General-purpose workloads', 400, 1600),
       ('d8v6', 'Standard_D8ps_v6', 'Dpsv6', 'General-purpose workloads', 800, 3200);

CREATE TABLE IF NOT EXISTS virtual_machine_states (
    state        text NOT NULL PRIMARY KEY,
    description  text NOT NULL
);

INSERT INTO virtual_machine_states (state, description)
VALUES ('RUNNING', 'The VM is running'),
       ('STOPPED', 'The VM is stopped'),
       ('INITIALIZING', 'The VM is still initializing so it is not ready'),
       ('BROKEN', 'The VM is into a broken state, we will need to check');
       -- we can have more descriptive states other than BROKEN, for example, to
       -- show that the error is a network error, or a hardware error, or
       -- something else.

CREATE TABLE IF NOT EXISTS virtual_machine_service (
    id            text PRIMARY KEY,
    rg_owner      text NOT NULL REFERENCES resource_groups(id),
    vm_type       text REFERENCES virtual_machine_types(id),
    metadata      text DEFAULT NULL,
    tags          text[],
    vm_state      text REFERENCES virtual_machine_states(state),
    created_at    timestamp NOT NULL DEFAULT NOW(),
    deleted_at    timestamp DEFAULT NULL -- soft-delete
);

INSERT INTO virtual_machine_service (id, rg_owner, vm_type, vm_state)
VALUES ('vm1', 'rg1', 'd4v6', 'STOPPED'),
       ('vm2', 'rg2', 'd4v6', 'STOPPED');

CREATE TABLE IF NOT EXISTS virtual_machine_service_permissions (
    permission    text PRIMARY KEY,
    description   text NOT NULL
);

INSERT INTO virtual_machine_service_permissions (permission, description)
VALUES ('Reader', 'Read a resource'),
       ('User', 'Use this resource'),
       ('Updater', 'Update this resource settings'),
       ('Deleter', 'Delete this resource');

CREATE TABLE virtual_machine_service_user_permissions (
    virtual_machine_id  text REFERENCES virtual_machine_service(id),
    user_email          text REFERENCES users(email),
    permission          text REFERENCES virtual_machine_service_permissions(permission),
    added_by            text REFERENCES users(email),
    created_at          timestamp NOT NULL DEFAULT NOW()
);

INSERT INTO virtual_machine_service_user_permissions (virtual_machine_id, user_email, permission, added_by)
VALUES ('vm1', 'joe@gmail.com', 'Updater', 'john@gmail.com');

-- TODO billing table

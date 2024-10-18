-- ============================================
-- STORAGE SERVICE

INSERT INTO storage_service_permissions (permission, description)
VALUES ('Writer', 'Can update and delete the configuration for this service'),
       ('Executor', 'Can use this service');

UPDATE storage_service_user_permissions
SET permission = 'Writer'
WHERE permission = 'Updater' OR permission = 'Deleter';

UPDATE storage_service_user_permissions
SET permission = 'Executor'
WHERE permission = 'User';

DELETE FROM storage_service_permissions
WHERE permission IN ('Updater', 'Deleter', 'User');

-- ============================================
-- VIRTUAL MACHINE SERVICE

INSERT INTO virtual_machine_service_permissions (permission, description)
VALUES ('Writer', 'Can update and delete the configuration for this service'),
       ('Executor', 'Can use this service');

UPDATE virtual_machine_service_user_permissions
SET permission = 'Writer'
WHERE permission = 'Updater' OR permission = 'Deleter';

UPDATE virtual_machine_service_user_permissions
SET permission = 'Executor'
WHERE permission = 'User';

DELETE FROM virtual_machine_service_permissions
WHERE permission IN ('Updater', 'Deleter', 'User');

-- ============================================
-- RESOURCE GROUP

INSERT INTO resource_group_permissions (permission, description)
VALUES ('Writer', 'Create, update or delete services from a resource group');

UPDATE resource_group_user_permissions
SET permission = 'Writer'
WHERE permission = 'Creator' OR
      permission = 'Deleter' OR
      permission = 'VM-Creator';

UPDATE resource_group_user_permissions
SET permission = 'Reader'
WHERE permission = 'User';

DELETE FROM resource_group_permissions
WHERE permission IN ('Creator', 'Deleter', 'User', 'VM-Creator');

-- ============================================
-- TENANTS
INSERT INTO tenant_permissions (permission, description)
VALUES ('Writer', 'Create, update or delete X from this tenant');

ALTER TABLE tenant_user_permissions
RENAME COLUMN permissions TO permission;

UPDATE tenant_user_permissions
SET permission = 'Writer'
WHERE permission = 'Creator' OR
      permission = 'Deleter';

DELETE FROM tenant_permissions
WHERE permission IN ('Creator', 'Deleter');

-- Script to create initial Super Admin user
-- Password: admin123 (hashed with BCrypt)
-- Change the password after first login!

INSERT INTO users (id, name, phone, email, password_hash, role, active, created_at)
VALUES (
    gen_random_uuid(),
    'Super Admin',
    '0000000000',
    'admin@eventpay.com',
    '$2a$12$JYqqQc7nzE6FxlU2hJUIuuMHborSVUx72yAAYo1aNX3MYu8IjOcjq', -- password: admin123
    'SUPER_ADMIN',
    true,
    NOW()
) ON CONFLICT DO NOTHING;

SELECT 'Super Admin created successfully!' as status;
SELECT 'Login credentials: admin@eventpay.com / admin123' as credentials;
SELECT 'IMPORTANT: Change password immediately after first login!' as warning;

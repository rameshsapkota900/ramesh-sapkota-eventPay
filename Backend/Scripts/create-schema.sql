-- EventPay Database Schema
-- PostgreSQL 12+

-- Drop tables if exists (in reverse order of dependencies)
DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS wallets CASCADE;
DROP TABLE IF EXISTS stalls CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS organizations CASCADE;

-- Create Organizations Table
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    address TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_org_status CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

-- Create Events Table
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    venue VARCHAR(255) NOT NULL,
    default_money DECIMAL(12, 2) NOT NULL,
    default_student_password_hash VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_event_organization FOREIGN KEY (organization_id) 
        REFERENCES organizations(id) ON DELETE CASCADE,
    CONSTRAINT chk_event_status CHECK (status IN ('DRAFT', 'ACTIVE', 'COMPLETED', 'CLOSED'))
);

-- Create Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID,
    event_id UUID,
    role VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(255),
    password_hash VARCHAR(255) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    school VARCHAR(255),
    visited_before BOOLEAN,
    registration_time TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_user_organization FOREIGN KEY (organization_id) 
        REFERENCES organizations(id) ON DELETE SET NULL,
    CONSTRAINT fk_user_event FOREIGN KEY (event_id) 
        REFERENCES events(id) ON DELETE SET NULL,
    CONSTRAINT chk_user_role CHECK (role IN ('SUPER_ADMIN', 'ORG_ADMIN', 'VOLUNTEER', 'STUDENT', 'STALL'))
);

-- Create indexes for Users
CREATE INDEX idx_phone ON users(phone);
CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_role ON users(role);

-- Create Stalls Table
CREATE TABLE stalls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    event_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    owner_name VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(255),
    qr_token TEXT,
    qr_public_url TEXT,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_stall_organization FOREIGN KEY (organization_id) 
        REFERENCES organizations(id) ON DELETE CASCADE,
    CONSTRAINT fk_stall_event FOREIGN KEY (event_id) 
        REFERENCES events(id) ON DELETE CASCADE,
    CONSTRAINT chk_stall_type CHECK (type IN ('FOOD', 'GAMES', 'ACTIVITIES', 'GIFTS'))
);

-- Create Wallets Table
CREATE TABLE wallets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    event_id UUID NOT NULL,
    balance DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    version BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_wallet_student FOREIGN KEY (student_id) 
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_wallet_event FOREIGN KEY (event_id) 
        REFERENCES events(id) ON DELETE CASCADE,
    CONSTRAINT uk_student_event UNIQUE (student_id, event_id)
);

-- Create Transactions Table
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL,
    from_wallet_id UUID,
    to_wallet_id UUID,
    stall_id UUID,
    amount DECIMAL(12, 2) NOT NULL,
    type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    metadata JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_transaction_event FOREIGN KEY (event_id) 
        REFERENCES events(id) ON DELETE CASCADE,
    CONSTRAINT fk_transaction_from_wallet FOREIGN KEY (from_wallet_id) 
        REFERENCES wallets(id) ON DELETE SET NULL,
    CONSTRAINT fk_transaction_to_wallet FOREIGN KEY (to_wallet_id) 
        REFERENCES wallets(id) ON DELETE SET NULL,
    CONSTRAINT fk_transaction_stall FOREIGN KEY (stall_id) 
        REFERENCES stalls(id) ON DELETE SET NULL,
    CONSTRAINT chk_transaction_type CHECK (type IN ('PAYMENT', 'TOPUP', 'REFUND')),
    CONSTRAINT chk_transaction_status CHECK (status IN ('COMPLETED', 'FAILED', 'PENDING'))
);

-- Create indexes for Transactions
CREATE INDEX idx_event ON transactions(event_id);
CREATE INDEX idx_from_wallet ON transactions(from_wallet_id);
CREATE INDEX idx_to_wallet ON transactions(to_wallet_id);
CREATE INDEX idx_created_at ON transactions(created_at);

-- Create Audit Logs Table
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_user_id UUID,
    organization_id UUID,
    event_id UUID,
    action VARCHAR(255) NOT NULL,
    details JSONB,
    ip_address VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for Audit Logs
CREATE INDEX idx_actor ON audit_logs(actor_user_id);
CREATE INDEX idx_org ON audit_logs(organization_id);
CREATE INDEX idx_event ON audit_logs(event_id);
CREATE INDEX idx_action ON audit_logs(action);
CREATE INDEX idx_created_at ON audit_logs(created_at);

-- Comments for documentation
COMMENT ON TABLE organizations IS 'Stores organization/college information';
COMMENT ON TABLE events IS 'Stores event information organized by organizations';
COMMENT ON TABLE users IS 'Stores all users: super admins, org admins, volunteers, students, and stall owners';
COMMENT ON TABLE stalls IS 'Stores stall/vendor information for events';
COMMENT ON TABLE wallets IS 'Stores student wallet balances for each event';
COMMENT ON TABLE transactions IS 'Stores all payment transactions';
COMMENT ON TABLE audit_logs IS 'Stores audit trail of all system actions';

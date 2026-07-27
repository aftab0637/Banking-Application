-- =====================================================
-- IBMS - COMPLETE DATABASE SETUP SCRIPT (FIXED)
-- =====================================================
-- Run this AFTER the application has started once
-- (so Hibernate creates the tables first).
-- Open pgAdmin → Right-click ibms1 → Query Tool → Paste → Execute (F5)
-- =====================================================

-- =====================================================
-- STEP 1: STORED PROCEDURES
-- =====================================================
-- These are PostgreSQL functions that handle complex
-- business logic INSIDE the database for atomicity.
-- Java calls them via: SELECT transfer_funds(?1, ?2, ?3)
-- =====================================================

-- PROCEDURE 1: transfer_funds
-- Called by: OTPVerifyController.java → BankingDAO.callTransferFunds()
-- Purpose: Atomic money transfer with row-level locking
CREATE OR REPLACE FUNCTION transfer_funds(
    p_sender_id INT, p_receiver_id INT, p_amount DOUBLE PRECISION
) RETURNS TEXT AS $$
DECLARE
    v_sender_bal DOUBLE PRECISION;
    v_receiver_exists INT;
BEGIN
    -- Validate amount
    IF p_amount <= 0 THEN RETURN 'ERROR: Amount must be greater than zero'; END IF;
    
    -- Check receiver exists
    SELECT COUNT(*) INTO v_receiver_exists FROM users WHERE id = p_receiver_id;
    IF v_receiver_exists = 0 THEN RETURN 'ERROR: Receiver account not found'; END IF;
    
    -- Prevent self-transfer
    IF p_sender_id = p_receiver_id THEN RETURN 'ERROR: Cannot transfer to your own account'; END IF;
    
    -- Lock sender's row (FOR UPDATE prevents concurrent modifications)
    SELECT bal INTO v_sender_bal FROM users WHERE id = p_sender_id FOR UPDATE;
    
    -- Check sufficient balance
    IF v_sender_bal < p_amount THEN RETURN 'ERROR: Insufficient balance. Available: ' || v_sender_bal; END IF;

    -- Perform atomic balance update
    UPDATE users SET bal = bal - p_amount WHERE id = p_sender_id;
    UPDATE users SET bal = bal + p_amount WHERE id = p_receiver_id;

    RETURN 'SUCCESS';
END;
$$ LANGUAGE plpgsql;


-- PROCEDURE 2: pay_bill
-- Called by: OTPVerifyController.java → BankingDAO.callPayBill()
-- Purpose: Bill payment with balance deduction
CREATE OR REPLACE FUNCTION pay_bill(
    p_user_id INT, p_bill_type VARCHAR, p_bill_number VARCHAR, p_amount DOUBLE PRECISION
) RETURNS TEXT AS $$
DECLARE
    v_user_bal DOUBLE PRECISION;
BEGIN
    IF p_amount <= 0 THEN RETURN 'ERROR: Amount must be greater than zero'; END IF;
    
    -- Lock the user's row
    SELECT bal INTO v_user_bal FROM users WHERE id = p_user_id FOR UPDATE;
    IF v_user_bal < p_amount THEN RETURN 'ERROR: Insufficient balance. Available: ' || v_user_bal; END IF;

    -- Deduct balance
    UPDATE users SET bal = bal - p_amount WHERE id = p_user_id;

    RETURN 'SUCCESS';
END;
$$ LANGUAGE plpgsql;


-- PROCEDURE 3: get_account_summary
-- Called by: DashboardController.java → BankingDAO.callGetAccountSummary()
-- Purpose: Returns user stats from 3 tables in a single call
CREATE OR REPLACE FUNCTION get_account_summary(p_user_id INT)
RETURNS TABLE(
    user_name VARCHAR, user_email VARCHAR, account_number VARCHAR,
    current_balance DOUBLE PRECISION, total_credits DOUBLE PRECISION,
    total_debits DOUBLE PRECISION, total_transactions BIGINT, total_bills_paid BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.name::VARCHAR, u.email::VARCHAR, u.accountnumber::VARCHAR, u.bal,
        COALESCE((SELECT SUM(t.amount) FROM banktransaction t WHERE t.receiverid = p_user_id AND t.type = 'CREDIT'), 0),
        COALESCE((SELECT SUM(t.amount) FROM banktransaction t WHERE t.senderid = p_user_id AND t.type = 'DEBIT'), 0),
        (SELECT COUNT(*) FROM banktransaction t WHERE t.senderid = p_user_id OR t.receiverid = p_user_id),
        (SELECT COUNT(*) FROM billpayment b WHERE b.userid = p_user_id)
    FROM users u WHERE u.id = p_user_id;
END;
$$ LANGUAGE plpgsql;


-- =====================================================
-- STEP 2: VIEWS
-- =====================================================
-- Views are pre-compiled SQL queries saved in the database.
-- Java queries them like normal tables: SELECT * FROM v_admin_dashboard_stats
-- =====================================================

-- VIEW 1: v_transaction_history
-- Shows transactions with sender/receiver NAMES (not just IDs)
CREATE OR REPLACE VIEW v_transaction_history AS
SELECT t.id AS transaction_id, t.type AS transaction_type, t.amount, t.transactiontime AS transaction_date,
    t.senderid AS sender_id, s.name AS sender_name, s.email AS sender_email, s.accountnumber AS sender_account,
    t.receiverid AS receiver_id, r.name AS receiver_name, r.email AS receiver_email, r.accountnumber AS receiver_account
FROM banktransaction t LEFT JOIN users s ON t.senderid = s.id LEFT JOIN users r ON t.receiverid = r.id
ORDER BY t.transactiontime DESC;

-- VIEW 2: v_admin_dashboard_stats
-- Called by: AdminDashboardController.java → BankingDAO.getAdminDashboardStats()
-- Returns all admin stats in ONE query instead of 9 separate queries
CREATE OR REPLACE VIEW v_admin_dashboard_stats AS
SELECT (SELECT COUNT(*) FROM users WHERE role = 'USER') AS total_users,
    (SELECT COUNT(*) FROM banktransaction) AS total_transactions,
    (SELECT COALESCE(SUM(bal), 0) FROM users WHERE role = 'USER') AS total_balance,
    (SELECT COALESCE(AVG(bal), 0) FROM users WHERE role = 'USER') AS average_balance,
    (SELECT COALESCE(SUM(amount), 0) FROM banktransaction WHERE type = 'CREDIT') AS total_credits,
    (SELECT COALESCE(SUM(amount), 0) FROM banktransaction WHERE type = 'DEBIT') AS total_debits,
    (SELECT COUNT(*) FROM billpayment) AS total_bills_paid,
    (SELECT COUNT(*) FROM beneficiary) AS total_beneficiaries,
    (SELECT COUNT(*) FROM banktransaction WHERE transactiontime >= CURRENT_DATE) AS today_transactions;

-- VIEW 3: v_user_account_summary
CREATE OR REPLACE VIEW v_user_account_summary AS
SELECT u.id AS user_id, u.name, u.email, u.phone, u.accountnumber AS account_number, u.bal AS current_balance,
    u.role, u.createdat AS member_since,
    COALESCE(c.total_credits, 0) AS total_credits, COALESCE(d.total_debits, 0) AS total_debits,
    COALESCE(tx.num_transactions, 0) AS total_transactions, COALESCE(b.num_bills, 0) AS total_bills_paid
FROM users u
LEFT JOIN (SELECT receiverid, SUM(amount) AS total_credits FROM banktransaction WHERE type = 'CREDIT' GROUP BY receiverid) c ON u.id = c.receiverid
LEFT JOIN (SELECT senderid, SUM(amount) AS total_debits FROM banktransaction WHERE type = 'DEBIT' GROUP BY senderid) d ON u.id = d.senderid
LEFT JOIN (SELECT senderid, COUNT(*) AS num_transactions FROM banktransaction GROUP BY senderid) tx ON u.id = tx.senderid
LEFT JOIN (SELECT userid, COUNT(*) AS num_bills FROM billpayment GROUP BY userid) b ON u.id = b.userid
WHERE u.role = 'USER' ORDER BY u.createdat DESC;

-- VIEW 4: v_bill_payment_history
CREATE OR REPLACE VIEW v_bill_payment_history AS
SELECT b.id AS bill_id, u.name AS user_name, u.email AS user_email, b.billtype AS bill_type,
    b.billnumber AS bill_number, b.amount, b.status, b.paidat AS paid_date
FROM billpayment b JOIN users u ON b.userid = u.id ORDER BY b.paidat DESC;


-- =====================================================
-- STEP 3: TRIGGERS
-- =====================================================
-- Triggers fire AUTOMATICALLY when data changes.
-- Java does NOT call them — they run at the DB level.
-- =====================================================

DROP TRIGGER IF EXISTS trg_audit_balance_change ON users;
DROP TRIGGER IF EXISTS trg_prevent_negative_balance ON users;
DROP TRIGGER IF EXISTS trg_set_default_role ON users;
DROP TABLE IF EXISTS audit_log;

-- Create audit_log table (column names match AuditLog.java entity)
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    userid INT NOT NULL,
    useremail VARCHAR(255),
    action VARCHAR(50) NOT NULL,
    oldbalance DOUBLE PRECISION,
    newbalance DOUBLE PRECISION,
    changeamount DOUBLE PRECISION,
    performedat TIMESTAMP DEFAULT NOW()
);

-- TRIGGER 1: Auto-log every balance change
-- This fires AFTER any UPDATE on the users table
-- It checks if 'bal' column changed, and if so, logs the details
CREATE OR REPLACE FUNCTION fn_audit_balance_change() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.bal IS DISTINCT FROM NEW.bal THEN
        INSERT INTO audit_log (userid, useremail, action, oldbalance, newbalance, changeamount, performedat)
        VALUES (NEW.id, NEW.email,
            CASE WHEN NEW.bal > OLD.bal THEN 'CREDIT' ELSE 'DEBIT' END,
            OLD.bal, NEW.bal, ABS(NEW.bal - OLD.bal), NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_balance_change AFTER UPDATE ON users FOR EACH ROW EXECUTE FUNCTION fn_audit_balance_change();

-- TRIGGER 2: Prevent negative balance (safety net)
-- Even if Java has a bug, this trigger blocks negative balances at DB level
CREATE OR REPLACE FUNCTION fn_prevent_negative_balance() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.bal < 0 THEN RAISE EXCEPTION 'Insufficient balance. Cannot go below zero.'; END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_negative_balance BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION fn_prevent_negative_balance();

-- TRIGGER 3: Auto-set default role to 'USER'
CREATE OR REPLACE FUNCTION fn_set_default_role() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.role IS NULL OR NEW.role = '' THEN NEW.role := 'USER'; END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_default_role BEFORE INSERT ON users FOR EACH ROW EXECUTE FUNCTION fn_set_default_role();

-- =====================================================
-- STEP 4: VERIFICATION
-- =====================================================
SELECT '✅ Procedures' AS status, COUNT(*) AS count FROM pg_proc WHERE proname IN ('transfer_funds', 'pay_bill', 'get_account_summary')
UNION ALL SELECT '✅ Views', COUNT(*) FROM pg_views WHERE viewname LIKE 'v_%'
UNION ALL SELECT '✅ Triggers', COUNT(*) FROM pg_trigger WHERE tgname LIKE 'trg_%';

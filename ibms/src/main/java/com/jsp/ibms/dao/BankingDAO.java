package com.jsp.ibms.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

/**
 * ============================================================
 * BankingDAO - Data Access Object for IBMS (Spring Managed Bean)
 * ============================================================
 * 
 * This class is the BRIDGE between Java and PostgreSQL.
 * It calls Stored Procedures and Views using Native SQL Queries.
 * 
 * STORED PROCEDURES called:
 *   1. transfer_funds(sender_id, receiver_id, amount) → Returns 'SUCCESS' or error
 *   2. pay_bill(user_id, bill_type, bill_number, amount) → Returns 'SUCCESS' or error
 *   3. get_account_summary(user_id) → Returns user stats as a table row
 * 
 * VIEWS used:
 *   1. v_admin_dashboard_stats → Aggregated admin stats
 *   2. v_transaction_history → Transaction history with user names
 * ============================================================
 */
@Repository
public class BankingDAO {

    @PersistenceContext
    private EntityManager em;

    // ============================================================
    // 1. STORED PROCEDURE: transfer_funds
    // ============================================================
    public String callTransferFunds(int senderId, int receiverId, double amount) {
        System.out.println("[IBMS-DAO] Calling STORED PROCEDURE: transfer_funds(" + senderId + ", " + receiverId + ", " + amount + ")");

        String result = (String) em.createNativeQuery(
                "SELECT transfer_funds(?1, ?2, ?3)")
                .setParameter(1, senderId)
                .setParameter(2, receiverId)
                .setParameter(3, amount)
                .getSingleResult();

        System.out.println("[IBMS-DAO] Stored Procedure returned: " + result);
        return result;
    }

    // ============================================================
    // 2. STORED PROCEDURE: pay_bill
    // ============================================================
    public String callPayBill(int userId, String billType, String billNumber, double amount) {
        System.out.println("[IBMS-DAO] Calling STORED PROCEDURE: pay_bill(" + userId + ", " + billType + ", " + billNumber + ", " + amount + ")");

        String result = (String) em.createNativeQuery(
                "SELECT pay_bill(?1, ?2, ?3, ?4)")
                .setParameter(1, userId)
                .setParameter(2, billType)
                .setParameter(3, billNumber)
                .setParameter(4, amount)
                .getSingleResult();

        System.out.println("[IBMS-DAO] Stored Procedure returned: " + result);
        return result;
    }

    // ============================================================
    // 3. STORED PROCEDURE: get_account_summary
    // ============================================================
    public Map<String, Object> callGetAccountSummary(int userId) {
        System.out.println("[IBMS-DAO] Calling STORED PROCEDURE: get_account_summary(" + userId + ")");

        List<?> results = em.createNativeQuery(
                "SELECT * FROM get_account_summary(?1)")
                .setParameter(1, userId)
                .getResultList();

        Map<String, Object> summary = new HashMap<>();

        if (results != null && !results.isEmpty()) {
            Object[] row = (Object[]) results.get(0);
            summary.put("userName", row[0]);
            summary.put("userEmail", row[1]);
            summary.put("accountNumber", row[2]);
            summary.put("currentBalance", row[3]);
            summary.put("totalCredits", row[4]);
            summary.put("totalDebits", row[5]);
            summary.put("totalTransactions", row[6]);
            summary.put("totalBillsPaid", row[7]);
            System.out.println("[IBMS-DAO] Account summary loaded successfully for user: " + row[0]);
        }

        return summary;
    }

    // ============================================================
    // 4. DATABASE VIEW: v_admin_dashboard_stats
    // ============================================================
    public Map<String, Object> getAdminDashboardStats() {
        System.out.println("[IBMS-DAO] Calling DATABASE VIEW: v_admin_dashboard_stats");

        List<?> results = em.createNativeQuery(
                "SELECT * FROM v_admin_dashboard_stats")
                .getResultList();

        Map<String, Object> stats = new HashMap<>();

        if (results != null && !results.isEmpty()) {
            Object[] row = (Object[]) results.get(0);
            stats.put("totalUsers", row[0]);
            stats.put("totalTransactions", row[1]);
            stats.put("totalBalance", row[2]);
            stats.put("averageBalance", row[3]);
            stats.put("totalCredits", row[4]);
            stats.put("totalDebits", row[5]);
            stats.put("totalBillsPaid", row[6]);
            stats.put("totalBeneficiaries", row[7]);
            stats.put("todayTransactions", row[8]);
            System.out.println("[IBMS-DAO] Admin dashboard stats loaded from VIEW successfully");
        }

        return stats;
    }

    // ============================================================
    // 5. DATABASE VIEW: v_transaction_history
    // ============================================================
    public List<?> getTransactionHistoryFromView(int userId) {
        System.out.println("[IBMS-DAO] Calling DATABASE VIEW: v_transaction_history for user " + userId);

        List<?> results = em.createNativeQuery(
                "SELECT * FROM v_transaction_history WHERE (sender_id = ?1 AND transaction_type = 'DEBIT') OR (receiver_id = ?1 AND transaction_type = 'CREDIT')")
                .setParameter(1, userId)
                .getResultList();

        System.out.println("[IBMS-DAO] Transaction history loaded: " + results.size() + " records");
        return results;
    }
}

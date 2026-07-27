<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.*,java.time.format.DateTimeFormatter,com.jsp.ibms.entity.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<div class="app-container">
    <% request.setAttribute("activePage", "dashboard"); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>Dashboard</h2>
            <div class="user-info">
                <span>Welcome, ${name}</span>
                <div class="user-avatar"><%= ((Users)session.getAttribute("user")).getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <%
                Users dashUser = (Users) session.getAttribute("user");
            %>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon gold">&#x1F4B0;</div>
                    <div class="stat-info">
                        <h3>&#x20B9; <%= String.format("%.2f", dashUser.getBal()) %></h3>
                        <p>Current Balance</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">&#x1F4B3;</div>
                    <div class="stat-info">
                        <h3><%= dashUser.getAccountNumber() != null ? dashUser.getAccountNumber() : "N/A" %></h3>
                        <p>Account Number</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue">&#x1F464;</div>
                    <div class="stat-info">
                        <h3><%= dashUser.getName() %></h3>
                        <p>Account Holder</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">&#x2709;</div>
                    <div class="stat-info">
                        <h3 style="font-size:14px;"><%= dashUser.getEmail() %></h3>
                        <p>Email Address</p>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <h3 style="margin-bottom:15px; font-weight:600;">Quick Actions</h3>
            <div class="quick-actions">
                <a href="transaction.jsp" class="quick-action-card">
                    <div class="action-icon">&#x1F4B3;</div>
                    <p>Deposit / Withdraw</p>
                </a>
                <a href="transfer.jsp" class="quick-action-card">
                    <div class="action-icon">&#x1F4B8;</div>
                    <p>Send Money</p>
                </a>
                <a href="billpayment.jsp" class="quick-action-card">
                    <div class="action-icon">&#x1F4C4;</div>
                    <p>Pay Bills</p>
                </a>
                <a href="history" class="quick-action-card">
                    <div class="action-icon">&#x1F4DC;</div>
                    <p>View History</p>
                </a>
            </div>

            <!-- Recent Transactions (Using DATABASE VIEW: v_transaction_history) -->
            <div class="card mt-30">
                <div class="card-header">Recent Transactions</div>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th>From / To</th>
                                <th>Amount</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<?> recentTxView = (List<?>) request.getAttribute("recentTxView");
                            int curUserId = (int) request.getAttribute("currentUserId");

                            if (recentTxView != null && !recentTxView.isEmpty()) {
                                for (Object obj : recentTxView) {
                                    Object[] row = (Object[]) obj;
                                    String txType = row[1] != null ? row[1].toString() : "";
                                    double amt = row[2] != null ? ((Number)row[2]).doubleValue() : 0;
                                    String txDate = "";
                                    if (row[3] != null) {
                                        txDate = row[3].toString();
                                        if (txDate.length() > 16) txDate = txDate.substring(0, 16).replace("T", " ");
                                    }
                                    int senderId = row[4] != null ? ((Number)row[4]).intValue() : 0;
                                    String senderName = row[5] != null ? row[5].toString() : "Unknown";
                                    int receiverId = row[8] != null ? ((Number)row[8]).intValue() : 0;
                                    String receiverName = row[9] != null ? row[9].toString() : "Unknown";

                                    boolean isSelf = (senderId == receiverId);
                                    boolean isIncoming = (receiverId == curUserId && !isSelf);
                                    String badge = isIncoming ? "badge-credit" : "badge-debit";
                                    String label = isIncoming ? "RECEIVED" : isSelf ? txType : "SENT";
                                    String party = isIncoming ? ("From: " + senderName) : isSelf ? "Self" : ("To: " + receiverName);
                        %>
                            <tr>
                                <td><span class="badge <%= badge %>"><%= label %></span></td>
                                <td style="font-size:13px;"><%= party %></td>
                                <td style="font-weight:600; color: <%= isIncoming ? "var(--success)" : "var(--danger)" %>">
                                    <%= isIncoming ? "+" : "-" %> &#x20B9; <%= String.format("%.2f", amt) %>
                                </td>
                                <td class="text-muted" style="font-size:12px;"><%= txDate %></td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="4" class="text-center text-muted" style="padding:30px;">No transactions yet</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <div class="text-center mt-20">
                    <a href="history" class="btn btn-outline btn-sm">View All Transactions</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
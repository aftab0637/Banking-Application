<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.Timestamp,com.jsp.ibms.entity.*" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Transaction History - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
<style>
.tx-party { display: flex; flex-direction: column; gap: 2px; }
.tx-party .party-name { font-weight: 600; font-size: 13px; }
.tx-party .party-acct { font-size: 11px; color: var(--text-secondary); font-family: monospace; }
.tx-arrow { font-size: 16px; }
</style>
</head>
<body>

<div class="app-container">
    <% request.setAttribute("activePage", "history"); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>&#x1F4DC; Transaction History</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= ((Users)session.getAttribute("user")).getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <div class="card fade-in-up">
                <div class="card-header">All Transactions (Loaded from Database VIEW: v_transaction_history)</div>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Type</th>
                                <th>From</th>
                                <th></th>
                                <th>To</th>
                                <th>Amount</th>
                                <th>Date & Time</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            // Data comes from v_transaction_history VIEW
                            // Columns: transaction_id, transaction_type, amount, transaction_date,
                            //          sender_id, sender_name, sender_email, sender_account,
                            //          receiver_id, receiver_name, receiver_email, receiver_account
                            List<?> txHistory = (List<?>) request.getAttribute("txHistory");
                            int currentUserId = (int) request.getAttribute("currentUserId");
                            int count = 0;

                            if (txHistory != null && !txHistory.isEmpty()) {
                                for (Object obj : txHistory) {
                                    Object[] row = (Object[]) obj;
                                    count++;

                                    // Extract data from VIEW columns
                                    String txType = row[1] != null ? row[1].toString() : "";
                                    double amount = row[2] != null ? ((Number) row[2]).doubleValue() : 0;
                                    String txDate = "";
                                    if (row[3] != null) {
                                        txDate = row[3].toString();
                                        // Format: keep only date and time (remove seconds/nanoseconds)
                                        if (txDate.length() > 16) txDate = txDate.substring(0, 16).replace("T", " ");
                                    }

                                    int senderId = row[4] != null ? ((Number) row[4]).intValue() : 0;
                                    String senderName = row[5] != null ? row[5].toString() : "Unknown";
                                    String senderAcct = row[7] != null ? row[7].toString() : "";

                                    int receiverId = row[8] != null ? ((Number) row[8]).intValue() : 0;
                                    String receiverName = row[9] != null ? row[9].toString() : "Unknown";
                                    String receiverAcct = row[11] != null ? row[11].toString() : "";

                                    // Determine if this is money coming IN or going OUT for the current user
                                    boolean isSelfTx = (senderId == receiverId);
                                    boolean isIncoming = (receiverId == currentUserId && !isSelfTx);
                                    String badgeClass = isIncoming ? "badge-credit" : "badge-debit";
                                    String displayType = isIncoming ? "RECEIVED" : isSelfTx ? txType : "SENT";
                        %>
                            <tr>
                                <td><%= count %></td>
                                <td><span class="badge <%= badgeClass %>"><%= displayType %></span></td>
                                <td>
                                    <div class="tx-party">
                                        <span class="party-name"><%= senderName %></span>
                                        <span class="party-acct"><%= senderAcct %></span>
                                    </div>
                                </td>
                                <td class="tx-arrow">&#x27A1;</td>
                                <td>
                                    <div class="tx-party">
                                        <span class="party-name"><%= receiverName %></span>
                                        <span class="party-acct"><%= receiverAcct %></span>
                                    </div>
                                </td>
                                <td style="font-weight:600;">
                                    <span style="color: <%= isIncoming ? "var(--success)" : "var(--danger)" %>">
                                        <%= isIncoming ? "+" : "-" %> &#x20B9; <%= String.format("%.2f", amount) %>
                                    </span>
                                </td>
                                <td class="text-muted"><%= txDate %></td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="7" class="text-center text-muted" style="padding:40px;">
                                    <div style="font-size:40px; margin-bottom:10px;">&#x1F4ED;</div>
                                    No transactions found
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="text-center mt-20">
                <a href="dashboard" class="btn btn-outline btn-sm">Back to Dashboard</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
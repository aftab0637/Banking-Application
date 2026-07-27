<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.jsp.ibms.entity.Users, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Transaction Receipt - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
<style>
.receipt-stamp { display: inline-block; border: 3px solid var(--success); color: var(--success); border-radius: 8px; padding: 4px 16px; font-weight: 700; font-size: 13px; transform: rotate(-5deg); letter-spacing: 2px; margin-bottom: 15px; }
</style>
</head>
<body>

<%
    Users receiptUser = (Users) session.getAttribute("user");
    String txRef = "IBMS" + System.currentTimeMillis();
    String dateTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm:ss a"));
%>

<div class="app-container">
    <% request.setAttribute("activePage", ""); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>&#x1F4CB; Transaction Receipt</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= receiptUser.getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <div class="card receipt-card fade-in-up">
                <div class="receipt-icon">&#x2705;</div>
                <div class="receipt-stamp">VERIFIED</div>
                <h2 style="margin-bottom:5px;">Transaction Successful!</h2>
                <p class="text-muted" style="font-size:13px;">Your transaction has been processed securely</p>

                <div class="receipt-details">
                    <div class="receipt-row">
                        <span class="label">Transaction Ref</span>
                        <span class="value" style="font-family:monospace; font-size:12px;"><%= txRef %></span>
                    </div>
                    <div class="receipt-row">
                        <span class="label">Date and Time</span>
                        <span class="value"><%= dateTime %></span>
                    </div>
                    <div class="receipt-row">
                        <span class="label">Transaction Type</span>
                        <span class="value">${receiptType}</span>
                    </div>
                    <div class="receipt-row">
                        <span class="label">Status</span>
                        <span class="value" style="color: var(--success); font-weight:600;">${receiptStatus}</span>
                    </div>

                    <% if (request.getAttribute("receiptSenderAcct") != null) { %>
                    <div class="receipt-row">
                        <span class="label">From Account</span>
                        <span class="value" style="font-family:monospace;">${receiptSenderAcct}</span>
                    </div>
                    <% } %>

                    <% if (request.getAttribute("receiptReceiverAcct") != null) { %>
                    <div class="receipt-row">
                        <span class="label">To Account</span>
                        <span class="value" style="font-family:monospace;">${receiptReceiverAcct}</span>
                    </div>
                    <% } %>

                    <% if (request.getAttribute("receiptReceiver") != null) { %>
                    <div class="receipt-row">
                        <span class="label">Paid To</span>
                        <span class="value">${receiptReceiver}</span>
                    </div>
                    <% } %>

                    <div class="receipt-row" style="border-bottom:2px solid var(--accent);">
                        <span class="label" style="font-weight:600;">Amount</span>
                        <span class="value" style="font-size:20px; color:var(--accent); font-weight:700;">&#x20B9; ${receiptAmount}</span>
                    </div>

                    <div class="receipt-row">
                        <span class="label">Remaining Balance</span>
                        <span class="value text-success" style="font-weight:600;">&#x20B9; ${receiptBalance}</span>
                    </div>

                    <% if (request.getAttribute("receiptRemarks") != null && !((String)request.getAttribute("receiptRemarks")).isEmpty()) { %>
                    <div class="receipt-row">
                        <span class="label">Remarks</span>
                        <span class="value">${receiptRemarks}</span>
                    </div>
                    <% } %>

                    <div class="receipt-row" style="border-bottom:none;">
                        <span class="label">Security</span>
                        <span class="value" style="color:var(--success);">&#x1F512; OTP Verified</span>
                    </div>
                </div>

                <div style="display:flex; gap:10px; justify-content:center; margin-top:20px; flex-wrap:wrap;">
                    <button onclick="window.print()" class="btn btn-outline btn-sm">&#x1F5A8; Print Receipt</button>
                    <a href="history" class="btn btn-outline btn-sm">&#x1F4DC; View History</a>
                    <a href="dashboard" class="btn btn-primary btn-sm">&#x1F3E0; Dashboard</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>

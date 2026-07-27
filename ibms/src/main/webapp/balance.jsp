<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.jsp.ibms.entity.Users" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Balance - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<div class="app-container">
    <% request.setAttribute("activePage", "balance"); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>Account Balance</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= ((Users)session.getAttribute("user")).getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <%
                Users balUser = (Users) session.getAttribute("user");
            %>
            <div class="card balance-card fade-in-up">
                <div style="font-size:60px; margin-bottom:10px;">&#x1F3E6;</div>
                <h3 style="color:var(--text-secondary); font-weight:400;">Available Balance</h3>
                <div class="balance-amount">
                    <span class="currency">&#x20B9;</span><%= String.format("%.2f", balUser.getBal()) %>
                </div>
                <div style="margin:20px 0;">
                    <p class="text-muted">Account Number: <strong><%= balUser.getAccountNumber() != null ? balUser.getAccountNumber() : "N/A" %></strong></p>
                    <p class="text-muted">Account Holder: <strong><%= balUser.getName() %></strong></p>
                </div>
                <div style="display:flex; gap:10px; justify-content:center; flex-wrap:wrap;">
                    <a href="transaction.jsp" class="btn btn-success btn-sm">Deposit</a>
                    <a href="transfer.jsp" class="btn btn-info btn-sm">Send Money</a>
                    <a href="dashboard" class="btn btn-outline btn-sm">Back to Dashboard</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.jsp.ibms.entity.Users" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bill Payment - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<div class="app-container">
    <% if(request.getAttribute("activePage")==null) request.setAttribute("activePage", "billpayment"); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>Pay Bills</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= ((Users)session.getAttribute("user")).getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <div class="card form-container fade-in-up">
                <div class="card-header" style="text-align:center;">
                    <span style="font-size:32px;">&#x1F4C4;</span>
                    <div>Bill Payment</div>
                </div>

                <div class="text-center mb-20">
                    <p class="text-muted">Available Balance</p>
                    <h2 class="text-success">&#x20B9; ${user.bal}</h2>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">${error}</div>
                <% } %>

                <%-- Form now goes to OTP generation --%>
                <form action="generate-otp" method="post">
                    <input type="hidden" name="txType" value="billpay">
                    <div class="form-group">
                        <label>Bill Type</label>
                        <select name="billType" required>
                            <option value="">-- Select Bill Type --</option>
                            <option value="Electricity">&#x26A1; Electricity</option>
                            <option value="Mobile Recharge">&#x1F4F1; Mobile Recharge</option>
                            <option value="Water">&#x1F4A7; Water</option>
                            <option value="Gas">&#x1F525; Gas</option>
                            <option value="Internet">&#x1F310; Internet / Broadband</option>
                            <option value="DTH">&#x1F4FA; DTH / Cable TV</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Bill / Consumer Number</label>
                        <input type="text" name="billNumber" placeholder="Enter bill number or consumer ID" required>
                    </div>
                    <div class="form-group">
                        <label>Amount (&#x20B9;)</label>
                        <input type="number" name="amount" placeholder="Enter bill amount" step="0.01" min="1" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">&#x1F512; Proceed with OTP Verification</button>
                </form>

                <div class="text-center mt-20">
                    <a href="dashboard" class="btn btn-outline btn-sm">Back to Dashboard</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.jsp.ibms.entity.Users" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Password - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<div class="app-container">
    <% if(request.getAttribute("activePage")==null) request.setAttribute("activePage", "changepassword"); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>Change Password</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= ((Users)session.getAttribute("user")).getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <div class="card form-container fade-in-up">
                <div class="card-header" style="text-align:center;">
                    <span style="font-size:32px;">&#x1F511;</span>
                    <div>Update Your Password</div>
                </div>

                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success">${success}</div>
                <% } %>
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">${error}</div>
                <% } %>

                <form action="changepassword" method="post">
                    <div class="form-group">
                        <label>Current Password</label>
                        <input type="password" name="currentPass" placeholder="Enter current password" required>
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <input type="password" name="newPass" placeholder="Enter new password" required>
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPass" placeholder="Confirm new password" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Change Password</button>
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

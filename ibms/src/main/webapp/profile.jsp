<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.jsp.ibms.entity.Users,java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<div class="app-container">
    <% if(request.getAttribute("activePage")==null) request.setAttribute("activePage", "profile"); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>My Profile</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= ((Users)session.getAttribute("user")).getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <%
                Users profUser = (Users) session.getAttribute("user");
                String createdStr = "";
                if (profUser.getCreatedAt() != null) {
                    createdStr = profUser.getCreatedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a"));
                }
            %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">${success}</div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">${error}</div>
            <% } %>

            <!-- Profile Card -->
            <div class="card fade-in-up" style="max-width:700px;">
                <div class="profile-header">
                    <div class="profile-avatar"><%= profUser.getName().substring(0,1).toUpperCase() %></div>
                    <div class="profile-info">
                        <h3><%= profUser.getName() %></h3>
                        <p><%= profUser.getEmail() %></p>
                    </div>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <label>Account Number</label>
                        <span><%= profUser.getAccountNumber() != null ? profUser.getAccountNumber() : "N/A" %></span>
                    </div>
                    <div class="info-item">
                        <label>Phone Number</label>
                        <span><%= profUser.getPhone() != null ? profUser.getPhone() : "Not Set" %></span>
                    </div>
                    <div class="info-item">
                        <label>Current Balance</label>
                        <span class="text-success" style="font-weight:600;">&#x20B9; <%= String.format("%.2f", profUser.getBal()) %></span>
                    </div>
                    <div class="info-item">
                        <label>Member Since</label>
                        <span><%= createdStr.isEmpty() ? "N/A" : createdStr %></span>
                    </div>
                    <div class="info-item">
                        <label>Email</label>
                        <span><%= profUser.getEmail() %></span>
                    </div>
                    <div class="info-item">
                        <label>Account Type</label>
                        <span>Savings Account</span>
                    </div>
                </div>
            </div>

            <!-- Edit Profile -->
            <div class="card mt-30 fade-in-up" style="max-width:700px;">
                <div class="card-header">Edit Profile</div>
                <form action="profile" method="post">
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="name" value="<%= profUser.getName() %>" required>
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="phone" value="<%= profUser.getPhone() != null ? profUser.getPhone() : "" %>" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Update Profile</button>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>

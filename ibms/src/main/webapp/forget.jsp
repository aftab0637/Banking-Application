<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reset Password - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-brand">
        <h1>IBMS Bank</h1>
        <p>Reset your password securely</p>
        <div class="brand-features">
            <div class="feature">
                <div class="feature-icon">&#x1F511;</div>
                <span>Secure Password Reset</span>
            </div>
            <div class="feature">
                <div class="feature-icon">&#x1F512;</div>
                <span>BCrypt Encrypted Storage</span>
            </div>
        </div>
    </div>

    <div class="auth-form-side">
        <div class="auth-card">
            <h2>Reset Password</h2>
            <p class="subtitle">Enter your email and new password</p>

            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-danger">${message}</div>
            <% } %>

            <form action="forget" method="post">
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" placeholder="Enter your registered email" required>
                </div>
                <div class="form-group">
                    <label>New Password</label>
                    <input type="password" name="pass" placeholder="Enter new password" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Reset Password</button>
            </form>

            <div class="auth-links" style="margin-top:20px;">
                <p>Remember your password? <a href="login.jsp">Sign In</a></p>
            </div>
        </div>
    </div>
</div>

</body>
</html>
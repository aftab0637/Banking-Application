<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-brand">
        <h1>IBMS Bank</h1>
        <p>Your trusted partner for secure and seamless internet banking</p>
        <div class="brand-features">
            <div class="feature">
                <div class="feature-icon">&#x1F512;</div>
                <span>Secure Encrypted Banking</span>
            </div>
            <div class="feature">
                <div class="feature-icon">&#x26A1;</div>
                <span>Instant Fund Transfers</span>
            </div>
            <div class="feature">
                <div class="feature-icon">&#x1F4CA;</div>
                <span>Real-time Transaction Tracking</span>
            </div>
        </div>
    </div>

    <div class="auth-form-side">
        <div class="auth-card">
            <h2>Welcome Back</h2>
            <p class="subtitle">Sign in to your account</p>

            <%-- Success message after registration --%>
            <% if ("true".equals(request.getParameter("registered"))) { %>
                <div class="alert alert-success">
                    &#x2705; Account Created Successfully!<br>
                    <strong>Your Account No:</strong> <%= request.getParameter("account") %><br>
                    <small>Please save your account number. You can now sign in.</small>
                </div>
            <% } %>

            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-danger">${message}</div>
            <% } %>

            <form action="login" method="post">
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <div class="password-wrapper">
                        <input type="password" name="pass" id="loginPass" placeholder="Enter your password" required>
                        <span class="toggle-password" onclick="togglePassword('loginPass', this)">&#x1F441;</span>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Sign In</button>
            </form>

            <div class="auth-links" style="margin-top:20px;">
                <p><a href="forget.jsp">Forgot Password?</a></p>
                <p style="margin-top:10px;">Don't have an account? <a href="register.jsp">Create Account</a></p>
            </div>
        </div>
    </div>
</div>

<script>
function togglePassword(fieldId, icon) {
    var field = document.getElementById(fieldId);
    if (field.type === 'password') {
        field.type = 'text';
        icon.innerHTML = '&#x1F576;';
    } else {
        field.type = 'password';
        icon.innerHTML = '&#x1F441;';
    }
}
</script>

</body>
</html>
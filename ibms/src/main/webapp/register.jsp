<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-brand">
        <h1>IBMS Bank</h1>
        <p>Open your account in minutes and start banking instantly</p>
        <div class="brand-features">
            <div class="feature">
                <div class="feature-icon">&#x1F4B0;</div>
                <span>Get &#x20B9;1000 Welcome Balance</span>
            </div>
            <div class="feature">
                <div class="feature-icon">&#x1F4B3;</div>
                <span>Unique Account Number</span>
            </div>
            <div class="feature">
                <div class="feature-icon">&#x1F680;</div>
                <span>Instant Account Activation</span>
            </div>
        </div>
    </div>

    <div class="auth-form-side">
        <div class="auth-card">
            <h2>Create Account</h2>
            <p class="subtitle">Fill in your details to get started</p>

            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-danger">${message}</div>
            <% } %>

            <form action="reg" method="post" onsubmit="return validateForm()">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" id="name" placeholder="Enter your full name" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" id="email" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" id="phone" placeholder="Enter your phone number" pattern="[0-9]{10}" title="Enter 10-digit phone number" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <div class="password-wrapper">
                        <input type="password" name="pass" id="pass" placeholder="Create a password (min 4 chars)" minlength="4" required>
                        <span class="toggle-password" onclick="togglePassword('pass', this)">&#x1F441;</span>
                    </div>
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <div class="password-wrapper">
                        <input type="password" name="confirmPass" id="confirmPass" placeholder="Re-enter your password" required>
                        <span class="toggle-password" onclick="togglePassword('confirmPass', this)">&#x1F441;</span>
                    </div>
                    <span id="passError" class="field-error"></span>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Create Account</button>
            </form>

            <div class="auth-links" style="margin-top:20px;">
                <p>Already have an account? <a href="login.jsp">Sign In</a></p>
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

function validateForm() {
    var pass = document.getElementById('pass').value;
    var confirmPass = document.getElementById('confirmPass').value;
    var errorSpan = document.getElementById('passError');

    if (pass !== confirmPass) {
        errorSpan.textContent = 'Passwords do not match!';
        errorSpan.style.display = 'block';
        return false;
    }
    if (pass.length < 4) {
        errorSpan.textContent = 'Password must be at least 4 characters!';
        errorSpan.style.display = 'block';
        return false;
    }
    errorSpan.style.display = 'none';
    return true;
}

// Real-time password match check
document.getElementById('confirmPass').addEventListener('input', function() {
    var pass = document.getElementById('pass').value;
    var errorSpan = document.getElementById('passError');
    if (this.value && this.value !== pass) {
        errorSpan.textContent = 'Passwords do not match!';
        errorSpan.style.display = 'block';
    } else {
        errorSpan.style.display = 'none';
    }
});
</script>

</body>
</html>
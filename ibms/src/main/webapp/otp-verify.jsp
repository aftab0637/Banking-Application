<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.jsp.ibms.entity.Users" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OTP Verification - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
<style>
.otp-container { max-width: 500px; margin: 0 auto; text-align: center; }
.otp-icon { font-size: 60px; margin-bottom: 10px; }
.otp-display {
    background: linear-gradient(135deg, #1a1a2e, #16213e);
    border: 2px dashed var(--primary);
    border-radius: 12px;
    padding: 20px;
    margin: 20px 0;
    color: var(--primary);
}
.otp-code {
    font-size: 36px;
    font-weight: 700;
    letter-spacing: 12px;
    color: var(--primary);
    font-family: 'Courier New', monospace;
}
.otp-input {
    font-size: 24px !important;
    text-align: center !important;
    letter-spacing: 8px !important;
    font-weight: 600 !important;
    padding: 15px !important;
}
.otp-timer {
    color: var(--danger);
    font-size: 14px;
    margin-top: 10px;
    font-weight: 500;
}
.sim-note {
    background: rgba(201,162,39,0.1);
    border-left: 4px solid var(--primary);
    padding: 12px 15px;
    border-radius: 0 8px 8px 0;
    font-size: 13px;
    text-align: left;
    margin: 15px 0;
}
</style>
</head>
<body>

<div class="app-container">
    <% request.setAttribute("activePage", ""); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>&#x1F512; OTP Verification</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= ((Users)session.getAttribute("user")).getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <div class="card otp-container fade-in-up">
                <div class="otp-icon">&#x1F512;</div>
                <h2>Transaction Verification</h2>
                <p class="text-muted">Enter the OTP to confirm your transaction</p>


                <%-- Display OTP (simulating SMS) --%>
                <div class="otp-display">
                    <p style="margin:0 0 8px 0; font-size:13px; color:#aaa;">Your One-Time Password</p>
                    <div class="otp-code">${otpGenerated}</div>
                </div>

                <div style="background:rgba(255,255,255,0.05); border-radius:8px; padding:12px; margin-bottom:15px;">
                    <p class="text-muted" style="margin:0;">Transaction Amount: <strong style="color:var(--success); font-size:18px;">&#x20B9; ${amount}</strong></p>
                </div>

                <% if (request.getAttribute("otpError") != null) { %>
                    <div class="alert alert-danger">${otpError}</div>
                <% } %>

                <form action="verify-otp" method="post">
                    <div class="form-group">
                        <label>Enter 6-Digit OTP</label>
                        <input type="text" name="otp" class="otp-input" maxlength="6" pattern="[0-9]{6}" 
                               placeholder="______" required autofocus>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">&#x2705; Verify & Confirm Transaction</button>
                </form>

                <div class="otp-timer" id="timer">OTP expires in: <span id="countdown">5:00</span></div>

                <div class="text-center mt-20">
                    <a href="dashboard" class="btn btn-outline btn-sm">Cancel Transaction</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Countdown timer for OTP expiry (5 minutes)
var timeLeft = 300; // 5 minutes in seconds
var timerEl = document.getElementById('countdown');

var countdown = setInterval(function() {
    timeLeft--;
    var minutes = Math.floor(timeLeft / 60);
    var seconds = timeLeft % 60;
    timerEl.textContent = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
    
    if (timeLeft <= 0) {
        clearInterval(countdown);
        timerEl.textContent = 'EXPIRED';
        timerEl.style.color = 'red';
        document.querySelector('form button').disabled = true;
        document.querySelector('form button').textContent = 'OTP Expired - Go Back';
    }
    
    if (timeLeft <= 60) {
        timerEl.style.color = '#e74c3c';
    }
}, 1000);
</script>

</body>
</html>

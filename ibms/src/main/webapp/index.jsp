<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>IBMS Bank - Secure Internet Banking</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<!-- Navigation -->
<nav class="landing-nav">
    <div class="logo">IBMS <span>Bank</span></div>
    <div class="nav-links">
        <a href="#features">Features</a>
        <a href="#about">About</a>
        <a href="login.jsp" class="btn btn-outline btn-sm">Login</a>
        <a href="register.jsp" class="btn btn-primary btn-sm">Open Account</a>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-content">
        <h1>Banking Made <span class="highlight">Simple</span> & <span class="highlight">Secure</span></h1>
        <p>Experience the future of banking with IBMS. Manage your finances, transfer money, pay bills, and track transactions — all from one secure platform.</p>
        <div class="hero-buttons">
            <a href="register.jsp" class="btn btn-primary btn-lg">Get Started Free</a>
            <a href="login.jsp" class="btn btn-outline btn-lg">Sign In</a>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features-section" id="features">
    <div class="section-title">
        <h2>Why Choose IBMS Bank?</h2>
        <p>Everything you need for modern banking, in one place</p>
    </div>
    <div class="features-grid">
        <div class="feature-card">
            <div class="feat-icon">&#x1F512;</div>
            <h3>Secure Banking</h3>
            <p>Bank-grade encryption with BCrypt password hashing ensures your data is always protected.</p>
        </div>
        <div class="feature-card">
            <div class="feat-icon">&#x1F4B8;</div>
            <h3>Instant Transfers</h3>
            <p>Send money to anyone instantly using just their email. Fast, simple, and reliable.</p>
        </div>
        <div class="feature-card">
            <div class="feat-icon">&#x1F4B3;</div>
            <h3>Easy Deposits & Withdrawals</h3>
            <p>Deposit or withdraw funds with just a few clicks. Your money, your control.</p>
        </div>
        <div class="feature-card">
            <div class="feat-icon">&#x1F4C4;</div>
            <h3>Bill Payments</h3>
            <p>Pay electricity, mobile, water, and gas bills directly from your account.</p>
        </div>
        <div class="feature-card">
            <div class="feat-icon">&#x1F4DC;</div>
            <h3>Transaction History</h3>
            <p>View detailed transaction history with timestamps. Stay on top of your finances.</p>
        </div>
        <div class="feature-card">
            <div class="feat-icon">&#x1F465;</div>
            <h3>Beneficiary Management</h3>
            <p>Save frequent recipients for quick and easy money transfers every time.</p>
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="stats-section" id="about">
    <div class="section-title" style="margin-bottom:40px;">
        <h2 style="color:white;">Trusted by Thousands</h2>
    </div>
    <div class="stats-row">
        <div class="stat-item">
            <h3>10,000+</h3>
            <p>Active Users</p>
        </div>
        <div class="stat-item">
            <h3>50,000+</h3>
            <p>Transactions</p>
        </div>
        <div class="stat-item">
            <h3>99.9%</h3>
            <p>Uptime</p>
        </div>
        <div class="stat-item">
            <h3>24/7</h3>
            <p>Support</p>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="landing-footer">
    <p>&copy; 2025 IBMS Bank. All rights reserved. | Internet Banking Management System</p>
</footer>

</body>
</html>

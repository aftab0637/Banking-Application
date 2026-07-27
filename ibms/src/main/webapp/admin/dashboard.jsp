<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.util.*,java.time.format.DateTimeFormatter,com.jsp.ibms.entity.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../css/shared-style.css">
</head>
<body>

<div class="app-container">
    <% request.setAttribute("activePage", "admin"); %>
    <div class="sidebar">
        <div class="sidebar-brand">
            <h2>IBMS BANK</h2>
            <p>Admin Panel</p>
        </div>
        <nav class="sidebar-nav">
            <a href="../dashboard"><span class="nav-icon">&#x1F4CA;</span> <span>User Dashboard</span></a>
            <a href="dashboard" class="active"><span class="nav-icon">&#x1F6E1;</span> <span>Admin Panel</span></a>
            <div class="nav-divider"></div>
        </nav>
        <div class="sidebar-footer">
            <a href="../logout"><span class="nav-icon">&#x1F6AA;</span> <span>Logout</span></a>
        </div>
    </div>

    <div class="main-content">
        <div class="topbar">
            <h2>&#x1F6E1; Admin Dashboard</h2>
            <div class="user-info">
                <span>Admin</span>
                <div class="user-avatar" style="background:linear-gradient(135deg,var(--danger),#c0392b);">A</div>
            </div>
        </div>

        <div class="content-area">
            <%
                Long totalUsers = (Long) request.getAttribute("totalUsers");
                Long totalTransactions = (Long) request.getAttribute("totalTransactions");
                Double totalBalance = (Double) request.getAttribute("totalBalance");
            %>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">&#x1F465;</div>
                    <div class="stat-info">
                        <h3><%= totalUsers != null ? totalUsers : 0 %></h3>
                        <p>Total Users</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">&#x1F4B3;</div>
                    <div class="stat-info">
                        <h3><%= totalTransactions != null ? totalTransactions : 0 %></h3>
                        <p>Total Transactions</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon gold">&#x1F4B0;</div>
                    <div class="stat-info">
                        <h3>&#x20B9; <%= totalBalance != null ? String.format("%.2f", totalBalance) : "0.00" %></h3>
                        <p>Total Balance (All Users)</p>
                    </div>
                </div>
            </div>

            <!-- All Users -->
            <div class="card mb-30 fade-in-up">
                <div class="card-header">All Registered Users</div>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Account No.</th>
                                <th>Balance</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Users> allUsers = (List<Users>) request.getAttribute("allUsers");
                            if (allUsers != null && !allUsers.isEmpty()) {
                                for (Users u : allUsers) {
                        %>
                            <tr>
                                <td><%= u.getId() %></td>
                                <td style="font-weight:500;"><%= u.getName() %></td>
                                <td><%= u.getEmail() %></td>
                                <td><%= u.getPhone() != null ? u.getPhone() : "-" %></td>
                                <td><%= u.getAccountNumber() != null ? u.getAccountNumber() : "-" %></td>
                                <td class="text-success" style="font-weight:600;">&#x20B9; <%= String.format("%.2f", u.getBal()) %></td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="6" class="text-center text-muted" style="padding:30px;">No users found</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Recent Transactions -->
            <div class="card fade-in-up">
                <div class="card-header">Recent Transactions (Last 20)</div>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Sender ID</th>
                                <th>Receiver ID</th>
                                <th>Type</th>
                                <th>Amount</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<BankTransaction> recentTx = (List<BankTransaction>) request.getAttribute("recentTx");
                            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");

                            if (recentTx != null && !recentTx.isEmpty()) {
                                for (BankTransaction tx : recentTx) {
                                    String badgeClass = "DEBIT".equals(tx.getType()) ? "badge-debit" : "badge-credit";
                                    String dateStr = tx.getTransactionTime() != null ? tx.getTransactionTime().format(fmt) : "";
                        %>
                            <tr>
                                <td><%= tx.getId() %></td>
                                <td><%= tx.getSenderId() %></td>
                                <td><%= tx.getReceiverId() %></td>
                                <td><span class="badge <%= badgeClass %>"><%= tx.getType() %></span></td>
                                <td style="font-weight:500;">&#x20B9; <%= String.format("%.2f", tx.getAmount()) %></td>
                                <td class="text-muted"><%= dateStr %></td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="6" class="text-center text-muted" style="padding:30px;">No transactions yet</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>

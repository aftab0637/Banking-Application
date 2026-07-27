<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.util.*,java.time.format.DateTimeFormatter,com.jsp.ibms.entity.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Audit Log - IBMS Bank</title>
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
            <a href="dashboard"><span class="nav-icon">&#x1F6E1;</span> <span>Admin Panel</span></a>
            <a href="../auditlog" class="active"><span class="nav-icon">&#x1F4DD;</span> <span>Audit Log</span></a>
            <div class="nav-divider"></div>
        </nav>
        <div class="sidebar-footer">
            <a href="../logout"><span class="nav-icon">&#x1F6AA;</span> <span>Logout</span></a>
        </div>
    </div>

    <div class="main-content">
        <div class="topbar">
            <h2>&#x1F4DD; Audit Log (Created by Database Triggers)</h2>
            <div class="user-info">
                <span>Admin</span>
                <div class="user-avatar" style="background:linear-gradient(135deg,var(--danger),#c0392b);">A</div>
            </div>
        </div>

        <div class="content-area">
            <div class="alert" style="background:rgba(201,162,39,0.1); border-left:4px solid var(--primary); padding:15px; border-radius:8px; margin-bottom:20px;">
                <strong>&#x1F4A1; How This Works:</strong> These log entries are created automatically by a 
                <strong>DATABASE TRIGGER</strong> (trg_audit_balance_change). Every time a user's balance changes, 
                the trigger fires and inserts a record here. No Java code is involved in creating these logs!
            </div>

            <div class="card fade-in-up">
                <div class="card-header">Balance Change Audit Trail</div>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>User Email</th>
                                <th>Action</th>
                                <th>Old Balance</th>
                                <th>New Balance</th>
                                <th>Change</th>
                                <th>Date & Time</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<AuditLog> auditLogs = (List<AuditLog>) request.getAttribute("auditLogs");
                            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");

                            if (auditLogs != null && !auditLogs.isEmpty()) {
                                int idx = 0;
                                for (AuditLog log : auditLogs) {
                                    idx++;
                                    String badgeClass = "CREDIT".equals(log.getAction()) ? "badge-credit" : "badge-debit";
                                    String dateStr = log.getPerformedat() != null ? log.getPerformedat().format(fmt) : "";
                        %>
                            <tr>
                                <td><%= idx %></td>
                                <td><%= log.getUseremail() != null ? log.getUseremail() : "N/A" %></td>
                                <td><span class="badge <%= badgeClass %>"><%= log.getAction() %></span></td>
                                <td>&#x20B9; <%= String.format("%.2f", log.getOldbalance()) %></td>
                                <td>&#x20B9; <%= String.format("%.2f", log.getNewbalance()) %></td>
                                <td style="font-weight:600;">&#x20B9; <%= String.format("%.2f", log.getChangeamount()) %></td>
                                <td class="text-muted"><%= dateStr %></td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="7" class="text-center text-muted" style="padding:40px;">
                                    <div style="font-size:40px; margin-bottom:10px;">&#x1F4DD;</div>
                                    No audit records yet. Perform a transaction to see trigger-generated logs here.
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="text-center mt-20">
                <a href="dashboard" class="btn btn-outline btn-sm">Back to Admin Dashboard</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>

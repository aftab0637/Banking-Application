<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.util.*,java.time.format.DateTimeFormatter,com.jsp.ibms.entity.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Beneficiaries - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
</head>
<body>

<div class="app-container">
    <% if(request.getAttribute("activePage")==null) request.setAttribute("activePage", "beneficiary"); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>Beneficiaries</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= ((Users)session.getAttribute("user")).getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">${error}</div>
            <% } %>

            <!-- Add Beneficiary Form -->
            <div class="card fade-in-up mb-30">
                <div class="card-header">Add New Beneficiary</div>
                <form action="beneficiary" method="post">
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Beneficiary Name</label>
                            <input type="text" name="name" placeholder="Enter name" required>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" placeholder="Enter email" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Account Number (Optional)</label>
                        <input type="text" name="accountNumber" placeholder="Enter account number">
                    </div>
                    <button type="submit" class="btn btn-primary">Add Beneficiary</button>
                </form>
            </div>

            <!-- Beneficiaries List -->
            <div class="card fade-in-up">
                <div class="card-header">Saved Beneficiaries</div>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Account Number</th>
                                <th>Added On</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Beneficiary> beneficiaries = (List<Beneficiary>) request.getAttribute("beneficiaries");
                            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                            int idx = 0;

                            if (beneficiaries != null && !beneficiaries.isEmpty()) {
                                for (Beneficiary b : beneficiaries) {
                                    idx++;
                                    String dateStr = b.getAddedAt() != null ? b.getAddedAt().format(fmt) : "";
                        %>
                            <tr>
                                <td><%= idx %></td>
                                <td style="font-weight:500;"><%= b.getName() %></td>
                                <td><%= b.getEmail() %></td>
                                <td><%= b.getAccountNumber() != null && !b.getAccountNumber().isEmpty() ? b.getAccountNumber() : "-" %></td>
                                <td class="text-muted"><%= dateStr %></td>
                                <td>
                                    <form action="deletebeneficiary" method="post" style="display:inline;">
                                        <input type="hidden" name="id" value="<%= b.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Delete this beneficiary?')">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="6" class="text-center text-muted" style="padding:40px;">
                                    <div style="font-size:40px; margin-bottom:10px;">&#x1F465;</div>
                                    No beneficiaries saved yet
                                </td>
                            </tr>
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

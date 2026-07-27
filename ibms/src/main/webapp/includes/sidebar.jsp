<%@ page isELIgnored="false" %>
<%@ page import="com.jsp.ibms.entity.Users" %>
<%
    Users sidebarUser = (Users) session.getAttribute("user");
    String userInitial = "";
    if (sidebarUser != null && sidebarUser.getName() != null && !sidebarUser.getName().isEmpty()) {
        userInitial = sidebarUser.getName().substring(0, 1).toUpperCase();
    }
    String activeP = (String) request.getAttribute("activePage");
    if (activeP == null) activeP = "";
%>
<div class="sidebar">
    <div class="sidebar-brand">
        <h2>IBMS BANK</h2>
        <p>Secure Banking</p>
    </div>
    <nav class="sidebar-nav">
        <a href="dashboard" class="<%= "dashboard".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F4CA;</span> <span>Dashboard</span>
        </a>
        <a href="profile" class="<%= "profile".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F464;</span> <span>My Profile</span>
        </a>
        <a href="balance" class="<%= "balance".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F4B0;</span> <span>View Balance</span>
        </a>
        <div class="nav-divider"></div>
        <a href="transaction.jsp" class="<%= "transaction".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F4B3;</span> <span>Deposit / Withdraw</span>
        </a>
        <a href="transfer.jsp" class="<%= "transfer".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F4B8;</span> <span>Send Money</span>
        </a>
        <a href="billpayment.jsp" class="<%= "billpayment".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F4C4;</span> <span>Pay Bills</span>
        </a>
        <div class="nav-divider"></div>
        <a href="beneficiary" class="<%= "beneficiary".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F465;</span> <span>Beneficiaries</span>
        </a>
        <a href="history" class="<%= "history".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F4DC;</span> <span>Transaction History</span>
        </a>
        <a href="changepassword.jsp" class="<%= "changepassword".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F511;</span> <span>Change Password</span>
        </a>
        <% if (sidebarUser != null && "ADMIN".equals(sidebarUser.getRole())) { %>
        <div class="nav-divider"></div>
        <a href="admin/dashboard" class="<%= "admin".equals(activeP) ? "active" : "" %>">
            <span class="nav-icon">&#x1F6E1;</span> <span>Admin Panel</span>
        </a>
        <% } %>
    </nav>
    <div class="sidebar-footer">
        <a href="logout">
            <span class="nav-icon">&#x1F6AA;</span> <span>Logout</span>
        </a>
    </div>
</div>

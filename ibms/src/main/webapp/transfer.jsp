<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.jsp.ibms.entity.Users" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Send Money - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
<style>
.transfer-method-tabs { display: flex; gap: 0; margin-bottom: 25px; border-radius: var(--radius-sm); overflow: hidden; border: 2px solid var(--accent); }
.transfer-method-tab { flex: 1; padding: 12px; text-align: center; cursor: pointer; font-weight: 500; font-size: 13px; transition: var(--transition); background: var(--bg-card); color: var(--text-primary); }
.transfer-method-tab.active { background: linear-gradient(135deg, var(--accent), var(--accent-hover)); color: #fff; }
.transfer-method-tab:hover:not(.active) { background: rgba(201,162,39,0.1); }
.transfer-section { display: none; }
.transfer-section.active { display: block; }
.acct-display { background: var(--bg-main); border-radius: var(--radius-sm); padding: 12px 16px; margin-bottom: 15px; }
.acct-display .label { font-size: 11px; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.5px; }
.acct-display .value { font-size: 16px; font-weight: 600; color: var(--text-primary); letter-spacing: 1px; }
.lookup-result { background: rgba(39,174,96,0.08); border: 1px solid rgba(39,174,96,0.2); border-radius: var(--radius-sm); padding: 12px 16px; margin-bottom: 15px; display: none; }
.lookup-result.error { background: rgba(231,76,60,0.08); border-color: rgba(231,76,60,0.2); }
.lookup-result .name { font-weight: 600; color: var(--success); }
.lookup-result.error .name { color: var(--danger); }
</style>
</head>
<body>

<%
    Users tfUser = (Users) session.getAttribute("user");
    String tfAcctNum = tfUser != null ? tfUser.getAccountNumber() : "";
%>

<div class="app-container">
    <% if(request.getAttribute("activePage")==null) request.setAttribute("activePage", "transfer"); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>&#x1F4B8; Send Money</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= tfUser.getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <div class="card form-container fade-in-up" style="max-width:550px;">
                <div class="card-header" style="text-align:center;">
                    <span style="font-size:32px;">&#x1F4B8;</span>
                    <div>Fund Transfer</div>
                </div>

                <%-- Sender Account Info --%>
                <div class="acct-display">
                    <div class="label">From Account</div>
                    <div class="value"><%= tfAcctNum %> (${name})</div>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">${error}</div>
                <% } %>

                <%-- Transfer Method Tabs --%>
                <div class="transfer-method-tabs">
                    <div class="transfer-method-tab active" onclick="switchTransferMode('account')">&#x1F4B3; By Account No.</div>
                    <div class="transfer-method-tab" onclick="switchTransferMode('email')">&#x1F4E7; By Email</div>
                </div>

                <%-- BY ACCOUNT NUMBER (Primary) --%>
                <div id="account-section" class="transfer-section active">
                    <form action="generate-otp" method="post" id="accountTransferForm">
                        <input type="hidden" name="txType" value="transfer">
                        <input type="hidden" name="transferMode" value="account">

                        <div class="form-group">
                            <label>Beneficiary Account Number</label>
                            <input type="text" name="accountNumber" id="receiverAcctNum" placeholder="Enter 10-digit account number" pattern="[0-9]{10}" title="Enter 10-digit account number" required onblur="lookupAccount()">
                        </div>

                        <div id="accountLookupResult" class="lookup-result">
                            <span class="name" id="accountHolderName"></span>
                        </div>

                        <div class="form-group">
                            <label>IFSC Code</label>
                            <input type="text" name="ifscCode" value="IBMS0001234" placeholder="IBMS0001234" readonly style="background: #f0f0f0;">
                            <small class="text-muted" style="font-size:11px;">IBMS Bank internal transfers use unified IFSC</small>
                        </div>

                        <div class="form-group">
                            <label>Amount (&#x20B9;)</label>
                            <input type="number" name="amount" placeholder="Enter amount" step="0.01" min="1" required>
                        </div>

                        <div class="form-group">
                            <label>Remarks (Optional)</label>
                            <input type="text" name="remarks" placeholder="e.g., Rent, EMI, Payment for...">
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">&#x1F512; Proceed to OTP Verification</button>
                    </form>
                </div>

                <%-- BY EMAIL (Quick Transfer) --%>
                <div id="email-section" class="transfer-section">
                    <form action="generate-otp" method="post" id="emailTransferForm">
                        <input type="hidden" name="txType" value="transfer">
                        <input type="hidden" name="transferMode" value="email">

                        <div class="form-group">
                            <label>Receiver's Email Address</label>
                            <input type="email" name="email" placeholder="Enter receiver's registered email" required>
                        </div>

                        <div class="form-group">
                            <label>Amount (&#x20B9;)</label>
                            <input type="number" name="amount" placeholder="Enter amount" step="0.01" min="1" required>
                        </div>

                        <div class="form-group">
                            <label>Remarks (Optional)</label>
                            <input type="text" name="remarks" placeholder="e.g., Rent, EMI, Payment for...">
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">&#x1F512; Proceed to OTP Verification</button>
                    </form>
                </div>

                <div class="text-center mt-20" style="display:flex; gap:10px; justify-content:center;">
                    <a href="beneficiary" class="btn btn-outline btn-sm">&#x1F465; My Beneficiaries</a>
                    <a href="history" class="btn btn-outline btn-sm">&#x1F4DC; History</a>
                    <a href="dashboard" class="btn btn-outline btn-sm">Dashboard</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function switchTransferMode(mode) {
    document.querySelectorAll('.transfer-method-tab').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.transfer-section').forEach(s => s.classList.remove('active'));

    if (mode === 'account') {
        document.querySelectorAll('.transfer-method-tab')[0].classList.add('active');
        document.getElementById('account-section').classList.add('active');
    } else {
        document.querySelectorAll('.transfer-method-tab')[1].classList.add('active');
        document.getElementById('email-section').classList.add('active');
    }
}

function lookupAccount() {
    var acctNum = document.getElementById('receiverAcctNum').value.trim();
    var resultDiv = document.getElementById('accountLookupResult');
    var nameSpan = document.getElementById('accountHolderName');

    if (acctNum.length !== 10) {
        resultDiv.style.display = 'none';
        return;
    }

    // AJAX call to lookup account holder name
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'lookup-account?accountNumber=' + acctNum, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            resultDiv.style.display = 'block';
            if (xhr.status === 200 && xhr.responseText && xhr.responseText !== 'NOT_FOUND') {
                resultDiv.className = 'lookup-result';
                nameSpan.textContent = '✅ Account Holder: ' + xhr.responseText;
            } else {
                resultDiv.className = 'lookup-result error';
                nameSpan.textContent = '❌ No account found with this number';
            }
        }
    };
    xhr.send();
}
</script>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.jsp.ibms.entity.Users" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Deposit / Withdraw - IBMS Bank</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/shared-style.css">
<style>
.mode-tabs { display: flex; gap: 0; margin-bottom: 25px; border-radius: var(--radius-sm); overflow: hidden; border: 2px solid var(--accent); }
.mode-tab { flex: 1; padding: 14px; text-align: center; cursor: pointer; font-weight: 600; font-size: 14px; transition: var(--transition); background: var(--bg-card); color: var(--text-primary); }
.mode-tab.active { background: linear-gradient(135deg, var(--accent), var(--accent-hover)); color: #fff; }
.mode-tab:hover:not(.active) { background: rgba(201,162,39,0.1); }
.sub-type-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; }
.sub-type-card { padding: 15px; border: 2px solid var(--border); border-radius: var(--radius-sm); cursor: pointer; text-align: center; transition: var(--transition); }
.sub-type-card:hover { border-color: var(--accent); background: rgba(201,162,39,0.05); }
.sub-type-card.selected { border-color: var(--accent); background: rgba(201,162,39,0.1); }
.sub-type-card .st-icon { font-size: 24px; margin-bottom: 5px; }
.sub-type-card .st-label { font-size: 12px; font-weight: 500; color: var(--text-primary); }
.mode-section { display: none; }
.mode-section.active { display: block; }
.acct-display { background: var(--bg-main); border-radius: var(--radius-sm); padding: 12px 16px; margin-bottom: 15px; }
.acct-display .label { font-size: 11px; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.5px; }
.acct-display .value { font-size: 16px; font-weight: 600; color: var(--text-primary); letter-spacing: 1px; }
</style>
</head>
<body>

<%
    Users txUser = (Users) session.getAttribute("user");
    String acctNum = txUser != null ? txUser.getAccountNumber() : "";
%>

<div class="app-container">
    <% if(request.getAttribute("activePage")==null) request.setAttribute("activePage", "transaction"); %>
    <%@ include file="includes/sidebar.jsp" %>

    <div class="main-content">
        <div class="topbar">
            <h2>&#x1F4B3; Deposit / Withdraw</h2>
            <div class="user-info">
                <span>${name}</span>
                <div class="user-avatar"><%= txUser.getName().substring(0,1).toUpperCase() %></div>
            </div>
        </div>

        <div class="content-area">
            <div class="card form-container fade-in-up" style="max-width:550px;">

                <%-- Account Info --%>
                <div class="acct-display">
                    <div class="label">Your Account Number</div>
                    <div class="value"><%= acctNum %></div>
                </div>

                <div style="text-align:center; margin-bottom:20px;">
                    <p class="text-muted">Available Balance</p>
                    <h2 class="text-success">&#x20B9; ${user.bal}</h2>
                </div>

                <% if (request.getAttribute("message") != null) { %>
                    <div class="alert alert-danger">${message}</div>
                <% } %>

                <%-- Deposit / Withdraw Tabs --%>
                <div class="mode-tabs">
                    <div class="mode-tab active" onclick="switchMode('deposit')">&#x2B06; Deposit</div>
                    <div class="mode-tab" onclick="switchMode('withdraw')">&#x2B07; Withdraw</div>
                </div>

                <%-- DEPOSIT SECTION --%>
                <div id="deposit-section" class="mode-section active">
                    <form action="generate-otp" method="post" id="depositForm">
                        <input type="hidden" name="txType" value="transaction">
                        <input type="hidden" name="type" value="deposit">
                        <input type="hidden" name="subType" id="depositSubType" value="Cash Deposit">

                        <p style="font-size:13px; font-weight:500; margin-bottom:10px;">Deposit Method</p>
                        <div class="sub-type-grid">
                            <div class="sub-type-card selected" onclick="selectSubType('deposit', 'Cash Deposit', this)">
                                <div class="st-icon">&#x1F4B5;</div>
                                <div class="st-label">Cash Deposit</div>
                            </div>
                            <div class="sub-type-card" onclick="selectSubType('deposit', 'Cheque Deposit', this)">
                                <div class="st-icon">&#x1F4DD;</div>
                                <div class="st-label">Cheque Deposit</div>
                            </div>
                            <div class="sub-type-card" onclick="selectSubType('deposit', 'NEFT Transfer In', this)">
                                <div class="st-icon">&#x1F3E6;</div>
                                <div class="st-label">NEFT Transfer In</div>
                            </div>
                            <div class="sub-type-card" onclick="selectSubType('deposit', 'Refund / Reversal', this)">
                                <div class="st-icon">&#x1F504;</div>
                                <div class="st-label">Refund / Reversal</div>
                            </div>
                        </div>

                        <div id="deposit-cheque-field" style="display:none;" class="form-group">
                            <label>Cheque Number</label>
                            <input type="text" name="chequeNumber" placeholder="Enter cheque number">
                        </div>
                        <div id="deposit-neft-field" style="display:none;" class="form-group">
                            <label>Sender's Account / Reference</label>
                            <input type="text" name="senderRef" placeholder="External account or reference number">
                        </div>

                        <div class="form-group">
                            <label>Amount (&#x20B9;)</label>
                            <input type="number" name="amount" placeholder="Enter deposit amount" step="0.01" min="1" required>
                        </div>
                        <div class="form-group">
                            <label>Remarks (Optional)</label>
                            <input type="text" name="remarks" placeholder="e.g., Salary, Gift, etc.">
                        </div>
                        <button type="submit" class="btn btn-success btn-block">&#x1F512; Proceed to OTP Verification</button>
                    </form>
                </div>

                <%-- WITHDRAW SECTION --%>
                <div id="withdraw-section" class="mode-section">
                    <form action="generate-otp" method="post" id="withdrawForm">
                        <input type="hidden" name="txType" value="transaction">
                        <input type="hidden" name="type" value="withdraw">
                        <input type="hidden" name="subType" id="withdrawSubType" value="ATM Withdrawal">

                        <p style="font-size:13px; font-weight:500; margin-bottom:10px;">Withdrawal Method</p>
                        <div class="sub-type-grid">
                            <div class="sub-type-card selected" onclick="selectSubType('withdraw', 'ATM Withdrawal', this)">
                                <div class="st-icon">&#x1F3E7;</div>
                                <div class="st-label">ATM Withdrawal</div>
                            </div>
                            <div class="sub-type-card" onclick="selectSubType('withdraw', 'Bank Counter', this)">
                                <div class="st-icon">&#x1F3E6;</div>
                                <div class="st-label">Bank Counter</div>
                            </div>
                            <div class="sub-type-card" onclick="selectSubType('withdraw', 'Self Cheque', this)">
                                <div class="st-icon">&#x1F4DD;</div>
                                <div class="st-label">Self Cheque</div>
                            </div>
                            <div class="sub-type-card" onclick="selectSubType('withdraw', 'NEFT Transfer Out', this)">
                                <div class="st-icon">&#x1F4E4;</div>
                                <div class="st-label">NEFT Transfer Out</div>
                            </div>
                        </div>

                        <div id="withdraw-neft-field" style="display:none;" class="form-group">
                            <label>External Account Number</label>
                            <input type="text" name="externalAccount" placeholder="Enter destination account number">
                        </div>
                        <div id="withdraw-neft-ifsc" style="display:none;" class="form-group">
                            <label>IFSC Code</label>
                            <input type="text" name="ifscCode" placeholder="e.g., SBIN0001234">
                        </div>

                        <div class="form-group">
                            <label>Amount (&#x20B9;)</label>
                            <input type="number" name="amount" placeholder="Enter withdrawal amount" step="0.01" min="1" required>
                        </div>
                        <div class="form-group">
                            <label>Remarks (Optional)</label>
                            <input type="text" name="remarks" placeholder="e.g., Cash for trip, Rent, etc.">
                        </div>
                        <button type="submit" class="btn btn-danger btn-block">&#x1F512; Proceed to OTP Verification</button>
                    </form>
                </div>

                <div class="text-center mt-20">
                    <a href="dashboard" class="btn btn-outline btn-sm">Back to Dashboard</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function switchMode(mode) {
    document.querySelectorAll('.mode-tab').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.mode-section').forEach(s => s.classList.remove('active'));

    if (mode === 'deposit') {
        document.querySelectorAll('.mode-tab')[0].classList.add('active');
        document.getElementById('deposit-section').classList.add('active');
    } else {
        document.querySelectorAll('.mode-tab')[1].classList.add('active');
        document.getElementById('withdraw-section').classList.add('active');
    }
}

function selectSubType(mode, subType, el) {
    // Highlight selected card
    var section = document.getElementById(mode + '-section');
    section.querySelectorAll('.sub-type-card').forEach(c => c.classList.remove('selected'));
    el.classList.add('selected');

    // Update hidden field
    document.getElementById(mode + 'SubType').value = subType;

    // Show/hide extra fields
    if (mode === 'deposit') {
        document.getElementById('deposit-cheque-field').style.display = (subType === 'Cheque Deposit') ? 'block' : 'none';
        document.getElementById('deposit-neft-field').style.display = (subType === 'NEFT Transfer In') ? 'block' : 'none';
    } else {
        var isNeft = (subType === 'NEFT Transfer Out');
        document.getElementById('withdraw-neft-field').style.display = isNeft ? 'block' : 'none';
        document.getElementById('withdraw-neft-ifsc').style.display = isNeft ? 'block' : 'none';
    }
}
</script>

</body>
</html>
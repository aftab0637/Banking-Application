package com.jsp.ibms.controller;

import java.util.Optional;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.transaction.annotation.Transactional;
import com.jsp.ibms.dao.BankingDAO;
import com.jsp.ibms.entity.*;
import com.jsp.ibms.repository.*;

@Controller
public class OTPVerifyController {

    private static final long OTP_VALIDITY_MS = 5 * 60 * 1000;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BankTransactionRepository bankTransactionRepository;

    @Autowired
    private BillPaymentRepository billPaymentRepository;

    @Autowired
    private BankingDAO bankingDAO;

    @PersistenceContext
    private EntityManager em;

    @PostMapping("/verify-otp")
    @Transactional
    public String doPost(HttpSession session,
                         @RequestParam String otp,
                         Model model) {

        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        String generatedOTP = (String) session.getAttribute("generatedOTP");
        Long otpTimestamp = (Long) session.getAttribute("otpTimestamp");

        if (generatedOTP == null || otpTimestamp == null) {
            model.addAttribute("error", "OTP expired. Please try the transaction again.");
            return "forward:/dashboard";
        }

        if (System.currentTimeMillis() - otpTimestamp > OTP_VALIDITY_MS) {
            clearOTPSession(session);
            model.addAttribute("error", "OTP has expired. Please try again.");
            return "forward:/dashboard";
        }

        if (!generatedOTP.equals(otp)) {
            model.addAttribute("otpError", "Invalid OTP! Please try again.");
            model.addAttribute("otpGenerated", generatedOTP);
            model.addAttribute("txType", session.getAttribute("pendingTxType"));
            model.addAttribute("amount", session.getAttribute("pendingAmount"));
            return "otp-verify";
        }

        String txType = (String) session.getAttribute("pendingTxType");
        Users user = (Users) session.getAttribute("user");

        try {
            if ("transfer".equals(txType)) {
                return processTransfer(session, user, model);
            } else if ("billpay".equals(txType)) {
                return processBillPayment(session, user, model);
            } else if ("transaction".equals(txType)) {
                return processTransaction(session, user, model);
            }
        } finally {
            clearOTPSession(session);
        }
        return "redirect:/dashboard";
    }

    private String processTransfer(HttpSession session, Users user, Model model) {
        String transferMode = (String) session.getAttribute("pendingTransferMode");
        double amount = Double.parseDouble((String) session.getAttribute("pendingAmount"));
        String remarks = (String) session.getAttribute("pendingRemarks");
        if (remarks == null) remarks = "";

        try {
            Users sender = userRepository.findById(user.getId())
                    .orElseThrow(() -> new RuntimeException("Sender not found"));
            Users receiver;

            if ("account".equals(transferMode)) {
                String acctNum = (String) session.getAttribute("pendingAccountNumber");
                receiver = userRepository.findByAccountNumber(acctNum)
                        .orElseThrow(() -> new RuntimeException("No account found with number: " + acctNum));
            } else {
                String receiverEmail = (String) session.getAttribute("pendingEmail");
                receiver = userRepository.findByEmail(receiverEmail)
                        .orElseThrow(() -> new RuntimeException("No user found with email: " + receiverEmail));
            }

            if (sender.getId() == receiver.getId()) {
                throw new RuntimeException("Cannot transfer to your own account");
            }

            // Stored procedure update
            String spResult = bankingDAO.callTransferFunds(sender.getId(), receiver.getId(), amount);
            if (!"SUCCESS".equals(spResult)) {
                throw new RuntimeException(spResult);
            }

            // Save transactions via Spring Data JPA
            BankTransaction debit = new BankTransaction();
            debit.setSenderId(sender.getId());
            debit.setReceiverId(receiver.getId());
            debit.setAmount(amount);
            debit.setType("DEBIT");
            bankTransactionRepository.save(debit);

            BankTransaction credit = new BankTransaction();
            credit.setSenderId(sender.getId());
            credit.setReceiverId(receiver.getId());
            credit.setAmount(amount);
            credit.setType("CREDIT");
            bankTransactionRepository.save(credit);

            // Fetch fresh balances
            em.flush();
            em.refresh(sender);
            em.refresh(receiver);

            session.setAttribute("user", sender);

            model.addAttribute("receiptType", "Fund Transfer (OTP Verified ✅)");
            model.addAttribute("receiptAmount", amount);
            model.addAttribute("receiptStatus", "Success");
            model.addAttribute("receiptBalance", sender.getBal());
            model.addAttribute("receiptSenderAcct", sender.getAccountNumber());
            model.addAttribute("receiptReceiverAcct", receiver.getAccountNumber());
            model.addAttribute("receiptReceiver", receiver.getName() + " (A/c: " + receiver.getAccountNumber() + ")");
            model.addAttribute("receiptRemarks", remarks);
            return "receipt";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("activePage", "transfer");
            return "transfer";
        }
    }

    private String processBillPayment(HttpSession session, Users user, Model model) {
        String billType = (String) session.getAttribute("pendingBillType");
        String billNumber = (String) session.getAttribute("pendingBillNumber");
        double amount = Double.parseDouble((String) session.getAttribute("pendingAmount"));

        try {
            Users dbUser = userRepository.findById(user.getId())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            String spResult = bankingDAO.callPayBill(user.getId(), billType, billNumber, amount);
            if (!"SUCCESS".equals(spResult)) {
                throw new RuntimeException(spResult);
            }

            BillPayment bill = new BillPayment();
            bill.setUserId(user.getId());
            bill.setBillType(billType);
            bill.setBillNumber(billNumber);
            bill.setAmount(amount);
            bill.setStatus("SUCCESS");
            billPaymentRepository.save(bill);

            BankTransaction tx = new BankTransaction();
            tx.setSenderId(user.getId());
            tx.setReceiverId(user.getId());
            tx.setAmount(amount);
            tx.setType("DEBIT");
            bankTransactionRepository.save(tx);

            em.flush();
            em.refresh(dbUser);

            session.setAttribute("user", dbUser);

            model.addAttribute("receiptType", "Bill Payment (OTP Verified ✅) - " + billType);
            model.addAttribute("receiptAmount", amount);
            model.addAttribute("receiptStatus", "Success");
            model.addAttribute("receiptBalance", dbUser.getBal());
            model.addAttribute("receiptSenderAcct", dbUser.getAccountNumber());
            model.addAttribute("receiptReceiver", billType + " (" + billNumber + ")");
            return "receipt";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("activePage", "billpayment");
            return "billpayment";
        }
    }

    private String processTransaction(HttpSession session, Users user, Model model) {
        String type = (String) session.getAttribute("pendingTxAction");
        String subType = (String) session.getAttribute("pendingSubType");
        double amount = Double.parseDouble((String) session.getAttribute("pendingAmount"));
        String remarks = (String) session.getAttribute("pendingRemarks");
        if (subType == null) subType = type;
        if (remarks == null) remarks = "";

        try {
            Users dbUser = userRepository.findById(user.getId())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            if ("deposit".equals(type)) {
                dbUser.setBal(dbUser.getBal() + amount);
                userRepository.save(dbUser);

                BankTransaction tx = new BankTransaction();
                tx.setSenderId(user.getId());
                tx.setReceiverId(user.getId());
                tx.setAmount(amount);
                tx.setType("CREDIT");
                bankTransactionRepository.save(tx);
                model.addAttribute("receiptType", subType + " (OTP Verified ✅)");
            } else {
                if (dbUser.getBal() < amount) {
                    throw new RuntimeException("Insufficient balance. Available: ₹" + dbUser.getBal());
                }
                dbUser.setBal(dbUser.getBal() - amount);
                userRepository.save(dbUser);

                BankTransaction tx = new BankTransaction();
                tx.setSenderId(user.getId());
                tx.setReceiverId(user.getId());
                tx.setAmount(amount);
                tx.setType("DEBIT");
                bankTransactionRepository.save(tx);
                model.addAttribute("receiptType", subType + " (OTP Verified ✅)");
            }

            session.setAttribute("user", dbUser);

            model.addAttribute("receiptAmount", amount);
            model.addAttribute("receiptStatus", "Success");
            model.addAttribute("receiptBalance", dbUser.getBal());
            model.addAttribute("receiptSenderAcct", dbUser.getAccountNumber());
            model.addAttribute("receiptRemarks", remarks);
            return "receipt";

        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            model.addAttribute("activePage", "transaction");
            return "transaction";
        }
    }

    private void clearOTPSession(HttpSession session) {
        session.removeAttribute("generatedOTP");
        session.removeAttribute("otpTimestamp");
        session.removeAttribute("pendingTxType");
        session.removeAttribute("pendingTransferMode");
        session.removeAttribute("pendingAccountNumber");
        session.removeAttribute("pendingEmail");
        session.removeAttribute("pendingAmount");
        session.removeAttribute("pendingTxAction");
        session.removeAttribute("pendingSubType");
        session.removeAttribute("pendingBillType");
        session.removeAttribute("pendingBillNumber");
        session.removeAttribute("pendingRemarks");
    }
}

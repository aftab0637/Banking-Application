package com.jsp.ibms.controller;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.transaction.annotation.Transactional;
import com.jsp.ibms.entity.BankTransaction;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.BankTransactionRepository;
import com.jsp.ibms.repository.UserRepository;

@Controller
public class TransactionContro {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BankTransactionRepository bankTransactionRepository;

    @PostMapping("/transaction")
    @Transactional
    public String doPost(HttpSession session,
                         @RequestParam double amount,
                         @RequestParam String type,
                         Model model) {

        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        if (amount <= 0) {
            model.addAttribute("message", "Enter a valid amount");
            model.addAttribute("activePage", "transaction");
            return "transaction";
        }

        Users user = (Users) session.getAttribute("user");

        try {
            Users dbUser = userRepository.findById(user.getId())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            if ("deposit".equals(type)) {
                dbUser.setBal(dbUser.getBal() + amount);
                userRepository.save(dbUser);

                BankTransaction tx = new BankTransaction();
                tx.setSenderId(dbUser.getId());
                tx.setReceiverId(dbUser.getId());
                tx.setAmount(amount);
                tx.setType("CREDIT");
                bankTransactionRepository.save(tx);

                model.addAttribute("receiptType", "Deposit");
                model.addAttribute("receiptAmount", amount);
                model.addAttribute("receiptStatus", "Success");

            } else if ("withdraw".equals(type)) {
                if (dbUser.getBal() >= amount) {
                    dbUser.setBal(dbUser.getBal() - amount);
                    userRepository.save(dbUser);

                    BankTransaction tx = new BankTransaction();
                    tx.setSenderId(dbUser.getId());
                    tx.setReceiverId(dbUser.getId());
                    tx.setAmount(amount);
                    tx.setType("DEBIT");
                    bankTransactionRepository.save(tx);

                    model.addAttribute("receiptType", "Withdrawal");
                    model.addAttribute("receiptAmount", amount);
                    model.addAttribute("receiptStatus", "Success");
                } else {
                    model.addAttribute("message", "Insufficient Balance");
                    model.addAttribute("activePage", "transaction");
                    return "transaction";
                }
            }

            session.setAttribute("user", dbUser);
            model.addAttribute("receiptBalance", dbUser.getBal());
            return "receipt";

        } catch (Exception e) {
            model.addAttribute("message", "Transaction Failed: " + e.getMessage());
            model.addAttribute("activePage", "transaction");
            return "transaction";
        }
    }
}
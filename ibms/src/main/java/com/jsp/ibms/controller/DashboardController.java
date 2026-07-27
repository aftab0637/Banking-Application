package com.jsp.ibms.controller;

import java.util.List;
import java.util.Map;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.jsp.ibms.dao.BankingDAO;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.UserRepository;

@Controller
public class DashboardController {

    @Autowired
    private BankingDAO bankingDAO;

    @Autowired
    private UserRepository userRepository;

    @PersistenceContext
    private EntityManager em;

    @GetMapping("/dashboard")
    public String doGet(HttpSession session, Model model) {
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");

        try {
            // Refresh user from DB
            Users freshUser = userRepository.findById(user.getId()).orElse(null);
            if (freshUser != null) {
                session.setAttribute("user", freshUser);
                session.setAttribute("name", freshUser.getName());
            }

            // Call Stored Procedure for account stats summary
            Map<String, Object> accountSummary = bankingDAO.callGetAccountSummary(user.getId());

            model.addAttribute("totalCredits", accountSummary.getOrDefault("totalCredits", 0.0));
            model.addAttribute("totalDebits", accountSummary.getOrDefault("totalDebits", 0.0));
            model.addAttribute("totalTransactions", accountSummary.getOrDefault("totalTransactions", 0L));
            model.addAttribute("totalBillsPaid", accountSummary.getOrDefault("totalBillsPaid", 0L));

            // Load last 5 transactions from v_transaction_history View
            List<?> recentTxView = em.createNativeQuery(
                    "SELECT * FROM v_transaction_history WHERE (sender_id = ?1 AND transaction_type = 'DEBIT') OR (receiver_id = ?1 AND transaction_type = 'CREDIT') LIMIT 5")
                    .setParameter(1, user.getId())
                    .getResultList();

            model.addAttribute("recentTxView", recentTxView);
            model.addAttribute("currentUserId", user.getId());
            model.addAttribute("activePage", "dashboard");

            return "dashbord";

        } catch (Exception e) {
            e.printStackTrace();
            return "dashbord";
        }
    }
}

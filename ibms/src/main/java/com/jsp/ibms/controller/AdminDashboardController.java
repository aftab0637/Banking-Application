package com.jsp.ibms.controller;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.jsp.ibms.dao.BankingDAO;
import com.jsp.ibms.entity.BankTransaction;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.BankTransactionRepository;
import com.jsp.ibms.repository.UserRepository;

@Controller
public class AdminDashboardController {

    @Autowired
    private BankingDAO bankingDAO;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BankTransactionRepository bankTransactionRepository;

    @GetMapping("/admin/dashboard")
    public String doGet(HttpSession session, Model model) {
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }

        try {
            // CALL DATABASE VIEW via BankingDAO
            Map<String, Object> stats = bankingDAO.getAdminDashboardStats();

            model.addAttribute("totalUsers", toLong(stats.get("totalUsers")));
            model.addAttribute("totalTransactions", toLong(stats.get("totalTransactions")));
            model.addAttribute("totalBalance", toDouble(stats.get("totalBalance")));
            model.addAttribute("averageBalance", toDouble(stats.get("averageBalance")));
            model.addAttribute("totalCredits", toDouble(stats.get("totalCredits")));
            model.addAttribute("totalDebits", toDouble(stats.get("totalDebits")));
            model.addAttribute("totalBillsPaid", toLong(stats.get("totalBillsPaid")));
            model.addAttribute("totalBeneficiaries", toLong(stats.get("totalBeneficiaries")));
            model.addAttribute("todayTransactions", toLong(stats.get("todayTransactions")));

            // Load user lists and recent transactions via Spring Data JPA
            List<Users> allUsers = userRepository.findByRoleOrderByCreatedAtDesc("USER");
            List<BankTransaction> recentTx = bankTransactionRepository.findTop20ByOrderByTransactionTimeDesc();

            model.addAttribute("allUsers", allUsers);
            model.addAttribute("recentTx", recentTx);
            model.addAttribute("activePage", "admin");

            return "admin/dashboard";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to load admin stats: " + e.getMessage());
            return "admin/dashboard";
        }
    }

    private Long toLong(Object obj) {
        if (obj instanceof Number) {
            return ((Number) obj).longValue();
        }
        return 0L;
    }

    private Double toDouble(Object obj) {
        if (obj instanceof Number) {
            return ((Number) obj).doubleValue();
        }
        return 0.0;
    }
}

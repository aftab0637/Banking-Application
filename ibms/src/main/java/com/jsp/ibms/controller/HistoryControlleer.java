package com.jsp.ibms.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.jsp.ibms.dao.BankingDAO;
import com.jsp.ibms.entity.Users;

@Controller
public class HistoryControlleer {

    @Autowired
    private BankingDAO bankingDAO;

    @GetMapping("/history")
    public String doGet(HttpSession session, Model model) {
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");

        try {
            // Retrieve history using database VIEW
            List<?> txHistory = bankingDAO.getTransactionHistoryFromView(user.getId());

            model.addAttribute("txHistory", txHistory);
            model.addAttribute("currentUserId", user.getId());
            model.addAttribute("activePage", "history");
            return "history";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("txHistory", List.of());
            model.addAttribute("currentUserId", user.getId());
            return "history";
        }
    }
}
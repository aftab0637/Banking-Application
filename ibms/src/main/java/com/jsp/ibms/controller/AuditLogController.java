package com.jsp.ibms.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.jsp.ibms.entity.AuditLog;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.AuditLogRepository;

@Controller
public class AuditLogController {

    @Autowired
    private AuditLogRepository auditLogRepository;

    @GetMapping("/auditlog")
    public String doGet(HttpSession session, Model model) {
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");

        // Only admin can view audit logs
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }

        try {
            // Read audit logs created by database triggers
            List<AuditLog> auditLogs = auditLogRepository.findTop50ByOrderByPerformedatDesc();

            model.addAttribute("auditLogs", auditLogs);
            model.addAttribute("activePage", "admin");
            return "admin/auditlog";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to load audit logs: " + e.getMessage());
            return "admin/auditlog";
        }
    }
}

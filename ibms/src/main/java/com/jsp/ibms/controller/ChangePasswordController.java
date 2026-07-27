package com.jsp.ibms.controller;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.transaction.annotation.Transactional;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.UserRepository;

@Controller
public class ChangePasswordController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BCryptPasswordEncoder encoder;

    @PostMapping("/changepassword")
    @Transactional
    public String doPost(HttpSession session,
                         @RequestParam String currentPass,
                         @RequestParam String newPass,
                         @RequestParam String confirmPass,
                         Model model) {

        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");

        if (!encoder.matches(currentPass, user.getPass())) {
            model.addAttribute("error", "Current password is incorrect");
            model.addAttribute("activePage", "changepassword");
            return "changepassword";
        }

        if (!newPass.equals(confirmPass)) {
            model.addAttribute("error", "New passwords do not match");
            model.addAttribute("activePage", "changepassword");
            return "changepassword";
        }

        if (newPass.length() < 4) {
            model.addAttribute("error", "Password must be at least 4 characters");
            model.addAttribute("activePage", "changepassword");
            return "changepassword";
        }

        try {
            Users dbUser = userRepository.findById(user.getId())
                    .orElseThrow(() -> new RuntimeException("User not found"));
            dbUser.setPass(encoder.encode(newPass));
            userRepository.save(dbUser);

            session.setAttribute("user", dbUser);

            model.addAttribute("success", "Password changed successfully!");
            model.addAttribute("activePage", "changepassword");
            return "changepassword";

        } catch (Exception e) {
            model.addAttribute("error", "Failed to change password");
            model.addAttribute("activePage", "changepassword");
            return "changepassword";
        }
    }
}

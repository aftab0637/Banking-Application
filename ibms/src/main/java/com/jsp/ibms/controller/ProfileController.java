package com.jsp.ibms.controller;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.transaction.annotation.Transactional;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.UserRepository;

@Controller
public class ProfileController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/profile")
    public String doGet(HttpSession session, Model model) {
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }
        model.addAttribute("activePage", "profile");
        return "profile";
    }

    @PostMapping("/profile")
    @Transactional
    public String doPost(HttpSession session,
                         @RequestParam String name,
                         @RequestParam String phone,
                         Model model) {

        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");

        try {
            Users dbUser = userRepository.findById(user.getId())
                    .orElseThrow(() -> new RuntimeException("User not found"));
            dbUser.setName(name);
            dbUser.setPhone(phone);
            userRepository.save(dbUser);

            session.setAttribute("user", dbUser);
            session.setAttribute("name", dbUser.getName());

            model.addAttribute("success", "Profile updated successfully!");
            model.addAttribute("activePage", "profile");
            return "profile";

        } catch (Exception e) {
            model.addAttribute("error", "Failed to update profile");
            model.addAttribute("activePage", "profile");
            return "profile";
        }
    }
}

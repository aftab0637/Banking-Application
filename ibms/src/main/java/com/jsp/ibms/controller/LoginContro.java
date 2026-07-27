package com.jsp.ibms.controller;

import java.util.Optional;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.UserRepository;

@Controller
public class LoginContro {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BCryptPasswordEncoder encoder;

    @PostMapping("/login")
    public String doPost(@RequestParam String email,
                         @RequestParam String pass,
                         HttpSession session,
                         Model model) {

        try {
            Optional<Users> userOpt = userRepository.findByEmail(email);

            if (userOpt.isPresent()) {
                Users user = userOpt.get();

                if (encoder.matches(pass, user.getPass())) {
                    session.setAttribute("user", user);
                    session.setAttribute("name", user.getName());
                    session.setAttribute("accountNumber", user.getAccountNumber());

                    if ("ADMIN".equals(user.getRole())) {
                        return "redirect:/admin/dashboard";
                    } else {
                        return "redirect:/dashboard";
                    }
                } else {
                    model.addAttribute("message", "Invalid Password");
                    return "login";
                }
            } else {
                model.addAttribute("message", "User not found with this email");
                return "login";
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", "Login error: " + e.getMessage());
            return "login";
        }
    }
}
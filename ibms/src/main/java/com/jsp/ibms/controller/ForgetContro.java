package com.jsp.ibms.controller;

import java.util.Optional;
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
public class ForgetContro {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BCryptPasswordEncoder encoder;

    @PostMapping("/forget")
    @Transactional
    public String doPost(@RequestParam String email,
                         @RequestParam String pass,
                         Model model) {
        try {
            Optional<Users> userOpt = userRepository.findByEmail(email);

            if (userOpt.isPresent()) {
                Users user = userOpt.get();
                user.setPass(encoder.encode(pass));
                userRepository.save(user);

                return "redirect:/login.jsp";
            } else {
                model.addAttribute("message", "Invalid Email. User not found.");
                return "forget";
            }
        } catch (Exception e) {
            model.addAttribute("message", "Error: " + e.getMessage());
            return "forget";
        }
    }
}
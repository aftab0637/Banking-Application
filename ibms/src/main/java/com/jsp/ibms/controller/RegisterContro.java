package com.jsp.ibms.controller;

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
public class RegisterContro {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BCryptPasswordEncoder encoder;

    @PostMapping("/reg")
    @Transactional
    public String doPost(@RequestParam String name,
                         @RequestParam String email,
                         @RequestParam String pass,
                         @RequestParam String confirmPass,
                         @RequestParam String phone,
                         Model model) {

        if (!pass.equals(confirmPass)) {
            model.addAttribute("message", "Passwords do not match!");
            return "register";
        }

        if (pass.length() < 4) {
            model.addAttribute("message", "Password must be at least 4 characters!");
            return "register";
        }

        if (userRepository.findByEmail(email).isPresent()) {
            model.addAttribute("message", "An account with this email already exists!");
            return "register";
        }

        try {
            String encodedPassword = encoder.encode(pass);

            long accNum = 1000000000L + (long)(Math.random() * 9000000000L);
            String accountNumber = String.valueOf(accNum);

            Users users = new Users();
            users.setName(name);
            users.setEmail(email);
            users.setPass(encodedPassword);
            users.setPhone(phone);
            users.setAccountNumber(accountNumber);
            users.setRole("USER");
            users.setBal(1000);

            userRepository.save(users);

            return "redirect:/login.jsp?registered=true&account=" + accountNumber;

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", "Registration failed: " + e.getMessage());
            return "register";
        }
    }
}
package com.jsp.ibms.controller;

import java.util.Optional;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.UserRepository;

@Controller
public class BalanceContro {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/balance")
    public String doGet(HttpSession session) {
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");

        try {
            Optional<Users> freshUserOpt = userRepository.findByEmail(user.getEmail());
            if (freshUserOpt.isPresent()) {
                session.setAttribute("user", freshUserOpt.get());
            }
            return "redirect:/balance.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/balance.jsp";
        }
    }
}

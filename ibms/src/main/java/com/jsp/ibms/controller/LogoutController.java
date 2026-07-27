package com.jsp.ibms.controller;

import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LogoutController {

    @GetMapping("/logout")
    public String doGet(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login.jsp";
    }
}

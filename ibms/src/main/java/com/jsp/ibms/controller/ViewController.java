package com.jsp.ibms.controller;

import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    @GetMapping({"/", "/index.jsp"})
    public String index() {
        return "index";
    }

    @GetMapping({"/login.jsp"})
    public String login() {
        return "login";
    }

    @GetMapping({"/register.jsp"})
    public String register() {
        return "register";
    }

    @GetMapping({"/forget.jsp"})
    public String forget() {
        return "forget";
    }

    @GetMapping({"/otp-verify.jsp"})
    public String otpVerify() {
        return "otp-verify";
    }

    @GetMapping({"/receipt.jsp"})
    public String receipt() {
        return "receipt";
    }

    @GetMapping("/balance.jsp")
    public String balanceJsp(Model model) {
        model.addAttribute("activePage", "balance");
        return "balance";
    }

    @GetMapping("/transfer.jsp")
    public String transferJsp(Model model) {
        model.addAttribute("activePage", "transfer");
        return "transfer";
    }

    @GetMapping("/billpayment.jsp")
    public String billpaymentJsp(Model model) {
        model.addAttribute("activePage", "billpayment");
        return "billpayment";
    }

    @GetMapping("/changepassword.jsp")
    public String changepasswordJsp(Model model) {
        model.addAttribute("activePage", "changepassword");
        return "changepassword";
    }

    @GetMapping("/profile.jsp")
    public String profileJsp(Model model) {
        model.addAttribute("activePage", "profile");
        return "profile";
    }

    @GetMapping("/transaction.jsp")
    public String transactionJsp(Model model) {
        model.addAttribute("activePage", "transaction");
        return "transaction";
    }
}

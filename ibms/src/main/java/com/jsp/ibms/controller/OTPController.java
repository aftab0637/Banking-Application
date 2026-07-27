package com.jsp.ibms.controller;

import java.util.Random;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.jsp.ibms.entity.Users;

@Controller
public class OTPController {

    @PostMapping("/generate-otp")
    public String doPost(HttpSession session,
                         @RequestParam String txType,
                         HttpServletRequest req,
                         Model model) {

        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        // Generate 6-digit OTP
        Random random = new Random();
        String otp = String.format("%06d", random.nextInt(999999));

        session.setAttribute("generatedOTP", otp);
        session.setAttribute("otpTimestamp", System.currentTimeMillis());
        session.setAttribute("pendingTxType", txType);

        String amount = req.getParameter("amount");
        session.setAttribute("pendingAmount", amount);

        if ("transfer".equals(txType)) {
            String transferMode = req.getParameter("transferMode");
            session.setAttribute("pendingTransferMode", transferMode);
            session.setAttribute("pendingRemarks", req.getParameter("remarks"));

            if ("account".equals(transferMode)) {
                session.setAttribute("pendingAccountNumber", req.getParameter("accountNumber"));
            } else {
                session.setAttribute("pendingEmail", req.getParameter("email"));
            }

        } else if ("billpay".equals(txType)) {
            session.setAttribute("pendingBillType", req.getParameter("billType"));
            session.setAttribute("pendingBillNumber", req.getParameter("billNumber"));

        } else if ("transaction".equals(txType)) {
            session.setAttribute("pendingTxAction", req.getParameter("type"));
            session.setAttribute("pendingSubType", req.getParameter("subType"));
            session.setAttribute("pendingRemarks", req.getParameter("remarks"));
        }

        Users user = (Users) session.getAttribute("user");
        System.out.println("[IBMS-OTP] Generated OTP: " + otp + " for user: " + user.getEmail());

        model.addAttribute("otpGenerated", otp);
        model.addAttribute("txType", txType);
        model.addAttribute("amount", amount);

        return "otp-verify";
    }
}

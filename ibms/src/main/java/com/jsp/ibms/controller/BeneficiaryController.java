package com.jsp.ibms.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.jsp.ibms.entity.Beneficiary;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.BeneficiaryRepository;

@Controller
public class BeneficiaryController {

    @Autowired
    private BeneficiaryRepository beneficiaryRepository;

    @GetMapping("/beneficiary")
    public String doGet(HttpSession session, Model model) {
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");

        try {
            List<Beneficiary> beneficiaries = beneficiaryRepository.findByUserIdOrderByAddedAtDesc(user.getId());
            model.addAttribute("beneficiaries", beneficiaries);
            model.addAttribute("activePage", "beneficiary");
            return "beneficiary";
        } catch (Exception e) {
            e.printStackTrace();
            return "beneficiary";
        }
    }

    @PostMapping("/beneficiary")
    public String doPost(HttpSession session,
                         @RequestParam String name,
                         @RequestParam String email,
                         @RequestParam String accountNumber,
                         Model model) {
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");

        try {
            Beneficiary b = new Beneficiary();
            b.setUserId(user.getId());
            b.setName(name);
            b.setEmail(email);
            b.setAccountNumber(accountNumber);

            beneficiaryRepository.save(b);

            return "redirect:/beneficiary";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to add beneficiary: " + e.getMessage());
            return doGet(session, model);
        }
    }
}

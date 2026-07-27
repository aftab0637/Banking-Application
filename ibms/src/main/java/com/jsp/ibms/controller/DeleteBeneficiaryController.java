package com.jsp.ibms.controller;

import java.util.Optional;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.jsp.ibms.entity.Beneficiary;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.BeneficiaryRepository;

@Controller
public class DeleteBeneficiaryController {

    @Autowired
    private BeneficiaryRepository beneficiaryRepository;

    @PostMapping("/deletebeneficiary")
    public String doPost(HttpSession session, @RequestParam int id) {
        if (session == null || session.getAttribute("user") == null) {
            return "redirect:/login.jsp";
        }

        Users user = (Users) session.getAttribute("user");

        try {
            Optional<Beneficiary> bOpt = beneficiaryRepository.findById(id);
            if (bOpt.isPresent()) {
                Beneficiary b = bOpt.get();
                if (b.getUserId() == user.getId()) {
                    beneficiaryRepository.delete(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/beneficiary";
    }
}

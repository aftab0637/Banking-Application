package com.jsp.ibms.controller;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.UserRepository;

@Controller
public class AccountLookupController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/lookup-account")
    @ResponseBody
    public String lookupAccount(@RequestParam(required = false) String accountNumber) {
        if (accountNumber == null || accountNumber.trim().isEmpty()) {
            return "NOT_FOUND";
        }

        try {
            Optional<Users> userOpt = userRepository.findByAccountNumber(accountNumber.trim());
            if (userOpt.isPresent()) {
                return userOpt.get().getName();
            } else {
                return "NOT_FOUND";
            }
        } catch (Exception e) {
            return "NOT_FOUND";
        }
    }
}

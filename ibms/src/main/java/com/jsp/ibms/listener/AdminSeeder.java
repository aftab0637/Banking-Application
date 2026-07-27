package com.jsp.ibms.listener;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import com.jsp.ibms.entity.Users;
import com.jsp.ibms.repository.UserRepository;

@Component
public class AdminSeeder implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BCryptPasswordEncoder encoder;

    @Override
    public void run(String... args) throws Exception {
        try {
            Optional<Users> adminOpt = userRepository.findByEmail("admin@ibms.com");

            if (adminOpt.isEmpty()) {
                Users admin = new Users();
                admin.setName("Admin");
                admin.setEmail("admin@ibms.com");
                admin.setPass(encoder.encode("admin123"));
                admin.setRole("ADMIN");
                admin.setBal(0);
                admin.setPhone("0000000000");
                admin.setAccountNumber("IBMS000000");

                userRepository.save(admin);

                System.out.println("[IBMS] Admin account created: admin@ibms.com / admin123");
            } else {
                System.out.println("[IBMS] Admin account already exists.");
            }
        } catch (Exception e) {
            System.err.println("[IBMS] Warning: Could not seed admin account.");
            e.printStackTrace();
        }
    }
}

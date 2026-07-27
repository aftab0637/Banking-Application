package com.jsp.ibms.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.jsp.ibms.entity.Users;

@Repository
public interface UserRepository extends JpaRepository<Users, Integer> {
    Optional<Users> findByEmail(String email);
    Optional<Users> findByAccountNumber(String accountNumber);
    List<Users> findByRoleOrderByCreatedAtDesc(String role);
}

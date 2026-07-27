package com.jsp.ibms.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.jsp.ibms.entity.BankTransaction;

@Repository
public interface BankTransactionRepository extends JpaRepository<BankTransaction, Integer> {
    List<BankTransaction> findTop20ByOrderByTransactionTimeDesc();
}

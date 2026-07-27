package com.jsp.ibms.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.jsp.ibms.entity.BillPayment;

@Repository
public interface BillPaymentRepository extends JpaRepository<BillPayment, Integer> {
}

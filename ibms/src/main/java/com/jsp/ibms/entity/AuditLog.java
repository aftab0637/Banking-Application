package com.jsp.ibms.entity;

import java.time.LocalDateTime;
import javax.persistence.*;

/**
 * AuditLog Entity - Maps to the 'audit_log' table.
 * 
 * IMPORTANT: This table is populated by a DATABASE TRIGGER (trg_audit_balance_change),
 * NOT by Java code. The trigger fires automatically whenever a user's balance changes.
 * Java only READS from this table to display the audit trail.
 */
@Entity
@Table(name = "audit_log")
public class AuditLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private int userid;
    private String useremail;
    private String action;
    private double oldbalance;
    private double newbalance;
    private double changeamount;
    private LocalDateTime performedat;

    public AuditLog() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserid() { return userid; }
    public void setUserid(int userid) { this.userid = userid; }

    public String getUseremail() { return useremail; }
    public void setUseremail(String useremail) { this.useremail = useremail; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public double getOldbalance() { return oldbalance; }
    public void setOldbalance(double oldbalance) { this.oldbalance = oldbalance; }

    public double getNewbalance() { return newbalance; }
    public void setNewbalance(double newbalance) { this.newbalance = newbalance; }

    public double getChangeamount() { return changeamount; }
    public void setChangeamount(double changeamount) { this.changeamount = changeamount; }

    public LocalDateTime getPerformedat() { return performedat; }
    public void setPerformedat(LocalDateTime performedat) { this.performedat = performedat; }
}

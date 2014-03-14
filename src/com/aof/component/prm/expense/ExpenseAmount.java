package com.aof.component.prm.expense;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import com.aof.component.prm.expense.*;
import com.aof.component.prm.project.*;

/** @author Hibernate CodeGenerator */
public class ExpenseAmount implements Serializable {

    /** identifier field */
    private Long Id;

    /** nullable persistent field */
    private ExpenseMaster ExpMaster;

    /** nullable persistent field */
    private ExpenseType ExpType;

    /** nullable persistent field */
    private Float UserAmount;

    /** nullable persistent field */
    private Float ConfirmedAmount;

    /** nullable persistent field */
    private Float PaidAmount;

    /** full constructor */
    public ExpenseAmount(ExpenseMaster ExpMaster, ExpenseType ExpType, Float UserAmount, Float ConfirmedAmount) {
        this.ExpMaster = ExpMaster;
        this.ExpType = ExpType;
        this.UserAmount = UserAmount;
        this.ConfirmedAmount = ConfirmedAmount;
    }

    /** default constructor */
    public ExpenseAmount() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public ExpenseMaster getExpMaster() {
        return this.ExpMaster;
    }

	public void setExpMaster(ExpenseMaster ExpMaster) {
		this.ExpMaster = ExpMaster;
	}

    public ExpenseType getExpType() {
        return this.ExpType;
    }

	public void setExpType(ExpenseType ExpType) {
		this.ExpType = ExpType;
	}

    public Float getUserAmount() {
        return this.UserAmount;
    }

	public void setUserAmount(Float UserAmount) {
		this.UserAmount = UserAmount;
	}

    public Float getConfirmedAmount() {
        return this.ConfirmedAmount;
    }

	public void setConfirmedAmount(Float ConfirmedAmount) {
		this.ConfirmedAmount = ConfirmedAmount;
	}    
	
	public Float getPaidAmount() {
        return this.PaidAmount;
    }

	public void setPaidAmount(Float PaidAmount) {
		this.PaidAmount = PaidAmount;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ExpenseAmount) ) return false;
        ExpenseAmount castOther = (ExpenseAmount) other;
        return new EqualsBuilder()
            .append(this.getId(), castOther.getId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }

}

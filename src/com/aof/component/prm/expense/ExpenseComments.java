package com.aof.component.prm.expense;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import com.aof.component.prm.expense.*;
import com.aof.component.prm.project.*;

/** @author Hibernate CodeGenerator */
public class ExpenseComments implements Serializable {

    /** identifier field */
    private Long Id;

    /** nullable persistent field */
    private ExpenseMaster ExpMaster;

    /** nullable persistent field */
    private String Comments;

    /** nullable persistent field */
    private java.util.Date ExpenseDate;

    /** default constructor */
    public ExpenseComments() {
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

    public String getComments() {
        return this.Comments;
    }

	public void setComments(String Comments) {
		this.Comments = Comments;
	}

    public java.util.Date getExpenseDate() {
        return this.ExpenseDate;
    }

	public void setExpenseDate(java.util.Date ExpenseDate) {
		this.ExpenseDate = ExpenseDate;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ExpenseComments) ) return false;
        ExpenseComments castOther = (ExpenseComments) other;
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

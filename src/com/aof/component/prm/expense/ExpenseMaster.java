package com.aof.component.prm.expense;

import java.io.Serializable;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;

/** @author Hibernate CodeGenerator */
public class ExpenseMaster implements Serializable {

    /** identifier field */
    private Long Id;

    /** persistent field */
    private UserLogin ExpenseUser;

    /** persistent field */
    private ProjectMaster Project;

    /** nullable persistent field */
    private String Status;
	
	/** nullable persistent field */
    private String ClaimType;
	private String FormCode;
	private String UserComment;
	private String PAComment;
	private String PMComment;
	private String FAComment;

	private java.util.Date ExpenseDate;
	private java.util.Date EntryDate;
	private java.util.Date ApprovalDate;
	private java.util.Date VerifyDate;
	private java.util.Date ReceiptDate;
	private java.util.Date ClaimExportDate;
	private java.util.Date VerifyExportDate;
	private java.util.Date FAConfirmDate;
	
	private Set Details;
	private Set Comments;
	private Set Amounts;
	
	private Float CurrencyRate;
	private CurrencyType ExpenseCurrency;
    /** default constructor */
    public ExpenseMaster() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public UserLogin getExpenseUser() {
        return this.ExpenseUser;
    }

	public void setExpenseUser(UserLogin ExpenseUser) {
		this.ExpenseUser = ExpenseUser;
	}

    public ProjectMaster getProject() {
        return this.Project;
    }

	public void setProject(ProjectMaster Project) {
		this.Project = Project;
	}

    public String getStatus() {
        return this.Status;
    }

	public void setStatus(String Status) {
		this.Status = Status;
	}
	

	/**
	 * @return Returns the fAConfirmDate.
	 */
	public java.util.Date getFAConfirmDate() {
		return FAConfirmDate;
	}
	/**
	 * @param confirmDate The fAConfirmDate to set.
	 */
	public void setFAConfirmDate(java.util.Date confirmDate) {
		FAConfirmDate = confirmDate;
	}
    public String getClaimType() {
        return this.ClaimType;
    }

	public void setClaimType(String ClaimType) {
		this.ClaimType = ClaimType;
	}
	
	public String getFormCode() {
		return this.FormCode;
	}

	public void setFormCode(String FormCode) {
		this.FormCode = FormCode;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ExpenseMaster) ) return false;
        ExpenseMaster castOther = (ExpenseMaster) other;
        return new EqualsBuilder()
            .append(this.getId(), castOther.getId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }

	public java.util.Date getExpenseDate() {
		return this.ExpenseDate;
	}
	public void setExpenseDate(java.util.Date date) {
		this.ExpenseDate = date;
	}

	public java.util.Date getEntryDate() {
		return this.EntryDate;
	}
	public void setEntryDate(java.util.Date date) {
		this.EntryDate = date;
	}

	public java.util.Date getReceiptDate() {
		return this.ReceiptDate;
	}
	public void setReceiptDate(java.util.Date date) {
		this.ReceiptDate = date;
	}

	public java.util.Date getVerifyDate() {
		return this.VerifyDate;
	}
	public void setVerifyDate(java.util.Date date) {
		this.VerifyDate = date;
	}

	public java.util.Date getApprovalDate() {
		return this.ApprovalDate;
	}
	public void setApprovalDate(java.util.Date date) {
		this.ApprovalDate = date;
	}

	public java.util.Date getVerifyExportDate() {
		return this.VerifyExportDate;
	}
	public void setVerifyExportDate(java.util.Date date) {
		this.VerifyExportDate = date;
	}

	public java.util.Date getClaimExportDate() {
		return this.ClaimExportDate;
	}
	public void setClaimExportDate(java.util.Date date) {
		this.ClaimExportDate = date;
	}
	
	public Set getDetails() {
		return this.Details;
	}
	public void setDetails(Set set) {
		this.Details = set;
	}
	public Set getComments() {
		return this.Comments;
	}
	public void setComments(Set set) {
		this.Comments = set;
	}
	public Set getAmounts() {
		return this.Amounts;
	}
	public void setAmounts(Set set) {
		this.Amounts = set;
	}
	
	public Float getCurrencyRate() {
		return this.CurrencyRate;
	}
	public void setCurrencyRate(Float CurrencyRate) {
		this.CurrencyRate = CurrencyRate;
	}
	public CurrencyType getExpenseCurrency() {
		return this.ExpenseCurrency;
	}
	public void setExpenseCurrency(CurrencyType ExpenseCurrency) {
		this.ExpenseCurrency = ExpenseCurrency;
	}

	public String getUserComment() {
		return this.UserComment;
	}
	public void setUserComment(String UserComment) {
		this.UserComment = UserComment;
	}
	

	public String getPAComment() {
		return this.PAComment;
	}
	public void setPAComment(String PAComment) {
		this.PAComment = PAComment;
	}
	

	public String getPMComment() {
		return this.PMComment;
	}
	public void setPMComment(String PMComment) {
		this.PMComment = PMComment;
	}
	

	public String getFAComment() {
		return this.FAComment;
	}
	public void setFAComment(String FAComment) {
		this.FAComment = FAComment;
	}
}
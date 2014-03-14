package com.aof.component.prm.Bill;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectInvoiceConfirmation extends Object implements Serializable {

    /** identifier field */
    private Long id;

    /** persistent field */
    private ProjectInvoice invoice;

    /** nullable persistent field */
    private String contactor;

    /** nullable persistent field */
    private com.aof.component.domain.party.UserLogin responsiblePerson;
    
    /** nullable persistent field */
    private String responsiblePersonId;

    /** nullable persistent field */
    private java.util.Date contactDate;

    /** nullable persistent field */
    private Double payAmount;

    /** nullable persistent field */
    private java.util.Date payDate;

    /** nullable persistent field */
    private String note;

    /** nullable persistent field */
    private com.aof.component.domain.party.UserLogin createUser;

    /** nullable persistent field */
    private java.util.Date createDate;
    
    /** nullable persistent field */
    private com.aof.component.prm.project.CurrencyType currency;
    
    private String currencyId;

    /** full constructor */
    public ProjectInvoiceConfirmation(Long id,
    								  ProjectInvoice invoice, 
    		                          String contactor, 
    		                          com.aof.component.domain.party.UserLogin responsiblePerson, 
									  java.util.Date contactDate, 
									  Double payAmount, 
									  java.util.Date payDate, 
									  java.lang.String note, 
									  com.aof.component.domain.party.UserLogin createUser, 
									  java.util.Date createDate,
									  com.aof.component.prm.project.CurrencyType currency) {
    	this.id = id;
        this.invoice = invoice;
        this.contactor = contactor;
        this.responsiblePerson = responsiblePerson;
        this.contactDate = contactDate;
        this.payAmount = payAmount;
        this.payDate = payDate;
        this.note = note;
        this.createUser = createUser;
        this.createDate = createDate;
        this.currency = currency;
    }

    /** default constructor */
    public ProjectInvoiceConfirmation() {
    }

    /** minimal constructor */
    public ProjectInvoiceConfirmation(Long id, ProjectInvoice invoice) {
    	this.id = id;
        this.invoice = invoice;
    }
	/**
	 * @return Returns the contactDate.
	 */
	public java.util.Date getContactDate() {
		return contactDate;
	}
	/**
	 * @param contactDate The contactDate to set.
	 */
	public void setContactDate(java.util.Date contactDate) {
		this.contactDate = contactDate;
	}
	/**
	 * @return Returns the contactor.
	 */
	public String getContactor() {
		return contactor;
	}
	/**
	 * @param contactor The contactor to set.
	 */
	public void setContactor(String contactor) {
		this.contactor = contactor;
	}
	/**
	 * @return Returns the createDate.
	 */
	public java.util.Date getCreateDate() {
		return createDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(java.util.Date createDate) {
		this.createDate = createDate;
	}
	/**
	 * @return Returns the createPerson.
	 */
	public com.aof.component.domain.party.UserLogin getCreateUser() {
		return createUser;
	}
	/**
	 * @param createPerson The createPerson to set.
	 */
	public void setCreateUser(
			com.aof.component.domain.party.UserLogin createUser) {
		this.createUser = createUser;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the invoice.
	 */
	public ProjectInvoice getInvoice() {
		return invoice;
	}
	/**
	 * @param invoice The invoice to set.
	 */
	public void setInvoice(ProjectInvoice invoice) {
		this.invoice = invoice;
	}
	/**
	 * @return Returns the note.
	 */
	public String getNote() {
		return note;
	}
	/**
	 * @param note The note to set.
	 */
	public void setNote(String note) {
		this.note = note;
	}
	/**
	 * @return Returns the payAmount.
	 */
	public Double getPayAmount() {
		return payAmount;
	}
	/**
	 * @param payAmount The payAmount to set.
	 */
	public void setPayAmount(Double payAmount) {
		this.payAmount = payAmount;
	}
	/**
	 * @return Returns the payDate.
	 */
	public java.util.Date getPayDate() {
		return payDate;
	}
	/**
	 * @param payDate The payDate to set.
	 */
	public void setPayDate(java.util.Date payDate) {
		this.payDate = payDate;
	}
	/**
	 * @return Returns the responsiblePerson.
	 */
	public com.aof.component.domain.party.UserLogin getResponsiblePerson() {
		return responsiblePerson;
	}
	/**
	 * @param responsiblePerson The responsiblePerson to set.
	 */
	public void setResponsiblePerson(
			com.aof.component.domain.party.UserLogin responsiblePerson) {
		this.responsiblePerson = responsiblePerson;
	}
    /**
     * @return Returns the currency.
     */
    public com.aof.component.prm.project.CurrencyType getCurrency() {
        return currency;
    }
    /**
     * @param currency The currency to set.
     */
    public void setCurrency(com.aof.component.prm.project.CurrencyType currency) {
        this.currency = currency;
    }
	/**
	 * @return Returns the currencyId.
	 */
	public String getCurrencyId() {
		return currencyId;
	}
	/**
	 * @param currencyId The currencyId to set.
	 */
	public void setCurrencyId(String currencyId) {
		this.currencyId = currencyId;
	}
	/**
	 * @return Returns the responsiblePersonId.
	 */
	public String getResponsiblePersonId() {
		return responsiblePersonId;
	}
	/**
	 * @param responsiblePersonId The responsiblePersonId to set.
	 */
	public void setResponsiblePersonId(String responsiblePersonId) {
		this.responsiblePersonId = responsiblePersonId;
	}
    public String toString() {
        return new ToStringBuilder(this)
            .append("id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectInvoiceConfirmation) ) return false;
        ProjectInvoiceConfirmation castOther = (ProjectInvoiceConfirmation) other;
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

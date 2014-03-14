package com.aof.component.prm.Bill;

import java.io.Serializable;
import java.text.SimpleDateFormat;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectReceipt extends Object implements Serializable {

    /** identifier field */
    private Long id;

    /** nullable persistent field */
    private String receiptNo;

    /** nullable persistent field */
    private ProjectInvoice invoice;

    private Long invoiceId;
    
    private String invoiceCode;

    /** nullable persistent field */
    private Double receiveAmount;

    /** nullable persistent field */
    private com.aof.component.prm.project.CurrencyType currency;
    
    private String currencyId;

    /** nullable persistent field */
    private java.util.Date receiveDate;

    /** nullable persistent field */
    private String note;

    /** nullable persistent field */
    private com.aof.component.domain.party.UserLogin createUser;

    /** nullable persistent field */
    private java.util.Date createDate;
    
    /** nullable persistent field */
    private Float currencyRate;
    
	private String currencyString;
	private String userString;
	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	private String createDateString;
	private String receiveDateString;


    /** full constructor */
    public ProjectReceipt(Long id, 
    		              java.lang.String receiptNo, 
    		              ProjectInvoice invoice, 
						  Double receiveAmount, 
						  com.aof.component.prm.project.CurrencyType currency, 
						  java.util.Date receiveDate, 
						  java.lang.String note, 
						  com.aof.component.domain.party.UserLogin createUser, 
						  java.util.Date createDate,
						  Float currencyRate) {
        this.id = id;
        this.receiptNo = receiptNo;
        this.invoice = invoice;
        this.receiveAmount = receiveAmount;
        this.currency = currency;
        this.receiveDate = receiveDate;
        this.note = note;
        this.createUser = createUser;
        this.createDate = createDate;
        this.currencyRate = currencyRate;
    }

    /** default constructor */
    public ProjectReceipt() {
    }

    /** minimal constructor */
    public ProjectReceipt(Long id) {
        this.id = id;
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
	 * @return Returns the createUser.
	 */
	public com.aof.component.domain.party.UserLogin getCreateUser() {
		return createUser;
	}
	/**
	 * @param createUser The createUser to set.
	 */
	public void setCreateUser(
			com.aof.component.domain.party.UserLogin createUser) {
		this.createUser = createUser;
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
	 * @return Returns the receiptNo.
	 */
	public String getReceiptNo() {
		return receiptNo;
	}
	/**
	 * @param receiptNo The receiptNo to set.
	 */
	public void setReceiptNo(String receiptNo) {
		this.receiptNo = receiptNo;
	}
	/**
	 * @return Returns the receiveAmount.
	 */
	public Double getReceiveAmount() {
		return receiveAmount;
	}
	/**
	 * @param receiveAmount The receiveAmount to set.
	 */
	public void setReceiveAmount(Double receiveAmount) {
		this.receiveAmount = receiveAmount;
	}
	/**
	 * @return Returns the receiveDate.
	 */
	public java.util.Date getReceiveDate() {
		return receiveDate;
	}
	/**
	 * @param receiveDate The receiveDate to set.
	 */
	public void setReceiveDate(java.util.Date receiveDate) {
		this.receiveDate = receiveDate;
	}
    public boolean equals(Object other) {
        if ( !(other instanceof ProjectReceipt) ) return false;
        ProjectReceipt castOther = (ProjectReceipt) other;
        return new EqualsBuilder()
            .append(this.getId(), castOther.getId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
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
     * @return Returns the invoiceId.
     */
    public Long getInvoiceId() {
        return invoiceId;
    }
    /**
     * @param invoiceId The invoiceId to set.
     */
    public void setInvoiceId(Long invoiceId) {
        this.invoiceId = invoiceId;
    }
	/**
	 * @return Returns the currencyRate.
	 */
	public Float getCurrencyRate() {
		return currencyRate;
	}
	/**
	 * @param currencyRate The currencyRate to set.
	 */
	public void setCurrencyRate(Float currencyRate) {
		this.currencyRate = currencyRate;
	}

	public String getInvoiceCode() {
		return invoice.getInvoiceCode();
	}
	
	public String getCreateDateString() {
		return formatter.format(createDate);
	}

	public String getCurrencyString() {
		return currency.getCurrName();
	}


	public String getReceiveDateString() {
		return formatter.format(receiveDate);
	}

	public String getUserString() {
		return createUser.getUserLoginId()+":"+createUser.getName();
	}
	
	

}

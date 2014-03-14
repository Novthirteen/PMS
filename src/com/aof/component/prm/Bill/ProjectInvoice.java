package com.aof.component.prm.Bill;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectInvoice implements Serializable {

    /** identifier field */
    private Long Id;

    /** nullable persistent field */
    private String InvoiceCode;

    /** nullable persistent field */
    private java.util.Date CreateDate;

    /** nullable persistent field */
    private com.aof.component.domain.party.UserLogin CreateUser;
    
    private String createUserId;

    /** nullable persistent field */
    private com.aof.component.prm.Bill.ProjectEMS EMS;
    
    private Long emsId;

    /** nullable persistent field */
    private com.aof.component.prm.project.ProjectMaster Project;
    
    private String projectId;
    
    /** nullable persistent field */
    private com.aof.component.crm.customer.CustomerProfile BillAddress;
    
    private String billAddressId;
    
    /** nullable persistent field */
    private Double Amount;
    
    /** nullable persistent field */
    private String Status;
    
    /** nullable persistent field */
    private String Note;
    
    /** nullable persistent field */
    private com.aof.component.prm.project.CurrencyType Currency;
    
    private String currencyId;
    
    /** nullable persistent field */
    private Float CurrencyRate;
    
    /** nullable persistent field */
    //private Set billings;
    
    private Long billId;
    
    /** nullable persistent field */
    private java.util.Date InvoiceDate;

    /** nullable persistent field */
    private com.aof.component.domain.party.UserLogin InvoiceUser;
    
    private String invoiceUserId;
    
    private com.aof.component.prm.Bill.ProjectBill Billing;
    
    private Set confirms;
    
    private Set receipts;
    
    private String InvoiceType;
    
    /** full constructor */
    public ProjectInvoice(java.lang.String InvoiceCode, 
    		              java.util.Date CreateDate, 
						  com.aof.component.domain.party.UserLogin CreateUser, 
						  com.aof.component.prm.Bill.ProjectEMS EMS, 
						  com.aof.component.prm.project.ProjectMaster Project,
						  com.aof.component.crm.customer.CustomerProfile BillAddress,
						  Double Amount,
						  String Status,
						  String Note,
						  com.aof.component.prm.project.CurrencyType Currency,
						  Float CurrencyRate,
						  //Set billings,
						  java.util.Date InvoiceDate,
						  com.aof.component.domain.party.UserLogin InvoiceUser,
						  com.aof.component.prm.Bill.ProjectBill Billing,
						  Set confirms,
						  Set receipts,
						  String InvoiceType) {
        this.InvoiceCode = InvoiceCode;
        this.CreateDate = CreateDate;
        this.CreateUser = CreateUser;
        this.EMS = EMS;
        this.Project = Project;
        this.BillAddress = BillAddress;
        this.Amount = Amount;
        this.Status = Status;
        this.Note = Note;
        this.Currency = Currency;
        this.CurrencyRate = CurrencyRate;
        //this.billings = billings;
        this.InvoiceDate = InvoiceDate;
        this.InvoiceUser = InvoiceUser;
        this.Billing = Billing;
        this.confirms = confirms;
        this.receipts = receipts;
        this.InvoiceType = InvoiceType;
    }

    /** default constructor */
    public ProjectInvoice() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public java.lang.String getInvoiceCode() {
        return this.InvoiceCode;
    }

	public void setInvoiceCode(java.lang.String InvoiceCode) {
		this.InvoiceCode = InvoiceCode;
	}

    public java.util.Date getCreateDate() {
        return this.CreateDate;
    }

	public void setCreateDate(java.util.Date CreateDate) {
		this.CreateDate = CreateDate;
	}

    public com.aof.component.domain.party.UserLogin getCreateUser() {
        return this.CreateUser;
    }

	public void setCreateUser(com.aof.component.domain.party.UserLogin CreateUser) {
		this.CreateUser = CreateUser;
	}

    public com.aof.component.prm.Bill.ProjectEMS getEMS() {
        return this.EMS;
    }

	public void setEMS(com.aof.component.prm.Bill.ProjectEMS EMS) {
		this.EMS = EMS;
	}

    public com.aof.component.prm.project.ProjectMaster getProject() {
        return this.Project;
    }

	public void setProject(com.aof.component.prm.project.ProjectMaster Project) {
		this.Project = Project;
	}
	
	/**
	 * @return Returns the amount.
	 */
	public Double getAmount() {
		return Amount;
	}
	/**
	 * @param amount The amount to set.
	 */
	public void setAmount(Double amount) {
		Amount = amount;
	}
	/**
	 * @return Returns the customer.
	 */
	public com.aof.component.crm.customer.CustomerProfile getBillAddress() {
		return BillAddress;
	}
	/**
	 * @param customer The customer to set.
	 */
	public void setBillAddress(com.aof.component.crm.customer.CustomerProfile BillAddress) {
		this.BillAddress = BillAddress;
	}
	/**
	 * @return Returns the note.
	 */
	public String getNote() {
		return Note;
	}
	/**
	 * @param note The note to set.
	 */
	public void setNote(String note) {
		Note = note;
	}
	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return Status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		Status = status;
	}
	/**
	 * @return Returns the currency.
	 */
	public com.aof.component.prm.project.CurrencyType getCurrency() {
		return Currency;
	}
	/**
	 * @param currency The currency to set.
	 */
	public void setCurrency(com.aof.component.prm.project.CurrencyType currency) {
		Currency = currency;
	}
	/**
	 * @return Returns the currencyRate.
	 */
	public Float getCurrencyRate() {
		return CurrencyRate;
	}
	/**
	 * @param currencyRate The currencyRate to set.
	 */
	public void setCurrencyRate(Float currencyRate) {
		CurrencyRate = currencyRate;
	}
	/**
	 * @return Returns the invoiceDate.
	 */
	public java.util.Date getInvoiceDate() {
		return InvoiceDate;
	}
	/**
	 * @param invoiceDate The invoiceDate to set.
	 */
	public void setInvoiceDate(java.util.Date invoiceDate) {
		InvoiceDate = invoiceDate;
	}
	/**
	 * @return Returns the invoiceUser.
	 */
	public com.aof.component.domain.party.UserLogin getInvoiceUser() {
		return InvoiceUser;
	}
	/**
	 * @param invoiceUser The invoiceUser to set.
	 */
	public void setInvoiceUser(
			com.aof.component.domain.party.UserLogin invoiceUser) {
		InvoiceUser = invoiceUser;
	}
    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectInvoice) ) return false;
        ProjectInvoice castOther = (ProjectInvoice) other;
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
	 * @return Returns the createUserId.
	 */
	public String getCreateUserId() {
		return createUserId;
	}
	/**
	 * @param createUserId The createUserId to set.
	 */
	public void setCreateUserId(String createUserId) {
		this.createUserId = createUserId;
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
	 * @return Returns the customerId.
	 */
	public String getBillAddressId() {
		return billAddressId;
	}
	/**
	 * @param customerId The customerId to set.
	 */
	public void setBillAddressId(String billAddressId) {
		this.billAddressId = billAddressId;
	}
	/**
	 * @return Returns the emsId.
	 */
	public Long getEmsId() {
		return emsId;
	}
	/**
	 * @param emsId The emsId to set.
	 */
	public void setEmsId(Long emsId) {
		this.emsId = emsId;
	}
	/**
	 * @return Returns the invoiceUserId.
	 */
	public String getInvoiceUserId() {
		return invoiceUserId;
	}
	/**
	 * @param invoiceUserId The invoiceUserId to set.
	 */
	public void setInvoiceUserId(String invoiceUserId) {
		this.invoiceUserId = invoiceUserId;
	}
	/**
	 * @return Returns the projectId.
	 */
	public String getProjectId() {
		return projectId;
	}
	/**
	 * @param projectId The projectId to set.
	 */
	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	/**
	 * @return Returns the billId.
	 */
	public Long getBillId() {
		return billId;
	}
	/**
	 * @param billId The billId to set.
	 */
	public void setBillId(Long billId) {
		this.billId = billId;
	}
	
	/**
	 * @return Returns the billing.
	 */
	public com.aof.component.prm.Bill.ProjectBill getBilling() {
		return Billing;
	}
	/**
	 * @param billing The billing to set.
	 */
	public void setBilling(com.aof.component.prm.Bill.ProjectBill billing) {
		Billing = billing;
	}
	/**
	 * @return Returns the confirms.
	 */
	public Set getConfirms() {
		return confirms;
	}
	/**
	 * @param confirms The confirms to set.
	 */
	public void setConfirms(Set confirms) {
		this.confirms = confirms;
	}
	public void addConfirm(com.aof.component.prm.Bill.ProjectInvoiceConfirmation confirm) {
		if (confirms == null) {
			confirms = new HashSet();
		}
		
		confirms.add(confirm);
	}
	public void removeConfirm(com.aof.component.prm.Bill.ProjectInvoiceConfirmation confirm) {
		if (confirms != null) {
			confirms.remove(confirm);
		}
	}
	/**
	 * @return Returns the receipts.
	 */
	public Set getReceipts() {
		return receipts;
	}
	/**
	 * @param receipts The receipts to set.
	 */
	public void setReceipts(Set receipts) {
		this.receipts = receipts;
	}
	
	public void addReceipt(com.aof.component.prm.Bill.ProjectReceipt receipt) {
		if (receipts == null) {
			receipts = new HashSet();
		}
		
		receipts.add(receipt);
	}
	public void removeReceipt(com.aof.component.prm.Bill.ProjectReceipt receipt) {
		if (receipts != null) {
			receipts.remove(receipt);
		}
	}
	/**
	 * @return Returns the invoiceType.
	 */
	public String getInvoiceType() {
		return InvoiceType;
	}
	/**
	 * @param invoiceType The invoiceType to set.
	 */
	public void setInvoiceType(String invoiceType) {
		InvoiceType = invoiceType;
	}
	
	public Double getRemaingAmount(){
		double value = this.getAmount().doubleValue() * this.getCurrencyRate().doubleValue();
		Set receiptSet = this.getReceipts();
		Iterator i = receiptSet.iterator();
		while(i.hasNext()){
			ProjectReceipt pr = (ProjectReceipt)i.next();
		//	value -= pr.getCurrencyRate().doubleValue() * pr.getReceiveAmount().doubleValue();
			value -= pr.getReceiveAmount().doubleValue();
		}
		//adjust amount 
		if(value < 1 && value > -1) 
			value = 0;
		return new Double(value);
	}
}

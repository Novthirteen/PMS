package com.aof.component.prm.payment;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.prm.Bill.TransacationComparator;
import com.aof.component.prm.expense.ProjectCostMaster;
import com.aof.util.Constants;

/** @author Hibernate CodeGenerator */
public class ProjectPayment implements Serializable {

    /** identifier field */
    private Long Id;

    /** nullable persistent field */
    private String PaymentCode;

    /** nullable persistent field */
    private String Type;

    /** nullable persistent field */
    private Double CalAmount;
    
    /** nullable persistent field */
    private Double settledAmount;

    /** nullable persistent field */
    //private double Amount;

    /** nullable persistent field */
    private com.aof.component.prm.project.ProjectMaster Project;

    /** nullable persistent field */
    private com.aof.component.crm.vendor.VendorProfile PayAddress;

    /** nullable persistent field */
    //private ProjectCostMaster Invoice;

    /** nullable persistent field */
    private java.util.Date CreateDate;

    /** nullable persistent field */
    private com.aof.component.domain.party.UserLogin CreateUser;
    
    private Set details;
   //private Set invoices;
    private String Status;
    
    private String Note;
    
    private Set settleRecords;


    /** full constructor */
    public ProjectPayment(java.lang.String PaymentCode, 
    		              java.lang.String Type, 
						  Double CalAmount, 
						  Double settledAmount, 
						  com.aof.component.prm.project.ProjectMaster Project, 
						  com.aof.component.crm.vendor.VendorProfile PayAddress, 
						  //ProjectCostMaster Invoice, 
						  Set invoices,
						  java.util.Date CreateDate, 
						  com.aof.component.domain.party.UserLogin CreateUser, 
						  Set details,
						  String Status,
						   String Note) {
        this.PaymentCode = PaymentCode;
        this.Type = Type;
        this.CalAmount = CalAmount;
        this.settledAmount = settledAmount;
        this.Project = Project;
        this.PayAddress = PayAddress;
        //this.Invoice = Invoice;
        this.CreateDate = CreateDate;
        this.CreateUser = CreateUser;
        this.details = details;
    }

    /** default constructor */
    public ProjectPayment() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public java.lang.String getPaymentCode() {
        return this.PaymentCode;
    }

	public void setPaymentCode(java.lang.String PaymentCode) {
		this.PaymentCode = PaymentCode;
	}

    public java.lang.String getType() {
        return this.Type;
    }

	public void setType(java.lang.String Type) {
		this.Type = Type;
	}

    public Double getCalAmount() {
        return this.CalAmount;
    }

	public void setCalAmount(Double CalAmount) {
		this.CalAmount = CalAmount;
	}

	/*
    public double getAmount() {
        return this.Amount;
    }

	public void setAmount(double Amount) {
		this.Amount = Amount;
	}
	*/

    public com.aof.component.prm.project.ProjectMaster getProject() {
        return this.Project;
    }

	public void setProject(com.aof.component.prm.project.ProjectMaster Project) {
		this.Project = Project;
	}

    public com.aof.component.crm.vendor.VendorProfile getPayAddress() {
        return this.PayAddress;
    }

	public void setPayAddress(com.aof.component.crm.vendor.VendorProfile PayAddress) {
		this.PayAddress = PayAddress;
	}

	/*
    public ProjectCostMaster getInvoice() {
        return this.Invoice;
    }

	public void setInvoice(ProjectCostMaster Invoice) {
		this.Invoice = Invoice;
	}
	*/

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

    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectPayment) ) return false;
        ProjectPayment castOther = (ProjectPayment) other;
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
	 * @return Returns the details.
	 */
	public Set getDetails() {
		return details;
	}
	/**
	 * @param details The details to set.
	 */
	public void setDetails(Set details) {
		this.details = details;
	}
	
	public void addDetail(PaymentTransactionDetail detail) {
		if (details == null) {
			details = new HashSet();
		}
		
		details.add(detail);
	}
	
	public void removeDetail(PaymentTransactionDetail detail) {
		if (details != null) {
			details.remove(detail);
		}
	}
	
	public List getExpenseDetails() {	
		return getDetailsByCategory(Constants.TRANSACATION_CATEGORY_EXPENSE);
	}
	
	public double getExpenseAmount() {
		return calculateAmount(getExpenseDetails());
	}
	
	public List getCAFDetails() {
		return getDetailsByCategory(Constants.TRANSACATION_CATEGORY_CAF);
	}
	
	public double getCAFAmount() {
		return calculateAmount(getCAFDetails());
	}
	
	public List getPaymentDetails() {
		return getDetailsByCategory(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE);
	}
	
	public double getCreditDownPaymentAmount() {
		return calculateAmount(getCreditDownPaymentDetails());
	}
	
	public List getCreditDownPaymentDetails() {
		return getDetailsByCategory(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
	}
	
	public double getDownPaymentAmount() {
		return calculateAmount(getDownPaymentDetails());
	}
	
	public List getDownPaymentDetails() {
		return getDetailsByCategory(Constants.TRANSACATION_CATEGORY_DOWN_PAYMENT);
	}
	
	public double getPaymentAmount() {
		return calculateAmount(getPaymentDetails());
	}
	
	private List getDetailsByCategory(String category) {
		if (details == null) {
			return null;
		}
		
		List list = null;
		Iterator iterator  = details.iterator();
		while (iterator.hasNext()) {
			PaymentTransactionDetail btd = (PaymentTransactionDetail)iterator.next();
			if (btd.getTransactionCategory().equals(category)) {
				if (list == null) {
					list = new ArrayList();
				}
				list.add(btd);
			}
		}
		if (list != null) {
			Collections.sort(list, new TransacationComparator());
		}
		return list;
	}
	
	private double calculateAmount(List list) {
		double amount = 0L;
		
		if (list != null) {
			for (int i0 = 0; i0 < list.size(); i0++) {
				PaymentTransactionDetail btd = (PaymentTransactionDetail)list.get(i0);
				if (btd != null && btd.getAmount() != null) {
					amount = amount + btd.getAmount().doubleValue() * btd.getExchangeRate().doubleValue();
				}
			}
		}
		
		BigDecimal Amount = new BigDecimal(amount);
		Amount = Amount.setScale(2, BigDecimal.ROUND_HALF_UP);
		
		return Amount.doubleValue();
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
	
	public boolean isFreezed() {
		return !Constants.PAYMENT_STATUS_DRAFT.equalsIgnoreCase(getStatus()) ? true : false;
	}
	
	public boolean isClosed() {
		return Constants.PAYMENT_STATUS_COMPLETED.equalsIgnoreCase(getStatus()) ? true : false;
	}
	/**
	 * @return Returns the invoices.
	 */
//	public Set getInvoices() {
//		return invoices;
//	}
//	/**
//	 * @param invoices The invoices to set.
//	 */
//	public void setInvoices(Set invoices) {
//		this.invoices = invoices;
//	}
//	
//	public void addInvoice(ProjectCostMaster pcm) {
//		if (invoices == null) {
//			invoices = new HashSet();
//		}
//		
//		invoices.add(pcm);
//	}
//	
//	public void remvoeInvoice(ProjectCostMaster pcm) {
//		if (invoices != null) {
//			invoices.remove(pcm);
//		}
//	}

//	public double getRemainingAmount(Long pId) {
//		double invoicedAmount = 0L;
//		
//		if (invoices != null) {
//			Iterator it = invoices.iterator();
//			while(it.hasNext()) {
//				ProjectCostMaster pi = (ProjectCostMaster)it.next();
//				if(pi.getPayment()!=null && !pi.getPayStatus().equals("Cancelled"))  {
//					if ((pi.getPayment().getId()== pId) && (pi.getTotalvalue() != 0)) {
//						invoicedAmount += pi.getTotalvalue() * pi.getCurrency().getCurrRate().floatValue();
//					}
//				}
//			}
//		}
//		
//		//double calAmount = getCalAmount();
//		BigDecimal remainAmount = 
//			new BigDecimal((this.CalAmount != null ? this.CalAmount.doubleValue() : 0D) - invoicedAmount);
//		remainAmount = remainAmount.setScale(2, BigDecimal.ROUND_HALF_UP);
//		if(remainAmount.doubleValue() > -1 && remainAmount.doubleValue() < 1)
//			remainAmount = new BigDecimal(0);
//		return remainAmount.doubleValue();
//	}
	
	//new version by Bill Yu
//	public double getRemainAmount(){
//		double amount = this.getCalAmount().doubleValue(); // * Currency ;
//		
//		if (this.settleRecords != null) {
//			Iterator it = this.settleRecords.iterator();
//			while(it.hasNext()) {
//				ProjPaymentTransaction ppt = (ProjPaymentTransaction)it.next();
//				amount -= ppt.getAmount().doubleValue();
//			}
//		}
//		
//		if(amount > -1 && amount < 1)
//			amount = 0;
//		return amount;
//	}
	
	/**
	 * @return Returns the settleRecords.
	 */
	public Set getSettleRecords() {
		return settleRecords;
	}
	/**
	 * @param settleRecords The settleRecords to set.
	 */
	public void setSettleRecords(Set settleRecords) {
		this.settleRecords = settleRecords;
	}
	
	public void addSettleRecord(ProjPaymentTransaction ppt) {
		if (this.settleRecords == null) {
			this.settleRecords = new HashSet();
		}
		
		this.settleRecords.add(ppt);
	}
	
	public void removeSettleRecord(ProjPaymentTransaction ppt) {
		if (this.settleRecords != null) {
			this.settleRecords.remove(ppt);
		}
	}

	/**
	 * @return Returns the settledAmount.
	 */
	public Double getSettledAmount() {
		return settledAmount;
	}

	/**
	 * @param settledAmount The settledAmount to set.
	 */
	public void setSettledAmount(Double settledAmount) {
		this.settledAmount = settledAmount;
	}
}

package com.aof.component.prm.Bill;

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

import com.aof.util.Constants;

/** @author Hibernate CodeGenerator */
public class ProjectBill implements Serializable {

    /** identifier field */
    private Long Id;

    /** nullable persistent field */
    private String BillCode;

    /** nullable persistent field */
    private String BillType;

    /** nullable persistent field */
    private Double CalAmount;

    /** nullable persistent field */
    //private Double Amount;

    /** nullable persistent field */
    private com.aof.component.prm.project.ProjectMaster Project;

    /** nullable persistent field */
    private com.aof.component.crm.customer.CustomerProfile BillAddress;

    /** nullable persistent field */
    //private ProjectInvoice Invoice;

    /** nullable persistent field */
    private java.util.Date CreateDate;

    /** nullable persistent field */
    private com.aof.component.domain.party.UserLogin CreateUser;
    
    private Set details;
    
    private Set invoices;
    
    private String Status;
    
    private String Note;

    /** full constructor */
    public ProjectBill(java.lang.String BillCode, 
    		           java.lang.String BillType, 
					   Double CalAmount, 
					   //Double Amount, 
					   com.aof.component.prm.project.ProjectMaster Project, 
					   com.aof.component.crm.customer.CustomerProfile BillAddress, 
					   //ProjectInvoice Invoice, 
					   java.util.Date CreateDate, 
					   com.aof.component.domain.party.UserLogin CreateUser, 
					   Set details,
					   Set invoices,
					   String Status,
					   String Note) {
        this.BillCode = BillCode;
        this.BillType = BillType;
        this.CalAmount = CalAmount;
        //this.Amount = Amount;
        this.Project = Project;
        this.BillAddress = BillAddress;
        //this.Invoice = Invoice;
        this.CreateDate = CreateDate;
        this.CreateUser = CreateUser;
        this.details = details;
    }

    /** default constructor */
    public ProjectBill() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public java.lang.String getBillCode() {
        return this.BillCode;
    }

	public void setBillCode(java.lang.String BillCode) {
		this.BillCode = BillCode;
	}

    public java.lang.String getBillType() {
        return this.BillType;
    }

	public void setBillType(java.lang.String BillType) {
		this.BillType = BillType;
	}

	
    public Double getCalAmount() {
        return this.CalAmount;
    }

	public void setCalAmount(Double CalAmount) {
		this.CalAmount = CalAmount;
	}
	/*
    public Double getAmount() {
        return this.Amount;
    }

	public void setAmount(Double Amount) {
		this.Amount = Amount;
	}
	*/

    public com.aof.component.prm.project.ProjectMaster getProject() {
        return this.Project;
    }

	public void setProject(com.aof.component.prm.project.ProjectMaster Project) {
		this.Project = Project;
	}

    public com.aof.component.crm.customer.CustomerProfile getBillAddress() {
        return this.BillAddress;
    }

	public void setBillAddress(com.aof.component.crm.customer.CustomerProfile BillAddress) {
		this.BillAddress = BillAddress;
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

    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectBill) ) return false;
        ProjectBill castOther = (ProjectBill) other;
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
	
	public List getExpenseDetails() {
		
		List list = getDetailsByCategory(Constants.TRANSACATION_CATEGORY_EXPENSE);
		
		if (list != null) {
			List list1 = getDetailsByCategory(Constants.TRANSACATION_CATEGORY_OTHER_COST);
			if (list1 != null) {
				list.addAll(list1);
			}
		} else {
			list = getDetailsByCategory(Constants.TRANSACATION_CATEGORY_OTHER_COST);
		}
		
		return list;
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
	
	public List getAllowanceDetails() {
		return getDetailsByCategory(Constants.TRANSACATION_CATEGORY_ALLOWANCE);
	}
	
	public double getAllowanceAmount() {
		return calculateAmount(getAllowanceDetails());
	}
	
	public List getBillingDetails() {
		return getDetailsByCategory(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);
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
	
	public void addDetail(BillTransactionDetail detail) {
		if (details == null) {
			details = new HashSet();
		}
		
		details.add(detail);
	}
	
	public void removeDetail(BillTransactionDetail detail) {
		if (details != null) {
			details.remove(detail);
		}
	}
	
	public double getBillingAmount() {
		return calculateAmount(getBillingDetails());
	}
	
	private List getDetailsByCategory(String category) {
		if (details == null) {
			return null;
		}
		
		List list = null;
		Iterator iterator  = details.iterator();
		while (iterator.hasNext()) {
			BillTransactionDetail btd = (BillTransactionDetail)iterator.next();
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
	
	/*
	public double getCalAmount() {
		double amount = 0L;
		
		amount += getExpenseAmount();
		amount += getCAFAmount();
		amount += getAllowanceAmount();
		amount += getBillingAmount();
		amount += getCreditDownPaymentAmount();
		amount += getDownPaymentAmount();
		
		return amount;
	}
	*/
	
	private double calculateAmount(List list) {
		double amount = 0L;
		
		if (list != null) {
			for (int i0 = 0; i0 < list.size(); i0++) {
				BillTransactionDetail btd = (BillTransactionDetail)list.get(i0);
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
	 * @return Returns the invoices.
	 */
	public Set getInvoices() {
		return invoices;
	}
	/**
	 * @param invoices The invoices to set.
	 */
	public void setInvoices(Set invoices) {
		this.invoices = invoices;
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
	
	public void addInvoice(ProjectInvoice pi) {
		if (invoices == null) {
			invoices = new HashSet();
		}
		
		invoices.add(pi);
	}
	
	public void remvoeInvoice(ProjectInvoice pi) {
		if (invoices != null) {
			invoices.remove(pi);
		}
	}
	
	public boolean isFreezed() {
		return !Constants.BILLING_STATUS_DRAFT.equalsIgnoreCase(getStatus()) ? true : false;
	}
	
	public boolean isClosed() {
		return Constants.BILLING_STATUS_COMPLETED.equalsIgnoreCase(getStatus()) ? true : false;
	}
	
	public double getRemainingAmount() {
		double invoicedAmount = 0L;
		
		if (invoices != null) {
			Iterator it = invoices.iterator();
			while(it.hasNext()) {
				ProjectInvoice pi = (ProjectInvoice)it.next();
				if (!pi.getStatus().equals(Constants.INVOICE_STATUS_CANCELED) && pi.getAmount() != null) {
					invoicedAmount += pi.getAmount().doubleValue() * pi.getCurrency().getCurrRate().floatValue();
				}
			}
		}
		
		//double calAmount = getCalAmount();
		BigDecimal remainAmount = 
			new BigDecimal((this.CalAmount != null ? this.CalAmount.doubleValue() : 0D) - invoicedAmount);
		remainAmount = remainAmount.setScale(2, BigDecimal.ROUND_HALF_UP);
		return remainAmount.doubleValue();
	}
}

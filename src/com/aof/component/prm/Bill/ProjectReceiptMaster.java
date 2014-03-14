/**
 * Atos Origin China ## All Right Reserved. 
 */

package com.aof.component.prm.Bill;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.HashSet;
import java.util.IdentityHashMap;
import java.util.Iterator;
import java.util.Set;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.CurrencyType;
import com.aof.util.UtilFormat;

/**
 * @author stanley
 *
 */
public class ProjectReceiptMaster {
	
	private String receiptNo;
	private String faReceiptNo;
	private Double receiptAmount;
	private CurrencyType currency;
	private Float exchangeRate;
	private UserLogin createUser;
	private java.util.Date createDate;
	private java.util.Date receiptDate;
	private CustomerProfile customerId;
	private String receiptStatus;
	private String receiptType;
	private String note;
	private String location;
	private Set invoices;
	
	//decorated attributes for Display-Tag
	private String currencyString;
	private String userString;
	private String amountString;
	private String createDateString;
	private String receiptDateString;
	private String customerString;
	private String amtstr;
	 

	private Double remainAmount;
	
	public java.util.Date getCreateDate() {
		return createDate;
	}
	
	public void setCreateDate(java.util.Date createDate) {
		this.createDate = createDate;
	}
	
	public UserLogin getCreateUser() {
		return createUser;
	}
	
	public void setCreateUser(UserLogin createUser) {
		this.createUser = createUser;
	}
	
	public CurrencyType getCurrency() {
		return currency;
	}
	
	public void setCurrency(CurrencyType currency) {
		this.currency = currency;
	}
	
	public CustomerProfile getCustomerId() {
		return customerId;
	}
	
	public void setCustomerId(CustomerProfile customerId) {
		this.customerId = customerId;
	}
	
	public Float getExchangeRate() {
		return exchangeRate;
	}
	
	public void setExchangeRate(Float exchangeRate) {
		this.exchangeRate = exchangeRate;
	}
	
	public Double getReceiptAmount() {
		return receiptAmount;
	}
	
	public void setReceiptAmount(Double receiptAmount) {
		this.receiptAmount = receiptAmount;
	}
	
	public java.util.Date getReceiptDate() {
		return receiptDate;
	}
	
	public void setReceiptDate(java.util.Date receiptDate) {
		this.receiptDate = receiptDate;
	}
	
	public String getReceiptNo() {
		return receiptNo;
	}
	
	public void setReceiptNo(String receiptNo) {
		this.receiptNo = receiptNo;
	}
	
	/**
	 * @return Returns the receiptstatus.
	 */
	public String getReceiptStatus() {
		return receiptStatus;
	}
	/**
	 * @param receiptstatus The receiptstatus to set.
	 */
	public void setReceiptStatus(String receiptStatus) {
		this.receiptStatus = receiptStatus;
	}
	public void addInvoice(com.aof.component.prm.Bill.ProjectReceipt receiptInvoice) {
		if (invoices == null) {
			invoices = new HashSet();
		}
		
		this.getInvoices().add(receiptInvoice);
	}
	public void removeInvoice(com.aof.component.prm.Bill.ProjectReceipt receiptInvoice) {
		
			this.getInvoices().remove(receiptInvoice);
		
	}
	/**
	 * @return Returns the invoices.
	 */
	public Set getInvoices() {
		if(this.invoices == null)
			this.invoices = new java.util.HashSet();
		return this.invoices;
	}
	/**
	 * @param invoices The invoices to set.
	 */
	public void setInvoices(Set invoices) {
		this.invoices = invoices;
	}

	public String getCreateDateString() {
		return UtilFormat.getDateFormatter().format(createDate);
	}

	public String getCurrencyString() {
		return currency.getCurrName();
	}

	public String getCustomerString() {
		return customerId.getPartyId()+":"+customerId.getDescription();
	}

	public String getReceiptDateString() {
		return UtilFormat.getDateFormatter().format(receiptDate);
	}

	public String getUserString() {
		return createUser.getUserLoginId()+":"+createUser.getName();
	}
	
	public Double getRemainAmount(){
		ReceiptService s = new ReceiptService();
		return s.getRemainAmount(this);
	}
	/**
	 * @return Returns the amtstr.
	 */
	public String getAmtstr() {
		return UtilFormat.getNumFormatter().format(this.getRemainAmount());
	}
	public String getFaReceiptNo() {
		return faReceiptNo;
	}

	public void setFaReceiptNo(String faReceiptNo) {
		this.faReceiptNo = faReceiptNo;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	/**
	 * @return Returns the receiptType.
	 */
	public String getReceiptType() {
		return receiptType;
	}

	/**
	 * @param receiptType The receiptType to set.
	 */
	public void setReceiptType(String receiptType) {
		this.receiptType = receiptType;
	}

	public String getAmountString() {
		return UtilFormat.getNumFormatter().format(this.getReceiptAmount().doubleValue());
	}
	
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
}

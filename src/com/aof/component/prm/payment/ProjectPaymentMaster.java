/**
 * Atos Origin China - all right reserved.
 */

package com.aof.component.prm.payment;

import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.expense.ProjectCostMaster;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.util.Constants;
import com.aof.util.UtilFormat;

/**
 * @author stanley
 *
 */
public class ProjectPaymentMaster {
	
	private String payCode;
	private String faPaymentNo;
	private String payType;
	private double payAmount;
	private Float exchangeRate;
	private CurrencyType currency;
	private UserLogin createUser;
	private Date createDate;
	private Date payDate;
	private ProjectMaster poProjId;
	private VendorProfile vendorId;
	private String payStatus;
	private String note;
	private Set invoicePayments;
	private String settleStatus;
	private Set settleRecords;
	
	private String amountString;
	private String settledRemainingAmountString;
	
	/**
	 * @return Returns the createDate.
	 */
	public Date getCreateDate() {
		return createDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	/**
	 * @return Returns the createUser.
	 */
	public UserLogin getCreateUser() {
		return createUser;
	}
	/**
	 * @param createUser The createUser to set.
	 */
	public void setCreateUser(UserLogin createUser) {
		this.createUser = createUser;
	}
	/**
	 * @return Returns the currency.
	 */
	public CurrencyType getCurrency() {
		return currency;
	}
	/**
	 * @param currency The currency to set.
	 */
	public void setCurrency(CurrencyType currency) {
		this.currency = currency;
	}
	/**
	 * @return Returns the exchangeRate.
	 */
	public Float getExchangeRate() {
		return exchangeRate;
	}
	/**
	 * @param exchangeRate The exchangeRate to set.
	 */
	public void setExchangeRate(Float exchangeRate) {
		this.exchangeRate = exchangeRate;
	}
	/**
	 * @return Returns the faPaymentNo.
	 */
	public String getFaPaymentNo() {
		return faPaymentNo;
	}
	/**
	 * @param faPaymentNo The faPaymentNo to set.
	 */
	public void setFaPaymentNo(String faPaymentNo) {
		this.faPaymentNo = faPaymentNo;
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
	public double getPayAmount() {
		return payAmount;
	}
	/**
	 * @param payAmount The payAmount to set.
	 */
	public void setPayAmount(double payAmount) {
		this.payAmount = payAmount;
	}
	/**
	 * @return Returns the payCode.
	 */
	public String getPayCode() {
		return payCode;
	}
	/**
	 * @param payCode The payCode to set.
	 */
	public void setPayCode(String payCode) {
		this.payCode = payCode;
	}
	/**
	 * @return Returns the payDate.
	 */
	public Date getPayDate() {
		return payDate;
	}
	/**
	 * @param payDate The payDate to set.
	 */
	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}
	/**
	 * @return Returns the payStatus.
	 */
	public String getPayStatus() {
		return payStatus;
	}
	/**
	 * @param payStatus The payStatus to set.
	 */
	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}
	/**
	 * @return Returns the payType.
	 */
	public String getPayType() {
		return payType;
	}
	/**
	 * @param payType The payType to set.
	 */
	public void setPayType(String payType) {
		this.payType = payType;
	}
	/**
	 * @return Returns the vendorId.
	 */
	public VendorProfile getVendorId() {
		return vendorId;
	}
	/**
	 * @param vendorId The vendorId to set.
	 */
	public void setVendorId(VendorProfile vendorId) {
		this.vendorId = vendorId;
	}
	
	public String getCreateDateString() {
		return UtilFormat.getDateFormatter().format(createDate);
	}
	
	public String getCreateUserString() {
		return createUser.getUserLoginId()+":"+createUser.getName();
	}
	
	public String getCurrencyString() {
		return currency.getCurrName();
	}
	
	public String getPayDateString() {
		return UtilFormat.getDateFormatter().format(payDate);
	}
	
	public String getVendorString() {
		return vendorId.getPartyId()+":"+vendorId.getDescription();
	}
	public Set getInvoicePayments() {
		if(this.invoicePayments == null)
			this.invoicePayments = new HashSet();
		return invoicePayments;
	}
	public void setInvoicePayments(Set invoicePayments) {
		this.invoicePayments = invoicePayments;
	}
	
	public void addInvoicePayment(ProjectCostMaster pcm){
		this.getInvoicePayments().add(pcm);
	}

	public void removeInvoicePayment(ProjectCostMaster pcm){
		this.getInvoicePayments().remove(pcm);
	}
	
	/*privious version of "getRemainAmount"
	public double getRemainAmount(){
		
		double amount = this.payAmount * (this.exchangeRate==null?0:this.exchangeRate.floatValue());
		Iterator i = this.getInvoicePayments().iterator();
		while(i.hasNext()){
			ProjectCostMaster pcm = (ProjectCostMaster)i.next();
			if(pcm.getPayStatus() != null && !pcm.getPayStatus().equalsIgnoreCase("Cancelled")){
				double settledAmount = pcm.getTotalvalue(); //* pcm.getExchangerate();
				amount -= settledAmount;
			}
		}
		if(amount > -1 && amount < 1) amount = 0;
		return amount;
	}
	*/
	
	/*
	public double getRemainAmount(){
		double amount = this.payAmount * (this.exchangeRate==null?0:this.exchangeRate.floatValue());
		if(this.getSettleRecords()==null){
			return amount;
		}
		Iterator i = this.getSettleRecords().iterator();
		while(i.hasNext()){
			ProjPaymentTransaction ppt = (ProjPaymentTransaction)i.next();
			double settledAmount = ppt.getAmount().doubleValue();
			amount -= settledAmount;
		}
		if(amount > -1 && amount < 1) amount = 0;
		return amount;
	}
	*/
	public String getAmountString() {
		return UtilFormat.getNumFormatter().format(this.getPayAmount());
	}
	
	public String getRemainAmountString() {
		return UtilFormat.getNumFormatter().format(this.getSettledRemainingAmount());
	}
	
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
	/**
	 * @return Returns the settleStatus.
	 */
	public String getSettleStatus() {
		return settleStatus;
	}
	/**
	 * @param settleStatus The settleStatus to set.
	 */
	public void setSettleStatus(String settleStatus) {
		this.settleStatus = settleStatus;
	}
	
	public double getSettledAmount() {
		double amount = 0;
		if(this.getSettleRecords()==null){
			return amount;
		}
		Iterator i = this.getSettleRecords().iterator();
		while(i.hasNext()){
			ProjPaymentTransaction ppt = (ProjPaymentTransaction)i.next();
			double settledAmount = ppt.getAmount().doubleValue();
			amount += settledAmount;
		}
		
		return amount;
	}
	
	public double getSettledRemainingAmount() {
		return payAmount * this.exchangeRate.floatValue() - getSettledAmount();
	}
	
	public double getPaidAmount() {
		double amount = 0;
		if(this.getSettleRecords()==null){
			return amount;
		}
		Iterator i = this.getSettleRecords().iterator();
		while(i.hasNext()){
			ProjPaymentTransaction ppt = (ProjPaymentTransaction)i.next();
			
			if (Constants.POST_PAYMENT_TRANSACTION_STATUS_PAID.equals(ppt.getPostStatus())) {
				double settledAmount = ppt.getAmount().doubleValue();
				amount += settledAmount;
			}
		}
		
		return amount;
	}
	
	public double getPaidRemainingAmount() {
		return payAmount * this.exchangeRate.floatValue() - getPaidAmount();
	}
	/**
	 * @return Returns the poProjId.
	 */
	public ProjectMaster getPoProjId() {
		return poProjId;
	}
	/**
	 * @param poProjId The poProjId to set.
	 */
	public void setPoProjId(ProjectMaster poProjId) {
		this.poProjId = poProjId;
	}
	/**
	 * @return Returns the settledRemainingAmountString.
	 */
	public String getSettledRemainingAmountString() {
		return getSettledRemainingAmountString();
	}
}

/*
 * Created on 2006-1-11
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.payment;

import org.apache.struts.action.ActionForm;


/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SettleSupplierInvoiceForm extends ActionForm {
	
	private long tranId;
	private long paymentId;
	private String invCode;
	private String currency;
	private String formAction;
	private float rate;
	private double amt;
	private String vendor;
	private String payDate;
	private double settleAmt;
	private String type;
	private String note;

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
	 * @return Returns the amt.
	 */
	public double getAmt() {
		return amt;
	}
	/**
	 * @param amt The amt to set.
	 */
	public void setAmt(double amt) {
		this.amt = amt;
	}
	/**
	 * @return Returns the currency.
	 */
	public String getCurrency() {
		return currency;
	}
	/**
	 * @param currency The currency to set.
	 */
	public void setCurrency(String currency) {
		this.currency = currency;
	}
	/**
	 * @return Returns the invCode.
	 */
	public String getInvCode() {
		return invCode;
	}
	/**
	 * @param invCode The invCode to set.
	 */
	public void setInvCode(String invCode) {
		this.invCode = invCode;
	}
	/**
	 * @return Returns the rate.
	 */
	public float getRate() {
		return rate;
	}
	/**
	 * @param rate The rate to set.
	 */
	public void setRate(float rate) {
		this.rate = rate;
	}
	/**
	 * @return Returns the payDate.
	 */
	public String getPayDate() {
		return payDate;
	}
	/**
	 * @param payDate The payDate to set.
	 */
	public void setPayDate(String payDate) {
		this.payDate = payDate;
	}
	/**
	 * @return Returns the settleAmt.
	 */
	public double getSettleAmt() {
		return settleAmt;
	}
	/**
	 * @param settleAmt The settleAmt to set.
	 */
	public void setSettleAmt(double settleAmt) {
		this.settleAmt = settleAmt;
	}
	/**
	 * @return Returns the vendor.
	 */
	public String getVendor() {
		return vendor;
	}
	/**
	 * @param vendor The vendor to set.
	 */
	public void setVendor(String vendor) {
		this.vendor = vendor;
	}
	/**
	 * @return Returns the type.
	 */
	public String getType() {
		return type;
	}
	/**
	 * @param type The type to set.
	 */
	public void setType(String type) {
		this.type = type;
	}
	/**
	 * @return Returns the formAction.
	 */
	public String getFormAction() {
		return formAction;
	}
	/**
	 * @param formAction The formAction to set.
	 */
	public void setFormAction(String formAction) {
		this.formAction = formAction;
	}
	/**
	 * @return Returns the paymentId.
	 */
	public long getPaymentId() {
		return paymentId;
	}
	/**
	 * @param paymentId The paymentId to set.
	 */
	public void setPaymentId(long paymentId) {
		this.paymentId = paymentId;
	}
	/**
	 * @return Returns the tranId.
	 */
	public long getTranId() {
		return tranId;
	}
	/**
	 * @param tranId The tranId to set.
	 */
	public void setTranId(long tranId) {
		this.tranId = tranId;
	}
}

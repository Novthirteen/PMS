/*
 * Created on 2005-5-8
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.bill;

import com.aof.webapp.form.BaseForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditLostRecordForm extends BaseForm {
	private String formAction;
	private Long lostRecordId;
	private Long billId;
	private String projectId;
	private String currency;
	private Float exchangeRate;
	private Double amount;
	private String note;
	/**
	 * @return Returns the amount.
	 */
	public Double getAmount() {
		return amount;
	}
	/**
	 * @param amount The amount to set.
	 */
	public void setAmount(Double amount) {
		this.amount = amount;
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
	 * @return Returns the currencyRate.
	 */
	public Float getExchangeRate() {
		return exchangeRate;
	}
	/**
	 * @param currencyRate The currencyRate to set.
	 */
	public void setExchangeRate(Float currencyRate) {
		this.exchangeRate = currencyRate;
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
	 * @return Returns the lostRecordId.
	 */
	public Long getLostRecordId() {
		return lostRecordId;
	}
	/**
	 * @param lostRecordId The lostRecordId to set.
	 */
	public void setLostRecordId(Long lostRecordId) {
		this.lostRecordId = lostRecordId;
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
}

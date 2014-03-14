/*
 * Created on 2005-4-12
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
public class EditInvoiceConfirmForm extends BaseForm {
	private String formAction;
	private Long confirmId;
	private Long invoiceId;
	private String contactor;
	private String responsiblePerson;
	private String contactDate;
	private Double payAmount;
	private String payDate;
	private String note;
	private String currency;
	/**
	 * @return Returns the confirmId.
	 */
	public Long getConfirmId() {
		return confirmId;
	}
	/**
	 * @param confirmId The confirmId to set.
	 */
	public void setConfirmId(Long confirmId) {
		this.confirmId = confirmId;
	}
	/**
	 * @return Returns the contactDate.
	 */
	public String getContactDate() {
		return contactDate;
	}
	/**
	 * @param contactDate The contactDate to set.
	 */
	public void setContactDate(String contactDate) {
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
	 * @return Returns the responsiblePerson.
	 */
	public String getResponsiblePerson() {
		return responsiblePerson;
	}
	/**
	 * @param responsiblePerson The responsiblePerson to set.
	 */
	public void setResponsiblePerson(String responsiblePerson) {
		this.responsiblePerson = responsiblePerson;
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
}

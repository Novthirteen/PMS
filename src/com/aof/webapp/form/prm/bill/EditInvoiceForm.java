/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.form.prm.bill;

import com.aof.webapp.form.BaseForm;

/**
 * @author Jackey Ding 
 * @version 2005-03-31
 *
 */
public class EditInvoiceForm extends BaseForm {
	
	private String formAction;
	private Long invoiceId;
	private String invoiceCode;
	private Long billId;
	private String projectId;
	private String billAddressId;
	private String currency;
	private Float currencyRate;
	private Double amount;
	private String invoiceDate;
	private String note;
	private Long emsId;
	private String process;
	private Long[] confirmId;
	private Long[] receiptId;
	private String invoiceType;
	
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
	public Float getCurrencyRate() {
		return currencyRate;
	}
	/**
	 * @param currencyRate The currencyRate to set.
	 */
	public void setCurrencyRate(Float currencyRate) {
		this.currencyRate = currencyRate;
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
	 * @return Returns the invoiceCode.
	 */
	public String getInvoiceCode() {
		return invoiceCode;
	}
	/**
	 * @param invoiceCode The invoiceCode to set.
	 */
	public void setInvoiceCode(String invoiceCode) {
		this.invoiceCode = invoiceCode;
	}
	/**
	 * @return Returns the invoiceDate.
	 */
	public String getInvoiceDate() {
		return invoiceDate;
	}
	/**
	 * @param invoiceDate The invoiceDate to set.
	 */
	public void setInvoiceDate(String invoiceDate) {
		this.invoiceDate = invoiceDate;
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
	 * @return Returns the process.
	 */
	public String getProcess() {
		return process;
	}
	/**
	 * @param process The process to set.
	 */
	public void setProcess(String process) {
		this.process = process;
	}
	/**
	 * @return Returns the confirmId.
	 */
	public Long[] getConfirmId() {
		return confirmId;
	}
	/**
	 * @param confirmId The confirmId to set.
	 */
	public void setConfirmId(Long[] confirmId) {
		this.confirmId = confirmId;
	}
    /**
     * @return Returns the receiptId.
     */
    public Long[] getReceiptId() {
        return receiptId;
    }
    /**
     * @param receiptId The receiptId to set.
     */
    public void setReceiptId(Long[] receiptId) {
        this.receiptId = receiptId;
    }
	/**
	 * @return Returns the invoiceType.
	 */
	public String getInvoiceType() {
		return invoiceType;
	}
	/**
	 * @param invoiceType The invoiceType to set.
	 */
	public void setInvoiceType(String invoiceType) {
		this.invoiceType = invoiceType;
	}
}

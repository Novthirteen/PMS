/*
 * Created on 2005-4-12
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.bill;

import org.apache.struts.action.ActionForm;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditReceiptForm extends ActionForm {
    private String formAction;
    private Long receiptId;
    private String receiptNo;    
    private Long invoiceId;
    private Double receiveAmount;
    private String currency;
    private Float currencyRate;
    private String receiveDate;
    private String note;
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
     * @return Returns the receiptId.
     */
    public Long getReceiptId() {
        return receiptId;
    }
    /**
     * @param receiptId The receiptId to set.
     */
    public void setReceiptId(Long receiptId) {
        this.receiptId = receiptId;
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
    public String getReceiveDate() {
        return receiveDate;
    }
    /**
     * @param receiveDate The receiveDate to set.
     */
    public void setReceiveDate(String receiveDate) {
        this.receiveDate = receiveDate;
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
}

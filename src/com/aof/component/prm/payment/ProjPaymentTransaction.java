/*
 * Created on 2006-1-9
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.payment;

import java.io.Serializable;
import java.util.Date;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.CurrencyType;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ProjPaymentTransaction implements Serializable {
	//Transaction id
	private Long id;
	//Supplier invoice
	private ProjectPaymentMaster invoice;
	//payment instruction
	private ProjectPayment payment;
	//transaction amount
	private Double amount;
	private CurrencyType currency;
	private Float currRate;
	private String postStatus;
	private Date postDate;
	private Date payDate;
	private String note;
	private UserLogin createUser;
	private Date createDate;
	private Date exportDate;
	/**
	 * @return Returns the exportDate.
	 */
	public Date getExportDate() {
		return exportDate;
	}
	/**
	 * @param exportDate The exportDate to set.
	 */
	public void setExportDate(Date exportDate) {
		this.exportDate = exportDate;
	}
	/**
	 * @return Returns the postDate.
	 */
	public Date getPostDate() {
		return postDate;
	}
	/**
	 * @param postDate The postDate to set.
	 */
	public void setPostDate(Date postDate) {
		this.postDate = postDate;
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
	 * @return Returns the currRate.
	 */
	public Float getCurrRate() {
		return currRate;
	}
	/**
	 * @param currRate The currRate to set.
	 */
	public void setCurrRate(Float currRate) {
		this.currRate = currRate;
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
	 * @return Returns the invoice.
	 */
	public ProjectPaymentMaster getInvoice() {
		return invoice;
	}
	/**
	 * @param invoice The invoice to set.
	 */
	public void setInvoice(ProjectPaymentMaster invoice) {
		this.invoice = invoice;
	}
	/**
	 * @return Returns the payment.
	 */
	public ProjectPayment getPayment() {
		return payment;
	}
	/**
	 * @param payment The payment to set.
	 */
	public void setPayment(ProjectPayment payment) {
		this.payment = payment;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the postStatus.
	 */
	public String getPostStatus() {
		return postStatus;
	}
	/**
	 * @param postStatus The postStatus to set.
	 */
	public void setPostStatus(String postStatus) {
		this.postStatus = postStatus;
	}
}

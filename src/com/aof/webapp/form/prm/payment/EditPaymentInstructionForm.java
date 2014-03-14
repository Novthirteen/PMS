/*
 * Created on 2005-5-23
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.payment;

import org.apache.struts.action.ActionForm;

import com.aof.util.Constants;

/**
 * @author gus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditPaymentInstructionForm extends ActionForm {

	
	private String action = null;
	private String category = null;
	private String payId = null;
	private String payCode = null;
	private String payType = Constants.PAYMENT_TYPE_NORMAL;
	private String calAmount = null;
	private String amount = null;
	private String projId = null;
	private String payAddr = null;
	//private String invNo = null;
	private String createDate = null;
	private String createUser = null;
	private String[] payDetailId = null;
	private String[] transactionId = null;
	private String status = null;
	private String note = null;
	
	/**
	 * @return Returns the action.
	 */
	public String getAction() {
		return action;
	}
	/**
	 * @param action The action to set.
	 */
	public void setAction(String action) {
		this.action = action;
	}
	/**
	 * @return Returns the category.
	 */
	public String getCategory() {
		return category;
	}
	/**
	 * @param category The category to set.
	 */
	public void setCategory(String category) {
		this.category = category;
	}
	/**
	 * @return Returns the payAddr.
	 */
	public String getPayAddr() {
		return payAddr;
	}
	/**
	 * @param billAddr The billAddr to set.
	 */
	public void setPayAddr(String payAddr) {
		this.payAddr = payAddr;
	}
	/**
	 * @return Returns the amount.
	 */
	public String getAmount() {
		return amount;
	}
	/**
	 * @param amount The amount to set.
	 */
	public void setAmount(String amount) {
		this.amount = amount;
	}
	/**
	 * @return Returns the billCode.
	 */
	public String getPayCode() {
		return payCode;
	}
	/**
	 * @param billCode The billCode to set.
	 */
	public void setPayCode(String payCode) {
		this.payCode = payCode;
	}
	/**
	 * @return Returns the billId.
	 */
	public String getPayId() {
		return payId;
	}
	/**
	 * @param billId The billId to set.
	 */
	public void setPayId(String payId) {
		this.payId = payId;
	}
	/**
	 * @return Returns the billType.
	 */
	public String getPayType() {
		return payType;
	}
	/**
	 * @param billType The billType to set.
	 */
	public void setPayType(String payType) {
		this.payType = payType;
	}
	/**
	 * @return Returns the calAmount.
	 */
	public String getCalAmount() {
		return calAmount;
	}
	/**
	 * @param calAmount The calAmount to set.
	 */
	public void setCalAmount(String calAmount) {
		this.calAmount = calAmount;
	}
	/**
	 * @return Returns the createDate.
	 */
	public String getCreateDate() {
		return createDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	/**
	 * @return Returns the createUser.
	 */
	public String getCreateUser() {
		return createUser;
	}
	/**
	 * @param createUser The createUser to set.
	 */
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}
	
	/*
	 * 
	 
	public String getInvNo() {
		return invNo;
	}
	/**
	 * @param invNo The invNo to set.
	 
	public void setInvNo(String invNo) {
		this.invNo = invNo;
	}
	/**
	 * @return Returns the projId.
	 */
	public String getProjId() {
		return projId;
	}
	/**
	 * @param projId The projId to set.
	 */
	public void setProjId(String projId) {
		this.projId = projId;
	}
	/**
	 * @return Returns the billDetailId.
	 */
	public String[] getPayDetailId() {
		return payDetailId;
	}
	/**
	 * @param billDetailId The billDetailId to set.
	 */
	public void setPayDetailId(String[] payDetailId) {
		this.payDetailId = payDetailId;
	}
	/**
	 * @return Returns the transactionId.
	 */
	public String[] getTransactionId() {
		return transactionId;
	}
	/**
	 * @param transactionId The transactionId to set.
	 */
	public void setTransactionId(String[] transactionId) {
		this.transactionId = transactionId;
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
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}

}

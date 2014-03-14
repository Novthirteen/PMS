/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.form.prm.bill;

import org.apache.struts.action.ActionForm;

/**
 * @author Jackey Ding 
 * @version 2005-03-17
 *
 */
public class EditBillingInstructionForm extends ActionForm {
	
	private String action = null;
	private String category = null;
	private String billId = null;
	private String billCode = null;
	private String billType = null;
	private String calAmount = null;
	private String amount = null;
	private String projId = null;
	private String billAddr = null;
	private String invNo = null;
	private String createDate = null;
	private String createUser = null;
	private String[] billDetailId = null;
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
	 * @return Returns the billAddr.
	 */
	public String getBillAddr() {
		return billAddr;
	}
	/**
	 * @param billAddr The billAddr to set.
	 */
	public void setBillAddr(String billAddr) {
		this.billAddr = billAddr;
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
	public String getBillCode() {
		return billCode;
	}
	/**
	 * @param billCode The billCode to set.
	 */
	public void setBillCode(String billCode) {
		this.billCode = billCode;
	}
	/**
	 * @return Returns the billId.
	 */
	public String getBillId() {
		return billId;
	}
	/**
	 * @param billId The billId to set.
	 */
	public void setBillId(String billId) {
		this.billId = billId;
	}
	/**
	 * @return Returns the billType.
	 */
	public String getBillType() {
		return billType;
	}
	/**
	 * @param billType The billType to set.
	 */
	public void setBillType(String billType) {
		this.billType = billType;
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
	/**
	 * @return Returns the invNo.
	 */
	public String getInvNo() {
		return invNo;
	}
	/**
	 * @param invNo The invNo to set.
	 */
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
	public String[] getBillDetailId() {
		return billDetailId;
	}
	/**
	 * @param billDetailId The billDetailId to set.
	 */
	public void setBillDetailId(String[] billDetailId) {
		this.billDetailId = billDetailId;
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

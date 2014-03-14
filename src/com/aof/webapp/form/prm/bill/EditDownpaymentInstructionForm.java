/*
 * Created on 2005-4-22
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
public class EditDownpaymentInstructionForm extends BaseForm {
	private String formAction;
	private Long billId;
	private String billCode = null;
	private String billType = null;
	private String projId = null;
	private String billAddr = null;
	private String status = null;
	private String note = null;
	private Double downAmount = null;
	private Double creditAmount = null;
	
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
	 * @return Returns the creditAmount.
	 */
	public Double getCreditAmount() {
		return creditAmount;
	}
	/**
	 * @param creditAmount The creditAmount to set.
	 */
	public void setCreditAmount(Double creditAmount) {
		this.creditAmount = creditAmount;
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
	/**
	 * @return Returns the downAmount.
	 */
	public Double getDownAmount() {
		return downAmount;
	}
	/**
	 * @param downAmount The downAmount to set.
	 */
	public void setDownAmount(Double downAmount) {
		this.downAmount = downAmount;
	}
}

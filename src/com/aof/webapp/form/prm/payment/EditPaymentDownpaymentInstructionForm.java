/*
 * Created on 2005-6-7
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.payment;

import com.aof.util.Constants;
import com.aof.webapp.form.BaseForm;

/**
 * @author gus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditPaymentDownpaymentInstructionForm extends BaseForm {
	private String formAction;
	private Long payId;
	private String payCode = null;
	private String payType = Constants.PAYMENT_TYPE_DOWN_PAYMENT;
	private String projId = null;
	private String payAddr = null;
	private String status = null;
	private String note = null;
	private Double downAmount = null;
	private Double creditAmount = null;

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
	 * @return Returns the payId.
	 */
	public Long getPayId() {
		return payId;
	}
	/**
	 * @param payId The payId to set.
	 */
	public void setPayId(Long payId) {
		this.payId = payId;
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
	 * @return Returns the payAddr.
	 */
	public String getPayAddr() {
		return payAddr;
	}
	/**
	 * @param payAddr The payAddr to set.
	 */
	public void setPayAddr(String payAddr) {
		this.payAddr = payAddr;
	}
}

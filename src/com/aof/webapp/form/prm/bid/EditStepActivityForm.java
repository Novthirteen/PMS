/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.form.prm.bid;

import com.aof.webapp.form.BaseForm;

public class EditStepActivityForm extends BaseForm {
	private String formAction;
	private Long id;
	private Long stepId;
	private Integer seqNo;
	private String description;
	private String criticalFlg;
	/**
	 * @return Returns the criticalFlg.
	 */
	public String getCriticalFlg() {
		return criticalFlg;
	}
	/**
	 * @param criticalFlg The criticalFlg to set.
	 */
	public void setCriticalFlg(String criticalFlg) {
		this.criticalFlg = criticalFlg;
	}
	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return description;
	}
	/**
	 * @param description The description to set.
	 */
	public void setDescription(String description) {
		this.description = description;
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
	 * @return Returns the seqNo.
	 */
	public Integer getSeqNo() {
		return seqNo;
	}
	/**
	 * @param seqNo The seqNo to set.
	 */
	public void setSeqNo(Integer seqNo) {
		this.seqNo = seqNo;
	}
	/**
	 * @return Returns the stepId.
	 */
	public Long getStepId() {
		return stepId;
	}
	/**
	 * @param stepId The stepId to set.
	 */
	public void setStepId(Long stepId) {
		this.stepId = stepId;
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

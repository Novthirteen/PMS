/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.form.prm.bid;

import com.aof.webapp.form.BaseForm;

public class EditStepForm extends BaseForm {
	private String formAction;
	private Long id;
	private Long stepGroupId;
	private Integer seqNo;
	private String description;
	private Integer percentage;
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
	 * @return Returns the percentage.
	 */
	public Integer getPercentage() {
		return percentage;
	}
	/**
	 * @param percentage The percentage to set.
	 */
	public void setPercentage(Integer percentage) {
		this.percentage = percentage;
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
	 * @return Returns the stepGroup.
	 */
	public Long getStepGroupId() {
		return stepGroupId;
	}
	/**
	 * @param stepGroup The stepGroup to set.
	 */
	public void setStepGroupId(Long stepGroupId) {
		this.stepGroupId = stepGroupId;
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

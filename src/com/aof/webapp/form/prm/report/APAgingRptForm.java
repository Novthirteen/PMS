/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.form.prm.report;

import com.aof.webapp.form.BaseForm;

public class APAgingRptForm extends BaseForm {
	private String formAction;
	private String date;
	private String payTo;
	private String department;
	private String poProject;
	/**
	 * @return Returns the date.
	 */
	public String getDate() {
		return date;
	}
	/**
	 * @param date The date to set.
	 */
	public void setDate(String date) {
		this.date = date;
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
	 * @return Returns the payTo.
	 */
	public String getPayTo() {
		return payTo;
	}
	/**
	 * @param payTo The payTo to set.
	 */
	public void setPayTo(String payTo) {
		this.payTo = payTo;
	}
	/**
	 * @return Returns the department.
	 */
	public String getDepartment() {
		return department;
	}
	/**
	 * @param department The department to set.
	 */
	public void setDepartment(String department) {
		this.department = department;
	}
	/**
	 * @return Returns the poProject.
	 */
	public String getPoProject() {
		return poProject;
	}
	/**
	 * @param poProject The poProject to set.
	 */
	public void setPoProject(String poProject) {
		this.poProject = poProject;
	}
	
}

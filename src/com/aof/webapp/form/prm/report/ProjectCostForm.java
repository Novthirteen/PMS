/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.form.prm.report;

import com.aof.webapp.form.BaseForm;

/**
 * @author Jackey Ding
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ProjectCostForm extends BaseForm {
	
	private String srcYear;
	private String srcMonth;
	private String project;
	private String customer;
	private String projectManager;
	private String departmentId;
	private String formAction;
	private String detailFlg;
	
	/**
	 * @return Returns the customer.
	 */
	public String getCustomer() {
		return customer;
	}
	/**
	 * @param customer The customer to set.
	 */
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	/**
	 * @return Returns the departmentId.
	 */
	public String getDepartmentId() {
		return departmentId;
	}
	/**
	 * @param departmentId The departmentId to set.
	 */
	public void setDepartmentId(String departmentId) {
		this.departmentId = departmentId;
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
	 * @return Returns the project.
	 */
	public String getProject() {
		return project;
	}
	/**
	 * @param project The project to set.
	 */
	public void setProject(String project) {
		this.project = project;
	}
	/**
	 * @return Returns the projectManager.
	 */
	public String getProjectManager() {
		return projectManager;
	}
	/**
	 * @param projectManager The projectManager to set.
	 */
	public void setProjectManager(String projectManager) {
		this.projectManager = projectManager;
	}
	/**
	 * @return Returns the srcMonth.
	 */
	public String getSrcMonth() {
		return srcMonth;
	}
	/**
	 * @param srcMonth The srcMonth to set.
	 */
	public void setSrcMonth(String srcMonth) {
		this.srcMonth = srcMonth;
	}
	/**
	 * @return Returns the srcYear.
	 */
	public String getSrcYear() {
		return srcYear;
	}
	/**
	 * @param srcYear The srcYear to set.
	 */
	public void setSrcYear(String srcYear) {
		this.srcYear = srcYear;
	}
	/**
	 * @return Returns the detailFlg.
	 */
	public String getDetailFlg() {
		return detailFlg;
	}
	/**
	 * @param detailFlg The detailFlg to set.
	 */
	public void setDetailFlg(String detailFlg) {
		this.detailFlg = detailFlg;
	}
}

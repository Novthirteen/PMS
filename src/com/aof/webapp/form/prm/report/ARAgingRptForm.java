/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.form.prm.report;

import com.aof.webapp.form.BaseForm;

/**
 * @author CN01458
 * @version 2005-5-30
 */
public class ARAgingRptForm extends BaseForm {
	
	private String formAction;
	private String date;
	private String customerBranch;
	private String billTo;
	private String customer;
	private String project;
	private String department;

	/**
	 * @return Returns the billTo.
	 */
	public String getBillTo() {
		return billTo;
	}
	/**
	 * @param billTo The billTo to set.
	 */
	public void setBillTo(String billTo) {
		this.billTo = billTo;
	}
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
	 * @return Returns the customerBranch.
	 */
	public String getCustomerBranch() {
		return customerBranch;
	}
	/**
	 * @param customerBranch The customerBranch to set.
	 */
	public void setCustomerBranch(String customerBranch) {
		this.customerBranch = customerBranch;
	}
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
}

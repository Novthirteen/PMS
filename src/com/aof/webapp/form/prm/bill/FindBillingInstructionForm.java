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
 * @version 2005-03-16
 *
 */
public class FindBillingInstructionForm extends ActionForm {
	
	private String billCode;
	private String project;
	private String customer;
	private String billTo;
	private String department;
	private String status;
	
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
}

/*
 * Created on 2005-5-23
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.payment;

import org.apache.struts.action.ActionForm;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindPaymentInstructionForm extends ActionForm {

	
	private String payCode;
	private String project;
	private String supplier;
	private String department;
	private String status;
	private String payTo;
	

	/**
	 * @return Returns the customer.
	 */
	public String getSupplier() {
		return supplier;
	}
	/**
	 * @param customer The customer to set.
	 */
	public void setSupplier(String supplier) {
		this.supplier = supplier;
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
}

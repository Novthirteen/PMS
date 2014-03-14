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
 * @version 2005-6-3
 */
public class ARCustStatementRptForm extends BaseForm {
	
	private String formAction;
	private String billTo;
	private String customer;
	private String contractNo;
	private String department;
	private String date;
	private String show0AmtOpen;
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
	 * @return Returns the contractNo.
	 */
	public String getContractNo() {
		return contractNo;
	}
	/**
	 * @param contractNo The contractNo to set.
	 */
	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
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
	 * @return Returns the show0AmtOpen.
	 */
	public String getShow0AmtOpen() {
		return show0AmtOpen;
	}
	/**
	 * @param show0AmtOpen The show0AmtOpen to set.
	 */
	public void setShow0AmtOpen(String show0AmtOpen) {
		this.show0AmtOpen = show0AmtOpen;
	}
}

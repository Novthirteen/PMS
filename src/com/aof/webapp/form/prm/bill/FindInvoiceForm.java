/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.form.prm.bill;

import java.sql.Date;

import com.aof.webapp.form.BaseForm;

/**
 * @author Jackey Ding 
 * @version 2005-03-31s
 *
 */
public class FindInvoiceForm extends BaseForm {
	
	private String formAction;
	
	private String invoice;
	
	private String billing;
	
	private String project;
	
	private String billAddress;
	
	private String status;
	
	//private Date dateFrom;
	
	//private Date dateTo;
	
	private String department;
	/**
	 * @return Returns the billAddress.
	 */
	public String getBillAddress() {
		return billAddress;
	}
	/**
	 * @param billAddress The billAddress to set.
	 */
	public void setBillAddress(String billAddress) {
		this.billAddress = billAddress;
	}
	/**
	 * @return Returns the dateFrom.
	 */
	//public Date getDateFrom() {
		//return dateFrom;
	//}
	/**
	 * @param dateFrom The dateFrom to set.
	 */
	//public void setDateFrom(Date dateFrom) {
		//this.dateFrom = dateFrom;
	//}
	/**
	 * @return Returns the dateTo.
	 */
	//public Date getDateTo() {
		//return dateTo;
	//}
	/**
	 * @param dateTo The dateTo to set.
	 */
	//public void setDateTo(Date dateTo) {
		//this.dateTo = dateTo;
	//}
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
	 * @return Returns the invoiceCode.
	 */
	public String getInvoice() {
		return invoice;
	}
	/**
	 * @param invoiceCode The invoiceCode to set.
	 */
	public void setInvoice(String invoice) {
		this.invoice = invoice;
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
	 * @return Returns the billing.
	 */
	public String getBilling() {
		return billing;
	}
	/**
	 * @param billing The billing to set.
	 */
	public void setBilling(String billing) {
		this.billing = billing;
	}
}

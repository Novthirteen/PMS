/*
 * Created on 2005-6-28
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.payment;

import org.apache.struts.action.ActionForm;


/**
 * @author angus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FindPaymentInvoiceForm extends ActionForm {
	
	private String formAction;
	
	private String invoice;
	
	private String payment;
	
	private String project;
	
	private String payAddress;
	
	private String status;
	
	//private Date dateFrom;
	
	//private Date dateTo;
	
	private String department;

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

	/**
	 * @return Returns the payAddress.
	 */
	public String getPayAddress() {
		return payAddress;
	}
	/**
	 * @param payAddress The payAddress to set.
	 */
	public void setPayAddress(String payAddress) {
		this.payAddress = payAddress;
	}
	/**
	 * @return Returns the payment.
	 */
	public String getPayment() {
		return payment;
	}
	/**
	 * @param payment The payment to set.
	 */
	public void setPayment(String payment) {
		this.payment = payment;
	}
}

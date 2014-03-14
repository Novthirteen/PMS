package com.aof.webapp.form.prm.report;

import com.aof.webapp.form.BaseForm;

public class OutstandingAcceptanceRptForm extends BaseForm {
	private static final long serialVersionUID = 0;
	
	private String formAction;
	private String date_begin;
	private String date_end;
	private String dpt;
	private String project;
	private String pa;
	
	/**
	 * @Getters and Setters
	 */
	public String getDate_begin() {
	//	System.out.println("date_begin_get");
		return date_begin;
	}
	public void setDate_begin(String date_begin) {
	//	System.out.println("date_begin_set");
		this.date_begin = date_begin;
	}
	public String getDate_end() {
	//	System.out.println("date_end_get");
		return date_end;
	}
	public void setDate_end(String date_end) {
	//	System.out.println("date_end_set");
		this.date_end = date_end;
	}
	public String getDpt() {
	//	System.out.println("dpt_get");
		return dpt;
	}
	public void setDpt(String dpt) {
	//	System.out.println("dpt_set");
		this.dpt = dpt;
	}
	public String getProject() {
	//	System.out.println("project_get");
		return project;
	}
	public void setProject(String project) {
	//	System.out.println("project_set");
		this.project = project;
	}
	public String getFormAction() {
	//	System.out.println("formaction_get");
		return formAction;
	}
	public void setFormAction(String formAction) {
	//	System.out.println("formaction_set");
		this.formAction = formAction;
	}
	public String getPa() {
	//	System.out.println("pa_get");
		return pa;
	}
	public void setPa(String pa) {
	//	System.out.println("pa_set");
		this.pa = pa;
	}
}

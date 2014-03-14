/*
 * Created on 2005-9-19 by Bill Yu
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.prm.report;

import com.aof.webapp.form.BaseForm;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class OutstandingTSRptForm extends BaseForm {
	private String formAction;
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
	private String date_begin;
	private String date_end;
	private String dpt;
	private String project;
	private String pa;
	private String pm;
	/**
	 * @return Returns the date_begin.
	 */
	public String getDate_begin() {
		return date_begin;
	}
	/**
	 * @param date_begin The date_begin to set.
	 */
	public void setDate_begin(String date_begin) {
		this.date_begin = date_begin;
	}
	/**
	 * @return Returns the date_end.
	 */
	public String getDate_end() {
		return date_end;
	}
	/**
	 * @param date_end The date_end to set.
	 */
	public void setDate_end(String date_end) {
		this.date_end = date_end;
	}
	/**
	 * @return Returns the dpt.
	 */
	public String getDpt() {
		return dpt;
	}
	/**
	 * @param dpt The dpt to set.
	 */
	public void setDpt(String dpt) {
		this.dpt = dpt;
	}
	/**
	 * @return Returns the pa.
	 */
	public String getPa() {
		return pa;
	}
	/**
	 * @param pa The pa to set.
	 */
	public void setPa(String pa) {
		this.pa = pa;
	}
	/**
	 * @return Returns the pm.
	 */
	public String getPm() {
		return pm;
	}
	/**
	 * @param pm The pm to set.
	 */
	public void setPm(String pm) {
		this.pm = pm;
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
}

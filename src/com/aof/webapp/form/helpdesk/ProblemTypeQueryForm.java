/*
 * Created on 2005-2-10
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.webapp.form.helpdesk;

import com.shcnc.struts.form.BaseQueryForm;

/**
 * @author Daniel
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ProblemTypeQueryForm extends BaseQueryForm{
	private String id;
	private String desc;
	

	/**
	 * @return
	 */
	public String getDesc() {
		return desc;
	}

	/**
	 * @param string
	 */
	public void setDesc(String string) {
		desc = string;
	}

	/**
	 * @return
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param string
	 */
	public void setId(String string) {
		id = string;
	}

}

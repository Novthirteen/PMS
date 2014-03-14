/*
 * Created on 2004-12-2
 *
 */
package com.aof.webapp.form.helpdesk;

import com.shcnc.struts.form.BaseQueryForm;

/**
 * @author nicebean
 *
 */
public class SLAMasterQueryForm extends BaseQueryForm {
	private String desc = "";
	private String customer;
    private String active;

	public String getActive() {
        return active;
    }

	public void setActive(String active) {
        this.active = active;
    }

    public String getCustomer() {
        return customer;
    }

    public void setCustomer(String customer) {
        this.customer = customer;
    }

	public String getDesc() {
	    return desc;
	}
	
	public void setDesc(String desc) {
	    this.desc = desc;
	}
}

/*
 * Created on 2004-12-20
 *
 */
package com.aof.webapp.form.helpdesk;

import com.shcnc.struts.form.BaseQueryForm;

/**
 * @author nicebean
 *
 */
public class CustomerQueryForm extends BaseQueryForm {
    private String desc;
    
    /**
     * @return Returns the desc.
     */
    public String getDesc() {
        return desc;
    }
    /**
     * @param desc The desc to set.
     */
    public void setDesc(String desc) {
        this.desc = desc;
    }
}

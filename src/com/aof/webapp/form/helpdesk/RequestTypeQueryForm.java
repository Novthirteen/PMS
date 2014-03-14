/*
 * Created on 2004-12-17
 *
 */
package com.aof.webapp.form.helpdesk;

import com.shcnc.struts.form.BaseQueryForm;

/**
 * @author nicebean
 *
 */
public class RequestTypeQueryForm extends BaseQueryForm {
    private String description;
    private String callType;
    private String disabled;
    /**
     * @return Returns the disabled.
     */
    public String getDisabled() {
        return disabled;
    }
    /**
     * @param disabled The disabled to set.
     */
    public void setDisabled(String disabled) {
        this.disabled = disabled;
    }
    /**
     * @return Returns the callType.
     */
    public String getCallType() {
        return callType;
    }
    /**
     * @param callType The callType to set.
     */
    public void setCallType(String callType) {
        this.callType = callType;
    }
    /**
     * @return Returns the description.
     */
    public String getDescription() {
        return description;
    }
    /**
     * @param description The description to set.
     */
    public void setDescription(String description) {
        this.description = description;
    }
}

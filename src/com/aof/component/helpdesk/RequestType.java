/*
 * Created on 2004-12-17
 *
 */
package com.aof.component.helpdesk;

import java.io.Serializable;

/**
 * @author nicebean
 *
 */
public class RequestType implements Serializable {
    private Integer id;
    private String description;
    private boolean disabled;
    private CallType callType;
    
    /**
     * @return Returns the callType.
     */
    public CallType getCallType() {
        return callType;
    }
    /**
     * @param callType The callType to set.
     */
    public void setCallType(CallType callType) {
        this.callType = callType;
    }
    /**
     * @return Returns the decription.
     */
    public String getDescription() {
        return description;
    }
    /**
     * @param decription The decription to set.
     */
    public void setDescription(String description) {
        this.description = description;
    }
    /**
     * @return Returns the disabled.
     */
    public boolean getDisabled() {
        return disabled;
    }
    /**
     * @param disabled The disabled to set.
     */
    public void setDisabled(boolean disabled) {
        this.disabled = disabled;
    }
    /**
     * @return Returns the id.
     */
    public Integer getId() {
        return id;
    }
    /**
     * @param id The id to set.
     */
    public void setId(Integer id) {
        this.id = id;
    }
}

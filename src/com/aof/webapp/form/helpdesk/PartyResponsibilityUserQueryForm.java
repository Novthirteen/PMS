/*
 * Created on 2004-12-16
 *
 */
package com.aof.webapp.form.helpdesk;

import com.shcnc.struts.form.BaseQueryForm;

/**
 * @author nicebean
 *
 */
public class PartyResponsibilityUserQueryForm extends BaseQueryForm {
    private String party;
    private String user;
    private String type;
    /**
     * @return Returns the party.
     */
    public String getParty() {
        return party;
    }
    /**
     * @param party The party to set.
     */
    public void setParty(String party) {
        this.party = party;
    }
    /**
     * @return Returns the type.
     */
    public String getType() {
        return type;
    }
    /**
     * @param type The type to set.
     */
    public void setType(String type) {
        this.type = type;
    }
    /**
     * @return Returns the user.
     */
    public String getUser() {
        return user;
    }
    /**
     * @param user The user to set.
     */
    public void setUser(String user) {
        this.user = user;
    }
}

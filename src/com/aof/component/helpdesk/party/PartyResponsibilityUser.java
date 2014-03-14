/*
 * Created on 2004-12-15
 *
 */
package com.aof.component.helpdesk.party;

import java.io.Serializable;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;

/**
 * @author nicebean
 *
 */
public class PartyResponsibilityUser implements Serializable {
    private Integer id;
    private Party party;
    private UserLogin user;
    private PartyResponsibilityType type;
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
    /**
     * @return Returns the party.
     */
    public Party getParty() {
        return party;
    }
    /**
     * @param party The party to set.
     */
    public void setParty(Party party) {
        this.party = party;
    }
    /**
     * @return Returns the user.
     */
    public UserLogin getUser() {
        return user;
    }
    /**
     * @param user The user to set.
     */
    public void setUser(UserLogin user) {
        this.user = user;
    }
    /**
     * @return Returns the type.
     */
    public PartyResponsibilityType getType() {
        return type;
    }
    /**
     * @param type The type to set.
     */
    public void setType(PartyResponsibilityType type) {
        this.type = type;
    }

    public boolean equals(Object obj) {
        if (obj == null) return false;
        if (this == obj) return true;
        if (!(obj instanceof PartyResponsibilityUser)) return false;
        PartyResponsibilityUser that = (PartyResponsibilityUser)obj;
        if (this.getId() != null) {
            return this.getId().equals(that.getId());
        }
        return that.getId() == null;	
    }

}

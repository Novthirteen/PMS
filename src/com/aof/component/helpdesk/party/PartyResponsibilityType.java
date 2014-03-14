/*
 * Created on 2004-12-15
 *
 */
package com.aof.component.helpdesk.party;

import java.io.Serializable;

/**
 * @author nicebean
 *
 */
public class PartyResponsibilityType implements Serializable {
    private String typeId;
    private String description;

    /**
     * @return Returns the typeId.
     */
    public String getTypeId() {
        return typeId;
    }
    /**
     * @param typeId The typeId to set.
     */
    public void setTypeId(String typeId) {
        this.typeId = typeId;
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

    public boolean equals(Object obj) {
        if (obj == null) return false;
        if (this == obj) return true;
        if (!(obj instanceof PartyResponsibilityType)) return false;
        PartyResponsibilityType that = (PartyResponsibilityType)obj;
        if (this.getTypeId() != null) {
            return this.getTypeId().equals(that.getTypeId());
        }
        return that.getTypeId() == null;	
    }

}

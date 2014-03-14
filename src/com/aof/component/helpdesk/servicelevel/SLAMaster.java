package com.aof.component.helpdesk.servicelevel;

import java.util.Set; 
import java.io.Serializable;


import com.aof.component.domain.party.Party;
import com.aof.component.helpdesk.ModifyLog;

/** @author Hibernate CodeGenerator */
public class SLAMaster implements Serializable {

    /** identifier field */
    private Integer id;

    /** nullable persistent field */
    private String desc;

    /** nullable persistent field */
    private Party party;

    /** persistent field */
    private String active;

    private ModifyLog modifyLog;

	/** linked object*/
	private Set categorys;

    /** default constructor */
    public SLAMaster() {
    }

    public Integer getId() {
        return this.id;
    }

	public void setId(Integer id) {
		this.id = id;
	}

    public java.lang.String getDesc() {
        return this.desc;
    }

	public void setDesc(String desc) {
		this.desc = desc;
	}

    public Party getParty() {
        return this.party;
    }

	public void setParty(Party party) {
		this.party = party;
	}

    public String getActive() {
        return this.active;
    }

	public void setActive(String active) {
		this.active = active;
	}

	public ModifyLog getModifyLog() {
		return modifyLog;
	}

	public void setModifyLog(ModifyLog modifyLog) {
		this.modifyLog = modifyLog;
	}

	/** new object method*/
	public Set getCategorys() {
			return categorys;
	}

	/**
	 * @param set
	 */
	public void setCategorys(Set categorys) {
		this.categorys = categorys;
	}
	
	public String toString() {
		return desc;
	}
	
	public boolean equals(Object obj) {
        if (obj == null) return false;
        if (this == obj) return true;
        if (!(obj instanceof SLAMaster)) return false;
        SLAMaster that = (SLAMaster)obj;
        if (this.getId() != null) {
            return this.getId().equals(that.getId());
        }
        return that.getId() == null;	
    }
	
}

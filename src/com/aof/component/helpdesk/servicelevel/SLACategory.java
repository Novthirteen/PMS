package com.aof.component.helpdesk.servicelevel;

import java.util.Set; 

import com.aof.component.helpdesk.ModifyLog;

/** @author Hibernate CodeGenerator */
public class SLACategory extends SLAAbstractDesc {

    /** identifier field */
    private Integer id;

    /** nullable persistent field */
    private SLAMaster master;

    private ModifyLog modifyLog;

    /** nullable persistent field */
    private Integer parentId;

    /** nullable persistent field */
    private String fullPath;

    /** linked object*/
    private Set children;
	
    private Set prioritys;
    
    /** default constructor */
    public SLACategory() {
    }

    public Integer getId() {
        return this.id;
    }

	public void setId(Integer id) {
		this.id = id;
	}

    public SLAMaster getMaster() {
        return this.master;
    }

	public void setMaster(SLAMaster master) {
		this.master = master;
	}

	public ModifyLog getModifyLog() {
		return modifyLog;
	}

	public void setModifyLog(ModifyLog modifyLog) {
		this.modifyLog = modifyLog;
	}
	
	public Integer getParentId() {
		return this.parentId;
	}
    
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	
	public String getFullPath() {
	    return fullPath;
	}
	
	public void setFullPath(String fullPath) {
	    this.fullPath = fullPath;
	}
	
	public Set getChildren() {
		return children;
	}

	public void setChildren(Set set) {
		children = set;
	}

	public Set getPrioritys() {
		return prioritys;
	}

	public void setPrioritys(Set set) {
		prioritys = set;
	}

	public boolean equals(Object obj) {
        if (obj == null) return false;
        if (this == obj) return true;
        if (!(obj instanceof SLACategory)) return false;
        SLACategory that = (SLACategory)obj;
        if (this.getId() != null) {
            return this.getId().equals(that.getId());
        }
        return that.getId() == null;	
    }

}

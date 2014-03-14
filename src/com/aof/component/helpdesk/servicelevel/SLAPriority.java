package com.aof.component.helpdesk.servicelevel;

import com.aof.component.helpdesk.ModifyLog;


/** @author Hibernate CodeGenerator */
public class SLAPriority extends SLAAbstractDesc {

    /** identifier field */
    private Integer id;

    /** nullable persistent field */
    private SLACategory category;

    /** nullable persistent field */
    private Integer responseTime;

    /** nullable persistent field */
    private Integer solveTime;

    /** nullable persistent field */
    private Integer closeTime;

    /** nullable persistent field */
    private Integer responseWarningTime;

    /** nullable persistent field */
    private Integer solveWarningTime;

    /** nullable persistent field */
    private Integer closeWarningTime;

    private ModifyLog modifyLog;

    /** default constructor */
    public SLAPriority() {
    }

    public Integer getId() {
        return this.id;
    }

	public void setId(Integer id) {
		this.id = id;
	}

    public SLACategory getCategory() {
        return this.category;
    }

	public void setCategory(SLACategory category) {
		this.category = category;
	}

    public Integer getResponseTime() {
        return this.responseTime;
    }

	public void setResponseTime(Integer responseTime) {
		this.responseTime = responseTime;
	}

    public Integer getSolveTime() {
        return this.solveTime;
    }

	public void setSolveTime(Integer solveTime) {
		this.solveTime = solveTime;
	}

    public Integer getCloseTime() {
        return this.closeTime;
    }

	public void setCloseTime(Integer closeTime) {
		this.closeTime = closeTime;
	}

    public Integer getResponseWarningTime() {
        return this.responseWarningTime;
    }

	public void setResponseWarningTime(Integer responseWarningTime) {
		this.responseWarningTime = responseWarningTime;
	}

    public Integer getSolveWarningTime() {
        return this.solveWarningTime;
    }

	public void setSolveWarningTime(Integer solveWarningTime) {
		this.solveWarningTime = solveWarningTime;
	}

    public Integer getCloseWarningTime() {
        return this.closeWarningTime;
    }

	public void setCloseWarningTime(Integer closeWarningTime) {
		this.closeWarningTime = closeWarningTime;
	}

	public ModifyLog getModifyLog() {
		return modifyLog;
	}

	public void setModifyLog(ModifyLog modifyLog) {
		this.modifyLog = modifyLog;
	}

	public boolean equals(Object obj) {
        if (obj == null) return false;
        if (this == obj) return true;
        if (!(obj instanceof SLAPriority)) return false;
        SLAPriority that = (SLAPriority)obj;
        if (this.getId() != null) {
            return this.getId().equals(that.getId());
        }
        return that.getId() == null;	
    }

}

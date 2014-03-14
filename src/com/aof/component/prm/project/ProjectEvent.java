package com.aof.component.prm.project;

import java.io.Serializable;
import java.util.Set;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectEvent implements Serializable {

    /** identifier field */
    private Integer peventId;

	/** nullable persistent field */
	private String peventCode;
		
    /** nullable persistent field */
    private String peventName;
    
	/** nullable persistent field */
    private String billable;
    
    private ProjectType pt;

    /** full constructor */
    public ProjectEvent(java.lang.String peventCode,java.lang.String peventName,ProjectType pt) {
        this.peventCode = peventCode;
        this.peventName = peventName;
        this.pt=pt;
    }

    /** default constructor */
    public ProjectEvent() {
    }

    public Integer getPeventId() {
        return this.peventId;
    }

	public void setPeventId(Integer peventId) {
		this.peventId = peventId;
	}

	public java.lang.String getPeventCode() {
		return this.peventCode;
	}

	public void setPeventCode(java.lang.String peventCode) {
		this.peventCode = peventCode;
	}

    public java.lang.String getPeventName() {
        return this.peventName;
    }

	public void setPeventName(java.lang.String peventName) {
		this.peventName = peventName;
	}

	public ProjectType getPt() {
		   return this.pt;
	   }
    

	public void setPt(ProjectType pt) {
		this.pt = pt;
	}
	
    public String toString() {
        return new ToStringBuilder(this)
            .append("peventId", getPeventId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectEvent) ) return false;
        ProjectEvent castOther = (ProjectEvent) other;
        return new EqualsBuilder()
            .append(this.getPeventId(), castOther.getPeventId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getPeventId())
            .toHashCode();
    }


	/**
	 * @return
	 */
	public String getBillable() {
		return billable;
	}

	/**
	 * @param string
	 */
	public void setBillable(String string) {
		billable = string;
	}

}

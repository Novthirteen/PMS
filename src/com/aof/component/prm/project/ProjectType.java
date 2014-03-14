package com.aof.component.prm.project;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectType implements Serializable {

    /** identifier field */
    private String ptId;

    /** nullable persistent field */
    private String ptName;
    
	/** nullable persistent field */
	private String openProject;


    /** full constructor */
    public ProjectType(java.lang.String ptId,java.lang.String ptName,java.lang.String openProject) {
        this.ptName = ptName;
    }

    /** default constructor */
    public ProjectType() {
    }

    public String getPtId() {
        return this.ptId;
    }

	public void setPtId(java.lang.String ptId) {
		this.ptId = ptId;
	}

    public java.lang.String getPtName() {
        return this.ptName;
    }

	public void setPtName(java.lang.String ptName) {
		this.ptName = ptName;
	}

	public java.lang.String getOpenProject() {
			return this.openProject;
		}

		public void setOpenProject(java.lang.String openProject) {
			this.openProject = openProject;
		}
		
    public String toString() {
        return new ToStringBuilder(this)
            .append("ptId", getPtId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectType) ) return false;
        ProjectType castOther = (ProjectType) other;
        return new EqualsBuilder()
            .append(this.getPtId(), castOther.getPtId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getPtId())
            .toHashCode();
    }

}

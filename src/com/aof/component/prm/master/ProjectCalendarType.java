package com.aof.component.prm.master;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectCalendarType implements Serializable {

    /** identifier field */
    private String TypeId;

    /** nullable persistent field */
    private String Description;

    /** full constructor */
    public ProjectCalendarType(java.lang.String TypeId, java.lang.String Description) {
        this.TypeId = TypeId;
        this.Description = Description;
    }

    /** default constructor */
    public ProjectCalendarType() {
    }

    /** minimal constructor */
    public ProjectCalendarType(java.lang.String TypeId) {
        this.TypeId = TypeId;
    }

    public java.lang.String getTypeId() {
        return this.TypeId;
    }

	public void setTypeId(java.lang.String TypeId) {
		this.TypeId = TypeId;
	}

    public java.lang.String getDescription() {
        return this.Description;
    }

	public void setDescription(java.lang.String Description) {
		this.Description = Description;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("TypeId", getTypeId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectCalendarType) ) return false;
        ProjectCalendarType castOther = (ProjectCalendarType) other;
        return new EqualsBuilder()
            .append(this.getTypeId(), castOther.getTypeId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getTypeId())
            .toHashCode();
    }

}

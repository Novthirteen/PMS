package com.aof.component.prm.project;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectEventType implements Serializable {

    /** identifier field */
    private Integer petId;

    /** nullable persistent field */
    private String petName;

    /** full constructor */
    public ProjectEventType(java.lang.String petName) {
        this.petName = petName;
    }

    /** default constructor */
    public ProjectEventType() {
    }

    public Integer getPetId() {
        return this.petId;
    }

	public void setPetId(Integer petId) {
		this.petId = petId;
	}

    public java.lang.String getPetName() {
        return this.petName;
    }

	public void setPetName(java.lang.String petName) {
		this.petName = petName;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("petId", getPetId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectEventType) ) return false;
        ProjectEventType castOther = (ProjectEventType) other;
        return new EqualsBuilder()
            .append(this.getPetId(), castOther.getPetId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getPetId())
            .toHashCode();
    }

}

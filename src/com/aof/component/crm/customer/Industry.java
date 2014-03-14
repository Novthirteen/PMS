package com.aof.component.crm.customer;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class Industry implements Serializable {

    /** identifier field */
    private Long Id;

    /** nullable persistent field */
    private String Description;

    /** full constructor */
    public Industry(java.lang.String Description) {
        this.Description = Description;
    }

    /** default constructor */
    public Industry() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public java.lang.String getDescription() {
        return this.Description;
    }

	public void setDescription(java.lang.String Description) {
		this.Description = Description;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof Industry) ) return false;
        Industry castOther = (Industry) other;
        return new EqualsBuilder()
            .append(this.getId(), castOther.getId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }

}

package com.aof.component.prm.expense;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectCostType implements Serializable {

    /** identifier field */
    private String typeid;

    /** nullable persistent field */
    private String typename;

	private String typeaccount;

    /** full constructor */
    public ProjectCostType(java.lang.String typename) {
        this.typename = typename;
    }

    /** default constructor */
    public ProjectCostType() {
    }

    public java.lang.String getTypeid() {
        return this.typeid;
    }

	public void setTypeid(java.lang.String typeid) {
		this.typeid = typeid;
	}

    public java.lang.String getTypename() {
        return this.typename;
    }

	public void setTypename(java.lang.String typename) {
		this.typename = typename;
	}

	public java.lang.String getTypeaccount() {
        return this.typeaccount;
    }

	public void setTypeaccount(java.lang.String typeaccount) {
		this.typeaccount = typeaccount;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("typeid", getTypeid())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectCostType) ) return false;
        ProjectCostType castOther = (ProjectCostType) other;
        return new EqualsBuilder()
            .append(this.getTypeid(), castOther.getTypeid())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getTypeid())
            .toHashCode();
    }

}

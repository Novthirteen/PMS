package com.aof.component.prm.project;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectCategory implements Serializable {

	/** identifier field */
	private String Id;

	/** nullable persistent field */
	private String Name;
    
	/** full constructor */
	public ProjectCategory(java.lang.String Id,java.lang.String Name) {
		this.Name = Name;
	}

	/** default constructor */
	public ProjectCategory() {
	}

	public String getId() {
		return this.Id;
	}

	public void setId(java.lang.String Id) {
		this.Id = Id;
	}

	public java.lang.String getName() {
		return this.Name;
	}

	public void setName(java.lang.String Name) {
		this.Name = Name;
	}

	public String toString() {
		return new ToStringBuilder(this)
			.append("Id", getId())
			.toString();
	}

	public boolean equals(Object other) {
		if ( !(other instanceof ProjectCategory) ) return false;
		ProjectCategory castOther = (ProjectCategory) other;
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

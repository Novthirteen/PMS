package com.aof.component.prm.project;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

import com.aof.component.domain.party.Party;

public class StandardBOMMaster {
	private long id;
	private Party department;
	private String description;
	public Party getDepartment() {
		return department;
	}
	public void setDepartment(Party department) {
		this.department = department;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	
	public boolean equals(Object other) {
		if ( !(other instanceof StandardBOMMaster) ) return false;
		StandardBOMMaster castOther = (StandardBOMMaster) other;
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

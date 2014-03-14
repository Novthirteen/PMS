/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.bid;

import java.io.Serializable;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.Party;

/**
 * @author CN01458
 * @version 2005-6-28
 */
public class SalesStepGroup implements Serializable {
	private Long id;
	private Party department;
	private String description;
	private String disableFlag;
	private Set steps;
	/**
	 * @param id
	 * @param department
	 * @param description
	 * @param disableFlag
	 * @param steps
	 */
	public SalesStepGroup(Long id, Party department, String description,
			String disableFlag, Set steps) {
		super();
		this.id = id;
		this.department = department;
		this.description = description;
		this.disableFlag = disableFlag;
		this.steps = steps;
	}
	/**
	 * @param id
	 */
	public SalesStepGroup(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public SalesStepGroup() {
		super();
	}
	/**
	 * @return Returns the department.
	 */
	public Party getDepartment() {
		return department;
	}
	/**
	 * @param department The department to set.
	 */
	public void setDepartment(Party department) {
		this.department = department;
	}
	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return description;
	}
	/**
	 * @param description The description to set.
	 */
	public void setDescription(String description) {
		this.description = description;
	}
	/**
	 * @return Returns the disableFlag.
	 */
	public String getDisableFlag() {
		return disableFlag;
	}
	/**
	 * @param disableFlag The disableFlag to set.
	 */
	public void setDisableFlag(String disableFlag) {
		this.disableFlag = disableFlag;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the steps.
	 */
	public Set getSteps() {
		return steps;
	}
	/**
	 * @param steps The steps to set.
	 */
	public void setSteps(Set steps) {
		this.steps = steps;
	}
	public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof SalesStepGroup) ) return false;
        SalesStepGroup castOther = (SalesStepGroup) other;
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

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

/**
 * @author CN01458
 * @version 2005-6-28
 */
public class SalesStep implements Serializable {
	private Long id;
	private SalesStepGroup stepGroup;
	private Integer seqNo;
	private String description;
	private Integer percentage;
	private Set activities;
	/**
	 * @param id
	 * @param stepGroup
	 * @param seqNo
	 * @param description
	 * @param percentage
	 * @param activities
	 */
	public SalesStep(Long id, SalesStepGroup stepGroup, Integer seqNo,
			String description, Integer percentage, Set activities) {
		super();
		this.id = id;
		this.stepGroup = stepGroup;
		this.seqNo = seqNo;
		this.description = description;
		this.percentage = percentage;
		this.activities = activities;
	}
	/**
	 * @param id
	 */
	public SalesStep(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public SalesStep() {
		super();
	}
	/**
	 * @return Returns the activities.
	 */
	public Set getActivities() {
		return activities;
	}
	/**
	 * @param activities The activities to set.
	 */
	public void setActivities(Set activities) {
		this.activities = activities;
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
	 * @return Returns the percentage.
	 */
	public Integer getPercentage() {
		return percentage;
	}
	/**
	 * @param percentage The percentage to set.
	 */
	public void setPercentage(Integer percentage) {
		this.percentage = percentage;
	}
	/**
	 * @return Returns the seqNo.
	 */
	public Integer getSeqNo() {
		return seqNo;
	}
	/**
	 * @param seqNo The seqNo to set.
	 */
	public void setSeqNo(Integer seqNo) {
		this.seqNo = seqNo;
	}
	/**
	 * @return Returns the stepGroup.
	 */
	public SalesStepGroup getStepGroup() {
		return stepGroup;
	}
	/**
	 * @param stepGroup The stepGroup to set.
	 */
	public void setStepGroup(SalesStepGroup stepGroup) {
		this.stepGroup = stepGroup;
	}
	public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof SalesStep) ) return false;
        SalesStep castOther = (SalesStep) other;
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

/*
 * Created on 2005-8-10
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
 
package com.aof.component.prm.bid;

import java.util.Date;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * @author CN01512
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class BidActDetail {
	private Long id;
	private com.aof.component.prm.bid.BidActivity bidActivity;
	private com.aof.component.domain.party.UserLogin assignee;
	private Date actionDate;
	private Float hours;
	private String description;
	
	/**
	 * 
	 */
	public BidActDetail() {
		super();
	}
	/**
	 * @param pdId
	 */
	public BidActDetail(Long id) {
		super();
		this.id = id;
	}
	/**
	 * @param pdId
	 * @param preSaleMaster
	 * @param assignee
	 * @param actionDate
	 * @param hours
	 * @param description
	 */
	public BidActDetail(Long id,
	com.aof.component.prm.bid.BidActivity bidActivity,
	com.aof.component.domain.party.UserLogin assignee, Date actionDate,
			Float hours, String description) {
		super();
		this.id = id;
		this.bidActivity = bidActivity;
		this.assignee = assignee;
		this.actionDate = actionDate;
		this.hours = hours;
		this.description = description;
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
	 * @return Returns the hours.
	 */
	public Float getHours() {
		return hours;
	}
	/**
	 * @param hours The hours to set.
	 */
	public void setHours(Float hours1) {
		this.hours = hours1;
	}
	/**
	 * @return Returns the actionDate.
	 */
	public Date getActionDate() {
		return actionDate;
	}
	/**
	 * @param actionDate The actionDate to set.
	 */
	public void setActionDate(Date actionDate) {
		this.actionDate = actionDate;
	}
	/**
	 * @return Returns the assignee.
	 */
	public com.aof.component.domain.party.UserLogin getAssignee() {
		return assignee;
	}
	/**
	 * @param assignee The assignee to set.
	 */
	public void setAssignee(com.aof.component.domain.party.UserLogin assignee) {
		this.assignee = assignee;
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
	 * @return Returns the bidActivity.
	 */
	public com.aof.component.prm.bid.BidActivity  getBidActivity() {
		return bidActivity;
	}
	/**
	 * @param bidActivity The bidActivity to set.
	 */
	public void setBidActivity(com.aof.component.prm.bid.BidActivity bidActivity) {
		this.bidActivity = bidActivity;
	}
	public String toString() {
		return new ToStringBuilder(this)
			.append("id", getId())
			.toString();
	}

	public boolean equals(Object other) {
		if ( !(other instanceof BidActivity) ) return false;
		BidActDetail castOther = (BidActDetail) other;
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

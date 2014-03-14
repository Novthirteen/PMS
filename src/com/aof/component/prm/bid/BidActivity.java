/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.bid;

import java.io.Serializable;
import java.util.*;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * @author CN01458
 * @version 2005-6-28
 */
public class BidActivity implements Serializable {
	private Long id;
	private SalesActivity activity;
	private Date actionDate;
	private BidMaster bidMaster;
	private Set bidActDetails;
	/**
	 * @param activity
	 * @param actionDate
	 */
	public BidActivity(Long id,SalesActivity activity, Date actionDate,BidMaster bidMaster,Set bidActDetails) {
		super();
		this.id = id;
		this.activity = activity;
		this.actionDate = actionDate;
		this.bidMaster = bidMaster;
		this.bidActDetails = bidActDetails;
	}
	/**
	 * 
	 */
	public BidActivity() {
		super();
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
	 * @return Returns the id.
	 */
	public BidMaster getBidMaster() {
		return bidMaster;
	}
	/**
	 * @param id The id to set.
	 */
	public void setBidMaster(BidMaster bidMaster) {
		this.bidMaster = bidMaster;
	}
	/**
	 * @return Returns the bidActDetails.
	 */
	public java.util.Set getBidActDetails() {
		return bidActDetails;
	}
	public void removeBidActDetails(BidActDetail bidActDetail) {
		if (this.bidActDetails!= null) {
			this.bidActDetails.remove(bidActDetail);
		}
	}
	public void addBidActDetail(BidActDetail bidActDetail) {
		if (this.bidActDetails == null) {
			this.bidActDetails = new HashSet();
		}
		
		this.bidActDetails.add(bidActDetail);
	}
	/**
	 * @param bidActDetails The bidActDetails to set.
	 */
	public void setBidActDetails(java.util.Set bidActDetails) {
		this.bidActDetails = bidActDetails;
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
	 * @return Returns the activity.
	 */
	public SalesActivity getActivity() {
		return activity;
	}
	/**
	 * @param activity The activity to set.
	 */
	public void setActivity(SalesActivity activity) {
		this.activity = activity;
	}
	
	public String toString() {
		return new ToStringBuilder(this)
			.append("id", getId())
			.toString();
	}

	public boolean equals(Object other) {
		if ( !(other instanceof BidActivity) ) return false;
		BidActivity castOther = (BidActivity) other;
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

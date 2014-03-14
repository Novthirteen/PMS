/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.bid;

import java.util.Date;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

public class BidMasterStatus {
	private Long id;
	private BidMaster bidMaster;
	private String status;
	private Date actionDate;
	/**
	 * @param date
	 * @param master
	 * @param id
	 * @param status
	 */
	public BidMasterStatus(Date date, BidMaster master, Long id, String status) {
		super();
		// TODO Auto-generated constructor stub
		actionDate = date;
		bidMaster = master;
		this.id = id;
		this.status = status;
	}
	/**
	 * @param id
	 */
	public BidMasterStatus(Long id) {
		super();
		// TODO Auto-generated constructor stub
		this.id = id;
	}
	/**
	 * 
	 */
	public BidMasterStatus() {
		super();
		// TODO Auto-generated constructor stub
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
	 * @return Returns the bidMaster.
	 */
	public BidMaster getBidMaster() {
		return bidMaster;
	}
	/**
	 * @param bidMaster The bidMaster to set.
	 */
	public void setBidMaster(BidMaster bidMaster) {
		this.bidMaster = bidMaster;
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
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof BidMaster) ) return false;
        BidMaster castOther = (BidMaster) other;
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

/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.bid;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * @author CN01458
 * @version 2005-6-28
 */
public class ContactList implements Serializable {
	private Long id;
	private String name;
	private String chineseName;
	private String teleNo;
	private String email;
	private String position;
	private Long bid_id;
	
	/**
	 * @param id
	 * @param name
	 * @param chineseName
	 * @param teleNo
	 * @param email
	 */
	public ContactList(Long id, String name, String chineseName, String teleNo,
			String email,String position) {
		super();
		this.id = id;
		this.name = name;
		this.chineseName = chineseName;
		this.teleNo = teleNo;
		this.email = email;
		this.position = position;
	}
	/**
	 * @param id
	 */
	public ContactList(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public ContactList() {
		super();
	}
	/**
	 * @return Returns the chineseName.
	 */
	public String getChineseName() {
		return chineseName;
	}
	/**
	 * @param chineseName The chineseName to set.
	 */
	public void setChineseName(String chineseName) {
		this.chineseName = chineseName;
	}
	/**
	 * @return Returns the position.
	 */
	public String getPosition() {
		return position;
	}
	/**
	 * @param chineseName The positon to set.
	 */
	public void setPosition(String position) {
		this.position = position;
	}
	/**
	 * @return Returns the email.
	 */
	public String getEmail() {
		return email;
	}
	/**
	 * @param email The email to set.
	 */
	public void setEmail(String email) {
		this.email = email;
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
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return Returns the teleNo.
	 */
	public String getTeleNo() {
		return teleNo;
	}
	/**
	 * @param teleNo The teleNo to set.
	 */
	public void setTeleNo(String teleNo) {
		this.teleNo = teleNo;
	}
	public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ContactList) ) return false;
        ContactList castOther = (ContactList) other;
        return new EqualsBuilder()
            .append(this.getId(), castOther.getId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }
	/**
	 * @return Returns the bid_id.
	 */
	public Long getBid_id() {
		return bid_id;
	}
	/**
	 * @param bid_id The bid_id to set.
	 */
	public void setBid_id(Long bid_id) {
		this.bid_id = bid_id;
	}
}

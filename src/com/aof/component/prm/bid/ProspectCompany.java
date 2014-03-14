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
public class ProspectCompany implements Serializable {
	private Long id;
	private String name;
	private String chineseName;
	private String city;
	private String address;
	private String bankNo;
	private String industry;
	private String customerGroup;
	private String postCode;
	private String teleNo;
	private String faxNo;
	private Set contactList;
	private String status;
	
	/**
	 * @param id
	 * @param name
	 * @param chineseName
	 * @param city
	 * @param address
	 * @param bankNo
	 * @param industry
	 * @param customerGroup
	 * @param postCode
	 * @param teleNo
	 * @param faxNo
	 * @param contactList
	 */
	public ProspectCompany(Long id, String name, String chineseName,
			String city, String address, String bankNo, String industry,
			String customerGroup, String postCode, String teleNo, String faxNo,
			Set contactList,String status) {
		super();
		this.id = id;
		this.name = name;
		this.chineseName = chineseName;
		this.city = city;
		this.address = address;
		this.bankNo = bankNo;
		this.industry = industry;
		this.customerGroup = customerGroup;
		this.postCode = postCode;
		this.teleNo = teleNo;
		this.faxNo = faxNo;
		this.contactList = contactList;
		this.status = status;
	}
	/**
	 * @param id
	 */
	public ProspectCompany(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public ProspectCompany() {
		super();
	}
	/**
	 * @return Returns the address.
	 */
	public String getAddress() {
		return address;
	}
	/**
	 * @param address The address to set.
	 */
	public void setAddress(String address) {
		this.address = address;
	}
	/**
	 * @return Returns the bankNo.
	 */
	public String getBankNo() {
		return bankNo;
	}
	/**
	 * @param bankNo The bankNo to set.
	 */
	public void setBankNo(String bankNo) {
		this.bankNo = bankNo;
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
	 * @return Returns the city.
	 */
	public String getCity() {
		return city;
	}
	/**
	 * @param city The city to set.
	 */
	public void setCity(String city) {
		this.city = city;
	}
	/**
	 * @return Returns the contactList.
	 */
	public Set getContactList() {
		return contactList;
	}
	/**
	 * @param contactList The contactList to set.
	 */
	public void setContactList(Set contactList) {
		this.contactList = contactList;
	}
	public void removeContactList(ContactList contact) {
		if (this.contactList != null) {
			this.contactList.remove(contact);
		}
	}
	public void addContactList(ContactList contact) {
		if (this.contactList == null) {
			this.contactList = new HashSet();
		}
	
		this.contactList.add(contact);
	}
	/**
	 * @return Returns the customerGroup.
	 */
	public String getCustomerGroup() {
		return customerGroup;
	}
	/**
	 * @param customerGroup The customerGroup to set.
	 */
	public void setCustomerGroup(String customerGroup) {
		this.customerGroup = customerGroup;
	}
	/**
	 * @return Returns the faxNo.
	 */
	public String getFaxNo() {
		return faxNo;
	}
	/**
	 * @param faxNo The faxNo to set.
	 */
	public void setFaxNo(String faxNo) {
		this.faxNo = faxNo;
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
	 * @return Returns the industry.
	 */
	public String getIndustry() {
		return industry;
	}
	/**
	 * @param industry The industry to set.
	 */
	public void setIndustry(String industry) {
		this.industry = industry;
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
	 * @return Returns the postCode.
	 */
	public String getPostCode() {
		return postCode;
	}
	/**
	 * @param postCode The postCode to set.
	 */
	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}
	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param postCode The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
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
        if ( !(other instanceof ProspectCompany) ) return false;
        ProspectCompany castOther = (ProspectCompany) other;
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

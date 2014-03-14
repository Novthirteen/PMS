/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.party;

import java.util.Set;   
import java.io.Serializable;

import com.aof.component.crm.customer.Industry;
import com.aof.component.helpdesk.servicelevel.SLAMaster;
/**        
 * @author xxp                     
 * @version 2003-6-22         
 *                     
 */   
public class Party implements Serializable {  
	private String partyId;     
	private String description;
	private String address;   
	private String teleCode;
	private String faxCode;   
	private String city;
	private String postCode;
	private String linkMan;
	private String province;
	private String note;
	private String isSales;

	private PartyType partyType;   
	private Set PartyRoles;
	private Set relationships;
	private String chnName;
	private String ChineseName;
	private String AccountCode;
	private Industry industry;
	//private Set partyFacilitys;
	
	public String getChineseName() {
		return ChineseName;
	}

	public void setChineseName(String chineseName) {
		ChineseName = chineseName;
	}

	/**
	 * @return
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @return
	 */
	public String getPartyId() {
		return partyId;
	}

	/**
	 * @param string
	 */
	public void setDescription(String string) {
		description = string;
	}

	/**
	 * @param string
	 */
	public void setPartyId(String string) {
		partyId = string;
	}

	/**
	 * @return
	 */
	public PartyType getPartyType() {
		return partyType;
	}

	/**
	 * @param type
	 */
	public void setPartyType(PartyType type) {
		partyType = type;
	}

	/**
	 * @return
	 */
	public Set getPartyRoles() {
		return PartyRoles;
	}

	/**
	 * @param set
	 */
	public void setPartyRoles(Set set) {
		PartyRoles = set;
	}

	/**
	 * @return
	 */
	public Set getRelationships() {
		return relationships;
	}
	
	/**
	 * @param set
	 */
	public void setRelationships(Set set) {
		relationships = set;
	}

	/**
	 * @return
	 */
	public String getCity() {
		return city;
	}

	/**
	 * @return
	 */
	public String getFaxCode() {
		return faxCode;
	}

	/**
	 * @return
	 */
	public String getLinkMan() {
		return linkMan;
	}

	/**
	 * @return
	 */
	public String getPostCode() {
		return postCode;
	}

	/**
	 * @return
	 */
	public String getTeleCode() {
		return teleCode;
	}

	/**
	 * @param string
	 */
	public void setCity(String string) {
		city = string;
	}

	/**
	 * @param string
	 */
	public void setFaxCode(String string) {
		faxCode = string;
	}

	/**
	 * @param string
	 */
	public void setLinkMan(String string) {
		linkMan = string;
	}

	/**
	 * @param string
	 */
	public void setPostCode(String string) {
		postCode = string;
	}

	/**
	 * @param string
	 */
	public void setTeleCode(String string) {
		teleCode = string;
	}

	/**
	 * @return
	 */
	public String getAddress() {
		return address;
	}

	/**
	 * @param string
	 */
	public void setAddress(String string) {
		address = string;
	}

	/**
	 * @return
	 */
	public String getProvince() {
		return province;
	}

	/**
	 * @param string
	 */
	public void setProvince(String string) {
		province = string;
	}

	/**
	 * @return
	 */
	public String getNote() {
		return note;
	}

	/**
	 * @param string
	 */
	public void setNote(String string) {
		note = string;
	}

	/**
	 * @return
	 */
	//public Set getPartyFacilitys() {
	//	return partyFacilitys;
	//}

	/**
	 * @param set
	 */
	//public void setPartyFacilitys(Set set) {
	//	partyFacilitys = set;
	//}

	public boolean equals(Object obj) {
        if (obj == null) return false;
        if (this == obj) return true;
        if (!(obj instanceof Party)) return false;
        Party that = (Party)obj;
        if (this.getPartyId() != null) {
            return this.getPartyId().equals(that.getPartyId());
        }
        return that.getPartyId() == null;	
    }

	public String getAccountCode() {
		return AccountCode;
	}

	public void setAccountCode(String accountCode) {
		AccountCode = accountCode;
	}

	public Industry getIndustry() {
		return industry;
	}

	public void setIndustry(Industry industry) {
		this.industry = industry;
	}


	public String getChnName() {
		return chnName;
	}

	public void setChnName(String chnName) {
		this.chnName = chnName;
	}
	
	/**
	 * @return Returns the isSales.
	 */
	public String getIsSales() {
		return isSales;
	}
	/**
	 * @param isSales The isSales to set.
	 */
	public void setIsSales(String isSales) {
		this.isSales = isSales;
	}
}

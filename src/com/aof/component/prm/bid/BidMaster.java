/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.bid;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.crm.customer.CustomerAccount;
import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.crm.customer.Industry;
import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.CurrencyType;


/**
 * @author CN01458
 * @version 2005-6-28
 */
public class BidMaster {
	private Long id;
	private String no;
	private String description;
	private CustomerProfile prospectCompany;
	private Double estimateAmount;
	private Party department;
	private UserLogin salesPerson;
	private String status;
	private Date estimateStartDate;
	private Date estimateEndDate;
	private CurrencyType currency;
	private Float exchangeRate;
	private SalesStepGroup stepGroup;
	private Date postDate;
	private Set bidActivities;
	private SalesStep currentStep;
	private String contractType;
	private UserLogin presalePM;
	
	private String departmentName;
	private String companyName;
	private String salesName;
	private String secondarySalesName;
	private String stepName;
	private String percentage;
	private String bidEndDate;
	private Date lastActionDate;
	private Set bidStatusHistorys;
	private UserLogin SecondarySalesPerson;
	private Date expectedEndDate;
	private Date createDate;
	private Set contactList;
//	private Set bmhistory;

	
//	public Set getBmhistory() {
//		return bmhistory;
//	}

//	public void setBmhistory(Set bmhistory) {
//		this.bmhistory = bmhistory;
//	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public Date getExpectedEndDate() {
		return expectedEndDate;
	}

	public void setExpectedEndDate(Date expectedEndDate) {
		this.expectedEndDate = expectedEndDate;
	}

	public UserLogin getSecondarySalesPerson() {
		return SecondarySalesPerson;
	}

	public void setSecondarySalesPerson(UserLogin secondarySalesPerson) {
		SecondarySalesPerson = secondarySalesPerson;
	}
	
	/**
	 * @param id
	 * @param description
	 * @param prospectCompany
	 * @param estimateAmount
	 * @param department
	 * @param salesPerson
	 * @param status
	 * @param estimateStartDate
	 * @param estimateEndDate
	 * @param currency
	 * @param exchangeRate
	 * @param stepGroup
	 * @param postDate
	 * @param bidActivities
	 * @param currentStep
	 */
	public BidMaster(Long id, String no,String description,
			CustomerProfile prospectCompany, Double estimateAmount,
			Party department, UserLogin salesPerson, String status,
			Date estimateStartDate, Date estimateEndDate,
			CurrencyType currency, Float exchangeRate,
			SalesStepGroup stepGroup, Date postDate, Set bidActivities,
			SalesStep currentStep,String contractType,UserLogin secondarySalesPerson,UserLogin presalePM) {
		super();
		this.id = id;
		this.no = no;
		this.description = description;
		this.prospectCompany = prospectCompany;
		this.estimateAmount = estimateAmount;
		this.department = department;
		this.salesPerson = salesPerson;
		this.status = status;
		this.estimateStartDate = estimateStartDate;
		this.estimateEndDate = estimateEndDate;
		this.currency = currency;
		this.exchangeRate = exchangeRate;
		this.stepGroup = stepGroup;
		this.postDate = postDate;
		this.bidActivities = bidActivities;
		this.currentStep = currentStep;
		this.contractType = contractType;

		this.SecondarySalesPerson=secondarySalesPerson;
		this.presalePM = presalePM;
	}
	
	public String getDepartmentName(){
		String departmentName = "";
		if(this.department!=null){
			departmentName = this.department.getDescription();
		}
		return departmentName;
	}
	public String getCompanyName(){
		String companyName = "";
		if(this.prospectCompany != null){
			companyName = this.prospectCompany.getDescription();
		}
		return companyName;
	}
	public String getBidEndDate(){
		String endDate = "";
		if(this.expectedEndDate != null){
			endDate = this.expectedEndDate.toString();
		}
		return endDate;
	}
	
	public String getSalesName(){
		String salesName = "";
		if(this.salesPerson != null){
			salesName = this.salesPerson.getName();
		}
		return salesName;
	}
	public String getSecondarySalesName(){
		String secondarySalesName = "";
		if(this.SecondarySalesPerson!= null){
			secondarySalesName = this.SecondarySalesPerson.getName();
		}
		return secondarySalesName;
	}
	public String getStepName(){
		String stepName = "";
		if(this.currentStep!=null){
			stepName = this.currentStep.getDescription();
		}
		return stepName;
	}
	public String getPercentage(){
		String percentage = "";
		if(this.currentStep!=null){
			percentage = this.currentStep.getPercentage().toString();
		}
		return percentage;
	}
	/**
	 * @param id
	 */
	public BidMaster(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public BidMaster() {
		super();
	}

	/**
	 * @return Returns the bidActivities.
	 */
	public Set getBidActivities() {
		return bidActivities;
	}
	/**
	 * @param bidActivities The bidActivities to set.
	 */
	public void setBidActivities(Set bidActivities) {
		this.bidActivities = bidActivities;
	}
	public void addBidActivity(BidActivity ba) {
		if (bidActivities == null) {
			bidActivities = new HashSet();
		}
		
		bidActivities.add(ba);
	}
//	public void addBidMstrHistoty(BMHistory bmh) {
//		if (bmhistory == null) {
//			bmhistory = new HashSet();
//		}
		
//		bmhistory.add(bmh);
//	}
	public void removeBidActivity(BidActivity ba) {
		if (bidActivities != null) {
			bidActivities.remove(ba);
		}
	}
	/**
	 * @return Returns the no.
	 */
	public String getNo() {
		return this.no;
	}
	/**
	 * @param no The no to set.
	 */
	public void setNo(String no) {
		this.no = no;
	}
	/**
	 * @return Returns the currency.
	 */
	public CurrencyType getCurrency() {
		return currency;
	}
	/**
	 * @param currency The currency to set.
	 */
	public void setCurrency(CurrencyType currency) {
		this.currency = currency;
	}
	/**
	 * @return Returns the currentStep.
	 */
	public SalesStep getCurrentStep() {
		return currentStep;
	}
	/**
	 * @param currentStep The currentStep to set.
	 */
	public void setCurrentStep(SalesStep currentStep) {
		this.currentStep = currentStep;
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
	 * @return Returns the estimateAmount.
	 */
	public Double getEstimateAmount() {
		return estimateAmount;
	}
	/**
	 * @param estimateAmount The estimateAmount to set.
	 */
	public void setEstimateAmount(Double estimateAmount) {
		this.estimateAmount = estimateAmount;
	}
	/**
	 * @return Returns the estimateEndDate.
	 */
	public Date getEstimateEndDate() {
		return estimateEndDate;
	}
	/**
	 * @param estimateEndDate The estimateEndDate to set.
	 */
	public void setEstimateEndDate(Date estimateEndDate) {
		this.estimateEndDate = estimateEndDate;
	}
	/**
	 * @return Returns the estimateStartDate.
	 */
	public Date getEstimateStartDate() {
		return estimateStartDate;
	}
	/**
	 * @param estimateStartDate The estimateStartDate to set.
	 */
	public void setEstimateStartDate(Date estimateStartDate) {
		this.estimateStartDate = estimateStartDate;
	}
	/**
	 * @return Returns the exchangeRate.
	 */
	public Float getExchangeRate() {
		return exchangeRate;
	}
	/**
	 * @param exchangeRate The exchangeRate to set.
	 */
	public void setExchangeRate(Float exchangeRate) {
		this.exchangeRate = exchangeRate;
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
	 * @return Returns the postDate.
	 */
	public Date getPostDate() {
		return postDate;
	}
	/**
	 * @param postDate The postDate to set.
	 */
	public void setPostDate(Date postDate) {
		this.postDate = postDate;
	}
	/**
	 * @return Returns the prospectCompany.
	 */
	public CustomerProfile getProspectCompany() {
		return prospectCompany;
	}
	/**
	 * @param prospectCompany The prospectCompany to set.
	 */
	public void setProspectCompany(CustomerProfile prospectCompany) {
		this.prospectCompany = prospectCompany;
	}
	/**
	 * @return Returns the salesPerson.
	 */
	public UserLogin getSalesPerson() {
		return salesPerson;
	}
	/**
	 * @param salesPerson The salesPerson to set.
	 */
	public void setSalesPerson(UserLogin salesPerson) {
		this.salesPerson = salesPerson;
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
	/**
	 * @return Returns the contractType.
	 */
	public String getContractType() {
		return contractType;
	}
	/**
	 * @param status The contractType to set.
	 */
	public void setContractType(String contractType) {
		this.contractType = contractType;
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
	/**
	 * @return Returns the lastActionDate.
	 */
	public Date getLastActionDate() {
		return lastActionDate;
	}

	/**
	 * @param lastActionDate The lastActionDate to set.
	 */
	public void setLastActionDate(Date lastActionDate) {
		this.lastActionDate = lastActionDate;
	}

	/**
	 * @return Returns the bidStatusHistorys.
	 */
	public Set getBidStatusHistorys() {
		return bidStatusHistorys;
	}

	/**
	 * @param bidStatusHistorys The bidStatusHistorys to set.
	 */
	public void setBidStatusHistorys(Set bidStatusHistorys) {
		this.bidStatusHistorys = bidStatusHistorys;
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
	public Set getContactList() {
		return contactList;
	}

	
	/**
	 * @return Returns the presalePM.
	 */
	public UserLogin getPresalePM() {
		return presalePM;
	}
	/**
	 * @param presalePM The presalePM to set.
	 */
	public void setPresalePM(UserLogin presalePM) {
		this.presalePM = presalePM;
	}
}

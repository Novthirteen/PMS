/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.contract;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;

/**
 * @author CN01458
 * @version 2005-6-21
 */
public class BaseContract implements Serializable {
	private Long id;
	private String no;
	private String description;
	private Party department;
	private UserLogin projectManager;
	private UserLogin accountManager;
	private Double totalContractValue;
	private String contractType;
	private String needCAF;
	private Date startDate;
	private Date endDate;
	private Float custPaidAllowance;
	private Date signedDate;
	private Date createDate;
	private UserLogin createUser;
	private Set projects;
	private BidMaster bidMaster;
	private String status;
	private CurrencyType currency;
	private Float exchangeRate;
	private Date legalReviewDate;
	private String customerSat;
	private UserLogin SalesPerson1;
	private UserLogin SalesPerson2;
	private String comments;
	/**
	 * @param manager
	 * @param master
	 * @param type
	 * @param date
	 * @param user
	 * @param currency
	 * @param allowance
	 * @param department
	 * @param description
	 * @param date2
	 * @param rate
	 * @param id
	 * @param date3
	 * @param needcaf
	 * @param no
	 * @param manager2
	 * @param projects
	 * @param date4
	 * @param date5
	 * @param status
	 * @param value
	 */
	public BaseContract(UserLogin manager, BidMaster master, String type, Date date, UserLogin user, CurrencyType currency, Float allowance, 
						Party department, String description, Date date2, Float rate, Long id, Date date3, String needcaf, String no, 
						UserLogin manager2, Set projects, Date date4, Date date5, String status, Double value, String customerSat, String comments) {		super();
		// TODO Auto-generated constructor stub
		accountManager = manager;
		bidMaster = master;
		contractType = type;
		createDate = date;
		createUser = user;
		this.currency = currency;
		custPaidAllowance = allowance;
		this.department = department;
		this.description = description;
		endDate = date2;
		exchangeRate = rate;
		this.id = id;
		legalReviewDate = date3;
		needCAF = needcaf;
		this.no = no;
		projectManager = manager2;
		this.projects = projects;
		signedDate = date4;
		startDate = date5;
		this.status = status;
		totalContractValue = value;
		this.customerSat = customerSat;
		this.comments=comments;
	}
	/**
	 * @param id
	 */
	public BaseContract(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public BaseContract() {
		super();
	}
	/**
	 * @return Returns the accountManager.
	 */
	public UserLogin getAccountManager() {
		return accountManager;
	}
	/**
	 * @param accountManager The accountManager to set.
	 */
	public void setAccountManager(UserLogin accountManager) {
		this.accountManager = accountManager;
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
	 * @return Returns the contractType.
	 */
	public String getContractType() {
		return contractType;
	}
	/**
	 * @param contractType The contractType to set.
	 */
	public void setContractType(String contractType) {
		this.contractType = contractType;
	}
	/**
	 * @return Returns the createDate.
	 */
	public Date getCreateDate() {
		return createDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	/**
	 * @return Returns the createUser.
	 */
	public UserLogin getCreateUser() {
		return createUser;
	}
	/**
	 * @param createUser The createUser to set.
	 */
	public void setCreateUser(UserLogin createUser) {
		this.createUser = createUser;
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
	 * @return Returns the custPaidAllowance.
	 */
	public Float getCustPaidAllowance() {
		return custPaidAllowance;
	}
	/**
	 * @param custPaidAllowance The custPaidAllowance to set.
	 */
	public void setCustPaidAllowance(Float custPaidAllowance) {
		this.custPaidAllowance = custPaidAllowance;
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
	 * @return Returns the endDate.
	 */
	public Date getEndDate() {
		return endDate;
	}
	/**
	 * @param endDate The endDate to set.
	 */
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
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
	 * @return Returns the needCAF.
	 */
	public String getNeedCAF() {
		return needCAF;
	}
	/**
	 * @param needCAF The needCAF to set.
	 */
	public void setNeedCAF(String needCAF) {
		this.needCAF = needCAF;
	}
	/**
	 * @return Returns the no.
	 */
	public String getNo() {
		return no;
	}
	/**
	 * @param no The no to set.
	 */
	public void setNo(String no) {
		this.no = no;
	}
	/**
	 * @return Returns the projectManager.
	 */
	public UserLogin getProjectManager() {
		return projectManager;
	}
	/**
	 * @param projectManager The projectManager to set.
	 */
	public void setProjectManager(UserLogin projectManager) {
		this.projectManager = projectManager;
	}
	/**
	 * @return Returns the projects.
	 */
	public Set getProjects() {
		return projects;
	}
	/**
	 * @param projects The projects to set.
	 */
	public void setProjects(Set projects) {
		this.projects = projects;
	}
	public void addProject(ProjectMaster pm) {
		if (this.projects == null) {
			this.projects = new HashSet();
		}
		
		this.projects.add(pm);
	}
	public void removeProject(ProjectMaster pm) {
		if (this.projects != null) {
			this.projects.remove(pm);
		}
	}
	/**
	 * @return Returns the signedDate.
	 */
	public Date getSignedDate() {
		return signedDate;
	}
	/**
	 * @param signedDate The signedDate to set.
	 */
	public void setSignedDate(Date signedDate) {
		this.signedDate = signedDate;
	}
	/**
	 * @return Returns the startDate.
	 */
	public Date getStartDate() {
		return startDate;
	}
	/**
	 * @param startDate The startDate to set.
	 */
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
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
	 * @return Returns the totalContractValue.
	 */
	public Double getTotalContractValue() {
		return totalContractValue;
	}
	/**
	 * @param totalContractValue The totalContractValue to set.
	 */
	public void setTotalContractValue(Double totalContractValue) {
		this.totalContractValue = totalContractValue;
	}
	/**
	 * @return Returns the legalReviewDate.
	 */
	public Date getLegalReviewDate() {
		return legalReviewDate;
	}
	/**
	 * @param legalReviewDate The legalReviewDate to set.
	 */
	public void setLegalReviewDate(Date legalReviewDate) {
		this.legalReviewDate = legalReviewDate;
	}
	public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof BaseContract) ) return false;
        BaseContract castOther = (BaseContract) other;
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
	 * @return Returns the customerSat.
	 */
	public String getCustomerSat() {
		return customerSat;
	}
	/**
	 * @param customerSat The customerSat to set.
	 */
	public void setCustomerSat(String customerSat) {
		this.customerSat = customerSat;
	}
	public UserLogin getSalesPerson1() {
		return SalesPerson1;
	}
	public void setSalesPerson1(UserLogin salesPerson1) {
		SalesPerson1 = salesPerson1;
	}
	public UserLogin getSalesPerson2() {
		return SalesPerson2;
	}
	public void setSalesPerson2(UserLogin salesPerson2) {
		SalesPerson2 = salesPerson2;
	}
	
	/**
	 * @return Returns the comments.
	 */
	public String getComments() {
		return comments;
	}
	/**
	 * @param comments The comments to set.
	 */
	public void setComments(String comments) {
		this.comments = comments;
	}
}

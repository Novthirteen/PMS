/*
 * Created on 2005-4-28
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.originaldata;

import java.util.Date;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.project.ProjectMaster;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Billing {
	private Long id;
	private ProjectBill billing;
	private String billCode;
	private ProjectMaster project;
	private String projectName;
	private CustomerProfile billAddress;
	private String billAddressName;
	private Date billDate;
	private Double amount;
	private UserLogin createUser;
	
	/**
	 * @param id
	 * @param billing
	 * @param billCode
	 * @param project
	 * @param projectName
	 * @param billAddress
	 * @param billAddressName
	 * @param billDate
	 * @param amount
	 * @param createUser
	 */
	public Billing(Long id, ProjectBill billing, String billCode,
			ProjectMaster project, String projectName,
			CustomerProfile billAddress, String billAddressName, Date billDate,
			Double amount, UserLogin createUser) {
		super();
		this.id = id;
		this.billing = billing;
		this.billCode = billCode;
		this.project = project;
		this.projectName = projectName;
		this.billAddress = billAddress;
		this.billAddressName = billAddressName;
		this.billDate = billDate;
		this.amount = amount;
		this.createUser = createUser;
	}
	/**
	 * @param id
	 */
	public Billing(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public Billing() {
		super();
	}
	/**
	 * @return Returns the amount.
	 */
	public Double getAmount() {
		return amount;
	}
	/**
	 * @param amount The amount to set.
	 */
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	/**
	 * @return Returns the billAddress.
	 */
	public CustomerProfile getBillAddress() {
		return billAddress;
	}
	/**
	 * @param billAddress The billAddress to set.
	 */
	public void setBillAddress(CustomerProfile billAddress) {
		this.billAddress = billAddress;
	}
	/**
	 * @return Returns the billAddressName.
	 */
	public String getBillAddressName() {
		return billAddressName;
	}
	/**
	 * @param billAddressName The billAddressName to set.
	 */
	public void setBillAddressName(String billAddressName) {
		this.billAddressName = billAddressName;
	}
	/**
	 * @return Returns the billCode.
	 */
	public String getBillCode() {
		return billCode;
	}
	/**
	 * @param billCode The billCode to set.
	 */
	public void setBillCode(String billCode) {
		this.billCode = billCode;
	}
	/**
	 * @return Returns the billDate.
	 */
	public Date getBillDate() {
		return billDate;
	}
	/**
	 * @param billDate The billDate to set.
	 */
	public void setBillDate(Date billDate) {
		this.billDate = billDate;
	}
	/**
	 * @return Returns the billing.
	 */
	public ProjectBill getBilling() {
		return billing;
	}
	/**
	 * @param billing The billing to set.
	 */
	public void setBilling(ProjectBill billing) {
		this.billing = billing;
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
	 * @return Returns the project.
	 */
	public ProjectMaster getProject() {
		return project;
	}
	/**
	 * @param project The project to set.
	 */
	public void setProject(ProjectMaster project) {
		this.project = project;
	}
	/**
	 * @return Returns the projectName.
	 */
	public String getProjectName() {
		return projectName;
	}
	/**
	 * @param projectName The projectName to set.
	 */
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	
	public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectBill) ) return false;
        ProjectBill castOther = (ProjectBill) other;
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

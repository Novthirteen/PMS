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

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.project.ProjectEvent;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CAF {
	private Long id;
	private UserLogin staff;
	private String staffName;
	private ProjectMaster project;
	private String projectName;
	private Date cafDate;
	private Double workingHours;
	private ServiceType serviceType;
	private String serviceTypeName;
	private ProjectBill billing;
	private String billCode;
	private Double rate;
	private ProjectEvent projectEvent;
	private String projectEventName;
	private String status;
	private UserLogin createUser;
	
	/**
	 * @param id
	 * @param staff
	 * @param staffName
	 * @param project
	 * @param projectName
	 * @param cafDate
	 * @param workingHours
	 * @param serviceType
	 * @param serviceTypeName
	 * @param billing
	 * @param billCode
	 * @param rate
	 * @param projectEvent
	 * @param projectEventName
	 * @param status
	 * @param createUser
	 */
	public CAF(Long id, UserLogin staff, String staffName,
			ProjectMaster project, String projectName, Date cafDate,
			Double workingHours, ServiceType serviceType,
			String serviceTypeName, ProjectBill billing, String billCode,
			Double rate, ProjectEvent projectEvent, String projectEventName,
			String status, UserLogin createUser) {
		super();
		this.id = id;
		this.staff = staff;
		this.staffName = staffName;
		this.project = project;
		this.projectName = projectName;
		this.cafDate = cafDate;
		this.workingHours = workingHours;
		this.serviceType = serviceType;
		this.serviceTypeName = serviceTypeName;
		this.billing = billing;
		this.billCode = billCode;
		this.rate = rate;
		this.projectEvent = projectEvent;
		this.projectEventName = projectEventName;
		this.status = status;
		this.createUser = createUser;
	}
	/**
	 * @param id
	 */
	public CAF(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public CAF() {
		super();
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
	 * @return Returns the cafDate.
	 */
	public Date getCafDate() {
		return cafDate;
	}
	/**
	 * @param cafDate The cafDate to set.
	 */
	public void setCafDate(Date cafDate) {
		this.cafDate = cafDate;
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
	 * @return Returns the projectEvent.
	 */
	public ProjectEvent getProjectEvent() {
		return projectEvent;
	}
	/**
	 * @param projectEvent The projectEvent to set.
	 */
	public void setProjectEvent(ProjectEvent projectEvent) {
		this.projectEvent = projectEvent;
	}
	/**
	 * @return Returns the projectEventName.
	 */
	public String getProjectEventName() {
		return projectEventName;
	}
	/**
	 * @param projectEventName The projectEventName to set.
	 */
	public void setProjectEventName(String projectEventName) {
		this.projectEventName = projectEventName;
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
	/**
	 * @return Returns the rate.
	 */
	public Double getRate() {
		return rate;
	}
	/**
	 * @param rate The rate to set.
	 */
	public void setRate(Double rate) {
		this.rate = rate;
	}
	/**
	 * @return Returns the serviceType.
	 */
	public ServiceType getServiceType() {
		return serviceType;
	}
	/**
	 * @param serviceType The serviceType to set.
	 */
	public void setServiceType(ServiceType serviceType) {
		this.serviceType = serviceType;
	}
	/**
	 * @return Returns the serviceTypeName.
	 */
	public String getServiceTypeName() {
		return serviceTypeName;
	}
	/**
	 * @param serviceTypeName The serviceTypeName to set.
	 */
	public void setServiceTypeName(String serviceTypeName) {
		this.serviceTypeName = serviceTypeName;
	}
	/**
	 * @return Returns the staff.
	 */
	public UserLogin getStaff() {
		return staff;
	}
	/**
	 * @param staff The staff to set.
	 */
	public void setStaff(UserLogin staff) {
		this.staff = staff;
	}
	/**
	 * @return Returns the staffName.
	 */
	public String getStaffName() {
		return staffName;
	}
	/**
	 * @param staffName The staffName to set.
	 */
	public void setStaffName(String staffName) {
		this.staffName = staffName;
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
	 * @return Returns the workingHours.
	 */
	public Double getWorkingHours() {
		return workingHours;
	}
	/**
	 * @param workingHours The workingHours to set.
	 */
	public void setWorkingHours(Double workingHours) {
		this.workingHours = workingHours;
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

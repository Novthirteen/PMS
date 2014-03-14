package com.aof.component.prm.project;

import java.io.Serializable;
import java.util.Collection;
import java.util.Set;

import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.domain.party.*;
import com.aof.component.prm.contract.BaseContract;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */

public class ProjectMaster implements Serializable {

    /** identifier field */
    private String projId;

    /** nullable persistent field */
    private String projName;

    /** nullable persistent field */
    private com.aof.component.crm.customer.CustomerProfile customer;

    /** nullable persistent field */
    private Party department;

    /** nullable persistent field */
    private String projStatus;

    /** nullable persistent field */
    private UserLogin ProjectManager;

    /** nullable persistent field */
    private ProjectType projectType;
	
	/** nullable persistent field */
	private String PublicFlag;
	private String CAFFlag;
	private ProjectMaster ParentProject;
	private String ProjectLink;
	private String VAT;
	private String category;
	private String contractGroup;
	/** nullable persistent field */
	private String ContractNo;
	
	/** nullable persistent field */
	private String ContractType;

	/** nullable persistent field */
	private Double totalServiceValue;
	private Double totalLicsValue;
		
	/** nullable persistent field */
	private Double PSCBudget;
	private Double EXPBudget;
	private Double procBudget;
	
	/** nullable persistent field */
	private java.util.Date startDate;
		
	/** nullable persistent field */
	private java.util.Date endDate;
	private java.util.Date closeDate;
	
	private String expenseNote;
	
	private String contact;
	private String contactTele;
	private String custPM;
	private String custPMTele;
		
	private String mailFlag;
	
	private String renewFlag;
	
	private ProjectCategory projectCategory;

	private Set memberGroups;
	 
	private Set CTC;
	 
	private Set PTC;
	
	private Set ProjAssign;

	private Set ServiceTypes;
	
	private Set expenseTypes;
	
	private Set arTrackingList;

	private com.aof.component.crm.customer.CustomerProfile BillTo;
	private VendorProfile Vendor;
	private Float PaidAllowance;
	
	private UserLogin projAssistant;
	private BaseContract contract;
	
	private String vendorId;
	private String vendorName;
	private String comments;
	private String duration;
	private String CYTransport;

	
    public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		this.duration = duration;
	}

	/** full constructor */
    public ProjectMaster(String projName, 
    		com.aof.component.crm.customer.CustomerProfile customer, 
			Party department, String projStatus, 
			UserLogin ProjectManager, 
			ProjectType projectType,
			String PublicFlag,String ContractNo,
			Double totalServiceValue,Double PSCBudget,Double procBudget, 
			String contact, String contactTele, String custPM, String custPMTele, String mailFlag ) {
        this.projName = projName;
        this.customer = customer;
        this.department = department;
        this.projStatus = projStatus;
        this.ProjectManager = ProjectManager;
        this.projectType = projectType;
		this.PublicFlag = PublicFlag;
		this.ContractNo = ContractNo;
		this.totalServiceValue = totalServiceValue;
		this.PSCBudget =PSCBudget;
		this.procBudget =procBudget;
		this.contact =contact;
		this.contactTele =contactTele;
		this.custPM =custPM;
		this.custPMTele =custPMTele;
		this.mailFlag = mailFlag;
    }

    /** default constructor */
    public ProjectMaster() {
    }

    public String getProjId() {
        return this.projId;
    }

	public void setProjId(String projId) {
		this.projId = projId;
	}

    public String getProjName() {
        return this.projName;
    }

	public void setProjName(String projName) {
		this.projName = projName;
	}

    public com.aof.component.crm.customer.CustomerProfile getCustomer() {
        return this.customer;
    }
    

	public void setCustomer(com.aof.component.crm.customer.CustomerProfile customer) {
		this.customer = customer;
	}

    public Party getDepartment() {
        return this.department;
    }

	public void setDepartment(Party department) {
		this.department = department;
	}

    public String getProjStatus() {
        return this.projStatus;
    }

	public void setProjStatus(String projStatus) {
		this.projStatus = projStatus;
	}

    public UserLogin getProjectManager() {
        return this.ProjectManager;
    }

	public void setProjectManager(UserLogin ProjectManager) {
		this.ProjectManager = ProjectManager;
	}

    public ProjectType getProjectType() {
        return this.projectType;
    }

	public void setProjectType(ProjectType projectType) {
		this.projectType = projectType;
	}

	public ProjectCategory getProjectCategory() {
        return this.projectCategory;
    }

	public void setProjectCategory(ProjectCategory projectCategory) {
		this.projectCategory = projectCategory;
	}

	public String getPublicFlag() {
		return this.PublicFlag;
	}

	public void setPublicFlag(String PublicFlag) {
		this.PublicFlag = PublicFlag;
	}

	public String getContractType() {
		return this.ContractType;
	}

	public void setContractType(String ContractType) {
		this.ContractType = ContractType;
	}

	public String getContractNo() {
		return this.ContractNo;
	}

	public void setContractNo(String ContractNo) {
		this.ContractNo = ContractNo;
	}
	
	public Double gettotalServiceValue() {
		return this.totalServiceValue;
	}

	public void settotalServiceValue(Double totalServiceValue) {
		this.totalServiceValue = totalServiceValue;
	}

	public String toString() {
        return new ToStringBuilder(this)
            .append("projId", getProjId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectMaster) ) return false;
        ProjectMaster castOther = (ProjectMaster) other;
        return new EqualsBuilder()
            .append(this.getProjId(), castOther.getProjId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getProjId())
            .toHashCode();
    }

	/**
	 * @return
	 */
	public Set getMemberGroups() {
		return this.memberGroups;
	}

	/**
	 * @param set
	 */
	public void setMemberGroups(Set set) {
		this.memberGroups = set;
	}

	/**
	 * @return
	 */
	public java.util.Date getEndDate() {
		return this.endDate;
	}

	/**
	 * @return
	 */
	public java.util.Date getStartDate() {
		return this.startDate;
	}

	/**
	 * @param date
	 */
	public void setEndDate(java.util.Date date) {
		this.endDate = date;
	}

	/**
	 * @param date
	 */
	public void setStartDate(java.util.Date date) {
		this.startDate = date;
	}

	/**
	 * @return
	 */
	public Set getCTC() {
		return this.CTC;
	}

	/**
	 * @return
	 */
	public Set getPTC() {
		return this.PTC;
	}

	/**
	 * @param set
	 */
	public void setCTC(Set set) {
		this.CTC = set;
	}

	/**
	 * @param set
	 */
	public void setPTC(Set set) {
		this.PTC = set;
	}

	/**
	 * @return
	 */
	public Set getServiceTypes() {
		return this.ServiceTypes;
	}

	/**
	 * @param set
	 */
	public void setServiceTypes(Set set) {
		this.ServiceTypes = set;
	}

	/**
	 * @return
	 */
	public Set getProjAssign() {
		return this.ProjAssign;
	}

	/**
	 * @param set
	 */
	public void setProjAssign(Set set) {
		this.ProjAssign = set;
	}

	/**
	 * @return
	 */
	public Double getPSCBudget() {
		return PSCBudget;
	}
	public void setPSCBudget(Double float1) {
		this.PSCBudget = float1;
	}
	
	/**
	 * @return
	 */
	public Double getProcBudget() {
		return this.procBudget;
	}
	public void setProcBudget(Double float1) {
		this.procBudget = float1;
	}
	
	public Double gettotalLicsValue() {
		return this.totalLicsValue;
	}
	public void settotalLicsValue(Double float1) {
		this.totalLicsValue = float1;
	}
	
	public Double getEXPBudget() {
		return this.EXPBudget;
	}
	public void setEXPBudget(Double float1) {
		this.EXPBudget = float1;
	}
	
	public String getCAFFlag() {
		return this.CAFFlag;
	}
	public void setCAFFlag(String CAFFlag) {
		this.CAFFlag = CAFFlag;
	}
	
	public ProjectMaster getParentProject() {
		return this.ParentProject;
	}
	public void setParentProject(ProjectMaster ParentProject) {
		this.ParentProject = ParentProject;
	}
	
	public String getProjectLink() {
		return this.ProjectLink;
	}
	public void setProjectLink(String ProjectLink) {
		this.ProjectLink = ProjectLink;
	}
	
	public com.aof.component.crm.customer.CustomerProfile getBillTo() {
		return this.BillTo;
	}
	public void setBillTo(com.aof.component.crm.customer.CustomerProfile BillTo) {
		this.BillTo = BillTo;
	}
	
	public VendorProfile getVendor() {
		return this.Vendor;
	}
	public void setVendor(VendorProfile Vendor) {
		this.Vendor = Vendor;
	}
	
	public Float getPaidAllowance() {
		return this.PaidAllowance;
	}
	public void setPaidAllowance(Float PaidAllowance) {
		this.PaidAllowance = PaidAllowance;
	}
	/**
	 * @return Returns the contract.
	 */
	public BaseContract getContract() {
		return contract;
	}
	/**
	 * @param contract The contract to set.
	 */
	public void setContract(BaseContract contract) {
		this.contract = contract;
	}
	/**
	 * @return Returns the projAssistant.
	 */
	public UserLogin getProjAssistant() {
		return projAssistant;
	}
	/**
	 * @param projAssistant The projAssistant to set.
	 */
	public void setProjAssistant(UserLogin projAssistant) {
		this.projAssistant = projAssistant;
	}
	/**
	 * @return Returns the totalLicsValue.
	 */
	public Double getTotalLicsValue() {
		return totalLicsValue;
	}
	/**
	 * @param totalLicsValue The totalLicsValue to set.
	 */
	public void setTotalLicsValue(Double totalLicsValue) {
		this.totalLicsValue = totalLicsValue;
	}
	/**
	 * @return Returns the totalServiceValue.
	 */
	public Double getTotalServiceValue() {
		return totalServiceValue;
	}
	/**
	 * @param totalServiceValue The totalServiceValue to set.
	 */
	public void setTotalServiceValue(Double totalServiceValue) {
		this.totalServiceValue = totalServiceValue;
	}
	
	public Set getExpenseTypes() {
		if(this.expenseTypes == null)
			this.expenseTypes = new java.util.HashSet();
		return this.expenseTypes;
	}

	public void setExpenseTypes(Set expenseTypes) {
		this.expenseTypes = expenseTypes;
	}

	public String getExpenseNote() {
		return expenseNote;
	}

	public void setExpenseNote(String expenseNote) {
		this.expenseNote = expenseNote;
	}

	/**
	 * @return Returns the arTrackingList.
	 */
	public Set getArTrackingList() {
		if(this.arTrackingList == null)
			this.arTrackingList = new java.util.HashSet();
		return arTrackingList;
	}

	/**
	 * @param arTrackingList The arTrackingList to set.
	 */
	public void setArTrackingList(Set arTrackingList) {
		this.arTrackingList = arTrackingList;
	}
	
	/**
	 * @return Returns the contact.
	 */
	public String getContact() {
		return contact;
	}
	/**
	 * @param contact The contact to set.
	 */
	public void setContact(String contact) {
		this.contact = contact;
	}
	/**
	 * @return Returns the contactTele.
	 */
	public String getContactTele() {
		return contactTele;
	}
	/**
	 * @param contactTele The contactTele to set.
	 */
	public void setContactTele(String contactTele) {
		this.contactTele = contactTele;
	}
	/**
	 * @return Returns the custPM.
	 */
	public String getCustPM() {
		return custPM;
	}
	/**
	 * @param custPM The custPM to set.
	 */
	public void setCustPM(String custPM) {
		this.custPM = custPM;
	}
	/**
	 * @return Returns the custPMTele.
	 */
	public String getCustPMTele() {
		return custPMTele;
	}
	/**
	 * @param custPMTele The custPMTele to set.
	 */
	public void setCustPMTele(String custPMTele) {
		this.custPMTele = custPMTele;
	}
	public void addARTracking(ProjectARTracking part){
		this.getArTrackingList().add(part);
	}
	
	public void removeARTracking(ProjectARTracking part){
		this.getArTrackingList().remove(part);
	}

	/**
	 * @return Returns the mailFlag.
	 */
	public String getMailFlag() {
		return mailFlag;
	}
	/**
	 * @param mailFlag The mailFlag to set.
	 */
	public void setMailFlag(String mailFlag) {
		this.mailFlag = mailFlag;
	}
	public String getRenewFlag() {
		return renewFlag;
	}
	public void setRenewFlag(String renewFlag) {
		this.renewFlag = renewFlag;
	}

	public String getVAT() {
		return VAT;
	}

	public void setVAT(String vat) {
		VAT = vat;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}
	/**
	 * @return Returns the vendorId.
	 */
	public String getVendorId() {
		return Vendor.getPartyId();
	}
	/**
	 * @return Returns the vendorName.
	 */
	public String getVendorName() {
		return Vendor.getDescription();
	}

	public java.util.Date getCloseDate() {
		return closeDate;
	}

	public void setCloseDate(java.util.Date closeDate) {
		this.closeDate = closeDate;
	}
	
	/**
	 * @return Returns the contractGroup.
	 */
	public String getContractGroup() {
		return contractGroup;
	}
	/**
	 * @param contractGroup The contractGroup to set.
	 */
	public void setContractGroup(String contractGroup) {
		this.contractGroup = contractGroup;
	}
	

	/**
	 * @return Returns the cYTransport.
	 */
	public String getCYTransport() {
		return CYTransport;
	}
	/**
	 * @param transport The cYTransport to set.
	 */
	public void setCYTransport(String transport) {
		CYTransport = transport;
	}
}
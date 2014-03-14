package com.aof.component.prm.expense;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.HashSet;
import java.util.Set;

import com.aof.util.UtilFormat;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.payment.ProjectPayment;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;

/** @author Hibernate CodeGenerator */
public class ProjectCostMaster implements Serializable {

    /** identifier field */
    private Integer costcode;

    /** nullable persistent field */
    private String refno;

    /** nullable persistent field */
    private String costdescription;

    /** nullable persistent field */
    private ProjectCostType projectCostType;

    /** nullable persistent field */
    private CurrencyType currency;

    /** nullable persistent field */
    private float totalvalue;

    /** nullable persistent field */
    private float exchangerate;

    /** nullable persistent field */
    private java.util.Date costdate;
	private java.util.Date approvalDate;

    /** nullable persistent field */
    private String createuser;

    /** nullable persistent field */
    private java.util.Date createdate;

    /** nullable persistent field */
    private String modifyuser;
    private java.util.Date PAConfirm;

    /** nullable persistent field */
    private java.util.Date modifydate;

    private ProjectMaster projectMaster;

    /** nullable persistent field */
    private UserLogin userLogin;
    
	/** nullable persistent field */
    private String ClaimType;
	private String formCode;
	private String payFor;
	private VendorProfile vendor;
	private ProjectPayment payment;
	private String payType;
	private String payStatus;
    private Set Details;
    
    private String currencyString;
    private String createString;
    private String totalvalueString;
    /** nullable persistent field */
    private java.util.Date exportDate;
    private java.util.Date payDate;
    private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

    /** full constructor */
    public ProjectCostMaster(java.lang.String refno, ProjectMaster projectMaster, UserLogin userLogin, java.lang.String costdescription, ProjectCostType projectCostType, CurrencyType currency, float totalvalue, float exchangerate, java.util.Date costdate, java.lang.String createuser, java.util.Date createdate, 
    		java.lang.String modifyuser, java.util.Date PAConfirm, java.util.Date modifydate , java.util.Date exportDate, java.util.Date payDate) {
        this.refno = refno;
        this.costdescription = costdescription;
        this.projectCostType = projectCostType;
        this.currency = currency;
        this.totalvalue = totalvalue;
        this.exchangerate = exchangerate;
        this.costdate = costdate;
        this.createuser = createuser;
        this.createdate = createdate;
        this.modifyuser = modifyuser;
        this.modifydate = modifydate;
        this.projectMaster = projectMaster;
        this.userLogin = userLogin;
        this.PAConfirm = PAConfirm;
        this.exportDate = exportDate;
        this.payDate = payDate;
    }

    /** default constructor */
    public ProjectCostMaster() {
    }

    public Integer getCostcode() {
        return this.costcode;
    }

	public void setCostcode(Integer costcode) {
		this.costcode = costcode;
	}

    public java.lang.String getRefno() {
        return this.refno;
    }

	public void setRefno(java.lang.String refno) {
		this.refno = refno;
	}

    public java.lang.String getCostdescription() {
        return this.costdescription;
    }

	public void setCostdescription(java.lang.String costdescription) {
		this.costdescription = costdescription;
	}

    public float getTotalvalue() {
        return this.totalvalue;
    }

	/**
	 * @return Returns the pAConfirm.
	 */
	public java.util.Date getPAConfirm() {
		return PAConfirm;
	}
	/**
	 * @param confirm The pAConfirm to set.
	 */
	public void setPAConfirm(java.util.Date confirm) {
		PAConfirm = confirm;
	}
	public void setTotalvalue(float totalvalue) {
		this.totalvalue = totalvalue;
	}

    public float getExchangerate() {
        return this.exchangerate;
    }

	public void setExchangerate(float exchangerate) {
		this.exchangerate = exchangerate;
	}

    public java.util.Date getCostdate() {
        return this.costdate;
    }

	public void setCostdate(java.util.Date costdate) {
		this.costdate = costdate;
	}
	
	public java.util.Date getApprovalDate() {
		return this.approvalDate;
	}

	public void setApprovalDate(java.util.Date ApprovalDate) {
		this.approvalDate = ApprovalDate;
	}

    public java.lang.String getCreateuser() {
        return this.createuser;
    }

	public void setCreateuser(java.lang.String createuser) {
		this.createuser = createuser;
	}

    public java.util.Date getCreatedate() {
        return this.createdate;
    }

	public void setCreatedate(java.util.Date createdate) {
		this.createdate = createdate;
	}

    public java.lang.String getModifyuser() {
        return this.modifyuser;
    }

	public void setModifyuser(java.lang.String modifyuser) {
		this.modifyuser = modifyuser;
	}

    public java.util.Date getModifydate() {
        return this.modifydate;
    }

	public void setModifydate(java.util.Date modifydate) {
		this.modifydate = modifydate;
	}

	/**
	 * @return Returns the exportDate.
	 */
	public java.util.Date getExportDate() {
		return exportDate;
	}
	/**
	 * @param exportDate The exportDate to set.
	 */
	public void setExportDate(java.util.Date exportDate) {
		this.exportDate = exportDate;
	}
    public String toString() {
        return new ToStringBuilder(this)
            .append("costcode", getCostcode())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectCostMaster) ) return false;
        ProjectCostMaster castOther = (ProjectCostMaster) other;
        return new EqualsBuilder()
            .append(this.getCostcode(), castOther.getCostcode())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getCostcode())
            .toHashCode();
    }


	/**
	 * @return
	 */
	public Set getDetails() {
		return Details;
	}

	/**
	 * @param set
	 */
	public void setDetails(Set set) {
		Details = set;
	}
	
	public void addDetails(ProjectCostDetail pcd) {
		if (Details == null) {
			Details = new HashSet();
		}
		
		Details.add(pcd);
	}

	/**
	 * @param currency
	 */
	public void setCurrency(CurrencyType currency) {
		this.currency = currency;
	}

	/**
	 * @return
	 */
	public CurrencyType getCurrency() {
		return currency;
	}

	public java.lang.String getClaimType() {
        return this.ClaimType;
    }
	public void setClaimType(java.lang.String ClaimType) {
		this.ClaimType = ClaimType;
	}
	
	public java.lang.String getFormCode() {
		return this.formCode;
	}
	public void setFormCode(java.lang.String FormCode) {
		this.formCode = FormCode;
	}

	public java.lang.String getPayFor() {
		return this.payFor;
	}
	public void setPayFor(java.lang.String PayFor) {
		this.payFor = PayFor;
	}
	/**
	 * @return
	 */
	public ProjectCostType getProjectCostType() {
		return projectCostType;
	}

	/**
	 * @param type
	 */
	public void setProjectCostType(ProjectCostType type) {
		projectCostType = type;
	}

	/**
	 * @return Returns the payment.
	 */
	public ProjectPayment getPayment() {
		return payment;
	}
	/**
	 * @param payment The payment to set.
	 */
	public void setPayment(ProjectPayment payment) {
		this.payment = payment;
	}
	/**
	 * @return Returns the vendor.
	 */
	public VendorProfile getVendor() {
		return vendor;
	}
	/**
	 * @param vendor The vendor to set.
	 */
	public void setVendor(VendorProfile vendor) {
		this.vendor = vendor;
	}
	
	/**
	 * @return Returns the payStatus.
	 */
	public String getPayStatus() {
		return payStatus;
	}
	/**
	 * @param payStatus The payStatus to set.
	 */
	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}
	/**
	 * @return Returns the payType.
	 */
	public String getPayType() {
		return payType;
	}
	/**
	 * @param payType The payType to set.
	 */
	public void setPayType(String payType) {
		this.payType = payType;
	}
	/**
	 * @return Returns the projectMaster.
	 */
	public ProjectMaster getProjectMaster() {
		return projectMaster;
	}
	/**
	 * @param projectMaster The projectMaster to set.
	 */
	public void setProjectMaster(ProjectMaster projectMaster) {
		this.projectMaster = projectMaster;
	}
	/**
	 * @return Returns the userLogin.
	 */
	public UserLogin getUserLogin() {
		return userLogin;
	}
	/**
	 * @param userLogin The userLogin to set.
	 */
	public void setUserLogin(UserLogin userLogin) {
		this.userLogin = userLogin;
	}
	
	public String getCreateDateString() {
		return formatter.format(createdate);
	}
		
	public String getCurrencyString() {
		return currency.getCurrName();
	}

	public String getTotalvalueString() {
		return UtilFormat.format(new Double(totalvalue));
	}
	
	
	/**
	 * @return Returns the payDate.
	 */
	public java.util.Date getPayDate() {
		return payDate;
	}
	/**
	 * @param payDate The payDate to set.
	 */
	public void setPayDate(java.util.Date payDate) {
		this.payDate = payDate;
	}
}

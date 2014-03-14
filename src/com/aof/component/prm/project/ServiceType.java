package com.aof.component.prm.project;

import java.io.Serializable;

import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.payment.ProjectPayment;

/** @author Hibernate CodeGenerator */
public class ServiceType implements Serializable {

    /** persistent field */
    private Long Id;

    /** persistent field */
    private ProjectMaster Project;

	/** nullable persistent field */
    private String Description;

	/** persistent field */
    private Double Rate;
	private Double SubContractRate;
	private Float EstimateManDays;

	private java.util.Date CustAcceptanceDate;
	private java.util.Date VendAcceptanceDate;
	private java.util.Date EstimateAcceptanceDate;
	
	private ProjectBill ProjBill;
	private ProjectPayment ProjPayment;
    /** full constructor */
    public ServiceType(Long Id, java.lang.String Description) {
        this.Id = Id;
        this.Description = Description;
    }

    /** default constructor */
    public ServiceType() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public java.lang.String getDescription() {
        return this.Description;
    }

	public void setDescription(java.lang.String Description) {
		this.Description = Description;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .toString();
    }

	/**
	 * @return
	 */
	public ProjectMaster getProject() {
		return this.Project;
	}

	/**
	 * @param master
	 */
	public void setProject(ProjectMaster master) {
		this.Project = master;
	}

	public Double getRate() {
        return this.Rate;
    }

	public void setRate(Double Rate) {
		this.Rate = Rate;
	}

	public Double getSubContractRate() {
        return this.SubContractRate;
    }

	public void setSubContractRate(Double SubContractRate) {
		this.SubContractRate = SubContractRate;
	}

	public Float getEstimateManDays() {
        return this.EstimateManDays;
    }

	public void setEstimateManDays(Float EstimateManDays) {
		this.EstimateManDays = EstimateManDays;
	}

	public java.util.Date getCustAcceptanceDate() {
		return this.CustAcceptanceDate;
	}
	public void setCustAcceptanceDate(java.util.Date date) {
		this.CustAcceptanceDate = date;
	}

	public java.util.Date getVendAcceptanceDate() {
		return this.VendAcceptanceDate;
	}
	public void setVendAcceptanceDate(java.util.Date date) {
		this.VendAcceptanceDate = date;
	}
	
	public java.util.Date getEstimateAcceptanceDate() {
		return this.EstimateAcceptanceDate;
	}
	public void setEstimateAcceptanceDate(java.util.Date date) {
		this.EstimateAcceptanceDate = date;
	}
	
	public ProjectBill getProjBill() {
        return this.ProjBill;
    }
	public void setProjBill(ProjectBill ProjBill) {
		this.ProjBill = ProjBill;
	}

	public ProjectPayment getProjPayment() {
        return this.ProjPayment;
    }
	public void setProjPayment(ProjectPayment ProjPayment) {
		this.ProjPayment = ProjPayment;
	}

}

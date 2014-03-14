package com.aof.component.prm.TimeSheet;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.project.ProjectEvent;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;

/** @author Hibernate CodeGenerator */
public class TimeSheetDetail implements Serializable {

    /** identifier field */
    private Integer  tsId;

    /** nullable persistent field */
    private ProjectMaster Project;

    /** nullable persistent field */
    private ProjectEvent projectEvent;

    /** nullable persistent field */
    private TimeSheetMaster TimeSheetMaster;

    /** nullable persistent field */
    private Float TsHoursUser;
    
	/** nullable persistent field */
	private Float TsHoursConfirm;

    /** nullable persistent field */
    private String Status;
	private String Confirm;

    /** nullable persistent field */
    private String CAFStatusUser;

    /** nullable persistent field */
    private String CAFStatusConfirm;

    /** nullable persistent field */
    private java.util.Date TsDate;

	private Double TsRateUser;
	private ServiceType TSServiceType;

	private Float TSAllowance;
	private java.util.Date TsConfirmDate;
	private ProjectBill TSBill;

	private String CAFPrintDate;

	/** full constructor */
    public TimeSheetDetail(ProjectMaster Project, ProjectEvent projectEvent, TimeSheetMaster TimeSheetMaster,Float TsHoursUser,Float TsHoursConfirm, java.lang.String Status, java.lang.String CAFStatusUser, java.lang.String CAFStatusConfirm, java.util.Date TsDate) {
        this.Project = Project;
        this.projectEvent = projectEvent;
        this.TimeSheetMaster = TimeSheetMaster;
        this.TsHoursUser = TsHoursUser;
		this.TsHoursConfirm = TsHoursConfirm;
        this.Status = Status;
        this.CAFStatusUser = CAFStatusUser;
        this.CAFStatusConfirm = CAFStatusConfirm;
        this.TsDate = TsDate;
    }

    /** default constructor */
    public TimeSheetDetail() {
    }

    public Integer  getTsId() {
        return this.tsId;
    }

	public void setTsId(Integer  tsId) {
		this.tsId = tsId;
	}

    public ProjectMaster getProject() {
        return this.Project;
    }

	public void setProject(ProjectMaster Project) {
		this.Project = Project;
	}

    public ProjectEvent getProjectEvent() {
        return this.projectEvent;
    }

	public void setProjectEvent(ProjectEvent projectEvent) {
		this.projectEvent = projectEvent;
	}

    public TimeSheetMaster getTimeSheetMaster() {
        return this.TimeSheetMaster;
    }

	public void setTimeSheetMaster(TimeSheetMaster TimeSheetMaster) {
		this.TimeSheetMaster = TimeSheetMaster;
	}

    public Float getTsHoursUser() {
        return this.TsHoursUser;
    }

	public void setTsHoursUser(Float TsHoursUser) {
		this.TsHoursUser = TsHoursUser;
	}
	
	public Float getTsHoursConfirm() {
		return this.TsHoursConfirm;
	}

	public void setTsHoursConfirm(Float TsHoursConfirm) {
		this.TsHoursConfirm = TsHoursConfirm;
	}
	
    public java.lang.String getStatus() {
        return this.Status;
    }

	public void setStatus(java.lang.String Status) {
		this.Status = Status;
	}
	
	public java.lang.String getConfirm() {
		return this.Confirm;
	}

	public void setConfirm(java.lang.String Confirm) {
		this.Confirm = Confirm;
	}


    public java.lang.String getCAFStatusUser() {
        return this.CAFStatusUser;
    }

	public void setCAFStatusUser(java.lang.String CAFStatusUser) {
		this.CAFStatusUser = CAFStatusUser;
	}

    public java.lang.String getCAFStatusConfirm() {
        return this.CAFStatusConfirm;
    }

	public void setCAFStatusConfirm(java.lang.String CAFStatusConfirm) {
		this.CAFStatusConfirm = CAFStatusConfirm;
	}

    public java.util.Date getTsDate() {
        return this.TsDate;
    }

	public void setTsDate(java.util.Date TsDate) {
		this.TsDate = TsDate;
	}

	public Double getTsRateUser() {
		return this.TsRateUser;
	}

	public void setTsRateUser(Double TsRateUser) {
		this.TsRateUser = TsRateUser;
	}
	
	public ServiceType getTSServiceType() {
		return this.TSServiceType;
	}

	public void setTSServiceType(ServiceType TSServiceType) {
		this.TSServiceType = TSServiceType;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("tsId", getTsId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof TimeSheetDetail) ) return false;
        TimeSheetDetail castOther = (TimeSheetDetail) other;
        return new EqualsBuilder()
            .append(this.getTsId(), castOther.getTsId())
            .isEquals();
    }
	
    public java.util.Date getTsConfirmDate() {
        return this.TsConfirmDate;
    }
	public void setTsConfirmDate(java.util.Date TsConfirmDate) {
		this.TsConfirmDate = TsConfirmDate;
	}

	public Float getTSAllowance() {
		return this.TSAllowance;
	}
	public void setTSAllowance(Float TSAllowance) {
		this.TSAllowance = TSAllowance;
	}

	public ProjectBill getTSBill() {
		return this.TSBill;
	}
	public void setTSBill(ProjectBill TSBill) {
		this.TSBill = TSBill;
	}

	public String getCAFPrintDate() {
		return CAFPrintDate;
	}

	public void setCAFPrintDate(String printDate) {
		CAFPrintDate = printDate;
	}

}

package com.aof.component.prm.TimeSheet;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import com.aof.component.prm.project.*;
import com.aof.component.prm.TimeSheet.TimeSheetForecastMaster;

/** @author Hibernate CodeGenerator */
public class TimeSheetForecastDetail implements Serializable {

    /** identifier field */
    private Integer  tsId;

    /** nullable persistent field */
    private ProjectMaster Project;

    /** nullable persistent field */
    private ProjectEvent projectEvent;

    /** nullable persistent field */
    private TimeSheetForecastMaster TimeSheetForecastMaster;

    /** nullable persistent field */
    private Float TsHoursUser;
    
	/** nullable persistent field */
	private Float TsHoursConfirm;

    /** nullable persistent field */
    private String Status;

    /** nullable persistent field */
    private String CAFStatusUser;

    /** nullable persistent field */
    private String CAFStatusConfirm;

    /** nullable persistent field */
    private java.util.Date TsDate;

	private ServiceType TSServiceType;
	
	private String description;

    /** full constructor */
    public TimeSheetForecastDetail(ProjectMaster Project, 
                                   ProjectEvent projectEvent, 
                                   TimeSheetForecastMaster TimeSheetForecastMaster,
                                   Float TsHoursUser,
                                   Float TsHoursConfirm, 
                                   java.lang.String Status, 
                                   java.lang.String CAFStatusUser, 
                                   java.lang.String CAFStatusConfirm, 
                                   java.util.Date TsDate,
                                   String description) {
        this.Project = Project;
        this.projectEvent = projectEvent;
        this.TimeSheetForecastMaster = TimeSheetForecastMaster;
        this.TsHoursUser = TsHoursUser;
		this.TsHoursConfirm = TsHoursConfirm;
        this.Status = Status;
        this.CAFStatusUser = CAFStatusUser;
        this.CAFStatusConfirm = CAFStatusConfirm;
        this.TsDate = TsDate;
        this.description = description;
    }

    /** default constructor */
    public TimeSheetForecastDetail() {
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

    public TimeSheetForecastMaster getTimeSheetForecastMaster() {
        return this.TimeSheetForecastMaster;
    }

	public void setTimeSheetForecastMaster(TimeSheetForecastMaster TimeSheetForecastMaster) {
		this.TimeSheetForecastMaster = TimeSheetForecastMaster;
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
        if ( !(other instanceof TimeSheetForecastDetail) ) return false;
        TimeSheetForecastDetail castOther = (TimeSheetForecastDetail) other;
        return new EqualsBuilder()
            .append(this.getTsId(), castOther.getTsId())
            .isEquals();
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
}

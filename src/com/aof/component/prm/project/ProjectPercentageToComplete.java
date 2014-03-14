package com.aof.component.prm.project;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.prm.project.*;

/** @author Hibernate CodeGenerator */
public class ProjectPercentageToComplete implements Serializable {

    /** identifier field */
    private Long Id;

    /** persistent field */
    private ProjectMaster Project;

    /** persistent field */
    private FMonth FiscalMonth;

    /** persistent field */
    private String Type;

    /** persistent field */
    private double Amount;

    /** full constructor */
    public ProjectPercentageToComplete(ProjectMaster Project, FMonth FiscalMonth, java.lang.String Type, double Amount) {
        this.Project = Project;
        this.FiscalMonth = FiscalMonth;
        this.Type = Type;
        this.Amount = Amount;
    }

    /** default constructor */
    public ProjectPercentageToComplete() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public ProjectMaster getProject() {
        return this.Project;
    }

	public void setProject(ProjectMaster Project) {
		this.Project = Project;
	}

    public FMonth getFiscalMonth() {
        return this.FiscalMonth;
    }

	public void setFiscalMonth(FMonth FiscalMonth) {
		this.FiscalMonth = FiscalMonth;
	}

    public java.lang.String getType() {
        return this.Type;
    }

	public void setType(java.lang.String Type) {
		this.Type = Type;
	}

    public double getAmount() {
        return this.Amount;
    }

	public void setAmount(double Amount) {
		this.Amount = Amount;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectPercentageToComplete) ) return false;
        ProjectPercentageToComplete castOther = (ProjectPercentageToComplete) other;
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

package com.aof.component.prm.expense;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.ProjectMaster;

/** @author Hibernate CodeGenerator */
public class ProjectCostDetail implements Serializable {

    /** identifier field */
    private int pcdid;

    /** nullable persistent field */
    private ProjectCostMaster projectCostMaster;

    /** persistent field */
    private ProjectMaster projectMaster;

    /** nullable persistent field */
    private UserLogin userLogin;

    /** nullable persistent field */
    private float percentage;
    
    /** nullable persistent field */
    private String projName;

    /** full constructor */
    public ProjectCostDetail(ProjectCostMaster projectCostMaster, ProjectMaster projectMaster, UserLogin userLogin, float percentage, String projName) {
        this.projectCostMaster = projectCostMaster;
        this.projectMaster = projectMaster;
        this.userLogin = userLogin;
        this.percentage = percentage;
        this.projName = projName;
    }

    /** default constructor */
    public ProjectCostDetail() {
    }

    public int getPcdid() {
        return this.pcdid;
    }

	public void setPcdid(int pcdid) {
		this.pcdid = pcdid;
	}

    public float getPercentage() {
        return this.percentage;
    }

	public void setPercentage(float percentage) {
		this.percentage = percentage;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("pcdid", getPcdid())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectCostDetail) ) return false;
        ProjectCostDetail castOther = (ProjectCostDetail) other;
        return new EqualsBuilder()
            .append(this.getPcdid(), castOther.getPcdid())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getPcdid())
            .toHashCode();
    }

	/**
	 * @return
	 */
	public ProjectCostMaster getProjectCostMaster() {
		return projectCostMaster;
	}

	/**
	 * @return
	 */
	public ProjectMaster getProjectMaster() {
		return projectMaster;
	}

	/**
	 * @return
	 */
	public UserLogin getUserLogin() {
		return userLogin;
	}

	/**
	 * @param master
	 */
	public void setProjectCostMaster(ProjectCostMaster master) {
		projectCostMaster = master;
	}

	/**
	 * @param master
	 */
	public void setProjectMaster(ProjectMaster master) {
		projectMaster = master;
	}

	/**
	 * @param login
	 */
	public void setUserLogin(UserLogin login) {
		userLogin = login;
	}

	/**
	 * @return Returns the projName.
	 */
	public String getProjName() {
		return projName;
	}
	/**
	 * @param projName The projName to set.
	 */
	public void setProjName(String projName) {
		this.projName = projName;
	}
}

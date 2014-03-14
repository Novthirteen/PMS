package com.aof.component.prm.project;
import com.aof.component.domain.party.*;
import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.prm.project.*;

/** @author Hibernate CodeGenerator */
public class ProjectAssignment implements Serializable {

    /** identifier field */
    private Long Id;

    /** persistent field */
    private ProjectMaster Project;
    
    /** persistent field */
    private UserLogin User;

    /** persistent field */
	private java.util.Date DateStart;

    /** persistent field */
	private java.util.Date DateEnd;

    /** persistent field */
   
    /** full constructor */
    public ProjectAssignment(UserLogin User, java.util.Date DateStart, java.util.Date DateEnd) {
        this.User = User;
        this.DateStart = DateStart;
        this.DateEnd = DateEnd;
        
    }

    /** default constructor */
    public ProjectAssignment() {
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    
    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }

	/**
	 * @return
	 */
	public java.util.Date getDateEnd() {
		return this.DateEnd;
	}

	/**
	 * @return
	 */
	public java.util.Date getDateStart() {
		return this.DateStart;
	}

	/**
	 * @return
	 */
	public UserLogin getUser() {
		return this.User;
	}

	/**
	 * @param date
	 */
	public void setDateEnd(java.util.Date date) {
		this.DateEnd = date;
	}

	/**
	 * @param date
	 */
	public void setDateStart(java.util.Date date) {
		this.DateStart = date;
	}

	/**
	 * @param login
	 */
	public void setUser(UserLogin login) {
		this.User = login;
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

}

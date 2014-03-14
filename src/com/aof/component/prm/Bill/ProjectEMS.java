package com.aof.component.prm.Bill;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectEMS implements Serializable {

    /** identifier field */
    private Long id;
    
    /** nullable persistent field */
    private String type;

    /** nullable persistent field */
    private String no;
    
    /** nullable persistent field */
    private java.util.Date emsDate;

    /** nullable persistent field */
    private String status;
    
    /** nullable persistent field */
    private String note;

    /** nullable persistent field */
    private java.util.Date createDate;

    /** nullable persistent field */
    private com.aof.component.domain.party.UserLogin createUser;
    
    /** nullable persistent field */
    private com.aof.component.domain.party.Party department;
    
    private Set invoices;

    /** full constructor */
    public ProjectEMS(Long id, 
    				  java.lang.String type, 
    		          java.lang.String no, 
    		          java.util.Date emsDate, 
					  java.lang.String status,
					  java.lang.String note,
					  java.util.Date createDate, 
					  com.aof.component.domain.party.UserLogin createUser,
					  com.aof.component.domain.party.Party department,
					  Set invoices) {
        this.id = id;
        this.type = type;
        this.no = no;
        this.emsDate = emsDate;
        this.status = status;
        this.note = note;
        this.createDate = createDate;
        this.createUser = createUser;
        this.department = department;
        this.invoices = invoices;
    }

    /** default constructor */
    public ProjectEMS() {
    }

    /** minimal constructor */
    public ProjectEMS(Long id) {
        this.id = id;
    }

    public Long getId() {
        return this.id;
    }

	public void setId(Long id) {
		this.id = id;
	}

    public java.lang.String getNo() {
        return this.no;
    }

	public void setNo(java.lang.String no) {
		this.no = no;
	}

    public java.lang.String getStatus() {
        return this.status;
    }

	public void setStatus(java.lang.String status) {
		this.status = status;
	}

    public java.util.Date getCreateDate() {
        return this.createDate;
    }

	public void setCreateDate(java.util.Date createDate) {
		this.createDate = createDate;
	}

    public com.aof.component.domain.party.UserLogin getCreateUser() {
        return this.createUser;
    }

	public void setCreateUser(com.aof.component.domain.party.UserLogin createUser) {
		this.createUser = createUser;
	}

	/**
	 * @return Returns the emsDate.
	 */
	public java.util.Date getEmsDate() {
		return emsDate;
	}
	/**
	 * @param emsDate The emsDate to set.
	 */
	public void setEmsDate(java.util.Date emsDate) {
		this.emsDate = emsDate;
	}
	/**
	 * @return Returns the note.
	 */
	public String getNote() {
		return note;
	}
	/**
	 * @param note The note to set.
	 */
	public void setNote(String note) {
		this.note = note;
	}
	/**
	 * @return Returns the type.
	 */
	public String getType() {
		return type;
	}
	/**
	 * @param type The type to set.
	 */
	public void setType(String type) {
		this.type = type;
	}
	/**
	 * @return Returns the department.
	 */
	public com.aof.component.domain.party.Party getDepartment() {
		return department;
	}
	/**
	 * @param department The department to set.
	 */
	public void setDepartment(com.aof.component.domain.party.Party department) {
		this.department = department;
	}
	/**
	 * @return Returns the invoices.
	 */
	public Set getInvoices() {
		return invoices;
	}
	/**
	 * @param invoices The invoices to set.
	 */
	public void setInvoices(Set invoices) {
		this.invoices = invoices;
	}
	public void removeInvoice(ProjectInvoice pi) {
	    if (invoices != null) {
	        invoices.remove(pi);
	    }
	}
	public void addInvoices(ProjectInvoice pi) {
		if (invoices == null) {
			invoices = new HashSet();
		} 
		
		invoices.add(pi);
	}
    public String toString() {
        return new ToStringBuilder(this)
            .append("id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectEMS) ) return false;
        ProjectEMS castOther = (ProjectEMS) other;
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

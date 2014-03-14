/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.project;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.Party;


public class SalaryLevel implements Serializable {
	private Long id;
	private String level;
	private String description;
	private Integer status;
	private Double rate;
	private String curr;
	private Party party;
	
	
	public String getCurr() {
		return curr;
	}

	public void setCurr(String curr) {
		this.curr = curr;
	}


	public Party getParty() {
		return party;
	}

	public void setParty(Party party) {
		this.party = party;
	}

	public Double getRate() {
		return rate;
	}

	public void setRate(Double rate) {
		this.rate = rate;
	}

	/**
	 * @param id
	 */
	public SalaryLevel(Long id) {
		super();
		// TODO Auto-generated constructor stub
		this.id = id;
	}

	/**
	 * @param description
	 * @param id
	 * @param level
	 * @param status
	 */
	public SalaryLevel(String description, Long id, String level, Integer status,Double rate,String curr,Party party) {
		super();
		// TODO Auto-generated constructor stub
		this.description = description;
		this.id = id;
		this.level = level;
		this.status = status;
		this.rate=rate;
		this.curr=curr;
		this.party=party;
	}

	/**
	 * 
	 */
	public SalaryLevel() {
		super();
		// TODO Auto-generated constructor stub
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
	 * @return Returns the level.
	 */
	public String getLevel() {
		return level;
	}

	/**
	 * @param level The level to set.
	 */
	public void setLevel(String level) {
		this.level = level;
	}

	/**
	 * @return Returns the status.
	 */
	public Integer getStatus() {
		return status;
	}

	/**
	 * @param status The status to set.
	 */
	public void setStatus(Integer status) {
		this.status = status;
	}

	public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof FMonth) ) return false;
        FMonth castOther = (FMonth) other;
        return new EqualsBuilder()
            .append(this.getId(), castOther.getId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }
    
    /**
	 * 获得所有机构信息
	 * 
	 * @param session   
	 * @return
	 * @throws HibernateException
	 */
	public  List getAllEnabledSalaryLevel(Session session) throws HibernateException{
		List result = new ArrayList();
		result = session.find("from SalaryLevel s where s.status='1'");
		return result ;
	}
}

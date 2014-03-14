/*
 * Created on 2005-5-24
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.crm.customer;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * @author gus
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CustT2Code implements Serializable{
	
	/** nullable persistent field */
    private String T2Code;
	/** nullable persistent field */
    private String Description;
    
	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return Description;
	}
	/**
	 * @param description The description to set.
	 */
	public void setDescription(String description) {
		Description = description;
	}
	/**
	 * @return Returns the t2Code.
	 */
	public String getT2Code() {
		return T2Code;
	}
	/**
	 * @param code The t2Code to set.
	 */
	public void setT2Code(String code) {
		T2Code = code;
	}
	/**
	 * @param description
	 */
	public CustT2Code(String description) {
		this.Description = description;
	}
	/**
	 * 
	 */
	public CustT2Code() {
	}
}

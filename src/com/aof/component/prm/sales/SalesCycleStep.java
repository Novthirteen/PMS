/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.sales;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;


/**
 * @author CN01458
 * @version 2005-5-25
 */
public class SalesCycleStep {
	
	private Long id;
	private String step;
	private String description;
	private Float percentage;
	
	
	/**
	 * @param id
	 * @param step
	 * @param descrition
	 * @param percentage
	 */
	public SalesCycleStep(Long id, String step, String description,
			Float percentage) {
		super();
		this.id = id;
		this.step = step;
		this.description = description;
		this.percentage = percentage;
	}
	
	/**
	 * @param id
	 */
	public SalesCycleStep(Long id) {
		super();
		this.id = id;
	}

	/**
	 * 
	 */
	public SalesCycleStep() {
		super();
	}
	
	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return description;
	}
	
	/**
	 * @param descrpition The description to set.
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
	 * @return Returns the percentage.
	 */
	public Float getPercentage() {
		return percentage;
	}
	/**
	 * @param percentage The percentage to set.
	 */
	public void setPercentage(Float percentage) {
		this.percentage = percentage;
	}
	/**
	 * @return Returns the step.
	 */
	public String getStep() {
		return step;
	}
	/**
	 * @param step The step to set.
	 */
	public void setStep(String step) {
		this.step = step;
	}
	public String toString() {
        return new ToStringBuilder(this)
            .append("id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof SalesCycleStep) ) return false;
        SalesCycleStep castOther = (SalesCycleStep) other;
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

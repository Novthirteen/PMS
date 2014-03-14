/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.sales;

import java.util.Date;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * @author CN01458
 * @version 2005-5-25
 */
public class SalesSheetDetail {
	private Long id;
	private SalesCycleStep salesCycleStep;
	private SalesSheetMaster salesSheetMaster;
	private String description;
	private Date achieveDate;
	/**
	 * @param id
	 * @param salesCycleStep
	 * @param salesSheetMaster
	 * @param description
	 * @param achieveDate
	 */
	public SalesSheetDetail(Long id, SalesCycleStep salesCycleStep,
			SalesSheetMaster salesSheetMaster, String description,
			Date achieveDate) {
		super();
		this.id = id;
		this.salesCycleStep = salesCycleStep;
		this.salesSheetMaster = salesSheetMaster;
		this.description = description;
		this.achieveDate = achieveDate;
	}
	/**
	 * @param id
	 */
	public SalesSheetDetail(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public SalesSheetDetail() {
		super();
	}
	/**
	 * @return Returns the achieveDate.
	 */
	public Date getAchieveDate() {
		return achieveDate;
	}
	/**
	 * @param achieveDate The achieveDate to set.
	 */
	public void setAchieveDate(Date achieveDate) {
		this.achieveDate = achieveDate;
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
	 * @return Returns the salesCycleStep.
	 */
	public SalesCycleStep getSalesCycleStep() {
		return salesCycleStep;
	}
	/**
	 * @param salesCycleStep The salesCycleStep to set.
	 */
	public void setSalesCycleStep(SalesCycleStep salesCycleStep) {
		this.salesCycleStep = salesCycleStep;
	}
	/**
	 * @return Returns the salesSheetMaster.
	 */
	public SalesSheetMaster getSalesSheetMaster() {
		return salesSheetMaster;
	}
	/**
	 * @param salesSheetMaster The salesSheetMaster to set.
	 */
	public void setSalesSheetMaster(SalesSheetMaster salesSheetMaster) {
		this.salesSheetMaster = salesSheetMaster;
	}
	public String toString() {
        return new ToStringBuilder(this)
            .append("id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof SalesSheetDetail) ) return false;
        SalesSheetDetail castOther = (SalesSheetDetail) other;
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

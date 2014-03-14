/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.bid;

import java.io.Serializable;
import java.util.*;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * @author CN01458
 * @version 2005-6-28
 */
public class SalesActivity implements Serializable {
	private Long id;
	private Integer seqNo;
	private String description;
	private String criticalFlg;
	private SalesStep step;

	/**
	 * @param id
	 * @param seqNo
	 * @param description
	 * @param criticalFlg
	 * @param step
	 */
	public SalesActivity(Long id, Integer seqNo, String description,
			String criticalFlg, SalesStep step) {
		super();
		this.id = id;
		this.seqNo = seqNo;
		this.description = description;
		this.criticalFlg = criticalFlg;
		this.step = step;

	}
	/**
	 * @param id
	 */
	public SalesActivity(Long id) {
		super();
		this.id = id;
	}
	/**
	 * 
	 */
	public SalesActivity() {
		super();
	}


	/**
	 * @return Returns the criticalFlg.
	 */
	public String getCriticalFlg() {
		return criticalFlg;
	}
	/**
	 * @param criticalFlg The criticalFlg to set.
	 */
	public void setCriticalFlg(String criticalFlg) {
		this.criticalFlg = criticalFlg;
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
	 * @return Returns the seqNo.
	 */
	public Integer getSeqNo() {
		return seqNo;
	}
	/**
	 * @param seqNo The seqNo to set.
	 */
	public void setSeqNo(Integer seqNo) {
		this.seqNo = seqNo;
	}
	/**
	 * @return Returns the step.
	 */
	public SalesStep getStep() {
		return step;
	}
	/**
	 * @param step The step to set.
	 */
	public void setStep(SalesStep step) {
		this.step = step;
	}
	public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof SalesActivity) ) return false;
        SalesActivity castOther = (SalesActivity) other;
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

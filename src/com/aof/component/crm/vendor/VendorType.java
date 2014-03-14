
package com.aof.component.crm.vendor;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.prm.master.ProjectCalendarType;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class VendorType {
    /** identifier field */
    private Long TypeId;

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
	 * @return Returns the typeId.
	 */
	public Long getTypeId() {
		return TypeId;
	}
	/**
	 * @param typeId The typeId to set.
	 */
	public void setTypeId(Long typeId) {
		TypeId = typeId;
	}
	/**
	 * @param typeId
	 * @param description
	 */
	public VendorType(Long typeId, String description) {
		super();
		TypeId = typeId;
		Description = description;
	}
	/**
	 * 
	 */
	public VendorType() {
	}
	/**
	 * @param typeId
	 */
	public VendorType(Long typeId) {
		TypeId = typeId;
	}
	
    public String toString() {
        return new ToStringBuilder(this)
            .append("TypeId", getTypeId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof VendorType) ) return false;
        VendorType castOther = (VendorType) other;
        return new EqualsBuilder()
            .append(this.getTypeId(), castOther.getTypeId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getTypeId())
            .toHashCode();
    }
}

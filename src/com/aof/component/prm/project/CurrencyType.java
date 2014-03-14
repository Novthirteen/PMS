package com.aof.component.prm.project;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class CurrencyType implements Serializable {

    /** identifier field */
    private String currId;

    /** nullable persistent field */
    private String currName;
    
	/** nullable persistent field */
	private Float currRate;
		
    /** full constructor */
    public CurrencyType(java.lang.String currId,java.lang.String currName,Float currRate) {
        this.currId = currId;
        this.currName = currName;
        this.currRate =currRate;
    }

    /** default constructor */
    public CurrencyType() {
    }

    public String getCurrId() {
        return this.currId;
    }

	public void setCurrId(java.lang.String currId) {
		this.currId = currId;
	}

    public java.lang.String getCurrName() {
        return this.currName;
    }

	public void setCurrName(java.lang.String currName) {
		this.currName = currName;
	}

	
    public String toString() {
        return new ToStringBuilder(this)
            .append("currId", getCurrId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectType) ) return false;
        ProjectType castOther = (ProjectType) other;
        return new EqualsBuilder()
            .append(this.getCurrId(), castOther.getPtId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getCurrId())
            .toHashCode();
    }

	/**
	 * @return
	 */
	public Float getCurrRate() {
		return this.currRate;
	}

	/**
	 * @param float1
	 */
	public void setCurrRate(Float currRate) {
		this.currRate = currRate;
	}
	
	static public CurrencyType getBaseCurrency(){
		return new CurrencyType(null,"RMB",new Float(1.0));
	}
}

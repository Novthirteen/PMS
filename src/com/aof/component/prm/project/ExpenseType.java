package com.aof.component.prm.project;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ExpenseType implements Serializable {

    /** identifier field */
    private Integer expId;

    /** nullable persistent field */
    private String expCode;
    
	/** nullable persistent field */
	private String expDesc;

	/** nullable persistent field */
	private Integer expParentCode;
		
	/** nullable persistent field */
	private String expBillCode;
	private String expBillAccDesc;
	private String expAccDesc;
	
	/** nullable persistent field */
	private String expSeq;
	
    /** full constructor */
    public ExpenseType(java.lang.String expCode,java.lang.String expDesc,Integer expParentCode,String expBillCode,String expSeq) {
        this.expCode=expCode;
        this.expDesc=expDesc;
        this.expParentCode=expParentCode;
        this.expBillCode=expBillCode;
        this.expSeq=expSeq;
    }

    /** default constructor */
    public ExpenseType() {
    }

    public Integer getExpId() {
        return this.expId;
    }

	public void setExpId(Integer expId) {
		this.expId = expId;
	}

	public java.lang.String getExpCode() {
		return this.expCode;
	}

	public void setExpCode(java.lang.String expCode) {
		this.expCode = expCode;
	}
	
	public java.lang.String getExpDesc() {
        return this.expDesc;
    }

	public void setExpDesc(java.lang.String expDesc) {
		this.expDesc = expDesc;
	}

	public Integer getExpParentCode() {
		return this.expParentCode;
	}

	public void setExpParentCode(Integer expParentCode) {
		this.expParentCode = expParentCode;
	}
	
    public String toString() {
        return new ToStringBuilder(this)
            .append("expId", getExpId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ExpenseType) )return false;
        ExpenseType castOther = (ExpenseType) other;
        return new EqualsBuilder()
            .append(this.getExpId(), castOther.getExpId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getExpId())
            .toHashCode();
    }

	/**
	 * @return
	 */
	public String getExpBillCode() {
		return this.expBillCode;
	}

	/**
	 * @return
	 */
	public String getExpSeq() {
		return this.expSeq;
	}

	/**
	 * @param string
	 */
	public void setExpBillCode(String string) {
		this.expBillCode = string;
	}

	/**
	 * @param string
	 */
	public void setExpSeq(String string) {
		this.expSeq = string;
	}

	public String getExpBillAccDesc() {
		return this.expBillAccDesc;
	}
	public void setExpBillAccDesc(String expBillAccDesc) {
		this.expBillAccDesc = expBillAccDesc;
	}
	
	public String getExpAccDesc() {
		return this.expAccDesc;
	}
	public void setExpAccDesc(String expAccDesc) {
		this.expAccDesc = expAccDesc;
	}
}

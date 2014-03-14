package com.aof.component.prm.project;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class FMonth implements Serializable {

    /** identifier field */
    private Long Id;

    /** persistent field */
    private Integer Year;

    /** persistent field */
    private short MonthSeq;

    /** persistent field */
    private String Description;

    /** nullable persistent field */
    private java.util.Date DateFrom;

    /** nullable persistent field */
    private java.util.Date DateTo;

    /** nullable persistent field */
    private java.util.Date DateFreeze;

    /** full constructor */
    public FMonth(Integer Year, short MonthSeq, java.lang.String Description, java.util.Date DateFrom, java.util.Date DateTo, java.util.Date DateFreeze) {
        this.Year = Year;
        this.MonthSeq = MonthSeq;
        this.Description = Description;
        this.DateFrom = DateFrom;
        this.DateTo = DateTo;
        this.DateFreeze = DateFreeze;
    }

    /** default constructor */
    public FMonth() {
    }

    /** minimal constructor */
    public FMonth(Integer Year, short MonthSeq, java.lang.String Description) {
        this.Year = Year;
        this.MonthSeq = MonthSeq;
        this.Description = Description;
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public Integer getYear() {
        return this.Year;
    }

	public void setYear(Integer Year) {
		this.Year = Year;
	}

    public short getMonthSeq() {
        return this.MonthSeq;
    }

	public void setMonthSeq(short MonthSeq) {
		this.MonthSeq = MonthSeq;
	}

    public java.lang.String getDescription() {
        return this.Description;
    }

	public void setDescription(java.lang.String Description) {
		this.Description = Description;
	}

    public java.util.Date getDateFrom() {
        return this.DateFrom;
    }

	public void setDateFrom(java.util.Date DateFrom) {
		this.DateFrom = DateFrom;
	}

    public java.util.Date getDateTo() {
        return this.DateTo;
    }

	public void setDateTo(java.util.Date DateTo) {
		this.DateTo = DateTo;
	}

    public java.util.Date getDateFreeze() {
        return this.DateFreeze;
    }

	public void setDateFreeze(java.util.Date DateFreeze) {
		this.DateFreeze = DateFreeze;
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

}

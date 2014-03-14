package com.aof.component.prm.master;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjectCalendar implements Serializable {

    /** identifier field */
    private Long Id;

    /** persistent field */
    private java.util.Date CalendarDate;

    /** nullable persistent field */
    private ProjectCalendarType Type;

    /** nullable persistent field */
    private double Hours;

    /** full constructor */
    public ProjectCalendar(java.util.Date CalendarDate, ProjectCalendarType Type, double Hours) {
        this.CalendarDate = CalendarDate;
        this.Type = Type;
        this.Hours = Hours;
    }

    /** default constructor */
    public ProjectCalendar() {
    }

    /** minimal constructor */
    public ProjectCalendar(java.util.Date CalendarDate) {
        this.CalendarDate = CalendarDate;
    }

    public Long getId() {
        return this.Id;
    }

	public void setId(Long Id) {
		this.Id = Id;
	}

    public java.util.Date getCalendarDate() {
        return this.CalendarDate;
    }

	public void setCalendarDate(java.util.Date CalendarDate) {
		this.CalendarDate = CalendarDate;
	}

    public ProjectCalendarType getType() {
        return this.Type;
    }

	public void setType(ProjectCalendarType Type) {
		this.Type = Type;
	}

    public double getHours() {
        return this.Hours;
    }

	public void setHours(double Hours) {
		this.Hours = Hours;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .append("Id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ProjectCalendar) ) return false;
        ProjectCalendar castOther = (ProjectCalendar) other;
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

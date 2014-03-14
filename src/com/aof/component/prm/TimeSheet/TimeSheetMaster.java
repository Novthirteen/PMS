package com.aof.component.prm.TimeSheet;
import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import com.aof.component.domain.party.UserLogin;
/** @author Hibernate CodeGenerator */
public class TimeSheetMaster implements Serializable
{
	/** identifier field */
	private Integer tsmId;
	/** nullable persistent field */
	private UserLogin TsmUser;
	/** nullable persistent field */
	private String Status;
	/** nullable persistent field */
	private String Period;
	/** nullable persistent field */
	private Date UpdateDate;
	/** nullable persistent field */
	private Float TotalHours;	

	private Set Details;
	/** full constructor */
	public TimeSheetMaster(
		UserLogin TsmUser,
		java.lang.String Status,
		java.lang.String Period)
	{
		this.TsmUser = TsmUser;
		this.Status = Status;
		this.Period = Period;
	}
	/** default constructor */
	public TimeSheetMaster()
	{
	}

	public UserLogin getTsmUser()
	{
		return this.TsmUser;
	}
	public void setTsmUser(UserLogin TsmUser)
	{
		this.TsmUser = TsmUser;
	}
	public java.lang.String getStatus()
	{
		return this.Status;
	}
	public void setStatus(java.lang.String Status)
	{
		this.Status = Status;
	}
	public java.lang.String getPeriod()
	{
		return this.Period;
	}
	public void setPeriod(java.lang.String Period)
	{
		this.Period = Period;
	}
	/**
	 * @return
	 */
	public Set getDetails()
	{
		return this.Details;
	}
	/**
	 * @param set
	 */
	public void setDetails(Set set)
	{
		this.Details = set;
	}
	
	public void addDetails(TimeSheetDetail ts)
	{
		ts.setTimeSheetMaster(this);
		
		if (Details == null) {
			Details = new HashSet();
		}
		this.Details.add(ts);
	}


	/**
	 * @return
	 */
	public Float getTotalHours() {
		return TotalHours;
	}

	/**
	 * @return
	 */
	public Date getUpdateDate() {
		return UpdateDate;
	}

	/**
	 * @param float1
	 */
	public void setTotalHours(Float float1) {
		TotalHours = float1;
	}

	/**
	 * @param date
	 */
	public void setUpdateDate(Date date) {
		UpdateDate = date;
	}

	/**
	 * @return
	 */
	public Integer getTsmId() {
		return tsmId;
	}

	/**
	 * @param integer
	 */
	public void setTsmId(Integer integer) {
		tsmId = integer;
	}

}
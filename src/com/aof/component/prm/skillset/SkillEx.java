package com.aof.component.prm.skillset;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.UserLogin;

public class SkillEx implements Serializable {

	private Long exId;

	private String exDesc;

	private UserLogin employee;

	private String exExp;

	public SkillEx() {

	}

	public UserLogin getEmployee() {
		return employee;
	}

	public void setEmployee(UserLogin employee) {
		this.employee = employee;
	}

	public String getExDesc() {
		return exDesc;
	}

	public void setExDesc(String exDesc) {
		this.exDesc = exDesc;
	}

	public Long getExId() {
		return exId;
	}

	public void setExId(Long exId) {
		this.exId = exId;
	}

	public String getExExp() {
		return exExp;
	}

	public void setExExp(String exExp) {
		this.exExp = exExp;
	}

	public String toString() {
		return new ToStringBuilder(this).append("exId", getExId()).toString();
	}

	public boolean equals(Object other) {
		if (!(other instanceof SkillEx))
			return false;
		SkillEx castOther = (SkillEx) other;
		return new EqualsBuilder().append(this.getExId(), castOther.getExId()).isEquals();
	}

	public int hashCode() {
		return new HashCodeBuilder().append(getExId()).toHashCode();
	}
}

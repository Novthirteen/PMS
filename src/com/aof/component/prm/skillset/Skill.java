package com.aof.component.prm.skillset;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.UserLogin;

public class Skill implements Serializable {

	private Long skillId;

	private UserLogin employee;

	private SkillCategory skillCat;

	private SkillLevel skillLevel;

	public Skill() {

	}

	public UserLogin getEmployee() {
		return employee;
	}

	public void setEmployee(UserLogin employee) {
		this.employee = employee;
	}

	public Long getSkillId() {
		return skillId;
	}

	public void setSkillId(Long skillId) {
		this.skillId = skillId;
	}

	public SkillCategory getSkillCat() {
		return skillCat;
	}

	public void setSkillCat(SkillCategory skillCat) {
		this.skillCat = skillCat;
	}

	public SkillLevel getSkillLevel() {
		return skillLevel;
	}

	public void setSkillLevel(SkillLevel skillLevel) {
		this.skillLevel = skillLevel;
	}

	public String toString() {
		return new ToStringBuilder(this).append("skillId", getSkillId()).toString();
	}

	public boolean equals(Object other) {
		if (!(other instanceof Skill))
			return false;
		Skill castOther = (Skill) other;
		return new EqualsBuilder().append(this.getSkillId(), castOther.getSkillId())
				.isEquals();
	}

	public int hashCode() {
		return new HashCodeBuilder().append(getSkillId()).toHashCode();
	}
}

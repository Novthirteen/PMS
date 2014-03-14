package com.aof.component.prm.skillset;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

public class SkillLevel implements Serializable {

	private String levelId;

	private String levelDesc;

	private String catId;

	public SkillLevel() {

	}

	public String getCatId() {
		return catId;
	}

	public void setCatId(String catId) {
		this.catId = catId;
	}

	public String getLevelDesc() {
		return levelDesc;
	}

	public void setLevelDesc(String levelDesc) {
		this.levelDesc = levelDesc;
	}

	public String getLevelId() {
		return levelId;
	}

	public void setLevelId(String levelId) {
		this.levelId = levelId;
	}

	public String toString() {
		return new ToStringBuilder(this).append("levelId", getLevelId())
				.toString();
	}

	public boolean equals(Object other) {
		if (!(other instanceof SkillLevel))
			return false;
		SkillLevel castOther = (SkillLevel) other;
		return new EqualsBuilder().append(this.getLevelId(),
				castOther.getLevelId()).isEquals();
	}

	public int hashCode() {
		return new HashCodeBuilder().append(getLevelId()).toHashCode();
	}
}

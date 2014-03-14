package com.aof.component.prm.skillset;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

public class SkillCategory implements Serializable {

	private String catId;

	private String pcatId;

	private String catName;

	private String catDesc;

	public SkillCategory() {

	}

	public String getCatDesc() {
		return catDesc;
	}

	public void setCatDesc(String catDesc) {
		this.catDesc = catDesc;
	}

	public String getCatId() {
		return catId;
	}

	public void setCatId(String catId) {
		this.catId = catId;
	}

	public String getCatName() {
		return catName;
	}

	public void setCatName(String catName) {
		this.catName = catName;
	}

	public String getPcatId() {
		return pcatId;
	}

	public void setPcatId(String pcatId) {
		this.pcatId = pcatId;
	}

	public String toString() {
		return new ToStringBuilder(this).append("catId", getCatId()).toString();
	}

	public boolean equals(Object other) {
		if (!(other instanceof SkillCategory))
			return false;
		SkillCategory castOther = (SkillCategory) other;
		return new EqualsBuilder()
				.append(this.getCatId(), castOther.getCatId()).isEquals();
	}

	public int hashCode() {
		return new HashCodeBuilder().append(getCatId()).toHashCode();
	}
}

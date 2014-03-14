package com.aof.component.prm.skillset;

import java.io.Serializable;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.UserLogin;

public class SkillComment implements Serializable {

	private Long commentId;

	private String commentDesc;

	private UserLogin employee;

	public SkillComment() {

	}

	public String getCommentDesc() {
		return commentDesc;
	}

	public void setCommentDesc(String commentDesc) {
		this.commentDesc = commentDesc;
	}

	public Long getCommentId() {
		return commentId;
	}

	public void setCommentId(Long commentId) {
		this.commentId = commentId;
	}

	public UserLogin getEmployee() {
		return employee;
	}

	public void setEmployee(UserLogin employee) {
		this.employee = employee;
	}

	public String toString() {
		return new ToStringBuilder(this).append("commentId", getCommentId()).toString();
	}

	public boolean equals(Object other) {
		if (!(other instanceof SkillComment))
			return false;
		SkillComment castOther = (SkillComment) other;
		return new EqualsBuilder().append(this.getCommentId(), castOther.getCommentId()).isEquals();
	}

	public int hashCode() {
		return new HashCodeBuilder().append(getCommentId()).toHashCode();
	}
}

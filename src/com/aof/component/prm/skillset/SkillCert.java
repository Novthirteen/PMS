package com.aof.component.prm.skillset;

import java.io.Serializable;
import java.util.Date;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.aof.component.domain.party.UserLogin;

public class SkillCert implements Serializable {

	private Long certId;

	private String certDesc;

	private Date dateGrant;

	private UserLogin employee;

	public SkillCert() {

	}

	public Long getCertId() {
		return certId;
	}

	public void setCertId(Long certId) {
		this.certId = certId;
	}

	public String getCertDesc() {
		return certDesc;
	}

	public void setCertDesc(String certDesc) {
		this.certDesc = certDesc;
	}

	public Date getDateGrant() {
		return dateGrant;
	}

	public void setDateGrant(Date dateGrant) {
		this.dateGrant = dateGrant;
	}

	public UserLogin getEmployee() {
		return employee;
	}

	public void setEmployee(UserLogin employee) {
		this.employee = employee;
	}

	public String toString() {
		return new ToStringBuilder(this).append("certId", getCertId()).toString();
	}

	public boolean equals(Object other) {
		if (!(other instanceof SkillCert))
			return false;
		SkillCert castOther = (SkillCert) other;
		return new EqualsBuilder().append(this.getCertId(), castOther.getCertId()).isEquals();
	}

	public int hashCode() {
		return new HashCodeBuilder().append(getCertId()).toHashCode();
	}
}

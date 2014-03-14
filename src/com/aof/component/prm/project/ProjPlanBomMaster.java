package com.aof.component.prm.project;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

import com.aof.component.prm.bid.BidMaster;

public class ProjPlanBomMaster {
private long id;
private ProjectMaster project;
private BidMaster bid;
private Long bom_id;
private int version;
private Date startDate;
private Date endDate;
private String status;
private String ReveConfirm;
private String CostConfirm;
private String enable;
private StandardBOMMaster template;

public StandardBOMMaster getTemplate() {
	return template;
}
public void setTemplate(StandardBOMMaster template) {
	this.template = template;
}
public Date getEndDate() {
	return endDate;
}
public void setEndDate(Date endDate) {
	this.endDate = endDate;
}
public long getId() {
	return id;
}
public void setId(long id) {
	this.id = id;
}
public ProjectMaster getProject() {
	return project;
}
public void setProject(ProjectMaster project) {
	this.project = project;
}
public String getReveConfirm() {
	return ReveConfirm;
}
public void setReveConfirm(String reveConfirm) {
	ReveConfirm = reveConfirm;
}
public Date getStartDate() {
	return startDate;
}
public void setStartDate(Date startDate) {
	this.startDate = startDate;
}
public String getStatus() {
	return status;
}
public void setStatus(String status) {
	this.status = status;
}
public int getVersion() {
	return version;
}
public void setVersion(int version) {
	this.version = version;
}
public String getEnable() {
	return enable;
}
public void setEnable(String enable) {
	this.enable = enable;
}
public String getCostConfirm() {
	return CostConfirm;
}
public void setCostConfirm(String costConfirm) {
	CostConfirm = costConfirm;
}
public BidMaster getBid() {
	return bid;
}
public void setBid(BidMaster bid) {
	this.bid = bid;
}
public Long getBom_id() {
	return bom_id;
}
public void setBom_id(Long bom_id) {
	this.bom_id = bom_id;
}
public boolean equals(Object other) {
	if ( !(other instanceof ProjPlanBomMaster) ) return false;
	ProjPlanBomMaster castOther = (ProjPlanBomMaster) other;
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

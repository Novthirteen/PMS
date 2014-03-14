package com.aof.component.prm.report;

import com.aof.component.prm.project.ProjectMaster;

public class BackLogMaster {
private int blm_id;
private ProjectMaster project;
private int blm_year;
private Double amount;
public Double getAmount() {
	return amount;
}
public void setAmount(Double amount) {
	this.amount = amount;
}
public int getBlm_year() {
	return blm_year;
}
public void setBlm_year(int blm_year) {
	this.blm_year = blm_year;
}
public int getBlm_id() {
	return blm_id;
}
public void setBlm_id(int blm_id) {
	this.blm_id = blm_id;
}
public ProjectMaster getProject() {
	return project;
}
public void setProject(ProjectMaster project) {
	this.project = project;
}

}

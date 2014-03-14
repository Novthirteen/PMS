package com.aof.component.prm.report;


import com.aof.component.prm.project.ProjectMaster;

public class BackLog {
	public int bl_id;
	private ProjectMaster project;
	private int bl_year;
	private int bl_month;
	private double amount ;
	private String status;
	private String department;
	
	public void setbl_month(int i)
	{bl_month=i;}
	public int getbl_month()
	{return bl_month;}
	public void setamount(double d)
	{amount=d;}
	public double getamount()
	{return amount;}
	public void setstatus(String s)
	{status=s;}
	public String getstatus()
	{return status;}
	public void setdepartment(String s)
	{department=s;}
	public String getdepartment()
	{return department;}




	public void setbl_id(int s) {
		bl_id = s;
	}

	public int getbl_id() {
		return bl_id;
	}

	public void setbl_year(int i) {
		bl_year=i;
	}
	public int getbl_year()
	{return bl_year;}



	public void setproject(ProjectMaster pm) {
		project= pm;
	}

	public ProjectMaster getproject() {
		return project;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public int getBl_id() {
		return bl_id;
	}
	public void setBl_id(int bl_id) {
		this.bl_id = bl_id;
	}
	public int getBl_month() {
		return bl_month;
	}
	public void setBl_month(int bl_month) {
		this.bl_month = bl_month;
	}
	public int getBl_year() {
		return bl_year;
	}
	public void setBl_year(int bl_year) {
		this.bl_year = bl_year;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public ProjectMaster getProject() {
		return project;
	}
	public void setProject(ProjectMaster project) {
		this.project = project;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}


}

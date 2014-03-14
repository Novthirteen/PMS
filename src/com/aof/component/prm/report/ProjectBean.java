package com.aof.component.prm.report;

import java.text.SimpleDateFormat;
import java.util.StringTokenizer;

public class ProjectBean {
	/** identifier field */
	private String projId;

	/** nullable persistent field */
	private String projName;

	/** nullable persistent field */
	private String customer;

	/** nullable persistent field */
	private String department;

	/** nullable persistent field */
	private String projStatus;

	/** nullable persistent field */
	private String ProjectManager;

	private String CAFFlag;

	/** nullable persistent field */
	private String ContractNo;

	/** nullable persistent field */
	private String ContractType;

	/** nullable persistent field */
	private Double totalServiceValue;

	/** nullable persistent field */
	private java.util.Date startDate;

	/** nullable persistent field */
	private java.util.Date endDate;
	
	private int duration;
	
	private String proj_duration;
	
//	private Double 
//	privat


	private String c2code;

	private String industry;
	private String t2_code;


	public String getT2_code() {
		return t2_code;
	}

	public void setT2_code(String t2_code) {
		this.t2_code = t2_code;
	}

	public ProjectBean(String projid,String projName, String customer, String department,
			String projStatus, String ProjectManager, String CAFFlag,double tcv,
			String ContractNo, String ContractType,
			java.sql.Date st, java.sql.Date ed,String t2,String ind,String d) {
		this.projId=projid;
		this.projName = projName;
		this.customer = customer;
		this.CAFFlag=CAFFlag;
		this.totalServiceValue=new Double(tcv);
		this.department = department;
		this.projStatus = projStatus;
		this.ProjectManager = ProjectManager;
		this.ContractNo = ContractNo;
		this.totalServiceValue = new Double(tcv);
		this.ContractType=ContractType;
		// this.contact = contact;
		this.startDate = st;
		this.endDate = ed;
		this.t2_code=t2;
		this.industry=ind;
		this.proj_duration = d;
		
		this.calculateDuration();
		
	}
	
	public void calculateDuration()
	{
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String myString = df.format(this.getStartDate());
		StringTokenizer st = new StringTokenizer(myString, "-");
		int year1 = Integer.parseInt(st.nextToken());
		int month1 = Integer.parseInt(st.nextToken());

		myString = df.format(this.getEndDate());
		st = new StringTokenizer(myString, "-");
		int year2 = Integer.parseInt(st.nextToken());
		int month2 = Integer.parseInt(st.nextToken());
		
		if(year1==year2)
		{
			this.setDuration(month2-month1+1);				
		}
		else
		{
			this.setDuration(13-month1+month2+12*(year2-year1-1));
		}

	}

	public String getC2code() {
		return c2code;
	}

	public void setC2code(String c2code) {
		this.c2code = c2code;
	}

	public String getIndustry() {
		return industry;
	}

	public void setIndustry(String industry) {
		this.industry = industry;
	}

	public String getCAFFlag() {
		return CAFFlag;
	}

	public void setCAFFlag(String flag) {
		CAFFlag = flag;
	}

	public String getContractNo() {
		return ContractNo;
	}

	public void setContractNo(String contractNo) {
		ContractNo = contractNo;
	}

	public String getContractType() {
		return ContractType;
	}

	public void setContractType(String contractType) {
		ContractType = contractType;
	}

	public String getCustomer() {
		return customer;
	}

	public void setCustomer(String customer) {
		this.customer = customer;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public java.util.Date getEndDate() {
		return endDate;
	}

	public void setEndDate(java.util.Date endDate) {
		this.endDate = endDate;
	}

	public String getProjectManager() {
		return ProjectManager;
	}

	public void setProjectManager(String projectManager) {
		ProjectManager = projectManager;
	}

	public String getProjId() {
		return projId;
	}

	public void setProjId(String projId) {
		this.projId = projId;
	}

	public String getProjName() {
		return projName;
	}

	public void setProjName(String projName) {
		this.projName = projName;
	}

	public String getProjStatus() {
		return projStatus;
	}

	public void setProjStatus(String projStatus) {
		this.projStatus = projStatus;
	}

	public java.util.Date getStartDate() {
		return startDate;
	}

	public void setStartDate(java.util.Date startDate) {
		this.startDate = startDate;
	}

	public Double getTotalServiceValue() {
		return totalServiceValue;
	}

	public void setTotalServiceValue(Double totalServiceValue) {
		this.totalServiceValue = totalServiceValue;
	}

	public int getDuration() {
		return duration;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	public String getProj_duration() {
		return proj_duration;
	}

	public void setProj_duration(String proj_duration) {
		this.proj_duration = proj_duration;
	}

}

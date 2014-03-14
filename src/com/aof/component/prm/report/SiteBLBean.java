package com.aof.component.prm.report;

import java.util.List;

public class SiteBLBean {

	private String depid;

	private String depdesc;

	private List deplist;// this is the list for departmentBLBean;

	private int TotalTCV;

	private int TYRevenue;

	private Integer month[];
	
	private String cyear;
	
	private String cmonth;

	public SiteBLBean(String desc, List deplist,String year,String smonth) {
//		this.depid = id;
		this.depdesc = desc;
		this.deplist = deplist;
		this.cyear=year;
		this.cmonth=smonth;
		month=new Integer[12];
		for(int i=0;i<12;i++)
			month[i]=new Integer(0);
		
	}

	public void setRevenue() {
		for (int i = 0; i < deplist.size(); i++) {
			DepartmentBLBean bean = (DepartmentBLBean) deplist.get(i);
			TotalTCV += bean.getTotalTCV();
			TYRevenue += bean.getTYRevenue();
			Integer[] temp = bean.getMonth();
			for (int j = 0; j < 12; j++)
				month[j] = new Integer(month[j].intValue()
						+ temp[j].intValue());
		}
	}

	public String getDepdesc() {
		return depdesc;
	}

	public void setDepdesc(String depdesc) {
		this.depdesc = depdesc;
	}

	public String getDepid() {
		return depid;
	}

	public void setDepid(String depid) {
		this.depid = depid;
	}

	public Integer[] getMonth() {
		return month;
	}

	public void setMonth(Integer[] month) {
		this.month = month;
	}

	public List getDeplist() {
		return deplist;
	}

	public void setDeplist(List deplist) {
		this.deplist = deplist;
	}

	public int getTotalTCV() {
		return TotalTCV;
	}

	public void setTotalTCV(int totalTCV) {
		TotalTCV = totalTCV;
	}

	public int getTYRevenue() {
		return TYRevenue;
	}

	public void setTYRevenue(int revenue) {
		TYRevenue = revenue;
	}

	public String getCmonth() {
		return cmonth;
	}

	public void setCmonth(String cmonth) {
		this.cmonth = cmonth;
	}

	public String getCyear() {
		return cyear;
	}

	public void setCyear(String cyear) {
		this.cyear = cyear;
	}

}

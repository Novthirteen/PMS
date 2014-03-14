package com.aof.component.prm.report;

import java.util.List;

public class DepartmentBLBean {

private String depid;
private String depdesc;
private List recordlist;
private int TotalTCV;
private int TYRevenue;
private Integer month[];
public DepartmentBLBean(String desc,List list)
{
//	this.depid=id;
	this.depdesc=desc;
	this.recordlist=list;
	month=new Integer[12];
	for(int i=0;i<12;i++)
	{
		month[i]=new Integer(0);
	}
	
}
public void setRevenue()
{
	for(int i=0;i<recordlist.size();i++)
	{
	BackLogBean bean=(BackLogBean)recordlist.get(i);
	TotalTCV+=(int)Math.round(bean.getPb().getTotalServiceValue().doubleValue());
	TYRevenue+=(int)Math.round(bean.getThisyear().doubleValue());
	Double[][] temp=bean.getMonth();
		for(int j=0;j<12;j++){
			if(month[j]==null)
				System.out.println("department month is null");
			else if(temp[0][j]==null)
				System.out.println("record month is null");
			else				
			month[j]=new Integer(month[j].intValue()+(int)Math.round(temp[0][j].doubleValue()));
			}
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
public List getRecordlist() {
	return recordlist;
}
public void setRecordlist(List recordlist) {
	this.recordlist = recordlist;
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



}

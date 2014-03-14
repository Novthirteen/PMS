package com.aof.component.prm.expense;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import com.aof.component.BaseServices;

public class ExpenseService extends BaseServices {
	public String getFormNo(ExpenseMaster exp,Session sess) throws HibernateException {
		Calendar calendar=Calendar.getInstance();
		final int year=calendar.get(Calendar.YEAR);
		String CodePrefix = getFormNoPrefix(exp,year);
		Query q = sess.createQuery("select max(p.FormCode) from ExpenseMaster as p where p.FormCode like '"+CodePrefix+"%'");
	
		List result=q.list();
		int count = 0;
		String GetResult = (String)result.get(0);
		if (GetResult !=  null)
			count = (new Integer(GetResult.substring(CodePrefix.length()))).intValue();
		return getFormNo(CodePrefix,count+1,6);
	}
	
	public String getFormNo(ProjectCostMaster pcm,Session sess) throws HibernateException {
		Calendar calendar=Calendar.getInstance();
		final int year=calendar.get(Calendar.YEAR);
		String CodePrefix = getFormNoPrefix(pcm,year);
		Query q = sess.createQuery("select max(p.FormCode) from ProjectCostMaster as p where p.FormCode like '"+CodePrefix+"%'");

		List result=q.list();
		int count = 0;
		String GetResult = (String)result.get(0);
		if (GetResult !=  null)
			count = (new Integer(GetResult.substring(CodePrefix.length()))).intValue();
		return getFormNo(CodePrefix,count+1,6);
	}
	
	private String getFormNo(String CodePrefix,int no,int len)
	{
		StringBuffer sb=new StringBuffer();
		sb.append(CodePrefix);
		sb.append(fillPreZero(no,len));
		return sb.toString();
	}
	
	private String getFormNoPrefix(ExpenseMaster exp,int year)
	{
		StringBuffer sb=new StringBuffer();
		sb.append("E");
		//sb.append(exp.getExpenseUser().getUserLoginId());
		sb.append(String.valueOf(year).substring(2));
		return sb.toString();
	}
	
	private String getFormNoPrefix(ProjectCostMaster pcm,int year)
	{
		StringBuffer sb=new StringBuffer();
		sb.append("P");
		//sb.append(pcm.getProjectCostType().getTypeid());
		sb.append(String.valueOf(year).substring(2));
		return sb.toString();
	}
	
	private String fillPreZero(int no,int len) {
		String s=String.valueOf(no);
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<len-s.length();i++)
		{
			sb.append('0');
		}
		sb.append(s);
		return sb.toString();
	}
	
	private int getYear(Date date)
	{
		Calendar calendar=Calendar.getInstance();
		calendar.setTime(date);
		return calendar.get(Calendar.YEAR);
	}
}
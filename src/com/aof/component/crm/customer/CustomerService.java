package com.aof.component.crm.customer;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import com.aof.component.BaseServices;

public class CustomerService extends BaseServices {
	public String getCustomerNo(Session sess) throws HibernateException {
		String CodePrefix = "C0";
		Query q = sess.createQuery("select max(p.partyId) from Party as p where p.partyId like '"+CodePrefix+"%'");
		List result=q.list();
		int count = 0;
		String GetResult = (String)result.get(0);
		if (GetResult !=  null)
			count = (new Integer(GetResult.substring(CodePrefix.length()))).intValue();
		return getCustomerNo(CodePrefix,count+1);
	}
	private String getCustomerNo(String CodePrefix,int no)
	{
		StringBuffer sb=new StringBuffer();
		sb.append(CodePrefix);
		sb.append(fillPreZero(no,5));
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
}
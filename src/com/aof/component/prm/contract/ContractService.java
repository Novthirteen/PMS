/*
 * Created on 2005-6-22
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.component.prm.contract;

import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import com.aof.component.BaseServices;

/**
 * @author CN01512
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ContractService extends BaseServices{
	public String getContractNo(ContractProfile Contract,Session sess) throws HibernateException {
			Calendar calendar=Calendar.getInstance();
			final int year=calendar.get(Calendar.YEAR);
			String CodePrefix = getContractNoPrefix(Contract,year);
			Query q = sess.createQuery("select max(cp.no) from ContractProfile as cp where cp.no like '"+CodePrefix+"%'");
		
			List result=q.list();
			int count = 0;
			String GetResult = (String)result.get(0);
			if (GetResult !=  null)
				count = (new Integer(GetResult.substring(CodePrefix.length()))).intValue();
			return getContractProfileNo(CodePrefix,count+1);
		}
	
		private String getContractProfileNo(String CodePrefix,int no)
		{
			StringBuffer sb=new StringBuffer();
			sb.append(CodePrefix);
			sb.append(fillPreZero(no,4));
			return sb.toString();
		}
		private String getContractNoPrefix(ContractProfile Contract,int year)
		{
			StringBuffer sb=new StringBuffer();
			sb.append("C");
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
	  
	  //POProfile
	public String getPOProfileNo(POProfile Contract,Session sess) throws HibernateException {
				Calendar calendar=Calendar.getInstance();
				final int year=calendar.get(Calendar.YEAR);
				String CodePrefix = getPONoPrefix(Contract,year);
				Query q = sess.createQuery("select max(cp.no) from POProfile as cp where cp.no like '"+CodePrefix+"%'");
		
				List result=q.list();
				int count = 0;
				String GetResult = (String)result.get(0);
				if (GetResult !=  null)
					count = (new Integer(GetResult.substring(CodePrefix.length()))).intValue();
				return getPONo(CodePrefix,count+1);
			}
	
			private String getPONo(String CodePrefix,int no)
			{
				StringBuffer sb=new StringBuffer();
				sb.append(CodePrefix);
				sb.append(fillPreZero(no,4));
				return sb.toString();
			}
			private String getPONoPrefix(POProfile Contract,int year)
			{
				StringBuffer sb=new StringBuffer();
				sb.append("P");
				sb.append(String.valueOf(year).substring(2));
			
				return sb.toString();
			}

}

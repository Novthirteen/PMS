/*
 * Created on 2005-7-8
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.component.prm.bid;

import java.util.Iterator;
import java.util.Set;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import org.apache.log4j.Logger;

import com.aof.component.BaseServices;
import com.aof.util.UtilDateTime;
/**
 * @author CN01512
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BidMasterService extends BaseServices{
	private Logger log = Logger.getLogger(BidMasterService.class);
	
	public BidMaster viewBidMaster(Long id, boolean lazyFlg) {
		
		BidMaster bm = null;
		
		if (id != null && id.longValue() > 0) {
			try {
				session = this.getSession();
				
				bm = (BidMaster)session.load(BidMaster.class, id);				
				
				//for load step and activity
				if (!lazyFlg) {
				  if(bm.getStepGroup()!= null){
				  	SalesStepGroup stepGroup = bm.getStepGroup();
					if (stepGroup.getSteps() != null) {
						Set steps = stepGroup.getSteps();
						
						if (steps != null) {
							Iterator iterator = steps.iterator();
							while (iterator.hasNext()) {
								SalesStep ss = (SalesStep)iterator.next();
								if (ss.getActivities() != null) {
									ss.getActivities().size();
								}
							}
						}
					}
				  }
				}
				return bm;
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		return bm;
	}
	public void newBidMaster(BidMaster bm) {
		if (bm != null) {
			try {
				session = this.getSession();
				session.save(bm);
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
	
	public void updateBidMaster(BidMaster bm) {
		if (bm != null) {
			try {
				session = this.getSession();
				session.update(bm);
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
	
	public void deleteBidMaster(BidMaster bm) {
		if (bm != null) {
			try {
				session = this.getSession();
				session.delete(bm);
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
	}
	
	public String getBidMasterNo(BidMaster bid,Session sess) throws HibernateException {
		Calendar calendar=Calendar.getInstance();
		calendar.setTime((java.util.Date)UtilDateTime.nowTimestamp());
		final int year=calendar.get(Calendar.YEAR);
		final int month =calendar.get(Calendar.MONTH);
		final int day = calendar.get(Calendar.DATE);
		String CodePrefix = getContractNoPrefix(bid,year,month,day);
		Query q = sess.createQuery("select max(bm.no) from BidMaster as bm where bm.no like '"+CodePrefix+"%'");

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
		sb.append(fillPreZero(no,3));
		return sb.toString();
	}
	private String getContractNoPrefix(BidMaster bid,int year,int month,int day)
	{
		StringBuffer sb=new StringBuffer();
		sb.append("B");
		sb.append(String.valueOf(year).substring(2));
		if(month<10){
			sb.append("0");
			sb.append(String.valueOf(month + 1));
		}else{
			sb.append(String.valueOf(month + 1));
		}
		if (day<10){
			sb.append("0");
			sb.append(String.valueOf(day));
		}else{
			sb.append(String.valueOf(day));
		}
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

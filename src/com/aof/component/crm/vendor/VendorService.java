
package com.aof.component.crm.vendor;

import java.util.ArrayList;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import com.aof.component.BaseServices;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class VendorService extends BaseServices {
	public String getVendorNo(Session sess) throws HibernateException {
		String CodePrefix = "V0";
		Query q = sess.createQuery("select max(p.partyId) from Party as p where p.partyId like '"+CodePrefix+"%'");
		List result=q.list();
		int count = 0;
		String GetResult = (String)result.get(0);
		if (GetResult !=  null)
			count = (new Integer(GetResult.substring(CodePrefix.length()))).intValue();
		return getVendorNo(CodePrefix,count+1);
	}
	public List getAllVendor(Session sess) 
	throws HibernateException{
		List result = new ArrayList();
		result = sess.find("from VendorProfile v");
		return result ;
	}
	private String getVendorNo(String CodePrefix,int no)
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

/*
 * Created on 2004-11-17
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.helpdesk.puquery;

import java.util.List;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.type.NullableType;
import net.sf.hibernate.type.Type;

import com.aof.component.domain.party.PartyKeys;
import com.aof.component.domain.party.PartyServices;

/**
 * @author qiu
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class PartyResult extends PartyServices {
	public int GetPartySelectCount(String stype,String sdesc,String sname,String saddress) throws HibernateException {
	    try {
	    	String sQuery;
		    getSession();
		    stype=stype.trim();
	    	if (stype.equals("")){
	    		sQuery="select count(p) from Party p left outer join p.partyRoles r where r.roleTypeId = ? and (?='' or p.description like ?) and (?='' or link_man like ?) and (?='' or address like ?)";
	    	}
	    	else{
	    		sQuery="select count(p) from Party p left outer join p.partyRoles r where r.roleTypeId <> ? and (?='' or p.description like ?) and (?='' or link_man like ?) and (?='' or address like ?)";
	    	}
	    	Query rs=session.createQuery(sQuery);
	    	rs.setString(0,PartyKeys.CUSTOMER_ROLE_KEY);
	    	rs.setString(1,sdesc);
	    	rs.setString(2,"%"+sdesc+"%");
	    	rs.setString(3,sname);
	    	rs.setString(4,"%"+sname+"%");
	    	rs.setString(5,saddress);
	    	rs.setString(6,"%"+saddress+"%");
	    	//rs.setFirstResult((nPage-1)*QueryListKeys.QUERY_IN_EACH_PAGE);
	    	//rs.setMaxResults(QueryListKeys.QUERY_IN_EACH_PAGE);
	    	List ls=rs.list();
	    	if(!ls.isEmpty())
			{
				Integer count = (Integer) ls.get(0);
				if(count!=null)	return count.intValue();
			}	    	
	    } finally {
	        closeSession();
	    }
	    return 0;
	}
	
	public List getPartySelectPage(String stype,String sdesc,String sname,String saddress,int nPage) {
	    try {
	    	String sQuery;
		    getSession();
		    stype=stype.trim();
	    	if (stype.equals("")){
	    		sQuery="select p from Party p left outer join p.partyRoles r where r.roleTypeId = ? and (?='' or p.description like ?) and (?='' or link_man like ?) and (?='' or address like ?)";
	    	}
	    	else{
	    		sQuery="select p from Party p left outer join p.partyRoles r where r.roleTypeId <> ? and (?='' or p.description like ?) and (?='' or link_man like ?) and (?='' or address like ?)";
	    	}
	    	Query rs=session.createQuery(sQuery);
	    	rs.setString(0,PartyKeys.CUSTOMER_ROLE_KEY);
	    	rs.setString(1,sdesc);
	    	rs.setString(2,"%"+sdesc+"%");
	    	rs.setString(3,sname);
	    	rs.setString(4,"%"+sname+"%");
	    	rs.setString(5,saddress);
	    	rs.setString(6,"%"+saddress+"%");
	    	rs.setFirstResult((nPage)*QueryListKeys.QUERY_IN_EACH_PAGE);
	    	rs.setMaxResults(QueryListKeys.QUERY_IN_EACH_PAGE);
	    	return rs.list();
	    } catch (HibernateException e) {
	        return null;
	    } finally {
	        closeSession();
	    }
	}	
	
	public List getPartySelect(String stype,String sdesc,String sname,String saddress) {
	    try {
		    getSession();
		    stype=stype.trim();
	    	String arg1[]=new String[7];
	    	NullableType arg2[]={Hibernate.STRING,Hibernate.STRING,Hibernate.STRING,Hibernate.STRING,Hibernate.STRING,Hibernate.STRING,Hibernate.STRING};
	    	arg1[0]=PartyKeys.CUSTOMER_ROLE_KEY;
	    	arg1[1]=sdesc;
	    	arg1[2]="%"+sdesc+"%";
	    	arg1[3]=sname;
	    	arg1[4]="%"+sname+"%";
	    	arg1[5]=saddress;
	    	arg1[6]="%"+saddress+"%";
	    	if (stype.equals("")){
	    		return session.find("select p from Party p left outer join p.partyRoles r where r.roleTypeId = ? and (?='' or p.description like ?) and (?='' or link_man like ?) and (?='' or address like ?)", arg1,arg2);
	    	}
	    	else{
	    		return session.find("select p from Party p left outer join p.partyRoles r where r.roleTypeId <> ? and (?='' or p.description like ?) and (?='' or link_man like ?) and (?='' or address like ?)", arg1,arg2);
	    	}
	    } catch (HibernateException e) {
	        return null;
	    } finally {
	        closeSession();
	    }
	}	

	public int getPartyUserCount(String spartyid,String susername)  throws HibernateException {
	    try {
	    	String sQuery="select count(ul) from UserLogin as ul where  ul.enable='y' and ul.party=? and (?='' or name like ?)";
		    getSession();
		    Query rs=session.createQuery(sQuery);
		    rs.setString(0,spartyid);
		    rs.setString(1,susername);
		    rs.setString(2,"%"+susername+"%");
	    	//rs.setFirstResult((nPage)*QueryListKeys.QUERY_IN_EACH_PAGE);
	    	//rs.setMaxResults(QueryListKeys.QUERY_IN_EACH_PAGE);
	    	List ls=rs.list();
	    	if(!ls.isEmpty())
			{
				Integer count = (Integer) ls.get(0);
				if(count!=null)	return count.intValue();
			}	   
	    }finally {
	        closeSession();
	    }
	    return 0;
	}	
	
	public List getPartyUserPage(String spartyid,int nPage) {
	    try {
	    	String sQuery="select ul from UserLogin as ul where  ul.enable='y' and ul.party=?";
		    getSession();
		    Query rs=session.createQuery(sQuery);
		    rs.setString(0,spartyid);
	    	rs.setFirstResult((nPage)*QueryListKeys.QUERY_IN_EACH_PAGE);
	    	rs.setMaxResults(QueryListKeys.QUERY_IN_EACH_PAGE);
	    	return rs.list();
		
	    } catch (HibernateException e) {
	        return null;
	    } finally {
	        closeSession();
	    }
	}	
		
	public List getPartyUser(String spartyid,String susername,int nPage) {
	    try {
	    	String sQuery="select ul from UserLogin as ul where  ul.enable='y' and ul.party=? and (?='' or name like ?)";
		    getSession();
		    Query rs=session.createQuery(sQuery);
		    rs.setString(0,spartyid);
		    rs.setString(1,susername);
		    rs.setString(2,"%"+susername+"%");
	    	rs.setFirstResult((nPage)*QueryListKeys.QUERY_IN_EACH_PAGE);
	    	rs.setMaxResults(QueryListKeys.QUERY_IN_EACH_PAGE);    	
	    	return rs.list();	 	
	
	    } catch (HibernateException e) {
	        return null;
	    } finally {
	        closeSession();
	    }
	}	
	
	public List getUser(String stype,String sname,String snote) {
	    try {
		    getSession();
		    stype=stype.trim();
	    	String arg1[]=new String[4];
	    	NullableType arg2[]={Hibernate.STRING,Hibernate.STRING,Hibernate.STRING,Hibernate.STRING};
	    	arg1[0]=PartyKeys.CUSTOMER_ROLE_KEY;
	    	arg1[1]="%"+sname+"%";
	    	arg1[2]=snote;
	    	arg1[3]="%"+snote+"%";
	    	if (stype.equals("")) {
	    		return session.find("select ul from UserLogin as ul where  ul.enable='y' and role = ? and name like ? and (?='' or ul.note like ?)", arg1,arg2);
	    	}else{
	    		return session.find("select ul from UserLogin as ul where  ul.enable='y' and role <> ? and name like ? and (?='' or ul.note like ?)", arg1,arg2);
	    	}
			
	    } catch (HibernateException e) {
	        return null;
	    } finally {
	        closeSession();
	    }
	}
	public List getSelCust(String stype,String searchKey1,String searchKey2,String searchKey3) throws HibernateException {
	    try {
		    getSession();
		    if (searchKey1 == null) {
		        searchKey1 = "%";
		    } else {
		        searchKey1 = '%' + searchKey1.trim() + '%';
		    }
		    if (!searchKey2.equals("")) {
		        searchKey2 = '%' + searchKey2.trim() + '%';
		    }
		    if (!searchKey3.equals("")) {
		        searchKey3 = '%' + searchKey3.trim() + '%';
		    }

		    //Object[] params = { PartyKeys.CUSTOMER_ROLE_KEY, searchKey1, searchKey1};
		    //Type[] paramTypes = { Hibernate.STRING, Hibernate.STRING, Hibernate.STRING};
		    Object[] params = { PartyKeys.CUSTOMER_ROLE_KEY, searchKey1, searchKey1, searchKey2, searchKey2, searchKey3, searchKey3};
		    Type[] paramTypes = { Hibernate.STRING, Hibernate.STRING, Hibernate.STRING, Hibernate.STRING, Hibernate.STRING, Hibernate.STRING, Hibernate.STRING };

		    stype=stype.trim();
		    if (stype.equals("")) {
		    	//return session.find("select u from UserLogin u,Party p left outer join p.partyRoles r where p.partyId=u.party and r.roleTypeId = ? and (p.partyId like ? or p.description like ?) and (?='' or u.name like ?)", params, paramTypes);
		    	return session.find("select u from UserLogin u,Party p left outer join p.partyRoles r where  u.enable='y' and p.partyId=u.party and r.roleTypeId = ? and (p.partyId like ? or p.description like ?) and (?='' or u.name like ?) and (?='' or u.note like ?)", params, paramTypes);
		    }else{
		    	return session.find("select u from UserLogin u,Party p left outer join p.partyRoles r where  u.enable='y' and p.partyId=u.party and r.roleTypeId <> ? and (p.partyId like ? or p.description like ?) and (?='' or u.name like ?) and (?='' or u.note like ?)", params, paramTypes);
		    }
		} catch (HibernateException e) {
	        throw e;
	    } finally {
	        closeSession();
	    }
	}	
	
	public int getPartyUserCount(String stype,String spartyname,String susername)  throws HibernateException {
	    try {
	    	String sQuery;
		    stype=stype.trim();
	    	if (stype.equals("")){	    	
	    		sQuery="select count(u) from UserLogin u,Party p left outer join p.partyRoles r where u.enable='y' and p.partyId=u.party and r.roleTypeId = ? and (?='' or p.description like ?) and (?='' or u.name like ?)";
	    	}else{
	    		sQuery="select count(u) from UserLogin u,Party p left outer join p.partyRoles r where u.enable='y' and p.partyId=u.party and r.roleTypeId <> ? and (?='' or p.description like ?) and (?='' or u.name like ?)";
	    	}
		    getSession();
		    Query rs=session.createQuery(sQuery);
	    	rs.setString(0,PartyKeys.CUSTOMER_ROLE_KEY);
	    	rs.setString(1,spartyname);
	    	rs.setString(2,"%"+spartyname+"%");
	    	rs.setString(3,susername);
	    	rs.setString(4,"%"+susername+"%");
	    	List ls=rs.list();
	    	if(!ls.isEmpty())
			{
				Integer count = (Integer) ls.get(0);
				if(count!=null)	return count.intValue();
			}	   
	    }finally {
	        closeSession();
	    }
	    return 0;
	}	
	public List getPartyUser(String stype,String spartyname,String susername,int nPage)  throws HibernateException {
	    try {
	    	String sQuery;
		    stype=stype.trim();
	    	if (stype.equals("")){	    	
	    		sQuery="select u from UserLogin u,Party p left outer join p.partyRoles r where  u.enable='y' and p.partyId=u.party and r.roleTypeId = ? and (?='' or p.description like ?) and (?='' or u.name like ?)";
	    	}else{
	    		sQuery="select u from UserLogin u,Party p left outer join p.partyRoles r where  u.enable='y' and p.partyId=u.party and r.roleTypeId <> ? and (?='' or p.description like ?) and (?='' or u.name like ?)";
	    	}
		    getSession();
		    Query rs=session.createQuery(sQuery);
	    	rs.setString(0,PartyKeys.CUSTOMER_ROLE_KEY);
	    	rs.setString(1,spartyname);
	    	rs.setString(2,"%"+spartyname+"%");
	    	rs.setString(3,susername);
	    	rs.setString(4,"%"+susername+"%");
	    	rs.setFirstResult((nPage)*QueryListKeys.QUERY_IN_EACH_PAGE);
	    	rs.setMaxResults(QueryListKeys.QUERY_IN_EACH_PAGE);    	
	    	return rs.list();	    	
   
	    }finally {
	        closeSession();
	    }
	}		
}

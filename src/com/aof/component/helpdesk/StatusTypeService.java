/*
 * Created on 2004-12-2
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import com.aof.component.BaseServices;
import com.aof.webapp.action.ActionException;
import com.shcnc.hibernate.CompositeQuery;
import com.shcnc.hibernate.QueryCondition;

/**
 * @author yech
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class StatusTypeService extends BaseServices {
	
	public final static int STATUS_FLAG_OTHER=0;
	public final static int STATUS_FLAG_RESPONSE=1;
	public final static int STATUS_FLAG_SOLVED=2;
	public final static int STATUS_FLAG_CLOSED=3;
	public final static String QUERY_CONDITION_CALLTYPE="callType";
	public final static String QUERY_CONDITION_DISABLED="disabled";
	

	public int getCount(final Map conditions) throws HibernateException
	{
		Session sess=null;
		try{
			sess=this.getSession();
			CompositeQuery query=new CompositeQuery(
				"select count(statustype) from StatusType as statustype",
				"",session);
			appendConditions(query,conditions);
			List result=query.list();
			if(!result.isEmpty())
			{
				Integer count = (Integer) result.get(0);
				if(count!=null)	return count.intValue();
			}
		}
		finally{
			this.closeSession();
		}
		return 0;
	}
	
	public List findStatusType(final Map conditions,final int pageNo,final int pageSize )	throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			CompositeQuery query=new CompositeQuery(
					"select statustype from StatusType as statustype",
					"statustype.callType,statustype.level",session);
			appendConditions(query,conditions);
			return query.list(pageNo*pageSize,pageSize);
		}
		finally
		{
			this.closeSession();
		}
	}
	
	public List listStatusTypeGroupByCallType() throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession(); 
			List results=new ArrayList();
			List listCallTypes=sess.find("from CallType as ct");
			Iterator iterCallType=listCallTypes.iterator();
			while (iterCallType.hasNext()) {
				CallType callType=(CallType) iterCallType.next();
				List listStatusTypes=sess.find("from StatusType as st where st.callType.type=? order by st.level",callType.getType(),Hibernate.STRING);
				results.add(listStatusTypes);
			}
			return results;
		}
		finally
		{
			this.closeSession();
		}
		
	}
	
	public List listStatusType(CallType callType)  throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			List results=sess.find("from StatusType as st where st.disabled=0 and  st.callType.type=? order by st.level",callType.getType(),Hibernate.STRING);
			return results;
		}
		finally
		{
			this.closeSession();
		}
	}
	
	public List listAllStatusType(CallType callType)  throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			List results=sess.find("from StatusType as st where st.callType.type=? order by st.level",callType.getType(),Hibernate.STRING);
			return results;
		}
		finally
		{
			this.closeSession();
		}
	}
	
	public StatusType getStatusType(Session sess,int statusFlag) throws HibernateException {
		StatusType responseStatus=null;
		sess=this.getSession();
		List results=sess.find("from StatusType as st where st.flag=?",new Integer(statusFlag),Hibernate.INTEGER);
		Iterator iter=results.iterator();
		if (iter.hasNext()) {
			responseStatus=(StatusType) iter.next();
			return responseStatus;
		}
		return null;
	}
	
	public StatusType getDefaultStatusType(CallType callType)  throws HibernateException {
		StatusType statusType=null;
		List statusTypes=this.listStatusType(callType);
		Iterator iter=statusTypes.iterator();
		if (iter.hasNext()) {
			statusType=(StatusType) iter.next(); 
		}
		return statusType;
	}
	
	public StatusType findStatusType(Integer id,Session session) throws HibernateException
	{
		return (StatusType) session.get(StatusType.class,id);
	}
	
	
	private void appendConditions(final CompositeQuery query, final Map conditions) {
		final String simpleConds[][]={
			{QUERY_CONDITION_CALLTYPE,
				"statustype.callType.type=?"},
			{QUERY_CONDITION_DISABLED,
				"statustype.disabled=?"}	
		};
		for(int i=0;i<simpleConds.length;i++)
		{
			Object value=conditions.get(simpleConds[i][0]);
			if(value!=null)
			{
				if(value instanceof String &&!(((String)value).trim().equals("")))
				{
					this.makeSimpeCondition(query,simpleConds[i][1],value);
				}
			}
		}
	}
	
	public StatusType findStatusType(Integer id)throws HibernateException
	{
		Session sess=null;
		try{
			sess=this.getSession();
			return this.findStatusType(id,sess);
		}
		finally{
			this.closeSession();
		}
	}
	
	public boolean insert(StatusType statusType) throws HibernateException {
		
		Session sess = this.getSession();
		Transaction tx = null;
		try {
			tx = sess.beginTransaction();
			int insertLevel=1;
			
			CompositeQuery query=new CompositeQuery(
					"select count(st) from StatusType as st",
					"",session);
			this.makeSimpeCondition(query,"st.level<?",statusType.getLevel());
			this.makeSimpeCondition(query,"st.callType.type=?",statusType.getCallType().getType());
			List result=query.list();
			
			if(!result.isEmpty())
			{
				Integer count = (Integer) result.get(0);
				if(count!=null)	insertLevel=count.intValue()+1;
			}
			statusType.setLevel(new Integer(insertLevel));
			List statusTypes=sess.find("from StatusType as st where st.callType.type=? order by st.level asc",statusType.getCallType().getType(),Hibernate.STRING);
			Iterator iterStatusTypes=statusTypes.iterator();
			int levelIndex=1;
			while (iterStatusTypes.hasNext() ){
				StatusType updateStatusType=(StatusType) iterStatusTypes.next();
				if (levelIndex!=insertLevel) {
					updateStatusType.setLevel(new Integer(levelIndex));
				} else {
					updateStatusType.setLevel(new Integer(++levelIndex));
				}
				levelIndex++;
				sess.update(updateStatusType);
			}
			sess.save(statusType);
			sess.flush();
			tx.commit();

		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {
			this.closeSession();
		}
		return true;
	}
	
	public boolean update(StatusType statusType) throws HibernateException {
			
 		Session sess = this.getSession();

		Transaction tx = null;
		try {
			tx = sess.beginTransaction();
			int updateLevel=statusType.getLevel().intValue();
			
			
			List result=sess.find("select count(st) from StatusType as st where st.callType.type=?",statusType.getCallType().getType(),Hibernate.STRING);
			int recCount=0;
			if(!result.isEmpty())
			{
				Integer count = (Integer) result.get(0);
				if(count!=null)	recCount=count.intValue();
			}
			if (recCount<statusType.getLevel().intValue()) {
				statusType.setLevel(new Integer(recCount));
			}
			
			
			CompositeQuery query=new CompositeQuery(
					"from StatusType as st",
					"st.level asc",session);
			this.makeSimpeCondition(query,"st.id<>?",statusType.getId());
			this.makeSimpeCondition(query,"st.callType.type=?",statusType.getCallType().getType());
			
			List statusTypes=query.list();
			Iterator iterStatusTypes=statusTypes.iterator();
			int levelIndex=1;
			while (iterStatusTypes.hasNext() ){
				StatusType updateStatusType=(StatusType) iterStatusTypes.next();
				if (levelIndex!=statusType.getLevel().intValue()) {
					updateStatusType.setLevel(new Integer(levelIndex));
				} else {
					updateStatusType.setLevel(new Integer(++levelIndex));
				}
				levelIndex++;
				sess.update(updateStatusType);
			}
			
			sess.update(statusType);
			
			sess.flush();
			
			if (statusType.getFlag().intValue()>0) {
				query=new CompositeQuery(
						"from StatusType as st",
						"",session);
				QueryCondition qc=query.createQueryCondition("st.callType.type=? and st.flag>0 and ((st.flag>? and st.level<?) or (st.flag<? and st.level>?))");
				qc.appendParameter(statusType.getCallType().getType());
				qc.appendParameter(statusType.getFlag());
				qc.appendParameter(statusType.getLevel());
				qc.appendParameter(statusType.getFlag());
				qc.appendParameter(statusType.getLevel());
				List searchStatusTypes=query.list();
				if (!searchStatusTypes.isEmpty()) {
					List listResults=sess.find("from StatusType as st where st.flag>0 and st.callType.type=? order by st.flag",statusType.getCallType().getType(),Hibernate.STRING);
					Iterator iter=listResults.iterator();
					String preDefinedStatus="";
					String preDefinedStatusOrder="";
					while (iter.hasNext()) {
						StatusType preDefinedStatusType=(StatusType) iter.next();
						preDefinedStatus=preDefinedStatus+" "+preDefinedStatusType.getDesc();
						preDefinedStatusOrder= preDefinedStatusOrder+"->"+preDefinedStatusType.getDesc();
					}
					preDefinedStatus=preDefinedStatus.substring(1);
					preDefinedStatusOrder=preDefinedStatusOrder.substring(2);
					tx.rollback();
					throw new ActionException("helpdesk.statusType.error.order",preDefinedStatus,preDefinedStatusOrder);
				}
			}
			tx.commit();

		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {
			this.closeSession();
		}
		return true;
	}
	
	public static boolean hasResponse(CallMaster call) {
		return (call.getStatus().getFlag().intValue()==STATUS_FLAG_RESPONSE)?true:false;
	}

	public static boolean hasSolved(CallMaster call) {
		return (call.getStatus().getFlag().intValue()==STATUS_FLAG_SOLVED)?true:false;
	}
	
	public static boolean hasClosed(CallMaster call) {
		return (call.getStatus().getFlag().intValue()==STATUS_FLAG_CLOSED)?true:false;
	}
	
}

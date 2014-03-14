/*
 * Created on 2004-11-24
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.util.List;
import java.util.Map;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import com.aof.component.BaseServices;
import com.shcnc.hibernate.CompositeQuery;
import com.shcnc.hibernate.QueryCondition;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CustConfigTableTypeService extends BaseServices {
	public static final String QUERY_CONDITION_DESC="desc";
	public static final String QUERY_CONDITION_DISABLED="disabled";
	
	public void deleteColumn(Integer columnId,Session sess) throws HibernateException
	{
		session.delete("from CustConfigSimpleItem as item where item.column.id=?",columnId,Hibernate.INTEGER);
		session.flush();
	}
	
	public CustConfigTableType getTableType(Integer id)throws HibernateException
	{
		Session sess=null;
		try{
			sess=this.getSession();
			return this.getTableType(id,sess);
		}
		finally{
			this.closeSession();
		}
	}
	
	public CustConfigTableType getTableType(Integer id,Session session) throws HibernateException
	{
		return (CustConfigTableType) session.get(CustConfigTableType.class,id);
	}
	
	public void disableTableType(Integer id) throws HibernateException
	{
		Session sess = this.getSession();
		Transaction tx = null;
		try{
			tx = sess.beginTransaction();
			CustConfigTableType type=getTableType(id,session);
			if(type!=null)
			{
				type.setDisabled(Boolean.TRUE);
				sess.update(type);
				sess.flush();
				tx.commit();
			}
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {
			this.closeSession();
		}
	}
	
	public void insertTableType(CustConfigTableType type)throws HibernateException
	{ 
		Session sess = this.getSession();
		Transaction tx = null;
		try{
			tx = sess.beginTransaction();
			type.getModifyLog().setCreateDate(new java.util.Date());
			type.getModifyLog().setModifyDate(new java.util.Date());
			sess.save(type);
			//sess.flush();
			tx.commit();
		}
		catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {
			this.closeSession();
		}
	}
	
	public void updateTableType(CustConfigTableType type,Session sess)throws HibernateException
	{
		type.getModifyLog().setModifyDate(new java.util.Date());
		sess.update(type);
		sess.flush();
	}
	
	public List listTableType()throws HibernateException
	{
		Session sess=null;
		try{
			sess=this.getSession();
			return sess.find("from CustConfigTableType as tableType where tableType.disabled=0 order by tableType.name");
		}
		finally{
			this.closeSession();
		}
	}

	public List listAllTableType()throws HibernateException
	{
		Session sess=null;
		try{
			sess=this.getSession();
			return sess.find("from CustConfigTableType as tableType order by tableType.name");
		}
		finally{
			this.closeSession();
		}
	}

	public int getCount(final Map conditions) throws HibernateException
	{
		Session sess=null;
		try{
			sess=this.getSession();
			CompositeQuery query=new CompositeQuery(
				"select count(tabletype) from CustConfigTableType as tabletype",
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
	
	private void appendConditions(final CompositeQuery query, final Map conditions) {
		final String simpleConds[][]={
				{QUERY_CONDITION_DISABLED,
					"tabletype.disabled=?"}	
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
		//like para 
		final String listConds[][]={
			{QUERY_CONDITION_DESC,
				"tabletype.name like ?"}	
		};
		for(int i=0;i<listConds.length;i++)
		{
			Object value=conditions.get(listConds[i][0]);
			if(value!=null)
			{
				this.makeSimpeLikeCondition(query,listConds[i][1],value);
			}
		}
	}

	public List findTableType(final Map conditions,final int pageNo,final int pageSize )	throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			CompositeQuery query=new CompositeQuery(
				"select tabletype from CustConfigTableType as tabletype",
				"tabletype.name",session);
			appendConditions(query,conditions);
			return query.list(pageNo*pageSize,pageSize);
		}
		finally
		{
			this.closeSession();
		}
	}
	
}

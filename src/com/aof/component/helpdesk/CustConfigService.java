/*
 * Created on 2004-11-22
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.util.List;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.Party;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CustConfigService extends BaseServices {
	public CustConfigTable getTable(Integer id,Session session) throws HibernateException
	{
		return (CustConfigTable) session.get(CustConfigTable.class,id);
	}
	public CustConfigTable getTable(Integer id) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			return this.getTable(id,session);
		}
		finally{
			this.closeSession();
		}
	}

	public List listCompanyConfigTables(String companyID) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			return session.find("from CustConfigTable as table where table.company.partyId=?",
				companyID,Hibernate.STRING);
		}
		finally{
			this.closeSession();
		}
	}
	public List listRows(Integer tableID) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			return session.find("from CustConfigRow as row where row.table.id=?",
				tableID,Hibernate.INTEGER);
		}
		finally{
			this.closeSession();
		}
	}
	//no page support now
	public List listRows(Integer tableID,int pageNo,int pageSize)
	{
		return null;
	}
	//insert row,items
	public void insertRow(CustConfigRow row) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			//we have set items cascade="all-delete-orphan"
			session.save(row);
			session.flush();
		}
		finally{
			this.closeSession();
		}
	}
	//delete items,insert items
	public void updateRow(CustConfigRow row) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			//we have set items cascade="all-delete-orphan"
			session.update(row);
			session.flush();
		}
		finally{
			this.closeSession();
		}
	}
	//delete row,item
	public void deleteRow(Integer rowid) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			CustConfigRow row=(CustConfigRow) session.get(CustConfigRow.class,rowid);
			if (row!=null)
			{
				//we have set items cascade="all-delete-orphan"
				session.delete(row);
			}
			session.flush();
		}
		finally{
			this.closeSession();
		}
	}
	//column name only
	public void insertColumn(CustConfigColumn column) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			session.save(column);
			session.flush();
		}
		finally{
			this.closeSession();
		}
	}
	//change name only
	public void updateColumn(CustConfigColumn column) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			session.update(column);
			session.flush();
		}
		finally{
			this.closeSession();
		}
	}
	//delete column,item
	/*public void deleteColumn(Integer columnid) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			CustConfigColumn column=(CustConfigColumn) session.get(CustConfigColumn.class,columnid);
			if (column!=null)
			{
				session.delete("from CustConfigItem as item where item.id.column.id=?",columnid,Hibernate.INTEGER);
				session.delete(column);
			}
		}
		finally{
			this.closeSession();
		}
	}*/
	//table name only
	public void insertTable(CustConfigTable table) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			session.save(table);
			session.flush();
		}
		finally{
			this.closeSession();
		}
	}
	//change name only
	public void updateTable(CustConfigTable table) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			session.update(table);
			session.flush();
		}
		finally{
			this.closeSession();
		}
	}
	//delete table,column,row,item
	public void deleteTable(Integer tableid) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			//detete row, item 
			//we have set items cascade="all-delete-orphan"
			session.delete("from CustConfigRow as row where row.table.id=?",tableid,Hibernate.INTEGER);
			//delte table
			session.delete("from CustConfigTable as table where table.id=?",tableid,Hibernate.INTEGER);
			session.flush();
		}
		finally{
			this.closeSession();
		}
	}
	/**
	 * @param columnID
	 * @return
	 * @throws HibernateException
	 */
	public CustConfigColumn getColumn(Integer columnID) throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			return this.getColumn(columnID,sess);
		}
		finally{
			this.closeSession();
		}
		
		
	}
	public CustConfigColumn getColumn(Integer columnID,Session session) throws HibernateException {
		return (CustConfigColumn) session.get(CustConfigColumn.class,columnID);
	}
	/**
	 * @param rowID
	 * @return
	 * @throws HibernateException
	 */
	public CustConfigRow getRow(Integer rowID) throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			return this.getRow(rowID,sess);
		}
		finally{
			this.closeSession();
		}
	}
	public CustConfigRow getRow(Integer rowID,Session session) throws HibernateException {
		return (CustConfigRow) session.get(CustConfigRow.class,rowID);
	}
	/**
	 * @param partyId
	 * @return
	 * @throws HibernateException
	 */
	public List getUsedTypeList(String partyId) throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			return sess.find("select table.tableType from CustConfigTable as table where table.company.partyId=?",
					partyId,Hibernate.STRING);
		}
		finally{
			this.closeSession();
		}
	}
}

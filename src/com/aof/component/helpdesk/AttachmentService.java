/*
 * Created on 2004-11-18
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import com.aof.component.BaseServices;

/**
 * @author shilei
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class AttachmentService extends BaseServices {
	public DetailAttachment getDetail(Integer id) throws HibernateException, IllegalAccessException, InvocationTargetException {
		Session sess=null;

		try{
			sess=this.getSession();
			return getDetail(id,session);
		}
		finally{
			this.closeSession();
		}

	}
	
	/**
	 * @param id
	 * @param session
	 * @return
	 * @throws HibernateException
	 * @throws InvocationTargetException
	 * @throws IllegalAccessException
	 */
	private static DetailAttachment getDetail(Integer id, Session session) 
		throws HibernateException, IllegalAccessException, InvocationTargetException {
		Attachment attach=(Attachment) session.get(Attachment.class,id);
		if(attach==null) return null;
		DetailAttachment detail=new DetailAttachment();
		BeanUtils.copyProperties(detail,attach);
		List l=session.find("select detail.content from DetailAttachment as detail where detail.id=?",
			id,Hibernate.INTEGER);
		if (l.size()==1)
		{
			detail.setContent((byte[]) l.get(0));
		}
		return detail;
	}

	public Attachment get(Integer id) throws HibernateException {
		Session sess=null;

		try{
			sess=this.getSession();
			return get(id,session);
		}
		finally{
			this.closeSession();
		}
	}
	
	public Attachment get(Integer id,Session session) throws HibernateException{
		return (Attachment) session.get(Attachment.class,id);
	}
	
	public List list(String groupID) throws HibernateException {
		Session sess=null;

		try{
			sess=this.getSession();
			return sess.find("from Attachment as attch where attch.groupid=? and attch.deleted=0",groupID,Hibernate.STRING);
		}
		finally{
			this.closeSession();
		}
	}
	public boolean insert(DetailAttachment attach) throws HibernateException {
		Session sess=null;
		Transaction tx = null;
		try{
			sess=this.getSession();
			tx=sess.beginTransaction();
			sess.save(attach);
			sess.flush();
			tx.commit();
		}
		catch (HibernateException e) {
		    if (tx != null)
		    {
		        e.printStackTrace();
				try {
					tx.rollback();
				} catch (HibernateException e1) {
					throw e1;
				}
				throw e;
		    }
		}
		finally{
			this.closeSession();
		}
		return true;
	}
	public boolean delete(Integer id) throws HibernateException {
		Session sess=null;
		Transaction tx = null;
		try{
			sess=this.getSession();
			Attachment attach= this.get(id,sess);
			attach.setDeleted(true);
			sess.update(attach);
			sess.flush();
		}
		catch (HibernateException e) {
			e.printStackTrace();
			if (tx != null)
			try {
				tx.rollback();
			} catch (HibernateException e1) {
//				throw e1;
			}
			throw e;
		}
		finally{
			this.closeSession();
		}
		return false;
	}

	public static boolean deleteGroup(String groupId, Session sess) throws HibernateException {
	    List l = sess.find("from Attachment a where a.groupid = ?", groupId, Hibernate.STRING);
	    for (int i = 0; i < l.size(); i++) {
	        sess.delete(l.get(i));
	    }
	    return true;
	}
	
	public static boolean copyGroup(String toGroupId, String fromGroupId, Session sess) throws Exception {
	    List l = sess.find("select attach.id from Attachment attach where attach.groupid = ? and attach.deleted = 0", fromGroupId, Hibernate.STRING);
	    for (int i = 0; i < l.size(); i++) {
	        DetailAttachment da = getDetail((Integer)l.get(i), sess);
	        da.setId(null);
	        da.setGroupid(toGroupId);
	        sess.save(da);
	    }
	    return true;
	}
}

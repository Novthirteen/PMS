/*
 * Created on 2004-11-16
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.util.Date;
import java.util.List;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.ActionType;
import com.aof.component.helpdesk.servicelevel.SLACategory;
import com.aof.component.helpdesk.servicelevel.SLACategoryService;
import com.aof.component.helpdesk.CallType;
import com.aof.component.helpdesk.CallTypeService;
import com.aof.component.BaseServices;
import com.aof.webapp.action.ActionException;

/**
 * @author yech
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ActionTypeService extends BaseServices {
	
	public ActionType find(Integer actionid){
		if (actionid == null) return null;
		try {
		    getSession();
		    return find(actionid, session);
		} catch (HibernateException e) {
		    e.printStackTrace();
		} finally {
		    closeSession();
		}
        return null;
	}

    public static ActionType find(Integer id, Session sess) throws HibernateException {
        return (ActionType)sess.get(ActionType.class, id);
    }
	
    public ActionType insert(ActionType newone, UserLogin user) throws Exception {
		Transaction tx = null;
	    
	    try {
	        getSession();
		    tx = session.beginTransaction();
		    session.save(newone);
		    tx.commit();
		    return newone;
        } catch (Exception e) {
            try {
                if (tx != null) tx.rollback();
            } catch (HibernateException e1) { }
            throw e;
        } finally {
    	    closeSession();
        }
    }

    public ActionType update(ActionType newone, UserLogin user) throws Exception {
		Transaction tx = null;
	    
	    try {
		    String actiondesc;
		    boolean actiondisabled = false;

		    getSession();
		    tx = session.beginTransaction();
		    ActionType oldone = find(newone.getActionid(), session);
		    if (oldone == null) throw new ActionException("call.actiontype.error.notfound");
		    actiondesc = newone.getActiondesc();
		    actiondisabled = newone.getActiondisabled();
		    oldone.setActiondesc(actiondesc);
		    oldone.setActiondisabled(actiondisabled);
		    session.update(oldone);
		    tx.commit();
		    return oldone;
        } catch (HibernateException e) {
            try {
                if (tx != null) tx.rollback();
            } catch (HibernateException el) { }
            throw e;
        } finally {
    	    closeSession();
        }
    }
    
	public List listActionTypes() throws HibernateException	{
		Session sess = this.getSession();
		List actionTypes=sess.createQuery("select actionType from ActionType actionType where actionType.actiondisabled=0").list();
		return actionTypes;
	}
	
	public List listAllActionTypes() throws HibernateException	{
		Session sess = this.getSession();
		List actionTypes=sess.createQuery("select actionType from ActionType actionType").list();
		return actionTypes;
	}
		
	public List listActionTypes(CallType callType) throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			List results=sess.find("from ActionType as at where at.callType.type=? and  at.actiondisabled=0",callType.getType(),Hibernate.STRING);
			return results;
		}
		finally
		{
			this.closeSession();
		}
	}
	
	public List listAllActionTypes(CallType callType) throws HibernateException	{
		Session sess=null;
		try{
			sess=this.getSession();
			List results=sess.find("from ActionType as at where at.callType.type=?",callType.getType(),Hibernate.STRING);
			return results;
		}
		finally
		{
			this.closeSession();
		}
	}
	
}

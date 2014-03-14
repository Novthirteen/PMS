/*
 * Created on 2004-12-3
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.util.Iterator;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import com.aof.component.BaseServices;
import com.aof.webapp.action.ActionException;

/**
 * @author yech
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CallTypeService extends BaseServices {
	
	public List listCallType() throws HibernateException
	{
		try {
		    getSession();
		    return listCallType(session);
		} 
		finally{
			this.closeSession();
		}
	}
	public static List listCallType(Session sess) throws HibernateException
	{
	    return sess.find("from CallType as ct order by ct.type");
	}
	
	public CallType getCallTypeByActionPath(final String actionPath) throws HibernateException
	{
		try{
		    getSession();
		    return getCallTypeByActionPath(actionPath, session);
		} 
		finally{
			this.closeSession();
		}
	}
	
	/**
	 * @param actionPath
	 * @param sess
	 * @return
	 * @throws HibernateException
	 */
	private static CallType getCallTypeByActionPath(final String actionPath, final Session sess) throws HibernateException {
		final String path=actionPath.toLowerCase();
		Iterator itor=listCallType(sess).iterator();
		while(itor.hasNext())
		{
			CallType callType=(CallType) itor.next();
			final String name=callType.getName().toLowerCase();
			if(path.indexOf(name)!=-1)
			{
				return callType;
			}
		}
		return null;
	}

	public CallType getDefaultCallType() throws HibernateException
	{
		CallType callType=null;
		List callTypes=this.listCallType();
		Iterator iter=callTypes.iterator();
		if (iter.hasNext()) {
			callType=(CallType) iter.next();
		}
		return callType;
	}

	public CallType find(String type) throws HibernateException {
	    try {
	        getSession();
	        return find(type, session);
	    } finally {
	        closeSession();
	    }
	}
	
    public static CallType find(String type, Session sess) throws HibernateException {
        return (CallType) sess.get(CallType.class, type);
    }
	
}
 
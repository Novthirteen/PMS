/*
 * Created on 2004-12-17
 *
 */
package com.aof.component.helpdesk;


import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import com.aof.component.BaseServices;
import com.aof.webapp.action.ActionException;
import com.shcnc.hibernate.CompositeQuery;

/**
 * @author nicebean
 *
 */
public class RequestTypeService extends BaseServices {
	public RequestType find(Integer id) throws HibernateException {
		if (id == null) return null;
		try {
		    getSession();
		    return find(id, session);
		} finally {
		    closeSession();
		}
	}

    public static RequestType find(Integer id, Session sess) throws HibernateException {
        return (RequestType)sess.get(RequestType.class, id);
    }
	
    public RequestType insert(RequestType newone) throws HibernateException {
	    try {
	        getSession();
			session.save(newone);
			session.flush();
		    return newone;
        } finally {
    	    closeSession();
        }
    }

    public RequestType update(RequestType newone) throws HibernateException {
	    try {
		    String description;
		    boolean disabled;

		    getSession();
		    RequestType oldone = find(newone.getId(), session);
		    if (oldone == null) throw new ActionException("helpdesk.call.requesttype.error.notfound");
		    description = newone.getDescription();
		    disabled = newone.getDisabled();
		    oldone.setDescription(description);
		    oldone.setDisabled(disabled);
		    session.update(oldone);
		    session.flush();
		    return oldone;
        } finally {
    	    closeSession();
        }
    }

    public RequestType delete(Integer id) throws HibernateException {
		if (id == null) throw new ActionException("helpdesk.call.requesttype.error.notfound");

		try {
            getSession();
            RequestType oldone = find(id, session);
		    if (oldone == null) throw new ActionException("helpdesk.call.requesttype.error.notfound");
		    session.delete(oldone);
		    session.flush();
            return oldone;
        } finally {
            closeSession();
        }
    }

    public final static String QUERY_CONDITION_DESC = "description";
    public final static String QUERY_CONDITION_CALLTYPE = "callType";
    public final static String QUERY_CONDITION_DISABLED = "disabled";
    private final static String QUERY_CONDITIONS[][] = {
        { QUERY_CONDITION_DESC, "r.description like ?" },
        { QUERY_CONDITION_CALLTYPE, "r.callType.type = ?" },
        { QUERY_CONDITION_DISABLED, "r.disabled = ?" }
    };

    private void appendConditions(CompositeQuery query, Map conditions) {
		for (int i = 0; i < QUERY_CONDITIONS.length; i++) {
			Object value = conditions.get(QUERY_CONDITIONS[i][0]);
			if (value != null) {
			    if (QUERY_CONDITIONS[i][0].equals(QUERY_CONDITION_DESC)) {
			        makeSimpeLikeCondition(query, QUERY_CONDITIONS[i][1], value);
			    } else if (QUERY_CONDITIONS[i][0].equals(QUERY_CONDITION_DISABLED)) {
			        makeSimpeCondition(query, QUERY_CONDITIONS[i][1], value.equals("true") ? Boolean.TRUE : Boolean.FALSE);
			    } else {
			        makeSimpeCondition(query, QUERY_CONDITIONS[i][1], value);
			    }
			}
		}
    }

    public int getListCount(Map conditions) throws HibernateException {
        try {
            getSession();
			CompositeQuery query = new CompositeQuery("select count(r) from RequestType r", "", session);
			appendConditions(query, conditions);
			List result = query.list();
			if (!result.isEmpty()) {
				Integer count = (Integer)result.get(0);
				if (count != null) return count.intValue();
			}
			return 0;
        } finally {
            closeSession();
        }
    }

    public List list(Map conditions, int pageNo, int pageSize) throws HibernateException {
        try {
            getSession();
			CompositeQuery query = new CompositeQuery("from RequestType r", "", session);
			appendConditions(query, conditions);
			return query.list(pageNo * pageSize, pageSize);
        } finally {
            closeSession();
        }
    }
    
    public List listAllEnabledByCallType(String callType) throws HibernateException {
        try {
            getSession();
            return session.find("from RequestType r where r.disabled = 0 and r.callType.type = ?", callType, Hibernate.STRING);
        } finally {
            closeSession();
        }
    }
    public List listAllEnabledByCallType(CallType callType) throws HibernateException {
    	return listAllEnabledByCallType(callType.getType());
    }
    
    public RequestType getDefaultRequestType(CallType callType) throws HibernateException
	{
		return getDefaultRequestType(callType.getType());
	}
    public RequestType getDefaultRequestType(String callType) throws HibernateException
	{
    	RequestType retVal=null;
		List RequestTypes=this.listAllEnabledByCallType(callType);
		Iterator iter=RequestTypes.iterator();
		if (iter.hasNext()) {
			retVal=(RequestType) iter.next();
		}
		return retVal;
	}
}

/*
 * Created on 2004-11-15
 *
 */
package com.aof.component.helpdesk.servicelevel;

import java.util.Date;
import java.util.List;
import java.util.Map;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.ModifyLog;
import com.aof.webapp.action.ActionException;
import com.shcnc.hibernate.CompositeQuery;

/**
 * @author nicebean
 *
 */
public class SLAMasterService extends BaseServices {
    public SLAMaster find(Integer id) {
		if (id == null) return null;
		try {
		    getSession();
		    return find(id, session);
		} catch (HibernateException e) {
		    e.printStackTrace();
		} finally {
		    closeSession();
		}
        return null;
    }
    
    public static SLAMaster find(Integer id, Session sess) throws HibernateException {
        return (SLAMaster)sess.get(SLAMaster.class, id);
    }
    
    public SLAMaster insert(SLAMaster newone, UserLogin user) throws HibernateException {
		Transaction tx = null;
	    
	    try {
	        getSession();
		    tx = session.beginTransaction();
			ModifyLog mlog = new ModifyLog();
			mlog.setCreateDate(new Date());
			mlog.setCreateUser(user);
			newone.setModifyLog(mlog);
			if (newone.getActive().charAt(0) == 'Y') {
			    disableOtherSLA(newone);
			}
			session.save(newone);
		    tx.commit();
		    return newone;
        } catch (HibernateException e) {
            try {
                if (tx != null) tx.rollback();
            } catch (HibernateException e1) { }
            throw e;
        } finally {
    	    closeSession();
        }
    }

    public SLAMaster update(SLAMaster newone, UserLogin user) throws Exception {
		Transaction tx = null;
	    
	    try {
		    String active, desc;
		    boolean modified = false;

		    getSession();
		    tx = session.beginTransaction();
		    SLAMaster oldone = find(newone.getId(), session);
		    if (oldone == null) throw new ActionException("helpdesk.servicelevel.master.error.notfound");
		    active = newone.getActive();
		    desc = newone.getDesc();
		    modified = !isEqual(active, oldone.getActive()) || !isEqual(desc, oldone.getDesc());
		    if (modified) {
		        oldone.setActive(active);
		        oldone.setDesc(desc);
		        ModifyLog mlog = oldone.getModifyLog();
		        mlog.setModifyDate(new Date());
		        mlog.setModifyUser(user);
				if (active.charAt(0) == 'Y') {
				    disableOtherSLA(oldone);
				}
				session.update(oldone);
		    }
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
    
    public void delete(Integer id) throws Exception {
        Transaction tx = null;
		try {
		    getSession();
            tx = session.beginTransaction();
		    SLAMaster master = find(id, session);
		    if (master.getActive().charAt(0) == 'Y' && master.getParty() == null) throw new ActionException("helpdesk.servicelevel.master.error.cannotdeleteactive");
		    session.delete(master);
		    try {
	            session.flush();
		    } catch (Exception e){
                try {
                    tx.rollback();
                } catch (Exception ee) { }
		    	throw new ActionException("helpdesk.servicelevel.master.error.cannotdelete");
		    }
            tx.commit();
		} finally {
		    closeSession();
		}
    }

    private void disableOtherSLA(SLAMaster thisone) throws HibernateException {
        Party party = thisone.getParty();
	    List l = null;
	    if (party == null) {
	        l = session.find("from SLAMaster master where master.party.id is null");
	    } else {
	        l = session.find("from SLAMaster master where master.party.id = ?", party.getPartyId(), Hibernate.STRING);
	    }
	    for (int i = 0; i < l.size(); i++) {
	        SLAMaster sla = (SLAMaster)l.get(i);
	        if (sla.equals(thisone)) continue;
	        if (sla.getActive().charAt(0) == 'Y') {
	            sla.setActive("N");
	        }
	    }
	    session.flush();
    }

	public  List getAll() throws Exception {
		try{
		getSession();
		return session.find("select sla from SLAMaster as sla");
		}catch(Exception e){
	        throw e;
	    } finally {
	        closeSession();
	    }
		  
	}
	
	public SLAMaster findActiveByPartyId(String partyId) throws Exception {
	    try {
	        getSession();
		    List l = null;
		    if (partyId != null) {
		        l = session.find("from SLAMaster master where master.party.id = ? and master.active = 'Y'", partyId, Hibernate.STRING);
		    }
		    if (l == null || l.size() == 0) {
		        l = session.find("from SLAMaster master where master.party.id is null and master.active = 'Y'");
		    }
		    if (l.size() == 0) throw new ActionException("helpdesk.servicelevel.master.error.nodefaultactive");
		    return (SLAMaster)l.get(0);
	    } finally {
	        closeSession();
	    }
	}

    public final static String QUERY_CONDITION_DESC = "desc";
    public final static String QUERY_CONDITION_CUSTOMER = "customer";
    public final static String QUERY_CONDITION_ACTIVE = "active";
    private final static String QUERY_CONDITIONS[][] = {
        { QUERY_CONDITION_DESC, "master.desc like ?" },
        { QUERY_CONDITION_CUSTOMER, "(master.party.description like ? or master.party.partyId like ?)" },
        { QUERY_CONDITION_ACTIVE, "master.active = ?" }
    };
    
    private void appendConditions(CompositeQuery query, Map conditions) {
		for (int i = 0;i < QUERY_CONDITIONS.length; i++) {
			Object value = conditions.get(QUERY_CONDITIONS[i][0]);
			if (value != null) {
			    if (QUERY_CONDITIONS[i][0].equals(QUERY_CONDITION_DESC)) {
			        makeSimpeLikeCondition(query, QUERY_CONDITIONS[i][1], value);
			    } else if (QUERY_CONDITIONS[i][0].equals(QUERY_CONDITION_CUSTOMER)) {
			        Object[] para = { value, value };
			        makeSimpeLikeCondition(query, QUERY_CONDITIONS[i][1], para);
			    } else if (QUERY_CONDITIONS[i][0].equals(QUERY_CONDITION_ACTIVE)) {
			        makeSimpeCondition(query, QUERY_CONDITIONS[i][1], value);
			    }
			}
		}
    }

    public int getListCount(Map conditions) throws HibernateException {
        try {
            getSession();
			CompositeQuery query = new CompositeQuery("select count(master) from SLAMaster master", "", session);
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
    
    public List getList(Map conditions, int pageNo, int pageSize) throws HibernateException {
        try {
            getSession();
			CompositeQuery query = new CompositeQuery("from SLAMaster master", "", session);
			appendConditions(query, conditions);
			return query.list(pageNo * pageSize, pageSize);
        } finally {
            closeSession();
        }
    }
    
}

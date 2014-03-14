/*
 * Created on 2004-11-19
 *
 */
package com.aof.component.helpdesk.servicelevel;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.ModifyLog;
import com.aof.webapp.action.ActionException;

/**
 * @author nicebean
 * 
 *  
 */
public class SLAPriorityService extends BaseServices {
   
    public SLAPriority find(Integer id) {
        if (id == null)
            return null;
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

    public static SLAPriority find(Integer id, Session sess) throws HibernateException {
        return (SLAPriority) sess.get(SLAPriority.class, id);
    }

    public SLAPriority insert(SLAPriority newone, UserLogin user) throws Exception {
        Transaction tx = null;

        try {
            getSession();
            tx = session.beginTransaction();
            SLACategory category = SLACategoryService.findFirstClass(newone.getCategory().getId(), session);
            newone.setCategory(category);
            ModifyLog mlog = new ModifyLog();
            mlog.setCreateDate(new Date());
            mlog.setCreateUser(user);
            newone.setModifyLog(mlog);
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

    public SLAPriority update(SLAPriority newone, UserLogin user) throws Exception {
    	Transaction tx = null;
    	try {
    		String chsDesc,engDesc;
    		boolean modified = false;
    		Integer responseTime, solveTime, closeTime, responseWarningTime, solveWarningTime, closeWarningTime;
            getSession();
            tx = session.beginTransaction();
            SLAPriority oldone = find(newone.getId(), session);
            if (oldone == null) throw new ActionException("helpdesk.servicelevel.priority.error.notfound");
            chsDesc = newone.getChsDesc();
            engDesc = newone.getEngDesc();
            responseTime = newone.getResponseTime() ;
            solveTime = newone.getSolveTime() ;
            closeTime = newone.getCloseTime() ;
            responseWarningTime = newone.getResponseWarningTime() ;
            solveWarningTime = newone.getSolveWarningTime();
            closeWarningTime = newone.getCloseWarningTime();
            modified = !isEqual(chsDesc, oldone.getChsDesc())
                    || !isEqual(engDesc, oldone.getEngDesc())
                    || !isEqual(responseTime, oldone.getResponseTime()) 
					|| !isEqual(solveTime, oldone.getSolveTime())
					|| !isEqual(closeTime, oldone.getCloseTime())
					|| !isEqual(responseWarningTime, oldone.getResponseWarningTime())
					|| !isEqual(solveWarningTime, oldone.getSolveWarningTime())
					|| !isEqual(closeWarningTime, oldone.getCloseWarningTime());
            if (modified) {
                oldone.setChsDesc(chsDesc);
                oldone.setEngDesc(engDesc);
                oldone.setResponseTime(responseTime);
                oldone.setSolveTime(solveTime);
                oldone.setCloseTime(closeTime);
                oldone.setResponseWarningTime(responseWarningTime);
                oldone.setSolveWarningTime(solveWarningTime);
                oldone.setCloseWarningTime(closeWarningTime);
                ModifyLog mlog = oldone.getModifyLog();
                mlog.setModifyDate(new Date());
                mlog.setModifyUser(user);
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
            SLAPriority priority = find(id, session);
            if (priority == null) throw new ActionException("helpdesk.servicelevel.priority.error.notfound");
            session.delete(priority);
		    try {
	            session.flush();
		    } catch (Exception e){
                try {
                    tx.rollback();
                } catch (Exception ee) { }
		    	throw new ActionException("helpdesk.servicelevel.priority.error.cannotdelete");
		    }
            tx.commit();
        } catch (Exception e) {
            throw e;
        } finally {
            closeSession();
        }
    }

    public List getAll() throws Exception {
        try {
            getSession();
            return session.find("from SLAPriority p");
        } catch (Exception e) {
            throw e;
        } finally {
            closeSession();
        }

    }

    public List getPrioritiesForCategory(SLACategory category, Locale locale) throws Exception {
        if (category == null) return new ArrayList();
        return getPrioritiesForCategory(category.getId(), locale);
    }

    public List getPrioritiesForCategory(Integer categoryid, Locale locale) throws Exception {
        if (categoryid == null) return new ArrayList();
        try {
            getSession();
            Integer parentId = categoryid;
            do {
                categoryid = parentId;
                List l = session.find("select c.parentId from SLACategory c where c.id = ?", categoryid, Hibernate.INTEGER);
                if (l.size() == 0) return new ArrayList();
                parentId = (Integer)l.get(0); 
            } while (parentId != null);
            List l = session.find("from SLAPriority p where p.category.id = ? order by p.id", categoryid, Hibernate.INTEGER);
            for (int i = 0; i < l.size(); i++) {
                SLAPriority p = (SLAPriority)l.get(i);
                p.setLocale(locale);
                p.getCategory().setLocale(locale);
            }
            return l;
        } catch (Exception e) {
            throw e;
        } finally {
            closeSession();
        }
    }

    public List getPrioritiesForMaster(SLAMaster master, Locale locale) throws Exception {
        if (master == null) return new ArrayList();
        return getPrioritiesForMaster(master.getId(), locale);
    }
    
    public List getPrioritiesForMaster(Integer masterid, Locale locale) throws Exception {
        if (masterid == null) return new ArrayList();
        try {
            getSession();
            List l = session.find("select p from SLAPriority p, SLACategory c where p.category.id = c.id and c.parentId is null and c.master.id = ? order by p.category.id, p.id", masterid, Hibernate.INTEGER);
            for (int i = 0; i < l.size(); i++) {
                SLAPriority p = (SLAPriority)l.get(i);
                p.setLocale(locale);
                p.getCategory().setLocale(locale);
            }
            return l;
        } catch (Exception e) {
            throw e;
        } finally {
            closeSession();
        }
    }
}
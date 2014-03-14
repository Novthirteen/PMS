/*
 * Created on 2004-11-26
 *
 */
package com.aof.component.helpdesk.kb;


import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;

import com.aof.component.BaseServices;
import com.aof.component.helpdesk.AttachmentService;
import com.aof.component.helpdesk.CallActionHistory;
import com.aof.component.helpdesk.CallActionTrackService;
import com.aof.component.helpdesk.CallMaster;
import com.aof.component.helpdesk.CallService;
import com.aof.component.helpdesk.servicelevel.SLACategory;
import com.aof.webapp.action.ActionException;
import com.shcnc.hibernate.CompositeQuery;
import com.shcnc.struts.form.TimeFormatter;
import com.shcnc.utils.UUID;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;


/**
 * @author nicebean
 *
 */
public class KnowledgeBaseService extends BaseServices {
	public static final String QUERY_CONDITION_SEARCHWORD="searchword";
	public static final String QUERY_CONDITION_SELECT="select";
	public static final String QUERY_CONDITION_CATEGORYID="categoryid";

    public SimpleKnowledgeBase findSimple(Integer id) {
		if (id == null) return null;
		try {
		    getSession();
		    return findSimple(id, session);
		} catch (Exception e) {
		    e.printStackTrace();
		} finally {
		    closeSession();
		}
	    return null;
    }

    public KnowledgeBase find(Integer id) {
		if (id == null) return null;
		try {
		    getSession();
		    return find(id, session);
		} catch (Exception e) {
		    e.printStackTrace();
		} finally {
		    closeSession();
		}
	    return null;
    }
    
    public static SimpleKnowledgeBase findSimple(Integer id, Session sess) throws HibernateException {
        return (SimpleKnowledgeBase)sess.get(SimpleKnowledgeBase.class, id);
    }

    public static KnowledgeBase find(Integer id, Session sess) throws Exception {
        SimpleKnowledgeBase skb = findSimple(id, sess);
        if (skb == null) return null;
        KnowledgeBase kb = new KnowledgeBase();
        BeanUtils.copyProperties(kb, skb);
        try {
	        List l = sess.find("select kb.solution from KnowledgeBase kb where kb.id = ?", id, Hibernate.INTEGER);
	        if (l.size() > 0) {
	            kb.setSolution((String)l.get(0));
	        }
        } catch (Exception e) { }
        return kb;
    }

    public KnowledgeBase insert(KnowledgeBase newone) throws HibernateException {
		Transaction tx = null;
	    
	    try {
	        getSession();
		    tx = session.beginTransaction();
			insert(newone, session);
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

    public static KnowledgeBase insert(KnowledgeBase newone, Session sess) throws HibernateException {
        sess.save(newone);
        return newone;
    }
    
    public KnowledgeBase update(KnowledgeBase newone) throws Exception {
        return (KnowledgeBase)update((SimpleKnowledgeBase)newone);
    }

    public SimpleKnowledgeBase update(SimpleKnowledgeBase newone) throws Exception {
		Transaction tx = null;
	    
	    try {
		    SimpleKnowledgeBase oldone = null;
		    if (newone instanceof KnowledgeBase) {
		        oldone = find(newone.getId());
		    } else {
		        oldone = findSimple(newone.getId());
		    }
		    if (oldone == null) throw new ActionException("helpdesk.kb.error.notfound");
		    getSession();
		    tx = session.beginTransaction();
		    oldone.setCategory(newone.getCategory());
	        oldone.setCustomer(newone.getCustomer() == null ? null : oldone.getOriginalCustomer());
		    oldone.setSubject(newone.getSubject());
		    //oldone.setKeyword(newone.getKeyword());
		    oldone.setProblemDesc(newone.getProblemDesc());
		    oldone.setPublished(newone.getPublished());
		    if (newone instanceof KnowledgeBase) {
		        ((KnowledgeBase)oldone).setSolution(((KnowledgeBase)newone).getSolution());
		    }
		    session.update(oldone);
		    tx.commit();
		    return oldone;
        } catch (Exception e) {
            try {
                if (tx != null) tx.rollback();
            } catch (HibernateException e1) { }
            throw e;
        } finally {
    	    closeSession();
        }
    }

    public SimpleKnowledgeBase delete(Integer id) throws Exception {
		if (id == null) throw new ActionException("helpdesk.kb.error.notfound");

		Transaction tx = null;
	    
	    try {
	        getSession();
		    tx = session.beginTransaction();
		    SimpleKnowledgeBase oldone = findSimple(id, session);
		    if (oldone == null) throw new ActionException("helpdesk.kb.error.notfound");
		    AttachmentService.deleteGroup(oldone.getProblemAttachGroupId(), session);
		    AttachmentService.deleteGroup(oldone.getSolutionAttachGroupId(), session);
		    session.delete(oldone);
		    tx.commit();
		    return oldone;
        } catch (Exception e) {
            try {
                if (tx != null) tx.rollback();
            } catch (HibernateException e1) { }
            throw e;
        } finally {
    	    closeSession();
        }
    }
    
    public KnowledgeBase createFromCall(Integer callid) throws Exception {
		Transaction tx = null;

		try {
            getSession();
            tx = session.beginTransaction();
            CallMaster call = CallService.find(callid, session);
            List callActionTracks = CallActionTrackService.listActionTrack(call.getCallID(), session);
            KnowledgeBase kb =  new KnowledgeBase();
            kb.setPublished(false);
            /*
            kb.setCall(call);
            */
            kb.setCustomer(call.getCompany());
            kb.setOriginalCustomer(call.getCompany());
            kb.setCategory(call.getRequestType());
            kb.setSubject(call.getSubject());
            kb.setProblemDesc(call.getDesc());
            String groupId = UUID.getUUID();
            kb.setProblemAttachGroupId(groupId);
            AttachmentService.copyGroup(groupId, call.getAttachGroupID(), session);
            groupId = UUID.getUUID();
            kb.setSolutionAttachGroupId(groupId);
            StringBuffer solution = new StringBuffer();
            TimeFormatter fmt = new TimeFormatter();
            for (int i = 0; i < callActionTracks.size(); i++) {
                CallActionHistory callAH = (CallActionHistory)callActionTracks.get(i);
                solution.append(">>>>>>>>>> ");
                solution.append(callAH.getModifyLog().getCreateUser().getName());
                solution.append(' ');
                solution.append(fmt.format(callAH.getModifyLog().getCreateDate()));
                solution.append('\n');
                solution.append(callAH.getSubject()).append('\n');
                solution.append(callAH.getDesc());
                solution.append("\n<<<<<<<<<<\n\n");
                AttachmentService.copyGroup(groupId, callAH.getAttachGroupID(), session);
            }
            kb.setSolution(solution.toString());
            kb = insert(kb, session);
            tx.commit();
            return kb;
        } catch (Exception e) {
            try {
                if (tx != null) tx.rollback();
            } catch (Exception el) { }
            throw e;
        } finally {
            closeSession();
        }
    }
 
	private void appendConditions(final CompositeQuery query, final Map conditions) {
		final String listConds[][] = {
		        {QUERY_CONDITION_SEARCHWORD, "(kb.subject like ? or kb.problemDesc like ? or kb.solution like ?)" },
		        {QUERY_CONDITION_SELECT, "kb.published = 1" },
		        {QUERY_CONDITION_CATEGORYID,"kb.category.id = ?"}
		};
		for(int i = 0; i < listConds.length; i++) {
			Object value = conditions.get(listConds[i][0]);
			if (value != null) {
			    if (listConds[i][0].equals(QUERY_CONDITION_SEARCHWORD)) {
			        Object[] para = { value, value, value }; 
					makeSimpeLikeCondition(query, listConds[i][1], para);
					continue;
			    }
			    if (listConds[i][0].equals(QUERY_CONDITION_SELECT)) {
			        if (value.equals("yes")) {
			            query.createQueryCondition("kb.published = 1");
			        }
		            else if (value.equals("no")) {
			            query.createQueryCondition("kb.published = 0");
		            }
			        continue;
			    }
			    if(listConds[i][0].equals(QUERY_CONDITION_CATEGORYID)) {
			        makeSimpeCondition(query, listConds[i][1], value);
					continue;
			    }
			}
		}
	}
    
	public List listKnowledgeBase(final Map conditions, final int pageNo, final int pageSize, Locale locale) throws HibernateException {
		try {
			getSession();
			CompositeQuery query=new CompositeQuery("select skb from SimpleKnowledgeBase skb, KnowledgeBase kb", "", session);
			query.createQueryCondition("kb.id = skb.id");
		    appendConditions(query, conditions);
			List l = query.list(pageNo * pageSize, pageSize);
			for (int i = 0; i < l.size(); i++) {
			    SLACategory category = (SLACategory)((SimpleKnowledgeBase)l.get(i)).getCategory();
			    category.setLocale(locale);
			}
			return l;
		} finally {
			closeSession();
		}
	}
    

	public int getListCount(final Map conditions) throws HibernateException {
		try {
			getSession();
			CompositeQuery query = new CompositeQuery("select count(skb) from SimpleKnowledgeBase skb, KnowledgeBase kb", "", session);
			query.createQueryCondition("kb.id = skb.id");
			appendConditions(query, conditions);
			List result = query.list();
			if (!result.isEmpty()) {
				Integer count = (Integer) result.get(0);
				if(count!=null)	return count.intValue();
			}
			return 0;
		} finally {
			closeSession();
		}
	}
}

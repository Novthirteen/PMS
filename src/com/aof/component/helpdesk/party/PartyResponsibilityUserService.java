/*
 * Created on 2004-12-15
 *
 */
package com.aof.component.helpdesk.party;

import java.util.List;
import java.util.Map;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.type.Type;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.Party;
import com.aof.webapp.action.ActionException;
import com.shcnc.hibernate.CompositeQuery;

/**
 * @author nicebean
 *
 */
public class PartyResponsibilityUserService extends BaseServices {
    public PartyResponsibilityUser find(Integer id) throws HibernateException {
        try {
            getSession();
            return find(id, session);
        } finally {
            closeSession();
        }
    }

    public static PartyResponsibilityUser find(Integer id, Session session) throws HibernateException {
        return (PartyResponsibilityUser) session.get(PartyResponsibilityUser.class, id);
    }
    
    public PartyResponsibilityUser insert(PartyResponsibilityUser newItem) throws HibernateException {
        try {
            getSession();
            Object[] para = { newItem.getParty().getPartyId(), newItem.getUser().getUserLoginId(), newItem.getType().getTypeId() };
            Type[] paraType = { Hibernate.STRING, Hibernate.STRING, Hibernate.STRING };
            List l = session.find("from PartyResponsibilityUser p where p.party.partyId = ? and p.user.userLoginId = ? and p.type.typeId = ?", para, paraType);
            if (l.size() > 0) {
                return (PartyResponsibilityUser)l.get(0);
            }
            session.save(newItem);
            return newItem;
        } finally {
            closeSession();
        }
    }

    public PartyResponsibilityUser delete(Integer id) throws HibernateException {
		if (id == null) throw new ActionException("helpdesk.partyresponsibilityuser.error.notfound");

		try {
            getSession();
            PartyResponsibilityUser oldone = find(id, session);
		    if (oldone == null) throw new ActionException("helpdesk.partyresponsibilityuser.error.notfound");
		    session.delete(oldone);
		    session.flush();
            return oldone;
        } finally {
            closeSession();
        }
    }

    public final static String QUERY_CONDITION_PARTY = "party";
    public final static String QUERY_CONDITION_USER = "user";
    public final static String QUERY_CONDITION_TYPE = "type";
    private final static String QUERY_CONDITIONS[][] = {
        { QUERY_CONDITION_PARTY, "(p.party.description like ? or p.party.partyId like ?)" },
        { QUERY_CONDITION_USER, "(p.user.name like ? or p.user.userLoginId like ?)" },
        { QUERY_CONDITION_TYPE, "p.type.typeId = ?" }
    };
    
    private void appendConditions(CompositeQuery query, Map conditions) {
		for (int i = 0; i < QUERY_CONDITIONS.length; i++) {
			Object value = conditions.get(QUERY_CONDITIONS[i][0]);
			if (value != null) {
			    if (QUERY_CONDITIONS[i][0].equals(QUERY_CONDITION_TYPE)) {
			        makeSimpeCondition(query, QUERY_CONDITIONS[i][1], value);
			    } else {
			        Object[] para = { value, value };
			        makeSimpeLikeCondition(query, QUERY_CONDITIONS[i][1], para);
			    }
			}
		}
    }
    
    public int getListCount(Map conditions) throws HibernateException {
        try {
            getSession();
			CompositeQuery query = new CompositeQuery("select count(p) from PartyResponsibilityUser p", "", session);
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
			CompositeQuery query = new CompositeQuery("from PartyResponsibilityUser p", "", session);
			appendConditions(query, conditions);
			return query.list(pageNo * pageSize, pageSize);
        } finally {
            closeSession();
        }
    }
    
    public String getPartyNotifyEmail(Party party) throws HibernateException {
        return getPartyNotifyEmail(party.getPartyId());
    }
    
    public String getPartyNotifyEmail(String partyId) throws HibernateException {
        try {
            getSession();
            List l = session.find("from PartyResponsibilityUser p where p.party.partyId = ? and p.type.typeId = 'A'", partyId, Hibernate.STRING);
            StringBuffer result = new StringBuffer();
            for (int i = 0; i < l.size(); i++) {
                PartyResponsibilityUser p = (PartyResponsibilityUser)l.get(i);
                String email = p.getUser().getEmail_addr();
                if (email != null && email.trim().length() > 0) {
                    if (result.length() > 0) result.append(';');
                    result.append(email);
                }
            }
            return result.toString();
        } finally {
            closeSession();
        }
    }
}

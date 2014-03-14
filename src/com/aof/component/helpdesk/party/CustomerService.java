/*
 * Created on 2004-12-20
 *
 */
package com.aof.component.helpdesk.party;

import java.util.List;
import java.util.Map;

import net.sf.hibernate.HibernateException;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.PartyKeys;
import com.shcnc.hibernate.CompositeQuery;

/**
 * @author nicebean
 *
 */
public class CustomerService extends BaseServices {

    public final static String QUERY_CONDITION_DESC = "description";
    private final static String QUERY_CONDITIONS[][] = {
        { QUERY_CONDITION_DESC, "(c.description like ? or c.partyId like ?)" }
    };

    private void appendConditions(CompositeQuery query, Map conditions) {
		for (int i = 0; i < QUERY_CONDITIONS.length; i++) {
			Object value = conditions.get(QUERY_CONDITIONS[i][0]);
			if (value != null) {
			    if (QUERY_CONDITIONS[i][0].equals(QUERY_CONDITION_DESC)) {
			        Object para[] = { value, value };
			        makeSimpeLikeCondition(query, QUERY_CONDITIONS[i][1], para);
			    }
			}
		}
    }

    public int getListCount(Map conditions) throws HibernateException {
        try {
            getSession();
			CompositeQuery query = new CompositeQuery("select count(c) from Party c left outer join c.partyRoles r", "", session);
            makeSimpeCondition(query, "r.roleTypeId = ?", PartyKeys.CUSTOMER_ROLE_KEY);
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
			CompositeQuery query = new CompositeQuery("select c from Party c left outer join c.partyRoles r", "", session);
            makeSimpeCondition(query, "r.roleTypeId = ?", PartyKeys.CUSTOMER_ROLE_KEY);
			appendConditions(query, conditions);
			return query.list(pageNo * pageSize, pageSize);
        } finally {
            closeSession();
        }
    }

}

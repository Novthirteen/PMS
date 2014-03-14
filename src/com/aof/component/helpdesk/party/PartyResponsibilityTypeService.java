/*
 * Created on 2004-12-16
 *
 */
package com.aof.component.helpdesk.party;

import java.util.List;

import net.sf.hibernate.HibernateException;

import com.aof.component.BaseServices;

/**
 * @author nicebean
 *
 */
public class PartyResponsibilityTypeService extends BaseServices {
    public List getAll() throws HibernateException {
        try {
            getSession();
            return session.find("from PartyResponsibilityType p order by p.description");
        } finally {
            closeSession();
        }
    }
}

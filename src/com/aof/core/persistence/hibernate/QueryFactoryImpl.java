package com.aof.core.persistence.hibernate;

import net.sf.hibernate.Session;
import net.sf.hibernate.HibernateException;


class QueryFactoryImpl implements QueryFactory {

    public Query newQuery(String query) throws LookupException {
        try {
            return new QueryImpl(getSession().createQuery(query));
        } catch (HibernateException e) {
            throw new LookupException("Unable to create new Query", e);
        }
    }

    public Query getNamedQuery(String name) throws LookupException {
        try {
            return new QueryImpl(getSession().getNamedQuery(name));
        } catch (HibernateException e) {
            throw new LookupException("Unable to find named Query: " + name, e);
        }
    }

    public CriteriaQuery newCriteriaQuery(Class domainClass) {
        return new CriteriaQueryImpl(getSession().createCriteria(domainClass));
    }

    private Session getSession() {
        return ThreadSessionHolder.get();
    }
}

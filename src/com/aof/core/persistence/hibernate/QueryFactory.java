package com.aof.core.persistence.hibernate;

public interface QueryFactory {
    public Query newQuery(String query) throws LookupException;

    public Query getNamedQuery(String name) throws LookupException;

    public CriteriaQuery newCriteriaQuery(Class domainClass);
}

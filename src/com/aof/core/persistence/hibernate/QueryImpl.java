package com.aof.core.persistence.hibernate;

import net.sf.hibernate.HibernateException;

import java.util.List;
import java.util.Collection;
import java.util.Locale;
import java.util.Date;
import java.util.Calendar;
import java.io.Serializable;
import java.math.BigDecimal;


class QueryImpl implements Query{
    private net.sf.hibernate.Query query;

    QueryImpl(net.sf.hibernate.Query query) {
        this.query = query;
    }
    public List execute() throws LookupException {
        try {
            return query.list();
        } catch (HibernateException e) {
            throw new LookupException("Unable to execute the Query", e);
        }
    }

    public void setFirstResult(int firstResult) {
        query.setFirstResult(firstResult);
    }

    public void setMaxResults(int maxResults) {
        query.setMaxResults(maxResults);
    }

    public Query setParameter(int i, Object o) throws LookupException {
        try {
            query.setParameter(i, o);
        } catch (HibernateException e) {
            throw exceptionFactory(e);
        }
        return this;
    }

    public Query setParameter(String s, Object o) throws LookupException {
        try {
            query.setParameter(s, o);
        } catch (HibernateException e) {
            throw exceptionFactory(e);
        }
        return this;
    }

    public Query setParameterList(String s, Collection collection) throws LookupException {
        try {
            query.setParameterList(s, collection);
        } catch (HibernateException e) {
            throw exceptionFactory(e);
        }
        return this;
    }

    public Query setParameterList(String s, Object[] objects) throws LookupException {
        try {
            query.setParameterList(s, objects);
        } catch (HibernateException e) {
            throw exceptionFactory(e);
        }
        return this;
    }

    public Query setProperties(Object o) throws LookupException {
        try {
            query.setProperties(o);
        } catch (HibernateException e) {
            throw exceptionFactory(e);
        }
        return this;
    }

    public Query setString(int i, String s) {
        query.setString(i, s);
        return this;
    }

    public Query setCharacter(int i, char c) {
        query.setCharacter(i, c);
        return this;
    }

    public Query setBoolean(int i, boolean b) {
        query.setBoolean(i, b);
        return this;
    }

    public Query setByte(int i, byte b) {
        query.setByte(i, b);
        return this;
    }

    public Query setShort(int i, short i1) {
        query.setShort(i, i1);
        return this;
    }

    public Query setInteger(int i, int i1) {
        query.setInteger(i, i1);
        return this;
    }

    public Query setLong(int i, long l) {
        query.setLong(i, l);
        return this;
    }

    public Query setFloat(int i, float v) {
        query.setFloat(i, v);
        return this;
    }

    public Query setDouble(int i, double v) {
        query.setDouble(i, v);
        return this;
    }

    public Query setBinary(int i, byte[] bytes) {
        query.setBinary(i, bytes);
        return this;
    }

    public Query setSerializable(int i, Serializable serializable) {
        query.setSerializable(i, serializable);
        return this;
    }

    public Query setLocale(int i, Locale locale) {
        query.setLocale(i, locale);
        return this;
    }

    public Query setBigDecimal(int i, BigDecimal bigDecimal) {
        query.setBigDecimal(i, bigDecimal);
        return this;
    }

    public Query setDate(int i, Date date) {
        query.setDate(i, date);
        return this;
    }

    public Query setTime(int i, Date date) {
        query.setTime(i, date);
        return this;
    }

    public Query setTimestamp(int i, Date date) {
        query.setTimestamp(i, date);
        return this;
    }

    public Query setCalendar(int i, Calendar calendar) {
        query.setCalendar(i, calendar);
        return this;
    }

    public Query setCalendarDate(int i, Calendar calendar) {
        query.setCalendarDate(i, calendar);
        return this;
    }

    public Query setString(String s, String s1) {
        query.setString(s, s1);
        return this;
    }

    public Query setCharacter(String s, char c) {
        query.setCharacter(s, c);
        return this;
    }

    public Query setBoolean(String s, boolean b) {
        query.setBoolean(s, b);
        return this;
    }

    public Query setByte(String s, byte b) {
        query.setByte(s, b);
        return this;
    }

    public Query setShort(String s, short i) {
        query.setShort(s, i);
        return this;
    }

    public Query setInteger(String s, int i) {
        query.setInteger(s, i);
        return this;
    }

    public Query setLong(String s, long l) {
        query.setLong(s, l);
        return this;
    }

    public Query setFloat(String s, float v) {
        query.setFloat(s, v);
        return this;
    }

    public Query setDouble(String s, double v) {
        query.setDouble(s, v);
        return this;
    }

    public Query setBinary(String s, byte[] bytes) {
        query.setBinary(s, bytes);
        return this;
    }

    public Query setSerializable(String s, Serializable serializable) {
        query.setSerializable(s, serializable);
        return this;
    }

    public Query setLocale(String s, Locale locale) {
        query.setLocale(s, locale);
        return this;
    }

    public Query setBigDecimal(String s, BigDecimal bigDecimal) {
        query.setBigDecimal(s, bigDecimal);
        return this;
    }

    public Query setDate(String s, Date date) {
        query.setDate(s, date);
        return this;
    }

    public Query setTime(String s, Date date) {
        query.setTime(s, date);
        return this;
    }

    public Query setTimestamp(String s, Date date) {
        query.setTimestamp(s, date);
        return this;
    }

    public Query setCalendar(String s, Calendar calendar) {
        query.setCalendar(s, calendar);
        return this;
    }

    public Query setCalendarDate(String s, Calendar calendar) {
        query.setCalendarDate(s, calendar);
        return this;
    }

    public Query setEntity(int i, Object o) {
        query.setEntity(i, o);
        return this;
    }

    public Query setEntity(String s, Object o) {
        query.setEntity(s, o);
        return this;
    }

    private LookupException exceptionFactory(Exception e) {
        return new LookupException("Unable to build query", e);
    }
}

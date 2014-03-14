package com.aof.core.persistence.hibernate;

import java.util.Collection;
import java.util.Locale;
import java.util.Date;
import java.util.Calendar;
import java.io.Serializable;
import java.math.BigDecimal;

public interface Query extends CommonQuery {

    Query setParameter(int i, Object o) throws LookupException;

    Query setParameter(String s, Object o) throws LookupException;

    Query setParameterList(String s, Collection collection) throws LookupException;

    Query setParameterList(String s, Object[] objects) throws LookupException;

    Query setProperties(Object o) throws LookupException;

    Query setString(int i, String s);

    Query setCharacter(int i, char c);

    Query setBoolean(int i, boolean b);

    Query setByte(int i, byte b);

    Query setShort(int i, short i1);

    Query setInteger(int i, int i1);

    Query setLong(int i, long l);

    Query setFloat(int i, float v);

    Query setDouble(int i, double v);

    Query setBinary(int i, byte[] bytes);

    Query setSerializable(int i, Serializable serializable);

    Query setLocale(int i, Locale locale);

    Query setBigDecimal(int i, BigDecimal bigDecimal);

    Query setDate(int i, Date date);

    Query setTime(int i, Date date);

    Query setTimestamp(int i, Date date);

    Query setCalendar(int i, Calendar calendar);

    Query setCalendarDate(int i, Calendar calendar);

    Query setString(String s, String s1);

    Query setCharacter(String s, char c);

    Query setBoolean(String s, boolean b);

    Query setByte(String s, byte b);

    Query setShort(String s, short i);

    Query setInteger(String s, int i);

    Query setLong(String s, long l);

    Query setFloat(String s, float v);

    Query setDouble(String s, double v);

    Query setBinary(String s, byte[] bytes);

    Query setSerializable(String s, Serializable serializable);

    Query setLocale(String s, Locale locale);

    Query setBigDecimal(String s, BigDecimal bigDecimal);

    Query setDate(String s, Date date);

    Query setTime(String s, Date date);

    Query setTimestamp(String s, Date date);

    Query setCalendar(String s, Calendar calendar);

    Query setCalendarDate(String s, Calendar calendar);

    Query setEntity(int i, Object o);

    Query setEntity(String s, Object o);
}

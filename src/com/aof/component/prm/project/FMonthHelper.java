/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.component.prm.project;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

/**
 * @author Jackey Ding 
 * @version 2005-02-21
 *
 */
public class FMonthHelper {

	public FMonth findFiscalMonthByYearAndMonth(Session session, int year, int month) throws HibernateException {
		Query query = session.createQuery("from FMonth as fm where fm.Year = ? and fm.MonthSeq = ? ");
		query.setInteger(0, year);
		query.setInteger(1, month - 1);
		List list = query.list();
		if (list == null || list.size() == 0) {
			return null;
		}
		FMonth fMonth = (FMonth)list.get(0);
		return preciseFiscalMonth(fMonth);
	}
	
	public FMonth findFiscalMonthByActurlDate(Session session, Date acturlDate) throws HibernateException {
		Query query = session.createQuery("from FMonth as fm where ? Between fm.DateFrom and fm.DateTo ");
		query.setDate(0, acturlDate);
		List list = query.list();
		if (list == null || list.size() == 0) {
			return null;
		}
		FMonth fMonth = (FMonth)list.get(0);
		return preciseFiscalMonth(fMonth);
	}
	
	private FMonth preciseFiscalMonth(FMonth fMonth) {

	    Calendar fromCalendar = Calendar.getInstance();
		fromCalendar.setTime(fMonth.getDateFrom());
		fromCalendar.set(Calendar.HOUR, 0);
		fromCalendar.set(Calendar.MINUTE, 0);
		fromCalendar.set(Calendar.SECOND, 0);
		fromCalendar.set(Calendar.MILLISECOND, 0);
		fMonth.setDateFrom(new java.sql.Date(fromCalendar.getTimeInMillis()));			
		Calendar toCalendar = Calendar.getInstance();
		toCalendar.setTime(fMonth.getDateTo());
		toCalendar.set(Calendar.HOUR, 23);
		toCalendar.set(Calendar.MINUTE, 59);
		//toCalendar.set(Calendar.SECOND, 59);
		//toCalendar.set(Calendar.MILLISECOND, 999);
		fMonth.setDateTo(new java.sql.Date(toCalendar.getTimeInMillis()));	

		return fMonth;
	}
}

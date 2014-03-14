/*
 * Created on 2005-3-11
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.master;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Criteria;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.prm.master.ProjectCalendar;
import com.aof.component.prm.master.ProjectCalendarType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditProjCalendarAction extends BaseAction {
	private Logger log = Logger.getLogger(EditProjCalendarAction.class);
	
	public ActionForward perform(ActionMapping mapping,
					             ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		String action = request.getParameter("action");
		Transaction tx = null;
		try {
			String yearStr = request.getParameter("year");
			String monthStr = request.getParameter("month");
			String typeId = request.getParameter("typeId");
			int year = 0;
			int month = 0;
			
			Session session = Hibernate2Session.currentSession();
			
			if (yearStr == null || monthStr == null) {
				Calendar calendar = Calendar.getInstance();
				
				year = calendar.get(Calendar.YEAR);
				month = calendar.get(Calendar.MONTH);
			} else {
				year = Integer.parseInt(yearStr);
				month = Integer.parseInt(monthStr);
			}
			
			//initial search condition
			Criteria crit = session.createCriteria(ProjectCalendarType.class);
			List result = crit.list();
			
			request.setAttribute("TypeList",result);
			request.setAttribute("CurrentYear", new Integer(year));
			request.setAttribute("CurrentMonth", new Integer(month));
			request.setAttribute("TypeId", typeId);
			
			tx = session.beginTransaction();
			if ("update".equals(action)) {
				update(request, session, typeId);
			}

			if ("view".equals(action) || "update".equals(action)) {
				view(request, session, year,  month,  typeId);
			}
		} catch(Exception e) {
			try {
				tx.rollback();
			} catch (HibernateException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			log.error(e.getMessage());
		} finally {
			try {
				tx.commit();
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}		
		}
		
		return (mapping.findForward("success"));
	}
	
	private void view(HttpServletRequest request, 
			          Session session, 
					  int year, 
					  int month, 
					  String typeId) {
		
		Calendar fromCalendar = Calendar.getInstance();
		Calendar toCalendar = Calendar.getInstance();
		
		fromCalendar.set(year, month, 1, 0, 0, 0);
		//fromCalendar.set(Calendar.MILLISECOND, 0);
		toCalendar.setTime(fromCalendar.getTime());
		toCalendar.add(Calendar.MONTH, 1);
		toCalendar.add(Calendar.DATE, -1);
		toCalendar.set(Calendar.HOUR, 23);
		toCalendar.set(Calendar.MINUTE, 59);
		toCalendar.set(Calendar.SECOND, 59);
		try {
			ProjectCalendarType pct = (ProjectCalendarType)session.load(ProjectCalendarType.class, typeId);
			
			Query query = session.createQuery("select pc " +
											  "  from ProjectCalendar as pc" +
											  " where pc.Type.TypeId = ? " +
											  "   and pc.CalendarDate between ? and ? " +
											  " order by pc.CalendarDate");
			
			query.setString(0, typeId);
			query.setDate(1, fromCalendar.getTime());
			query.setDate(2, toCalendar.getTime());
			
			List list = query.list();
			Iterator iterator = null;
			boolean noRecordFlg = true;
			if (list != null) {
				iterator = list.iterator();
			}
			ProjectCalendar pc = null;
			if (iterator.hasNext()) {
				noRecordFlg = false;
				pc = (ProjectCalendar)iterator.next();
			}
			DateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
			List resultList = new ArrayList();
			
			for (int i0 = 1; i0 <= toCalendar.get(Calendar.DATE); i0++) {
				Calendar calendar = Calendar.getInstance();
				calendar.set(year, month, i0);
				if (pc != null && 
						formatter.format(pc.getCalendarDate()).equals(formatter.format(calendar.getTime()))) {
					
					resultList.add(pc);
					
					if (iterator.hasNext()) {
						pc = (ProjectCalendar)iterator.next();
					}
					
				} else {
					ProjectCalendar newPc = new ProjectCalendar();
					
					newPc.setType(pct);
					newPc.setCalendarDate(calendar.getTime());
					if (calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY
							|| calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) {
						newPc.setHours(0);
					} else {
						newPc.setHours(8);
					}

					resultList.add(newPc);
				}
			}
			
			request.setAttribute("NoRecord", noRecordFlg + "");
			request.setAttribute("ResultList", resultList);
		} catch(Exception e) {
			log.error(e.getMessage());
		}
	}
	
	private void update(HttpServletRequest request, 
		                Session session, 
				        String typeId) {
		
		String[] id = request.getParameterValues("Id");
		String[] pcYear = request.getParameterValues("PC_Date_Year");
		String[] pcMonth = request.getParameterValues("PC_Date_Month");
		String[] pcDate = request.getParameterValues("PC_Date_Date");
		String[] pcHours = request.getParameterValues("PC_Hours");
		
		try {
			ProjectCalendarType pct = (ProjectCalendarType)session.load(ProjectCalendarType.class, typeId);
			
			for (int i0 = 0; i0 < id.length; i0++) {
				ProjectCalendar projectCalendar = new ProjectCalendar();
				
				Calendar calendar = Calendar.getInstance();
				calendar.set(Integer.parseInt(pcYear[i0]), 
							 Integer.parseInt(pcMonth[i0]),
							 Integer.parseInt(pcDate[i0]));
				
				//calendar.set(Calendar.MILLISECOND, 0);
				
				projectCalendar.setType(pct);
				projectCalendar.setCalendarDate(calendar.getTime());
				projectCalendar.setHours(Double.parseDouble(pcHours[i0]));
				
				if (id[i0] != null && id[i0].trim().length() != 0) {
					projectCalendar.setId(new Long(id[i0]));
					session.update(projectCalendar);
				} else {
					session.save(projectCalendar);
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		}
	}
}

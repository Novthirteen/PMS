/*
 * Created on 2005-3-2
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.master;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.prm.project.FMonth;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ListFisCalendarAction extends BaseAction {
	
	public ActionForward perform(ActionMapping mapping,
			                     ActionForm form,
			                     HttpServletRequest request,
			                     HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(ListFisCalendarAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
			
		net.sf.hibernate.Session hs = null;
			
		try {
			hs = Hibernate2Session.currentSession();
			Date currDate = new Date();
				
			String statement1 = 
					"select fm from FMonth as fm " +
					" where ? between fm.DateFrom and fm.DateTo";
			Query query1 = hs.createQuery(statement1);
			query1.setDate(0, currDate);
				
			List list1 = query1.list();
				
			if (list1 != null && list1.iterator().hasNext()) {
				FMonth currFMonth = (FMonth)list1.iterator().next();
				int currentYear = currFMonth.getYear().intValue();
				int currentMonth = currFMonth.getMonthSeq();
				
				int yearFrom = currentYear;
				int monthFrom = currentMonth - 6;
				int yearTo = currentYear;
				int monthTo = currentMonth + 6;
				
				if (monthFrom < 0) {
					yearFrom = yearFrom - 1;
					monthFrom = monthFrom + 12;
				}
				
				if (monthTo > 11) {
					yearTo = yearTo + 1;
					monthTo = monthTo - 12;
				}
				
				String statement2 = 
					"select fm from FMonth as fm " +
					" where (fm.Year * 100 + fm.MonthSeq) between ? and ? " +
					" order by fm.Year, fm.MonthSeq";
				
				Query query2 = hs.createQuery(statement2);
				query2.setInteger(0, yearFrom * 100 + monthFrom);
				query2.setInteger(1, yearTo * 100 + monthTo);
				
				List list2 = query2.list();
				
				request.setAttribute("QryList", list2);
			}
		} catch(Exception e){
			e.printStackTrace();
			log.error(e.getMessage());
			return (mapping.findForward("success"));	
		} finally{
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
			return (mapping.findForward("success"));
		}
	}
}

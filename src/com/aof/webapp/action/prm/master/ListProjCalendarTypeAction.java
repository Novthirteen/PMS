/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.master;

import java.sql.SQLException;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Criteria;
import net.sf.hibernate.HibernateException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.prm.master.ProjectCalendarType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;

/**
/**
 * @author Jackey Ding
 * @version 2005-03-10
 *
 */
public class ListProjCalendarTypeAction extends BaseAction {
	private Logger log = Logger.getLogger(ListProjCalendarTypeAction.class);
	
	public ActionForward perform(ActionMapping mapping,
			                     ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		try {
			net.sf.hibernate.Session session = Hibernate2Session.currentSession();
			
			Criteria crit = session.createCriteria(ProjectCalendarType.class);
			
			List result = crit.list();
			
			request.setAttribute("QryList",result);
			
		} catch(Exception e) {
			log.error(e.getMessage());
		} finally {
			try {
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
}

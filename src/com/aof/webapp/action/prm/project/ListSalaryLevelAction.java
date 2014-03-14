/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.project;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;

public class ListSalaryLevelAction extends BaseAction {
	
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
		Logger log = Logger.getLogger(ListSalaryLevelAction.class);
		String level = request.getParameter("level");
		String description = request.getParameter("description");
		String status = request.getParameter("status");

		try{
			net.sf.hibernate.Session session = Hibernate2Session.currentSession();
			String selectStatement = "select sl from SalaryLevel as sl";
			String whereStatement = null;
			
			if (level != null && level.trim().length() != 0) {
				whereStatement = " where sl.level = '"+level+"' ";
			}
			
			if (description != null && description.trim().length() != 0) {
				if (whereStatement == null) {
					whereStatement = " where sl.description = '"+description+"' ";
				} else {
					whereStatement += " and sl.description = '"+description+"' ";
				}
			}
			
			if (status != null && status.trim().length() != 0) {
				if (whereStatement == null) {
					whereStatement = " where sl.status = '"+status+"' ";
				} else {
					whereStatement += " and sl.status = '"+status+"' ";
				}
			}
			
			if (whereStatement != null) {
				selectStatement += whereStatement;
			}
			
			request.setAttribute("QryList", session.find(selectStatement));
		}catch(Exception e){
			log.error(e.getMessage());
		}finally{
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

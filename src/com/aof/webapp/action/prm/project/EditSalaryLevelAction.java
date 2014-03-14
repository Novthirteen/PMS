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
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.Party;
import com.aof.component.prm.project.SalaryLevel;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilString;
import com.aof.webapp.action.BaseAction;

public class EditSalaryLevelAction extends BaseAction{
	public ActionForward perform(ActionMapping mapping,
			ActionForm form,HttpServletRequest request,HttpServletResponse response) {
		
		Logger log = Logger.getLogger(EditSalaryLevelAction.class);
		String action = request.getParameter("formAction");
		String id = request.getParameter("id");
		String level = request.getParameter("level");
		String description = request.getParameter("description");
		String status = request.getParameter("status");
		String party = request.getParameter("partyId");
		String curr = request.getParameter("currencyId");
		String rateStr= request.getParameter("rate");
		if (rateStr==null) rateStr="0.000";
		rateStr = UtilString.removeSymbol(rateStr,',');
		Double rate=new Double(rateStr);
		//double rate=rateDouble.doubleValue()
	
		
		Session session = null;
		
		try{
			
			session = Hibernate2Session.currentSession();
			
			SalaryLevel salaryLevel = null;
			
			if (id != null && id.trim().length() != 0) {
				salaryLevel = (SalaryLevel) session.load(SalaryLevel.class, new Long(id));
			} else {
				salaryLevel = new SalaryLevel();
			}
			
			if ("edit".equals(action)) {
				salaryLevel.setLevel(level);
				salaryLevel.setDescription(description);
				salaryLevel.setStatus(new Integer(status));
				salaryLevel.setCurr(curr);
				salaryLevel.setRate(rate);
				Party p = (Party)session.load(Party.class,party);
				salaryLevel.setParty(p);
				
				session.saveOrUpdate(salaryLevel);
			}
			
			if ("delete".equals(action)) {
				session.delete(salaryLevel);
				return mapping.findForward("list");
			} else {
				request.setAttribute("SalaryLevel", salaryLevel);
				return mapping.findForward("success");
			}
		} catch(Exception e){
			e.printStackTrace();
			log.error(e.getMessage());	
		}finally{
			try {
				session.flush();
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
		return null;
	}
}

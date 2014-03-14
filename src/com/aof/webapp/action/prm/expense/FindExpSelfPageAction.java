/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.expense;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *
 */
public class FindExpSelfPageAction extends BaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(FindExpSelfPageAction.class.getName());
		Locale locale = getLocale(request);
		HttpSession session = request.getSession();
		MessageResources messages = getResources();
		try {

			List result = new ArrayList();
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
			String UserId=ul.getUserLoginId();
			
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
			String textproj = request.getParameter("textproj");
			String textstatus = request.getParameter("textstatus");
			String textcode = request.getParameter("textcode");
			String DateStart = request.getParameter("DateStart");
			String DateEnd = request.getParameter("DateEnd");
			if (textproj==null) textproj="";
			if (textstatus==null) textstatus="Draft";
			if (textcode==null) textcode="";
			if (DateStart==null) DateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
			if (DateEnd==null) DateEnd=Date_formater.format(nowDate);
			
			String QryStr = "select em from ExpenseMaster as em where em.ExpenseUser.userLoginId = :UserId";
			if(!textstatus.trim().equals("")){
				QryStr = QryStr +" and (em.Status = '"+ textstatus +"')";
			}
			if(!textproj.trim().equals("")){
				QryStr = QryStr +" and ((em.Project.projName like '%"+ textproj.trim() +"%') or (em.Project.projId like '%"+ textproj.trim() +"%'))";
			}
			if(!textcode.trim().equals("")){
				QryStr = QryStr +" and (em.FormCode like '%"+ textcode.trim() +"%')";
			}
			QryStr = QryStr +" and ((em.EntryDate >= '"+DateStart+"') and ( em.EntryDate <= '"+DateEnd+"'))";
			QryStr = QryStr + " order by em.EntryDate DESC, em.Project.projId, em.ExpenseUser, em.FormCode";
			Query q= hs.createQuery(QryStr);
			q.setParameter("UserId",UserId);
			result = q.list();
			request.setAttribute("QryList", result);

		} catch (Exception e) {
			e.printStackTrace();
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

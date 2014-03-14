/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.expense;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.expense.ExpenseMaster;
import com.aof.component.prm.util.EmailService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *
 */
public class FindExpToApprovalPageAction extends BaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log =
			Logger.getLogger(FindExpToApprovalPageAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		String action = request.getParameter("FormAction");
		if(action == null) action = "QueryForList";
		
		if (action.equals("QueryForList")) {
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
		if (action.equals("ApproveSelection")) {
			String chk[] =request.getParameterValues("chk");
			if (chk != null) {
				try {
					net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
					Transaction tx = hs.beginTransaction();
					int RowSize = java.lang.reflect.Array.getLength(chk);
					for (int i = 0; i < RowSize; i++) {
						ExpenseMaster findmaster = (ExpenseMaster)hs.load(ExpenseMaster.class, new Long(chk[i]));
						if (findmaster.getApprovalDate() == null) {
						//if (!findmaster.getStatus().equals("Approved")) {
							findmaster.setStatus("Approved");
							findmaster.setApprovalDate(UtilDateTime.nowTimestamp());
							hs.update(findmaster);
						}
//						sendmail to expense user
						EmailService.notifyUser(findmaster);
					}
					
					tx.commit();
					hs.flush();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
	
		//-----------------------------------------------------------------------------------
		if (action.equals("RejectSelection")) {
			String chk[] =request.getParameterValues("chk");
			if (chk != null) {
				try {
					net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
					Transaction tx = hs.beginTransaction();
					int RowSize = java.lang.reflect.Array.getLength(chk);
					for (int i = 0; i < RowSize; i++) {
						ExpenseMaster findmaster = (ExpenseMaster)hs.load(ExpenseMaster.class, new Long(chk[i]));
						//if (!findmaster.getStatus().equals("Rejected")) {
						if ((findmaster.getReceiptDate() == null) && (!findmaster.getStatus().equals("Posted To F&A"))){
							findmaster.setStatus("Rejected");
							findmaster.setApprovalDate(null);
							hs.saveOrUpdate(findmaster);
						}
//						sendmail to expense user
						EmailService.notifyUser(findmaster);
					}
					tx.commit();
					hs.flush();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			List result = findQueryResult(request);
			request.setAttribute("QryList", result);
		}
		

				
		//-----------------------------------------------------------------------------------
		return (mapping.findForward("success"));
	}
	
	private List findQueryResult(HttpServletRequest request) {
		List result = null;
		try {
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			HttpSession session = request.getSession();
			UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
			String UserId=ul.getUserLoginId();
			
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
						
			String textuser = request.getParameter("textuser");
			String textproj = request.getParameter("textproj");
			String textstatus = request.getParameter("textstatus");
			String textcode = request.getParameter("textcode");
			String DateStart = request.getParameter("DateStart");
			String DateEnd = request.getParameter("DateEnd");
			if (textproj==null) textproj="";
			if (textstatus==null) textstatus="Submitted";
			if (textuser==null) textuser="";
			if (textcode==null) textcode="";
			if (DateStart==null) DateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
			if (DateEnd==null) DateEnd=Date_formater.format(nowDate);
			
			
			String StatusListStr = "'Submitted','Verified','Approved','Rejected','Posted To F&A','Confirmed','Claimed'";
			String QryStr = "select em from ExpenseMaster as em where em.Project.ProjectManager.userLoginId = :UserId";
			if(!textstatus.trim().equals("")){
				QryStr = QryStr +" and (em.Status = '"+ textstatus +"')";
			}else{
				QryStr = QryStr +" and (em.Status in ("+ StatusListStr +"))";
			}
			if(!textuser.trim().equals("")){
				QryStr = QryStr +" and ((em.ExpenseUser.name like '%"+ textuser.trim() +"%') or (em.ExpenseUser.userLoginId like '%"+ textuser.trim() +"%'))";
			}
			if(!textproj.trim().equals("")){
				QryStr = QryStr +" and ((em.Project.projName like '%"+ textproj.trim() +"%') or (em.Project.projId like '%"+ textproj.trim() +"%'))";
			}
			if(!textcode.trim().equals("")){
				QryStr = QryStr +" and (em.FormCode like '%"+ textcode.trim() +"%')";
			}
			QryStr = QryStr +" and (em.EntryDate between '"+DateStart+"' and '"+DateEnd+"')";
			QryStr = QryStr + " order by em.EntryDate DESC, em.Project.projId, em.ExpenseUser, em.FormCode";
			
			Query q= hs.createQuery(QryStr);
			q.setParameter("UserId",UserId);
			result = q.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}

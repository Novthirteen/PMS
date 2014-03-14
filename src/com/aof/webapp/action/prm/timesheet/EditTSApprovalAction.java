/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.timesheet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.TimeSheet.TimeSheetDetail;
import com.aof.component.prm.TimeSheet.TimeSheetMaster;
import com.aof.component.prm.project.FMonth;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

import com.aof.component.prm.util.EmailService;
/**
 * @author xxp 
 * @version 2003-7-2
 *	update time 2004-12-2
 */
public class EditTSApprovalAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditTSApprovalAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		// get parameters from ListTimeSheet page
		String action = request.getParameter("FormAction");
		String UserId = request.getParameter("UserId");
		String DepartmentId = request.getParameter("DepartmentId");
		String DataPeriod = request.getParameter("DataId");
		String SelStatus = request.getParameter("SelStatus");
		
		java.util.ArrayList mailtoList = new java.util.ArrayList();
		java.util.ArrayList tsList = new java.util.ArrayList();
		
		// date of this week
		String DayArray[];
		DayArray = new String[7];
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		String nowTimestampString = UtilDateTime.nowTimestamp().toString();
		String DateStart = "";
		float totalCount = 0;
		if (DataPeriod == null) {
			DateStart = nowTimestampString;
		} else {
			DateStart = DataPeriod + " 00:00:00.000";
		}
		Date dayStart = UtilDateTime.toDate2(DateStart);
		log.info("dayStart=" + dayStart);
		log.info("DateStart=" + DateStart);
		if (UserId == null) UserId = "";
		if (DepartmentId == null) DepartmentId = "";
		if (DataPeriod == null) DataPeriod = "2004-11-01";
		if (SelStatus == null) SelStatus = "Submitted";
		if (action == null) action = "view";

		if (!isTokenValid(request)) {
			if(action.equals("Approval")){
				action ="view";
			}
		}
		saveToken(request);
		
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			List result = new ArrayList();
			if (action.equals("Approval") || action.equals("Reject")) {
				String projId[] = request.getParameterValues("projId");
				String PEventId[] = request.getParameterValues("PEventId");
				String chk[] = request.getParameterValues("chk");
				
				String newStatus = "";
				if (action.equals("Approval")) {
					newStatus = "Approved";
				} else {
					newStatus = "Rejected";
				}
				
				tx = hs.beginTransaction();
				if (projId != null) {
					int RowSize = java.lang.reflect.Array.getLength(projId);
					TimeSheetDetail ts = null;
					int k = 0;
					for (int i = 1; i <= RowSize; i++) {
						String tsId[] = request.getParameterValues("tsId" + i);
						int ColSize = java.lang.reflect.Array.getLength(tsId);
						if (chk != null) {
							int ChkSize = java.lang.reflect.Array.getLength(chk);
							if (k < ChkSize && i == new Integer(chk[k]).intValue()) {
								k++;
								if (tsId != null) {
									String oldStatus = null;
									for (int j = 0; j < ColSize; j++) {
										if (!tsId[j].trim().equals("")) {
											//delete records which were selected
											ts = (TimeSheetDetail) hs.load(TimeSheetDetail.class,new Integer(tsId[j]));
											if (ts != null) {
												//if (!ts.getStatus().trim().equals("Approved")) {
													oldStatus = ts.getStatus();
													ts.setStatus(newStatus);
													hs.update(ts);
												//}
											}
										}
									}
									if(!oldStatus.equals(newStatus)){
										String s = ts.getTimeSheetMaster().getTsmUser().getEmail_addr();
										if(!mailtoList.contains(s)){							
											mailtoList.add(ts);		
											tsList.add(ts);
										}
									}							
								}

							}
						}
					}
					
				}
				tx.commit();
				
				//sending mail
				/*
				Query q = hs.createQuery(
									"select tsm from TimeSheetMaster as tsm " +
									"inner join tsm.TsmUser as tUser " +
									"where tsm.Period = :DataPeriod and tUser.userLoginId = :DataUser"
									    );
				q.setParameter("DataPeriod", DataPeriod);
				q.setParameter("DataUser", UserId);
				List tsmList = q.list();
				Iterator it = tsmList.iterator();
			
				TimeSheetMaster tsm = null;
				if(it.hasNext()){				
					 tsm = (TimeSheetMaster)it.next();
					 com.aof.component.prm.util.EmailService.notifyUser(tsm);
				}
				*/
				for(int j=0; j<tsList.size(); j++){
					TimeSheetDetail ts = (TimeSheetDetail)tsList.get(j);
					EmailService.notifyUser(ts.getTimeSheetMaster(),ts);
					mailtoList.clear();	
					tsList.clear();
				}				
				// delete
			} else if (action.equals("Back")) {
				return (mapping.findForward("backToList"));
			}
			// init display or refresh display
			String SQLStr = "select ts from TimeSheetDetail as ts inner join ts.TimeSheetMaster as tsm";
			SQLStr = SQLStr + " inner join ts.Project as p inner join ts.projectEvent as pe inner join ts.TSServiceType as st";
			SQLStr = SQLStr + " where tsm.Period = :DataPeriod and p.ProjectManager.userLoginId = :DataUser";
			if (!SelStatus.equals("")) {
				SQLStr = SQLStr + " and ts.Status =  '" + SelStatus + "'";
			}
			SQLStr = SQLStr + " order by tsm.tsmId,p.projId, tsm.TsmUser.userLoginId, pe.peventId ,st.Id, ts.TsDate";
			Query q = hs.createQuery(SQLStr);
			q.setParameter("DataPeriod", DataPeriod);
			q.setParameter("DataUser", UserId);
			result = q.list();
			Iterator itMstrDet = result.iterator();
			
			request.setAttribute("QryList", result);
			// set display result to request
			Date dayEnd = UtilDateTime.getDiffDay(dayStart, 6);
			request.setAttribute("FreezeFlag", FreezeDateCheck(dayEnd));
			return (mapping.findForward("success"));
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return (mapping.findForward("success"));
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
	}
}

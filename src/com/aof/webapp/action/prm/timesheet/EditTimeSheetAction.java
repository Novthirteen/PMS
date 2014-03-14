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
import com.aof.component.prm.TimeSheet.TimeSheetForecastDetail;
import com.aof.component.prm.TimeSheet.TimeSheetMaster;
import com.aof.component.prm.project.ConsultantCost;
import com.aof.component.prm.project.FMonth;
import com.aof.component.prm.project.ProjectEvent;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;
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
public class EditTimeSheetAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	
	private java.util.ArrayList mailtoList = new ArrayList();
	
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditTimeSheetAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		
		// get parameters from ListTimeSheet page
		String action = request.getParameter("FormAction");
		String UserId = request.getParameter("UserId");
		String DepartmentId = request.getParameter("DepartmentId");
		String DataPeriod = request.getParameter("DataId");
		
		if (UserId == null) UserId = "";
		if (DepartmentId == null) DepartmentId = "";
		if (DataPeriod == null) DataPeriod = "";
		if (action == null) action = "view";
		
		
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
		TimeSheetMaster tsm = null;
		
		if (!isTokenValid(request)) {
			if(action.equals("update")){
				action ="view";
			}
		}
		saveToken(request);
		
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			List result = new ArrayList();
			// query the record from TimeSheetMaster according to loginId and period
			Query q =
				hs.createQuery(
					"select tsm from TimeSheetMaster as tsm inner join tsm.TsmUser as tUser where tsm.Period = :DataPeriod and tUser.userLoginId = :DataUser");
			q.setParameter("DataPeriod", DataPeriod);
			q.setParameter("DataUser", UserId);
			result = q.list();
			List result2 = result;
			Iterator itMstr = result.iterator();
			
			if (itMstr.hasNext()) {
				// set query result to request
				request.setAttribute("QryMaster", result);
				tsm = (TimeSheetMaster) itMstr.next();
			} else {
				tx = hs.beginTransaction();
				tsm = new TimeSheetMaster();
				UserLogin ul = (UserLogin) hs.load(UserLogin.class, UserId);
				tsm.setStatus("draft");
				tsm.setPeriod(DataPeriod);
				tsm.setTsmUser(ul);
				tsm.setTotalHours(new Float(0));
				tsm.setUpdateDate(new Date());
				hs.save(tsm);

				result = new ArrayList();
				result.add(tsm);
				itMstr = result.iterator();
				request.setAttribute("QryMaster", result);
				tx.commit();
			}
			for (int i = 0; i < 7; i++) {
				DayArray[i] = Date_formater.format(UtilDateTime.getDiffDay(dayStart, i));
			}
			result = null;
			
			if (action.equals("create")) {// create
				InsertTSDetail(tsm, request, DayArray);
				UpdateTSDetail(tsm, request, DayArray,"update");
			} 
			
			if (action.equals("update")) {//	update
				UpdateTSDetail(tsm, request, DayArray,"update");
				
				String saveType = request.getParameter("SaveType");
				if(saveType == null)
					saveType = "";
				if(saveType.equals("Submit Record")){
					java.util.Set set = tsm.getDetails();
					Iterator i1 = set.iterator();
					while(i1.hasNext()){
						String status = ((TimeSheetDetail)i1.next()).getStatus();
						if(status.equals("draft") || status.equals("Rejected")){							
							EmailService.sendMail(tsm);
							break;
						}
					}
				}
				
			} 
			
			if (action.equals("delete")) {// delete
				UpdateTSDetail(tsm, request, DayArray,"delete");
			}
			if (action.equals("UpdateFromForecast")) {
				UpdateFromForecast(tsm);
			}
			if (action.equals("UpdateFromTS")) {
				UpdateFromTS(tsm,Date_formater.format(UtilDateTime.getDiffDay(dayStart, -7)));
			}
			result = fetchTSDetail(tsm);
			request.setAttribute("QryDetail", result);
			
			if (result != null) {
				ProjectMaster oldProj = null;
				ProjectMaster newProj = null;
				ProjectEvent oldEvent = null;
				ProjectEvent newEvent = null;
				ServiceType oldType = null;
				ServiceType newType = null;				
				Boolean hasCAFed = Boolean.FALSE;
				List canNotRemoved = new ArrayList();
				for (int i0 = 0; i0 < result.size(); i0++) {
					TimeSheetDetail tsd = (TimeSheetDetail)result.get(i0);
					newProj = tsd.getProject();
					newEvent = tsd.getProjectEvent();
					newType = tsd.getTSServiceType();
					if (!newProj.equals(oldProj)
							|| !newEvent.equals(oldEvent)
							|| !newType.equals(oldType)) {
						if (i0 != 0) {
							canNotRemoved.add(hasCAFed);
						}
						oldProj = newProj;
						oldEvent = newEvent;
						oldType = newType;
						hasCAFed = Boolean.FALSE;
					}
					
					if ((tsd.getConfirm() != null && tsd.getConfirm().trim().equalsIgnoreCase("Confirmed"))
							|| (tsd.getCAFStatusConfirm() != null && tsd.getCAFStatusConfirm().trim().equalsIgnoreCase("Y"))) {
						hasCAFed = Boolean.TRUE;
					}
				}
				
				canNotRemoved.add(hasCAFed);
				
				request.setAttribute("CanNotRemoved", canNotRemoved.toArray());
			}
			
			Date dayEnd = UtilDateTime.getDiffDay(dayStart, 6);
			request.setAttribute("FreezeFlag", FreezeDateCheck(dayEnd));
			
			//Sending Mail
			/* 			
			String saveType = request.getParameter("SaveType");
			if(saveType == null) 
				saveType = "";
			if(saveType.equals("Submit Record")){
				Iterator itMail = mailtoList.iterator();
				java.util.ArrayList list = new ArrayList();
				while(itMail.hasNext()){
					TimeSheetDetail tsd = (TimeSheetDetail)itMail.next();
					String s = tsd.getProject().getProjName()+tsd.getProjectEvent().getPeventName();
					if(!list.contains(s)){
						list.add(s);
						if(!tsd.getProject().getProjectCategory().getId().equals("I"))
							EmailService.notifyUser(tsm,tsd);
					}
					else
						continue;
				}
				mailtoList.clear();
			}
			*/			
			
			
			return (mapping.findForward("success"));
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			if (tsm!= null) {
				List result = fetchTSDetail(tsm);
				request.setAttribute("QryDetail", result);
				Date dayEnd = UtilDateTime.getDiffDay(dayStart, 6);
				request.setAttribute("FreezeFlag", FreezeDateCheck(dayEnd));
			}
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
	
	private void InsertTSDetail (TimeSheetMaster tsm,HttpServletRequest request,String DayArray[]) {
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			String projectCode = request.getParameter("hiddenProjectCode");
			Integer eventCode = new Integer(request.getParameter("hiddenEventCode"));
			Long ServiceTypeCode = new Long(request.getParameter("hiddenServiceType"));
			Query q = hs.createQuery(
				"select ts from TimeSheetDetail as ts inner join ts.TimeSheetMaster as tsm inner join ts.Project as p inner join ts.projectEvent as pe inner join ts.TSServiceType as st where tsm.tsmId = :TSMasterId and p.projId = :projectCode and pe.peventId = :eventCode and st.Id = :ServiceTypeId");
			q.setParameter("TSMasterId", tsm.getTsmId());
			q.setParameter("projectCode", projectCode);
			q.setParameter("eventCode", eventCode);
			q.setParameter("ServiceTypeId", ServiceTypeCode);
			List result = q.list();
			Iterator tsmList = result.iterator();
			if (!tsmList.hasNext()) {
				//create new TimeSheetDetail
				tx = hs.beginTransaction();
				TimeSheetDetail ts = new TimeSheetDetail();
				
				ts.setTimeSheetMaster(tsm);
				ProjectMaster projectMaster =(ProjectMaster) hs.load(ProjectMaster.class,projectCode);
				ts.setProject(projectMaster);
				ProjectEvent projectEvent =(ProjectEvent) hs.load(ProjectEvent.class, eventCode);
				ts.setProjectEvent(projectEvent);
				ServiceType st =(ServiceType) hs.load(ServiceType.class, ServiceTypeCode);
				
				Double CostRate = GetCostRate(tsm,st);
				ts.setTsRateUser(new Double(CostRate.doubleValue() / 8));
				ts.setTSServiceType(st);
				ts.setTsHoursUser(new Float(0));
				ts.setTsHoursConfirm(new Float(0));
				ts.setStatus("draft");
				ts.setConfirm("draft");
				ts.setCAFStatusUser("N");
				ts.setCAFStatusConfirm("N");
				ts.setTsDate(UtilDateTime.toDate2(DayArray[0] + " 00:00:00.000"));
				hs.save(ts);
				tx.commit();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private void UpdateTSDetail (TimeSheetMaster tsm,HttpServletRequest request,String DayArray[], String ActionType) {
		float totalCount = 0;
		
		String projId[] = request.getParameterValues("projId");
		String PEventId[] = request.getParameterValues("PEventId");
		String PSTId[] = request.getParameterValues("PSTId");
		String chk[] = request.getParameterValues("chk");
		String saveType = request.getParameter("SaveType");
		if(saveType == null)	saveType = "";
		
		int ckrow = 0;
		int ChkSize = 0;
		
		if (chk == null || 
			/* Modification : incorrect condition , by Bill Yu
			!(ActionType.equals("delete") || (ActionType.equals("update")&&saveType.equals("Submit Record")))) {
			*///replace code below
			!(ActionType.equals("delete"))){
			/*Modification end */
			chk = new String[1];
			chk[0] = "-1";
		} else {
			ChkSize = java.lang.reflect.Array.getLength(chk);
		}
		
		if (projId != null) {
			int RowSize = java.lang.reflect.Array.getLength(projId);
			try {
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				TimeSheetDetail ts = null;
				tx = hs.beginTransaction();
				
				for (int i = 1; i <= RowSize; i++) {
					String tsId[] = request.getParameterValues("tsId" + i);
					String RecordVal[] =request.getParameterValues("RecordVal" + i);
					
					ProjectMaster projectMaster =(ProjectMaster) hs.load(ProjectMaster.class,projId[i - 1].toString());
					ProjectEvent projectEvent =(ProjectEvent) hs.load(ProjectEvent.class,new Integer(PEventId[i - 1]));
					ServiceType st = (ServiceType) hs.load(ServiceType.class, new Long(PSTId[i - 1]));
					int ColSize = 0;
					if (tsId != null) ColSize= java.lang.reflect.Array.getLength(tsId);
					
					Double CostRate = GetCostRate(tsm,st);
				
					if (ckrow < ChkSize && i == new Integer(chk[ckrow]).intValue()) {
						for (int j = 0; j < ColSize; j++) {
							if (!tsId[j].trim().equals("")) {
								ts =(TimeSheetDetail) hs.load(TimeSheetDetail.class,new Integer(tsId[j]));
								//Modification : ts with status "Approved" cannot be deleted , by Bill Yu 
								if(ts.getStatus().equals("Approved")){
									request.setAttribute("deleteWarn", "yes");
									break;
								}
								if (ts != null && ActionType.equals("delete")) 
									hs.delete(ts);
								/*
								if(ts != null && ActionType.equals("update")){
									ts.setStatus("Submitted");
									mailtoList.add(ts);	
								}
								*/
							}
						}
						ckrow++;
					} else {
						int ckcol = 0;
						
						for (int j = 0; j < ColSize; j++) {
							if (tsId[j].trim().equals("")) {
								//Create a new record
								if (!(new Float(RecordVal[j]).floatValue() == 0)) {
									ts = new TimeSheetDetail();
									ts.setProject(projectMaster);
									ts.setProjectEvent(projectEvent);
									ts.setTSServiceType(st);
									ts.setTsHoursUser(new Float(RecordVal[j]));
									ts.setTsHoursConfirm(new Float(RecordVal[j]));
									ts.setStatus("draft");
									ts.setConfirm("draft");
									ts.setCAFStatusUser("N");
									ts.setCAFStatusConfirm("N");
									ts.setTsDate(UtilDateTime.toDate2(DayArray[j] + " 00:00:00.000"));
									tsm.addDetails(ts);
									ts.setTsRateUser(new Double(CostRate.doubleValue() / 8));
									hs.save(ts);
									totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
								}
							} else {
								//Update a old record
								ts = (TimeSheetDetail) hs.load(TimeSheetDetail.class,new Integer(tsId[j]));
								//update
								if (!ts.getStatus().trim().equals("Approved") && !ts.getConfirm().trim().equals("Confirmed")) {
									ts.setTsHoursUser(new Float(RecordVal[j]));
									ts.setTsHoursConfirm(new Float(RecordVal[j]));
									if(ts.getStatus().trim().equals("Submitted"))
										ts.setStatus("Submitted");
									else
										ts.setStatus("draft");
									ts.setTsRateUser(new Double(CostRate.doubleValue() / 8));
									hs.update(ts);
								}
								totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
							}
						}
					}
				}	
				tsm.setTotalHours(new Float(totalCount));
				tsm.setUpdateDate(new Date());
				tx.commit();
				
			}catch (Exception e) {
				e.printStackTrace();
			} 
		}
	}
	
	private List fetchTSDetail (TimeSheetMaster tsm) {
		List result = null;
		if (tsm != null) {
			Transaction tx = null;
			try {
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				String QryStr = "select ts from TimeSheetDetail as ts inner join ts.TimeSheetMaster as tsm inner join ts.Project as p inner join ts.projectEvent as pe inner join ts.TSServiceType as st where tsm.tsmId = :TSMasterId order by p.projId, pe.peventId , st.Id, ts.TsDate";
				Query q = hs.createQuery(QryStr);
				q.setParameter("TSMasterId", tsm.getTsmId());
				result = q.list();
			} catch (Exception e) {
				e.printStackTrace();
			} 
		}
		return result;
	}
	
	private void UpdateFromTS (TimeSheetMaster tsm, String PrevDataPeriod){
		Transaction tx = null;
		try {
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			
			Query q = hs.createQuery("select ts from TimeSheetDetail as ts inner join ts.TimeSheetMaster as tsm where tsm.tsmId = :TSMasterId");
			q.setParameter("TSMasterId", tsm.getTsmId());
			List result = q.list();
			Iterator itTs = result.iterator();
			if (!itTs.hasNext()) {
				tx = hs.beginTransaction();
				q = hs.createQuery("select ts from TimeSheetDetail as ts inner join ts.TimeSheetMaster as tsm where tsm.TsmUser = :UserId and tsm.Period = :DataPeriod");
				q.setParameter("UserId", tsm.getTsmUser().getUserLoginId());
				q.setParameter("DataPeriod", PrevDataPeriod);
				result = q.list();
				itTs = result.iterator();
				while (itTs.hasNext()) {
					TimeSheetDetail PreTs = (TimeSheetDetail)itTs.next();
					TimeSheetDetail CurrTs = new TimeSheetDetail();
					
					Double CostRate = GetCostRate(tsm,PreTs.getTSServiceType());
					
					CurrTs.setTimeSheetMaster(tsm);
					CurrTs.setStatus("draft");
					CurrTs.setConfirm("draft");
					CurrTs.setProject(PreTs.getProject());
					CurrTs.setProjectEvent(PreTs.getProjectEvent());
					CurrTs.setTSServiceType(PreTs.getTSServiceType());
					CurrTs.setTsDate(UtilDateTime.getDiffDay(PreTs.getTsDate(), 7));
					CurrTs.setTsRateUser(new Double(CostRate.doubleValue() / 8));
					CurrTs.setCAFStatusUser(PreTs.getCAFStatusUser());
					CurrTs.setCAFStatusConfirm(PreTs.getCAFStatusUser());
					CurrTs.setTsHoursUser(PreTs.getTsHoursUser());
					CurrTs.setTsHoursConfirm(PreTs.getTsHoursUser());
					hs.save(CurrTs);
				}
				tx.commit();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private void UpdateFromForecast (TimeSheetMaster tsm){
		Transaction tx = null;
		try {
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			
			Query q = hs.createQuery("select ts from TimeSheetDetail as ts inner join ts.TimeSheetMaster as tsm where tsm.tsmId = :TSMasterId");
			q.setParameter("TSMasterId", tsm.getTsmId());
			List result = q.list();
			Iterator itTs = result.iterator();
			if (!itTs.hasNext()) {
				tx = hs.beginTransaction();
				q = hs.createQuery("select ts from TimeSheetForecastDetail as ts inner join ts.TimeSheetForecastMaster as tsm " +
						"where tsm.TsmUser = :UserId and tsm.Period = :DataPeriod and ts.Project is not null ");
				q.setParameter("UserId", tsm.getTsmUser().getUserLoginId());
				q.setParameter("DataPeriod", tsm.getPeriod());
				result = q.list();
				itTs = result.iterator();
				while (itTs.hasNext()) {
					TimeSheetForecastDetail PreTs = (TimeSheetForecastDetail)itTs.next();
					TimeSheetDetail CurrTs = new TimeSheetDetail();
					
					Double CostRate = GetCostRate(tsm,PreTs.getTSServiceType());
					
					CurrTs.setTimeSheetMaster(tsm);
					CurrTs.setStatus("draft");
					CurrTs.setConfirm("draft");
					CurrTs.setProject(PreTs.getProject());
					CurrTs.setProjectEvent(PreTs.getProjectEvent());
					CurrTs.setTSServiceType(PreTs.getTSServiceType());
					CurrTs.setTsDate(PreTs.getTsDate());
					CurrTs.setTsRateUser(new Double(CostRate.doubleValue() / 8));
					CurrTs.setCAFStatusUser("N");
					CurrTs.setCAFStatusConfirm("N");
					CurrTs.setTsHoursUser(PreTs.getTsHoursUser());
					CurrTs.setTsHoursConfirm(PreTs.getTsHoursUser());
					hs.save(CurrTs);
				}
				tx.commit();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private Double GetCostRate(TimeSheetMaster tsm,ServiceType st) {
		Double CostRate = new Double(0);
		try {
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			String PartyNote = tsm.getTsmUser().getNote();
			if (PartyNote == null) PartyNote = "";
			if (PartyNote.equals("EXT")) {
				return st.getSubContractRate();
			} else {
				Query q = hs.createQuery("select fm from FMonth as fm where fm.DateTo >=:DataPeriod and fm.DateFrom <=:DataPeriod");
				q.setParameter("DataPeriod",UtilDateTime.toDate2(tsm.getPeriod() + " 00:00:00.000"));
				List result = q.list();
				Iterator itFm = result.iterator();
				if (itFm.hasNext()) {
					FMonth fm =(FMonth)itFm.next();
					q = hs.createQuery("select cr from ConsultantCost cr inner join cr.User as ul where ul.userLoginId = :UserId and cr.Year =:CRYear");
					q.setParameter("UserId", tsm.getTsmUser().getUserLoginId());
					q.setParameter("CRYear", fm.getYear());
					result = q.list();
					Iterator itCR = result.iterator();
					if (itCR.hasNext()) {
						ConsultantCost cr = (ConsultantCost)itCR.next();
						return new Double(cr.getCost().doubleValue());
					}
				} 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CostRate;
	}
}

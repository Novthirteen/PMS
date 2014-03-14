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
import com.aof.component.prm.TimeSheet.TimeSheetForecastDetail;
import com.aof.component.prm.TimeSheet.TimeSheetForecastMaster;
import com.aof.component.prm.project.ProjectEvent;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
/**
 * @author xxp 
 * @version 2003-7-2
 *	update time 2004-12-2
 */
public class EditTSForecastAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditTSForecastAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		// get parameters from ListTimeSheet page
		String action = request.getParameter("FormAction");
		String UserId = request.getParameter("UserId");
		String DepartmentId = request.getParameter("DepartmentId");
		String DataPeriod = request.getParameter("DataId");
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
		if (UserId == null) UserId = "";
		if (DepartmentId == null) DepartmentId = "";
		if (DataPeriod == null) DataPeriod = "2004-11-01";
		if (action == null) action = "view";
		
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
			TimeSheetForecastMaster tsm = null;
			// query the record from TimeSheetForecastMaster according to loginId and period
			Query q =
				hs.createQuery(
					"select tsm from TimeSheetForecastMaster as tsm inner join tsm.TsmUser as tUser where tsm.Period = :DataPeriod and tUser.userLoginId = :DataUser");
			q.setParameter("DataPeriod", DataPeriod);
			q.setParameter("DataUser", UserId);
			result = q.list();
			Iterator itMstr = result.iterator();

			if (itMstr.hasNext()) {
				// set query result to request
				request.setAttribute("QryMaster", result);
				tsm = (TimeSheetForecastMaster) itMstr.next();
			} else {
				tx = hs.beginTransaction();
				tsm = new TimeSheetForecastMaster();
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
				DayArray[i] =
					Date_formater.format(UtilDateTime.getDiffDay(dayStart, i));
			}
			// create
			if (action.equals("create")) {
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				try {
					String projectCode = request.getParameter("hiddenProjectCode");
					String hiddenEventCode = request.getParameter("hiddenEventCode");
					Integer eventCode = null;
					if (hiddenEventCode != null && hiddenEventCode.trim().length() != 0) {
					    eventCode = new Integer(hiddenEventCode );
					}
					String hiddenServiceType = request.getParameter("hiddenServiceType");
					Long ServiceTypeCode =  null;
					if (hiddenServiceType != null && hiddenServiceType.trim().length() != 0) {
					    ServiceTypeCode = new Long(request.getParameter("hiddenServiceType"));
					}
					String description = request.getParameter("hiddenDescription");
					
					if (projectCode == null || projectCode.trim().length() == 0) {
					    q = hs.createQuery("select ts from TimeSheetForecastDetail as ts inner join ts.TimeSheetForecastMaster as tsm " +
					    		" where tsm.tsmId = :TSMasterId " +
					    		"   and ts.Project is null ");
						q.setParameter("TSMasterId", tsm.getTsmId());
						//q.setParameter("projectCode", projectCode);
						//q.setParameter("eventCode", eventCode);
						//q.setParameter("ServiceTypeId", ServiceTypeCode);
						result = q.list();
						Iterator tsmList = result.iterator();
						if (tsmList.hasNext()) {
						    q = hs.createQuery("select ts from TimeSheetForecastDetail as ts " +
									"inner join ts.TimeSheetForecastMaster as tsm " +
									"left join ts.Project as p " +
									"left join ts.projectEvent as pe " +
									"left join ts.TSServiceType as st " +
									"where tsm.tsmId = :TSMasterId order by p.projId, pe.peventId , st.Id, ts.TsDate");
							q.setParameter("TSMasterId", tsm.getTsmId());
							result = q.list();
							// set display result to request
							request.setAttribute("QryDetail", result);
							return (mapping.findForward("success"));
						}
						// create new TimeSheetForecastDetail
						tx = hs.beginTransaction();
						TimeSheetForecastDetail ts = new TimeSheetForecastDetail();
						ts.setTimeSheetForecastMaster(tsm);
						//ProjectMaster projectMaster =(ProjectMaster) hs.load(ProjectMaster.class,projectCode);
						//ts.setProject(projectMaster);
						//ProjectEvent projectEvent =(ProjectEvent) hs.load(ProjectEvent.class, eventCode);
						//ts.setProjectEvent(projectEvent);
						//ServiceType st =(ServiceType) hs.load(ServiceType.class, ServiceTypeCode);
						//ts.setTSServiceType(st);
						ts.setTsHoursUser(new Float(0));
						ts.setTsHoursConfirm(new Float(0));
						ts.setStatus("");
						ts.setTsDate(UtilDateTime.toDate2(DayArray[1] + " 00:00:00.000"));
						ts.setDescription(description);
						hs.save(ts);
						tx.commit();
					} else {
						q = hs.createQuery("select ts from TimeSheetForecastDetail as ts inner join ts.TimeSheetForecastMaster as tsm inner join ts.Project as p inner join ts.projectEvent as pe inner join ts.TSServiceType as st where tsm.tsmId = :TSMasterId and p.projId = :projectCode and pe.peventId = :eventCode and st.Id = :ServiceTypeId");
						q.setParameter("TSMasterId", tsm.getTsmId());
						q.setParameter("projectCode", projectCode);
						q.setParameter("eventCode", eventCode);
						q.setParameter("ServiceTypeId", ServiceTypeCode);
						result = q.list();
						Iterator tsmList = result.iterator();
						if (tsmList.hasNext()) {
							q = hs.createQuery("select ts from TimeSheetForecastDetail as ts " +
									"inner join ts.TimeSheetForecastMaster as tsm " +
									"left join ts.Project as p " +
									"left join ts.projectEvent as pe " +
									"left join ts.TSServiceType as st " +
									"where tsm.tsmId = :TSMasterId order by p.projId, pe.peventId , st.Id, ts.TsDate");
							q.setParameter("TSMasterId", tsm.getTsmId());
							result = q.list();
							// set display result to request
							request.setAttribute("QryDetail", result);
							return (mapping.findForward("success"));
						}
						// create new TimeSheetForecastDetail
						tx = hs.beginTransaction();
						TimeSheetForecastDetail ts = new TimeSheetForecastDetail();
						ts.setTimeSheetForecastMaster(tsm);
						ProjectMaster projectMaster =(ProjectMaster) hs.load(ProjectMaster.class,projectCode);
						ts.setProject(projectMaster);
						ProjectEvent projectEvent =(ProjectEvent) hs.load(ProjectEvent.class, eventCode);
						ts.setProjectEvent(projectEvent);
						ServiceType st =(ServiceType) hs.load(ServiceType.class, ServiceTypeCode);
						ts.setTSServiceType(st);
						ts.setTsHoursUser(new Float(0));
						ts.setTsHoursConfirm(new Float(0));
						ts.setStatus("");
						ts.setTsDate(UtilDateTime.toDate2(DayArray[1] + " 00:00:00.000"));
						ts.setDescription(description);
						hs.save(ts);
						tx.commit();
					}
					log.info("go to >>>>>>>>>>>>>>>>. view forward");
				} catch (Exception e) {
					e.printStackTrace();
				}
				//	update
			} 
			if (action.equals("update") || action.equals("create")) {
				String projId[] = request.getParameterValues("projId");
				String PEventId[] = request.getParameterValues("PEventId");
				String PSTId[] = request.getParameterValues("PSTId");
				String description[] = request.getParameterValues("description");
				
				if (projId != null) {
					int RowSize = java.lang.reflect.Array.getLength(projId);
					TimeSheetForecastDetail ts = null;

					q =
						hs.createQuery("select p.projId, pe.peventId ,ts.TsDate from TimeSheetForecastDetail as ts " +
								"inner join ts.TimeSheetForecastMaster as tsm " +
								"left join ts.Project as p " +
								"left join ts.projectEvent as pe " +
								"where tsm.tsmId = :TSMasterId order by p.projId, pe.peventId ,ts.TsDate");
					q.setParameter("TSMasterId", tsm.getTsmId());
					result = q.list();
					
					tx = hs.beginTransaction();
					for (int i = 1; i <= RowSize; i++) {
						String tsId[] = request.getParameterValues("tsId" + i);
						String RecordVal[] =request.getParameterValues("RecordVal" + i);
						int ColSize = java.lang.reflect.Array.getLength(tsId);
						ProjectMaster projectMaster = null;
						if (projId[i - 1] != null && projId[i - 1].trim().length() != 0) {
						    projectMaster =(ProjectMaster) hs.load(ProjectMaster.class,projId[i - 1].toString());
						}
						ProjectEvent projectEvent = null;
						if (PEventId[i - 1] != null && PEventId[i - 1].trim().length() != 0) {
						    projectEvent = (ProjectEvent) hs.load(ProjectEvent.class,new Integer(PEventId[i - 1]));
						}
						ServiceType st = null;
						if (PSTId[i - 1] != null && PSTId[i - 1].trim().length() != 0) {
						    st = (ServiceType) hs.load(ServiceType.class, new Long(PSTId[i - 1]));
						}
						if (tsId != null) {
							for (int j = 0; j < ColSize; j++) {
								if (tsId[j].trim().equals("")) {
									//Create a new record
									if (!(new Float(RecordVal[j]).floatValue() == 0)) {
										log.info("create");
										ts = new TimeSheetForecastDetail();
										ts.setProject(projectMaster);
										ts.setProjectEvent(projectEvent);
										ts.setTSServiceType(st);
										ts.setTsHoursUser(new Float(RecordVal[j]));
										ts.setTsHoursConfirm(new Float(0));
										ts.setStatus("");
										ts.setTsDate(UtilDateTime.toDate2(DayArray[j] + " 00:00:00.000"));
										ts.setDescription(description[i - 1]);
										tsm.addDetails(ts);
										hs.save(ts);
										totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
									}
								} else { //Update a old record
									ts =(TimeSheetForecastDetail) hs.load(TimeSheetForecastDetail.class,new Integer(tsId[j]));
									ts.setTimeSheetForecastMaster(tsm);
									ts.setProject(projectMaster);
									ts.setProjectEvent(projectEvent);
									ts.setTSServiceType(st);
									ts.setTsHoursUser(new Float(RecordVal[j]));
									ts.setTsHoursConfirm(new Float(0));
									ts.setStatus("");
									ts.setCAFStatusUser("");
									ts.setCAFStatusConfirm("");
									ts.setTsDate(UtilDateTime.toDate2(DayArray[j] + " 00:00:00.000"));
									ts.setDescription(description[i - 1]);
									hs.update(ts);
									totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
								}
							}
							//update TimeSheetForecastMaster
							tsm.setTotalHours(new Float(totalCount));
							tsm.setUpdateDate(new Date());
						}
					}
					tx.commit();
				}
				// delete
			} 
			if (action.equals("delete")) {
				String projId[] = request.getParameterValues("projId");
				String PEventId[] = request.getParameterValues("PEventId");
				String PSTId[] = request.getParameterValues("PSTId");
				String chk[] = request.getParameterValues("chk");
				String description[] = request.getParameterValues("description");
				
				int k = 0;
				if (projId != null) {
					int RowSize = java.lang.reflect.Array.getLength(projId);
					TimeSheetForecastDetail ts = null;

					for (int i = 1; i <= RowSize; i++) {
						String tsId[] = request.getParameterValues("tsId" + i);
						String RecordVal[] =request.getParameterValues("RecordVal" + i);
						int ColSize = java.lang.reflect.Array.getLength(tsId);
						ProjectMaster projectMaster = null;
						if (projId[i - 1] != null && projId[i - 1].trim().length() != 0) {
						    projectMaster =(ProjectMaster) hs.load(ProjectMaster.class,projId[i - 1].toString());
						}
						ProjectEvent projectEvent = null;
						if (PEventId[i - 1] != null && PEventId[i - 1].trim().length() != 0) {
						    projectEvent = (ProjectEvent) hs.load(ProjectEvent.class,new Integer(PEventId[i - 1]));
						}
						ServiceType st = null;
						if (PSTId[i - 1] != null && PSTId[i - 1].trim().length() != 0) {
						    st = (ServiceType) hs.load(ServiceType.class, new Long(PSTId[i - 1]));
						}
						if (chk != null) {
							int ChkSize =java.lang.reflect.Array.getLength(chk);
							if (k < ChkSize && i == new Integer(chk[k]).intValue()) {
								if (tsId != null) {
									tx = hs.beginTransaction();
									for (int j = 0; j < ColSize; j++) {
										if (!tsId[j].trim().equals("")) {
											//delete records which were selected
											ts =(TimeSheetForecastDetail) hs.load(TimeSheetForecastDetail.class,new Integer(tsId[j]));
											if (ts != null) {
												hs.delete(ts);
											}
										}
									}
									tx.commit();
								}
								k++;
							} else {
								if (tsId != null) {
									tx = hs.beginTransaction();
									for (int j = 0; j < ColSize; j++) {
										log.info("tsId[j]" + j + "=" + tsId[j]);
										if (tsId[j].trim().equals("")) {
											//Create a new record
											if (!(new Float(RecordVal[j]).floatValue() == 0)) {
												log.info("create");
												ts =new TimeSheetForecastDetail();
												ts.setProject(projectMaster);
												ts.setProjectEvent(projectEvent);
												ts.setTSServiceType(st);
												ts.setTsHoursUser(new Float(RecordVal[j]));
												ts.setTsHoursConfirm(new Float(0));
												ts.setStatus("");
												ts.setCAFStatusUser("");
												ts.setCAFStatusConfirm("");
												ts.setTsDate(UtilDateTime.toDate2(DayArray[j]+ " 00:00:00.000"));
												ts.setDescription(description[i - 1]);
												tsm.addDetails(ts);
												hs.save(ts);
												hs.flush();
												totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
											}
										} else { //Update a old record
											ts =(TimeSheetForecastDetail) hs.load(TimeSheetForecastDetail.class,new Integer(tsId[j]));
											ts.setTimeSheetForecastMaster(tsm);
											ts.setProject(projectMaster);
											ts.setProjectEvent(projectEvent);
											ts.setTSServiceType(st);
											ts.setTsHoursUser(new Float(RecordVal[j]));
											ts.setTsHoursConfirm(new Float(0));
											ts.setStatus("");
											ts.setCAFStatusUser("");
											ts.setCAFStatusConfirm("");
											ts.setTsDate(UtilDateTime.toDate2(DayArray[j]+ " 00:00:00.000"));
											ts.setDescription(description[i - 1]);
											hs.update(ts);
											totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
										}
									}
								}
							}
						} else {
							if (tsId != null) {
								tx = hs.beginTransaction();
								for (int j = 0; j < ColSize; j++) {
									log.info("tsId[j]" + j + "=" + tsId[j]);
									if (tsId[j].equals("")|| tsId[j].equals(" ")) {
										//Create a new record
										if (!(new Float(RecordVal[j]).floatValue() == 0)) {
											log.info("create");
											ts = new TimeSheetForecastDetail();
											ts.setProject(projectMaster);
											ts.setProjectEvent(projectEvent);
											ts.setTSServiceType(st);
											ts.setTsHoursUser(
												new Float(RecordVal[j]));
											ts.setTsHoursConfirm(new Float(0));
											ts.setStatus("");
											ts.setCAFStatusUser("");
											ts.setCAFStatusConfirm("");
											ts.setTsDate(UtilDateTime.toDate2(DayArray[j]+ " 00:00:00.000"));
											ts.setDescription(description[i - 1]);
											tsm.addDetails(ts);
											hs.save(ts);
											hs.flush();
											totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
										}
									} else { //Update a old record
										ts =(TimeSheetForecastDetail) hs.load(TimeSheetForecastDetail.class,new Integer(tsId[j]));
										ts.setTimeSheetForecastMaster(tsm);
										ts.setProject(projectMaster);
										ts.setProjectEvent(projectEvent);
										ts.setTSServiceType(st);
										ts.setTsHoursUser(new Float(RecordVal[j]));
										ts.setTsHoursConfirm(new Float(0));
										ts.setStatus("");
										ts.setCAFStatusUser("");
										ts.setCAFStatusConfirm("");
										ts.setTsDate(UtilDateTime.toDate2(DayArray[j]+ " 00:00:00.000"));
										ts.setDescription(description[i - 1]);
										hs.update(ts);
										totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
									}
								}
							}
						}
					}
				}
				//update TimeSheetForecastMaster
				tsm = (TimeSheetForecastMaster) hs.load(TimeSheetForecastMaster.class,tsm.getTsmId());
				tsm.setTotalHours(new Float(totalCount));
				tsm.setUpdateDate(new Date());
				tx.commit();
			} else if (action.equals("back")) {
				return (mapping.findForward("backToList"));
			}
			// init display or refresh display
			q = hs.createQuery(
				"select ts from TimeSheetForecastDetail as ts inner join ts.TimeSheetForecastMaster as tsm " +
				"left join ts.Project as p " +
				"left join ts.projectEvent as pe " +
				"left join ts.TSServiceType as st " +
				"where tsm.tsmId = :TSMasterId " +
				"order by p.projId, pe.peventId , st.Id, ts.TsDate");
			q.setParameter("TSMasterId", tsm.getTsmId());
			result = q.list();
			// set display result to request
			request.setAttribute("QryDetail", result);
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

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
import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.component.prm.Bill.TransacationDetail;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.TimeSheet.TimeSheetDetail;
import com.aof.component.prm.TimeSheet.TimeSheetMaster;
import com.aof.component.prm.payment.PaymentTransactionDetail;
import com.aof.component.prm.project.ConsultantCost;
import com.aof.component.prm.project.FMonth;
import com.aof.component.prm.project.ProjectEvent;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
/**
 * @author xxp 
 * @version 2003-7-2
 *	update time 2004-12-2
 */
public class EditTSCAFUpdateAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditTSCAFUpdateAction.class.getName());
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
			if(action.equals("update") || action.equals("confirm")){
				action ="view";
			}
		}
		saveToken(request);
		
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			List result = new ArrayList();
			TimeSheetMaster tsm = null;
			// query the record from TimeSheetMaster according to loginId and period
			Query q =
				hs.createQuery(
					"select tsm from TimeSheetMaster as tsm " +
					" inner join tsm.TsmUser as tUser where tsm.Period = :DataPeriod and tUser.userLoginId = :DataUser");
			
			q.setParameter("DataPeriod", DataPeriod);
			q.setParameter("DataUser", UserId);
			result = q.list();
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
				DayArray[i] =Date_formater.format(UtilDateTime.getDiffDay(dayStart, i));
			}
			// update
			if (action.equals("update")) {
				UpdateTSDetail(tsm, request, DayArray, "update");
			}
			// confirm
			if (action.equals("confirm")) {
				UpdateTSDetail(tsm, request, DayArray, "confirm");
			}
			// init display or refresh display
			result = fetchTSDetail(tsm);
			request.setAttribute("QryDetail", result);
			
			if (result != null) {
				ProjectMaster oldProj = null;
				ProjectMaster newProj = null;
				ProjectEvent oldEvent = null;
				ProjectEvent newEvent = null;
				ServiceType oldType = null;
				ServiceType newType = null;	
				Boolean hasCAFed = Boolean.TRUE;
				Boolean hasConfirmed = Boolean.TRUE;
				List hasCAFList = new ArrayList();
				List hasConfirmList = new ArrayList();
				int confirmCount= 0;
				for (int i0 = 0; i0 < result.size(); i0++) {
					TimeSheetDetail tsd = (TimeSheetDetail)result.get(i0);
					newProj = tsd.getProject();
					newEvent = tsd.getProjectEvent();
					newType = tsd.getTSServiceType();
					if (!newProj.equals(oldProj)
							|| !newEvent.equals(oldEvent)
							|| !newType.equals(oldType)) {
						if (i0 != 0) {
							if (confirmCount < 7) {
							    hasConfirmed = Boolean.FALSE;
							}
							hasCAFList.add(hasCAFed);
							hasConfirmList.add(hasConfirmed);
						}
						oldProj = newProj;
						oldEvent = newEvent;
						oldType = newType;
						hasCAFed = Boolean.TRUE;
						hasConfirmed = Boolean.TRUE;

						confirmCount = 0;
					}
					
					if (tsd.getConfirm() != null && tsd.getConfirm().equalsIgnoreCase("Confirmed")) {
						confirmCount++;
					}
					
					if (tsd.getCAFStatusConfirm() != null && tsd.getCAFStatusConfirm().equalsIgnoreCase("N")) {					
						hasCAFed = Boolean.FALSE;
					}
				}
				
				if (confirmCount < 7) {
				    hasConfirmed = Boolean.FALSE;
				}
				hasCAFList.add(hasCAFed);
				hasConfirmList.add(hasConfirmed);
				
				request.setAttribute("hasCAFList", hasCAFList.toArray());
				request.setAttribute("hasConfirmList", hasConfirmList.toArray());
			}
			
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
	private void UpdateTSDetail (TimeSheetMaster tsm,HttpServletRequest request,String DayArray[],String ActionType) {
		float totalCount = 0;
	
		String projId[] = request.getParameterValues("projId");
		String PEventId[] = request.getParameterValues("PEventId");
		String PSTId[] = request.getParameterValues("PSTId");
		String chk[] = request.getParameterValues("chk");
		String cafChk[] =request.getParameterValues("cafChk");		
		int ckrow = 0;
		int ChkSize = 0;
		boolean ConfirmFlag =false;
		int ckcol = 0;
		int CAFChkSize = 0;
		boolean CAFFlag =false;
	
		if (chk == null || !ActionType.equals("confirm")) {
			chk = new String[1];
			chk[0] = "-1";
		} else {
			ChkSize = java.lang.reflect.Array.getLength(chk);
		}
		if (cafChk == null) {
			cafChk = new String[1];
			cafChk[0] = "-1";
		} else {
			CAFChkSize= java.lang.reflect.Array.getLength(cafChk); 
		}
		
		if (projId != null) {
			int RowSize = java.lang.reflect.Array.getLength(projId);
			try {
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				TimeSheetDetail ts = null;
				tx = hs.beginTransaction();
				Double CostRate = GetCostRate(tsm);
				
				for (int i = 1; i <= RowSize; i++) {
					String tsId[] = request.getParameterValues("tsId" + i);
					
					String RecordVal[] =request.getParameterValues("RecordVal" + i);
					
					String TSAllowance[] = request.getParameterValues("TSAllowance" + i); 
					
					String[] caf = request.getParameterValues("CAF" + i);
					
					String[] confirm = request.getParameterValues("Confirm" + i);
					
					ProjectMaster projectMaster =(ProjectMaster) hs.load(ProjectMaster.class,projId[i - 1].toString());
					ProjectEvent projectEvent =(ProjectEvent) hs.load(ProjectEvent.class,new Integer(PEventId[i - 1]));
					ServiceType st = (ServiceType) hs.load(ServiceType.class, new Long(PSTId[i - 1]));
					
					int ColSize = 0;
					
					if (tsId != null) ColSize= java.lang.reflect.Array.getLength(tsId);
					ConfirmFlag =false;
					if (ckrow < ChkSize && i == new Integer(chk[ckrow]).intValue()) {
						ConfirmFlag = true;
						ckrow++;
					} 
					CAFFlag =false;
					if (ckcol < CAFChkSize && i == new Integer(cafChk[ckcol]).intValue()) {
						CAFFlag = true;
						ckcol++;
					} 
					TransactionServices trs = new TransactionServices();
					
					String sqlStatment = " select ts from TimeSheetDetail as ts "
						               + "where ts.Project.projId = ? and ts.Status = 'Approved' ";
					Query query = hs.createQuery(sqlStatment);
					query.setString(0, projectMaster.getProjId());
					List result = query.list();
					String tsStatus = null;
					if (result != null && result.size() > 0) {
						tsStatus = "Approved";
					} else {
						tsStatus = "draft";
					}
					
					for (int j = 0; j < ColSize; j++) {
						if (tsId[j].trim().equals("")) {
							//Create a new record
							if (!(new Float(RecordVal[j]).floatValue() == 0f) 
							        || (TSAllowance != null && !(new Float(TSAllowance[j]).floatValue() == 0f))) {
								ts = new TimeSheetDetail();
								ts.setProject(projectMaster);
								ts.setProjectEvent(projectEvent);
								ts.setTSServiceType(st);
								ts.setTsHoursUser(new Float(0));
								ts.setTsHoursConfirm(new Float(RecordVal[j]));
								if (TSAllowance != null) {
									ts.setTSAllowance(new Float(TSAllowance[j]));
								}
								ts.setConfirm("draft");
								
								ts.setCAFStatusUser("N");
								ts.setCAFStatusConfirm("N");								
								for (int i0 = 0; caf != null && i0 < caf.length; i0++) {							    
								    if (caf[i0].equals(j + "")) {
								        ts.setCAFStatusUser("Y");
										ts.setCAFStatusConfirm("Y");
										
										break;
								    }
								}
								    
								/*
								if (CAFFlag) {
									ts.setCAFStatusUser("Y");
									ts.setCAFStatusConfirm("Y");
								} else {
									ts.setCAFStatusUser("N");
									ts.setCAFStatusConfirm("N");
								}
								*/
								ts.setTsDate(UtilDateTime.toDate2(DayArray[j] + " 00:00:00.000"));
								tsm.addDetails(ts);
								ts.setTsRateUser(CostRate);
								
								if (ActionType.equalsIgnoreCase("confirm")) {
								    for (int i0 = 0; confirm != null && i0 < confirm.length; i0++) {								    
									    if (confirm[i0].equals(j + "")) {
									        ts.setTsConfirmDate(new Date());
											ts.setConfirm("Confirmed");
											//trs.insert(ts,request);										
											break;
									    }
									}
								}
								/*
								if (ConfirmFlag) {
									ts.setTsConfirmDate(new Date());
									ts.setConfirm("Confirmed");
									trs.insert(ts,request);
								} 
								*/
								
								ts.setStatus(tsStatus);
								hs.save(ts);
								
								if (ts.getConfirm().trim().equalsIgnoreCase("Confirmed")) {
									UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
									trs.insert(ts,ul);				
								}
								totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
							}
						} else {
							//Update an old record
							ts = (TimeSheetDetail) hs.load(TimeSheetDetail.class,new Integer(tsId[j]));
							//update
							if (!ts.getConfirm().trim().equals("Confirmed")) {
								ts.setTsHoursConfirm(new Float(RecordVal[j]));
								if (TSAllowance != null) {
									ts.setTSAllowance(new Float(TSAllowance[j]));
								}
								ts.setCAFStatusConfirm("N");
								
								for (int i0 = 0; caf != null && i0 < caf.length; i0++) {								    
								    if (caf[i0].equals(j + "")) {
										ts.setCAFStatusConfirm("Y");										
										break;
								    }
								}
								
								/*
								if (CAFFlag) {
									ts.setCAFStatusConfirm("Y");
								} else {
									ts.setCAFStatusConfirm("N");
								}
								*/
								
								if (ActionType.equalsIgnoreCase("confirm")) {
									for (int i0 = 0; confirm != null && i0 < confirm.length; i0++) {								    
									    if (confirm[i0].equals(j + "")) {
									        ts.setTsConfirmDate(new Date());
											ts.setConfirm("Confirmed");
											ts.setStatus("Approved");
											UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
											trs.insert(ts,ul);	
											break;
									    }
									}
								}
								
								/*
								if (ConfirmFlag) {
									ts.setTsConfirmDate(new Date());
									ts.setConfirm("Confirmed");
									trs.insert(ts,request);
								} 
								*/
								hs.update(ts);							
							} else {
								//confirmed ts
								if (ActionType.equalsIgnoreCase("confirm")) {
									List list = trs.getInsertedTS(ts);
									
									if (list != null && list.size() > 0) {
										boolean hasInstructionFlg = false;
										for (int i0 = 0; i0 < list.size(); i0++) {
											TransacationDetail td = (TransacationDetail)list.get(i0);
											if (td instanceof BillTransactionDetail) {
												if (((BillTransactionDetail)td).getTransactionMaster() != null) {
													hasInstructionFlg = true;
													break;
												}
											} else {
												if (((PaymentTransactionDetail)td).getTransactionMaster() != null) {
													hasInstructionFlg = true;
													break;
												}
											}
										}
										
										if (!hasInstructionFlg) {
											boolean confirmFlg = false;
											for (int i0 = 0; confirm != null && i0 < confirm.length; i0++) {								    
											    if (confirm[i0].equals(j + "")) {
											    	confirmFlg = true;
													break;
											    }
											}
											
											if (!confirmFlg) {
												for (int i0 = 0; i0 < list.size(); i0++) {
													hs.delete(list.get(i0));
												}
												ts.setTsConfirmDate(null);
												ts.setConfirm("draft");
												
												hs.update(ts);
											}
										}
									} else {
										ts.setTsConfirmDate(null);
										ts.setConfirm("draft");
										
										hs.update(ts);
									}
								}
							}
							totalCount =totalCount+ new Float(RecordVal[j]).floatValue();
						}
					}
				}
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
				String QryStr = "select ts from TimeSheetDetail as ts inner join ts.TimeSheetMaster as tsm inner join ts.Project as p inner join ts.projectEvent as pe inner join ts.TSServiceType as st where tsm.tsmId = :TSMasterId and p.CAFFlag = 'Y' order by p.projId, pe.peventId , st.Id, ts.TsDate";
				Query q = hs.createQuery(QryStr);
				q.setParameter("TSMasterId", tsm.getTsmId());
				result = q.list();
			} catch (Exception e) {
				e.printStackTrace();
			} 
		}
		return result;
	}
	private Double GetCostRate(TimeSheetMaster tsm) {
		Double CostRate = new Double(0);
		try {
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CostRate;
	}
}

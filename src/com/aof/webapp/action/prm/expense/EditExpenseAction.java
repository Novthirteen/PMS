/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.expense;

import java.sql.SQLException;
import java.util.Locale;
import java.util.*;
import java.text.SimpleDateFormat;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.*;

import org.apache.log4j.Logger;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.component.prm.project.*;
import com.aof.component.prm.util.EmailService;
import com.aof.component.domain.party.*;
import com.aof.component.prm.expense.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;

/**
 * @author xxp
 * @version 2003-7-2
 * 
 */
public class EditExpenseAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	private boolean mailFlag = false;

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditExpenseAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");

		String FormStatus = request.getParameter("FormStatus");
		String ClaimType = request.getParameter("ClaimType");
		String action = request.getParameter("FormAction");
		String ExpenseCurrency = request.getParameter("ExpenseCurrency");
		String CurrencyRate = request.getParameter("CurrencyRate");

		if (FormStatus == null)
			FormStatus = "Draft";
		if (ClaimType == null)
			ClaimType = "CN";
		if (action == null)
			action = "view";
		if (ExpenseCurrency == null)
			ExpenseCurrency = "RMB";
		if (CurrencyRate == null)
			CurrencyRate = "0";

		if (!isTokenValid(request)) {
			if (action.equals("create") || action.equals("update")) {
				return (mapping.findForward("list"));
			}
		}
		saveToken(request);

		try {
			String DataId = request.getParameter("DataId");

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			Query q = null;

			if (action.equals("update")) {

				if ((DataId == null) || (DataId.length() < 1))
					actionDebug
							.addGlobalError(errors, "error.context.required");

				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				try {
					tx = hs.beginTransaction();
					ExpenseMaster findmaster = (ExpenseMaster) hs.load(
							ExpenseMaster.class, new Long(DataId));
					if (findmaster.getApprovalDate() == null) {
						// if (!findmaster.getStatus().equals("Approved")) {
						String ExpType[] = request
								.getParameterValues("ExpType");
						String DateId[] = request.getParameterValues("DateId");
						if (ExpType != null && DateId != null) {
							int RowSize = java.lang.reflect.Array
									.getLength(DateId);
							int ColSize = java.lang.reflect.Array
									.getLength(ExpType);
							float AmtValue[] = new float[ColSize];
							for (int j = 0; j < ColSize; j++) {
								AmtValue[j] = 0;
							}
							ExpenseDetail ed = null;
							for (int i = 0; i < RowSize; i++) {
								String RecId[] = request
										.getParameterValues("RecId" + i);
								String RecordVal[] = request
										.getParameterValues("RecordVal" + i);
								for (int j = 0; j < ColSize; j++) {
									if (RecId[j].trim().equals("")) {
										// Create a new Record
										if (!(new Float(RecordVal[j])
												.floatValue() == 0)) {
											ed = new ExpenseDetail();
											Date ExpenseDate = UtilDateTime
													.toDate2(DateId[i]
															+ " 00:00:00.000");
											ed.setExpenseDate(ExpenseDate);
											ed.setUserAmount((new Float(
													RecordVal[j])));
											AmtValue[j] = AmtValue[j]
													+ (new Float(RecordVal[j])
															.floatValue());
											ExpenseType eType = (ExpenseType) hs
													.load(ExpenseType.class,
															new Integer(
																	ExpType[j]));
											ed.setExpType(eType);
											ed.setExpMaster(findmaster);
											hs.save(ed);
										}
									} else {
										// Update Record
										ed = (ExpenseDetail) hs.load(
												ExpenseDetail.class, new Long(
														RecId[j]));
										Date ExpenseDate = UtilDateTime
												.toDate2(DateId[i]
														+ " 00:00:00.000");
										ed.setExpenseDate(ExpenseDate);
										ed.setUserAmount((new Float(
												RecordVal[j])));

										AmtValue[j] = AmtValue[j]
												+ (new Float(RecordVal[j])
														.floatValue());

										ExpenseType eType = (ExpenseType) hs
												.load(ExpenseType.class,
														new Integer(ExpType[j]));
										ed.setExpType(eType);
										ed.setExpMaster(findmaster);
										hs.update(ed);

									}
								}
								// Update Comments table
								String CmtRecId = request
										.getParameter("CmtRecId" + i);
								String CmtVal = request.getParameter("CmtVal"
										+ i);
								if (CmtRecId.trim().equals("")) {
									if (!CmtVal.trim().equals("")) {
										ExpenseComments ec = new ExpenseComments();
										ec.setComments(CmtVal);
										Date ExpenseDate = UtilDateTime
												.toDate2(DateId[i]
														+ " 00:00:00.000");
										ec.setExpenseDate(ExpenseDate);
										ec.setExpMaster(findmaster);
										hs.save(ec);
									}
								} else {
									ExpenseComments ec = (ExpenseComments) hs
											.load(ExpenseComments.class,
													new Long(CmtRecId));
									ec.setComments(CmtVal);
									hs.update(ec);
								}
							}
							// Update the Amount summary table
							ArrayList al = new ArrayList();
							if (findmaster.getProject().getExpenseTypes() != null) {
								Iterator itr = findmaster.getProject()
										.getExpenseTypes().iterator();
								while (itr.hasNext()) {
									ExpenseType expType = (ExpenseType) itr
											.next();
									al.add(expType.getExpId());
								}
							}
							if (findmaster.getAmounts().size() == 0) {
								List expList = this.getAllExpenseType();
								for (int j = 0; j < ColSize; j++) {
									ExpenseType eType = (ExpenseType) hs.load(
											ExpenseType.class, new Integer(
													ExpType[j]));
									if(expList.indexOf(eType)>-1)
										expList.remove(eType);
									ExpenseAmount ea = new ExpenseAmount();
										if (eType.getExpAccDesc().equalsIgnoreCase(
												"CN")
												&& ClaimType.equals("CY")) {
											ea.setUserAmount(new Float(0));
										} else {
											ea
													.setUserAmount(new Float(
															AmtValue[j]));
										}
										ea.setExpType(eType);
										ea.setExpMaster(findmaster);
										hs.save(ea);										
								}
							} else {
								Iterator amt = findmaster.getAmounts()
										.iterator();
								List expList = this.getAllExpenseType();
								Iterator expit = expList.iterator();
								ExpenseType tempType = null;
								if (expit.hasNext())
									tempType = (ExpenseType) expit.next();
								while (amt.hasNext()) {
									ExpenseAmount ea = (ExpenseAmount) amt
											.next();
									if (ClaimType.equals("CY")
											&& (ea.getExpMaster()
													.getClaimType()
													.equals("CN"))) {
										if (al.contains(ea.getExpType()
												.getExpId())) {
											int tempCol = -1;
											for (int x = 0; x < ExpType.length; x++) {
												if (Integer
														.parseInt(ExpType[x]) == ea
														.getExpType()
														.getExpId().intValue())
													tempCol = x;
											}
											if (tempCol != -1)
												ea.setUserAmount(new Float(
														AmtValue[tempCol]));
											else
												ea.setUserAmount(new Float(0));

											hs.update(ea);
										} else {
											if (ea.getExpType().getExpAccDesc()
													.equalsIgnoreCase("CN"))
												hs.delete(ea);
											else {
												ea.setUserAmount(new Float(0));
												hs.update(ea);
											}
										}
										Iterator ied = ea.getExpMaster()
												.getDetails().iterator();
										while (ied.hasNext()) {
											ExpenseDetail edt = (ExpenseDetail) ied
													.next();
											if (edt.getExpType()
													.getExpAccDesc()
													.equalsIgnoreCase("CN")
													|| !al.contains(edt
															.getExpType()
															.getExpId())) {
												hs.delete(edt);
											}
										}
									} else if (ClaimType.equals("CN")
											&& (ea.getExpMaster()
													.getClaimType()
													.equals("CY"))) {
										int index = expList.indexOf(ea.getExpType());
										if(index>-1)
											expList.remove(index);
									} else {
										if (AmtValue.length == 5) {
											if (ea.getExpType().getExpId()
													.intValue() == 1)
												ea.setUserAmount(new Float(
														AmtValue[0]));

											else if (ea.getExpType().getExpId()
													.intValue() == 2)
												ea.setUserAmount(new Float(
														AmtValue[1]));

											else if (ea.getExpType().getExpId()
													.intValue() == 3)
												ea.setUserAmount(new Float(
														AmtValue[2]));

											else if (ea.getExpType().getExpId()
													.intValue() == 4) {
												// hs.delete(ea);
												ea.setUserAmount(new Float(0));
											} else if (ea.getExpType()
													.getExpId().intValue() == 5) {
												ea.setUserAmount(new Float(
														AmtValue[3]));
											} else if (ea.getExpType()
													.getExpId().intValue() == 6) {
												ea.setUserAmount(new Float(
														AmtValue[4]));
											} else
												// hs.delete(ea);
												ea.setUserAmount(new Float(0));
										} else {
											int tempCol = -1;
											for (int x = 0; x < ExpType.length; x++) {
												if (Integer
														.parseInt(ExpType[x]) == ea
														.getExpType()
														.getExpId().intValue())
													tempCol = x;
											}
											if (tempCol != -1)
												ea.setUserAmount(new Float(
														AmtValue[tempCol]));
											else
												ea.setUserAmount(new Float(0));
										}
										hs.update(ea);
									}
								}
								if(ClaimType.equals("CN")
										&& (findmaster.getClaimType()
												.equals("CY")))
								{
									expit = expList.iterator();
									while(expit.hasNext())
									{
										tempType =  (ExpenseType) expit.next();
										ExpenseAmount expamount = new ExpenseAmount();
										expamount.setExpType(tempType);
										expamount
												.setUserAmount(new Float(
														0));
										expamount
												.setExpMaster(findmaster);
										hs.save(expamount);
									}
								}
								
							}
						}
						if (findmaster.getStatus().equals("Draft")
								|| findmaster.getStatus().equals("Rejected"))
							mailFlag = true;
						if (!findmaster.getStatus().equals("Verified")) {
							findmaster.setStatus(FormStatus);
						}
						findmaster.setClaimType(ClaimType);
						if (FormStatus.equals("Submitted"))
							mailFlag = true;
						CurrencyType ct = (CurrencyType) hs.load(
								CurrencyType.class, ExpenseCurrency);
						findmaster.setExpenseCurrency(ct);
						findmaster.setCurrencyRate(new Float(CurrencyRate));

						hs.update(findmaster);
						tx.commit();
						hs.flush();
					}
				} catch (Exception e) {
					e.printStackTrace();
					log.error(e.getMessage());
				}
			}

			if (action.equals("create")) {

				try {
					tx = hs.beginTransaction();
					ExpenseMaster findmaster = new ExpenseMaster();
					String projectCode = request.getParameter("projId");
					String DataPeriod = request.getParameter("DataPeriod");
					String UserId = request.getParameter("UserId");
					if (projectCode == null)
						projectCode = "";
					if (DataPeriod == null)
						DataPeriod = Date_formater.format(UtilDateTime
								.nowTimestamp());
					if (UserId == null)
						UserId = "";

					ProjectMaster projectMaster = (ProjectMaster) hs.load(
							ProjectMaster.class, projectCode);
					findmaster.setProject(projectMaster);

					UserLogin ul = (UserLogin) hs.load(UserLogin.class, UserId);
					findmaster.setExpenseUser(ul);

					findmaster.setClaimType(ClaimType);
					Date dayStart = UtilDateTime.toDate2(DataPeriod
							+ " 00:00:00.000");
					dayStart = UtilDateTime.getThisWeekDay(dayStart, 1);
					findmaster.setExpenseDate(dayStart);
					Date entryDate = UtilDateTime.toDate2((Date_formater
							.format(UtilDateTime.nowDate()) + " 00:00:00.000"));
					findmaster.setEntryDate(entryDate);

					ExpenseService Service = new ExpenseService();
					findmaster.setFormCode(Service.getFormNo(findmaster, hs));

					CurrencyType ct = (CurrencyType) hs.load(
							CurrencyType.class, ExpenseCurrency);
					findmaster.setExpenseCurrency(ct);
					findmaster.setCurrencyRate(new Float(CurrencyRate));

					if (FormStatus.equals("Submitted"))
						mailFlag = true;
					findmaster.setStatus(FormStatus);
					hs.save(findmaster);
					tx.commit();
					hs.flush();
					DataId = findmaster.getId().toString();
				} catch (Exception e) {
					e.printStackTrace();
					log.error(e.getMessage());
				}
			}
			if (action.equals("delete")) {
				try {
					tx = hs.beginTransaction();
					ExpenseMaster findmaster = (ExpenseMaster) hs.load(
							ExpenseMaster.class, new Long(DataId));
					// if (!findmaster.getStatus().equals("Approved")) {
					if (findmaster.getApprovalDate() == null) {
						Iterator itdet = findmaster.getDetails().iterator();
						while (itdet.hasNext()) {
							ExpenseDetail ed = (ExpenseDetail) itdet.next();
							hs.delete(ed);
						}
						itdet = findmaster.getAmounts().iterator();
						while (itdet.hasNext()) {
							ExpenseAmount ed = (ExpenseAmount) itdet.next();
							hs.delete(ed);
						}
						itdet = findmaster.getComments().iterator();
						while (itdet.hasNext()) {
							ExpenseComments ed = (ExpenseComments) itdet.next();
							hs.delete(ed);
						}
						hs.delete(findmaster);
					}
					tx.commit();
					hs.flush();
					return (mapping.findForward("list"));
				} catch (Exception e) {
					e.printStackTrace();
					log.error(e.getMessage());
				}
			}

			if (action.equals("view") || action.equals("create")
					|| action.equals("update")
					|| action.equals("showArAndApDetail")) {
				ExpenseMaster findmaster = null;

				if (!((DataId == null) || (DataId.length() < 1)))
					findmaster = (ExpenseMaster) hs.load(ExpenseMaster.class,
							new Long(DataId));

				List detailList = null;
				ArrayList DateList = new ArrayList();
				if (findmaster != null) {
					q = hs
							.createQuery("select ed from ExpenseDetail as ed inner join ed.ExpMaster as em inner join ed.ExpType as et where em.Id =:DataId order by ed.ExpenseDate, et.expSeq ASC");
					q.setParameter("DataId", DataId);
					detailList = q.list();
					Date dayStart = findmaster.getExpenseDate();

					for (int i = 0; i < 14; i++) {
						DateList.add(UtilDateTime.getDiffDay(dayStart, i));
					}
					request.setAttribute("FreezeFlag",
							FreezeDateCheck(findmaster.getApprovalDate()));
					request.setAttribute("findmaster", findmaster);
					request.setAttribute("detailList", detailList);
					request.setAttribute("DateList", DateList);

					q = hs
							.createQuery("select ec from ExpenseComments as ec inner join ec.ExpMaster as em where em.Id =:DataId order by ec.ExpenseDate");
					q.setParameter("DataId", DataId);
					detailList = q.list();
					request.setAttribute("CommentsList", detailList);

					q = hs
							.createQuery("select ea from ExpenseAmount as ea inner join ea.ExpMaster as em inner join ea.ExpType as et where em.Id =:DataId order by et.expSeq ASC");
					q.setParameter("DataId", DataId);
					detailList = q.list();
					request.setAttribute("AmountList", detailList);
				}

				if (action.equals("showArAndApDetail")) {
					return (mapping.findForward("showArAndApDetail"));
				}

				if (action.equals("update") && FormStatus.equals("Submitted")
						&& mailFlag) {
					EmailService.notifyUser(findmaster);
					mailFlag = false;
					return (mapping.findForward("list"));
				}

				return (mapping.findForward("view"));
			}

			if (!errors.empty()) {
				saveErrors(request, errors);
				return (new ActionForward(mapping.getInput()));
			}
			return (mapping.findForward("view"));
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return (mapping.findForward("view"));
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

	private List getAllExpenseType() {
		Session hs;
		List list = new ArrayList();
		try {
			hs = Hibernate2Session.currentSession();
			Query q = hs
					.createQuery("from ExpenseType as e order by e.expSeq asc");
			list = q.list();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;

	}
}

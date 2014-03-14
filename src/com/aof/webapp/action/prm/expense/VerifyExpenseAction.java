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
import com.aof.component.domain.party.*;
import com.aof.component.prm.expense.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;



/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class VerifyExpenseAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(VerifyExpenseAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			
			String FormStatus = request.getParameter("FormStatus");
			String action = request.getParameter("FormAction");
			
			if(FormStatus == null) FormStatus = "";
			if(action == null) action = "view";
	
			if (!isTokenValid(request)) {
				if(action.equals("update")){
					action ="view";
				}
			}
			saveToken(request);
			
			try{
				String DataId = request.getParameter("DataId");
					
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				Query q = null;
				
				if(action.equals("update")){
					
					if ((DataId == null) || (DataId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		
					
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					try{
						tx = hs.beginTransaction();
						ExpenseMaster findmaster = (ExpenseMaster)hs.load(ExpenseMaster.class, new Long(DataId));
						if (findmaster.getReceiptDate() == null) {
							String ExpType[] = request.getParameterValues("ExpType");
							if (ExpType != null) {
								int ColSize = java.lang.reflect.Array.getLength(ExpType);
								// Update the Amount summary table
								String AmtRecId[] = request.getParameterValues("AmtRecId");
								String AmtRecValue[] = request.getParameterValues("AmtRecValue");
								for (int j = 0; j < ColSize; j++) {
									if (AmtRecId[j].trim().equals("")) {
										ExpenseAmount ea = new ExpenseAmount();
										ea.setConfirmedAmount(new Float(AmtRecValue[j]));
										ExpenseType eType = (ExpenseType)hs.load(ExpenseType.class, new Integer(ExpType[j]));
										ea.setExpType(eType);
										ea.setExpMaster(findmaster);
										hs.save(ea);
									} else {
										ExpenseAmount ea = (ExpenseAmount)hs.load(ExpenseAmount.class,new Long(AmtRecId[j]));
										ea.setConfirmedAmount(new Float(AmtRecValue[j]));
										hs.update(ea);
									}
								}
							}
							boolean updFlag = false;
							if (FormStatus.equals("Posted To F&A")) {
								if (findmaster.getReceiptDate() == null && findmaster.getApprovalDate() != null) {
									updFlag = true;
								}
							}
							if (FormStatus.equals("Verified")) {
								if (findmaster.getApprovalDate() == null) {
									updFlag = true;
								}
							}
							if (updFlag) {
								findmaster.setStatus(FormStatus);
								Date verifyDate =UtilDateTime.toDate2((Date_formater.format(UtilDateTime.nowDate())+" 00:00:00.000"));
								findmaster.setVerifyDate(verifyDate);
								hs.update(findmaster);
							}
							tx.commit();
							hs.flush();
						}
					}catch(Exception e){
						e.printStackTrace();
						log.error(e.getMessage());
					}
				}
				if(action.equals("view") || action.equals("create") || action.equals("update")){
					ExpenseMaster findmaster = null;
	
					if (!((DataId == null) || (DataId.length() < 1)))
						findmaster = (ExpenseMaster)hs.load(ExpenseMaster.class,new Long(DataId));
		
					List detailList = null;
					ArrayList DateList = new ArrayList();
					if (findmaster != null) {
						q=hs.createQuery("select ed from ExpenseDetail as ed inner join ed.ExpMaster as em inner join ed.ExpType as et where em.Id =:DataId order by ed.ExpenseDate, et.expSeq ASC");
						q.setParameter("DataId", DataId);
						detailList = q.list();
						Date dayStart = findmaster.getExpenseDate();
						
						for (int i = 0; i < 14; i++) {
							DateList.add(UtilDateTime.getDiffDay(dayStart, i));
						}
						
						if (findmaster.getStatus().equals("Claimed")) {
							request.setAttribute("FreezeFlag", "Y");
						} else {
							request.setAttribute("FreezeFlag", "N");
						}
						
						request.setAttribute("findmaster",findmaster);
						request.setAttribute("detailList",detailList);
						request.setAttribute("DateList",DateList);
						
						q=hs.createQuery("select ec from ExpenseComments as ec inner join ec.ExpMaster as em where em.Id =:DataId order by ec.ExpenseDate");
						q.setParameter("DataId", DataId);
						detailList = q.list();
						request.setAttribute("CommentsList",detailList);
						
						q=hs.createQuery("select ea from ExpenseAmount as ea inner join ea.ExpMaster as em inner join ea.ExpType as et where em.Id =:DataId order by et.expSeq ASC");
						q.setParameter("DataId", DataId);
						detailList = q.list();
						request.setAttribute("AmountList",detailList);
					} 
					return (mapping.findForward("view"));
				}
							
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				return (mapping.findForward("view"));
			}catch(Exception e){
				e.printStackTrace();
				log.error(e.getMessage());
				return (mapping.findForward("view"));	
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
	}
}

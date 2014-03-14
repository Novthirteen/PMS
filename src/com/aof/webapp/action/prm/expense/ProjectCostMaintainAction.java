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
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;

import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.expense.ExpenseService;
import com.aof.component.prm.expense.ProjectAirFareCost;
import com.aof.component.prm.expense.ProjectCostDetail;
import com.aof.component.prm.expense.ProjectCostMaster;
import com.aof.component.prm.expense.ProjectCostType;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *  update time 2004-12-2
 */
public class ProjectCostMaintainAction extends BaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log =
			Logger.getLogger(ProjectCostMaintainAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		String action = request.getParameter("FormAction");
		HttpSession session = request.getSession();
		DynaValidatorForm projectCostMaintainForm = (DynaValidatorForm) form;
		ArrayList typeSelectArr = new ArrayList();
		ArrayList currencySelectArr = new ArrayList();
		ArrayList ClaimTypeSelectArr = new ArrayList();
		List result = new ArrayList();
		boolean currencySelect = false;
		
		String Type = request.getParameter("Type");
		String costType = request.getParameter("CostType");
		
		if (Type == null) Type = "";
		initSelect(result, typeSelectArr, currencySelectArr,ClaimTypeSelectArr,Type,costType);

		String DataId = request.getParameter("DataId");
		ProjectCostMaster pcm = null;
		//ProjectCostDetail pcd = null;
		Date CostDate = (Date)UtilDateTime.nowTimestamp();
		Date FormCostDate = UtilDateTime.toDate2((String) projectCostMaintainForm.get("costDate")+ " 00:00:00.000");
		
		String FC = "N";
		if (FormCostDate!=null) FC = FreezeDateCheck(FormCostDate);
		if (!FC.equals("Y")) CostDate = FormCostDate;
		if (action == null) action="";
		if (DataId == null) DataId="";
		
		if (!isTokenValid(request)) {
			if (action.equals("save") || action.equals("confirm") || action.equals("unconfirm")) {
				action = "";
			}
		}
		saveToken(request);
					
		if (action.equals("save") || action.equals("confirm") || action.equals("unconfirm")) {
			String projId = request.getParameter("projId");
			String staffId = request.getParameter("staffId");
			String projName = request.getParameter("projName");
			if (projName == null) projName="";
			try {
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				tx = hs.beginTransaction();
				UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
				if (DataId.trim().equals("")) {
					//new cost profile
					if (costType != null && costType.equals("EAF")) {
						pcm = new ProjectAirFareCost();
					} else {
						pcm = new ProjectCostMaster();
					}
					pcm.setCreatedate((Date)UtilDateTime.nowTimestamp());
					pcm.setCreateuser(ul.getUserLoginId());
					pcm.setModifydate((Date)UtilDateTime.nowTimestamp());
					pcm.setModifyuser(ul.getUserLoginId());
					
				} else {
					//load existed cost profile
					if (costType != null && costType.equals("EAF")) {
						pcm =(ProjectAirFareCost) hs.load(ProjectAirFareCost.class,new Integer(DataId));
					} else {
						pcm =(ProjectCostMaster) hs.load(ProjectCostMaster.class,new Integer(DataId));
					}
					
					pcm.setModifydate((Date)UtilDateTime.nowTimestamp());
					pcm.setModifyuser(ul.getUserLoginId());
				}
				if (!projName.equals("")) {
					pcm.setPayType(projName);
					projId="";
					pcm.setProjectMaster(null);
				}
				pcm.setRefno((String) projectCostMaintainForm.get("refNo"));
				pcm.setCostdescription((String) projectCostMaintainForm.get("costDescription"));
				pcm.setClaimType((String) projectCostMaintainForm.get("ClaimTypeSelect"));
				ProjectCostType projectCostType =(ProjectCostType) hs.load(ProjectCostType.class,
						(String) projectCostMaintainForm.get("typeSelect"));
				pcm.setProjectCostType(projectCostType);
				CurrencyType currencyType =(CurrencyType) hs.load(CurrencyType.class,
					(String) projectCostMaintainForm.get("currencySelect"));
				pcm.setCurrency(currencyType);
				pcm.setPayment(null);
				pcm.setTotalvalue((new Float(UtilString.removeSymbol((String) projectCostMaintainForm.get("totalValue"),','))).floatValue());
				pcm.setExchangerate((new Float((String) projectCostMaintainForm.get("exchangeRate"))).floatValue());
				pcm.setCostdate(FormCostDate);
				String payFor = (String)request.getParameter("payFor");
				if(payFor != null && !payFor.trim().equals("")){	
					pcm.setPayFor((String) request.getParameter("payFor"));
					pcm.setVendor((VendorProfile)hs.load(VendorProfile.class,pcm.getPayFor()));
				}
				if(!projId.equals("")){
					ProjectMaster projectMaster = 
								(ProjectMaster)hs.load(ProjectMaster.class,projId);
					pcm.setProjectMaster(projectMaster);
					pcm.setPayType(null);
				}
				
				UserLogin userLogin = (UserLogin)hs.load(UserLogin.class,staffId);
				pcm.setUserLogin(userLogin);
				if(pcm.getPayStatus()!=null){
					if ((!pcm.getPayStatus().equalsIgnoreCase("posted")) &&(!pcm.getPayStatus().equalsIgnoreCase("paid"))&&(!pcm.getPayStatus().equalsIgnoreCase("confirm"))){
						pcm.setPayStatus("unconfirmed");
					}
				}else{
					pcm.setPayStatus("unconfirmed");
				}
				
				if (action.equals("confirm")) {
					pcm.setApprovalDate((Date)UtilDateTime.nowTimestamp());
					if ((!pcm.getPayStatus().equalsIgnoreCase("posted"))&&(!pcm.getPayStatus().equalsIgnoreCase("paid")))
					pcm.setPayStatus("confirmed");
				}
				if (costType != null && costType.equals("EAF")) {
					convertFormToModlue((ProjectAirFareCost)pcm, projectCostMaintainForm);
					((ProjectAirFareCost)pcm).setDestination(request.getParameter("destination"));
				}
				
				if (DataId.trim().equals("")) {
					ExpenseService Service = new ExpenseService();
					pcm.setFormCode(Service.getFormNo(pcm,hs));
					hs.save(pcm);
					hs.flush();
					DataId = pcm.getCostcode().toString();
				} else {
					hs.update(pcm);	
				}
			
				
				/*
					int RowSize = java.lang.reflect.Array.getLength(staffId);
					for (int i = 0; i < RowSize; i++) {
						if (pcdId[i].trim().equals("")) { //create a new record
							pcd = new ProjectCostDetail();
							pcd.setProjectCostMaster(pcm);
							pcm.addDetails(pcd);
							ProjectMaster projectMaster = null;
							if (projId[i] != null && projId[i].trim().length() != 0) {
								projectMaster = (ProjectMaster)hs.load(ProjectMaster.class,projId[i]);
							}
							pcd.setProjectMaster(projectMaster);
							if (!staffId[i].equals("")) {
								UserLogin userLogin =(UserLogin) hs.load(UserLogin.class,staffId[i]);
								pcd.setUserLogin(userLogin);
							}								
							pcd.setPercentage((new Float(percentage[i])).floatValue());
							if (projName != null) {
								pcd.setProjName(projName[i]);
							}
							hs.save(pcd);
						} else { //update record
							pcd =(ProjectCostDetail) hs.load(ProjectCostDetail.class,new Integer(pcdId[i]));
							
							pcd.setProjectCostMaster(pcm);
							ProjectMaster projectMaster = null;
							if (projId[i] != null && projId[i].trim().length() != 0) {
								projectMaster = (ProjectMaster)hs.load(ProjectMaster.class,projId[i]);
							}
							pcd.setProjectMaster(projectMaster);
							if (!staffId[i].equals("")) {
								UserLogin userLogin =(UserLogin) hs.load(UserLogin.class,staffId[i]);
								pcd.setUserLogin(userLogin);
							}
							pcd.setPercentage((new Float(percentage[i])).floatValue());
							if (projName != null) {
								pcd.setProjName(projName[i]);
							}
							hs.update(pcd);						
						}						
					}
					*/
				
				if (action.equals("unconfirm")) {
					pcm.setApprovalDate(null);	
					pcm.setPayStatus("unconfirmed");
				}
				hs.update(pcm);
					
				hs.flush();
				
				tx.commit();
			} catch (Exception e) {
				e.printStackTrace();
			} 
			//delete
		} else if (action.equals("delete")) {
			if (!DataId.trim().equals("")) {
				try {
					net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
					Transaction tx = null;
					tx = hs.beginTransaction();
					ProjectCostMaster projectCostMaster = null;
					if (costType != null && costType.equals("EAF")) {
						projectCostMaster =(ProjectAirFareCost) hs.load(ProjectAirFareCost.class,new Integer(DataId));
					} else {
						projectCostMaster =(ProjectCostMaster) hs.load(ProjectCostMaster.class,new Integer(DataId));
					}
					
					if (projectCostMaster != null) {
						hs.delete(projectCostMaster);
					}
					hs.flush();
					tx.commit();
					return (mapping.findForward("list"));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			//currencySelect
		}
		
		if (!DataId.trim().equals("")) {
			try {
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				ProjectCostMaster projectCostMaster = null;
				if (costType != null && costType.equals("EAF")) {
					projectCostMaster =pcm =(ProjectAirFareCost) hs.load(ProjectAirFareCost.class,new Integer(DataId));
					convertModlueToForm(projectCostMaintainForm, (ProjectAirFareCost)projectCostMaster);
				} else {
					projectCostMaster =pcm =(ProjectCostMaster) hs.load(ProjectCostMaster.class,new Integer(DataId));
				}
				projectCostMaintainForm.set("refNo",projectCostMaster.getRefno());
				projectCostMaintainForm.set("costDescription",projectCostMaster.getCostdescription());
				projectCostMaintainForm.set("ClaimTypeSelect",projectCostMaster.getClaimType());
				projectCostMaintainForm.set("typeSelect",projectCostMaster.getProjectCostType().getTypeid().toString());
				
				projectCostMaintainForm.set("totalValue", UtilString.removeSymbol(new Float(projectCostMaster.getTotalvalue()).toString(),','));
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
				String costDate = format.format(projectCostMaster.getCostdate());
				projectCostMaintainForm.set("costDate", costDate);
				Integer costcode = projectCostMaster.getCostcode();
				
				if (action.equals("currencySelect")) {
					Iterator itCurr = currencySelectArr.iterator();
					String currId =(String) projectCostMaintainForm.get("currencySelect");
					//if (currId == null || currId.trim().equals("")) currId= "RMB";
					while (itCurr.hasNext()) {
						HashMap currencySelectmap = (HashMap)itCurr.next();
						if (currencySelectmap.get("key").toString().equals(currId)) {
							projectCostMaintainForm.set("exchangeRate",currencySelectmap.get("Rate").toString());
						}
					}
				} else {
					projectCostMaintainForm.set("currencySelect",projectCostMaster.getCurrency().getCurrId().toString());
					projectCostMaintainForm.set("exchangeRate",new Float(projectCostMaster.getExchangerate()).toString());
				}
				//projectCostMaintainForm.set("payFor", projectCostMaster.getPayFor());
				
				String DateStr = "";
				if (projectCostMaster.getCreatedate() !=  null) 
					DateStr = format.format(projectCostMaster.getCreatedate());
				request.setAttribute("createDate",DateStr);
				DateStr = "";
				if (projectCostMaster.getApprovalDate() !=  null) 
					DateStr = format.format(projectCostMaster.getApprovalDate());
				request.setAttribute("approvalDate",DateStr);
				
				/* Modification : deliver the flag whether pa has confirmed , by Bill Yu */
				if(projectCostMaster.getPAConfirm() != null){
					request.setAttribute("paConfirm", "yes");
				}else{
					request.setAttribute("paConfirm", "no");
				}
				/* Modification ends */
				
				/*
				Query q =hs.createQuery("select pcd from ProjectCostDetail as pcd inner join pcd.projectCostMaster as pcm where pcm.costcode = :costcode");
				q.setParameter("costcode", costcode);
				result = q.list();
				request.setAttribute("QryDetail", result);
				*/
				
				String freezeFlag = FreezeDateCheck(projectCostMaster.getApprovalDate());
				
				if (freezeFlag.equalsIgnoreCase("N")) {
					TransactionServices ts = new TransactionServices();
					if (ts.hasPosted("BillTransactionDetail", pcm.getCostcode().longValue(), Constants.TRANSACATION_CATEGORY_OTHER_COST)) {
						freezeFlag = "Y";
					}
				}
				
				request.setAttribute("FreezeFlag", freezeFlag);
				Hibernate2Session.closeSession();
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			Iterator itCurr = currencySelectArr.iterator();
			String currId =(String) projectCostMaintainForm.get("currencySelect");
			//if (currId == null || currId.trim().equals("")) currId= "RMB";
			while (itCurr.hasNext()) {
				HashMap currencySelectmap = (HashMap)itCurr.next();
				if (currencySelectmap.get("key").toString().equals(currId)) {
					projectCostMaintainForm.set("exchangeRate",currencySelectmap.get("Rate").toString());
				}
			}
			SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd");
			projectCostMaintainForm.set("costDate", format.format((Date)UtilDateTime.nowTimestamp()));
			projectCostMaintainForm.set("bookDate", format.format((Date)UtilDateTime.nowTimestamp()));
		//	projectCostMaintainForm.set("returnDate", format.format((Date)UtilDateTime.nowTimestamp()));
			
			request.setAttribute("createDate",format.format((Date)UtilDateTime.nowTimestamp()));
			request.setAttribute("approvalDate","");
			
			/* Modification : deliver the flag whether pa has confirmed , by Bill Yu */
			request.setAttribute("paConfirm", "");
			/* Modification ends */
			
			//request.setAttribute("QryDetail", null);
		}
		
		//save the Query result of typeSelect
		request.setAttribute("findmaster", pcm);
		request.setAttribute("typeSelectArr", typeSelectArr);
		//save the Query result of currencySelect
		request.setAttribute("currencySelectArr", currencySelectArr);
		request.setAttribute("ClaimTypeSelectArr", ClaimTypeSelectArr);

		if (action.equals("showArAndApDetail")) {
			return (mapping.findForward("showArAndApDetail"));
		}
		
		if (costType != null && costType.equals("EAF")) {
			return (mapping.findForward("airfare"));
		} else {
			return (mapping.findForward("success"));
		}
	}
	/**
	 * init the projectSelect
	 * @param result list
	 * @param projectSelectArr ArrayList
	 */
	private void initSelect(
		List result,
		ArrayList typeSelectArr,
		ArrayList currencySelectArr,
		ArrayList ClaimTypeSelectArr,
		String Type,
		String id) {
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			String sqlStr = " select pct from ProjectCostType as pct where pct.typeaccount=:typeaccount";
			if (Type.equals("Expense")) {
				if (id != null && id.equals("EAF")) {
					sqlStr += " and pct.typeid = 'EAF' ";
				} else {
					sqlStr += " and pct.typeid <> 'EAF' ";
				}
			}
			Query q = hs.createQuery(sqlStr);
			q.setParameter("typeaccount",Type);
			result = q.list();
			Iterator itMstr = result.iterator();
			while (itMstr.hasNext()) {

				ProjectCostType projectCostType =
					(ProjectCostType) itMstr.next();
				HashMap typeSelectmap = new HashMap();
				typeSelectmap.put("key", projectCostType.getTypeid());
				typeSelectmap.put("value",projectCostType.getTypename());
				typeSelectArr.add(typeSelectmap);
			}
			q = hs.createQuery("select currency from CurrencyType as currency");
			result = q.list();
			itMstr = result.iterator();
			while (itMstr.hasNext()) {

				CurrencyType expCurrency = (CurrencyType) itMstr.next();
				HashMap currencySelectmap = new HashMap();
				currencySelectmap.put("key", expCurrency.getCurrId());
				currencySelectmap.put("value",expCurrency.getCurrId() + ":" + expCurrency.getCurrName());
				currencySelectmap.put("Rate",expCurrency.getCurrRate());
				currencySelectArr.add(currencySelectmap);
			}
			
			// ClaimTypeSelectArr
			HashMap ClaimTypeSelectmap = new HashMap();
			ClaimTypeSelectmap.put("key", "CN");
			ClaimTypeSelectmap.put("value","Company");
			ClaimTypeSelectArr.add(ClaimTypeSelectmap);
			ClaimTypeSelectmap = new HashMap();
			ClaimTypeSelectmap.put("key", "CY");
			ClaimTypeSelectmap.put("value","Customer");
			ClaimTypeSelectArr.add(ClaimTypeSelectmap);

		} catch (Exception e) {
			e.printStackTrace();
			//return (mapping.findForward("success"));
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
	}
	
	private void convertFormToModlue(ProjectAirFareCost pafc, DynaValidatorForm form) {
		pafc.setTakeOffTime((String)form.get("takeOffTime"));
		if (form.get("sameFlightPrice") != null && ((String)form.get("sameFlightPrice")).trim().length() != 0) {
			pafc.setSameFlightPrice(new Float(UtilString.removeSymbol((String)form.get("sameFlightPrice"), ',')));
		}
		pafc.setTakeOffTimeIn4((String)form.get("takeOffTimeIn4"));
		pafc.setFlightNoIn4((String)form.get("flightNoIn4"));
		if (form.get("priceIn4") != null && ((String)form.get("priceIn4")).trim().length() != 0) {
			pafc.setPriceIn4(new Float(UtilString.removeSymbol((String)form.get("priceIn4"), ',')));
		}
		pafc.setTakeOffTimeInDay((String)form.get("takeOffTimeInDay"));
		pafc.setFlightNoInDay((String)form.get("flightNoInDay"));
		if (form.get("priceInDay") != null && ((String)form.get("priceInDay")).trim().length() != 0) {
			pafc.setPriceInDay(new Float(UtilString.removeSymbol((String)form.get("priceInDay"), ',')));
		}
		if (form.get("bookDate") != null && ((String)form.get("bookDate")).trim().length() != 0) {
			pafc.setBookDate(UtilDateTime.toDate2((String)form.get("bookDate") + " 00:00:00.000"));
		}
		try{
			TransactionServices tsn = new TransactionServices();
			net.sf.hibernate.Session hs =Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();
			ProjectCostMaster pcm = (ProjectCostMaster)hs.load(ProjectCostMaster.class, pafc.getCostcode());
		//	UserLogin ul = (UserLogin)hs.load(UserLogin.class, pafc.getCreateuser());
			if (form.get("returnDate") != null && ((String)form.get("returnDate")).trim().length() != 0) {
				pafc.setReturnDate(UtilDateTime.toDate2((String)form.get("returnDate") + " 00:00:00.000"));
				
				if(pafc.getClaimType().equalsIgnoreCase("CY")){
					if (pcm.getPAConfirm() == null) {
						pcm.setPAConfirm(UtilDateTime.nowTimestamp());
						hs.update(pcm);
					}
					tsn.insert(pcm, pcm.getUserLogin());
					tx.commit();
					hs.flush();
				}
				
			}else{
				pafc.setReturnDate(null);
				if (pcm.getPAConfirm() != null) {
					pcm.setPAConfirm(null);
					hs.update(pcm);
				}
				tsn.remove(pcm);
				tx.commit();
				hs.flush();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void convertModlueToForm(DynaValidatorForm form, ProjectAirFareCost pafc) {
		form.set("takeOffTime", pafc.getTakeOffTime());
		if (pafc.getSameFlightPrice() != null) {
			form.set("sameFlightPrice", pafc.getSameFlightPrice().toString());
		}
		form.set("takeOffTimeIn4", pafc.getTakeOffTimeIn4());
		form.set("flightNoIn4", pafc.getFlightNoIn4());
		if (pafc.getPriceIn4() != null) {
			form.set("priceIn4", pafc.getPriceIn4().toString());
		}
		form.set("takeOffTimeInDay", pafc.getTakeOffTimeInDay());
		form.set("flightNoInDay", pafc.getFlightNoInDay());
		if (pafc.getPriceInDay() != null) {
			form.set("priceInDay", pafc.getPriceInDay().toString());
		}
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		if (pafc.getBookDate() != null) {
			form.set("bookDate", dateFormat.format(pafc.getBookDate()));		
		}
		if (pafc.getReturnDate() != null) {
			form.set("returnDate", dateFormat.format(pafc.getReturnDate()));		
		}
	}
}

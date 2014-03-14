/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
*/
package com.aof.webapp.action.prm.projectmanager;

import java.sql.SQLException;
import java.util.Locale;  
import java.util.*; 
import java.text.SimpleDateFormat;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.component.prm.Bill.*;
import com.aof.component.prm.project.*;
import com.aof.component.domain.party.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLResults;

/**
* @author xxp 
* @version 2003-7-2
*
*/
public class EditProjAccpAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditProjAccpAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("FormAction");
		    SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			log.info("action="+action);
			try{
				String ProjectId = request.getParameter("DataId");
				log.info("***************************** data id ="+ProjectId);
				String ProjName = request.getParameter("projName");
				String EventCategoryId = request.getParameter("projectType");
				String ProjectTypeId = request.getParameter("projectCategory");
				String ContractNo = request.getParameter("contractNo");
				String CustomerId = request.getParameter("customerId");
				String DepartmentId = request.getParameter("departmentId");
				String ProjectManagerId = request.getParameter("projectManagerId");
				String PublicFlag=request.getParameter("PublicFlag");
				String totalServiceValueStr=request.getParameter("totalServiceValue");
				String totalLicsValueStr=request.getParameter("totalLicsValue");
				String EXPBudgetStr=request.getParameter("EXPBudget");
				String PSCBudgetStr=request.getParameter("PSCBudget");
				String ProcBudgetStr=request.getParameter("procBudget");
				String ContractType=request.getParameter("ContractType");
				
				String ProjectStatus=request.getParameter("projectStatus");
				String startDate=request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				
				Float totalServiceValue=null;
				Float PSCBudget=null;
				Float ProcBudget=null;
				
				Float EXPBudget=null;
				Float totalLicsValue=null;
				
				if (!(totalLicsValueStr == null || totalLicsValueStr.length()<1)) totalLicsValue= new Float(totalLicsValueStr);
				if (!(EXPBudgetStr == null || EXPBudgetStr.length()<1)) EXPBudget= new Float(EXPBudgetStr);
				
				if (!(totalServiceValueStr == null || totalServiceValueStr.length()<1)) totalServiceValue= new Float(totalServiceValueStr);
				if (!(PSCBudgetStr == null || PSCBudgetStr.length()<1)) PSCBudget= new Float(PSCBudgetStr);					
				if (!(ProcBudgetStr == null || ProcBudgetStr.length()<1)) ProcBudget= new Float(ProcBudgetStr);					
				
				if (ProjectId == null) ProjectId ="";
				if (ProjName == null) ProjName ="";
				if (ContractNo == null) ContractNo ="";
				if (ProjectManagerId == null) ProjectManagerId ="";
				
				String CAFFlag=request.getParameter("CAFFlag");
				String ParentProjectId=request.getParameter("ParentProjectId");
				if (CAFFlag == null) CAFFlag ="N";
				if (ParentProjectId == null) ParentProjectId ="";
				
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				if(action == null) action = "view";
				ProjectMaster CustProject = null;
				
		
				
				if(action.equals("update")){ 
					if ((ProjectId == null) || (ProjectId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}

					String StId[] = request.getParameterValues("StId");
					String STDescription[] = request.getParameterValues("STDescription");
					String STRate[] = request.getParameterValues("STRate");
				
					String EstimateManDays[] = request.getParameterValues("EstimateManDays");
					String EstimateDate[] = request.getParameterValues("EstimateDate");
					String CustAccpDate[] = request.getParameterValues("CustAccpDate");
					String SuppAccpDate[] = request.getParameterValues("SuppAccpDate");
					String CustAccp[] = request.getParameterValues("CustAccp");
					String SuppAccp[] = request.getParameterValues("SuppAccp");
					
				
					
					int RowSize = java.lang.reflect.Array.getLength(StId);
				
					ServiceType st = null;
					tx = hs.beginTransaction();
					for (int i = 0; i < RowSize; i++) {
						if (StId[i].trim().equals("")) {
							if (!STDescription[i].trim().equals("")) {
								st = new ServiceType();
								if (CustAccpDate[i]!= null){
									st.setCustAcceptanceDate(UtilDateTime.toDate2(CustAccpDate[i] + " 00:00:00.000"));
								}
								if (SuppAccpDate[i]!= null){
									st.setVendAcceptanceDate(UtilDateTime.toDate2(SuppAccpDate[i] + " 00:00:00.000"));
								}
								hs.save(st);
							}
						} else {
							st = (ServiceType)hs.load(ServiceType.class,new Long(StId[i]));
							
							if (STDescription[i].trim().equals("")) {
								hs.delete(st);
							} else {
								if (CustAccpDate!= null){
									st.setCustAcceptanceDate(UtilDateTime.toDate2(CustAccpDate[i] + " 00:00:00.000"));
								}
								if (SuppAccpDate!= null){
									st.setVendAcceptanceDate(UtilDateTime.toDate2(SuppAccpDate[i] + " 00:00:00.000"));
								}
								hs.update(st);
							
							}
						}
						//if ((st.getCustAcceptanceDate() != null) || (st.getVendAcceptanceDate() != null))
						// {
											
							TransactionServices trs = new TransactionServices();
							UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
							trs.insert(st, ul);
						//}
					}
					
					
					tx.commit();
				}// finish update action
				
						
				if(action.equals("view") || action.equals("update")){
					log.info("project id is "+ProjectId);
					if (!((ProjectId == null) || (ProjectId.length() < 1)))
						CustProject = (ProjectMaster)hs.load(ProjectMaster.class,ProjectId);
					
					List ServiceTypeList = null;
					if (CustProject != null) {
						Query q=hs.createQuery("select st from ServiceType as st inner join st.Project as p where p.projId =:ProjectId");
						q.setParameter("ProjectId", CustProject.getProjId());
						ServiceTypeList = q.list();
					}
					
					request.setAttribute("CustProject",CustProject);
					request.setAttribute("ServiceTypeList",ServiceTypeList);
				//---------
					Iterator itst = ServiceTypeList.iterator();
						if (itst.hasNext()){
						ServiceType st = (ServiceType)itst.next();
					//	log.info("***bill id is = ="+st.getProjBill().getId());
					//	log.info("***pay id is= ="+st.getProjPayment().getId());
						}
				//------------
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

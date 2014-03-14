/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.project;

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

import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.component.prm.project.*;
import com.aof.component.domain.party.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;

/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class EditInternalProjectAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditInternalProjectAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();		
		String action = request.getParameter("FormAction");
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
		log.info("action="+action);
		try{
			String ProjectId = request.getParameter("DataId");
			String ProjName = request.getParameter("projName");
			String EventCategoryId = request.getParameter("projectType");
			//String ProjectTypeId = request.getParameter("I");
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
			String[] exTypeChk = request.getParameterValues("exTypeChk"); 
			String expenseNote = request.getParameter("expenseNote");
			
			String repeatFlag = "";
			
			totalServiceValueStr = UtilString.removeSymbol(totalServiceValueStr,',');
			totalLicsValueStr = UtilString.removeSymbol(totalLicsValueStr,',');
			EXPBudgetStr = UtilString.removeSymbol(EXPBudgetStr,',');
			PSCBudgetStr = UtilString.removeSymbol(PSCBudgetStr,',');
			ProcBudgetStr = UtilString.removeSymbol(ProcBudgetStr,',');
						
			Double totalServiceValue=null;
			Double PSCBudget=null;
			Double ProcBudget=null;
				
			Double EXPBudget=null;
			Double totalLicsValue=null;
				
			if (!(totalLicsValueStr == null || totalLicsValueStr.length()<1)) totalLicsValue= new Double(totalLicsValueStr);
			if (!(EXPBudgetStr == null || EXPBudgetStr.length()<1)) EXPBudget= new Double(EXPBudgetStr);
				
			if (!(totalServiceValueStr == null || totalServiceValueStr.length()<1)) totalServiceValue= new Double(totalServiceValueStr);
			if (!(PSCBudgetStr == null || PSCBudgetStr.length()<1)) PSCBudget= new Double(PSCBudgetStr);					
			if (!(ProcBudgetStr == null || ProcBudgetStr.length()<1)) ProcBudget= new Double(ProcBudgetStr);					
				
			if (ProjectId == null) ProjectId ="";
			if (ProjName == null) ProjName ="";
			if (ContractNo == null) ContractNo ="";
			if (ProjectManagerId == null) ProjectManagerId ="";
			
				
			String CAFFlag=request.getParameter("CAFFlag");
			String ParentProjectId=request.getParameter("ParentProjectId");
			if (CAFFlag == null) CAFFlag ="N";
			if (ParentProjectId == null) ParentProjectId ="";
			String catgy=request.getParameter("catgy");
			if (catgy == null) catgy ="N";
			
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			if(action == null) action = "view";
			ProjectMaster CustProject = null;
			if(expenseNote == null) expenseNote = "";
			String yn = "N";
			java.util.HashSet al = new HashSet();
			int length = (exTypeChk == null) ? 0 : exTypeChk.length;
			for(int j0=0; j0<length; j0++){
				ExpenseType et = (ExpenseType)hs.load(ExpenseType.class, new Integer(exTypeChk[j0]));
				if(et.getExpDesc().equals("Transport(Travel)")){
					yn="yes";
				}
				al.add(et);
			}
			String ProjectTypeId = "I";
			if(action.equals("create")){
					
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				try{
					tx = hs.beginTransaction();
						
					CustProject = new ProjectMaster();
						
					if (CustomerId != null) {
						com.aof.component.crm.customer.CustomerProfile Customer=(com.aof.component.crm.customer.CustomerProfile)hs.load(com.aof.component.crm.customer.CustomerProfile.class,CustomerId);
						CustProject.setCustomer(Customer);
						CustProject.setBillTo(Customer);
					}
					if (DepartmentId != null) {
						Party Department=(Party)hs.load(Party.class,DepartmentId);
						CustProject.setDepartment(Department);
					}
					if (EventCategoryId != null) {
						ProjectType ProjType = (ProjectType)hs.load(ProjectType.class,EventCategoryId);
						CustProject.setProjectType(ProjType);
					}
					if (ProjectTypeId != null) {
						ProjectCategory ProjCategory = (ProjectCategory)hs.load(ProjectCategory.class,ProjectTypeId);
						CustProject.setProjectCategory(ProjCategory);
					}
					if (!ProjectManagerId.equals("")) {
						UserLogin ProjectManager=(UserLogin)hs.load(UserLogin.class,ProjectManagerId);
						CustProject.setProjectManager(ProjectManager);
					}
						
					CustProject.setProjName(ProjName);
					CustProject.setContractNo(ContractNo);
					CustProject.setPublicFlag(PublicFlag);
					CustProject.setProjStatus(ProjectStatus);
					CustProject.settotalServiceValue(totalServiceValue);
					CustProject.setPSCBudget(PSCBudget);
					CustProject.setProcBudget(ProcBudget);
					CustProject.settotalLicsValue(totalLicsValue);
					CustProject.setEXPBudget(EXPBudget);
					CustProject.setContractType(ContractType);	
					CustProject.setStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
					CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
						
					if (ProjectId.trim().equals("")) {
						ProjectService Service = new ProjectService();
						CustProject.setProjId(Service.getProjectNo(CustProject,hs));
					} else {
						CustProject.setProjId(ProjectId);
					}
						
					CustProject.setCAFFlag(CAFFlag);
					CustProject.setCategory(catgy);
					
					if(ProjectId != null && !ProjectId.equals("")){
						String  QryStr = " select pm from ProjectMaster as pm ";
						QryStr = QryStr + "where pm.projId = '" +  ProjectId + "'";
						Query query = hs.createQuery(QryStr);
						List result = query.list();
						if (result != null && result.size() > 0) {
							repeatFlag = "yes";
							request.setAttribute("repeatName",repeatFlag);
							request.setAttribute("CustProject",CustProject);
							CustProject.setProjId(ProjectId);
							return (mapping.findForward("view"));
						}

						CustProject.setProjId(ProjectId);
					}
					CustProject.setExpenseTypes(al);
					if (yn.equals("yes")){
						CustProject.setCYTransport("Y");
					}else{
						CustProject.setCYTransport("N");
					}
					CustProject.setExpenseNote(expenseNote);
					ProjectService ps = new ProjectService();
					ps.UpdateProjectLink(hs,CustProject,ParentProjectId);
						
					hs.save(CustProject);
					
					//insert default CTC forecast
					ProjectCostToComplete ctc = null;
					
					Date date = UtilDateTime.toDate2(startDate + " 00:00:00.000");
					FMonthHelper fMonthHelper = new FMonthHelper();
					FMonth fMonth = fMonthHelper.findFiscalMonthByActurlDate(hs, date);
					
					//insert default PSC forecast
					ctc = new ProjectCostToComplete();
					ctc.setFiscalMonth(fMonth);
					ctc.setAmount(PSCBudget.doubleValue());
					ctc.setProject(CustProject);
					ctc.setType("PSC");
					ctc.setVersionFiscalMonth(fMonth);
					hs.save(ctc);
					
					//insert default EXP forecast
					ctc = new ProjectCostToComplete();
					ctc.setFiscalMonth(fMonth);
					ctc.setAmount(EXPBudget.doubleValue());
					ctc.setProject(CustProject);
					ctc.setType("Expense");
					ctc.setVersionFiscalMonth(fMonth);
					hs.save(ctc);
					
					//insert default Proc forecast
					ctc = new ProjectCostToComplete();
					ctc.setFiscalMonth(fMonth);
					ctc.setAmount(ProcBudget.doubleValue());
					ctc.setProject(CustProject);
					ctc.setType("ExtCost");
					ctc.setVersionFiscalMonth(fMonth);
					hs.save(ctc);
					
					tx.commit();
						
					//Add a Default Serice Type for this project
					ServiceType st = new ServiceType();
					st.setProject(CustProject);
					st.setDescription("Other");
					st.setRate(new Double(0));
					st.setEstimateManDays(new Float(0));
					st.setSubContractRate(new Double(0));
					hs.save(st);
					log.info("go to >>>>>>>>>>>>>>>>. view forward");
				}catch(Exception e){
					e.printStackTrace();
				}
			}
				
			if(action.equals("update")){ 
				if ((ProjectId == null) || (ProjectId.length() < 1))
					actionDebug.addGlobalError(errors,"error.context.required");		
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}

				tx = hs.beginTransaction();
				CustProject = (ProjectMaster)hs.load(ProjectMaster.class,ProjectId);
				
				double orgPSCBudget = CustProject.getPSCBudget().doubleValue();
				double orgEXPBudget = CustProject.getEXPBudget().doubleValue();
				double orgProcBudget = CustProject.getProcBudget().doubleValue();
				
				if (CustomerId != null) {
					com.aof.component.crm.customer.CustomerProfile Customer=(com.aof.component.crm.customer.CustomerProfile)hs.load(com.aof.component.crm.customer.CustomerProfile.class,CustomerId);
					CustProject.setCustomer(Customer);
					CustProject.setBillTo(Customer);
				}
				if (DepartmentId != null) {
					Party Department=(Party)hs.load(Party.class,DepartmentId);
					CustProject.setDepartment(Department);
				}
				if (EventCategoryId != null) {
					ProjectType ProjType = (ProjectType)hs.load(ProjectType.class,EventCategoryId);
					CustProject.setProjectType(ProjType);
				}
				if (!ProjectManagerId.equals("")) {
					UserLogin ProjectManager=(UserLogin)hs.load(UserLogin.class,ProjectManagerId);
					CustProject.setProjectManager(ProjectManager);
				}
					
				CustProject.setProjName(ProjName);
				CustProject.setContractNo(ContractNo);
				CustProject.setPublicFlag(PublicFlag);
				CustProject.setProjStatus(ProjectStatus);
				CustProject.settotalServiceValue(totalServiceValue);
				CustProject.setPSCBudget(PSCBudget);
				CustProject.settotalLicsValue(totalLicsValue);
				CustProject.setEXPBudget(EXPBudget);
				CustProject.setProcBudget(ProcBudget);
				CustProject.setContractType(ContractType);	
				CustProject.setStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
				CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));

				CustProject.setCAFFlag(CAFFlag);
				ProjectService ps = new ProjectService();
				ps.UpdateProjectLink(hs,CustProject,ParentProjectId);
				CustProject.setCategory(catgy);	
				CustProject.setExpenseTypes(al);
				if (yn.equals("yes")){
					CustProject.setCYTransport("Y");
				}else{
					CustProject.setCYTransport("N");
				}
				CustProject.setExpenseNote(expenseNote);
				hs.update(CustProject);
				
				//insert default CTC forecast below
				Long CurrVerFMId = getCurrVerionFMId(hs,ProjectId);
				List CustProjectCTCs = null;
				
				if (CustProject != null) {
					java.util.Date SDate=CustProject.getStartDate();
					java.util.Date EDate=CustProject.getEndDate();
					if (CurrVerFMId != null) {
						Query q=hs.createQuery("select ctc from ProjectCostToComplete as ctc inner join ctc.FiscalMonth as fm where ctc.Project.projId =:ProjectId and ctc.VersionFiscalMonth.Id =:CurrVerFMId order by ctc.Type DESC, fm.Year, fm.MonthSeq");
						q.setParameter("ProjectId", ProjectId);
						q.setParameter("CurrVerFMId", CurrVerFMId);
						CustProjectCTCs = q.list();
						
						if (CustProjectCTCs != null) {
							Iterator iterator = CustProjectCTCs.iterator();
							while (iterator.hasNext()) {
								ProjectCostToComplete projCTC = (ProjectCostToComplete)iterator.next();
								if ("PSC".equals(projCTC.getType())) {
									if (orgPSCBudget != PSCBudget.doubleValue() && orgPSCBudget == projCTC.getAmount()) {
										projCTC.setAmount(PSCBudget.doubleValue());
										hs.save(projCTC);
									}
								} else if ("Expense".equals(projCTC.getType())) {
									if (orgEXPBudget != EXPBudget.doubleValue() && orgEXPBudget == projCTC.getAmount()) {
										projCTC.setAmount(EXPBudget.doubleValue());
										hs.save(projCTC);
									}
								} else if ("ExtCost".equals(projCTC.getType())) {
									if (orgProcBudget != ProcBudget.doubleValue() && orgProcBudget == projCTC.getAmount()) {
										projCTC.setAmount(ProcBudget.doubleValue());
										hs.save(projCTC);
									}
								}
							}
						}
					}
				}
				//insert default CTC forecast Up
				
				tx.commit();
			}
				
			if(action.equals("delete")){
				if ((ProjectId == null) || (ProjectId.length() < 1))
					actionDebug.addGlobalError(errors,"error.context.required");
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				tx = hs.beginTransaction();
				
				Query query = hs.createQuery("from ProjectCostToComplete as pctc where pctc.Project.projId = ?");
				query.setString(0, ProjectId);
				List ctcList = query.list();
				if (ctcList != null) {
					for (int i0 = 0; i0 < ctcList.size(); i0++) {
						hs.delete(ctcList.get(i0));
					}
				}

				CustProject = (ProjectMaster)hs.load(ProjectMaster.class,ProjectId);
				Iterator itSt = CustProject.getServiceTypes().iterator();
				while (itSt.hasNext()) {
					ServiceType st= (ServiceType)itSt.next();
					hs.delete(st);
				}
				hs.delete(CustProject);
				
				hs.flush();
				tx.commit();
				return (mapping.findForward("list"));
																	
			}
				
			if(action.equals("view") || action.equals("create") || action.equals("update")){
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
	
	private Long getCurrVerionFMId (Session session,String ProjectId) throws HibernateException{
		Long VerionFMId = null;
		String QryStr = "select max(ctc.VersionFiscalMonth.Id) from ProjectCostToComplete as ctc inner join ctc.Project as p where p.projId =:ProjectId";
		Query q = session.createQuery(QryStr);
		q.setParameter("ProjectId", ProjectId);
		Iterator itFind = q.list().iterator();
		if (itFind.hasNext()) {
			VerionFMId = (Long)itFind.next();
		}		
		return VerionFMId;
	}
}

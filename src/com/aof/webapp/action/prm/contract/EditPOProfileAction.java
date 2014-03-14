/*
 * Created on 2005-6-21
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.webapp.action.prm.contract;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Transaction;
import net.sf.hibernate.Query;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.contract.ContractProfile;
import com.aof.component.prm.contract.ContractService;
import com.aof.component.prm.contract.POProfile;
import com.aof.component.prm.project.CurrencyType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01512
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class EditPOProfileAction extends BaseAction{
  		protected ActionErrors errors = new ActionErrors();
  		protected ActionErrorLog actionDebug = new ActionErrorLog();
		
		public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
				// Extract attributes we will need
				ActionErrors errors = this.getActionErrors(request.getSession());
				Logger log = Logger.getLogger(EditPOProfileAction.class.getName());
				Locale locale = getLocale(request);
				MessageResources messages = getResources();		
			    UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			
				String action = request.getParameter("FormAction");
				SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
				log.info("action="+action);
				try{
					String ProjectId = request.getParameter("contractId");
					String ContractNo = request.getParameter("contractNo");
					String ContractDes = request.getParameter("contractDes");
					String vendorId = request.getParameter("vendorId");
					//String ProjectManagerId = request.getParameter("projectManagerId");
					String accountManagerId = request.getParameter("accountManagerId");
					String totalServiceValueStr=request.getParameter("totalServiceValue");
					String AlownceStr=request.getParameter("alownceAmt");
					String ContractType=request.getParameter("ContractType");	
					String startDate=request.getParameter("startDate");
					String endDate = request.getParameter("endDate");
					String currencyId = request.getParameter("currency");
					String exchangeRateStr = request.getParameter("exchangeRate");
					String linkContractId = request.getParameter("linkContractId");
					String signedOrNot = request.getParameter("signedOrNot");
					String signedDate = request.getParameter("signedDate");
					String DepartmentId = request.getParameter("departmentId");
					String legalReviewDate = request.getParameter("legalReviewDate");
					String hasProjectFlag = "true";
					String deleteOrNot = "yes";
					
					String status = request.getParameter("textStatus");
					
					totalServiceValueStr = UtilString.removeSymbol(totalServiceValueStr,',');
					AlownceStr = UtilString.removeSymbol(AlownceStr,',');
					exchangeRateStr = UtilString.removeSymbol(exchangeRateStr,',');
					
					Double totalServiceValue=null;
					//Float PSCBudget=null;
					//Float ProcBudget=null;
					Float AlownceRate=null;
					Float exchangeRate=null;
					//Float EXPBudget=null;
					//Float totalLicsValue=null;
				
					if (!(totalServiceValueStr == null || totalServiceValueStr.length()<1)) {
						totalServiceValue= new Double(totalServiceValueStr);
					}else{
						totalServiceValue= new Double(0);
					}
					
					if (!(AlownceStr == null || AlownceStr.length()<1)) {
						AlownceRate= new Float(AlownceStr);
					}else{
						AlownceRate= new Float(0);
					}
					
					if (!(exchangeRateStr == null || exchangeRateStr.length()<1)){
						exchangeRate= new Float(exchangeRateStr); 
					}else{
						exchangeRate= new Float(0);
					}
					
					if (ProjectId == null) ProjectId ="";
					if (ContractNo == null) ContractNo ="";
					//if (ProjectManagerId == null) ProjectManagerId ="";
					if(accountManagerId ==null)accountManagerId="";
					if(linkContractId ==null)linkContractId="";
					
					//String CAFFlag=request.getParameter("CAFFlag");
					//if (CAFFlag == null) CAFFlag ="N";
					
					net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
					Transaction tx = null;
					if(action == null) action = "view";
					POProfile CustProject = null;
					
					String repeatFlag = "";
					
					if(action.equals("create")){
					
						if (!errors.empty()) {
							saveErrors(request, errors);
							return (new ActionForward(mapping.getInput()));
						}
						try{
							tx = hs.beginTransaction();
						
							CustProject = new POProfile();
						
							if (vendorId != null && vendorId.trim().length() != 0) {
								com.aof.component.crm.vendor.VendorProfile Vendor=(com.aof.component.crm.vendor.VendorProfile)hs.load(com.aof.component.crm.vendor.VendorProfile.class,vendorId);
								CustProject.setVendor(Vendor);
							}
							
							if (DepartmentId != null && DepartmentId.trim().length() != 0) {
								Party Department=(Party)hs.load(Party.class,DepartmentId);
								CustProject.setDepartment(Department);
							}
							
							//if (!ProjectManagerId.equals("")) {
								//UserLogin ProjectManager=(UserLogin)hs.load(UserLogin.class,ProjectManagerId);
								//CustProject.setProjectManager(ProjectManager);
							//}
							if (!accountManagerId.equals("")) {
								UserLogin AccountManager=(UserLogin)hs.load(UserLogin.class,accountManagerId);
								CustProject.setAccountManager(AccountManager);
							}
							
							if (!linkContractId.equals("")) {
								ContractProfile contractProfile=(ContractProfile)hs.load(ContractProfile.class, new Long(linkContractId));
								CustProject.setLinkProfile(contractProfile);
							}
														
							if (ContractNo.trim().equals("")) {
									ContractService Service = new ContractService();
									CustProject.setNo(Service.getPOProfileNo(CustProject,hs));
							} 
							
							if (currencyId != null && currencyId.trim().length() != 0) {
								CurrencyType currency=(CurrencyType)hs.load(CurrencyType.class, currencyId);
								CustProject.setCurrency(currency);
							}
					
							CustProject.setContractType(ContractType);
							CustProject.setDescription(ContractDes);
							CustProject.setTotalContractValue(totalServiceValue);	
							
							CustProject.setCustPaidAllowance(AlownceRate);
							CustProject.setStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
							CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
							
							if (legalReviewDate != null && legalReviewDate.trim().length() != 0) {
								CustProject.setLegalReviewDate(UtilDateTime.toDate2(legalReviewDate + " 00:00:00.000"));
							}
		
							CustProject.setCreateUser(ul);
							/*if(createDate!=null && createDate.length()!=0 ){
								CustProject.setCreateDate(UtilDateTime.toDate2(createDate + " 00:00:00.000"));
							}*/
							CustProject.setCreateDate(new Date());
							if (signedOrNot != null) {
								if(signedDate!=null && signedDate.length()!=0){
									CustProject.setSignedDate(UtilDateTime.toDate2(signedDate + " 00:00:00.000"));
								}
							}
							//CustProject.setNeedCAF(CAFFlag);
							CustProject.setExchangeRate(exchangeRate);
							
							if (CustProject.getSignedDate() != null) {
								CustProject.setStatus("Signed");
							} else {
								CustProject.setStatus("Unsigned");
							}
							
							if(ContractNo != null && !ContractNo.equals("")){
								String  QryStr = " select cp from POProfile as cp ";
								QryStr = QryStr + "where cp.no = '" +  ContractNo + "'";
								Query query = hs.createQuery(QryStr);
								List result = query.list();
								if (result != null && result.size() > 0) {
									repeatFlag = "yes";
									request.setAttribute("repeatName",repeatFlag);
									request.setAttribute("CustProject",CustProject);
									CustProject.setNo(ContractNo);
									return (mapping.findForward("view"));
								}
								CustProject.setNo(ContractNo);
							}
							
							hs.save(CustProject);
							tx.commit();
						
							
							log.info("go to >>>>>>>>>>>>>>>>. view forward");
						}catch(Exception e){
							e.printStackTrace();
						}
					}
				  
					if(action.equals("update")){ 
						if ((ProjectId == null) || ProjectId.equals("null") ||(ProjectId.length() < 1))
							actionDebug.addGlobalError(errors,"error.context.required");		
						if (!errors.empty()) {
							saveErrors(request, errors);
							return (new ActionForward(mapping.getInput()));
						}
						
						tx = hs.beginTransaction();
						CustProject = (POProfile)hs.load(POProfile.class, new Long(ProjectId));
						
						String cpNo = CustProject.getNo();
						
						if(CustProject.getProjects().size()==0){
							   hasProjectFlag = "false";
						}
						request.setAttribute("hasProjectFlag",hasProjectFlag);
						
						if (vendorId != null && vendorId.trim().length() != 0) {
							com.aof.component.crm.vendor.VendorProfile Vendor=(com.aof.component.crm.vendor.VendorProfile)hs.load(com.aof.component.crm.vendor.VendorProfile.class,vendorId);
							CustProject.setVendor(Vendor);
						}
						if (DepartmentId != null && DepartmentId.trim().length() != 0) {
							Party Department=(Party)hs.load(Party.class,DepartmentId);
							CustProject.setDepartment(Department);
						}
						
						//if (!ProjectManagerId.equals("")) {
							//UserLogin ProjectManager=(UserLogin)hs.load(UserLogin.class,ProjectManagerId);
							//CustProject.setProjectManager(ProjectManager);
						//}					
						
						if (!accountManagerId.equals("")) {
							UserLogin AccountManager=(UserLogin)hs.load(UserLogin.class,accountManagerId);
							CustProject.setAccountManager(AccountManager);
						}
						
						if (!linkContractId.equals("")) {
							ContractProfile contractProfile=(ContractProfile)hs.load(ContractProfile.class,new Long(linkContractId));
							CustProject.setLinkProfile(contractProfile);
						}
						if (currencyId != null && currencyId.trim().length() != 0) {
							CurrencyType currency=(CurrencyType)hs.load(CurrencyType.class, currencyId);
							CustProject.setCurrency(currency);
						}
						CustProject.setExchangeRate(exchangeRate);
						if(ContractNo == null)ContractNo="";
						if (ContractNo.trim().equals("")) {
								ContractService Service = new ContractService();
								CustProject.setNo(Service.getPOProfileNo(CustProject,hs));
						} 
			
						//CustProject.setCreateUser(ul);
						CustProject.setDescription(ContractDes);
						CustProject.setContractType(ContractType);	
						CustProject.setCustPaidAllowance(AlownceRate);
						CustProject.setStartDate(UtilDateTime.toDate2(startDate + " 00:00:00.000"));
						CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
						if (legalReviewDate != null && legalReviewDate.trim().length() != 0) {
							CustProject.setLegalReviewDate(UtilDateTime.toDate2(legalReviewDate + " 00:00:00.000"));
						}
						CustProject.setTotalContractValue(totalServiceValue);	
							/*if(createDate!=null && createDate.length()!=0 ){
								CustProject.setEndDate(UtilDateTime.toDate2(createDate + " 00:00:00.000"));
							}*/
						//CustProject.setCreateDate(new Date());
						
						if(status != null && !status.equals("")){
							CustProject.setStatus(status);
							if(status.equals("Signed")){
								CustProject.setSignedDate(UtilDateTime.toDate2(signedDate + " 00:00:00.000"));
							}else if(status.equals("Unsigned")){
								CustProject.setSignedDate(null);
							}
						}
						
						if(ContractNo != null && !ContractNo.equals(cpNo)){
							String  QryStr = " select po from POProfile as po ";
							QryStr = QryStr + "where po.no = '" +  ContractNo + "'";
							Query query = hs.createQuery(QryStr);
							List result = query.list();
							if (result != null && result.size() > 0) {
								repeatFlag = "yes";
								request.setAttribute("repeatName",repeatFlag);
								request.setAttribute("CustProject",CustProject);
								CustProject.setNo(ContractNo);
								return (mapping.findForward("view"));
							}
	
							CustProject.setNo(ContractNo);
						}
						
						hs.update(CustProject);
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
						
						CustProject = (POProfile)hs.load(POProfile.class,new Long(ProjectId));
						if(CustProject.getProjects().size()==0){
						     hs.delete(CustProject);
						     hs.flush();
							}else{
						     deleteOrNot="no";
							}
						tx.commit();
						request.setAttribute("deleteOrNot",deleteOrNot);
						return (mapping.findForward("list"));
																	
					}
					
					if (action.equals("cancel")) {
						tx = hs.beginTransaction();
						CustProject = (POProfile)hs.load(POProfile.class,new Long(ProjectId));
						CustProject.setStatus("Cancel");
						hs.update(CustProject);
						hs.flush();
						tx.commit();
					}
				
					if(action.equals("view") 
							|| action.equals("create") 
							|| action.equals("update") 
							|| action.equals("cancel")
							|| action.equals("dialogView")){
						if (!((ProjectId == null) || ProjectId.equals("null") || (ProjectId.length() < 1)))
							CustProject = (POProfile)hs.load(POProfile.class,new Long(ProjectId));
					
						request.setAttribute("CustProject",CustProject);
						
						if (CustProject != null && CustProject.getProjects() != null && CustProject.getProjects().size() > 0) {
							request.setAttribute("hasProjectFlag", "true");
						} else {
							request.setAttribute("hasProjectFlag", "false");
						}
						
						if (action.equals("dialogView")) {
							Set projectSet = CustProject.getLinkProfile().getProjects();
							projectSet.size();
							return (mapping.findForward("dialogView"));
						} else {
							return (mapping.findForward("view"));
						}
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

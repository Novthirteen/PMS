/*
 * Created on 2005-6-21
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.webapp.action.prm.project;

import java.sql.SQLException; 
import java.util.*; 
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;
import com.aof.component.prm.project.*;
import com.aof.component.domain.party.*;
import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.contract.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLResults;

/**
 * @author CN01536
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class EditCustComplainsAction extends ReportBaseAction{
  		protected ActionErrors errors = new ActionErrors();
  		protected ActionErrorLog actionDebug = new ActionErrorLog();
		
		public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
				// Extract attributes we will need
				ActionErrors errors = this.getActionErrors(request.getSession());
				Logger log = Logger.getLogger(EditCustComplainsAction.class.getName());
				//Locale locale = getLocale(request);
				//MessageResources messages = getResources();		
			    UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			
				String action = request.getParameter("FormAction");
				if(action ==null)action="";
				if (action.equals("")){
					action = "view";
				}
				//SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
				log.info("action="+action);
				try{
					String DataId = request.getParameter("DataId");
					String ProjectId=request.getParameter("ProjCode");
					String departmentId = request.getParameter("departmentId");
					String pmId = request.getParameter("pmId");
 					String CreateUser = ul.getUserLoginId();
 					Calendar c = Calendar.getInstance();
 					Date createDate=c.getTime();
					String Description = request.getParameter("Desc");
					String type = request.getParameter("type");
					String solved=request.getParameter("solved");
					
					if (ProjectId == null) ProjectId ="";
					if(pmId ==null)pmId="";
					if(CreateUser ==null)CreateUser="";
					if(Description ==null)Description="";
					if(type ==null)type="";
					if(departmentId ==null)departmentId="";
					if(solved ==null)solved="";
					if(DataId ==null)DataId="";
					
					net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
					Transaction tx = null;
					log.info("action="+action);
					log.info("DataId="+DataId);
					if(action.equals("create")){
						if (!errors.empty()) {
							saveErrors(request, errors);
							return (new ActionForward(mapping.getInput()));
						}
						try{
							tx = hs.beginTransaction();
						
							CustComplain cc = new CustComplain();
							  if (!ProjectId.equals(""))
							  {
								  ProjectMaster proj=(ProjectMaster)hs.load(ProjectMaster.class,ProjectId);
								  cc.setProject(proj);
								  
							  }
							cc.setDep_ID(departmentId);
							if (!pmId.equals("")) {
								UserLogin pm=(UserLogin)hs.load(UserLogin.class,pmId);
								cc.setPM_ID(pm);
							}
							cc.setCreate_User(ul);
							cc.setCreate_Date(createDate);
							cc.setDescription(Description);
							cc.setType(type);
							cc.setSolved(solved);
						   hs.save(cc);
							tx.commit();
							
						   DataId=cc.getCC_Id().toString();
						   action="view";
							
							log.info("go to >>>>>>>>>>>>>>>>. view forward");
						}catch(Exception e){
							e.printStackTrace();
						}
						//return (mapping.findForward("view"));
					}
				  
					if(action.equals("update")){ 
						if (!errors.empty()) {
							saveErrors(request, errors);
							return (new ActionForward(mapping.getInput()));
						}
						try{
						if (DataId!=null){
						tx = hs.beginTransaction();
						CustComplain cc = (CustComplain)hs.load(CustComplain.class, new Long(DataId));
						cc.setType(type);
						cc.setDescription(Description);
						cc.setSolved(solved);
						hs.update(cc);						
					    tx.commit();
					    request.setAttribute("CustComplain",cc);
					    ProjectMaster  proj=cc.getProject();
						request.setAttribute("CurrentProj",proj);
						}
						else{
						   log.info("update  error >>>>>>>>>>>>>>>>. list forward");
						}
						log.info("update  done >>>>>>>>>>>>>>>>. list forward");
						}catch(Exception e){
							e.printStackTrace();
						}
					    return (mapping.findForward("view"));
					}
					
					if(action.equals("view")){ 
						if (!errors.empty()) {
							saveErrors(request, errors);
							return (new ActionForward(mapping.getInput()));
						}
						try{
							if(DataId.equals(""))
							{
								log.info("ready for create new >>>>>>>>>>>>>>>>. view forward");
							
							}else{
						CustComplain cc = (CustComplain)hs.load(CustComplain.class, new Long(DataId));
					    request.setAttribute("CustComplain",cc);
					    ProjectMaster  proj=cc.getProject();
						request.setAttribute("CurrentProj",proj);
						request.setAttribute("DataId",DataId);
						log.info("view  done >>>>>>>>>>>>>>>>. view forward");
							}
						}catch(Exception e){
							e.printStackTrace();
						}
					    return (mapping.findForward("view"));
					}
					
					if(action.equals("reportToexcel")){
						if ((ProjectId == null)|| ProjectId.equals("null") || (ProjectId.length() < 1))
							actionDebug.addGlobalError(errors,"error.context.required");		
						if (!errors.empty()) {
							saveErrors(request, errors);
							return (new ActionForward(mapping.getInput()));
						}
						
						//CustProject = (ContractProfile)hs.load(ContractProfile.class, new Long(ProjectId));
						
						return ExportToExcel(mapping,request, response);
					}
					
					
					
					if (action.equals("cancel")) {
						/*tx = hs.beginTransaction();
						CustProject = (ContractProfile)hs.load(ContractProfile.class,new Long(DataId));
						CustProject.setStatus(Constants.CONTRACT_PROFILE_STATUS_CANCEL);
						hs.update(CustProject);
						hs.flush();
						tx.commit();
						*/
						return (mapping.findForward("list"));
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
		
		private ActionForward ExportToExcel (ActionMapping mapping, HttpServletRequest request, HttpServletResponse response){
			try {
				ActionErrors errors = this.getActionErrors(request.getSession());
				if (!errors.empty()) {
					saveErrors(request, errors);
					return null;
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			return null;
		}
		
		private final static String ExcelTemplate="Contract Profile.xls";
		private final static String FormSheetName="Form";
		private final static String SaveToFileName="Contract Profile.xls";	
}

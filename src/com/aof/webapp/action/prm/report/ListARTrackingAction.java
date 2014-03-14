/*
 * Atos Origin China * All Right Reserved
 */

package com.aof.webapp.action.prm.report;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.Set;

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
import com.aof.component.prm.bid.BidActDetail;
import com.aof.component.prm.bid.BidActivity;
import com.aof.component.prm.project.ProjectARTracking;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;


/*
 *	@author: Stanley 
 */

public class ListARTrackingAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response) {

		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(ListARTrackingAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();	
		String action = request.getParameter("FormAction");
	    SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	    String nowTimestampString = UtilDateTime.nowTimestamp().toString();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		
		if(action == null) action = "view";
		ProjectMaster project = null;
		try{
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			
			String projId = request.getParameter("projId");
			
			if(action.equals("addDetail")){
				String aId = request.getParameter("aAssignee");
				String aDate = request.getParameter("aDate");
				String aDesc = request.getParameter("aDesc");
				ProjectARTracking part = null;
				if(projId != null && !projId.trim().equals("")){
					project = (ProjectMaster)hs.load(ProjectMaster.class, projId);
				}
				tx = hs.beginTransaction();

				if (!(aId.trim().equals(""))){
					com.aof.component.domain.party.UserLogin assignee =(com.aof.component.domain.party.UserLogin)hs.load(com.aof.component.domain.party.UserLogin.class,aId);
					part = new ProjectARTracking();
					part.setProject(project);
					part.setCreateUser(assignee);
					part.setDescription(aDesc);
					part.setCreateDate(UtilDateTime.toDate2(aDate + " 00:00:00.000"));
					hs.save(part);								
					project.addARTracking(part);
				}
				tx.commit();
				hs.flush();	
			}
			
			if(action.equals("deleteDetail")){ 
				String partIdStr = request.getParameter("partId");//detail
				if (((partIdStr == null) || (partIdStr.length() < 1)))
					actionDebug.addGlobalError(errors,"error.context.required");
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				tx = hs.beginTransaction();
				ProjectARTracking detail = (ProjectARTracking)hs.load(ProjectARTracking.class,new Long(partIdStr));
				project = detail.getProject();
				project.removeARTracking(detail);
				hs.delete(detail);
				hs.flush();
				tx.commit();
			}
			
			if(action.equals("update")){ 
				if (((projId == null) || (projId.length() < 1)))
					actionDebug.addGlobalError(errors,"error.context.required");
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				project = (ProjectMaster)hs.load(ProjectMaster.class,projId);
				
				String cc = request.getParameter("cc");
				String assigneeId[] = request.getParameterValues("Assignee");
				String createDate[] = new String[project.getArTrackingList().size()];

				for (int cs = 0; cs< (Integer.parseInt(cc)); cs++){
					createDate[cs] = request.getParameter("createDate"+cs);
				}
				String actionDesc[] = request.getParameterValues("actionDesc");
				String detailId[] = request.getParameterValues("detailId");
				
				int RowSize = java.lang.reflect.Array.getLength(assigneeId);
				ProjectARTracking part = null;	
				
				tx = hs.beginTransaction();
				for (int i = 0; i < RowSize; i++) {	
					Long dId = null;
					if (!(detailId[i] == null || detailId[i].length()<1)) dId= new Long(detailId[i]);
					if (!(assigneeId[i].trim().equals(""))){
						com.aof.component.domain.party.UserLogin assignee =(com.aof.component.domain.party.UserLogin)hs.load(com.aof.component.domain.party.UserLogin.class,assigneeId[i]);
						part = (ProjectARTracking)hs.load(ProjectARTracking.class,dId);
						part.setProject(project);
						part.setCreateUser(assignee);
						part.setDescription(actionDesc[i]);
						part.setCreateDate(UtilDateTime.toDate2(createDate[i] + " 00:00:00.000"));
						hs.update(part);
					}else{
						part = (ProjectARTracking)hs.load(ProjectARTracking.class,dId);
						part.setProject(project);
						part.setDescription(actionDesc[i]);
						part.setCreateDate(UtilDateTime.toDate2(createDate[i] + " 00:00:00.000"));
						hs.update(part);
					}
				}
				
				tx.commit();
				hs.flush();
			}
			if("view".equals(action) || "addDetail".equals(action) || "deleteDetail".equals(action) || "update".equals(action)){
				if ((projId != null) && (projId.length() > 0)){
					project = (ProjectMaster)hs.load(ProjectMaster.class,projId);
				}
				List arTrackingList = null;
				if(project != null){
					//arTrackingList = project.getArTrackingList();
					String statement = "from ProjectARTracking as part where part.project='"+project.getProjId()+"' order by part.id DESC";
					Query q = hs.createQuery(statement);
					arTrackingList = q.list();
				}
				request.setAttribute("ARTrackingList",arTrackingList);
			}
			return (mapping.findForward("success"));
		}catch(Exception e){
			e.printStackTrace();
			log.error(e.getMessage());
			return (mapping.findForward("success"));	
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

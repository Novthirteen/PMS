/*
 * Created on 2005-11-8
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.helpdesk;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.ConsultantGroup;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01558
 *	
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class GroupMaintainAction extends BaseAction {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String formAction = request.getParameter("formAction");
		
		if(formAction==null)	formAction = "view";
		
		//view groups
		if(formAction.equals("view")){
			request.setAttribute("groupList", findAllGroup());
			return mapping.findForward("list");
			
		//just access to the create page
		}else if(formAction.equals("create")){
			return mapping.findForward("create");
			
		//save the record to database
		}else if(formAction.equals("realCreate")){
			createNewGroup(mapping, request);
			request.setAttribute("groupList", findAllGroup());
			return mapping.findForward("list");
			
		//go to update page
		}else if(formAction.equals("update")){
			return mapping.findForward("create");
			
        //update the record
		}else if(formAction.equals("realUpdate")){
			updateGroup(mapping, request);
			return mapping.findForward("create");
			
		//to delete a group
		}else if(formAction.equals("delete")){
			deleteGroup(mapping, request);
			request.setAttribute("groupList", findAllGroup());
			return mapping.findForward("list");
			
		}else{
			return mapping.findForward("view");
		}
	}
	
	public List findAllGroup() throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		return hs.find("from ConsultantGroup"); 
	}
	
	//create or update the group
	public void createNewGroup(ActionMapping mapping, HttpServletRequest request)
	throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		
		String desc = request.getParameter("desc");
		String supervisorString = request.getParameter("supervisor");
		
		UserLogin supervisor = (UserLogin)hs.load(UserLogin.class, supervisorString);
		
		ConsultantGroup cg = new ConsultantGroup();
		cg.setDescription(desc);
		cg.setSupvisor(supervisor);
		
		hs.save(cg);
		hs.flush();
	}
	
	public void updateGroup(ActionMapping mapping, HttpServletRequest request)
	throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		
		int gid = Integer.parseInt(request.getParameter("gid"));
		
		String desc = request.getParameter("desc");
		String supervisorString = request.getParameter("supervisor");
		
		UserLogin supervisor = (UserLogin)hs.load(UserLogin.class, supervisorString);
		
		ConsultantGroup cg = (ConsultantGroup)hs.load(ConsultantGroup.class, new Integer(gid));
		
		cg.setDescription(desc);
		cg.setSupvisor(supervisor);
		
		hs.update(cg);
		hs.flush();
	}
	
	public void deleteGroup(ActionMapping mapping, HttpServletRequest request)
	throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		
		int id = Integer.parseInt(request.getParameter("gid"));
		ConsultantGroup cg = (ConsultantGroup)hs.load(ConsultantGroup.class, new Integer(id));
		
		List list = hs.find("from ConsultantAssign ca where ca.groupID="+id);
		if(list.isEmpty()){		
			hs.delete(cg);
			hs.flush();
		}else{
			request.setAttribute("warning", "Group "+id+" cannot be deleted!");
		}
	}
}

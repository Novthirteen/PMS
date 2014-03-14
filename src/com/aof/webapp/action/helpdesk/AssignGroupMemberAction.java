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

import net.sf.hibernate.Query;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.ConsultantAssign;
import com.aof.component.helpdesk.ConsultantGroup;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AssignGroupMemberAction extends BaseAction {
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String formAction = request.getParameter("formAction");
		
		if(formAction==null)	formAction = "view";
		
		//view groups
		if(formAction.equals("view")){
			request.setAttribute("groupList", findAllGroup());
			return mapping.findForward("list");
		
		//go to assign page of a single group
		}else if(formAction.equals("assignPage")){
			request.setAttribute("memberList", getGroupMembers(mapping, request));
			return mapping.findForward("assignment");
		
		//assign a new member to a group
		}else if(formAction.equals("assign")){
			assignMemberToGroup(mapping, request);
			request.setAttribute("memberList", getGroupMembers(mapping, request));
			return mapping.findForward("assignment");
			
		}else if(formAction.equals("remove")){
			removeMember(mapping, request);
			request.setAttribute("memberList", getGroupMembers(mapping, request));
			return mapping.findForward("assignment");
			
		}else{
			return mapping.findForward("list");
		}
	}
	
	public List findAllGroup() throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		return hs.find("from ConsultantGroup"); 
	}
	
	public List getGroupMembers(ActionMapping mapping, HttpServletRequest request)
	throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		
		int gid = Integer.parseInt(request.getParameter("gid"));
		return hs.find("from ConsultantAssign ca where ca.groupID="+gid);
	}
	
	public void assignMemberToGroup(ActionMapping mapping, HttpServletRequest request)
	throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		
		int gid = Integer.parseInt(request.getParameter("gid"));
		String uid = request.getParameter("uid");
		
		UserLogin member = (UserLogin)hs.load(UserLogin.class, uid);
		ConsultantGroup cg = (ConsultantGroup)hs.load(ConsultantGroup.class, new Integer(gid));
		
		Query query = hs.createQuery("from ConsultantAssign ca where ca.groupID=:gid and ca.consultant=:clt");
		query.setParameter("gid", cg);
		query.setParameter("clt", member);
		List list = query.list();
		
		if(list.isEmpty()){		
			ConsultantAssign ca = new ConsultantAssign();
			ca.setGroupID(cg);
			ca.setConsultant(member);
			hs.save(ca);
			hs.flush();
		}else{
			request.setAttribute("warning", "Error: Duplicate members!");
		}
	}
	
	public void removeMember(ActionMapping mapping, HttpServletRequest request)
	throws Exception{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		
		int id = Integer.parseInt(request.getParameter("uid"));	
		
		ConsultantAssign ca = (ConsultantAssign)hs.load(ConsultantAssign.class, new Integer(id));
		
		hs.delete(ca);
		hs.flush();
	}
}
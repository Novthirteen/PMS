/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.party;


import java.lang.reflect.Array;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Criteria;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.module.ModuleGroup;
import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.domain.security.SecurityGroup;
import com.aof.component.prm.master.ProjectCalendarType;
import com.aof.component.prm.project.SalaryLevel;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class EditUserLoginAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditUserLoginAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String otheraction = request.getParameter("add");

			if(otheraction==null)
				otheraction = "";
			String action = request.getParameter("action");
			
			log.info("action="+action);
			try{
				String userLoginId = request.getParameter("userLoginId");
				String name = request.getParameter("name");
				String enable = request.getParameter("enable");
				String role = request.getParameter("role"); 
				String partyId = request.getParameter("partyId");
				String password = request.getParameter("password");
				String email_addr = request.getParameter("email_addr");
				String note = request.getParameter("note");
				String typeId = request.getParameter("TypeId");
				String intern = request.getParameter("intern");
				//String fte = request.getParameter("fte");
				String type = request.getParameter("type");
				String reportToId = request.getParameter("reportToId");
				String LevelId = request.getParameter("LevelId");
				String joinDay = request.getParameter("joinDay");
				String leaveDay = request.getParameter("leaveDay");
				String acctType = request.getParameter("acctType");
				//System.out.println("reportToId is "+reportToId+"\n");
				
				if (enable == null) enable = "";
				if (role == null) role = "";
				if (partyId == null) partyId = "";
				if (password == null) password = "";
				if (email_addr == null) email_addr = "";
				if (note == null) note = "";
				if (intern == null) intern = "N";
				if (type == null) type = "N";
				if (reportToId == null) reportToId = "null";
				if (LevelId == null) LevelId = "";
				if(joinDay==null)	joinDay = "";
				if(leaveDay==null)	leaveDay = "";
				if(acctType==null)	acctType = "";
					
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				Criteria crit = hs.createCriteria(ProjectCalendarType.class);
				List result = crit.list();
				
				request.setAttribute("TypeList",result);
				if(action == null)
					action = "view";
					
				if (!isTokenValid(request)) {
					saveToken(request);
					if (action.equals("create")) {
						action = "view";
					}
				} else {
					saveToken(request);
				}
				if(action.equals("view")){
					log.info(action);
					
					UserLogin ul = null;
					if (!((userLoginId == null) || (userLoginId.length() < 1)))
						ul = (UserLogin)hs.load(UserLogin.class,userLoginId);
										
					request.setAttribute("userLogin",ul);
					return (mapping.findForward("view"));
				}
				if(action.equals("create")){
					
					if ((userLoginId == null) || (userLoginId.length() < 1)) {
						userLoginId = generateUserLoginId(hs, note);
						request.setAttribute("userLoginId", userLoginId);
					}
							
					if ((partyId == null) || (partyId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");
					
					if ((typeId == null) || (typeId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");
					
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					try{
						tx = hs.beginTransaction();
						Party party = (Party)hs.load(Party.class,partyId);
						ProjectCalendarType PCT = (ProjectCalendarType)hs.load(ProjectCalendarType.class, typeId);
						UserLogin ul = new UserLogin();
						ul.setUserLoginId(userLoginId);
						ul.setName(name);
						ul.setRole(role);
						ul.setEnable(enable);
						ul.setParty(party); 
						ul.setProjectCalendarType(PCT);
						ul.setCurrent_password(password);
						ul.setEmail_addr(email_addr);
						ul.setLocale("en");
						ul.setNote(note);
						ul.setIntern(intern);
						if(type.equalsIgnoreCase("slmanager"))
						{
							Query q = hs.createQuery("from UserLogin as ul where ul.type='slmanager' and ul.party.partyId='"+partyId+"'");
							List list = q.list();
							if((list!=null)&&(list.size()>0))
							{
								UserLogin mgr = (UserLogin)list.get(0);
								request.setAttribute("errormsg","You can not set this staff as SLManager!" +
										",because "+mgr.getName()+" is "+mgr.getParty().getDescription()+" SLManager");
								type = "other";
							}							
						}
						ul.setType(type);
						ul.setJoinDay(UtilDateTime.toDate2(joinDay + " 00:00:00.000"));
						ul.setLeaveDay(UtilDateTime.toDate2(leaveDay + " 00:00:00.000"));
						Calendar c = Calendar.getInstance();
	 					Date createDate=c.getTime();
	 					ul.setLast_update_Date(createDate);
	 					ul.setAccountType(acctType);
						SalaryLevel s;
						if (!LevelId.equals("")){
						s=new SalaryLevel(new Long(LevelId));
						ul.setSalaryLevel(s);
						}
						else {
							ul.setSalaryLevel(null);
						}						
					
						//ul.setIntern(intern);
						if (!reportToId.equals("")) {
							UserLogin reportToPerson=(UserLogin)hs.load(UserLogin.class,reportToId);
							ul.setReporToPerson(reportToPerson);
						}
						hs.save(ul);
						tx.commit(); 
						request.setAttribute("userLogin",ul);
						log.info("go to >>>>>>>>>>>>>>>>. view forward");
					}catch(Exception e){
						e.printStackTrace();
					}
					
					return (mapping.findForward("view"));
				}
				
				
				if(action.equals("update")){ 
					if ((userLoginId == null) || (userLoginId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		

					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}

					tx = hs.beginTransaction();
					UserLogin ul = (UserLogin)hs.load(UserLogin.class,userLoginId);
					Party party = (Party)hs.load(Party.class,partyId);
					ProjectCalendarType PCT = (ProjectCalendarType)hs.load(ProjectCalendarType.class, typeId);
					ul.setName(name);
					ul.setRole(role);
					ul.setEnable(enable);
					ul.setParty(party); 
					ul.setProjectCalendarType(PCT);
					ul.setCurrent_password(password);
					ul.setEmail_addr(email_addr);
					ul.setIntern(intern);
					if(type.equalsIgnoreCase("slmanager"))
					{
						Query q = hs.createQuery("from UserLogin as ul where ul.type='slmanager' and ul.party.partyId='"+partyId+"'");
						List list = q.list();
						if((list!=null)&&(list.size()>0))
						{
							UserLogin mgr = (UserLogin)list.get(0);
							request.setAttribute("errormsg","You can not set this staff as SLManager!" +
									",because "+mgr.getName()+" is "+mgr.getParty().getDescription()+" SLManager");
						}
						else{
						ul.setType(type);
						}						
					}else
						ul.setType(type);
					ul.setAccountType(acctType);
					ul.setNote(note);
					ul.setJoinDay(UtilDateTime.toDate2(joinDay + " 00:00:00.000"));
					ul.setLeaveDay(UtilDateTime.toDate2(leaveDay + " 00:00:00.000"));
					if (!reportToId.equals("")) {
						UserLogin reportToPerson=(UserLogin)hs.load(UserLogin.class,reportToId);
						ul.setReporToPerson(reportToPerson);
					}
					SalaryLevel s;
					if (!LevelId.equals("")){
					s=new SalaryLevel(new Long(LevelId));
					ul.setSalaryLevel(s);
					}
					else {
						ul.setSalaryLevel(null);
					}						
					
					hs.update(ul);
					tx.commit();	

					request.setAttribute("userLogin",ul);
					return (mapping.findForward("view"));
				}
				
				if(action.equals("delete")){
					if ((userLoginId == null) || (userLoginId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					tx = hs.beginTransaction();
					UserLogin ul = (UserLogin)hs.load(UserLogin.class,userLoginId);
					log.info("userloginId="+ul.getUserLoginId());
					hs.delete(ul);
					tx.commit();
					return (mapping.findForward("list"));
				}
				
				if(otheraction.equalsIgnoreCase("updatesecurity"))
				{
					tx = hs.beginTransaction();
					userLoginId = request.getParameter("userLoginId");
					UserLogin ul = (UserLogin)hs.load(UserLogin.class,userLoginId);
					String[] param = request.getParameterValues("GrantSecurity");
					if(param!=null)
					{
						Set set = ul.getSecurityGroups();
						if(set==null) set = new HashSet();
						Iterator it = set.iterator();
						while(it.hasNext())
						{
							boolean has = false;
							SecurityGroup sg = (SecurityGroup)it.next();
							for(int i=0;i<Array.getLength(param);i++)
							{
								String id = param[i];
								if(sg.getGroupId().equalsIgnoreCase(id)){
									has = true;
									break;
								}
							}
							if(!has){
								it.remove();
								set.remove(sg);
							}
						}
							hs.update(ul);
						
						for(int i=0;i<Array.getLength(param);i++)
						{
							String id = param[i];
							SecurityGroup sg = (SecurityGroup)hs.load(SecurityGroup.class,id);
							if(!set.contains(sg))
							{
								set.add(sg);
							}
						}
							ul.setSecurityGroups(set);
							hs.update(ul);
					}
					hs.flush();
					tx.commit();
				}
				if(otheraction.equalsIgnoreCase("updatemodule"))
				{
					tx = hs.beginTransaction();
					userLoginId = request.getParameter("userLoginId");
					UserLogin ul = (UserLogin)hs.load(UserLogin.class,userLoginId);
					String[] param = request.getParameterValues("GrantModule");
					if(param!=null)
					{
						Set set = ul.getModuleGroups();
						if(set==null) set = new HashSet();
						Iterator it = set.iterator();
						while(it.hasNext())
						{
							boolean has = false;
							ModuleGroup sg = (ModuleGroup)it.next();
							for(int i=0;i<Array.getLength(param);i++)
							{
								String id = param[i];
								if(sg.getModuleGroupId().equalsIgnoreCase(id)){
									has = true;
									break;
								}
							}
							if(!has){
								it.remove();
								set.remove(sg);
							}
						}
						hs.update(ul);
						
						for(int i=0;i<Array.getLength(param);i++)
						{
							String id = param[i];
							ModuleGroup sg = (ModuleGroup)hs.load(ModuleGroup.class,id);
							if(!set.contains(sg))
							{
								set.add(sg);
							}
						}
						ul.setModuleGroups(set);
						hs.update(ul);
					}
					hs.flush();
					tx.commit();
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
	
	
	private String generateUserLoginId(net.sf.hibernate.Session session, String perfix) throws HibernateException {
		try {
			String userLoginId = null;
			String statement = "from UserLogin as ul where ul.userLoginId like ?";
			Query query = session.createQuery(statement);
			query.setString(0, perfix + "%");
			List list = query.list();
			int sequence = 1;
			
			for (int i0 = 0; list != null && i0 < list.size(); i0++) {
				UserLogin ul = (UserLogin)list.get(i0);
				try {
					int surfix = Integer.parseInt(ul.getUserLoginId().substring(perfix.length() + 1));
					if (sequence <= surfix) {
						sequence = surfix + 1;
					}
				} catch(NumberFormatException e) {
					e.printStackTrace();
				}
			}
			
			return perfix + leftPad(String.valueOf(sequence), 5, "0");
		} catch (HibernateException e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	private String leftPad(String target, int length, String padString) {
		for (int i0 = target.length(); i0 < length; i0++) {
			target = padString + target;
		}
		
		return target;
	}
}

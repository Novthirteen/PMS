/*
 * Created on 2005-6-28
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

package com.aof.webapp.action.prm.project;


import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *
 */
public class ListPOProjectAction extends BaseAction{
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
				// Extract attributes we will need
				Logger log = Logger.getLogger(ListPOProjectAction.class.getName());
				Locale locale = getLocale(request);
				MessageResources messages = getResources();		

				try{
					List result = new ArrayList();
					net.sf.hibernate.Session session = Hibernate2Session.currentSession();
					PartyHelper ph = new PartyHelper();
					UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
					//List partyList_dep=ph.getAllSubPartysByPartyId(session,ul.getParty().getPartyId());
					//Iterator itdep = partyList_dep.iterator();
					//String PartyListStr = "'"+ul.getParty().getPartyId()+"'";
					//while (itdep.hasNext()) {
						//Party p =(Party)itdep.next();
						//PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
					//}
					String formAction = request.getParameter("formAction");
					String textcode = request.getParameter("textcode");
					String textdesc = request.getParameter("textdesc");
					String texttype = request.getParameter("texttype");
					String textstatus = request.getParameter("textstatus");
					String textvend = request.getParameter("textvend");
					String textcno = request.getParameter("textcno");
					String textdep = request.getParameter("textdep");
					if (textcode == null) textcode ="";
					if (textdesc == null) textdesc ="";
					if (texttype == null) texttype ="";
					if (textstatus == null) textstatus ="";
					if (textvend == null) textvend ="";
					if (textcno == null) textcno ="";
					if (textdep == null) textdep ="";
					
					String PartyListStr = "''";
					if (!textdep.trim().equals("")) {
						List partyList_dep=ph.getAllSubPartysByPartyId(session,textdep);
						Iterator itdep = partyList_dep.iterator();
						PartyListStr = "'"+textdep+"'";
						while (itdep.hasNext()) {
							Party p =(Party)itdep.next();
							PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
						}
					}
					
					String QryStr = "select p from ProjectMaster as p inner join p.projectType as pt ";
					QryStr = QryStr +"                                inner join p.Vendor as c";
					QryStr = QryStr +"                                inner join p.projectCategory as pc";
					
					if (!textdep.trim().equals("")) {
						QryStr = QryStr +" inner join p.department as dep";
						QryStr = QryStr +" where dep.partyId in (" + PartyListStr +")";
					} else {
						QryStr = QryStr + " inner join p.ProjectManager as pm";
						QryStr = QryStr +" where pm.userLoginId = '" + ul.getUserLoginId() + "'";
					}
					QryStr = QryStr + " and p.ContractNo like '%"+textcno+"%'";
					QryStr = QryStr + " and pc.Id = 'P'";
					QryStr = QryStr +" and ((p.projId like '%"+ textcode +"%') and (p.projName like '%"+ textdesc +"%')";
					QryStr = QryStr +" and (p.projStatus like '%"+ textstatus +"%')";
					QryStr = QryStr +" and ((c.partyId like '%"+ textvend +"%') or (c.description like '%"+ textvend +"%'))";
					QryStr = QryStr +" and (pt.ptId like '%"+ texttype +"%'))";
					
					Query q = session.createQuery(QryStr);
					//q.setMaxResults(20);
					result = q.list();
							
					request.setAttribute("QryList",result);
					
					if (formAction != null && formAction.equals("dialogView")) {
						 return (mapping.findForward("dialogView"));
								}
								
				}catch(Exception e){
					log.error(e.getMessage());
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
				return (mapping.findForward("success"));
		}
}


/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.bid;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bid.FindStepGroupForm;

/**
 * @author Jackey Ding 
 * @version 2005-07-5
 *
 */
public class FindStepGroupAction extends BaseAction {
	
	private Logger log = Logger.getLogger(FindStepGroupAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		try {
			long timeStart = System.currentTimeMillis();    //for performance test
			FindStepGroupForm fsgForm = (FindStepGroupForm)form;
			
			String qryDepartmentId = request.getParameter("qryDepartmentId");
			String qryDisableFlg = request.getParameter("qryDisableFlg");
			
			Session session = Hibernate2Session.currentSession();
			PartyHelper ph = new PartyHelper();
			
			List partyList = null;
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			if(ul.getParty()!=null){
				partyList = ph.getAllSubPartysByPartyId(session,ul.getParty().getPartyId());
			}
			if (partyList == null) partyList = new ArrayList();
			partyList.add(0, ul.getParty());
			request.setAttribute("PartyList", partyList);
			
			String whereStr = "";
			StringBuffer statement = new StringBuffer("");
			statement.append(" from SalesStepGroup as ssg");
			
			String PartyListStr = "''";
			if ( qryDepartmentId != null && !qryDepartmentId.trim().equals("")) {
					List partyList_dep=ph.getAllSubPartysByPartyId(session,qryDepartmentId);
					Iterator itdep = partyList_dep.iterator();
					PartyListStr = "'"+qryDepartmentId+"'";
					while (itdep.hasNext()) {
							Party p =(Party)itdep.next();
							PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
							}
			}
			if (fsgForm.getQryDisableFlg() == null) {
				whereStr = " where ssg.disableFlag = '"+Constants.STEP_GROUP_DISABLE_FLAG_STATUS_NO+"' ";
			}
			
			if(qryDepartmentId!=null && !qryDepartmentId.trim().equals("")){
				if(!whereStr.equals("")){
					whereStr += " and ssg.department.partyId in (" + PartyListStr +")";
				}else{
					whereStr = " where ssg.department.partyId in (" + PartyListStr +")";
				}
			}
			
			if (!whereStr.equals("")) {
				whereStr = statement.toString() + whereStr;
			}
				
			Query query = session.createQuery(whereStr);
			request.setAttribute("QryList", query.list());
			
			
			long timeEnd = System.currentTimeMillis();      //for performance test
			log.info("it takes " + (timeEnd - timeStart) + " ms to excute the query...");
			
			if ("dialogView".equals(fsgForm.getQryFormAction())) {
				return mapping.findForward("dialogView");
			}
		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
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
		return mapping.findForward("view");
	}
}

/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.timesheet;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyRelationship;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2004-10-30
 *
 */
public class FindPRMPageAction extends BaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(FindPRMPageAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		DynaValidatorForm projectSelectForm = (DynaValidatorForm) form;
		UserLogin ul =
			(UserLogin) request.getSession().getAttribute(
				Constants.USERLOGIN_KEY);
		List result = new ArrayList();
		ArrayList departmentSelectArr = new ArrayList();

		try {

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Query q =
				hs.createQuery(
					"select party from Party as party where party.partyId = :partyId");
			q.setParameter("partyId", ul.getParty().getPartyId());
			result = q.list();
//			List itResult = null;
//			Iterator itMstr = result.iterator();
//			if (itMstr.hasNext()) {
//				Party party = (Party) itMstr.next();
//				Set relationships = party.getRelationships();
//				Iterator it = relationships.iterator();
//				HashMap departmentSelectmap = new HashMap();
//				departmentSelectmap.put("key", party.getPartyId());
//				departmentSelectmap.put("value",party.getDescription());
//				departmentSelectArr.add(departmentSelectmap);
//				while (it.hasNext()) {
//					PartyRelationship partyRelationship = (PartyRelationship) it.next();
//					departmentSelectmap = new HashMap();
//					departmentSelectmap.put("key", partyRelationship.getPartyTo());
//					q = hs.createQuery(
//					"select party from Party as party where party.partyId = :partyId");
//					q.setParameter("partyId", partyRelationship.getPartyTo());
//					result = q.list();
//					itMstr = result.iterator();
//					if (itMstr.hasNext()) {
//						party = (Party) itMstr.next();
//						departmentSelectmap.put("value",party.getDescription());
//					}
//					departmentSelectArr.add(departmentSelectmap);
//				}
//			}
		
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return (mapping.findForward("success"));
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

		return (mapping.findForward("success"));
	}
}

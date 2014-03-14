/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.bid;

import java.sql.SQLException;
import java.util.*;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.PartyServices;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.bid.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bid.EditStepGroupForm;

public class EditStepGroupAction extends BaseAction {
	
	private Logger log = Logger.getLogger(EditStepGroupAction.class);
	
	public ActionForward perform(ActionMapping mapping,
			 ActionForm form,
			 HttpServletRequest request,
			 HttpServletResponse response) {
		Transaction transaction = null; 
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			EditStepGroupForm esfForm = (EditStepGroupForm)form;
			SalesStepGroupService salesStepGroupService = new SalesStepGroupService();
			
			PartyHelper ph = new PartyHelper();
			
			List partyList = null;
			UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			if(ul.getParty()!=null){
				partyList = ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
			}
			if (partyList == null) partyList = new ArrayList();
			partyList.add(0, ul.getParty());
			request.setAttribute("PartyList", partyList);
			
			if ("view".equals(esfForm.getFormAction())) {
				request.setAttribute("SalesStepGroup", salesStepGroupService.viewSalesStepGroup(esfForm.getId(), false));
			}
			
			if ("edit".equals(esfForm.getFormAction())) {
				SalesStepGroup ssg = convertFormToModule(esfForm);
				if (ssg.getId() != null && ssg.getId().longValue() > 0L) {
				//	SalesStepGroupService StepGroupService = new SalesStepGroupService();
				//	ssg = salesStepGroupService.viewSalesStepGroup(ssg.getId(), false);
					
					salesStepGroupService.updateSalesStepGroup(ssg);
				} else {
					salesStepGroupService.newSalesStepGroup(ssg);
				}
				request.setAttribute("SalesStepGroup", ssg);
			}
			
			if ("delete".equals(esfForm.getFormAction())) {
				String stepId = request.getParameter("stepId");
				SalesStep ss = null;
				if (stepId != null && (new Long(stepId)).longValue() > 0L) {
					SalesStepService salesStepService = new SalesStepService();
					ss = salesStepService.viewSalesStep(new Long(stepId));
					int currSeqNo = ss.getSeqNo().intValue();
					salesStepService.deleteSalesStep(ss);
					
					//seqNo --
					if (esfForm.getId() != null && esfForm.getId().longValue() > 0L) {
						SalesStepGroup stepGroup = (SalesStepGroup)salesStepGroupService.viewSalesStepGroup(esfForm.getId(), false);	
						if(stepGroup.getSteps()!=null){
							Iterator it = stepGroup.getSteps().iterator();
							while(it.hasNext()){
								SalesStep step = (SalesStep)it.next();
								if(step.getSeqNo().intValue()>currSeqNo){
									step.setSeqNo(new Integer(step.getSeqNo().intValue()-1));
									salesStepService.updateSalesStep(step);
								}
							}
						}
					}
					
				}
				
				if (esfForm.getId() != null && esfForm.getId().longValue() > 0L) {
					request.setAttribute("SalesStepGroup", salesStepGroupService.viewSalesStepGroup(esfForm.getId(), false));
				}
				
			}
			
			String DataId = request.getParameter("DataId");
			if(DataId!=null && DataId.length() >0){
				SalesStepGroup ssg = salesStepGroupService.viewSalesStepGroup(new Long(DataId), false);
				request.setAttribute("SalesStepGroup", ssg);
			}
			
		} catch (Exception e) {
			try {
				if (transaction != null) {
					transaction.rollback();
				}
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (transaction != null) {
					transaction.commit();
				}
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
		
		return mapping.findForward("success");
	}
	
	private SalesStepGroup convertFormToModule(EditStepGroupForm esfForm) throws HibernateException {
		SalesStepGroup ssg = null;
		
		if (esfForm.getId() != null && esfForm.getId().longValue() > 0L) {
			SalesStepGroupService salesStepGroupService = new SalesStepGroupService();
			ssg = salesStepGroupService.viewSalesStepGroup(esfForm.getId(), false);
		} else {
			ssg = new SalesStepGroup();
		}
		
		if (esfForm.getDepartmentId() != null 
				&& (ssg.getDepartment() == null 
						|| !ssg.getDepartment().getPartyId().equals(esfForm.getDepartmentId()))) {
			PartyServices partyService = new PartyServices();
			ssg.setDepartment(partyService.getParty(esfForm.getDepartmentId()));
		}
		
		if (esfForm.getDescription() != null) {
			ssg.setDescription(esfForm.getDescription());
		}
		if (esfForm.getDisableFlag() != null) {
			ssg.setDisableFlag(Constants.STEP_GROUP_DISABLE_FLAG_STATUS_YES);
		} else {
			ssg.setDisableFlag(Constants.STEP_GROUP_DISABLE_FLAG_STATUS_NO);
		}
		return ssg;
	}
}

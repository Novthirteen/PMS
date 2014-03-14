/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.bid;

import java.sql.SQLException;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.prm.bid.*;

import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bid.EditStepForm;

public class EditStepAction extends BaseAction {
	private Logger log = Logger.getLogger(EditStepAction.class);
	
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
		Transaction transaction = null; 
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			EditStepForm esForm = (EditStepForm)form;
			SalesStepService salesStepService = new SalesStepService();
			String stepGroupId = request.getParameter("stepGroupId");
			
			//set seq No.
			String groupId = "";
			if(stepGroupId!=null && !stepGroupId.equals("")){
				groupId = stepGroupId;
				esForm.setStepGroupId(new Long(stepGroupId));
			}else{
				groupId =  String.valueOf(esForm.getStepGroupId());
			}
			SalesStepGroup stepGroup=(SalesStepGroup)hs.load(SalesStepGroup.class,new Long(groupId));
			
			if ("view".equals(esForm.getFormAction())) {
				request.setAttribute("SalesStep", salesStepService.viewSalesStep(esForm.getId()));
				request.setAttribute("maxSeqNo",String.valueOf(getMaxSeqNo(hs,stepGroup,0)));
			}
			
			if ("edit".equals(esForm.getFormAction())) {
				transaction = hs.beginTransaction();
				SalesStep ss = convertFormToModule(esForm);
				if (ss.getId() != null && ss.getId().longValue() > 0L) {
					salesStepService.updateSalesStep(ss);
				} else {
					salesStepService.newSalesStep(ss);
					request.setAttribute("maxSeqNo",String.valueOf(getMaxSeqNo(hs,stepGroup,ss.getSeqNo().intValue())));
				}
				request.setAttribute("SalesStep", ss);
			}
			
			if ("delete".equals(esForm.getFormAction())) {
				transaction = hs.beginTransaction();
				SalesStep ss = convertFormToModule(esForm);
				salesStepService.deleteSalesStep(ss);
			}
			
			if ("deleteActivity".equals(esForm.getFormAction())) {
				transaction = hs.beginTransaction();
				String activityId = request.getParameter("activityId");
				
				SalesActivity sa = null;
				if (activityId != null && (new Long(activityId)).longValue() > 0L) {
					SalesActivityService salesActivityService = new SalesActivityService();
					sa = salesActivityService.viewSalesActivity(new Long(activityId));
					int currSeqNo = sa.getSeqNo().intValue();
					salesActivityService.deleteSalesActivity(sa);
					
					//seqno --
					if (esForm.getId() != null && esForm.getId().longValue() > 0L) {
						SalesStep step = salesStepService.viewSalesStep(esForm.getId());
						if(step.getActivities()!=null){
							Iterator it = step.getActivities().iterator();
							while(it.hasNext()){
								SalesActivity activity = (SalesActivity)it.next();
								if(activity.getSeqNo().intValue()>currSeqNo){
									activity.setSeqNo(new Integer(activity.getSeqNo().intValue()-1));
									salesActivityService.updateSSalesActivity(activity);
								}
							}
						}
					}
				} 
				if (esForm.getId() != null && esForm.getId().longValue() > 0L) {
					request.setAttribute("SalesStep", salesStepService.viewSalesStep(esForm.getId()));
				}
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
	
	private int getMaxSeqNo(net.sf.hibernate.Session hs,SalesStepGroup stepGroup,int i){
		int maxSeqNo = 0;
		if(stepGroup.getSteps()!=null){
			Iterator it = stepGroup.getSteps().iterator();
			while(it.hasNext()){
				SalesStep step = (SalesStep)it.next();
				if(step.getSeqNo().intValue() > maxSeqNo)
					maxSeqNo = step.getSeqNo().intValue();
				}
		}
		if(i > maxSeqNo)maxSeqNo = i;
		return maxSeqNo;
	}
	
	private SalesStep convertFormToModule(EditStepForm esForm) throws HibernateException {
		SalesStep ss = null;
		SalesStepService salesStepService = new SalesStepService();
		
		int oldSeqNo = 0;
		if (esForm.getId() != null && esForm.getId().longValue() > 0L) {
			ss = salesStepService.viewSalesStep(esForm.getId());
			oldSeqNo = ss.getSeqNo().intValue();
		} else {
			ss = new SalesStep();
		}
		
		//seqNo ++
		Long stepGroupId = null;
		SalesStepGroupService salesStepGroupService = new SalesStepGroupService();
		boolean noFlag = true;
		
		if(ss.getSeqNo() != null && esForm.getSeqNo()!=null && ss.getSeqNo().equals(esForm.getSeqNo())){//edit
			noFlag = false;
		}
		if(noFlag){
			if(ss.getStepGroup()!=null){
				stepGroupId = ss.getStepGroup().getId();
			}else{
				stepGroupId = esForm.getStepGroupId();
			}
			
			if(stepGroupId !=null){
			  SalesStepGroup stepGroup = salesStepGroupService.viewSalesStepGroup(stepGroupId, true);
			  if(stepGroup.getSteps()!=null){
				  if(esForm.getSeqNo() != null){
				  	  
					  int currSeqNo = esForm.getSeqNo().intValue();
					  Iterator it = stepGroup.getSteps().iterator();
					  boolean flag = false;
					  while(it.hasNext()){
						  SalesStep step = (SalesStep)it.next();
						  if(step.getSeqNo().intValue()==currSeqNo){
							  flag = true;
						  }
					  }
					  it = stepGroup.getSteps().iterator();
					  if(flag == true){
						  while(it.hasNext()){
							  SalesStep step = (SalesStep)it.next();
							  if(oldSeqNo > 0){//edit bigger than the old seq No 
							  	if(currSeqNo < oldSeqNo){
									if(step.getSeqNo().intValue()>=currSeqNo && step.getSeqNo().intValue()<oldSeqNo){
										  step.setSeqNo(new Integer(step.getSeqNo().intValue() + 1));
										  salesStepService.updateSalesStep(step);
									  }
							  	}else{
									if(step.getSeqNo().intValue() >= currSeqNo){
									  step.setSeqNo(new Integer(step.getSeqNo().intValue() + 1));
									  salesStepService.updateSalesStep(step);
								  }
							  	}
								
							  }else{
								if(step.getSeqNo().intValue()>=currSeqNo ){
									  step.setSeqNo(new Integer(step.getSeqNo().intValue() + 1));
									  salesStepService.updateSalesStep(step);
								  }
							  }
							  
						  }
					  }
				  }
			  }
	
			}
		}
		
		if (esForm.getStepGroupId() != null && esForm.getStepGroupId().longValue() > 0L && ss.getStepGroup() == null) {
			ss.setStepGroup(salesStepGroupService.viewSalesStepGroup(esForm.getStepGroupId(), true));
		}
		
		if (esForm.getSeqNo() != null) {
			ss.setSeqNo(esForm.getSeqNo());
		}
		
		if (esForm.getDescription() != null) {
			ss.setDescription(esForm.getDescription());
		}
		
		if (esForm.getPercentage() != null) {
			ss.setPercentage(esForm.getPercentage());
		}
		
		return ss;
	}
}

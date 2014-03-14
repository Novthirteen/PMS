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

import com.aof.component.prm.bid.SalesActivity;
import com.aof.component.prm.bid.SalesActivityService;
import com.aof.component.prm.bid.SalesStep;
import com.aof.component.prm.bid.SalesStepService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.prm.bid.EditStepActivityForm;
import com.aof.webapp.form.prm.bid.EditStepForm;

public class EditStepActivityAction extends BaseAction {
	
	private Logger log = Logger.getLogger(EditStepActivityAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		Transaction transaction = null; 
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			EditStepActivityForm esaForm = (EditStepActivityForm)form;
			SalesActivityService salesActivityService = new SalesActivityService();
			String stepId = request.getParameter("stepId");
			String formAction = request.getParameter("formAction");
			
			String temptId = "";
			if(stepId!=null && !stepId.equals("")){
				temptId = stepId;
				esaForm.setStepId(new Long(stepId));
			}else{
				temptId =String.valueOf(esaForm.getStepId());
			}
			SalesStep step=(SalesStep)hs.load(SalesStep.class,new Long(temptId));
			
			if ("view".equals(formAction)) {
				request.setAttribute("SalesActivity", salesActivityService.viewSalesActivity(esaForm.getId()));
				request.setAttribute("maxSeqNo",String.valueOf(getMaxSeqNo(hs,step,0)));
			}
			
			
			if ("edit".equals(formAction)) {
				transaction = hs.beginTransaction();
				SalesActivity sa = convertFormToModule(esaForm);
				if (sa.getId() != null && sa.getId().longValue() > 0L) {
					salesActivityService.updateSSalesActivity(sa);
				} else {
					salesActivityService.newSalesActivity(sa);
					request.setAttribute("maxSeqNo",String.valueOf(getMaxSeqNo(hs,step,esaForm.getSeqNo().intValue())));
				}
				request.setAttribute("SalesActivity", sa);
			}
				
			if ("delete".equals(formAction)) {
				transaction = hs.beginTransaction();
				SalesActivity sa = convertFormToModule(esaForm);
				salesActivityService.deleteSalesActivity(sa);
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
	
	private int getMaxSeqNo(net.sf.hibernate.Session hs,SalesStep step,int i){
		int maxSeqNo = 0;
		if(step.getActivities()!=null){
			Iterator it = step.getActivities().iterator();
			while(it.hasNext()){
				SalesActivity activity = (SalesActivity)it.next();
				if(activity.getSeqNo().intValue() > maxSeqNo)
					maxSeqNo = activity.getSeqNo().intValue();
				}
		}
		if(maxSeqNo < i){
			maxSeqNo = i;
		}
		return maxSeqNo;
	}
	
	private SalesActivity convertFormToModule(EditStepActivityForm esaForm) throws HibernateException {
		SalesActivity sa = null;
		SalesActivityService salesActivityService = new SalesActivityService();
		
		int oldSeqNo = 0;
		if (esaForm.getId() != null && esaForm.getId().longValue() > 0L) {
			sa = salesActivityService.viewSalesActivity(esaForm.getId());
			oldSeqNo = sa.getSeqNo().intValue();
		} else {
			sa = new SalesActivity();
		}
		
		//seqNo ++
		SalesStepService salesStepService = new SalesStepService();
		Long stepId = null;
		boolean noFlag = true;
		
		if(sa.getSeqNo() != null && esaForm.getSeqNo()!=null && sa.getSeqNo().equals(esaForm.getSeqNo())){//edit
			noFlag = false;
		}
		if(noFlag){
			if(sa.getStep()!=null){
				stepId = sa.getStep().getId();
			}else{
				stepId = esaForm.getStepId();
			}
			if (stepId != null ){ 
				SalesStep step = salesStepService.viewSalesStep(stepId);
				if(step.getActivities()!=null){
				  if(esaForm.getSeqNo()!=null){
					  int currSeqNo = esaForm.getSeqNo().intValue();
					  Iterator it = step.getActivities().iterator();
					  boolean flag = false;
					  while(it.hasNext()){
						  SalesActivity activity = (SalesActivity)it.next();
						  if(activity.getSeqNo().intValue()==currSeqNo){
							  flag = true;
						  }
					  }
					  it = step.getActivities().iterator();
					  if(flag == true){
						  while(it.hasNext()){
							  SalesActivity activity = (SalesActivity)it.next();
							  if(oldSeqNo > 0){
								if(currSeqNo < oldSeqNo){
									if(activity.getSeqNo().intValue()>=currSeqNo && activity.getSeqNo().intValue()< oldSeqNo){
										  activity.setSeqNo(new Integer(activity.getSeqNo().intValue()+1));
										  salesActivityService.updateSSalesActivity(activity);
									  }
								}else{
									if(activity.getSeqNo().intValue() >= currSeqNo ){
										  activity.setSeqNo(new Integer(activity.getSeqNo().intValue()+ 1));
										  salesActivityService.updateSSalesActivity(activity);
									  }
								}
								
							  }else{
								if(activity.getSeqNo().intValue()>=currSeqNo){
									  activity.setSeqNo(new Integer(activity.getSeqNo().intValue()+1));
									  salesActivityService.updateSSalesActivity(activity);
								  }
							  }
							  
						  }
					  }
				  }
				}
			}
		}
		
		if (esaForm.getStepId() != null && esaForm.getStepId().longValue() > 0L && sa.getStep() == null ) {
			sa.setStep(salesStepService.viewSalesStep(esaForm.getStepId()));
		}
				
		if (esaForm.getSeqNo() != null) {
			sa.setSeqNo(esaForm.getSeqNo());
		}
				
		if (esaForm.getDescription() != null) {
			sa.setDescription(esaForm.getDescription());
		}
		
		if (esaForm.getCriticalFlg() != null) {
			sa.setCriticalFlg(Constants.STEP_ACTIVITY_CRITICAL_FLAG_STATUS_YES);
		} else {
			sa.setCriticalFlg(Constants.STEP_ACTIVITY_CRITICAL_FLAG_STATUS_NO);
		}
		return sa;
	}
}

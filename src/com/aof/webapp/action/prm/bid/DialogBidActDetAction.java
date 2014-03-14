package com.aof.webapp.action.prm.bid;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Transaction;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.bid.BidActDetail;
import com.aof.component.prm.bid.BidActivity;
import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.bid.SalesActivity;
import com.aof.component.prm.bid.SalesStep;
import com.aof.component.prm.bid.SalesStepGroup;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

public class DialogBidActDetAction extends BaseAction{
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		String action = request.getParameter("FormAction");
		
		if(action == null) action = "view";
		BidActivity bidActivity = null;
		
		try{
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			
			String bidActId = request.getParameter("bidActId");//bidActivity
			String bidId = request.getParameter("bidId");
			BidMaster bm = new BidMaster();
			if (!((bidId == null) || (bidId.length() < 1))) {
				bm = (BidMaster)hs.load(BidMaster.class,new Long(bidId));				    
			}			
			if("view".equals(action)){
				if ((bidActId != null) && (bidActId.length() > 0)){
					bidActivity = (BidActivity)hs.load(BidActivity.class,new Long(bidActId));
				}
				Set bidActDetailList = null;
				if(bidActivity != null){
					bidActDetailList = bidActivity.getBidActDetails();
				}
				request.setAttribute("BidActDetailList",bidActDetailList);

					Set bidActivitySet = bm.getBidActivities();
					Iterator bit = bidActivitySet.iterator();
					ArrayList bbId = new ArrayList();
					while(bit.hasNext()){
						BidActivity bty = (BidActivity)bit.next();
						if(bty.getBidActDetails().size()>0){
							bbId.add(bty.getActivity().getId());
						}
					}
//--------------------			
				SalesStepGroup stepGroup = bm.getStepGroup();
				Set steps = stepGroup.getSteps();
				bm.setCurrentStep(null);
				if(steps != null){
					ArrayList stepList = ComparatorStepArray(steps);
					Iterator it = stepList.iterator();
					while(it.hasNext()){//step
						tx = hs.beginTransaction();
						SalesStep stepOne = (SalesStep)it.next();
						Iterator ait = stepOne.getActivities().iterator();			
						while(ait.hasNext()){// activity list in each step
							String flag1="";
							SalesActivity sa = (SalesActivity)ait.next();
							for(int ii=0; ii<bbId.size();ii++){
								if(sa.getId()==bbId.get(ii)){
									flag1="pass";
									continue;
								}
							}	
							if ((flag1.equals(""))||(bbId.size()==0)){
								hs.flush();
								tx.commit();
								request.setAttribute("bidMaster",bm);
								return (mapping.findForward("view"));
							}
						}
						bm.setCurrentStep(stepOne);
						hs.update(bm);			
					}
			 }
				hs.flush();
				tx.commit();
				request.setAttribute("bidMaster",bm);
				
			}
			return (mapping.findForward("view"));
		}catch(Exception e){
			e.printStackTrace();
	//		log.error(e.getMessage());
			return (mapping.findForward("view"));	
		}finally{
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
	//			log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
	//			log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
	}
	
	private ArrayList ComparatorStepArray(Set steps){
		ArrayList list = new ArrayList();
		Object[] stepArray = steps.toArray();
		for(int i = 0;i<steps.size();i++){
			Integer seqNo1= ((SalesStep)stepArray[i]).getSeqNo();
			for(int j=i+1;j<steps.size();j++){
				Integer seqNo2 = ((SalesStep)stepArray[j]).getSeqNo();
				seqNo1= ((SalesStep)stepArray[i]).getSeqNo();
				if(seqNo1.intValue()>seqNo2.intValue()){
					Object temp = stepArray[i];
					stepArray[i] = stepArray[j];
					stepArray[j] = temp;
				}
			}
			list.add(stepArray[i]);
		}
		
		return list;
	}

}

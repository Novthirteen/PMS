/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.master;

import java.sql.SQLException;
import java.text.DateFormat; 
import java.text.SimpleDateFormat; 
import java.util.*; 

import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.*;


import org.apache.log4j.Logger;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;


import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.component.prm.project.*;
import com.aof.component.domain.party.*;
import com.aof.component.prm.TimeSheet.*;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import net.sf.hibernate.*;
import com.aof.util.*;
/**
/**
 * @author Elaine Sun 
 * @version 2004-12-10
 *
 */
public class EditConsultantCostAction extends BaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(EditConsultantCostAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
	    //ConsultantCost cc=new ConsultantCost();
		String departmentId=request.getParameter("departmentId");
		String year=request.getParameter("year");
		String Action=request.getParameter("Action");
		String Count=request.getParameter("Count");
		String offset=request.getParameter("offset");
		if(Count==null||Count.length()<1){
		
		Count="10";
		}
		
		
		String IdStr[]=new String[Integer.valueOf(Count).intValue()];
		Long Id[]=new Long[Integer.valueOf(Count).intValue()];
		String user[]=new String[Integer.valueOf(Count).intValue()];
		String costStr[]=new String[Integer.valueOf(Count).intValue()];
		Float cost[]=new Float[Integer.valueOf(Count).intValue()];
		if(Action==null)
		{
		   Action="view";
	    }
		if(Action.equals("save")){
			            int i=Integer.valueOf(offset).intValue()+1;
						while(i<=Integer.valueOf(Count).intValue()){
						//log.info("id1="+request.getParameter("Id"+i));
						IdStr[i-1]=request.getParameter("Id"+i);
					           if(IdStr[i-1]==null||IdStr[i-1].length()<1){
			    	   }
					   else{
							   Id[i-1]=new Long(IdStr[i-1]);   
					   }
						user[i-1]=request.getParameter("user"+i);
						costStr[i-1]=request.getParameter("cost"+i);
						if(costStr[i-1]==null||costStr[i-1].length()<1){
			    	
						}
						else{
							cost[i-1]=new Float(costStr[i-1]);   
						}
			        	i++;
						}
		}    
		
		try{
					
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			List memberResult = new ArrayList();
			List crResult =new ArrayList();
			tx = hs.beginTransaction();
			Query q = hs.createQuery("select ul from UserLogin as ul inner join ul.party as p where p.partyId = :DepId");
			q.setParameter("DepId",departmentId);
			memberResult = q.list();
			request.setAttribute("memberResult",memberResult);
			Query q1 = hs.createQuery("select cr from ConsultantCost as cr inner join cr.User as ul inner join ul.party as p where p.partyId = :DepId and cr.Year = :year");
			q1.setParameter("DepId",departmentId);
			q1.setParameter("year",year);
			crResult = q1.list();
			request.setAttribute("crResult",crResult);
			tx = hs.beginTransaction();
			tx.commit();  
			if(Action.equals("save")){
						net.sf.hibernate.Session hs1 = Hibernate2Session.currentSession();
						Transaction tx1=null;
				        tx1 = hs1.beginTransaction();
						for(int index=Integer.valueOf(offset).intValue();index<Integer.valueOf(Count).intValue();index++){
								  // log.info("for funcgtion");
							if(Id[index].toString().equals("0")){
							//	Create a new Recorsd
					log.info("create:"+index);
						  // tx1 = hs1.beginTransaction();
							ConsultantCost cr = new ConsultantCost();
							UserLogin ul=(UserLogin)hs1.load(UserLogin.class,user[index]);
							cr.setUser(ul);
							cr.setYear(Integer.valueOf(year));
							cr.setCost(cost[index]);
							hs1.save(cr);
							Query q2 = hs.createQuery("select cr from ConsultantCost as cr inner join cr.User as ul inner join ul.party as p where p.partyId = :DepId and cr.Year = :year");
										q2.setParameter("DepId",departmentId);
										q2.setParameter("year",year);
										crResult = q2.list();
										request.setAttribute("crResult",crResult);	
							//tx1.commit();					
							} 
							else{
						   //Update Record
						   //tx1 = hs1.beginTransaction();
				   log.info("Update:id="+Id[index]);
				   log.info("Update:index="+index);
				            ConsultantCost cr=(ConsultantCost)hs1.load(ConsultantCost.class,Id[index]);
							UserLogin ul=(UserLogin)hs1.load(UserLogin.class,user[index]);
							cr.setUser(ul);
							cr.setYear(Integer.valueOf(year));
							cr.setCost(cost[index]);
							hs1.update(cr);
							//tx1.commit();
						}
					 
						//request.setAttribute("FMonth",fm);
						log.info("go to >>>>>>>>>>>>>>>>. view forward");
						tx1.commit();
						}
					
    		}  
		    		
					
					
		return (mapping.findForward("success"));
		}catch(Exception e){
						e.printStackTrace();
						log.error(e.getMessage());
						return (mapping.findForward("success"));	
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
			      return (mapping.findForward("success"));
					}
	}
}

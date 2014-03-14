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
public class EditFisCalendarAction extends BaseAction {
	public ActionForward perform(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		// Extract attributes we will need
		Logger log = Logger.getLogger(EditFisCalendarAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
				String yearStr =request.getParameter("year");
			    Integer year= new Integer("1900");
			    if(yearStr!=null){
			    
				 year= new Integer(yearStr);
			    }
				
				//String FormAction1="save";
				String FormAction1=request.getParameter("FormAction1");
				
				String Flag=request.getParameter("flag");
				Integer Size=null;
			    if (Flag == null || Flag.length()<1) {
			
		        } else {
			        Size= new Integer(Flag);					
		        }	
			
				String IdStr[]=new String[12];
				Long Id[]=new Long[12];
				String MonStr[]=new String[12];
				Integer Mon[]=new Integer[12];
			    String StartDate[]=new String[12];
				String EndDate[]=new String[12];
				String CloseDate[]=new String[12]; 
				String Desc[]=new String[12];
			    int i=1;
			    if(FormAction1==null)
			    {
			    	FormAction1="view";
			    }
			if(FormAction1.equals("save")){
			    while(i<=12){
				log.info("id1="+request.getParameter("Id"+i));
			    IdStr[i-1]=request.getParameter("Id"+i);
			    if(IdStr[i-1]==null||IdStr[i-1].length()<1){
			    	
			    }
			    else{
					Id[i-1]=new Long(IdStr[i-1]);   
			    }
				MonStr[i-1]=request.getParameter("Mon"+i);
				if(MonStr[i-1]==null||MonStr[i-1].length()<1){
			    	
				}
				else{
					Mon[i-1]=new Integer(MonStr[i-1]);   
				}
			    
				StartDate[i-1]=request.getParameter("startDate"+i);
				EndDate[i-1] = request.getParameter("endDate"+i);
				CloseDate[i-1]=request.getParameter("closeDate"+i); 
				Desc[i-1]=request.getParameter("description"+i);
			    i++;
			    }
			}    
		
		try{
					net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
					Transaction tx = null;
					List memberResult = new ArrayList();
					List monthList = new ArrayList();
					tx = hs.beginTransaction();
			        
			
		            Query q = hs.createQuery("select fm from FMonth as fm where fm.Year = :year");
					q.setParameter("year", year);
					monthList = q.list();
					request.setAttribute("monthList",monthList);
			        //int Currlen=;
					tx = hs.beginTransaction();
					tx.commit();
			log.info("if function");
			//log.info(String.valueOf(Currlen));
					if(FormAction1.equals("save")){
						net.sf.hibernate.Session hs1 = Hibernate2Session.currentSession();
						Transaction tx1=null;
						//tx1 = hs1.beginTransaction();
					     
						
					    for(short index=0;index<12;index++){
			//		    	log.info(String.valueOf(Currlen));
			               log.info("for funcgtion");
						    if(Id[index].toString().equals("0")){
                            //	Create a new Recorsd
					log.info("create"+index);
					       tx1 = hs1.beginTransaction();
							FMonth fm = new FMonth();
						    fm.setYear(year);
                            fm.setMonthSeq(Mon[index].shortValue());
                            fm.setDateFrom(UtilDateTime.toDate2(StartDate[index] + " 00:00:00.000"));
                            fm.setDateTo(UtilDateTime.toDate2(EndDate[index] + " 23:59:59.000"));	           	
                            fm.setDateFreeze(UtilDateTime.toDate2(CloseDate[index] + " 23:59:59.000"));
                            fm.setDescription(Desc[index]);
							hs1.save(fm);	
							tx1.commit();					
							} 
							else{
						   //Update Record
						   tx1 = hs1.beginTransaction();
						log.info("index="+Id[index]);
					        FMonth fm=(FMonth)hs1.load(FMonth.class,Id[index]);
						    fm.setYear(year);
                   	        fm.setMonthSeq(Mon[index].shortValue());
						    fm.setDateFrom(UtilDateTime.toDate2(StartDate[index] + " 00:00:00.000"));
						    fm.setDateTo(UtilDateTime.toDate2(EndDate[index] + " 23:59:59.000"));	           	
						    fm.setDateFreeze(UtilDateTime.toDate2(CloseDate[index] + " 23:59:59.000"));
						    fm.setDescription(Desc[index]);
					        hs1.update(fm);
							tx1.commit();
						}
					 
						//request.setAttribute("FMonth",fm);
						log.info("go to >>>>>>>>>>>>>>>>. view forward");
						
					    }
					    //tx1.commit();
					}  
			             
						//FMonth fm=new FMonth();
						//fm.setYear(year);
						//fm.setMonthSeq(i);
						
						//fm.setDateFrom(UtilDateTime.toDate2(StartDate + " 00:00:00.000"));
						//fm.setDateTo(UtilDateTime.toDate2(EndDate + " 00:00:00.000"));	           	
						//fm.setDateFreeze(UtilDateTime.toDate2(CloseDate + " 00:00:00.000"));
	                    //fm.setDescription(Desc);
	                    
						//hs1.save(fm);
						//tx1.commit();
						//request.setAttribute("FMonth",fm);
					    log.info("go to >>>>>>>>>>>>>>>>. view forward");
					 
	          
				  
	           		
					
					
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

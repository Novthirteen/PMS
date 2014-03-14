/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.party;


import java.sql.SQLException;
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
import com.aof.component.domain.party.*;
import com.aof.core.persistence.hibernate.*;
/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class EditPartyAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditPartyAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("action");
			
			log.info("action="+action);
			try{
				String PartyId = request.getParameter("PartyId");
				String description = request.getParameter("description");
				
				String address = request.getParameter("address");
				String postcode = request.getParameter("postcode");
				String note = request.getParameter("note");
				String role = request.getParameter("role");
				String isSalesTeam = request.getParameter("isSalesTeam");
				String SLParentpartyId = request.getParameter("SLParentpartyId");
				String OldSLParentPartyId = request.getParameter("OldSLParentpartyId");
				String LocParentpartyId = request.getParameter("LocParentpartyId");
				String OldLocParentPartyId = request.getParameter("OldLocParentpartyId");
				
				String CustPartyTypeId = "PARTY_GROUP";
				
				if (address == null) address = "";
				if (postcode == null) postcode = "";
				if (note == null) note = "";
				if (role == null) role = "";
				if (SLParentpartyId == null) SLParentpartyId = "None";
				if (LocParentpartyId == null) LocParentpartyId = "None";
				if (isSalesTeam == null) {
					isSalesTeam = "N";
				}				
				log.info("============>"+description);

				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				if(action == null)
					action = "view";
					
				if(action.equals("view")){
					log.info(action);
					
					Party CustParty = null;
					if (!((PartyId == null) || (PartyId.length() < 1)))
						CustParty = (Party)hs.load(Party.class,PartyId);

					request.setAttribute("CustParty",CustParty);
					return (mapping.findForward("view"));
				}
				if(action.equals("create")){
					
					if ((PartyId == null) || (PartyId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		
					if ((description == null) || (description.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		
					
					log.info(PartyId+description);	

					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					try{
						tx = hs.beginTransaction();
						
						Party CustParty = new Party();
						CustParty.setPartyId(PartyId);
						CustParty.setDescription(description);
						CustParty.setAddress(address);
						CustParty.setPostCode(postcode);
						CustParty.setNote(note);
						CustParty.setIsSales(isSalesTeam);				
						PartyType CustPartyType = (PartyType)hs.load(PartyType.class,CustPartyTypeId);
						CustParty.setPartyType(CustPartyType);
						
						Set mset = CustParty.getPartyRoles();
						if(mset==null){
							mset = new HashSet();
						}
						mset.add((RoleType)hs.load(RoleType.class,role));
						CustParty.setPartyRoles(mset);
						
						hs.save(CustParty);
						tx.commit();
						
						PartyServices ps = new PartyServices();
						ps.updatePartyRelationshipByPartyId(hs, SLParentpartyId, PartyId,"GROUP_ROLLUP");
						ps.updatePartyRelationshipByPartyId(hs, LocParentpartyId, PartyId,"LOCATION_ROLLUP");
						
						request.setAttribute("CustParty",CustParty);
						log.info("go to >>>>>>>>>>>>>>>>. view forward");
					}catch(Exception e){
						e.printStackTrace();
					}
					
					return (mapping.findForward("view"));
				}
				
				if(action.equals("update")){ 
					if ((PartyId == null) || (PartyId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		

					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}

					tx = hs.beginTransaction();
					Party CustParty = (Party)hs.load(Party.class,PartyId);
					
					CustParty.setDescription(description);
					CustParty.setAddress(address);
					CustParty.setPostCode(postcode);
					CustParty.setNote(note);
					CustParty.setIsSales(isSalesTeam);	
					hs.update(CustParty);
					tx.commit();
					
					PartyServices ps = new PartyServices();
					ps.updatePartyRelationshipByPartyId(hs, SLParentpartyId, PartyId,"GROUP_ROLLUP");
					ps.updatePartyRelationshipByPartyId(hs, LocParentpartyId, PartyId,"LOCATION_ROLLUP");
					
					request.setAttribute("CustParty",CustParty);
					return (mapping.findForward("view"));
				}
				
				if(action.equals("delete")){
					if ((PartyId == null) || (PartyId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					tx = hs.beginTransaction();
					Party CustParty = (Party)hs.load(Party.class,PartyId);
					log.info("PartyId="+CustParty.getPartyId());
					
					PartyServices ps = new PartyServices();
					ps.updatePartyRelationshipByPartyId(hs, SLParentpartyId, PartyId,"GROUP_ROLLUP");
					ps.updatePartyRelationshipByPartyId(hs, LocParentpartyId, PartyId,"LOCATION_ROLLUP");
				
					hs.delete(CustParty);
					tx.commit();
					return (mapping.findForward("list"));
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
	
	
	
}

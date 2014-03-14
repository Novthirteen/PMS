/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.party;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.crm.customer.CustT2Code;
import com.aof.component.crm.customer.CustomerAccount;
import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.crm.customer.CustomerService;
import com.aof.component.crm.customer.Industry;
import com.aof.component.domain.party.PartyType;
import com.aof.component.domain.party.RoleType;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class EditCustPartyAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditCustPartyAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("action");
			String openType = request.getParameter("openType");
			
			log.info("action="+action);
			try{
				String PartyId = request.getParameter("PartyId");
				String description = request.getParameter("description");
				//String ParentpartyId = request.getParameter("ParentpartyId");
				String address = request.getParameter("address");
				String postcode = request.getParameter("postcode");
				String telecode = request.getParameter("telecode");
				String note = request.getParameter("note");
				String role = request.getParameter("role");
				String ChineseName = request.getParameter("ChineseName");
				String AccountId = request.getParameter("AccountId");
				String IndustryId = request.getParameter("IndustryId");
				String t2code = request.getParameter("t2code");
				String AccountCode=request.getParameter("AccountCode");
				String CustPartyTypeId = "PARTY_GROUP";
				
				if (address == null) address = "";
				if (postcode == null) postcode = "";
				if (telecode == null) telecode = "";
				if (note == null) note = "";
				if (role == null) role = "";
				if (ChineseName == null) ChineseName = "";
				if (AccountId == null) AccountId = "0";
				if (IndustryId == null) IndustryId = "0";
				if (t2code == null) t2code = "";
				if (AccountCode == null) AccountCode = "";
				
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				if(action == null)
					action = "view";
					
				if (!isTokenValid(request)) {
					if (action.equals("create") || action.equals("update")) {
						action = "view";
					}
				} 
				saveToken(request);
				
				if(action.equals("view")){
					log.info(action);
					CustomerProfile CustParty = null;
					if (!((PartyId == null) || (PartyId.length() < 1)))
						CustParty = (CustomerProfile)hs.load(CustomerProfile.class,PartyId);

					request.setAttribute("CustParty",CustParty);
					
					if ("dialogView".equals(openType)) {
						return (mapping.findForward("dialogView"));
					} else {
						return (mapping.findForward("view"));
					}
				}
				if(action.equals("create")){
					
					if ((PartyId == null) || (PartyId.length() < 1)) {
						CustomerService cs = new CustomerService();
						PartyId = cs.getCustomerNo(hs);
					}
					if ((description == null) || (description.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		

					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					try{
						tx = hs.beginTransaction();
						
						CustomerProfile CustParty = new CustomerProfile();
						CustParty.setPartyId(PartyId);
						CustParty.setDescription(description);
						CustParty.setAddress(address);
						CustParty.setPostCode(postcode);
						CustParty.setTeleCode(telecode);
						CustParty.setNote(note);
						CustParty.setType("C");
						CustParty.setChineseName(ChineseName);
						CustParty.setAccountCode(AccountCode);
						Industry ind =(Industry)hs.load(Industry.class,new Long(IndustryId));
						CustParty.setIndustry(ind);
						CustomerAccount acc =(CustomerAccount)hs.load(CustomerAccount.class,new Long(AccountId));
						CustParty.setAccount(acc);
						CustT2Code T2C = (CustT2Code)hs.load(CustT2Code.class,t2code);
						CustParty.setT2Code(T2C);
						
						PartyType CustPartyType = (PartyType)hs.load(PartyType.class,CustPartyTypeId);
						CustParty.setPartyType(CustPartyType);
						
						Set mset = CustParty.getPartyRoles();
						if(mset==null){
							mset = new HashSet();
						}
						mset.add((RoleType)hs.load(RoleType.class,role));
						CustParty.setPartyRoles(mset);
						
						hs.save(CustParty);
						hs.flush();
						tx.commit();
						
						//edit prospect Company
						String prospectCompanyId = request.getParameter("prospectCompanyId");
						if(prospectCompanyId != null && !prospectCompanyId.equals("") && !prospectCompanyId.equals("null")){
							tx = hs.beginTransaction();
							com.aof.component.prm.bid.ProspectCompany prospect = (com.aof.component.prm.bid.ProspectCompany)hs.load(com.aof.component.prm.bid.ProspectCompany.class,new Long(prospectCompanyId));
							
							prospect.setName(description);
							prospect.setAddress(address);
							prospect.setPostCode(postcode);
							prospect.setTeleNo(telecode);
							prospect.setChineseName(ChineseName);
							prospect.setIndustry(IndustryId);
							prospect.setCustomerGroup(AccountId);
							prospect.setStatus("Existing");
							
							hs.update(prospect);
							hs.flush();
							tx.commit();
						}
						
						request.setAttribute("CustParty",CustParty);
						log.info("go to >>>>>>>>>>>>>>>>. view forward");
					}catch(Exception e){
						e.printStackTrace();
					}
					
					if ("dialogView".equals(openType)) {
						return (mapping.findForward("dialogView"));
					} else {
						return (mapping.findForward("view"));
					}
				}
				
				if(action.equals("update")){ 
					if ((PartyId == null) || (PartyId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		

					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}

					tx = hs.beginTransaction();
					CustomerProfile CustParty = (CustomerProfile)hs.load(CustomerProfile.class,PartyId);
					
					CustParty.setDescription(description);
					CustParty.setAddress(address);
					CustParty.setPostCode(postcode);
					CustParty.setTeleCode(telecode);
					CustParty.setNote(note);
					
					CustParty.setChineseName(ChineseName);
					Industry ind =(Industry)hs.load(Industry.class,new Long(IndustryId));
					CustParty.setIndustry(ind);
					CustomerAccount acc =(CustomerAccount)hs.load(CustomerAccount.class,new Long(AccountId));
					CustParty.setAccount(acc);
					CustT2Code T2C = (CustT2Code)hs.load(CustT2Code.class,t2code);
					CustParty.setT2Code(T2C);
					CustParty.setAccountCode(AccountCode);
					hs.update(CustParty);
					tx.commit();	

					request.setAttribute("CustParty",CustParty);
					if ("dialogView".equals(openType)) {
						return (mapping.findForward("dialogView"));
					} else {
						return (mapping.findForward("view"));
					}
				}
				
				if(action.equals("delete")){
					if ((PartyId == null) || (PartyId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					
					tx = hs.beginTransaction();
					CustomerProfile CustParty = (CustomerProfile)hs.load(CustomerProfile.class,PartyId);
					log.info("PartyId="+CustParty.getPartyId());
					hs.delete(CustParty);
					tx.commit();
					
					return (mapping.findForward("after_delete"));
																	
				}
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				if ("dialogView".equals(openType)) {
					return (mapping.findForward("dialogView"));
				} else {
					return (mapping.findForward("view"));
				}
			}catch(Exception e){
				e.printStackTrace();
				log.error(e.getMessage());
				
				//cannot delete due to the database constraints
				if(action.equals("delete")){
					request.setAttribute("errorSign", "Cannot delete the record !");
				}
				
				if ("dialogView".equals(openType)) {
					return (mapping.findForward("dialogView"));
				} else {
					return (mapping.findForward("view"));
				}
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

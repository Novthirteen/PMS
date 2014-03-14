
package com.aof.webapp.action.party;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Criteria;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import com.aof.component.crm.vendor.VendorService;
import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.crm.vendor.VendorType;
import com.aof.component.domain.party.PartyType;
import com.aof.component.domain.party.RoleType;
import com.aof.component.prm.master.ProjectCalendarType;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01446
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class EditVendorPartyAction extends BaseAction {

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditVendorPartyAction.class.getName());
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
				String typeId = request.getParameter("TypeId");
				String BankNo = request.getParameter("BankNo");
				String TaxNo = request.getParameter("TaxNo");
				String AccountCode=request.getParameter("AccountCode");
				
				String VendorPartyTypeId = "PARTY_GROUP";

				if (address == null) address = "";
				if (postcode == null) postcode = "";
				if (telecode == null) telecode = "";
				if (note == null) note = "";
				if (role == null) role = "";
				if (ChineseName == null) ChineseName = "";
				if (AccountCode == null) AccountCode = "";
				//if (AccountId == null) AccountId = "0";
				//if (IndustryId == null) IndustryId = "0";
				
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				Criteria crit = hs.createCriteria(VendorType.class);
				List result = crit.list();

				
				request.setAttribute("TypeList",result);
				
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
					VendorProfile VendorParty = null;
					if (!((PartyId == null) || (PartyId.length() < 1)))
						VendorParty = (VendorProfile)hs.load(VendorProfile.class,PartyId);

					request.setAttribute("VendorParty",VendorParty);
					
					if ("dialogView".equals(openType)) {
						return mapping.findForward("dialogView");
					} else {
						return (mapping.findForward("view"));
					}
					
				}
				if(action.equals("create")){
					
					if ((PartyId == null) || (PartyId.length() < 1)) {
						VendorService cs = new VendorService();
						PartyId = cs.getVendorNo(hs);
					}
					if ((description == null) || (description.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");	
					
					if ((typeId == null) || (typeId.length() < 1)){
						actionDebug.addGlobalError(errors,"error.context.required");
					}
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					try{
						tx = hs.beginTransaction();
						VendorType VendorType = (VendorType)hs.load(VendorType.class,new Long(typeId));
						VendorProfile VendorParty = new VendorProfile();
						VendorParty.setPartyId(PartyId);
						VendorParty.setDescription(description);
						VendorParty.setAddress(address);
						VendorParty.setPostCode(postcode);
						VendorParty.setTeleCode(telecode);
						VendorParty.setNote(note);
						VendorParty.setChineseName(ChineseName);
						VendorParty.setCategoryType(VendorType);
						VendorParty.setBankNo(BankNo);
						VendorParty.setTaxNo(TaxNo);
						VendorParty.setAccountCode(AccountCode);
						//Industry ind =(Industry)hs.load(Industry.class,new Long(IndustryId));
						//CustParty.setIndustry(ind);
						//CustomerAccount acc =(CustomerAccount)hs.load(CustomerAccount.class,new Long(AccountId));
						//CustParty.setAccount(acc);
						
						PartyType VendorPartyType = (PartyType)hs.load(PartyType.class,VendorPartyTypeId);
						VendorParty.setPartyType(VendorPartyType);
						
						Set mset = VendorParty.getPartyRoles();
						if(mset==null){
							mset = new HashSet();
						}
						mset.add((RoleType)hs.load(RoleType.class,role));
						VendorParty.setPartyRoles(mset);
						
						hs.save(VendorParty);
						hs.flush();
						tx.commit();
						request.setAttribute("VendorParty",VendorParty);
						log.info("go to >>>>>>>>>>>>>>>>. view forward");
					}catch(Exception e){
						e.printStackTrace();
					}
					
					if ("dialogView".equals(openType)) {
						return mapping.findForward("dialogView");
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
					
					if ((typeId == null) || (typeId.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");

					tx = hs.beginTransaction();
					VendorProfile VendorParty = (VendorProfile)hs.load(VendorProfile.class,PartyId);
					VendorType VendorType = (VendorType)hs.load(VendorType.class, new Long(typeId));
					VendorParty.setDescription(description);
					VendorParty.setAddress(address);
					VendorParty.setPostCode(postcode);
					VendorParty.setTeleCode(telecode);
					VendorParty.setNote(note);
					VendorParty.setCategoryType(VendorType);
					VendorParty.setChineseName(ChineseName);
					VendorParty.setBankNo(BankNo);
					VendorParty.setTaxNo(TaxNo);
					VendorParty.setAccountCode(AccountCode);
					//Industry ind =(Industry)hs.load(Industry.class,new Long(IndustryId));
					//CustParty.setIndustry(ind);
					//CustomerAccount acc =(CustomerAccount)hs.load(CustomerAccount.class,new Long(AccountId));
					//CustParty.setAccount(acc);
					
					hs.update(VendorParty);
					tx.commit();	

					request.setAttribute("VendorParty",VendorParty);
					return (mapping.findForward("view"));
				}
				
				if(action.equals("delete")){
					if ((PartyId == null) || (PartyId.length() < 1)){
						actionDebug.addGlobalError(errors,"error.context.required");
					}	
					List cpResult = new ArrayList();
					net.sf.hibernate.Session session = Hibernate2Session.currentSession();
					Query q = session.createQuery("select cp from POProfile as cp inner join cp.vendor as v where v.partyId ='" +  PartyId + "' ");
					//q.setMaxResults(20);
					cpResult = q.list();
					if ( cpResult !=null){
						actionDebug.addGlobalError(errors,"error.context.required");
					}
					if (!errors.empty()) {
						saveErrors(request, errors);
						return (new ActionForward(mapping.getInput()));
					}
					tx = hs.beginTransaction();
					VendorProfile VendorParty = (VendorProfile)hs.load(VendorProfile.class,PartyId);
					log.info("PartyId="+VendorParty.getPartyId());
					hs.delete(VendorParty);
					tx.commit();
					return (mapping.findForward("after_delete"));
																	
				}
									
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				
				if ("dialogView".equals(openType)) {
					return mapping.findForward("dialogView");
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

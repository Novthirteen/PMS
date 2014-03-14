package com.aof.webapp.action.party;

import java.sql.SQLException;
import java.util.Locale;

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
import com.aof.component.crm.customer.Industry;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

public class VerifyProspectAction extends BaseAction{
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
		
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			Logger log = Logger.getLogger(EditCustPartyAction.class.getName());
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("action");
			
			log.info("action="+action);
			try{
				String PartyId = request.getParameter("PartyId");
				String pid = request.getParameter("pid");
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
				String faxNo=request.getParameter("faxNo");
				String bankNo=request.getParameter("bankNo");
				
				if (address == null) address = "";
				if (postcode == null) postcode = "";
				if (telecode == null) telecode = "";
				if (note == null) note = "";
				if (role == null) role = "";
				if (ChineseName == null) ChineseName = "";
				if (AccountId == null) AccountId = "0";
				if (IndustryId == null) IndustryId = "0";
				if (AccountCode == null) AccountCode = "";
				if (faxNo == null) faxNo = "";
				if (bankNo == null) bankNo = "";
				
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				if(action == null)
					action = "view";
					
				saveToken(request);
				
				if(action.equals("view")){
					log.info(action);
					CustomerProfile CustParty = null;
					if (!((PartyId == null) || (PartyId.length() < 1)))
						CustParty = (CustomerProfile)hs.load(CustomerProfile.class,PartyId);

					request.setAttribute("CustParty",CustParty);
						return (mapping.findForward("view"));
				}
				
				if(action.equals("update") || action.equals("verify") || action.equals("unverify")){ 
					if ((pid == null) || (pid.length() < 1))
						actionDebug.addGlobalError(errors,"error.context.required");		

					tx = hs.beginTransaction();
					CustomerProfile CustParty = (CustomerProfile)hs.load(CustomerProfile.class,pid);
					
					CustParty.setDescription(description);
					CustParty.setAddress(address);
					CustParty.setPostCode(postcode);
					CustParty.setTeleCode(telecode);
					CustParty.setNote(note);
					CustParty.setFaxCode(faxNo);
					CustParty.setAccountCode(bankNo);
					CustParty.setChineseName(ChineseName);
					Industry ind =(Industry)hs.load(Industry.class,new Long(IndustryId));
					CustParty.setIndustry(ind);
					CustomerAccount acc =(CustomerAccount)hs.load(CustomerAccount.class,new Long(AccountId));
					CustParty.setAccount(acc);
					if(!t2code.equalsIgnoreCase("-1")){
					CustT2Code T2C = (CustT2Code)hs.load(CustT2Code.class,t2code);
					CustParty.setT2Code(T2C);
					}
					CustParty.setAccountCode(AccountCode);
					if(action.equals("verify"))
						CustParty.setType("C");
					hs.update(CustParty);
					tx.commit();	
					request.setAttribute("CustParty",CustParty);
						return (mapping.findForward("view"));
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

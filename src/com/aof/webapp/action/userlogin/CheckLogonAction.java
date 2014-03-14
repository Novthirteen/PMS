/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.userlogin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.PartyKeys;
import com.aof.component.domain.party.UserLogin;
import com.aof.util.Constants;
import com.aof.webapp.action.BaseAction;

/**
 * @author xxp 
 * @version 2003-7-3
 *
 */
public class CheckLogonAction  extends BaseAction {
	public ActionForward perform(
			ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response)
			throws IOException, ServletException {
				
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		Logger log = Logger.getLogger(CheckLogonAction.class.getName());

		if(userLogin != null){
			String role = (String)request.getSession().getAttribute(Constants.USER_ROLE_KEY);
			log.info("user="+userLogin.getName()+" role="+role);
		
			if(role.equals(PartyKeys.SUPPLIER_ROLE_KEY)){ 
				return (mapping.findForward(PartyKeys.SUPPLIER_ROLE_KEY));
			}
			if(role.equals(PartyKeys.STORAGE_ROLE_KEY)){ 
				return (mapping.findForward(PartyKeys.STORAGE_ROLE_KEY));
			}
			if(role.equals(PartyKeys.SHIPPER_ROLE_KEY)){ 
				return (mapping.findForward(PartyKeys.SHIPPER_ROLE_KEY));
			}
			if(role.equals(PartyKeys.ORGANIZATION_UNIT_ROLE_KEY)){
				String siteRole = userLogin.getRole();
				if(siteRole!=null){
					return (mapping.findForward(siteRole)); 
				}else{
					return (mapping.findForward("EMPTY"));
				}			
			}else {
				return (mapping.findForward("failed")); 
			}		
		}else{
			return (mapping.findForward("failed")); 
		}
	}
}

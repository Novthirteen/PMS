//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.form.helpdesk;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.ActionType;
import com.aof.component.helpdesk.CallMaster;
import com.aof.component.helpdesk.ModifyLog;
import com.shcnc.struts.form.BeanActionForm;

/** 
 * MyEclipse Struts
 * Creation date: 11-13-2004
 * 
 * XDoclet definition:
 * @struts:form name="callActionTrackForm"
 */
public class CallActionTrackForm extends BeanActionForm {
 
  
	/** 
	 * Method validate
	 * @param mapping
	 * @param request
	 * @return ActionErrors
	 */
	public ActionErrors validate(
		ActionMapping mapping,
		HttpServletRequest request) {
		ActionErrors errors =new ActionErrors();
		errors=super.validate(mapping,request);
		return errors;
	}

}
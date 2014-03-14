//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.helpdesk.servicelevel.SLACategoryService;
import com.aof.component.helpdesk.servicelevel.SLAMaster;
import com.aof.component.helpdesk.servicelevel.SLAMasterService;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;

/** 
 * MyEclipse Struts
 * Creation date: 11-16-2004
 * 
 * XDoclet definition:
 * @struts:action validate="true"
 */
public class SLACategoryTreeDialogAction extends com.shcnc.struts.action.BaseAction {

    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Integer masterid = ActionUtils.parseInt(request.getParameter("masterid"));
        if (masterid == null) {
            String partyid = request.getParameter("partyid");
            SLAMaster master = new SLAMasterService().findActiveByPartyId(partyid);
            masterid = master.getId();
        }
    	request.setAttribute("X_xml", new SLACategoryService().getAllForMasterAsXml(masterid, getLocale(request)));
        return mapping.findForward("jsp");
    }

}
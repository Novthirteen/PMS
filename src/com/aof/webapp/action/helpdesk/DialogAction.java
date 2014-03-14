//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.webapp.action.BaseAction;

/** 
 * MyEclipse Struts
 * Creation date: 11-17-2004
 * 
 * XDoclet definition:
 * @struts:action validate="true"
 */
public class DialogAction extends com.shcnc.struts.action.BaseAction {

    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String realpath = request.getQueryString();
        request.setAttribute("X_realpath", realpath.substring(realpath.indexOf('&') + 1));
        request.setAttribute("X_title", request.getParameter("title"));
        return mapping.findForward("success");
    }

}
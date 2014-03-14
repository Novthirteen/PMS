/*
 * Created on 2004-12-3
 *
 */
package com.aof.webapp.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.tiles.TilesRequestProcessor;

/**
 * @author nicebean
 *
 */
public class SecureRequestProcessor extends TilesRequestProcessor {
    private SecureRequestProcessorHelper helper;
    
    public SecureRequestProcessor() {
        super();
        helper = new SecureRequestProcessorHelper();
    }

/*
    protected ActionForward processActionPerform(HttpServletRequest request, HttpServletResponse response, Action action, ActionForm form, ActionMapping mapping) throws IOException, ServletException {
        boolean logined = false;
        try {
            logined = helper.checkPermission(request, response, mapping);
        } catch (Exception e) {
            return super.processException(request, response, e, form, mapping);
        }
        if (logined) return super.processActionPerform(request, response, action, form, mapping);
        return mapping.findForward("logon");
    }
*/
    
    protected boolean processRoles(HttpServletRequest request, HttpServletResponse response, ActionMapping mapping) throws IOException, ServletException {
        if (!super.processRoles(request, response, mapping)) return false;
        
        boolean logined = false;

        try {
            logined = helper.checkPermission(request, response, mapping);
        } catch (Exception e) {
            processForwardConfig(request, response, processException(request, response, e, null, mapping));
            return false;
        }

        if (logined) return true;
            
        processForwardConfig(request, response, mapping.findForward("logon"));
        return false;
    }

/*
    protected boolean processInclude(HttpServletRequest request, HttpServletResponse response, ActionMapping mapping) throws IOException, ServletException {
        if (helper.checkPermission(request, response, mapping)) {
            return super.processInclude(request, response, mapping);
        } else {
            return false;
        }
    }
*/
}

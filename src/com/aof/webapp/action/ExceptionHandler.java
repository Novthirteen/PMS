/*
 * Created on 2004-11-16
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action;

import java.util.HashSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.Globals;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.config.ExceptionConfig;
import org.apache.struts.util.ModuleException;


/**
 * @author nicebean
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ExceptionHandler extends org.apache.struts.action.ExceptionHandler{
    private static HashSet setDialogAction = new HashSet();
    
    static {
        /* common */
        setDialogAction.add("/helpdesk.showDialog");
        setDialogAction.add("/helpdesk.confirmDeleteDialog");
        /* helpdesk service level master */
        setDialogAction.add("/helpdesk.editSLAMaster");
        setDialogAction.add("/helpdesk.updateSLAMaster");
        setDialogAction.add("/helpdesk.deleteSLAMaster");
        /* helpdesk service level category */
        setDialogAction.add("/helpdesk.newSLACategory");
        setDialogAction.add("/helpdesk.insertSLACategory");
        setDialogAction.add("/helpdesk.editSLACategory");
        setDialogAction.add("/helpdesk.updateSLACategory");
        setDialogAction.add("/helpdesk.deleteSLACategory");
        setDialogAction.add("/helpdesk.showSLACategoryTreeDialog");
        /* helpdesk service level priority */
        setDialogAction.add("/helpdesk.newSLAPriority");
        setDialogAction.add("/helpdesk.insertSLAPriority");
        setDialogAction.add("/helpdesk.editSLAPriority");
        setDialogAction.add("/helpdesk.updateSLAPriority");
        setDialogAction.add("/helpdesk.deleteSLAPriority");
        setDialogAction.add("/helpdesk.showSLAPriorityDialog");
        /* helpdesk knowledge base */
        setDialogAction.add("/helpdesk.deleteKnowledgeBase");
        /* helpdesk call action type*/
        setDialogAction.add("/helpdesk.newActionType");
        setDialogAction.add("/helpdesk.insertActionType");
        setDialogAction.add("/helpdesk.editActionType");
        setDialogAction.add("/helpdesk.updateActionType");
        /* helpdesk attachment */
        setDialogAction.add("/helpdesk.newAttachment");
        setDialogAction.add("/helpdesk.insertAttachment");
        setDialogAction.add("/helpdesk.deleteAttachment");
        setDialogAction.add("/helpdesk.listAttachment");
        /* helpdesk customer config table */
        setDialogAction.add("/helpdesk.editRow");
        setDialogAction.add("/helpdesk.newRow");
        setDialogAction.add("/helpdesk.updateRow");
        setDialogAction.add("/helpdesk.insertRow");
        setDialogAction.add("/helpdesk.listTable");
        setDialogAction.add("/helpdesk.newTable");
        setDialogAction.add("/helpdesk.insertTable");
        /* helpdesk load customer user */
        setDialogAction.add("/helpdesk.newUploadExcel");
        setDialogAction.add("/helpdesk.insertUploadExcel");
    }
    
    public ActionForward execute(Exception ex, ExceptionConfig ae, ActionMapping mapping, ActionForm formInstance,
            HttpServletRequest request, HttpServletResponse response) throws ServletException {

        ActionForward forward = null;
        ActionError error = null;
        
        if (ex instanceof ActionException) {
            ActionException e = (ActionException)ex;
            String key = e.getKey();
            Object values = e.getValues();
            if (values == null) {
                error = new ActionError(key);
            } else {
                error = new ActionError(key, (Object [])values);
            }
            ActionErrors errors = new ActionErrors();
            errors.add(ActionErrors.GLOBAL_ERROR, error);
            if ("request".equals(ae.getScope())){
                request.setAttribute(Globals.ERROR_KEY, errors);
            } else {
                request.getSession().setAttribute(Globals.ERROR_KEY, errors);
            }
            forward = mapping.getInputForward();
            if (forward == null || forward.getName() == null) {
                if (setDialogAction.contains(mapping.getPath())) {
                    forward = new ActionForward(ae.getPath());
                } else {
                    forward = mapping.findForward("failure");
                }
            }
        } else {
            request.setAttribute("X_exception", ex);
            if (setDialogAction.contains(mapping.getPath())) {
                forward = new ActionForward(ae.getPath());
            } else {
                forward = mapping.findForward("failure");
            }
        }

        return forward;
    }

}

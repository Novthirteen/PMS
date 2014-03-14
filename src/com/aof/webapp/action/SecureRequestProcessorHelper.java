/*
 * Created on 2004-12-3
 *
 */
package com.aof.webapp.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionMapping;

import com.aof.util.Constants;

/**
 * @author nicebean
 *
 */
public class SecureRequestProcessorHelper {
    
    public boolean checkPermission(HttpServletRequest request, HttpServletResponse response, ActionMapping mapping) {
        if (mapping instanceof SecureActionMapping) {
            SecureActionMapping secureMapping = (SecureActionMapping)mapping;
            String permission = secureMapping.getPermission();
            if (permission == null) return true;
            HttpSession session = request.getSession();
            if (session.getAttribute(Constants.USERLOGIN_KEY) == null) {
                return false;
            }
            List userPermission = (List)session.getAttribute(Constants.SECURITY_KEY);
            if (userPermission == null) {
                return false;
            }
            if (!userPermission.contains(permission)) {
                throw new ActionException("error.nopermission." + permission);
            }
        }
        return true;
    }
}

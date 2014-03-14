/*
 * Created on 2004-12-6
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.helpdesk;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.ActionMapping;

import com.aof.component.helpdesk.CallType;
import com.aof.component.helpdesk.CallTypeService;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.SecureActionMapping;

/**
 * @author shilei
 *
 * 
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ClosedPowerChecker {
	/*private static Map PERMISSION_MAP=new HashMap();
	static{
		PERMISSION_MAP.put("A","HELPDESK_CALL_CHANGE_CLOSED");
		PERMISSION_MAP.put("B","HELPDESK_CHANGE_REQUEST_CHANGE_CLOSED");
		PERMISSION_MAP.put("C","HELPDESK_COMPLAIN_CHANGE_CLOSED");
	}*/
	public static boolean checkChangeClosedPermission(HttpServletRequest request,String callType, ActionMapping mapping,String exception) throws HibernateException {
        if (mapping instanceof SecureActionMapping) {
            HttpSession session = request.getSession();
            if (session.getAttribute(Constants.USERLOGIN_KEY) == null) {
                return false;
            }
            List userPermission = (List)session.getAttribute(Constants.SECURITY_KEY);
            if (userPermission == null) {
                return false;
            }
            CallTypeService cts=new CallTypeService();
            CallType type=cts.find(callType);
            
            if(type==null)
            {
            	throw new RuntimeException("call type error");
            }
            final String permission="HELPDESK_"+type.getName().toUpperCase()+"_CHANGE_CLOSED";
            if (!userPermission.contains(permission)) {
                throw new ActionException(exception);
            }
  
            
        }
        return true;
    }
}

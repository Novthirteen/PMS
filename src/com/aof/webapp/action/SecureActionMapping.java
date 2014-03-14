/*
 * Created on 2004-12-3
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action;

import org.apache.struts.action.ActionMapping;

/**
 * @author nicebean
 *
 */
public class SecureActionMapping extends ActionMapping {
    private String permission;
    
    public SecureActionMapping() {
        super();
    }
    
    public String getPermission() {
        return permission;
    }
    
    public void setPermission(String permission) {
        this.permission = permission;
    }
}

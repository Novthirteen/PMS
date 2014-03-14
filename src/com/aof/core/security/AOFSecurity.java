/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.core.security;

import java.util.*;

import javax.servlet.http.HttpSession;

import com.aof.util.Constants;
   
/**
 * @author xxp 
 * @version 2003-6-24
 *
 */
public class AOFSecurity extends Security{


	protected AOFSecurity() {}
	public boolean hasEntityPermission(String entity, String action, HttpSession session) {
		List securityList = (List)session.getAttribute(Constants.SECURITY_KEY);
		Iterator it = securityList.iterator();
		while(it.hasNext()){
			if ( (entity+action).equals(it.next()) ){
				return true;
			}
		}
		return false;
	}
}

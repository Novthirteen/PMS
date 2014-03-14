/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action;

import java.util.*;

/**
 * @author xxp 
 * @version 2003-12-16
 *
 */
public class SiteDefs {
	static private Hashtable registry = new Hashtable();
	
	public static void Register(String name, Object aInstance) {
		registry.put(name, aInstance);
	}
	
	public static Object GetInstance(String name) {
		return LookUp(name);
	}
    
	protected static Object LookUp(String name) {
		if(registry.get(name)==null){
			registry.put(name,new ArrayList());
		}
		return registry.get(name);
	}
}
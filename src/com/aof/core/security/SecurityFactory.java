/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.core.security;

import org.apache.log4j.Logger;



/**
 * @author xxp 
 * @version 2003-6-24
 *
 */

public class SecurityFactory {
    
		protected static Logger log = Logger.getLogger(SecurityFactory.class.getName());
		public static final int AOFSecurity = 0;

		public static Security getInstance(int SecurityType ) throws SecurityConfigurationException {
			Security security = null;

			synchronized (SecurityFactory.class) {
				try {
					switch(SecurityType){
						case AOFSecurity:
							security = new AOFSecurity();
							break;	
						default:
							security = new AOFSecurity();
					}
					//ClassLoader loader = Thread.currentThread().getContextClassLoader();
					//Class c = loader.loadClass(getSecurityClass(securityName));
				} catch(Exception e){
					log.error("ERROR: get security instance failed.");
					e.printStackTrace();
				}
			}
			return security;
		}

	}


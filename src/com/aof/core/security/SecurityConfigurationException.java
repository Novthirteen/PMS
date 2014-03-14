/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.core.security;

/**
 * @author xxp 
 * @version 2003-6-24
 *
 */

public class SecurityConfigurationException extends Exception {

		public SecurityConfigurationException(String str, Throwable t) {
			super(str, t);
		}

		public SecurityConfigurationException(String str) {
			super(str);
		}

		public SecurityConfigurationException() {
			super();
		}
}

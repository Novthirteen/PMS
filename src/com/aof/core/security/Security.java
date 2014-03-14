/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.core.security;

import javax.servlet.http.HttpSession;

/**
 * @author xxp 
 * @version 2003-6-24
 *
 */
public abstract class Security {
	public abstract boolean hasEntityPermission(String entity, String action, HttpSession session);
}

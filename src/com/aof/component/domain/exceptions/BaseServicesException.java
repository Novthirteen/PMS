/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.exceptions;

import net.sf.hibernate.HibernateException;  

/**
 * @author xxp 
 * @version 2003-6-25
 *
 */
public class BaseServicesException extends HibernateException {

	/**
	 * @param arg0
	 *
	 */
	public BaseServicesException(Throwable arg0) {
		super(arg0);
	}

	/**
	 * @param arg0
	 * @param arg1
	 *
	 */
	public BaseServicesException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

	/**
	 * @param arg0
	 *
	 */
	public BaseServicesException(String arg0) {
		super(arg0);
	}

}

/*
 * Created on 2004-11-13
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form;

import org.apache.struts.action.ActionErrors;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface BaseFormInterface {
	public final static int TO_OBJECT = 0;
	public final static int TO_STRING = 1;
	public ActionErrors populate(Object bean, int mode) ;
	
}

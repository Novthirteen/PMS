/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action;


import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;

/**
 * @author xxp 
 * @version 2003-6-20
 *
 */
public class  ActionErrorLog {
	public void addGlobalError(ActionErrors errors,String msgError){
		errors.add(ActionErrors.GLOBAL_ERROR,new ActionError(msgError));
	}	

	public void addGlobalKAVError(ActionErrors errors,String msgKey,String msgValue){
		errors.add(ActionErrors.GLOBAL_ERROR,new ActionError(msgKey,msgValue));
	}
}

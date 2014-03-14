/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.aof.util.Constants;
import com.aof.util.PropertiesUtil;
import com.aof.webapp.action.BaseAction;
/**
 * @author Jeffrey Liang 
 * @version 2005-1-12
 *
 */
public class ReportBaseAction extends BaseAction {
	public String GetTemplateFolder() {
		Logger log = Logger.getLogger(ReportBaseAction.class.getName());
		String temppath = null;
		try {
			Properties prop = new Properties();
			prop.load(new FileInputStream(PropertiesUtil.getProperty("pasreport")));
			temppath = prop.getProperty("TEMPLATE_PATH");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return temppath;
	}
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
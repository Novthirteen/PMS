/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action;

import java.util.ArrayList;
import java.util.List;


/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class PageBean extends ComPageCtl {
	
	private List itemList = new ArrayList();

	/**
	 * @return
	 */
	public List getItemList() {
		return itemList;
	}

	/**
	 * @param list
	 */
	public void setItemList(List list) {
		itemList = list;
	}

}

//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.form.helpdesk;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 11-22-2004
 * 
 * XDoclet definition:
 * @struts:form name="rowForm"
 */
public class RowForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	// --------------------------------------------------------- Methods

	/** 
	 * Method validate
	 * @param mapping
	 * @param request
	 * @return ActionErrors
	 */
	public ActionErrors validate(
		ActionMapping mapping,
		HttpServletRequest request) {

		throw new UnsupportedOperationException(
			"Generated method 'validate(...)' not implemented.");
	}

	
	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		items.clear();
	}
	
	private Map items=new HashMap();
	
	public void setItems(String key,Object value)
	{
		items.put(key,value);
	}
	public Object getItems(String key)
	{
		return (String) items.get(key);
	}
	
	private String tableID;
	private String rowID;
	private boolean close=false;
	
	


	/**
	 * @return Returns the close.
	 */
	public boolean isCloseMe() {
		return close;
	}
	/**
	 * @param close The close to set.
	 */
	public void setCloseMe(boolean close) {
		this.close = close;
	}
	/**
	 * @return Returns the rowID.
	 */
	public String getRowID() {
		return rowID;
	}
	/**
	 * @param rowID The rowID to set.
	 */
	public void setRowID(String rowID) {
		this.rowID = rowID;
	}
	/**
	 * @return Returns the table.
	 */
	public String getTableID() {
		return tableID;
	}
	/**
	 * @param table The table to set.
	 */
	public void setTableID(String table) {
		this.tableID = table;
	}
	/**
	 * @return Returns the items.
	 */
	public Map getItemsMap() {
		return items;
	}
}
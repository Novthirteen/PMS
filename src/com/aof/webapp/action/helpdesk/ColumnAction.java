//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.helpdesk.CustConfigColumn;
import com.aof.component.helpdesk.CustConfigService;
import com.aof.component.helpdesk.CustConfigTable;
import com.aof.component.helpdesk.CustConfigTableType;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;

/** 
 * MyEclipse Struts
 * Creation date: 11-22-2004
 * 
 * XDoclet definition:
 * @struts:action parameter="insert"
 */
public class ColumnAction extends com.shcnc.struts.action.BaseAction {

	// --------------------------------------------------------- Instance Variables

	// --------------------------------------------------------- Methods

	/** 
	 * Method execute
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 * @throws HibernateException
	 */
	public ActionForward execute(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) throws HibernateException {
		final String action=mapping.getParameter();
		final String name=request.getParameter("name");
		final Integer tableTypeID=ActionUtils.parseInt(request.getParameter("tableType"));
		final Integer columnID=ActionUtils.parseInt(request.getParameter("column"));
		CustConfigService service=new CustConfigService();
		if(action.equals(INSERT))
		{
			/*CustConfigColumn column=new CustConfigColumn();
			CustConfigTableType tableType=service.getTableType(tableTypeID);
			column.setTableType(tableType);
			column.setName(name);
			service.insertColumn(column);*/
		}
		else if(action.equals(EDIT))
		{
			CustConfigColumn column=service.getColumn(columnID);
			request.setAttribute("column",column);
		}
		else if(action.equals(UPDATE))
		{
			CustConfigColumn column=service.getColumn(columnID);
			column.setName(name);
			service.updateColumn(column);
		}
		else if(action.equals(DELETE))
		{
			//service.deleteColumn(columnID);
		}
		return null;
	}

}
//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.helpdesk.CustConfigColumn;
import com.aof.component.helpdesk.CustConfigItem;
import com.aof.component.helpdesk.CustConfigItemKey;
import com.aof.component.helpdesk.CustConfigRow;
import com.aof.component.helpdesk.CustConfigService;
import com.aof.component.helpdesk.CustConfigTable;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.helpdesk.RowForm;

/** 
 * MyEclipse Struts
 * Creation date: 11-22-2004
 * 
 * XDoclet definition:
 * @struts:action path="/newRow" name="rowForm" parameter="new" scope="request"
 */
public class RowAction extends com.shcnc.struts.action.BaseAction {

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
		if(action.equals(EDIT))
		{
			return edit(mapping,form,request,response);
		}
		else if(action.equals(NEW))
		{
			return newRow(mapping,form,request,response);
		}
		else if(action.equals(INSERT))
		{
			return insert(mapping,form,request,response);
		}
		else if(action.equals(UPDATE))
		{
			return update(mapping,form,request,response);
		}
		else if(action.equals(DELETE))
		{
			return delete(mapping,form,request,response);
		}

		
		return null;
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws HibernateException {
		Integer rowID=ActionUtils.parseInt(request.getParameter("rowID"));
		if(rowID==null)
		{
			throw new ActionException(ActionUtils.ERROR_ID_INT,"rowID");
		}
		CustConfigService service=new CustConfigService();
		CustConfigRow row=service.getRow(rowID);
		if(row==null)
		{
			throw new ActionException(ActionUtils.ERROR_NOT_FOUND,"row("+rowID+")");
		}
		service.deleteRow(rowID);
		ActionForward forward=new ActionForward("/helpdesk.viewTable.do?table="+row.getTable().getId());
		forward.setRedirect(true);
		return forward;
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward update(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) 
		throws HibernateException {
		RowForm rowForm=(RowForm) form;
		//rowID
		final Integer rowID=ActionUtils.parseInt(rowForm.getRowID());
		if(rowID==null)
		{
			throw new ActionException(ActionUtils.ERROR_ID_INT,"rowID");
		}
		
		final CustConfigService service=new CustConfigService();
		//row
		final CustConfigRow row=service.getRow(rowID);
		if(row==null)
		{
			throw new ActionException(ActionUtils.ERROR_NOT_FOUND,"row("+rowID+")");
		}
		
		Iterator itor=rowForm.getItemsMap().keySet().iterator();
		while(itor.hasNext())
		{
			//columnID
			final Integer columnID=ActionUtils.parseInt((String) itor.next());
			if(columnID==null)
			{
				throw new ActionException(ActionUtils.ERROR_ID_INT,"columnID");
			}
			
			//column
			CustConfigColumn column=service.getColumn(columnID);
			if(column==null)
			{
				throw new ActionException(ActionUtils.ERROR_NOT_FOUND,"column("+columnID+")");
			}
			
			CustConfigItem item=(CustConfigItem) row.getItems().get(columnID);
			if(item==null)//new column
			{
				item=new CustConfigItem();
				item.setRow(row);
				item.setColumn(column);
				row.getItems().put(columnID,item);
			}
			final String value=(String) rowForm.getItems(columnID.toString());
			if(value!=null)
			{
				item.setContent(value);
			}
		}
		service.updateRow(row);
		if (rowForm.isCloseMe())
		{
			ActionForward forward=new ActionForward("/WEB-INF/jsp/helpdesk/table/closeDialog.jsp");
			//forward.setRedirect(true);
			return forward;
		}
		else
		{
			this.postGlobalMessage("helpdesk.row.update.success",request);
			ActionForward forward=new ActionForward("/helpdesk.editRow.do?rowID="+row.getId());
			//forward.setRedirect(true);
			return forward;
		}
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward insert(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws HibernateException {
		RowForm rowForm=(RowForm) form;
		
		Integer tableID=ActionUtils.parseInt(rowForm.getTableID());
		if(tableID==null)
		{
			throw new ActionException(ActionUtils.ERROR_ID_INT,"tableID");
		}
		
		CustConfigService service=new CustConfigService();
		
		
		CustConfigTable table=service.getTable(tableID);
		if(table==null)
		{
			throw new ActionException(ActionUtils.ERROR_NOT_FOUND,"table("+tableID+")");
		}
		
		CustConfigRow row=new CustConfigRow();
		row.setTable(table);
		Iterator itor=rowForm.getItemsMap().keySet().iterator();
		while(itor.hasNext())
		{
			
			final Integer columnID=ActionUtils.parseInt((String) itor.next());
			if(columnID==null)
			{
				throw new ActionException(ActionUtils.ERROR_ID_INT,"columnID");
			}
			
			CustConfigColumn column=service.getColumn(columnID);
			if(column==null)
			{
				throw new ActionException(ActionUtils.ERROR_NOT_FOUND,"column("+columnID+")");
			}
			
			CustConfigItem item=new CustConfigItem();
			item.setColumn(column);
			item.setRow(row);
			item.setContent((String)rowForm.getItems(columnID.toString()));
			row.getItems().put(columnID,item);
		}
		service.insertRow(row);
		if (rowForm.isCloseMe())
		{
			ActionForward forward=new ActionForward("/WEB-INF/jsp/helpdesk/table/closeDialog.jsp");
			//forward.setRedirect(true);
			return forward;
		}
		else
		{
			this.postGlobalMessage("helpdesk.row.insert.success",request);
			rowForm.reset(mapping,request);
			ActionForward forward=new ActionForward("/helpdesk.newRow.do?tableID="+table.getId());
			//forward.setRedirect(true);
			return forward;
		}
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward newRow(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws HibernateException {
		
		Integer tableID=ActionUtils.parseInt(request.getParameter("tableID"));
		if(tableID==null)
		{
			throw new ActionException(ActionUtils.ERROR_ID_INT,"tableID");
		}
		
		CustConfigService service=new CustConfigService();
		CustConfigTable table=service.getTable(tableID);
		if(table==null)
		{
			throw new ActionException(ActionUtils.ERROR_NOT_FOUND,"table("+tableID+")");
		}
		
		RowForm rowForm=(RowForm) this.getForm("/helpdesk.insertRow",request);
		rowForm.setTableID(tableID.toString());
		request.setAttribute("tableType",table.getTableType());
		
		return mapping.findForward("editPage");
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @throws HibernateException
	 */
	private ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws HibernateException {
		Integer rowID=ActionUtils.parseInt(request.getParameter("rowID"));
		if(rowID==null)
		{
			throw new ActionException(ActionUtils.ERROR_ID_INT,"rowID");
		}
		
		CustConfigService service=new CustConfigService();
		CustConfigRow row=service.getRow(rowID);
		if(row==null)
		{
			throw new ActionException(ActionUtils.ERROR_NOT_FOUND,"row("+rowID+")");
		}
		
		final RowForm rowForm=(RowForm) this.getForm("/helpdesk.updateRow",request);
		final Iterator itor=row.getItems().keySet().iterator();
		while(itor.hasNext())
		{
			Integer columnID=(Integer) itor.next();
			CustConfigItem item=(CustConfigItem) row.getItems().get(columnID);
			rowForm.setItems(columnID.toString(),item.getContent());
		}
		rowForm.setTableID(row.getTable().getId().toString());
		rowForm.setRowID(rowID.toString());
		request.setAttribute("tableType",row.getTable().getTableType());
		return mapping.findForward("editPage");
	}

	

}









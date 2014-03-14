//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.aof.component.helpdesk.CallActionHistory;
import com.aof.component.helpdesk.CallActionTrackService;
import com.aof.component.helpdesk.CallService;
import com.aof.component.helpdesk.CustConfigColumn;
import com.aof.component.helpdesk.CustConfigTableType;
import com.aof.component.helpdesk.CustConfigTableTypeService;
import com.aof.component.helpdesk.StatusTypeService;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.helpdesk.CallQueryForm;
import com.aof.webapp.form.helpdesk.RowForm;
import com.aof.webapp.form.helpdesk.TableTypeForm;
import com.aof.webapp.form.helpdesk.TableTypeQueryForm;
import com.shcnc.struts.form.BeanActionForm;
import com.shcnc.struts.form.DateFormatter;
import com.shcnc.utils.UUID;

/** 
 * MyEclipse Struts
 * Creation date: 11-25-2004
 * 
 * XDoclet definition:
 * @struts:action parameter="edit" scope="request"
 * @struts:action-forward name="editPage" path="/WEB-INF/jsp/table/editTableType.jsp"
 */
public class TableTypeAction extends com.shcnc.struts.action.BaseAction {

	// --------------------------------------------------------- Instance Variables

	// --------------------------------------------------------- Methods
	
	private final static String LIST_PAGE="listPage";
	private final static String EDIT_PAGE="editPage";
	private final static String ACTION_TABLE_TYPE_LIST="/helpdesk.listTableType";
	private final static String ACTION_TABLE_TYPE_UPDATE="/helpdesk.updateTableType";
	private final static String ACTION_TABLE_TYPE_INSERT="/helpdesk.insertTableType";
	private final static String ACTION_TABLE_TYPE_NEW="/helpdesk.newTableType";
	private final static String ACTION_TABLE_TYPE_EDIT="/helpdesk.editTableType";
	private final static String RESULTS="results";
	private final static String ID="id";
	
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
		final String para=mapping.getParameter();
		if (para.equals(LIST)) {
			return listTableType(mapping,form,request);
		}
		else if(para.equals(EDIT)) {
			return editTableType(mapping,request);
		}
		else if(para.equals(NEW))
		{
			return newTableType(mapping);
		}
		else if(para.equals(INSERT))
		{
			return insertTableType(form,request);
		}
		else if(para.equals(UPDATE))
		{
			return updateTableType(mapping,form,request);
		}
		
		else {
			throw new UnsupportedOperationException(
				"Generated method 'execute(...)' not implemented.");
		}
	}
	
	private ActionForward listTableType(ActionMapping mapping,ActionForm form,HttpServletRequest request) throws HibernateException {
		CustConfigTableTypeService service=new CustConfigTableTypeService();
		final TableTypeQueryForm queryForm=(TableTypeQueryForm) form;
		final Map map=this.getQueryMap(queryForm);
		final int pageNo=ActionUtils.parseInt(queryForm.getPageNo()).intValue();
		final int pageSize=ActionUtils.parseInt(queryForm.getPageSize()).intValue();
		final Integer integerCount=ActionUtils.parseInt(queryForm.getCount());
		if (integerCount==null)
		{
			if(pageNo!=0)throw new RuntimeException("count must have been computed when not first page");
			//compute count
			final int count=service.getCount(map);
			queryForm.setCount(String.valueOf(count));
		}
		final List resultList=service.findTableType(map,pageNo,pageSize);
		request.setAttribute(RESULTS,resultList);
		return  mapping.findForward(LIST_PAGE);
	}
	
	private Map getQueryMap(TableTypeQueryForm queryForm) {
		final Map map=new HashMap();
		//company
		final String desc=queryForm.getDesc().trim();
		if(desc!=null && !desc.equals(""))
		{
			map.put(CustConfigTableTypeService.QUERY_CONDITION_DESC,desc);
		}
		map.put(CustConfigTableTypeService.QUERY_CONDITION_DISABLED,queryForm.getDisabledTableType());
		return map;
	}
	
	private ActionForward newTableType(ActionMapping mapping) {
		return mapping.findForward(EDIT_PAGE);
	}
	
	private ActionForward editTableType(ActionMapping mapping,  HttpServletRequest request) 	throws HibernateException {
		
		final TableTypeForm tableTypeForm=(TableTypeForm) this.getForm(ACTION_TABLE_TYPE_UPDATE,request);
		Integer tableTypeID=ActionUtils.parseInt(request.getParameter("id"));
		if(tableTypeID==null)
		{
			throw new ActionException("helpdesk.custconfig.tabletype.error.notabletypeid");
		}
		CustConfigTableTypeService service=new CustConfigTableTypeService();
		CustConfigTableType tableType=service.getTableType(tableTypeID);
		if(tableType==null)
		{
			throw new ActionException("helpdesk.custconfig.tabletype.error.cannotfindtabletype");
		}
		tableTypeForm.setId(tableType.getId().toString());
		tableTypeForm.setName(tableType.getName());
		tableTypeForm.setDisabled(tableType.getDisabled().booleanValue());
		if (tableType.getModifyLog()!=null) {
			tableTypeForm.setCreateUser(tableType.getModifyLog().getCreateUser().getName());
			tableTypeForm.setModifyUser(tableType.getModifyLog().getModifyUser().getName());
			DateFormatter dateFormatter=new DateFormatter(java.util.Date.class);
			tableTypeForm.setCreateDate(dateFormatter.format(tableType.getModifyLog().getCreateDate()));
			tableTypeForm.setModifyDate(dateFormatter.format(tableType.getModifyLog().getModifyDate()));	
		}
		
		Iterator iter=tableType.getColumns().iterator();
		int index=0;
		while (iter.hasNext()) {
			CustConfigColumn column=(CustConfigColumn) iter.next();
			tableTypeForm.setColumns(index++,column.getName());
		}
		
		return mapping.findForward(EDIT_PAGE);
	}
	
	private ActionForward insertTableType(ActionForm form,	HttpServletRequest request) throws HibernateException {
		CustConfigTableTypeService service=new CustConfigTableTypeService();
		CustConfigTableType tableType=new CustConfigTableType();
		TableTypeForm tableTypeForm=(TableTypeForm)form;
		tableType.setName(tableTypeForm.getName().trim());
		tableType.setDisabled(new Boolean(tableTypeForm.getDisabled()));
		tableType.getModifyLog().setCreateUser(ActionUtils.getCurrentUser(request));
		tableType.getModifyLog().setModifyUser(ActionUtils.getCurrentUser(request));
		Iterator iter=tableTypeForm.getColumnList().iterator();
		List newColumns=new ArrayList();
		int index=0;
		while (iter.hasNext()) {
			String columnName=((String)iter.next()).trim();
			if (columnName.length()!=0) {
				CustConfigColumn column=new CustConfigColumn();
				column.setName(columnName);
				column.setType(new Integer(1));
				column.setIndex(new Integer(index++));
				column.setTableType(tableType);
				newColumns.add(column);
			}
		}
		tableType.setColumns(newColumns);
		service.insertTableType(tableType);
		ActionForward forward=new ActionForward(ACTION_TABLE_TYPE_EDIT+".do?id="+tableType.getId());
		forward.setRedirect(true);
		return forward;
	}
	
	private ActionForward updateTableType(ActionMapping mapping, ActionForm form,	HttpServletRequest request) throws HibernateException {
		CustConfigTableTypeService service=new CustConfigTableTypeService();
		TableTypeForm tableTypeForm=(TableTypeForm)form;
		
		if (this.isCancelled(request)){
			ActionForward forward=new ActionForward(ACTION_TABLE_TYPE_EDIT+".do?id="+tableTypeForm.getId());
			forward.setRedirect(true);
			return forward;
			
	  }
		
		Iterator iterForm=tableTypeForm.getColumnList().iterator();
		List newColumns=new ArrayList();
		int newIndex=0,oldIndex=0;
		Session sess = service.getSession(); 
		Transaction tx = null;
		try {
			tx = sess.beginTransaction();
			CustConfigTableType tableType=new CustConfigTableType();
			tableType=service.getTableType(new Integer(tableTypeForm.getId()),sess);
			tableType.setName(tableTypeForm.getName().trim());
			tableType.setDisabled(new Boolean(tableTypeForm.getDisabled()));
			tableType.getModifyLog().setModifyUser(ActionUtils.getCurrentUser(request));
			List oldColumns=tableType.getColumns();
			//oldColumns.clear();
			while (iterForm.hasNext()) {
				String columnName=((String)iterForm.next()).trim();
				if (columnName.length()!=0) {
					CustConfigColumn column=null;
					if (oldColumns.size()>oldIndex) {
						column=(CustConfigColumn) oldColumns.get(oldIndex);
					} else {
						column=new CustConfigColumn();
						column.setType(new Integer(1));
						column.setTableType(tableType);
					}
					column.setName(columnName);
					column.setIndex(new Integer(newIndex++));
					newColumns.add(column);
				} else {
					if (oldColumns.size()>oldIndex) {
						CustConfigColumn column=(CustConfigColumn)oldColumns.get(oldIndex);
						service.deleteColumn(column.getId(),sess);
					}
				}
				oldIndex++;
			}
			oldColumns.clear();
			Iterator itNew=newColumns.iterator();
			while (itNew.hasNext()) {
				oldColumns.add(itNew.next());
			}
			//tableType.setColumns(newColumns);
			service.updateTableType(tableType,sess);
			
			tx.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (tx != null) {
				tx.rollback();
			}
			throw e; 
		} finally {
			service.closeSession(); 
		}
		ActionForward forward=new ActionForward(ACTION_TABLE_TYPE_EDIT+".do?id="+tableTypeForm.getId());
		forward.setRedirect(true);
		return forward;

	}
}
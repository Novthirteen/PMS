//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import java.io.FileInputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.CallActionHistory;
import com.aof.component.helpdesk.CallActionTrackService;
import com.aof.component.helpdesk.CallMaster;
import com.aof.component.helpdesk.CallService;
import com.aof.component.helpdesk.CallType;
import com.aof.component.helpdesk.CallTypeService;
import com.aof.component.helpdesk.ProblemTypeService;
import com.aof.component.helpdesk.RequestTypeService;
import com.aof.component.helpdesk.StatusTypeService;
import com.aof.component.helpdesk.servicelevel.SLACategory;
import com.aof.component.helpdesk.servicelevel.SLACategoryService;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.prm.report.ReportBaseAction;
import com.aof.webapp.form.helpdesk.CallQueryForm;
import com.shcnc.struts.form.BeanActionForm;
import com.shcnc.struts.form.Formatter;
import com.shcnc.utils.UUID;

/**
 * MyEclipse Struts Creation date: 11-12-2004
 * 
 * XDoclet definition:
 * 
 * @struts:action parameter="new"
 */
public class CallAction extends com.shcnc.struts.action.BaseAction {

	// --------------------------------------------------------- Instance
	// Variables

	// --------------------------------------------------------- Methods

	/**
	 * Method execute
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 * @throws Exception
	 */
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		final String para = mapping.getParameter();

		if (para.equals(EDIT)) {
			return edit(mapping, form, request, response);
		} else if (para.equals(NEW)) {
			return newCall(mapping, form, request, response);
		} else if (para.equals(QUERY)) {
			return query(mapping, form, request, response);
		} else if (para.equals(FIND)) {
			return find(mapping, form, request, response);
		} else if (para.equals(INSERT)) {
			return insert(mapping, form, request, response);
		} else if (para.equals(UPDATE)) {
			return update(mapping, form, request, response);
		} else if (para.equals("report")) {
			return report(mapping, form, request, response);
		} else {
			throw new UnsupportedOperationException();
		}
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	private ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws SQLException, Exception {
		BeanActionForm callForm = (BeanActionForm) form;
		CallService service = new CallService();
		CallMaster call = service.find(ActionUtils.parseInt((String) callForm
				.get("callID")));
		if (call == null) {
			throw new ActionException("helpdesk.call.oldcall.notexist");
		}
		if (StatusTypeService.hasClosed(call)) {
			ClosedPowerChecker.checkChangeClosedPermission(request, call
					.getType().getType(), mapping,
					"error.nopermission.HELPDESK_CALL_CHANGE_CLOSED");
		}
		callForm.populate(call, BeanActionForm.TO_BEAN);
		call.getModifyLog().setModifyUser(ActionUtils.getCurrentUser(request));
		service.update(call);

		// the attribute is set in editCall.do
		request.getSession().removeAttribute(HISTORY_LIST + call.getCallID());
		return this.getEditCallForward(call);
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	private ActionForward insert(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws SQLException, Exception {
		BeanActionForm callForm = (BeanActionForm) form;
		CallMaster call = new CallMaster();
		callForm.populate(call, BeanActionForm.TO_BEAN);
		call.getModifyLog().setModifyUser(ActionUtils.getCurrentUser(request));
		call.getModifyLog().setCreateUser(ActionUtils.getCurrentUser(request));

		call.setType(new CallTypeService().getCallTypeByActionPath(mapping
				.getPath()));
		CallService service = new CallService();
		service.insert(call);
		return this.getEditCallForward(call);
	}

	/**
	 * @return
	 */
	private ActionForward getEditCallForward(final CallMaster call) {
		// final ActionForward forward=new ActionForward(
		// ACTION_EDIT+call.getType().getName()+".do?"+
		// CALL_ID+"="+call.getCallID());
		final ActionForward forward = new ActionForward("helpdesk.new"
				+ call.getType().getName() + "ActionTrack.do?callId="
				+ call.getCallID().toString());
		forward.setRedirect(true);
		return forward;
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */

	private ActionForward find(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		final CallQueryForm queryForm = (CallQueryForm) form;
		final CallService service = new CallService();
		final Map map = this.getQueryMap(queryForm);

		final int pageNo = ActionUtils.parseInt(queryForm.getPageNo())
				.intValue();
		final int pageSize = ActionUtils.parseInt(queryForm.getPageSize())
				.intValue();
		final Integer integerCount = ActionUtils.parseInt(queryForm.getCount());
		if (integerCount == null) {
			if (pageNo != 0)
				throw new RuntimeException(
						"count must have beean computed when not first page");
			// compute count
			final int count = service.getCount(map);
			// final int pageCount=(count-1)/pageSize+1;
			queryForm.setCount(String.valueOf(count));
			// queryForm.setPageCount(String.valueOf(pageCount));
		}
		String order = queryForm.getOrder();
		if (order.equals("call.priority")) {
			if (!this.getLocale(request).getLanguage().equals("en")) {
				order += ".engDesc";
			} else {
				order += ".chsDesc";
			}
		}/*
			 * else if(order.equals("call.assignedUser.name")) {
			 * order="'a'+"+order; }
			 */

		final List resultList = service.findCall(map, pageNo, pageSize, order,
				queryForm.isDescend(),false);
		Iterator itor = resultList.iterator();
		while (itor.hasNext()) {
			CallMaster call = (CallMaster) itor.next();
			this.processLocale(this.getLocale(request), call);
		}
		request.setAttribute(RESULTS, resultList);
		if (resultList.isEmpty()) {
			this.postGlobalMessage("helpdesk.call.not.found", request);
		}
		return mapping.getInputForward();
	}

	/**
	 * @param form
	 * @return
	 */
	private Map getQueryMap(CallQueryForm queryForm) {
		final Map map = new HashMap();
		// company
		final String companyID = queryForm.getCompany_id();
		if (companyID != null && !companyID.trim().equals("")) {
			map.put(CallService.QUERY_CONDITION_COMPANY_ID, companyID);
		} else if (!queryForm.getCompany_name().trim().equals("")) {
			map.put(CallService.QUERY_CONDITION_COMPANY, queryForm
					.getCompany_name().trim());
		}
		// contact
		final String contactID = (queryForm.getContact_id());
		if (contactID != null && !contactID.trim().equals("")) {
			map.put(CallService.QUERY_CONDITION_CONTACT_ID, contactID);
		} else if (!queryForm.getContact_name().trim().equals("")) {
			map.put(CallService.QUERY_CONDITION_CONTACT, queryForm
					.getContact_name().trim());
		}
		// status
		map.put(CallService.QUERY_CONDITION_STATUS, ActionUtils
				.parseInt(queryForm.getStatus()));
		// party_id
		map.put(CallService.QUERY_CONDITION_PARTY, queryForm.getParty_id());
		// user_id
		map.put(CallService.QUERY_CONDITION_USER, queryForm.getUser_id());
		// callid
		map.put(CallService.QUERY_CONDITION_TICKETNO, queryForm.getTicketNo());
		// requestType
		String fullPath = null;
		Integer slcid = ActionUtils.parseInt(queryForm.getRequestType_id());
		if (slcid != null) {
			SLACategoryService service = new SLACategoryService();
			SLACategory sc = service.find(slcid);
			if (sc != null)
				fullPath = sc.getFullPath();
		}
		map.put(CallService.QUERY_CONDITION_REQUESTTYPE, fullPath);
		// priority
		map.put(CallService.QUERY_CONDITION_PRIORITY, ActionUtils
				.parseInt(queryForm.getPriority_id()));

		// calltype
		map.put(CallService.QUERY_CONDITION_TYPE, queryForm.getCallType());

		// response
		map.put(CallService.QUERY_CONDITION_RESPONSE, ActionUtils
				.parseInt(queryForm.getResponseHour()));

		// solve
		map.put(CallService.QUERY_CONDITION_SOLVE, ActionUtils
				.parseInt(queryForm.getSolveHour()));

		// close
		map.put(CallService.QUERY_CONDITION_CLOSE, ActionUtils
				.parseInt(queryForm.getCloseHour()));

		map.put(CallService.QUERY_CONDITION_REQUESTTYPE2, ActionUtils
				.parseInt(queryForm.getRequestType2()));

		// problemtype
		map.put(CallService.QUERY_CONDITION_PROBLEMTYPE, ActionUtils
				.parseInt(queryForm.getProblemType()));

		if (queryForm.getRequestDate1().trim().length() != 0) {
			Formatter formatter = Formatter.getFormatter(java.util.Date.class);
			map.put(CallService.QUERY_CONDITION_REQUESTDATE1, formatter
					.unformat(queryForm.getRequestDate1().trim()));
		}

		if (queryForm.getRequestDate2().trim().length() != 0) {
			Formatter formatter = Formatter.getFormatter(java.util.Date.class);
			map.put(CallService.QUERY_CONDITION_REQUESTDATE2, formatter
					.unformat(queryForm.getRequestDate2().trim()));
		}

		return map;
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws HibernateException
	 */

	private ActionForward query(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws HibernateException {
		// use defalt pageSize
		CallQueryForm queryForm = (CallQueryForm) this.getForm(
				"/helpdesk.findCall", request);
		String strCallType = request.getParameter("callType");
		CallTypeService callTypeService = new CallTypeService();
		CallType callType = null;
		if (strCallType == null) {
			callType = callTypeService.getDefaultCallType();
		} else {
			callType = callTypeService.find(strCallType);
		}
		queryForm.setCallType(strCallType);
		queryForm.setPageSize("10");
		queryForm.setOrder("call.contactInfo.companyName");
		queryForm.setDescend(true);
		List statusTypes = null;
		StatusTypeService statusTypeService = new StatusTypeService();
		statusTypes = statusTypeService.listStatusType(callType);
		request.getSession().setAttribute("queryCall_statusTypes", statusTypes);
		request.getSession().setAttribute("queryCall_callTypeList",
				callTypeService.listCallType());

		RequestTypeService rts = new RequestTypeService();
		request.getSession().setAttribute("queryCall_requestTypeList",
				rts.listAllEnabledByCallType(callType));

		ProblemTypeService pts = new ProblemTypeService();
		request.getSession().setAttribute("queryCall_problemTypeList",
				pts.list());

		return mapping.findForward(QUERY_PAGE);
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws HibernateException
	 */
	private ActionForward newCall(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws HibernateException {
		BeanActionForm callForm = (BeanActionForm) this.getForm(ACTION_UPDATE,
				request);
		CallMaster call = new CallMaster();
		call.setAcceptedDate(new Date());
		call.setAttachGroupID(UUID.getUUID());

		UserLogin user = (UserLogin) request.getSession().getAttribute(
				Constants.USERLOGIN_KEY);
		call.setAssignedUser(user);
		call.setAssignedParty(user.getParty());
		call.setType(new CallTypeService().getCallTypeByActionPath(mapping
				.getPath()));
		call.setStatus(new StatusTypeService().getDefaultStatusType(call
				.getType()));
		call.setRequestType2(new RequestTypeService()
				.getDefaultRequestType(call.getType()));
		call.setProblemType(new ProblemTypeService().getDefaultProblemType());

		callForm.populate(call);

		prepareCombo(request, call);
		request.setAttribute("buttonEnabled", Boolean.TRUE);
		return mapping.findForward(EDIT_PAGE);
	}

	private void prepareCombo(HttpServletRequest request, CallMaster call)
			throws HibernateException {
		RequestTypeService rts = new RequestTypeService();
		List requestTypeList = rts.listAllEnabledByCallType(call.getType());
		request.getSession().setAttribute(
				"requestTypeList" + call.getType().getType(), requestTypeList);

		ProblemTypeService pts = new ProblemTypeService();
		List problemTypeList = pts.list();
		request.getSession().setAttribute("problemTypeList", problemTypeList);
		/*
		 * List statusTypes=null; StatusTypeService statusTypeService=new
		 * StatusTypeService();
		 * statusTypes=statusTypeService.listStatusType(call.getType());
		 * request.getSession().setAttribute("statusTypes"+call.getType().getType(),statusTypes);
		 */
	}

	private void processLocale(Locale locale, CallMaster call) throws Exception {
		SLACategoryService slaService = new SLACategoryService();
		call.getRequestType().setEngDesc(
				slaService.getPathDesc(call.getRequestType(), locale));
		if (!locale.getLanguage().equals("en")) {
			call.getPriority().setEngDesc(call.getPriority().getChsDesc());
		}
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	private ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		final String ticketNo = request.getParameter("ticketNo");
		CallService service = new CallService();
		CallMaster call = null;
		if (ticketNo != null) {
			if (ticketNo.trim().length() == 0) {
				throw new ActionException(ActionUtils.ERROR_NOT_FOUND, CALL);
			}
			call = service.getCallByTicketNo(ticketNo);
			if (call == null) {
				throw new ActionException(ActionUtils.ERROR_NOT_FOUND, CALL);
			}
			return this.getEditCallForward(call);
		} else {
			Integer callID = ActionUtils
					.parseInt(request.getParameter(CALL_ID));
			if (callID == null) {
				throw new ActionException(ActionUtils.ERROR_ID_INT, CALL_ID);
			}

			call = service.find(callID);
		}
		if (call == null) {
			throw new ActionException(ActionUtils.ERROR_NOT_FOUND, CALL);
		}
		this.processLocale(this.getLocale(request), call);
		BeanActionForm callForm = (BeanActionForm) this.getForm(ACTION_UPDATE,
				request);

		ActionErrors errors = callForm.populate(call);
		if (!errors.isEmpty()) {
			this.saveErrors(request, errors);
			return mapping.getInputForward();
		}

		prepareCombo(request, call);

		List historyList = service.listHistory(call.getCallID());
		request.getSession().setAttribute(HISTORY_LIST + call.getCallID(),
				historyList);
		Boolean buttonEnabled = Boolean.TRUE;
		if (StatusTypeService.hasClosed(call)) {
			try {
				ClosedPowerChecker.checkChangeClosedPermission(request, call
						.getType().getType(), mapping,
						"error.nopermission.HELPDESK_CALL_CHANGE_CLOSED");
			} catch (ActionException e) {
				buttonEnabled = Boolean.FALSE;
			}
		}
		request.setAttribute("buttonEnabled", buttonEnabled);
		return mapping.findForward(EDIT_PAGE);
	}

	/**
	 * Create Call Report
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	private ActionForward report(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		final CallQueryForm queryForm = (CallQueryForm) form;
		final CallService service = new CallService();
		final Map map = this.getQueryMap(queryForm);

		final int pageNo = ActionUtils.parseInt(queryForm.getPageNo())
				.intValue();
		final int pageSize = ActionUtils.parseInt(REPORT_SIZE).intValue();// set
																			// default
																			// report
																			// page
																			// size
		final Integer integerCount = ActionUtils.parseInt(queryForm.getCount());

		String order = "";
		boolean isDesc;
		isDesc = queryForm.isDescend();
		if (request.getParameter("grp_by_asnee") != null) {
			order = "call.assignedUser.name";
			isDesc = false;
		} else {
			order = "call.contactInfo.companyName";
		}

		String issue = request.getParameter("issue");
		if(issue==null)
			issue= "";
		boolean byCategory = false;
		if(!issue.equalsIgnoreCase(""))
			byCategory = true;

		final List resultList = service.findCall(map, pageNo, pageSize, order,
				isDesc,byCategory);
		Iterator itor = resultList.iterator();
		while (itor.hasNext()) {
			CallMaster call = (CallMaster) itor.next();
			this.processLocale(this.getLocale(request), call);
		}
		request.setAttribute(RESULTS, resultList);

		return exportToExcel(resultList, request, response);
	}

	/**
	 * export result to excel file
	 * 
	 * @param resultList
	 * @param request
	 * @param response
	 * @return
	 */
	private ActionForward exportToExcel(List resultList,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			CallActionTrackService CAService = new CallActionTrackService();
			ReportBaseAction rptBaseAction = new ReportBaseAction();
			String TemplatePath = rptBaseAction.GetTemplateFolder();
			String flag = request.getParameter("allday");
			if(flag==null)
				flag = "";
			String issue = request.getParameter("issue");
			if(issue==null)
				issue= "";
			// Start to output the excel file
			response.reset();

			// when selecting group by assignee , use "weekly report" file name
			if(!issue.equalsIgnoreCase(""))
			{
				response.setHeader("Content-Disposition",
						"attachment;filename=\"" + SaveToFileName3 + "\"");				
			}
			else{
				if (request.getParameter("grp_by_asnee") == null) {
					response.setHeader("Content-Disposition",
							"attachment;filename=\"" + SaveToFileName1 + "\"");
				} else {
					response.setHeader("Content-Disposition",
							"attachment;filename=\"" + SaveToFileName2 + "\"");
				}				
			}

			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			// when selecting group by assignee , use "weekly report" template
			HSSFWorkbook wb = null;
			
			if(!issue.equalsIgnoreCase(""))
			{
				wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
						+ ExcelTemplate3));
			}
			else{
				if (request.getParameter("grp_by_asnee") == null) {
					wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
							+ ExcelTemplate1));
				} else {
					wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
							+ ExcelTemplate2));
				}				
			}
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			if (TemplatePath == null)
				return null;

			HSSFRow HRow = null;
			HSSFCell cell = null;
			int ExcelRow = ListStartRow;
			SimpleDateFormat date_formatter = new SimpleDateFormat("yyyy-MM-dd");

			// List for CMHistory Track
			List CAList = null;
			CallActionHistory CAObject = null;

			int colnum = 0; // cell number
			if(!issue.equalsIgnoreCase("")) //export QAD Service Line issue log
			{
				ExcelRow = 3;
				HSSFCellStyle textstyle = sheet.getRow((short)0).getCell((short)0).getCellStyle();
				HSSFCellStyle numberstyle = sheet.getRow((short)0).getCell((short)5).getCellStyle();
				HSSFCellStyle actionstyle = sheet.getRow((short)0).getCell((short)9).getCellStyle();
				
				for(int row = 0; row < resultList.size(); row++)
				{
					CallMaster CMObject = (CallMaster) resultList.get(row);
					/* List for CallMaster History Track */
					CAList = CAService.listActionTrack(CMObject.getCallID());

					HRow = sheet.createRow(ExcelRow);
					//start date
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(textstyle);
					cell.setCellValue(date_formatter.format(CMObject.getModifyLog().getCreateDate()));
					
					//raiser
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(textstyle);
					cell.setCellValue(CMObject.getModifyLog().getCreateUser().getName());
					//assginer
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(textstyle);
					cell.setCellValue(CMObject.getAssignedUser().getName());
					//description
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(textstyle);
					cell.setCellValue(CMObject.getDesc());
					//problem type
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(textstyle);
					cell.setCellValue(CMObject.getRequestType().getEngDesc());
					
					colnum = 6;
					//days not closed
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(numberstyle);
					Date from = CMObject.getModifyLog().getCreateDate();
					Date to = CMObject.getClosedDate();
					if(to==null)
						to = new Date();
					cell.setCellValue(UtilDateTime.getDiffWorkingDate(from ,to));					
					//expected close date
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(textstyle);
					cell.setCellValue(CMObject.getTargetClosedDate());
					//status
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(textstyle);
					cell.setCellValue(CMObject.getStatus().getDesc());
					//act close date
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(textstyle);
					if(CMObject.getClosedDate()!=null)
						cell.setCellValue(date_formatter.format(CMObject.getClosedDate()));
					else
						cell.setCellValue("N/A");
						
					//action done-solution
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(actionstyle);
					from = null;
					if((CAList==null)||(CAList.size()==0))
						cell.setCellValue("N/A");				
					else
					{
						for (int i = 0; i < CAList.size(); i++) {
							CAObject = (CallActionHistory) CAList.get(i);
							if (CAObject.getCallMaster().getCallID().equals(
									CMObject.getCallID())) {
								cell.setCellValue(CAObject.getDesc());
								if((from==null)||CAObject.getDate().after(from))
									from = CAObject.getDate();
							}
						}						
					}
					
					colnum = 5;
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(numberstyle);
					to = CMObject.getClosedDate();
					if(to==null)
						to = new Date();
					if(from==null)
						cell.setCellValue("N/A");
					else
						cell.setCellValue(UtilDateTime.getDiffWorkingDate(from ,to));					
					

					// reset the column number
					colnum = 0;
					ExcelRow++;
				}
				
				sheet = wb.getSheet(FormSheetName2);
				CallService service = new CallService();
				List ctgyList = service.getSLACategory();
				ExcelRow = 0;//
				Iterator it = resultList.iterator();
				Iterator itctgy = ctgyList.iterator();
				int ctgy = 0;
				int offset = 0;
				if(itctgy.hasNext())
					ctgy = ((SLACategory)itctgy.next()).getId().intValue();
				
				String customer = "";
				int longest = 0;
				int tot = 0;
				int totOutstanding = 0;
				int row = 0;
				while(it.hasNext())
				{
					int column = 0;//change
					CallMaster CMObject = (CallMaster) it.next();
					CAList = CAService.listActionTrack(CMObject.getCallID());
					if(CMObject.getCompany().getPartyId().equalsIgnoreCase(customer))
					{
						if(CMObject.getRequestType().getId().intValue()==ctgy)
						{
							tot +=1;
							int off = UtilDateTime.getDiffWorkingDate(CMObject.getModifyLog().getCreateDate(),new Date());
							if(off>5)//one week
							{
								totOutstanding +=1;
								if(off>longest)
									longest = off;
							}
						}
//						if(CMObject.getRequestType().getId().intValue()==ctgy)
						else
						{
							//set cells
							longest = 0;
							tot = 0;
							totOutstanding = 0;
							if(itctgy.hasNext())
								ctgy = ((SLACategory)itctgy.next()).getId().intValue();
							
						}

						
					}

					
					
				}

			}
			else
			{				
				HSSFCellStyle normalTextStyle;
				HSSFCellStyle normalNumberStyle;
				HSSFCellStyle invisibleStyle;
				HSSFCellStyle dateStyle;

				if (request.getParameter("grp_by_asnee") != null) {
					dateStyle = sheet.getRow(ListStartRow).getCell((short) 2)
							.getCellStyle();
				} else {
					dateStyle = sheet.getRow(ListStartRow).getCell((short) 1)
							.getCellStyle();
				}

				normalTextStyle = sheet.getRow(ListStartRow).getCell((short) 0)
						.getCellStyle();
				normalNumberStyle = sheet.getRow(ListStartRow).getCell((short) 27)
						.getCellStyle();
				invisibleStyle = sheet.getRow(ListStartRow).getCell((short) 31)
						.getCellStyle();

				for (int row = 0; row < resultList.size(); row++) {
					CallMaster CMObject = (CallMaster) resultList.get(row);
					/* List for CallMaster History Track */
					CAList = CAService.listActionTrack(CMObject.getCallID());

					HRow = sheet.createRow(ExcelRow);

					// another type of report , group by assignee
					if (request.getParameter("grp_by_asnee") != null) {
						// Assignee
						cell = HRow.createCell((short) colnum++);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);
						cell.setCellStyle(normalTextStyle);
						cell.setCellValue(CMObject.getAssignedUser().getName());
					}

					// Customer
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getContactInfo().getCompanyName());

					// Customer request date
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(dateStyle);
					cell.setCellValue(CMObject.getAcceptedDate());

					// Create User
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getModifyLog().getCreateUser()
							.getName());

					// Call Number
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getTicketNo());

					// Email
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getContactInfo().getEmail());

					// Contact Number
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getContactInfo().getTeleCode());

					// Customer Caller Name
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getContactInfo().getContactName());

					// Subject
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getSubject());

					// whether ever notify customer ?
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getNotifyCustomer());

					// Symptom
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getDesc());

					// Body
					/*
					 * cell = HRow.createCell((short)6);
					 * cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					 * cell.setCellStyle(normalTextStyle);
					 * cell.setCellValue(CMObject.getDesc());
					 */

					// Solution
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					if ((CMObject.getStatus().getDesc().equalsIgnoreCase("solve"))
							|| (CMObject.getStatus().getDesc().equalsIgnoreCase("close"))) {// status is Solved & Closed
						for (int i = 0; i < CAList.size(); i++) {
							CAObject = (CallActionHistory) CAList.get(i);
							if (CAObject.getCallMaster().getCallID().equals(
									CMObject.getCallID())
									&& ((CMObject.getStatus().getDesc().equalsIgnoreCase("solve"))
											|| (CMObject.getStatus().getDesc().equalsIgnoreCase("close")))) {
								cell.setCellValue(CAObject.getDesc());
							}
						}
					} else
						cell.setCellValue("N/A");

					// Category
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getRequestType().getEngDesc());

					// Type
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getProblemType().getDesc());

					// if there is no assignee at the first column , it appears here
					if (request.getParameter("grp_by_asnee") == null) {
						// Assignee
						cell = HRow.createCell((short) colnum++);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellStyle(normalTextStyle);
						cell.setCellValue(CMObject.getAssignedUser().getName());
					}

					// Reply Date
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(dateStyle);
					if (CMObject.getResponseDate() != null) {
						cell.setCellValue(CMObject.getResponseDate());
					}

					// Solved By
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					if (CMObject.getSolveUser() != null)
						cell.setCellValue(CMObject.getSolveUser().getName());

					// Date Solved
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(dateStyle);
					if (CMObject.getSolvedDate() != null) {
						cell.setCellValue(CMObject.getSolvedDate());
					}

					// Status
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getStatus().getDesc());

					// Confirmed By
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					if ((CMObject.getStatus().getDesc().equalsIgnoreCase("solve"))
							|| (CMObject.getStatus().getDesc().equalsIgnoreCase("close"))) {// status
																					// is
																					// Solved
																					// &
																					// Closed
						for (int i = 0; i < CAList.size(); i++) {
							CAObject = (CallActionHistory) CAList.get(i);
							if ((CMObject.getStatus().getDesc().equalsIgnoreCase("solve"))
									|| (CMObject.getStatus().getDesc().equalsIgnoreCase("close"))) {
								cell.setCellValue(CAObject.getSubject());
							}
						}
					} else
						cell.setCellValue("N/A");

					// Priority
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getPriority().getDesc());

					// Response Duration
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					if ((flag != null) && (flag.equalsIgnoreCase("y")))
						cell.setCellValue(this.getAllDiffHour(CMObject
								.getResponseDate(), CMObject.getAcceptedDate()));
					else
						cell.setCellValue(getDiffHour(CMObject.getResponseDate(),
								CMObject.getAcceptedDate()));

					// Missed SLA Response
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					if ((flag != null) && (flag.equalsIgnoreCase("y")))
						cell.setCellValue(this.getAllDiffHour(CMObject
								.getResponseDate(), CMObject
								.getTargetResponseDate()));
					else
						cell.setCellValue(getDiffHour(CMObject.getResponseDate(),
								CMObject.getTargetResponseDate()));

					// Solve Duration
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					if ((flag != null) && (flag.equalsIgnoreCase("y")))
						cell.setCellValue(this.getAllDiffHour(CMObject
								.getSolvedDate(), CMObject.getAcceptedDate()));
					else
						cell.setCellValue(getDiffHour(CMObject.getSolvedDate(),
								CMObject.getAcceptedDate()));

					// Missed SLA Solve
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					if ((flag != null) && (flag.equalsIgnoreCase("y")))
						cell.setCellValue(this.getAllDiffHour(CMObject
								.getSolvedDate(), CMObject.getTargetSolvedDate()));
					else
						cell.setCellValue(getDiffHour(CMObject.getSolvedDate(),
								CMObject.getTargetSolvedDate()));

					// Close Duration
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					if ((flag != null) && (flag.equalsIgnoreCase("y")))
						cell.setCellValue(this.getAllDiffHour(CMObject
								.getClosedDate(), CMObject.getAcceptedDate()));
					else
						cell.setCellValue(getDiffHour(CMObject.getClosedDate(),
								CMObject.getAcceptedDate()));

					// Closed Date
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(dateStyle);
					if (CMObject.getClosedDate() != null) {
						cell.setCellValue(CMObject.getClosedDate());
					}

					// Missed SLA Close
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					if ((flag != null) && (flag.equalsIgnoreCase("y")))
						cell.setCellValue(this.getAllDiffHour(CMObject
								.getClosedDate(), CMObject.getTargetClosedDate()));
					else
						cell.setCellValue(getDiffHour(CMObject.getClosedDate(),
								CMObject.getTargetClosedDate()));

					// Total Time
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalNumberStyle);
					cell.setCellValue(CMObject.getSumCost());

					// Status
					// cell = HRow.createCell((short)22);
					// cell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					// cell.setCellStyle(normalTextStyle);
					// cell.setCellValue(CMObject.getStatus().getDesc());

					// Request Type
					cell = HRow.createCell((short) colnum++);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellStyle(normalTextStyle);
					cell.setCellValue(CMObject.getRequestType2().getDescription());

					// Escalated
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					// if (CMObject.getEscalated() != null) {
					// cell.setCellValue(CMObject.getEscalated());
					// } else {
					// cell.setCellValue("N");
					// }
					if (CMObject.getAssignedUser().getUserLoginId().equals(
							"QAD-001")) {
						cell.setCellValue("Y");
					} else {
						cell.setCellValue("N");
					}

					// Re-Assigned
					cell = HRow.createCell((short) colnum++);
					cell.setCellStyle(normalTextStyle);
					if (CMObject.getReAssigned() != null) {
						cell.setCellValue(CMObject.getReAssigned());
					} else {
						cell.setCellValue("N");
					}

					// days outstanding. duration from customers' creating time to
					// now
					// cell = HRow.createCell((short)colnum++);
					// cell.setCellStyle(invisibleStyle);
					// cell.setCellValue(getDiffHour(new Date(),
					// CMObject.getAcceptedDate()));
					cell = HRow.createCell((short) colnum++);
					// cell.setEncoding(HSSFCell.ENCODING_UTF_16);
					// cell.setCellStyle(normalTextStyle);
					String sloveDuration = getDiffHour(CMObject.getSolvedDate(),
							CMObject.getAcceptedDate());
					String closeDuration = getDiffHour(CMObject.getClosedDate(),
							CMObject.getAcceptedDate());
					if (sloveDuration.equals("N/A") || closeDuration.equals("N/A")) {
						cell.setCellValue("");
					} else {
						if ((flag != null) && (flag.equalsIgnoreCase("y")))
						{
							cell.setCellValue((CMObject.getClosedDate().getTime()-CMObject.getSolvedDate().getTime())/1000/3600);
						}
						else{
							cell.setCellValue(Long.parseLong(closeDuration)
									- Long.parseLong(sloveDuration));						
						}
						// cell.setCellValue(String.valueOf((CMObject.getClosedDate().getTime()-CMObject.getSolvedDate().getTime())/1000/3600));
					}

					// reset the column number
					colnum = 0;
					ExcelRow++;					
				}
			}


			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus(HttpServletResponse.SC_OK);
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private String getDiffHour(Date srcdate, Date targetDate)
			throws SQLException {
		if (targetDate == null || srcdate == null) {
			return "N/A";
		} else {
			long now = new Date().getTime();
			if (srcdate != null)
				now = srcdate.getTime();
			long targetTime = targetDate.getTime();
			if (now <= targetTime) {
				return "N/A";
			} else {
				// Modification : addition of code , by Bill Yu , 2005/11/21
				SQLExecutor sqlExec = new SQLExecutor(Persistencer
						.getSQLExecutorConnection(EntityUtil
								.getConnectionByName("jdbc/aofdb")));

				SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");

				StringBuffer statement = new StringBuffer("");
				statement.append("	select count(*)	as freeDays");
				statement.append("	from proj_calendar	");
				statement.append("	where convert(varchar(10),PC_Date,(126))>'"
						+ formater.format(targetDate) + "'	");
				statement.append("	and   convert(varchar(10),PC_Date,(126))<'"
						+ formater.format(srcdate) + "'	");
				statement.append("	and   PC_Hours=0	");
				ResultSet rs = sqlExec.runQueryStreamResults(statement
						.toString());
				rs.next();

				// free days (weekends or public holidays)
				int freeDays = rs.getInt("freeDays");

				sqlExec.closeConnection();

				int accross_hours = (int) ((now - targetTime) / 1000 / 3600);
				// System.out.println("Accross_hours:"+accross_hours);
				// System.out.println("FreeDays:"+freeDays);

				// 9 hours a working day , 15 free hours
				int accross_days = 0;
				accross_days = accross_hours / 24;
				int scattered_hours = 0;
				scattered_hours = accross_hours % 24;

				// sum of days needed to be subtracted(only free hours which is
				// 15)
				int substractedDays = 0;
				substractedDays = accross_days;
				if (scattered_hours > 9) {
					substractedDays++;
				}
				// System.out.println("SubstractedDays:"+substractedDays);

				// replace code below : modification by Bill Yu , 2005/11/21
				// previous caculated hours should be substracted with free days
				// and free hours in a day
				// return String.valueOf((now-targetTime)/1000/3600);
				// System.out.println("Result:"+String.valueOf((now-targetTime)/1000/3600-freeDays*24-(substractedDays-freeDays)*15));
				// System.out.println("");
				// long result =
				// (now-targetTime)/1000/3600-freeDays*24-(substractedDays-freeDays)*15;
				return String.valueOf((now - targetTime) / 1000 / 3600
						- freeDays * 24 - (substractedDays - freeDays) * 15);
				// Modification ends
			}
		}
	}

	private String getAllDiffHour(Date srcdate, Date targetDate)
			throws SQLException {
		if (targetDate == null || srcdate == null) {
			return "N/A";
		} else {
			long now = new Date().getTime();
			if (srcdate != null)
				now = srcdate.getTime();
			long targetTime = targetDate.getTime();
			if (now <= targetTime) {
				return "N/A";
			} else {
				return String.valueOf((now - targetTime) / 1000 / 3600);
			}
		}
	}

	private final static String EDIT_PAGE = "editPage";

	private final static String ACTION = "action";

	private final static String ACTION_UPDATE = "/helpdesk.updateCall";

	private final static String ACTION_INSERT = "/helpdesk.insertCall";

	private final static String ACTION_EDIT = "/helpdesk.edit";

	private final static String ATTACH_GROUP_ID = "attachGroupID";

	private final static String HISTORY_LIST = "historyList";

	private final static String CALL_ID = "id";

	private final static String CALL = "call";

	private final static String QUERY_PAGE = "queryPage";

	private final static String RESULTS = "results";

	private final static String REPORT_SIZE = "10000";

	private final static String ExcelTemplate1 = "MonthlyReport.xls";

	private final static String ExcelTemplate2 = "Weekly Report.xls";

	private final static String ExcelTemplate3 = "ServiceLineIssueLog.xls";

	private final static String FormSheetName = "Form";

	private final static String FormSheetName2 = "Project information";

	private final static String SaveToFileName1 = "MonthlyReport.xls";

	private final static String SaveToFileName2 = "Weekly Report.xls";

	private final static String SaveToFileName3 = "ServiceLineIssueLog.xls";

	private final int ListStartRow = 12;
}
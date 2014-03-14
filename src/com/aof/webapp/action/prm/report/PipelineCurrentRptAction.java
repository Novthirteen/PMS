/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.bid.BidUnweightedValue;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.GeneralException;

/**
 * 
 * @author Stanley
 * @version 2005-9-27
 */
public class PipelineCurrentRptAction extends ReportBaseAction {

	private Log log = LogFactory.getLog(ARAgingRptAction.class);
	private String nowyear = null;

	Hashtable hash;
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();

		String action = request.getParameter("formAction");
		if (action == null)
			action = "";
		try {
			UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			PartyHelper helper = new PartyHelper();
			List list = helper.getAllSubPartysByPartyId(Hibernate2Session.currentSession(),ul.getParty().getPartyId());
			list.add(0,ul.getParty());
			request.setAttribute("PartyList", list);

			if ("QueryForList".equals(action)) {
				request.setAttribute("QryList", findQueryList(Hibernate2Session.currentSession(),request));
			}
			if ("ExportToExcel".equals(action)) {

				ActionErrors error = this.getActionErrors(request.getSession());
				if (!error.empty()) {
					saveErrors(request, error);
					return null;
				}
				return ExportToExcel(mapping, request, response,list);
			}

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
		return (mapping.findForward("success"));

	}

	private List findQueryList(Session hs,HttpServletRequest request) throws HibernateException,
			GeneralException {
		String department = request.getParameter("department");
		String salesman = request.getParameter("hid_id");
		String salesname = request.getParameter("sales");
		String year = request.getParameter("year");
		String persontype = request.getParameter("persontype"); 
		if(persontype == null)
			persontype = "0";
//		int month = Integer.parseInt(request.getParameter("month"));
//		if(month==12){
//			year = String.valueOf(Integer.parseInt(year)+1);
//			month =1;
//		}
		request.setAttribute("pipeYear",new Integer(year));
		String viewType = request.getParameter("viewType");
		String wonFlag = request.getParameter("wonFlag");
		String zeroFlag = request.getParameter("zeroFlag");
		
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);	
		
		List templist = new ArrayList();
		if(!department.equalsIgnoreCase("-1"))
		{
			PartyHelper helper = new PartyHelper();
			templist = helper.getAllSubPartysByPartyId(Hibernate2Session.currentSession(),department);
			Party p = (Party)hs.load(Party.class,department);
			templist.add(0,p);
		}

		List partyList = templist;

		String PartyListStr = "";
		int mark = 0;
		// List partyList_dep = null;
		if (!department.trim().equals("-1")) {
			// partyList_dep = ph.getAllSubPartysByPartyId(session, department);
			Iterator itdep = partyList.iterator();
			PartyListStr = "'" + department + "',";
			while (itdep.hasNext()) {
				Party p = (Party) itdep.next();
				if (mark == 0) {
					PartyListStr = PartyListStr + "'" + p.getPartyId() + "'";
					mark++;
				} else
					PartyListStr = PartyListStr + ", '" + p.getPartyId() + "'";
			}
		}

		String statement = "select bm  from BidMaster as bm left join bm.currentStep as curr where bm.id in (select un.bid_no from BidUnweightedValue as un "
				+ " where un.year='" + year + "') and bm.status <> 'lost/drop' and bm.status <> 'Deleted'";
		if ((salesman != null) && (salesman.length() > 1)) {
			statement += " and (bm.salesPerson.userLoginId ='" + salesman
					+ "' or bm.SecondarySalesPerson.userLoginId='" + salesman + "') ";
		}
		if (department.trim().equals("-1") || (year.trim().equals(""))) {
			statement += " and (bm.salesPerson.userLoginId ='" + ul.getUserLoginId()
					+ "' or bm.SecondarySalesPerson.userLoginId='" + ul.getUserLoginId() + "') ";
		} else if (viewType.equals("sales")) {
			if (partyList.size() == 0) {
				statement += " and bm.salesPerson.party.partyId in ('" + department + "') ";
			} else if (partyList.size() > 0) {
				statement += " and bm.salesPerson.party.partyId in (" + PartyListStr + ") ";
			}
		} else if (viewType.equals("bid")) {
			if (partyList.size() == 0) {
				statement += " and bm.department  in ('" + department + "')";
			} else if (partyList.size() > 0) {
				statement += " and bm.department  in (" + PartyListStr + ")";
			}
		}
		if(!persontype.equalsIgnoreCase("0"))
		{
			if(persontype.equalsIgnoreCase("1"))
				statement += " and bm.salesPerson.party.isSales = 'Y'";
			else if(persontype.equalsIgnoreCase("2"))
				statement += " and bm.salesPerson.party.isSales = 'N'";
		}
		if (wonFlag == null || !(wonFlag.equals("y"))) {
			statement += " and (curr.percentage <> '100' or curr is null)";
		}
		if (zeroFlag == null || !(zeroFlag.equals("y"))) {
			statement += " and (curr.percentage <> '0' )";
		}
		statement += " order by bm.department.partyId,bm.salesPerson.userLoginId,bm.estimateStartDate asc";
		Query q = session.createQuery(statement);
		List list = q.list();
		/*
		 * statement = "select un from BidUnweightedValue as un where un.year='" +
		 * year + "'";
		 */statement = "select un from BidUnweightedValue as un where un.year='" + year + "'";
		q = session.createQuery(statement);
		List unlist = q.list();
		hash = new Hashtable();
		for (int i = 0; i < unlist.size(); i++) {
			BidUnweightedValue un = (BidUnweightedValue) unlist.get(i);
			if (hash.get(un.getBid_no()) == null) {
				hash.put(un.getBid_no(), un);
			}
		}
		String nowdate = DateFormat.getDateInstance().format(Calendar.getInstance().getTime());
		StringTokenizer st = new StringTokenizer(nowdate, "-");
		String tempyear = st.nextToken();
		if (!tempyear.equalsIgnoreCase(year))
			nowyear = year;
		request.setAttribute("hash", hash);
		request.setAttribute("department", department);
		request.setAttribute("sales", salesman);
		request.setAttribute("salesname", salesname);
		return list;
	}

	private ActionForward ExportToExcel(ActionMapping mapping, HttpServletRequest request,
			HttpServletResponse response,List list) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				System.out.println("error");
				return null;
			}
			List sr = findQueryList(Hibernate2Session.currentSession(),request);
			Hashtable hash = this.hash;
			if (sr == null || sr.size() <= 0)
				return null;
			if ((hash.size() == 0) || (hash == null))
				return null;

			int ListStartRow = 0;
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) {
				System.out.println("file not found!");
				return null;
			}
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
					+ ExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);
			HSSFCell cell = null;
			HSSFCellStyle formularstyle = sheet.getRow(8).getCell((short) 26).getCellStyle();
			HSSFCellStyle totalstyle = sheet.getRow(6).getCell((short) 8).getCellStyle();

			HSSFCellStyle blodTextFormatStyle = sheet.getRow(8).getCell((short) 1).getCellStyle();
			HSSFCellStyle numberTextFormatStyle = sheet.getRow(8).getCell((short) 8).getCellStyle();
			HSSFCellStyle depttitlestyle = sheet.getRow(7).getCell((short) 1).getCellStyle();
			HSSFCellStyle othertitlestyle = sheet.getRow(7).getCell((short) 8).getCellStyle();
			HSSFCellStyle headerstyle = sheet.getRow(0).getCell((short) 1).getCellStyle();
			if (sheet == null) {
				System.out.println("sheet not found!");
				return null;
			}
			HSSFRow HRow = null;
			// Header
			cell = sheet.getRow(0).getCell((short) 1);
			Calendar calendar = Calendar.getInstance();
			calendar.clear();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			String now = formatter.format(Calendar.getInstance().getTime());
			StringTokenizer st = new StringTokenizer(now, "-");
			int year = Integer.parseInt(st.nextToken());
			cell.setCellValue("PipeLine Report");

			// cell.setCellValue("haha");

			// List
			NumberFormat numFormat = NumberFormat.getInstance();
			numFormat.setMaximumFractionDigits(0);
			numFormat.setMinimumFractionDigits(0);
			numFormat.setGroupingUsed(false);
			String NowDept = "";
			int ExcelRow = 7;
			
			int queryYear = Integer.parseInt(request.getParameter("year"));
			int queryMonth = Integer.parseInt(request.getParameter("month"));

			calendar.set(queryYear,queryMonth-1,1);
			Date nowDate = calendar.getTime();

			cell = sheet.getRow(1).getCell((short) 1);
			cell.setCellStyle(headerstyle);
			cell.setCellValue(queryYear);

			double tcv = 0;
			double tyunw = 0;
			double tyw = 0;
			double[] total = new double[12];
			double dtcv = 0;
			double dtyunw = 0;
			double dtyw = 0;
			double[] dtotal = new double[12];
			boolean mark = false;
			int deprow = 0;

			for (int row = 0; row < sr.size(); row++) {

				BidMaster bm = (BidMaster) sr.get(row);
				BidUnweightedValue un = (BidUnweightedValue) hash.get(bm.getId().toString().trim());
				if (!bm.getDepartment().getPartyId().trim().equals(NowDept)) {
					if (mark) {
						HRow = sheet.createRow(deprow);
						cell = HRow.createCell((short) 8);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
						cell.setCellStyle(othertitlestyle);
						cell.setCellValue(dtcv);
						dtcv = 0;
						cell = HRow.createCell((short) 9);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
						cell.setCellStyle(othertitlestyle);
						cell.setCellValue(dtyunw);
						dtyunw = 0;
						cell = HRow.createCell((short) 13);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
						cell.setCellStyle(othertitlestyle);
						cell.setCellValue(dtyw);
						dtyw = 0;
						for (int i = 0; i < 12; i++) {
							cell = HRow.createCell((short) (i + 14));
							cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
							cell.setCellStyle(othertitlestyle);
							cell.setCellValue(dtotal[i]);
							dtotal[i] = 0;
						}
					}
					mark = true;
					deprow = ExcelRow;// department row to set department
					// total
					NowDept = bm.getDepartment().getPartyId().trim();
					HRow = sheet.createRow(ExcelRow);
					cell = HRow.createCell((short) 1);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(depttitlestyle);
					cell.setCellValue(bm.getDepartmentName());
					for (int n = 2; n < 30; n++) {
						cell = HRow.createCell((short) n);
						cell.setCellStyle(othertitlestyle);
					}
					ExcelRow += 1;
				}
				if (bm.getDepartment().getPartyId().trim().equalsIgnoreCase(NowDept)) {
					calendar = Calendar.getInstance();
					String slmanager = null;
					Query query = Hibernate2Session.currentSession().createQuery(
							"from UserLogin as ul where ul.party.partyId=? and ul.type=?");
					query.setString(0, bm.getDepartment().getPartyId());
					query.setString(1, "SLMANAGER");
					List partyList = query.list();
					if ((partyList != null && (partyList.size() > 0)))
						slmanager = ((UserLogin) partyList.get(0)).getName();
					
					//
					calendar.set(queryYear, 11, 31);
					Date thisyearEnd = calendar.getTime();
					 calendar.set(queryYear, 0, 1);
					Date thisyearStart = calendar.getTime();

					 if(nowDate.after(thisyearStart)&&nowDate.before(thisyearEnd))
					 	thisyearStart = nowDate;

					java.util.Date startDate = bm.getEstimateStartDate();
					java.util.Date endDate = bm.getEstimateEndDate();
					int totalMonth = 0;
					 year = endDate.getYear() - startDate.getYear();
					if (year < 1) {
						totalMonth = endDate.getMonth() - startDate.getMonth();
					} else {
						totalMonth = endDate.getMonth() - startDate.getMonth()
								+ year * 12;
					}
					if (totalMonth < 1)
						totalMonth = 1;
					int thisYearStartMonth = 0;
					int thisYearEndMonth = 0;

					if (endDate.before(thisyearEnd)&&endDate.after(thisyearStart)) {
						thisYearEndMonth = endDate.getMonth();
					} 
					else
						thisYearEndMonth = thisyearEnd.getMonth();
						
					if (startDate.after(thisyearStart)&&startDate.before(thisyearEnd)) {
						thisYearStartMonth = startDate.getMonth();
					} else {
						thisYearStartMonth = thisyearStart.getMonth();
						if(endDate.before(thisyearStart))
							thisYearEndMonth = thisYearStartMonth;
					}
						
					int thisYearMonth = thisYearEndMonth - thisYearStartMonth
							+ 1;
					if (thisYearMonth < 1)
						thisYearMonth = 1;
					double thisYearUnW;
					if(un!=null){
					thisYearUnW =Math.round( un.getValue().doubleValue()/1000);}
					else{
					thisYearUnW = Math.round((thisYearMonth
							/ new Double(totalMonth).doubleValue()
							* bm.getEstimateAmount().doubleValue())/1000);
							}
					double weightedThisYear = 0;
					if (bm.getPercentage() != null
							&& !bm.getPercentage().trim().equals("")) {
						weightedThisYear = Math.round(thisYearUnW
								* ((new Double(bm.getPercentage())).intValue())
								/ 100);

					}
					int startMonth = thisYearStartMonth+1;
					int endMonth = thisYearEndMonth+1;
					double amountPerMonth = Math.round(weightedThisYear / thisYearMonth);

					HRow = sheet.createRow(ExcelRow);

					cell = HRow.createCell((short) 1);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue(bm.getProspectCompany().getDescription());
					cell = HRow.createCell((short) 2);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue(bm.getProspectCompany().getIndustry().getDescription());
					cell = HRow.createCell((short) 3);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue(bm.getProspectCompany().getAccount().getDescription());
					cell = HRow.createCell((short) 4);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue(bm.getDescription());
					cell = HRow.createCell((short) 5);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue("CSI-ITCons");
					cell = HRow.createCell((short) 6);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue(bm.getContractType());
					cell = HRow.createCell((short) 7);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue(bm.getNo());
					cell = HRow.createCell((short) 8);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(numberTextFormatStyle);
					cell.setCellValue(Math.round(bm.getEstimateAmount().doubleValue() / 1000));
					tcv += bm.getEstimateAmount().doubleValue() / 1000;
					dtcv += bm.getEstimateAmount().doubleValue() / 1000;
					cell = HRow.createCell((short) 9);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(numberTextFormatStyle);
					cell.setCellValue(thisYearUnW);
					tyunw += thisYearUnW;
					dtyunw += thisYearUnW;
					cell = HRow.createCell((short) 10);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					if ((bm.getPercentage() == null) || (bm.getPercentage().length() <= 0))
						cell.setCellValue("0%");
					else
						cell.setCellValue(bm.getPercentage() + "%");

					cell = HRow.createCell((short) 11);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue(bm.getEstimateStartDate().toString());
					cell = HRow.createCell((short) 12);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue(bm.getEstimateEndDate().toString());
					cell = HRow.createCell((short) 13);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(numberTextFormatStyle);
					cell.setCellValue(weightedThisYear);
					tyw += weightedThisYear;
					dtyw += weightedThisYear;
					for (int m = 14; m < 26; m++) {
						int month = m - 13;
						if (month >= startMonth && month <= endMonth && (amountPerMonth!=0)) {
							cell = HRow.createCell((short) m);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
							cell.setCellStyle(numberTextFormatStyle);
							cell.setCellValue(amountPerMonth);
							total[month - 1] += amountPerMonth;
							dtotal[month - 1] += amountPerMonth;
						} else {
							cell = HRow.createCell((short) m);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
							cell.setCellStyle(numberTextFormatStyle);
							cell.setCellValue("");
						}
					}
					cell = HRow.createCell((short) 26);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(formularstyle);

					cell = HRow.createCell((short) 27);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					if ((bm.getSalesPerson() != null) && (bm.getSalesPerson().getName() != null))
						cell.setCellValue(bm.getSalesPerson().getName());
					cell = HRow.createCell((short) 28);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					cell.setCellValue(slmanager);
					cell = HRow.createCell((short) 29);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
					cell.setCellStyle(blodTextFormatStyle);
					if ((bm.getSecondarySalesPerson() != null)
							&& (bm.getSecondarySalesPerson().getName() != null)) {
						cell.setCellValue(bm.getSecondarySalesPerson().getName());
					}

				}

				ExcelRow++;
			}
			HRow = sheet.createRow(deprow);
			cell = HRow.createCell((short) 8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
			cell.setCellStyle(othertitlestyle);
			cell.setCellValue(dtcv);
			dtcv = 0;
			cell = HRow.createCell((short) 9);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
			cell.setCellStyle(othertitlestyle);
			cell.setCellValue(dtyunw);
			dtyunw = 0;
			cell = HRow.createCell((short) 13);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
			cell.setCellStyle(othertitlestyle);
			cell.setCellValue(dtyw);
			dtyw = 0;
			for (int i = 0; i < 12; i++) {
				cell = HRow.createCell((short) (i + 14));
				cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
				cell.setCellStyle(othertitlestyle);
				cell.setCellValue(dtotal[i]);
				dtotal[i] = 0;
			}
			HRow = sheet.createRow(6);
			cell = HRow.createCell((short) 8);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
			cell.setCellValue(tcv);
			cell.setCellStyle(totalstyle);
			cell = HRow.createCell((short) 9);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
			cell.setCellValue(tyunw);
			cell.setCellStyle(totalstyle);
			cell = HRow.createCell((short) 13);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16); // 设置cell编码解决中文高位字节截断
			cell.setCellValue(tyw);
			cell.setCellStyle(totalstyle);
			for (int i = 0; i < 12; i++) {
				cell = HRow.createCell((short) (i + 14));
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(total[i]);
				cell.setCellStyle(totalstyle);
			}
			calendar.clear();

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

	/*
	 * private final static String ExcelTemplate = "test.xls";
	 * 
	 * private final static String FormSheetName = "test";
	 * 
	 * private final static String SaveToFileName = "test.xls";
	 */private final static String ExcelTemplate = "pipeLineCurrentRpt.xls";

	private final static String FormSheetName = "SalesPipeline";

	private final static String SaveToFileName = "SalesPipelineRpt.xls";

}

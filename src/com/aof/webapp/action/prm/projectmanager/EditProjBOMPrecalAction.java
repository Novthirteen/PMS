package com.aof.webapp.action.prm.projectmanager;

import java.io.FileInputStream;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.project.ProjPlanBOMST;
import com.aof.component.prm.project.ProjPlanBomMaster;
import com.aof.component.prm.project.ProjPlanType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.project.EditContractProjectAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;

public class EditProjBOMPrecalAction extends ReportBaseAction {

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		Logger log = Logger.getLogger(EditContractProjectAction.class.getName());
		String action = request.getParameter("formAction");
		String masterId = request.getParameter("masterId");

		if (action == null || action.equals("")) {
			action = "view";
		}

		log.info("action=" + action);

		try {

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();

			ProjPlanBomMaster master = null;

			if ((masterId != null) && (masterId.length() > 0)) {
				StringTokenizer st = new StringTokenizer(masterId, ".");
				masterId = st.nextToken();
				master = (ProjPlanBomMaster) hs.load(ProjPlanBomMaster.class, new Long(masterId));
			}

			if (action.equals("update")) {

				String[] stId = request.getParameterValues("stId");
				String[] indirRate = request.getParameterValues("indirRate");
				String[] nhrRev = request.getParameterValues("nhrRevenue");
				String[] sc = request.getParameterValues("csc");

				if (stId != null) {
					int size = stId.length;
					for (int i = 0; i < size; i++) {

						ProjPlanType projType = (ProjPlanType) hs.load(ProjPlanType.class, Long
								.valueOf(stId[i]));

						projType.setIndirectRate(Double.parseDouble(UtilString.removeSymbol(
								indirRate[i], ',')));
						projType.setNhrRevenue(Double.parseDouble(UtilString.removeSymbol(
								nhrRev[i], ',')));
						projType.setCodingSubContr(Double.parseDouble(UtilString.removeSymbol(
								sc[i], ',')));

						hs.save(projType);
						hs.flush();
						tx.commit();
					}
				}
				request.setAttribute("actionFlag", "update");
			}

			if (action.equals("view") || action.equals("update")) {

				List stList = findSTList(hs, master.getBom_id().longValue());

				List valueList = precal(stList);

				request.setAttribute("masterId", masterId);
				request.setAttribute("stList", stList);
				request.setAttribute("valueList", valueList);

				return mapping.findForward("view");
			}

			if (action.equals("export")) {

				List stList = findSTList(hs, master.getBom_id().longValue());

				List valueList = precal(stList);

				return export(master, valueList, stList, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return mapping.findForward("view");
	}

	private List findSTList(Session hs, long masterId) {

		List resultlist = null;//
		String strquery = null;
		strquery = " from ProjPlanType as ppt where ppt.bom_id =? and ppt.parent.id is null";

		try {
			Query query = hs.createQuery(strquery);
			query.setLong(0, masterId);
			resultlist = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (resultlist == null)
			resultlist = new LinkedList();

		return resultlist;
	}

	private List precal(List stList) {

		List valueList = new ArrayList();

		int stSize = stList.size();

		int[] manDay = new int[stSize];

		double[] cost = new double[stSize];
		double[] revenue = new double[stSize];
		double[] otherRev = new double[stSize];
		double[] totalRevenue = new double[stSize];
		double[] margin = new double[stSize];
		double[] profit = new double[stSize];
		double[] beforTax = new double[stSize];
		double[] corpTax = new double[stSize];
		double[] ifo = new double[stSize];

		double allCost = 0.0;
		double allRevenue = 0.0;
		double allTotalRev = 0.0;
		double allOtherRev = 0.0;
		double allNhrRev = 0.0;
		double allMargin = 0.0;
		double allCsc = 0.0;
		double allBeforTax = 0.0;
		double allCorpTax = 0.0;
		double allIfo = 0.0;

		for (int i = 0; i < stSize; i++) {

			ProjPlanType tmpType = null;
			tmpType = (ProjPlanType) stList.get(i);

			float currRate = (tmpType.getCurrency().getCurrRate()).floatValue();
			String taxFlag = tmpType.getTax();

			Set tmpSet = tmpType.getTypes();

			Iterator iter = tmpSet.iterator();

			while (iter.hasNext()) {
				ProjPlanBOMST tmpBomSt = (ProjPlanBOMST) iter.next();
				if (tmpBomSt.getBom().getParent() == null) {
					tmpBomSt.getManday();
					manDay[i] += tmpBomSt.getManday();
				}
			}

			cost[i] = (tmpType.getSl().getRate().doubleValue() + tmpType.getIndirectRate())
					* manDay[i];

			revenue[i] = tmpType.getSTRate() * manDay[i] * currRate;
			if (taxFlag != null && taxFlag.equals("y")) {
				revenue[i] = revenue[i] / 1.05;
			}

			otherRev[i] = revenue[i] * 0.0505;
			totalRevenue[i] = revenue[i] * 1.0505 + tmpType.getNhrRevenue();
			margin[i] = totalRevenue[i] * 0.95 - tmpType.getCodingSubContr();
			profit[i] = margin[i] - cost[i];
			beforTax[i] = profit[i] - totalRevenue[i] * 0.2;
			corpTax[i] = beforTax[i] * 0.075;
			ifo[i] = beforTax[i] * 0.925;

			allCost += cost[i];
			allRevenue += revenue[i];
			allTotalRev += totalRevenue[i];
			allOtherRev += otherRev[i];
			allNhrRev += tmpType.getNhrRevenue();
			allCsc += tmpType.getCodingSubContr();
			allMargin += margin[i];
			allBeforTax += beforTax[i];
			allCorpTax += corpTax[i];
			allIfo += ifo[i];
		}

		valueList.add(0, manDay);
		valueList.add(1, cost);
		valueList.add(2, revenue);
		valueList.add(3, otherRev);
		valueList.add(4, totalRevenue);
		valueList.add(5, margin);
		valueList.add(6, profit);
		valueList.add(7, beforTax);
		valueList.add(8, corpTax);
		valueList.add(9, ifo);
		valueList.add(10, new Double(allCost));
		valueList.add(11, new Double(allRevenue));
		valueList.add(12, new Double(allTotalRev));
		valueList.add(13, new Double(allOtherRev));
		valueList.add(14, new Double(allNhrRev));
		valueList.add(15, new Double(allCsc));
		valueList.add(16, new Double(allMargin));
		valueList.add(17, new Double(allBeforTax));
		valueList.add(18, new Double(allCorpTax));
		valueList.add(19, new Double(allIfo));

		return valueList;
	}

	private ActionForward export(ProjPlanBomMaster master, List valueList, List stList,
			HttpServletResponse response) {

		BidMaster bid = master.getBid();

		String dept = "";
		String projName = "";
		String custName = "";
		String contrNo = "";

		if (bid != null) {

			dept = bid.getDepartment().getDescription();
			custName = bid.getProspectCompany().getDescription();

			ProjectMaster proj = master.getProject();

			if (proj != null) {
				projName = proj.getProjName();
				contrNo = proj.getContractNo();
			}
		}

		try {
			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			NumberFormat numFormater = NumberFormat.getInstance();
			numFormater.setMaximumFractionDigits(2);
			numFormater.setMinimumFractionDigits(2);

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
					+ ExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			// 粗体文本，无下划线
			HSSFCellStyle boldTextStyle1 = sheet.getRow(2).getCell((short) 2).getCellStyle();

			// 粗体文本，有下划线
			HSSFCellStyle boldTextStyle2 = sheet.getRow(5).getCell((short) 2).getCellStyle();

			// Total 文本显示式样
			HSSFCellStyle totalTextStyle = sheet.getRow(8).getCell((short) 2).getCellStyle();

			// 文本式样
			HSSFCellStyle normalTextStyle = sheet.getRow(8).getCell((short) 3).getCellStyle();

			// 蓝色
			HSSFCellStyle normalNumberStyle = sheet.getRow(11).getCell((short) 2).getCellStyle();

			// 白色，无下划线
			HSSFCellStyle normalNumberStyle2 = sheet.getRow(13).getCell((short) 2).getCellStyle();

			// 白色，有下划线
			HSSFCellStyle normalNumberStyle3 = sheet.getRow(12).getCell((short) 2).getCellStyle();

			// 橙色
			HSSFCellStyle normalNumberStyle4 = sheet.getRow(19).getCell((short) 2).getCellStyle();

			// 绿色
			HSSFCellStyle normalNumberStyle5 = sheet.getRow(29).getCell((short) 2).getCellStyle();

			// 白色，上边框，蓝色字体，百分数
			HSSFCellStyle normalNumberStyle6 = sheet.getRow(33).getCell((short) 2).getCellStyle();

			// 白色，无边框，蓝色字体，百分数
			HSSFCellStyle normalNumberStyle7 = sheet.getRow(34).getCell((short) 2).getCellStyle();

			// 白色，下边框，蓝色字体，百分数
			HSSFCellStyle normalNumberStyle8 = sheet.getRow(35).getCell((short) 2).getCellStyle();

			// 紫色，有边框，
			HSSFCellStyle totalNumberStyle1 = sheet.getRow(22).getCell((short) 3).getCellStyle();

			// 紫色，上边框，
			HSSFCellStyle totalNumberStyle2 = sheet.getRow(19).getCell((short) 3).getCellStyle();

			// 紫色，下边框，
			HSSFCellStyle totalNumberStyle3 = sheet.getRow(21).getCell((short) 3).getCellStyle();

			// 紫色，无边框，
			HSSFCellStyle totalNumberStyle4 = sheet.getRow(20).getCell((short) 3).getCellStyle();

			// 紫色，无边框，百分数
			HSSFCellStyle totalNumberStyle5 = sheet.getRow(34).getCell((short) 3).getCellStyle();

			// 紫色，有边框，百分数
			HSSFCellStyle totalNumberStyle6 = sheet.getRow(29).getCell((short) 3).getCellStyle();

			// 紫色，上边框，百分数
			HSSFCellStyle totalNumberStyle7 = sheet.getRow(33).getCell((short) 3).getCellStyle();

			// 紫色，下边框，百分数
			HSSFCellStyle totalNumberStyle8 = sheet.getRow(35).getCell((short) 3).getCellStyle();

			HSSFRow HRow = null;
			HSSFCell cell = null;

			HRow = sheet.createRow(2);
			cell = HRow.createCell((short) 2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(dept);
			cell.setCellStyle(boldTextStyle1);

			HRow = sheet.createRow(3);
			cell = HRow.createCell((short) 2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(projName);
			cell.setCellStyle(boldTextStyle1);

			HRow = sheet.createRow(4);
			cell = HRow.createCell((short) 2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(custName);
			cell.setCellStyle(boldTextStyle1);

			HRow = sheet.createRow(5);
			cell = HRow.createCell((short) 2);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(contrNo);
			cell.setCellStyle(boldTextStyle2);

			// Service type
			int excelCol = ListStartCol;
			HRow = sheet.createRow(8);
			for (int i = 0; i < stList.size(); i++) {

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(((ProjPlanType) stList.get(i)).getDescription());
				cell.setCellStyle(normalTextStyle);

				excelCol++;
			}

			// NR OF Man-days USED FOR PROJECT
			excelCol = ListStartCol;
			HRow = sheet.createRow(9);
			for (int i = 0; i < stList.size(); i++) {

				int[] manDay = (int[]) valueList.get(0);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(manDay[i] == 0 ? "0.00" : numFormater.format(manDay[i]));
				cell.setCellStyle(normalNumberStyle);

				excelCol++;
			}

			// Fully Loaded DIRECT Cost Rate per day of resource
			excelCol = ListStartCol;
			HRow = sheet.createRow(11);
			for (int i = 0; i < stList.size(); i++) {

				double directRate = (((ProjPlanType) stList.get(i)).getSl().getRate())
						.doubleValue();

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(directRate);
				cell.setCellStyle(normalNumberStyle);

				excelCol++;
			}

			// Fully Loaded EXPENSE Cost Rate per day of resource
			excelCol = ListStartCol;
			HRow = sheet.createRow(12);
			for (int i = 0; i < stList.size(); i++) {

				double indirectRate = ((ProjPlanType) stList.get(i)).getIndirectRate();

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(indirectRate == 0 ? "0.00" : numFormater.format(indirectRate));
				cell.setCellStyle(normalNumberStyle3);

				excelCol++;
			}

			// Fully Loaded Cost Rate per day of resource
			excelCol = ListStartCol;
			HRow = sheet.createRow(13);
			for (int i = 0; i < stList.size(); i++) {

				double costRate = (((ProjPlanType) stList.get(i)).getSl().getRate()).doubleValue()
						+ ((ProjPlanType) stList.get(i)).getIndirectRate();

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(costRate == 0 ? "0.00" : numFormater.format(costRate));
				cell.setCellStyle(normalNumberStyle2);

				excelCol++;
			}

			// Sales Rate per resource
			excelCol = ListStartCol;
			HRow = sheet.createRow(14);
			for (int i = 0; i < stList.size(); i++) {

				double stRate = ((ProjPlanType) stList.get(i)).getSTRate();
				float currRate = (((ProjPlanType) stList.get(i)).getCurrency().getCurrRate())
						.floatValue();
				String tax = ((ProjPlanType) stList.get(i)).getTax();

				double rate = stRate * currRate;
				if (tax != null && tax.equals("y")) {
					rate = rate / 1.05;
				}

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(rate == 0 ? "0.00" : numFormater.format(rate));
				cell.setCellStyle(normalNumberStyle);

				excelCol++;
			}

			// Hour related revenue (T&M projects)
			excelCol = ListStartCol;
			HRow = sheet.createRow(16);
			for (int i = 0; i < stList.size(); i++) {

				double[] revenue = (double[]) valueList.get(2);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(revenue[i] == 0 ? "0.00" : numFormater.format(revenue[i]));
				cell.setCellStyle(normalNumberStyle2);

				excelCol++;
			}

			// Non-hour related revenue (FPP projects)
			excelCol = ListStartCol;
			HRow = sheet.createRow(17);
			for (int i = 0; i < stList.size(); i++) {

				double nhrRev = ((ProjPlanType) stList.get(i)).getNhrRevenue();

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(nhrRev == 0 ? "0.00" : numFormater.format(nhrRev));
				cell.setCellStyle(normalNumberStyle);

				excelCol++;
			}

			// Other Revenue
			excelCol = ListStartCol;
			HRow = sheet.createRow(18);
			for (int i = 0; i < stList.size(); i++) {

				double[] otherRev = (double[]) valueList.get(3);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(otherRev[i] == 0 ? "0.00" : numFormater.format(otherRev[i]));
				cell.setCellStyle(normalNumberStyle2);

				excelCol++;
			}

			// Total Revenue
			excelCol = ListStartCol;
			HRow = sheet.createRow(19);
			for (int i = 0; i < stList.size(); i++) {

				double[] totalRevenue = (double[]) valueList.get(4);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(totalRevenue[i] == 0 ? "0.00" : numFormater
						.format(totalRevenue[i]));
				cell.setCellStyle(normalNumberStyle4);

				excelCol++;
			}

			// Coding Subcontract
			excelCol = ListStartCol;
			HRow = sheet.createRow(20);
			for (int i = 0; i < stList.size(); i++) {

				double csc = ((ProjPlanType) stList.get(i)).getCodingSubContr();

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(csc == 0 ? "0.00" : numFormater.format(csc));
				cell.setCellStyle(normalNumberStyle);

				excelCol++;
			}

			// Business tax (for China portion) or other taxes levied on revenue
			excelCol = ListStartCol;
			HRow = sheet.createRow(21);
			for (int i = 0; i < stList.size(); i++) {

				double[] totalRevenue = (double[]) valueList.get(4);
				double tax = totalRevenue[i] * 0.05;

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(tax == 0 ? "0.00" : numFormater.format(tax));
				cell.setCellStyle(normalNumberStyle2);

				excelCol++;
			}

			// Contribution margin
			excelCol = ListStartCol;
			HRow = sheet.createRow(22);
			for (int i = 0; i < stList.size(); i++) {

				double[] margin = (double[]) valueList.get(5);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(margin[i] == 0 ? "0.00" : numFormater.format(margin[i]));
				cell.setCellStyle(normalNumberStyle4);

				excelCol++;
			}

			// DIRECT Cost of resources used
			excelCol = ListStartCol;
			HRow = sheet.createRow(23);
			for (int i = 0; i < stList.size(); i++) {

				double[] cost = (double[]) valueList.get(1);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(cost[i] == 0 ? "0.00" : numFormater.format(cost[i]));
				cell.setCellStyle(normalNumberStyle2);

				excelCol++;
			}

			// Gross Profit
			excelCol = ListStartCol;
			HRow = sheet.createRow(24);
			for (int i = 0; i < stList.size(); i++) {

				double[] profit = (double[]) valueList.get(6);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(profit[i] == 0 ? "0.00" : numFormater.format(profit[i]));
				cell.setCellStyle(normalNumberStyle4);

				excelCol++;
			}

			// INDIRECT Cost of resources used
			excelCol = ListStartCol;
			HRow = sheet.createRow(25);
			for (int i = 0; i < stList.size(); i++) {

				double[] totalRevenue = (double[]) valueList.get(4);
				double indirCost = totalRevenue[i] * 0.2;

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(indirCost == 0 ? "0.00" : numFormater.format(indirCost));
				cell.setCellStyle(normalNumberStyle2);

				excelCol++;
			}

			// Profit before Corporate Tax
			excelCol = ListStartCol;
			HRow = sheet.createRow(26);
			for (int i = 0; i < stList.size(); i++) {

				double[] beforTax = (double[]) valueList.get(7);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(beforTax[i] == 0 ? "0.00" : numFormater.format(beforTax[i]));
				cell.setCellStyle(normalNumberStyle4);

				excelCol++;
			}

			// Corporte tax
			excelCol = ListStartCol;
			HRow = sheet.createRow(27);
			for (int i = 0; i < stList.size(); i++) {

				double[] corpTax = (double[]) valueList.get(8);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(corpTax[i] == 0 ? "0.00" : numFormater.format(corpTax[i]));
				cell.setCellStyle(normalNumberStyle2);

				excelCol++;
			}

			// IFO
			excelCol = ListStartCol;
			HRow = sheet.createRow(28);
			for (int i = 0; i < stList.size(); i++) {

				double[] ifo = (double[]) valueList.get(9);

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(ifo[i] == 0 ? "0.00" : numFormater.format(ifo[i]));
				cell.setCellStyle(normalNumberStyle4);

				excelCol++;
			}

			// IFO%
			excelCol = ListStartCol;
			HRow = sheet.createRow(29);
			for (int i = 0; i < stList.size(); i++) {

				double ifoPer = 0;

				double[] totalRevenue = (double[]) valueList.get(4);
				double[] profit = (double[]) valueList.get(6);

				if (totalRevenue[i] != 0) {
					ifoPer = ((profit[i] - totalRevenue[i] * 0.2) * 0.925) / totalRevenue[i];
				}

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(ifoPer == 0 ? "0.00" : (numFormater.format(ifoPer * 100) + "%"));
				cell.setCellStyle(normalNumberStyle5);

				excelCol++;
			}

			// Contribution Margin as % of Revenue
			excelCol = ListStartCol;
			HRow = sheet.createRow(33);
			for (int i = 0; i < stList.size(); i++) {

				double marginPer = 0;

				double[] totalRevenue = (double[]) valueList.get(4);
				double[] margin = (double[]) valueList.get(5);

				if (totalRevenue[i] != 0) {
					marginPer = margin[i] / totalRevenue[i];
				}

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(marginPer == 0 ? "0.00"
						: (numFormater.format(marginPer * 100) + "%"));
				cell.setCellStyle(normalNumberStyle6);

				excelCol++;
			}

			// Gross Profit as % of Revenue
			excelCol = ListStartCol;
			HRow = sheet.createRow(34);
			for (int i = 0; i < stList.size(); i++) {

				double profitPer = 0;

				double[] totalRevenue = (double[]) valueList.get(4);
				double[] profit = (double[]) valueList.get(6);

				if (totalRevenue[i] != 0) {
					profitPer = profit[i] / totalRevenue[i];
				}

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(profitPer == 0 ? "0.00"
						: (numFormater.format(profitPer * 100) + "%"));
				cell.setCellStyle(normalNumberStyle7);

				excelCol++;
			}

			// IFO%
			excelCol = ListStartCol;
			HRow = sheet.createRow(35);
			for (int i = 0; i < stList.size(); i++) {

				double ifoPer = 0;

				double[] totalRevenue = (double[]) valueList.get(4);
				double[] profit = (double[]) valueList.get(6);

				if (totalRevenue[i] != 0) {
					ifoPer = ((profit[i] - totalRevenue[i] * 0.2) * 0.925) / totalRevenue[i];
				}

				cell = HRow.createCell((short) excelCol);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(ifoPer == 0 ? "0.00" : (numFormater.format(ifoPer * 100) + "%"));
				cell.setCellStyle(normalNumberStyle8);

				excelCol++;
			}

			int stSize = stList.size();
			int totalCol = stSize + 2;

			// Print "Total Project"
			HRow = sheet.createRow(15);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue("Total Project");
			cell.setCellStyle(totalTextStyle);

			// Total hour related revenue (T&M projects)
			double allRevenue = ((Double) valueList.get(11)).doubleValue();
			HRow = sheet.createRow(16);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allRevenue));
			cell.setCellStyle(totalNumberStyle2);

			// Total non-hour related revenue (FPP projects)
			double allNhrRev = ((Double) valueList.get(14)).doubleValue();
			HRow = sheet.createRow(17);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allNhrRev));
			cell.setCellStyle(totalNumberStyle4);

			// Total other Revenue
			double allOtherRev = ((Double) valueList.get(13)).doubleValue();
			HRow = sheet.createRow(18);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allOtherRev));
			cell.setCellStyle(totalNumberStyle3);

			// All total revenue
			double allTotalRev = ((Double) valueList.get(12)).doubleValue();
			HRow = sheet.createRow(19);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allTotalRev));
			cell.setCellStyle(totalNumberStyle1);

			// Total Coding Subcontract
			double allCsc = ((Double) valueList.get(15)).doubleValue();
			HRow = sheet.createRow(20);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allCsc));
			cell.setCellStyle(totalNumberStyle2);

			// Total business tax or other taxes levied on revenue
			HRow = sheet.createRow(21);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allTotalRev * 0.05));
			cell.setCellStyle(totalNumberStyle4);

			// Total contribution margin
			double allMargin = ((Double) valueList.get(16)).doubleValue();
			HRow = sheet.createRow(22);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allMargin));
			cell.setCellStyle(totalNumberStyle4);

			// Total DIRECT Cost of resources used
			double allCost = ((Double) valueList.get(10)).doubleValue();
			HRow = sheet.createRow(23);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allCost));
			cell.setCellStyle(totalNumberStyle3);

			// Total gross Profit
			HRow = sheet.createRow(24);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allMargin - allCost));
			cell.setCellStyle(totalNumberStyle1);

			// Total INDIRECT Cost of resources used
			HRow = sheet.createRow(25);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allTotalRev * 0.2));
			cell.setCellStyle(totalNumberStyle1);

			// Total profit before Corporate Tax
			double allBeforTax = ((Double) valueList.get(17)).doubleValue();
			HRow = sheet.createRow(26);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allBeforTax));
			cell.setCellStyle(totalNumberStyle1);

			// Total Corporte tax
			double allCorpTax = ((Double) valueList.get(18)).doubleValue();
			HRow = sheet.createRow(27);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allCorpTax));
			cell.setCellStyle(totalNumberStyle1);

			// Total IFO
			double allIfo = ((Double) valueList.get(19)).doubleValue();
			HRow = sheet.createRow(28);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(numFormater.format(allIfo));
			cell.setCellStyle(totalNumberStyle1);

			// Total IFO %
			HRow = sheet.createRow(29);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(allTotalRev == 0 ? "0.00" : (numFormater
					.format((allIfo / allTotalRev) * 100) + "%"));
			cell.setCellStyle(totalNumberStyle6);

			// Total contribution Margin as % of Revenue
			HRow = sheet.createRow(33);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(allTotalRev == 0 ? "0.00" : (numFormater
					.format((allMargin / allTotalRev) * 100))
					+ "%");
			cell.setCellStyle(totalNumberStyle7);

			// Total gross Profit as % of Revenue
			HRow = sheet.createRow(34);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(allTotalRev == 0 ? "0.00" : (numFormater
					.format(((allMargin - allCost) / allTotalRev) * 100))
					+ "%");
			cell.setCellStyle(totalNumberStyle5);

			// Total IFO%
			HRow = sheet.createRow(35);
			cell = HRow.createCell((short) totalCol);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(allTotalRev == 0 ? "0.00" : (numFormater
					.format((allIfo / allTotalRev) * 100))
					+ "%");
			cell.setCellStyle(totalNumberStyle8);

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

	private final static String ExcelTemplate = "ProjectBomPreCal.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Project Bom Pre-Calculation.xls";

	private final int ListStartCol = 2;
}

package com.aof.webapp.action.prm;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
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
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.BillingMaterial;
import com.aof.component.prm.Bill.MOBillTransactionDetail;
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.project.ServiceType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.report.ReportBaseAction;

public class addMaterialAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(SelMemberAction.class.getName());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");

		String action = request.getParameter("formAction");

		// add by Will begin. 2006-05-26
		String excelAction = request.getParameter("excelAction");
		// add bye Will end.

		System.out.println("the action for add material is :" + action);

		if ((action == null) || (action.length() < 2))
			action = "update";

		Transaction tx = null;
		try {
			String[] trid = request.getParameterValues("trid");
			String[] type = request.getParameterValues("type");
			String[] typeid = request.getParameterValues("typeid");
			String[] price = request.getParameterValues("price");
			String[] quantity = request.getParameterValues("quantity");
			String[] subtotal = request.getParameterValues("subtotal");
			String[] desc = request.getParameterValues("desc");
			String total = request.getParameter("total");
			String[] record = request.getParameterValues("record");
			String materialid = request.getParameter("materialid");
			String name = request.getParameter("descname");
			String index = request.getParameter("index");
			String modifydate = request.getParameter("modifydate");
			if (modifydate != null)
				System.out.println("the modify date is:" + modifydate);

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			tx = hs.beginTransaction();

			// add by Will begin. 2006-05-26
			if (excelAction != null && excelAction.equals("exportYes")) {

				String projId = request.getParameter("projectId");
				String materialIndex = request.getParameter("materialIndex");

				if (projId != null && !projId.equals("")) {

					return ExportToExcel(mapping, request, response, projId, materialIndex);
				}
			} else {
				// add by Will end.

				if (action.equalsIgnoreCase("add")) {
					String projId = request.getParameter("hiddenDataId");
					if (projId != null && !projId.equals("")) {
						ProjectMaster CustProject = (ProjectMaster) hs.load(ProjectMaster.class,
								projId);
						List ServiceTypeList = new LinkedList();
						Iterator iter = CustProject.getServiceTypes().iterator();
						while (iter.hasNext()) {
							ServiceType st = (ServiceType) iter.next();
							ServiceTypeList.add(st);
							st.getDescription();
						}
						System.out.println("the project id is:" + CustProject.getProjId()
								+ "and the size is:" + ServiceTypeList.size());
						request.setAttribute("projId", projId);
						request.setAttribute("servicetype", ServiceTypeList);
						request.setAttribute("action", "add");
						log.info("go to >>>>>>>>>>>>>>>>. add forward");
					}
					return (mapping.findForward("success"));
				}
				if (action.equalsIgnoreCase("edit")) {
					String projId = request.getParameter("hiddenDataId");
					if (projId != null && !projId.equals("")) {
						ProjectMaster CustProject = (ProjectMaster) hs.load(ProjectMaster.class,
								projId);
						Query query = hs
								.createQuery("from MOBillTransactionDetail as tr where tr.Project.projId=? and tr.TransactionIndex = ?");
						query.setString(0, projId);
						query.setInteger(1, Integer.parseInt(index));
						List result = query.list();
						request.setAttribute("TransactionList", result);
						query = hs
								.createQuery("from BillingMaterial as m where m.project.projId=? and m.index=?");
						query.setString(0, projId);
						query.setInteger(1, Integer.parseInt(index));
						result = query.list();
						request.setAttribute("BillingMaterial", (BillingMaterial) result.get(0));
						request.setAttribute("action", "edit");
					}
				}

				if (action.equalsIgnoreCase("insert")) {
					String projId = request.getParameter("projId");
					ProjectMaster pm = (ProjectMaster) hs.load(ProjectMaster.class, projId);
					Query query = hs.createQuery(" from BillingMaterial as tr "
							+ " where tr.project.projId= ? order by tr.index desc");
					query.setString(0, pm.getProjId());
					List result = query.list();
					Long id;
					if ((result != null) && (result.size() > 0)) {
						BillingMaterial motr = (BillingMaterial) result.get(0);
						id = motr.getIndex();
						if (id == null) {
							id = new Long(0);
						}
						System.out.println("id is:" + id);

						id = new Long(id.intValue() + 1);
					} else
						id = new Long(1);
					System.out.println(id);
					CurrencyType ct = (CurrencyType) hs.load(CurrencyType.class, "RMB");
					for (int i = 0; i < java.lang.reflect.Array.getLength(record); i++) {
						MOBillTransactionDetail tr = new MOBillTransactionDetail();
						tr
								.setTransactionCategory(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE);
						tr.setTransactionIndex(id);
						tr.setSerivcetypeid(new Long(typeid[i]));
						tr.setDesc(type[i]);
						tr.setSubtotal(new Double(subtotal[i]));
						// tr.setCreatedate(Calendar.getInstance().getTime());
						tr.setDesc2(desc[i]);
						tr.setQuantity(new Long(UtilString.removeSymbol(quantity[i], ',')));
						tr.setPrice(new Double(UtilString.removeSymbol(price[i], ',')));
						tr.setCurrency(ct);
						tr.setProject(pm);
						hs.save(tr);
						ProjectBill billling = new ProjectBill();
						billling.getBillCode();
					}
					BillingMaterial material = new BillingMaterial();
					if (modifydate != null) {
						material.setCreateDate(new Date());
						material.setAcceptanceDate(new SimpleDateFormat("yyyy-MM-dd")
								.parse(modifydate));
					} else {
						material.setAcceptanceDate(new Date());
						material.setCreateDate(new Date());
					}
					material.setAmount(new Double(total));
					material.setBillTo(pm.getBillTo());
					material.setCurrency(ct);
					material.setExchangeRate(new Double(ct.getCurrRate().doubleValue()));
					material.setProject(pm);
					material.setProjectManager(pm.getProjectManager());
					material.setIndex(id);
					material.setDescription(name);
					TransactionServices ts = new TransactionServices();
					UserLogin ul = (UserLogin) request.getSession().getAttribute(
							Constants.USERLOGIN_KEY);
					ts.insert(material, ul);

					request.setAttribute("CLOSE", "TRUE");
					return (mapping.findForward("success"));
				}

				if (action.equalsIgnoreCase("update")) {
					for (int i = 0; i < java.lang.reflect.Array.getLength(record); i++) {
						MOBillTransactionDetail tr = (MOBillTransactionDetail) hs.load(
								MOBillTransactionDetail.class, new Long(trid[i]));
						tr.setSubtotal(new Double(UtilString.removeSymbol(subtotal[i], ',')));
						tr.setDesc2(desc[i]);
						// tr.setCreatedate(Calendar.getInstance().getTime());
						tr.setQuantity(new Long(UtilString.removeSymbol(quantity[i], ',')));
						hs.save(tr);
					}
					BillingMaterial material = (BillingMaterial) hs.load(BillingMaterial.class,
							new Long(materialid));
					if ((modifydate != null) && (modifydate.length() > 1))
						// material.setCreateDate(new
						// SimpleDateFormat("yyyy-MM-dd").parse(modifydate));
						material.setAcceptanceDate(new SimpleDateFormat("yyyy-MM-dd")
								.parse(modifydate));
					else {
						Calendar.getInstance().clear();
						material.setAcceptanceDate(new Date());
						// material.setCreateDate(new Date());
					}
					material.setAmount(new Double(UtilString.removeSymbol(total, ',')));
					material.setDescription(name);
					request.setAttribute("CLOSE", "TRUE");
					return (mapping.findForward("success"));
				}
			}
			return (mapping.findForward("success"));
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return (mapping.findForward("success"));
		} finally {
			try {
				if (tx != null)
					tx.commit();
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				try {
					if (tx != null)
						tx.rollback();
				} catch (HibernateException e2) {
					e2.printStackTrace();
				}
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				try {
					if (tx != null)
						tx.rollback();
				} catch (HibernateException e2) {
					e2.printStackTrace();
				}
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
	}

	// add by Will begin.2006-5-28
	private ActionForward ExportToExcel(ActionMapping mapping, HttpServletRequest request,
			HttpServletResponse response, String projId, String materialIndex) {
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}

			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			// Fetch related Data
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			ProjectMaster custProject = (ProjectMaster) hs.load(ProjectMaster.class, projId);

			String project = projId + ":" + custProject.getProjName();

			String contractNo = custProject.getContractNo();

			String customer = custProject.getCustomer().getPartyId() + ":"
					+ custProject.getCustomer().getDescription();

			Query query = hs
					.createQuery("from MOBillTransactionDetail as tr where tr.Project.projId=? and tr.TransactionIndex = ?");
			query.setString(0, projId);
			query.setInteger(1, Integer.parseInt(materialIndex));
			List itemList = query.list();

			query = hs
					.createQuery("from BillingMaterial as m where m.project.projId=? and m.index=?");
			query.setString(0, projId);
			query.setInteger(1, Integer.parseInt(materialIndex));
			List result = query.list();
			BillingMaterial material = (BillingMaterial) result.get(0);

			String acceptDesc = material.getDescription();
			SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
			String acceptDate = dateFormater.format(material.getCreateDate());
			double acceptValue = material.getAmount().doubleValue();

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

			// Header
			HSSFRow row = null;
			HSSFCell cell = null;

			row = sheet.getRow(2);
			cell = row.getCell((short) 1); // Project Name.
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
			cell.setCellValue(project);

			cell = row.getCell((short) 5); // Contract No
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(contractNo);

			cell = sheet.getRow(3).getCell((short) 1); // Customer Name
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(customer);

			cell = sheet.getRow(4).getCell((short) 1); // Acceptance
			// Description
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(acceptDesc);

			cell = sheet.getRow(5).getCell((short) 1); // Acceptance Date
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(acceptDate);

			cell = sheet.getRow(6).getCell((short) 1); // Acceptance Value
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(acceptValue);

			// List
			int excelRow = ListStartRow;
			// Style
			HSSFCellStyle textStyle = sheet.getRow(ListStartRow).getCell((short) 0).getCellStyle();
			HSSFCellStyle numberStyle = sheet.getRow(ListStartRow).getCell((short) 1)
					.getCellStyle();
			for (int i = 0; i < itemList.size(); i++) {

				MOBillTransactionDetail transDetail = (MOBillTransactionDetail) itemList.get(i);
				row = sheet.getRow(excelRow);

				cell = row.getCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(transDetail.getDesc());
				cell.setCellStyle(textStyle);

				cell = row.getCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(transDetail.getPrice().doubleValue());
				cell.setCellStyle(numberStyle);

				cell = row.getCell((short) 2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(transDetail.getQuantity().longValue());
				cell.setCellStyle(numberStyle);

				cell = row.getCell((short) 3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(transDetail.getSubtotal().doubleValue());
				cell.setCellStyle(numberStyle);

				String desc2 = transDetail.getDesc2();
				cell = row.getCell((short) 4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				if (desc2 == null || desc2.equals("")) {
					cell.setCellValue("");
				} else {
					cell.setCellValue(transDetail.getDesc2());
				}
				cell.setCellStyle(textStyle);
				excelRow++;
			}
			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private final static String FormSheetName = "Form";

	private final static String ExcelTemplate = "MOServiceDeliveryDetailPrint.xls";

	private final static String SaveToFileName = "MO Service Delivery Detail Report.xls";

	private final int ListStartRow = 9;

	// add bye Will end.
}
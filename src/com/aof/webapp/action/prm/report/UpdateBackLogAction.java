package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.util.*;
import java.util.LinkedList;
import java.util.List;
import java.text.*;

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

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.TimeSheet.TimeSheetDetail;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.report.BackLog;
import com.aof.component.prm.report.BackLogBean;
import com.aof.component.prm.report.BackLogMaster;
import com.aof.component.prm.report.DepartmentBLBean;
import com.aof.component.prm.report.SiteBLBean;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.project.EditContractProjectAction;

public class UpdateBackLogAction extends ReportBaseAction {
	private final static String ExcelTemplate = "BackLog.xls";

	private final static String FormSheetName = "Backlog New";

	private final static String SaveToFileName = "BackLog Report.xls";

	// private final int ListStartRow = 7;

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger
				.getLogger(EditContractProjectAction.class.getName());
		String cmonth = request.getParameter("cmonth");
		String cyear = request.getParameter("cyear");
		String status = request.getParameter("status");
		String projId[] = request.getParameterValues("projId");
		String department = request.getParameter("departmentId");
		String recurringflag = request.getParameter("recurringflag");
		int RowSize = java.lang.reflect.Array.getLength(projId);

		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			tx = hs.beginTransaction();
			Query query = null;
			// update backlog
			if ((status.equalsIgnoreCase("draft"))
					|| (status.equalsIgnoreCase("confirm"))) {
				for (int i = 0; i < RowSize; i++) {
					String RecordVal[] = request.getParameterValues("RecordVal"
							+ i);
					List bllist = null;
					query = hs
							.createQuery("from BackLog as bl where bl.project=? and bl.bl_year=? and bl.bl_month=?");
					query.setString(0, projId[i]);
					query.setString(1, cyear);
					query.setString(2, cmonth);
					bllist = query.list();
					if ((bllist != null) && (bllist.size() != 0)) {
						BackLog backlog = (BackLog) bllist.get(0);
						if (backlog.getStatus().trim()
								.equalsIgnoreCase("draft")) {
							int savemonth = backlog.getBl_month();
							backlog.setAmount(Double
									.parseDouble(UtilString.removeSymbol(RecordVal[savemonth - 1], ',')));
							backlog.setstatus(status);
							hs.save(backlog);
						}
					} else {
						BackLog backlog = new BackLog();
						backlog.setAmount(Double.parseDouble(UtilString.removeSymbol(RecordVal[Integer
						                                       								.parseInt(cmonth) - 1], ',')));
						backlog.setbl_year(Integer.parseInt(cyear));
						backlog.setbl_month(Integer.parseInt(cmonth));
						ProjectMaster pm = (ProjectMaster) hs.load(
								ProjectMaster.class, projId[i]);
						backlog.setproject(pm);
						backlog.setstatus(status);
						hs.save(backlog);
					}

					// update backlog master
					String weight = request.getParameter("yt" + i);
					bllist = null;
					query = hs
							.createQuery("from BackLogMaster where project=? and blm_year=? ");
					query.setString(0, projId[i]);
					query.setString(1, cyear);
					bllist = query.list();
					ProjectMaster project = (ProjectMaster) hs.load(
							ProjectMaster.class, projId[i]);
					if (bllist.size() == 0) {
						BackLogMaster master = new BackLogMaster();
						master.setProject(project);
						master.setBlm_year(Integer.parseInt(cyear));
						master
								.setAmount(new Double(Double
										.parseDouble(UtilString.removeSymbol(weight, ','))));
						hs.save(master);
					} else if (bllist.size() != 0) {
						BackLogMaster master = (BackLogMaster) bllist.get(0);
						master
								.setAmount(new Double(Double
										.parseDouble(UtilString.removeSymbol(weight, ','))));
						hs.save(master);
					}
				}
				request.setAttribute("cmonth", cmonth);
				request.setAttribute("cyear", cyear);
				request.setAttribute("formaction", "draft");
				request.setAttribute("departmentId",department);
				request.setAttribute("recurringflag",recurringflag);
				hs.flush();
				tx.commit();
				return (mapping.findForward("view"));// back to backlog
				// maintain page
			} else if (status.equalsIgnoreCase("export")) {
				UserLogin ul = (UserLogin) request.getSession().getAttribute(
						Constants.USERLOGIN_KEY);

				List securitylist = (List) request.getAttribute("securitylist");
				Hashtable depttable = new Hashtable();//
				List deptlist = new LinkedList();
				for (int n = 0; n < securitylist.size(); n++) {
					List recordList = (List) request
							.getAttribute((String) securitylist.get(n));
					DepartmentBLBean bean = new DepartmentBLBean(
							(String) securitylist.get(n), recordList);
					bean.setRevenue();
					depttable.put((String) securitylist.get(n), bean);
					deptlist.add(bean);
				}

				SiteBLBean sitebean = new SiteBLBean((String) request
						.getAttribute("departmentdesc"), deptlist, cyear, cmonth);
				sitebean.setRevenue();

				// Start to output the excel file
				response.reset();
				response.setHeader("Content-Disposition",
						"attachment;filename=\"" + SaveToFileName + "\"");
				response.setContentType("application/octet-stream");

				// Use POI to read the selected Excel Spreadsheet
				String TemplatePath = GetTemplateFolder();
				HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(
						TemplatePath + "\\" + ExcelTemplate));
				// Select the first worksheet
				HSSFSheet sheet = wb.getSheet(FormSheetName);
				HSSFCell cell = null;
				HSSFCellStyle titlestyle = sheet.getRow(0).getCell((short) 1)
						.getCellStyle();
				HSSFCellStyle totalvaluestyle = sheet.getRow(6).getCell(
						(short) 8).getCellStyle();
				HSSFCellStyle deptnamestyle = sheet.getRow(7)
						.getCell((short) 1).getCellStyle();
				HSSFCellStyle deptnumber = sheet.getRow(7).getCell((short) 8)
						.getCellStyle();
				HSSFCellStyle recordtextstyle = sheet.getRow(8).getCell(
						(short) 1).getCellStyle();
				HSSFCellStyle recordnumberstyle = sheet.getRow(8).getCell(
						(short) 8).getCellStyle();

				/***************************************************************
				 * initial the excel header
				 **************************************************************/

				int currentRow = 0;
				HSSFRow HRow = null;

				HRow = sheet.createRow(0);
				cell = HRow.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue("BackLog Report");
				cell.setCellStyle(titlestyle);

				cell = HRow.createCell((short) 6);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell
						.setCellValue("PRC  "
								+ sitebean.getDepdesc().toUpperCase());
				cell.setCellStyle(titlestyle);

				HRow = sheet.createRow(1);
				cell = HRow.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				DateFormat fomat = new SimpleDateFormat("MMMM-yy", Locale.ENGLISH);
				DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
				System.out.println(sitebean.getCyear()+"-"+sitebean.getCmonth()+"-1");
				cell.setCellValue(fomat.format(df.parse(sitebean.getCyear()+"-"+sitebean.getCmonth()+"-1" )));
				cell.setCellStyle(titlestyle);

				// department records set
				currentRow = 6;
				HRow = sheet.createRow(currentRow);
				cell = HRow.createCell((short) 8);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sitebean.getTotalTCV()/1000);
				cell.setCellStyle(totalvaluestyle);
				cell = HRow.createCell((short) 13);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
				cell.setCellValue(sitebean.getTYRevenue());
				cell.setCellStyle(totalvaluestyle);
				Integer[] month = sitebean.getMonth();
				for (int j = 14; j < 26; j++) {
					cell = HRow.createCell((short) j);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellValue((int) Math.round(month[j - 14]
							.doubleValue()));
					cell.setCellStyle(totalvaluestyle);
				}

				// department begin
				currentRow = 7;
				for (int i = 0; i < sitebean.getDeplist().size(); i++) {
					// department total
					HRow = sheet.createRow(currentRow);
					DepartmentBLBean depbean = (DepartmentBLBean) sitebean
							.getDeplist().get(i);
					if (depbean.getRecordlist().size()<=0)
						continue;
					for (int h = 1; h < 28; h++) {
						cell = HRow.createCell((short) h);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(" ");
						cell.setCellStyle(deptnumber);
					}
					cell = HRow.createCell((short) 1);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellValue(depbean.getDepdesc());
					cell.setCellStyle(deptnamestyle);

					cell = HRow.createCell((short) 8);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellValue(depbean.getTotalTCV()/1000);
					cell.setCellStyle(deptnumber);
					cell = HRow.createCell((short) 13);
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellValue(depbean.getTYRevenue());
					cell.setCellStyle(deptnumber);
					month = depbean.getMonth();
					for (int j = 14; j < 26; j++) {
						cell = HRow.createCell((short) j);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(month[j - 14].intValue());
						cell.setCellStyle(deptnumber);
					}

					// department records
					currentRow += 1;
					for (int d = 0; d < depbean.getRecordlist().size(); d++) {
						BackLogBean recordbean = (BackLogBean) depbean
								.getRecordlist().get(d);
						HRow = sheet.createRow(currentRow);
						cell = HRow.createCell((short) 1);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(recordbean.getPb().getCustomer());
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 2);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(recordbean.getPb().getC2code());
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 3);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(recordbean.getPb().getCustomer());
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 4);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(recordbean.getPb().getProjName());
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 5);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(recordbean.getPb().getIndustry());
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 6);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(recordbean.getPb().getContractType());
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 7);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(recordbean.getPb().getContractNo()); //
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 8);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue((int) Math.round(recordbean.getPb()
								.getTotalServiceValue().doubleValue()/1000)); //
						cell.setCellStyle(recordnumberstyle);

						cell = HRow.createCell((short) 11);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(recordbean.getPb().getStartDate()
								.toString());
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 12);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(recordbean.getPb().getEndDate()
								.toString());
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 13);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue((int) Math.round(recordbean
								.getThisyear().doubleValue())); //
						cell.setCellStyle(recordnumberstyle);

						Double[][] recordmonth = recordbean.getMonth();
						for (int p = 14; p < 26; p++) {
							cell = HRow.createCell((short) p);
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
							cell
									.setCellValue((int) Math
											.round(recordmonth[0][p - 14]
													.doubleValue())); //
							cell.setCellStyle(recordnumberstyle);
						}
						cell = HRow.createCell((short) 27);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue("Acc Mgr");
						cell.setCellStyle(recordtextstyle);

						cell = HRow.createCell((short) 28);
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue("SD PM");
						cell.setCellStyle(recordtextstyle);
						currentRow += 1;
					}
					currentRow += 1;
				}
				// 写入Excel工作表
				wb.write(response.getOutputStream());
				// 关闭Excel工作薄对象
				response.getOutputStream().close();
				response.setStatus(HttpServletResponse.SC_OK);
				response.flushBuffer();
				return null;
			}
			return (mapping.findForward("error"));// back to backlog maintain
			// page
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return (mapping.findForward("error"));

		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
	}

}

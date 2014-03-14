/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.expense;

import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.expense.ExpenseAmount;
import com.aof.component.prm.expense.ExpenseMaster;
import com.aof.component.prm.project.ExpenseType;
import com.aof.component.prm.util.EmailService;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.prm.report.ReportBaseAction;

/**
 * @author Jeffrey Liang
 * @version 2004-10-30
 * 
 */
public class FindExpToClaimPageAction extends
		com.shcnc.struts.action.BaseAction {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws HibernateException, IOException, IllegalAccessException,
			InvocationTargetException {
		// Extract attributes we will need
		String action = request.getParameter("FormAction");
		UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (action == null)
			action = "QueryForList";

		if (action.equals("QueryForList")) {
			List result = findQueryResult(request, 0);
			request.setAttribute("QryList", result);
		}
		if (action.equals("VerifySelection")) {
			BatchUpdateStatus(request, "Claimed");
			List result = findQueryResult(request, 0);
			request.setAttribute("QryList", result);
		}
		if (action.equals("ConfirmSelection")) {
			BatchUpdateStatus(request, "Confirmed");
			List result = findQueryResult(request, 0);
			request.setAttribute("QryList", result);
		}
		if (action.equals("UnconfirmSelection")) {
			BatchUpdateStatus(request, "F&A Rejected");
			List result = findQueryResult(request, 0);
			request.setAttribute("QryList", result);
		}
		if (action.equals("ExportSelection")) {
			List result = findExportSelectionResult(request);
			try {
				if (result != null) {
					String templateid = request.getParameter("template");
					if(templateid == null)templateid = ul.getParty().getPartyId();			
					if(templateid.equals("002"))//shanghai
						return ExportList(request, response, result);

					if(templateid.equals("003"))//beijing
						return this.ExportExcel4BJ(request, response, result);
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
		}
		if (action.equals("ExportAll")) {
			String templateid = request.getParameter("template");
			if(templateid == null)templateid = ul.getParty().getPartyId();			
			try {
				if(templateid.equals("002"))//shanghai
				{
					List result = findQueryResult(request, 0);
					return ExportList(request, response, result);
				}
				if(templateid.equals("003"))//beijing
				{
					List result = findQueryResult(request, 1);
					return this.ExportExcel4BJ(request, response, result);
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
		}
		return (mapping.findForward("success"));
	}

	private List findQueryResult(HttpServletRequest request, int locFlag) {
		List result = null;
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			HttpSession session = request.getSession();
			UserLogin ul = (UserLogin) session
					.getAttribute(Constants.USERLOGIN_KEY);
//			String UserId = ul.getUserLoginId();
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date nowDate = (java.util.Date) UtilDateTime.nowTimestamp();

			String textuser = request.getParameter("textuser");
			String textproj = request.getParameter("textproj");
			String textstatus = request.getParameter("textstatus");
			String textcode = request.getParameter("textcode");
			String departmentId = request.getParameter("departmentId");
			String DateStart = request.getParameter("DateStart");
			String DateEnd = request.getParameter("DateEnd");
			String ConfirmStart = request.getParameter("ConfirmStart");
			String ConfirmEnd = request.getParameter("ConfirmEnd");
			String ClaimStart = request.getParameter("ClaimStart");
			String ClaimEnd = request.getParameter("ClaimEnd");
			if (ConfirmStart == null)
				ConfirmStart = "";
			if (ConfirmEnd == null)
				ConfirmEnd = "";
			if (ClaimStart == null)
				ClaimStart = "";
			if (ClaimEnd == null)
				ClaimEnd = "";
			if (textproj == null)
				textproj = "";
			if (textstatus == null)
				textstatus = "Posted To F&A";
			if (textuser == null)
				textuser = "";
			if (textcode == null)
				textcode = "";
			if (departmentId == null)
				departmentId = ul.getParty().getPartyId();
			if (DateStart == null)
				DateStart = Date_formater.format(UtilDateTime.getDiffDay(
						nowDate, -30));
			if (DateEnd == null)
				DateEnd = Date_formater.format(nowDate);

			String ExportFlag = request.getParameter("ExportFlag");
			if (ExportFlag == null)
				ExportFlag = "N";

			PartyHelper ph = new PartyHelper();
			String PartyListStr = "''";
			if (!departmentId.trim().equals("")) {
				List partyList_dep = ph.getAllSubPartysByPartyId(hs,
						departmentId);
				Iterator itdep = partyList_dep.iterator();
				PartyListStr = "'" + departmentId + "'";
				while (itdep.hasNext()) {
					Party p = (Party) itdep.next();
					PartyListStr = PartyListStr + ", '" + p.getPartyId() + "'";
				}
			}

			String StatusListStr = "'Posted To F&A','Confirmed','Claimed','F&A Rejected'";
			String QryStr = "select em from ExpenseMaster as em";
			// QryStr = QryStr +" where ";

			if (!textstatus.trim().equals("")) {
				QryStr = QryStr + " where  (em.Status = '" + textstatus + "')";
			} else {
				QryStr = QryStr + " where  (em.Status in (" + StatusListStr
						+ "))";
			}

			if (ExportFlag.equals("N")) {
				QryStr = QryStr
						+ " and (isnull(em.ClaimExportDate,'1990-01-01') = '1990-01-01')";
			}
			if (!textuser.trim().equals("")) {
				QryStr = QryStr + " and ((em.ExpenseUser.name like '%"
						+ textuser.trim()
						+ "%') or (em.ExpenseUser.userLoginId like '%"
						+ textuser.trim() + "%'))";
			}
			if (!textproj.trim().equals("")) {
				QryStr = QryStr + " and ((em.Project.projName like '%"
						+ textproj.trim() + "%') or (em.Project.projId like '%"
						+ textproj.trim() + "%'))";
			}
			if (!textcode.trim().equals("")) {
				QryStr = QryStr + " and (em.FormCode like '%" + textcode.trim()
						+ "%')";
			}
			if (!ConfirmStart.trim().equals("")) {
				QryStr = QryStr + " and ((em.FAConfirmDate <= '" + ConfirmStart
						+ " 23:59:59" + "' ) and (em.FAConfirmDate >= '"
						+ ConfirmStart + " 00:00:00" + "' ))";
			}
			if (!ClaimStart.trim().equals("")) {
				QryStr = QryStr + " and ((em.ReceiptDate <= '" + ClaimStart
						+ " 23:59:59" + "' ) and (em.ReceiptDate >= '"
						+ ClaimStart + " 00:00:00" + "' ))";
				// QryStr = QryStr +" and (em.ReceiptDate = '"+ClaimStart+"')";
			}

			QryStr = QryStr + " and (em.EntryDate between '" + DateStart
					+ "' and '" + DateEnd + "')";
			QryStr = QryStr + " and em.ExpenseUser.party.partyId in ("
					+ PartyListStr + ")";
			if (locFlag == 0)
				QryStr = QryStr
						+ " order by em.EntryDate DESC, em.Project.projId, em.ExpenseUser, em.FormCode";
			if (locFlag == 1)
				QryStr = QryStr
						+ " order by em.ExpenseUser, em.FormCode,em.EntryDate DESC,em.Project.projId";
			Query q = hs.createQuery(QryStr);
			result = q.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	private List findExportSelectionResult(HttpServletRequest request) {
		List result = null;
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			String QryStr = "select em from ExpenseMaster as em";
			String chk[] = request.getParameterValues("chk");
			if (chk != null) {
				int RowSize = java.lang.reflect.Array.getLength(chk);
				String emIdListStr = "";
				for (int i = 0; i < RowSize; i++) {
					emIdListStr = emIdListStr + chk[i] + ",";
				}
				emIdListStr = emIdListStr
						.substring(0, emIdListStr.length() - 1);
				QryStr = QryStr + " where em.Id in (" + emIdListStr + ")";
				QryStr = QryStr
						+ " order by em.ExpenseUser, em.FormCode,em.EntryDate DESC,em.Project.projId";
				Query q = hs.createQuery(QryStr);
				result = q.list();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	private void BatchUpdateStatus(HttpServletRequest request, String ToStatus) {
		String chk[] = request.getParameterValues("chk");
		if (chk != null) {
			try {
				net.sf.hibernate.Session hs = Hibernate2Session
						.currentSession();
				Transaction tx = hs.beginTransaction();
				int RowSize = java.lang.reflect.Array.getLength(chk);
				for (int i = 0; i < RowSize; i++) {
					ExpenseMaster findmaster = (ExpenseMaster) hs.load(
							ExpenseMaster.class, new Long(chk[i]));
					if (findmaster.getApprovalDate() != null) {
						findmaster.setStatus(ToStatus);
						Iterator itAmt = findmaster.getAmounts().iterator();
						TransactionServices trs = new TransactionServices();
						if (findmaster.getReceiptDate() == null
								&& ToStatus.equals("Claimed")) {
							findmaster.setReceiptDate(UtilDateTime
									.nowTimestamp());
							while (itAmt.hasNext()) {
								ExpenseAmount ea = (ExpenseAmount) itAmt.next();
								if (ea.getPaidAmount() == null)
									ea.setPaidAmount(ea.getConfirmedAmount());
								hs.update(ea);
							}
							if (findmaster.getFAConfirmDate() == null) {
								findmaster.setFAConfirmDate(UtilDateTime
										.nowTimestamp());
								hs.update(findmaster);
							}
							EmailService.notifyUser(findmaster);
							UserLogin ul = (UserLogin) request.getSession()
									.getAttribute(Constants.USERLOGIN_KEY);
							trs.insert(findmaster, ul);
						}

						hs.update(findmaster);

						if (ToStatus.equals("Confirmed")) {
							while (itAmt.hasNext()) {
								ExpenseAmount ea = (ExpenseAmount) itAmt.next();
								if (ea.getPaidAmount() == null)
									ea.setPaidAmount(ea.getConfirmedAmount());
								hs.update(ea);
							}
							if (findmaster.getFAConfirmDate() == null) {
								findmaster.setFAConfirmDate(UtilDateTime
										.nowTimestamp());
								hs.update(findmaster);
							}
							EmailService.notifyUser(findmaster);
							UserLogin ul = (UserLogin) request.getSession()
									.getAttribute(Constants.USERLOGIN_KEY);
							trs.insert(findmaster, ul);
						}
						if (ToStatus.equals("F&A Rejected")) {
							findmaster.setApprovalDate(null);
							findmaster.setClaimExportDate(null);
							findmaster.setReceiptDate(null);
							findmaster.setVerifyDate(null);
							findmaster.setVerifyExportDate(null);
							findmaster.setFAConfirmDate(null);
							hs.update(findmaster);
							while (itAmt.hasNext()) {
								ExpenseAmount ea = (ExpenseAmount) itAmt.next();
								ea.setConfirmedAmount(null);
								ea.setPaidAmount(null);
								hs.update(ea);
							}

							UserLogin ul = (UserLogin) request.getSession()
									.getAttribute(Constants.USERLOGIN_KEY);
							trs.delete(findmaster, ul);
							try {
								EmailService.notifyUser(findmaster);
							} catch (Exception e) {
							}
						}
					}
				}
				tx.commit();
				hs.flush();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private ActionForward ExportList(HttpServletRequest request,
			HttpServletResponse response, List result) {
		try {
			Iterator itExp = result.iterator();
			if (itExp.hasNext()) {
				net.sf.hibernate.Session hs = Hibernate2Session
						.currentSession();

				// Get Excel Template Path
				String TemplatePath = (new ReportBaseAction())
						.GetTemplateFolder();
				if (TemplatePath == null)
					return null;
				Date nowDate = (java.util.Date) UtilDateTime.nowTimestamp();
				// Start to output the excel file
				response.reset();
				response.setHeader("Content-Disposition",
						"attachment;filename=\"" + SaveToFileName + "\"");
				response.setContentType("application/octet-stream");

				// Use POI to read the selected Excel Spreadsheet
				HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(
						TemplatePath + "\\" + ExcelTemplate));
				// Select the first worksheet
				HSSFSheet sheet = wb.getSheet(FormSheetName);
				// Header
				HSSFCell cell = null;
				HSSFRow HRow = null;
				// cell styple
				HSSFCellStyle NumStyle = sheet.getRow(0).getCell((short) 3)
						.getCellStyle();
				HSSFCellStyle DateStyle = sheet.getRow(0).getCell((short) 4)
						.getCellStyle();
				HSSFCellStyle RateStyle = sheet.getRow(0).getCell((short) 5)
						.getCellStyle();

				HSSFCellStyle YTextStyle = sheet.getRow(4).getCell((short) 0)
						.getCellStyle();
				HSSFCellStyle YNumStyle = sheet.getRow(4).getCell((short) 3)
						.getCellStyle();
				HSSFCellStyle YDateStyle = sheet.getRow(4).getCell((short) 2)
						.getCellStyle();
				HSSFCellStyle YRateStyle = sheet.getRow(4).getCell((short) 6)
						.getCellStyle();

				DateFormat df = new SimpleDateFormat("yyyy-MM-dd",
						Locale.ENGLISH);
				DateFormat dfy = new SimpleDateFormat("yyyy", Locale.ENGLISH);
				DateFormat dfm = new SimpleDateFormat("MM", Locale.ENGLISH);
				float AmtClaim = 0;
				float tlBaseAmt = 0;
				float tlOtherAmt = 0;
				float rate = 0;
				float splitAmt = 0;
//				Date aDate = null;
				String CmtsValue = "";
				int ExcelRow = ListStartRow;
//				Object[] findResult = null;
				NumberFormat Num_formater2 = NumberFormat.getInstance();
				Num_formater2.setMaximumFractionDigits(2);
				Num_formater2.setMinimumFractionDigits(2);
				NumberFormat Num_formater4 = NumberFormat.getInstance();
				Num_formater4.setMaximumFractionDigits(4);
				Num_formater4.setMinimumFractionDigits(4);
				Transaction tx = hs.beginTransaction();
				while (itExp.hasNext()) {
					// findResult = (Object[])itExp.next();
					ExpenseMaster findmaster = (ExpenseMaster) itExp.next();
					// FMonth fm = (FMonth)findResult[1];
					findmaster.setClaimExportDate(nowDate);
					hs.update(findmaster);
					tlBaseAmt = 0;
					tlOtherAmt = 0;
					rate = 0;
//					aDate = null;
					Iterator itExpAmt = findmaster.getAmounts().iterator();
					while (itExpAmt.hasNext()) {
						ExpenseAmount ea = (ExpenseAmount) itExpAmt.next();
						String user = ea.getExpMaster().getExpenseUser()
								.getUserLoginId();

//						aDate = null;
						String AccountCode = "";
						String AccountDesc = "";
						if (findmaster.getClaimType().equals("CY")) {
							AccountCode = ea.getExpType().getExpCode();
							AccountDesc = ea.getExpType().getExpDesc();
						} else {
							
							if(ea.getExpMaster().getExpenseUser().getAccountType().equalsIgnoreCase("indirect"))
								AccountCode = "5141"+ea.getExpType().getExpBillCode();
							else if(ea.getExpMaster().getExpenseUser().getAccountType().equalsIgnoreCase("direct"))
								AccountCode = "5131"+ea.getExpType().getExpBillCode();
						}
						if (AccountCode == null)
							AccountCode = "";
						if (AccountDesc == null)
							AccountDesc = "";

						AmtClaim = 0;
						float exRate = findmaster.getCurrencyRate()
								.floatValue();
						if (ea.getPaidAmount() != null) {
							AmtClaim = ea.getPaidAmount().floatValue();
							splitAmt = AmtClaim / 3;

						} else {
							AmtClaim = ea.getConfirmedAmount().floatValue();
							splitAmt = AmtClaim / 3;

						}
						if (AmtClaim != 0) {
							if (user.equals("CN01264")
									|| user.equals("CN01305")) {
								for (int ii = 0; ii < 4; ii++) {										
									float tempAmt = splitAmt;
									if((ii==0)||(ii==1))
										tempAmt = splitAmt/2;
									HRow = sheet.createRow(ExcelRow);
									cell = HRow.createCell((short) 0); // Account
									// Code
									cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
									cell
											.setCellValue(AccountCode
													.toUpperCase());

									cell = HRow.createCell((short) 1); // Period
									cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
									// cell.setCellValue(fm.getYear().toString()+"/"+fillPreZero(fm.getMonthSeq()+1,3));
									cell.setCellValue(dfy.format(findmaster
											.getClaimExportDate())
											+ "0"
											+ dfm.format(findmaster
													.getClaimExportDate()));

									cell = HRow.createCell((short) 2); // Period
									cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
									if (findmaster.getClaimExportDate() != null) {
										cell.setCellValue(df.format(findmaster
												.getClaimExportDate()));
//										aDate = findmaster.getClaimExportDate();
									} else {
										cell.setCellValue(nowDate);
									}
									cell.setCellStyle(DateStyle);

									cell = HRow.createCell((short) 3); // Base
									// Amount

									cell.setCellValue(tempAmt * exRate);
									// }
									cell.setCellStyle(NumStyle);
									tlBaseAmt = tlBaseAmt + (tempAmt * exRate);

									cell = HRow.createCell((short) 4); // Other
									// Amount
									if (tempAmt == 0) {
										cell.setCellValue("");
									} else {
										cell.setCellValue(tempAmt);
									}
									cell.setCellStyle(NumStyle);
									tlOtherAmt = tlOtherAmt + tempAmt;

									cell = HRow.createCell((short) 5); // Currency
									cell.setCellValue(findmaster
											.getExpenseCurrency().getCurrId()
											.toUpperCase());

									cell = HRow.createCell((short) 6); // Rate
									cell.setCellValue(exRate);
									cell.setCellStyle(RateStyle);
									rate = exRate;

									cell = HRow.createCell((short) 7); // Transaction
									// Reference
									cell.setCellValue(findmaster.getFormCode()
											.toUpperCase());

									cell = HRow.createCell((short) 8); // Description
									CmtsValue = findmaster.getExpenseUser()
											.getName().toUpperCase()
											+ ":"
											+ ea.getExpType().getExpDesc()
													.toUpperCase();
									cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
									cell.setCellValue(CmtsValue);

									cell = HRow.createCell((short) 9); // T1
									// Analysis
									// Code
									if (ii == 0) {
										cell.setCellValue("AS-GW");
									} else if (ii == 1) {
										cell.setCellValue("AS-MD");
									} else if (ii == 2) {
										cell.setCellValue("OES-QAD 1");
									}else if (ii == 3) {
										cell.setCellValue("OES-SAP");
									}

									cell = HRow.createCell((short) 10); // T2
									// Analysis
									// Code
									if(findmaster.getProject().getProjId().startsWith("IB")&&findmaster.getProject().getContractGroup().equalsIgnoreCase("presale"))
										cell.setCellValue("Gen");
									else
										cell.setCellValue(findmaster.getProject()
											.getCustomer().getT2Code()
											.getT2Code().toUpperCase());

									cell = HRow.createCell((short) 11); // T3
									// Analysis
									// Code
									if (!findmaster.getProject().getCustomer()
											.getT2Code().getT2Code().equals(
													"GEN")) {
										cell.setCellValue(findmaster
												.getProject().getContractNo()
												.toUpperCase());
									} else {
										cell.setCellValue("");
									}
									ExcelRow++;
								}

							} else {
								// --------------------------...........................
								HRow = sheet.createRow(ExcelRow);
								cell = HRow.createCell((short) 0); // Account
								// Code
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
								cell.setCellValue(AccountCode.toUpperCase());

								cell = HRow.createCell((short) 1); // Period
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
								// cell.setCellValue(fm.getYear().toString()+"/"+fillPreZero(fm.getMonthSeq()+1,3));
								cell.setCellValue(dfy.format(findmaster
										.getClaimExportDate())
										+ "0"
										+ dfm.format(findmaster
												.getClaimExportDate()));

								cell = HRow.createCell((short) 2); // Period
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
								if (findmaster.getClaimExportDate() != null) {
									cell.setCellValue(df.format(findmaster
											.getClaimExportDate()));
//									aDate = findmaster.getClaimExportDate();
								} else {
									cell.setCellValue(nowDate);
								}
								cell.setCellStyle(DateStyle);

								cell = HRow.createCell((short) 3); // Base
								// Amount

								cell.setCellValue(AmtClaim * exRate);
								// }
								cell.setCellStyle(NumStyle);
								tlBaseAmt = tlBaseAmt + (AmtClaim * exRate);

								cell = HRow.createCell((short) 4); // Other
								// Amount
								if (splitAmt == 0) {
									cell.setCellValue("");
								} else {
									cell.setCellValue(AmtClaim);
								}
								cell.setCellStyle(NumStyle);
								tlOtherAmt = tlOtherAmt + AmtClaim;

								cell = HRow.createCell((short) 5); // Currency
								cell.setCellValue(findmaster
										.getExpenseCurrency().getCurrId()
										.toUpperCase());

								cell = HRow.createCell((short) 6); // Rate
								cell.setCellValue(exRate);
								cell.setCellStyle(RateStyle);
								rate = exRate;

								cell = HRow.createCell((short) 7); // Transaction
								// Reference
								cell.setCellValue(findmaster.getFormCode()
										.toUpperCase());

								cell = HRow.createCell((short) 8); // Description
								CmtsValue = findmaster.getExpenseUser()
										.getName().toUpperCase()
										+ ":"
										+ ea.getExpType().getExpDesc()
												.toUpperCase();
								cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
								cell.setCellValue(CmtsValue);

								cell = HRow.createCell((short) 9); // T1
								// Analysis
								// Code
								if (user.equals("CN01606")
										|| user.equals("CN01608")
										|| user.equals("CN01607")) {
									cell.setCellValue("AS-EC");
								} else {
									if(user.endsWith("CN01578")) //QUEENIE
										cell.setCellValue("AS-MD");
									else if(user.endsWith("CN01683"))//CATHY
										cell.setCellValue("AS-GW");
									else if(user.endsWith("CN01516"))//JAXEY
										cell.setCellValue("OES-QAD 1");
									else if(user.endsWith("CN01294"))//JASMINE
										cell.setCellValue("OES-SAP");
									else if(user.endsWith("CN01185"))//SABRINA
										cell.setCellValue("OES-QAD 2");
									else cell.setCellValue(findmaster.getProject()
											.getDepartment().getNote()
											.toUpperCase());
								}

								cell = HRow.createCell((short) 10); // T2
								// Analysis
								// Code
								if(findmaster.getProject().getProjId().startsWith("IB")&&findmaster.getProject().getContractGroup().equalsIgnoreCase("presale"))
									cell.setCellValue("Gen");	
								else
									cell.setCellValue(findmaster.getProject()
										.getCustomer().getT2Code().getT2Code()
										.toUpperCase());

								cell = HRow.createCell((short) 11); // T3
								// Analysis
								// Code
								if (!findmaster.getProject().getCustomer()
										.getT2Code().getT2Code().equals("GEN")) {
									cell.setCellValue(findmaster.getProject()
											.getContractNo().toUpperCase());
								} else {
									cell.setCellValue("");
								}
								ExcelRow++;
							}
						}
					}
					// --------------------
					HRow = sheet.createRow(ExcelRow);
					cell = HRow.createCell((short) 0); // Account Code
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellValue("1111510033");
					cell.setCellStyle(YTextStyle);

					cell = HRow.createCell((short) 1); // Period
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					// cell.setCellValue(fm.getYear().toString()+"/"+fillPreZero(fm.getMonthSeq()+1,3));
					cell
							.setCellValue(dfy.format(findmaster
									.getClaimExportDate())
									+ "0"
									+ dfm.format(findmaster
											.getClaimExportDate()));
					cell.setCellStyle(YTextStyle);

					cell = HRow.createCell((short) 2); // Period
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellValue(df
							.format(findmaster.getClaimExportDate()));
					cell.setCellStyle(YDateStyle);

					cell = HRow.createCell((short) 3); // Base Amount
					cell.setCellValue(0 - tlBaseAmt);
					cell.setCellStyle(YNumStyle);

					cell = HRow.createCell((short) 4); // Other Amount
					cell.setCellValue(0 - tlOtherAmt);
					cell.setCellStyle(YNumStyle);

					cell = HRow.createCell((short) 5); // Currency
					cell.setCellValue(findmaster.getExpenseCurrency()
							.getCurrId().toUpperCase());
					cell.setCellStyle(YTextStyle);

					cell = HRow.createCell((short) 6); // Rate
					cell.setCellValue(rate);
					cell.setCellStyle(YRateStyle);

					cell = HRow.createCell((short) 7); // Transaction Reference
					cell.setCellValue(findmaster.getFormCode().toUpperCase());
					cell.setCellStyle(YTextStyle);

					cell = HRow.createCell((short) 8); // Description
					// CmtsValue =
					// findmaster.getExpenseUser().getName()+":"+ea.getExpType().getExpDesc();
					cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
					cell.setCellValue(findmaster.getExpenseUser().getName()
							.toUpperCase()
							+ ":EXPENSE");
					cell.setCellStyle(YTextStyle);

					cell = HRow.createCell((short) 9); // T1 Analysis Code
					// cell.setCellValue(findmaster.getProject().getDepartment().getNote().toUpperCase());
					cell.setCellValue("A");
					cell.setCellStyle(YTextStyle);

					cell = HRow.createCell((short) 10); // T2 Analysis Code
					// cell.setCellValue(findmaster.getProject().getCustomer().getT2Code().getT2Code().toUpperCase());
					cell.setCellValue("ALL");
					cell.setCellStyle(YTextStyle);

					cell = HRow.createCell((short) 11); // T3 Analysis Code
					if (!findmaster.getProject().getCustomer().getT2Code()
							.getT2Code().equals("GEN")) {
						cell.setCellValue(findmaster.getProject()
								.getContractNo().toUpperCase());
					} else {
						cell.setCellValue("");
					}
					cell.setCellStyle(YTextStyle);

					cell = HRow.createCell((short) 12); // T3 Analysis Code
					cell.setCellValue("A17");
					cell.setCellStyle(YTextStyle);
					ExcelRow++;

					// --------------------

				}
				// 写入Excel工作表
				wb.write(response.getOutputStream());
				// 关闭Excel工作薄对象
				response.getOutputStream().close();
				response.setStatus(HttpServletResponse.SC_OK);
				response.flushBuffer();
				tx.commit();
				hs.flush();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private ActionForward ExportExcel4BJ(HttpServletRequest request,
			HttpServletResponse response, List result) {
		try {
			ExpenseMaster mstr = new ExpenseMaster();
			result.add(mstr);
			Iterator itExp = result.iterator();
			if (itExp.hasNext()) {
				net.sf.hibernate.Session hs = Hibernate2Session
						.currentSession();
				List typeList = hs
						.createQuery(
								"select et from ExpenseType as et order by et.expSeq ASC")
						.list();

				// Get Excel Template Path
				String TemplatePath = (new ReportBaseAction())
						.GetTemplateFolder();
				if (TemplatePath == null)
					return null;
				Date nowDate = (java.util.Date) UtilDateTime.nowTimestamp();
				// Start to output the excel file
				response.reset();
				response.setHeader("Content-Disposition",
						"attachment;filename=\"" + SaveToFileName + "\"");
				response.setContentType("application/octet-stream");

				// Use POI to read the selected Excel Spreadsheet
				HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(
						TemplatePath + "\\" + ExcelTemplate2));
				// Select the first worksheet
				HSSFSheet sheet = wb.getSheet(FormSheetName);
				// Header
				HSSFCell cell = null;
				HSSFRow HRow = null;
				// cell styple
				HSSFCellStyle txtStyle = sheet.getRow(0).getCell((short) 1)
						.getCellStyle();
				HSSFCellStyle NumStyle = sheet.getRow(0).getCell((short) 5)
						.getCellStyle();

				float typeAmt[] = new float[typeList.size()];
				for (int i = 0; i < typeList.size(); i++) {
					typeAmt[i] = 0;
				}
				int ExcelRow = 0;
				NumberFormat Num_formater2 = NumberFormat.getInstance();
				Num_formater2.setMaximumFractionDigits(2);
				Num_formater2.setMinimumFractionDigits(2);
				Transaction tx = hs.beginTransaction();
				UserLogin ul = null;
				String prefix = "";
				float totAmt = 0;
				while (itExp.hasNext()) {
					ExpenseMaster findmaster = (ExpenseMaster) itExp.next();
					if (findmaster.getExpenseUser() != null) {
						findmaster.setClaimExportDate(nowDate);
						hs.update(findmaster);
					}

					if (ul == null)
						ul = findmaster.getExpenseUser();
					if ((findmaster.getExpenseUser() == null)
							|| (((ul != null)) && (!findmaster.getExpenseUser()
									.getUserLoginId().equalsIgnoreCase(
											ul.getUserLoginId())))) {
						if(ul.getAccountType().equalsIgnoreCase("indirect"))
							prefix = "5141";
						else if(ul.getAccountType().equalsIgnoreCase("direct"))
							prefix = "5131";
						// write to excel
						for (int c = 0; c < typeList.size(); c++) {
							ExpenseType et = (ExpenseType) typeList.get(c);

							HRow = sheet.createRow(ExcelRow);
							cell = HRow.createCell((short) 1); // user
							// login id
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
							cell.setCellValue(ul.getUserLoginId().toUpperCase());
							cell.setCellStyle(txtStyle);

							cell = HRow.createCell((short) 2); // user
							// department
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
							cell.setCellValue(ul.getParty().getNote());							
//							cell.setCellValue(ul.getParty().getDescription());
							cell.setCellStyle(txtStyle);

							cell = HRow.createCell((short) 3); // c or d
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
							cell.setCellValue("D");
							cell.setCellStyle(txtStyle);

							cell = HRow.createCell((short) 4); // accound
							// code
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
							cell
									.setCellValue(prefix+getAccountCode4BJ(et
											.getExpDesc()));
							cell.setCellStyle(NumStyle);

							cell = HRow.createCell((short) 5); // amount
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
							if (typeAmt[c] != 0)
								cell.setCellValue(Num_formater2
										.format(typeAmt[c]));
							totAmt += typeAmt[c];
							typeAmt[c] = 0;
							cell.setCellStyle(NumStyle);

							cell = HRow.createCell((short) 6); // description
							cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
							cell.setCellValue(ul.getName()+et.getExpDesc());
							cell.setCellStyle(txtStyle);

							ExcelRow++;
						}

						HRow = sheet.createRow(ExcelRow);
						cell = HRow.createCell((short) 1); // user login id
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(ul.getUserLoginId().toUpperCase());
						cell.setCellStyle(txtStyle);

						cell = HRow.createCell((short) 2); // user
						// department
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(ul.getParty().getNote());							
//						cell.setCellValue(ul.getParty().getDescription());
						cell.setCellStyle(txtStyle);

						cell = HRow.createCell((short) 3); // c or d
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue("C");
						cell.setCellStyle(txtStyle);

						cell = HRow.createCell((short) 4); // accound code
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue("21814200P");
						cell.setCellStyle(txtStyle);

						cell = HRow.createCell((short) 5); // amount
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue(Num_formater2.format(totAmt));
						cell.setCellStyle(NumStyle);

						cell = HRow.createCell((short) 6); // description
						cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
						cell.setCellValue("Total" + ul.getName());
						cell.setCellStyle(txtStyle);

						ExcelRow++;

						// reset user
						totAmt = 0;
						ul = findmaster.getExpenseUser();
					}
					if (findmaster.getExpenseUser() != null) {
						Iterator itExpAmt = findmaster.getAmounts().iterator();

						while (itExpAmt.hasNext()) {
							ExpenseAmount ea = (ExpenseAmount) itExpAmt.next();
							int typeIndex = -1;
							typeIndex = typeList.indexOf(ea.getExpType());
							if (typeIndex > -1) {
								if (ea.getPaidAmount() != null)
									typeAmt[typeIndex] += ea.getPaidAmount()
											.floatValue();
								else
									typeAmt[typeIndex] += ea.getConfirmedAmount()
									.floatValue();									
							}
						}
					}

				}
				// 写入Excel工作表
				wb.write(response.getOutputStream());
				// 关闭Excel工作薄对象
				response.getOutputStream().close();
				response.setStatus(HttpServletResponse.SC_OK);
				response.flushBuffer();
				tx.commit();
				hs.flush();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	private String getAccountCode4BJ(String seq) {
		if (seq.equalsIgnoreCase("Hotel")) {
			return "6251";
		} else if (seq.equalsIgnoreCase("Meal")) {
			return "6252";
		} else if (seq.equalsIgnoreCase("Transport(Travel)")) {
			return "6251";
		} else if (seq.equalsIgnoreCase("Allowance")) {
			return "6420";
		} else if (seq.equalsIgnoreCase("Telephones")) {
			return "6261";
		} else if (seq.equalsIgnoreCase("Misc")) {
			return "6062";
		} else if (seq.equalsIgnoreCase("Transport(OT)")) {
			return "6252";
		}else if (seq.equalsIgnoreCase("Entertainment")) {
			return "6231";
		}
		return "";
	}

	private String fillPreZero(int no, int len) {
		String s = String.valueOf(no);
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < len - s.length(); i++) {
			sb.append('0');
		}
		sb.append(s);
		return sb.toString();
	}

	private final static String ExcelTemplate = "expenseload.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Exported Expense Data.xls";

	private final static String ExcelTemplate2 = "expenseloadBJ.xls";

	private final int ListStartRow = 4;
}

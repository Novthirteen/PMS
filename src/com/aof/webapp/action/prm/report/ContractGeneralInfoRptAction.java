package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.prm.contract.FindContractProfileAction;

public class ContractGeneralInfoRptAction extends ReportBaseAction {

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

		Logger log = Logger.getLogger(FindContractProfileAction.class.getName());

		try {
			String action = request.getParameter("formAction");
			String textContract = request.getParameter("textContract");
			String textCustomer = request.getParameter("textCustomer");
			String textContractType = request.getParameter("textContractType");
			String textStatus = request.getParameter("textStatus");
			String textDept = request.getParameter("textDept");
			String textSignDateFrom = request.getParameter("textSignDateFrom");
			String textSignDateTo = request.getParameter("textSignDateTo");
			String textCreateDateFrom = request.getParameter("textCreateDateFrom");
			String textCreateDateTo = request.getParameter("textCreateDateTo");
			String textProjCode = request.getParameter("textProjCode");

			if (action == null || action.equals("")) {
				action = "view";
			}

			if (textContract == null) {
				textContract = "";
			}
			if (textCustomer == null) {
				textCustomer = "";
			}
			if (textContractType == null) {
				textContractType = "";
			}
			if (textStatus == null) {
				textStatus = "";
			}
			if (textDept == null) {
				textDept = "";
			}
			if (textSignDateFrom == null) {
				textSignDateFrom = "";
			}
			if (textSignDateTo == null) {
				textSignDateTo = "";
			}
			if (textCreateDateFrom == null) {
				textCreateDateFrom = "";
			}
			if (textCreateDateTo == null) {
				textCreateDateTo = "";
			}
			if (textProjCode == null) {
				textProjCode = "";
			}

			Session session = Hibernate2Session.currentSession();

			PartyHelper ph = new PartyHelper();

			List partyList = null;
			UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			partyList = ph.getAllSubPartysByPartyId(session, ul.getParty().getPartyId());
			if (partyList == null)
				partyList = new ArrayList();
			partyList.add(0, ul.getParty());

			request.setAttribute("partyList", partyList);

			if (action.equals("query")) {

				SQLResults result = queryResult(textContract, textCustomer, textContractType,
						textStatus, textDept, textSignDateFrom, textSignDateTo, textCreateDateFrom,
						textCreateDateTo, textProjCode);

				request.setAttribute("result", result);
			}

			if (action.equals("export")) {
				SQLResults result = queryResult(textContract, textCustomer, textContractType,
						textStatus, textDept, textSignDateFrom, textSignDateTo, textCreateDateFrom,
						textCreateDateTo, textProjCode);
				return exportToExcel(result, response);
			}

		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
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
		return (mapping.findForward("success"));
	}

	private SQLResults queryResult(String textContract, String textCustomer,
			String textContractType, String textStatus, String textDept, String textSignDateFrom,
			String textSignDateTo, String textCreateDateFrom, String textCreateDateTo,
			String textProjCode) {

		String strSQL = "";
		String strWhere = "";
		String strOrder = "order by contract_no";

		strSQL = "select ";
		strSQL += "cp.cp_no as contract_no, ";
		strSQL += "acc_man.name as account_manager, ";
		strSQL += "cp.cp_total_contract_value as total_contract_value, ";
		strSQL += "cp.cp_signed_date as signed_date, ";
		strSQL += "cp.cp_create_date as create_date, ";
		strSQL += "cp.cp_legal_review_date as legal_review_date, ";
		strSQL += "cp.cust_sat as customer_sat, ";
		strSQL += "cp.cp_start_date as start_date, ";
		strSQL += "cp.cp_end_date as end_date, ";
		strSQL += "cp.cp_status as contract_status, ";
		strSQL += "cp.cp_contract_type as contract_type, ";
		strSQL += "pm.proj_id as project_code, ";
		strSQL += "pm.proj_name as project_name, ";
		strSQL += "dept.description as department, ";
		strSQL += "cust.description as customer, ";
		strSQL += "parent.proj_name as parent_proj_name, ";
		strSQL += "cp.cp_allowance as customer_paid_allowance, ";
		strSQL += "projman.name as project_manager, ";
		strSQL += "pa.name as project_assistant, ";
		strSQL += "billto.description as bill_to, ";
		strSQL += "pm.contact_person as contact_person, ";
		strSQL += "pm.contact_tele as contact_tel, ";
		strSQL += "pm.cust_pm as customer_pm, ";
		strSQL += "pm.cust_pm_tele as customer_pm_tel, ";
		strSQL += "pm.Proj_CAF_Flag as caf_flag, ";
		strSQL += "pm.renew_Flag as renew_flag ";
		strSQL += "from Contract_Profile as cp ";
		strSQL += "left join Proj_Mstr as pm on cp.cp_no = pm.proj_contract_no ";
		strSQL += "left join user_login as acc_man on cp.cp_account_manager = acc_man.user_login_id ";
		strSQL += "left join party as cust on pm.cust_id = cust.party_id ";
		strSQL += "left join party as dept on cp.cp_department = dept.party_id ";
		strSQL += "left join Proj_Mstr as parent on pm.parent_proj_id = parent.proj_id ";
		strSQL += "left join user_login as projman on pm.proj_pm_user = projman.user_login_id ";
		strSQL += "left join user_login as pa on pm.proj_pa_id = pa.user_login_id ";
		strSQL += "left join party as billto on billto.party_id = pm.Proj_billaddr_id ";

		if (!textContract.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and (cp.cp_no like '%" + textContract
						+ "%' or cp.cp_description like '%" + textContract + "%') ";
			} else {
				strWhere = "  where (cp.cp_no like '%" + textContract
						+ "%' or cp.cp_description like '%" + textContract + "%') ";
			}
		}

		if (!textCustomer.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and (cust.description like '%" + textCustomer + "%') ";
			} else {
				strWhere = "  where (cust.description like '%" + textCustomer + "%') ";
			}
		}

		if (!textDept.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and (dept.party_id like '%" + textDept + "%') ";
			} else {
				strWhere = "  where (dept.party_id like '%" + textDept + "%') ";
			}
		}

		if (!textContractType.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and cp.cp_contract_type = '" + textContractType + "' ";
			} else {
				strWhere = "  where cp.cp_contract_type = '" + textContractType + "' ";
			}
		}

		if (!textStatus.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and cp.cp_status = '" + textStatus + "' ";
			} else {
				strWhere = " where cp.cp_status = '" + textStatus + "' ";
			}
		}

		if (!textSignDateFrom.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and cp.cp_signed_date > '" + textSignDateFrom + "' ";
			} else {
				strWhere = " where cp.cp_signed_date > '" + textSignDateFrom + "' ";
			}
		}

		if (!textSignDateTo.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and cp.cp_signed_date < '" + textSignDateTo + "' ";
			} else {
				strWhere = " where cp.cp_signed_date < '" + textSignDateTo + "' ";
			}
		}

		if (!textCreateDateFrom.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and cp.cp_create_date > '" + textCreateDateFrom + "' ";
			} else {
				strWhere = " where cp.cp_create_date > '" + textCreateDateFrom + "' ";
			}
		}

		if (!textCreateDateTo.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and cp.cp_create_date < '" + textCreateDateTo + "' ";
			} else {
				strWhere = " where cp.cp_create_date < '" + textCreateDateTo + "' ";
			}
		}

		if (!textProjCode.trim().equals("")) {
			if (!strWhere.equals("")) {
				strWhere += "  and pm.proj_id like '%" + textProjCode + "%' ";
			} else {
				strWhere = " where pm.proj_id like '%" + textCreateDateTo + "%' ";
			}
		}
		String strQuery = strSQL + strWhere + strOrder;

		System.out.println("\n" + strQuery + "\n");

		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));

		SQLResults result = null;

		result = sqlExec.runQueryCloseCon(strQuery);

		return result;
	}

	private ActionForward exportToExcel(SQLResults result, HttpServletResponse response) {
		try {
			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
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

			HSSFCellStyle normalTextStyle = sheet.getRow(ListStartRow).getCell((short) 0)
					.getCellStyle();
			HSSFCellStyle normalNumberStyle = sheet.getRow(ListStartRow).getCell((short) 2)
					.getCellStyle();
			HSSFCellStyle normalDateStyle = sheet.getRow(ListStartRow).getCell((short) 3)
					.getCellStyle();

			HSSFRow HRow = null;
			HSSFCell cell = null;

			int excelRow = ListStartRow;

			for (int row = 0; result != null && row < result.getRowCount(); row++) {

				HRow = sheet.createRow(excelRow);

				// Contract No.
				String contractNo = "";
				String tmpContractNo = result.getString(row, "contract_no");
				if (tmpContractNo != null) {
					contractNo = tmpContractNo;
				}
				cell = HRow.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(contractNo);
				cell.setCellStyle(normalTextStyle);

				// Account Manager
				String accountManager = "";
				String tmpAccountManager = result.getString(row, "account_manager");
				if (tmpAccountManager != null) {
					accountManager = tmpAccountManager;
				}
				cell = HRow.createCell((short) 1);
				cell.setCellValue(accountManager);
				cell.setCellStyle(normalTextStyle);

				// Total Contract Value
				String strTotalValue = "0.00";
				double totalValue = result.getDouble(row, "total_contract_value");
				if (totalValue >= 0) {
					strTotalValue = numFormater.format(totalValue);
				}
				cell = HRow.createCell((short) 2);
				cell.setCellValue(strTotalValue);
				cell.setCellStyle(normalNumberStyle);

				// Signed Date
				String strSignedDate = "";
				Date signedDate = result.getDate(row, "signed_date");
				if (signedDate != null) {
					strSignedDate = dateFormater.format(signedDate);
				}
				cell = HRow.createCell((short) 3);
				cell.setCellValue(strSignedDate);
				cell.setCellStyle(normalDateStyle);

				// Create Date
				String strCreateDate = "";
				Date createDate = result.getDate(row, "create_date");
				if (createDate != null) {
					strCreateDate = dateFormater.format(createDate);
				}
				cell = HRow.createCell((short) 4);
				cell.setCellValue(strCreateDate);
				cell.setCellStyle(normalDateStyle);

				// Legal Review Date
				String strLegalReviewDate = "";
				Date legalReviewDate = result.getDate(row, "legal_review_date");
				if (legalReviewDate != null) {
					strLegalReviewDate = dateFormater.format(legalReviewDate);
				}
				cell = HRow.createCell((short) 5);
				cell.setCellValue(strLegalReviewDate);
				cell.setCellStyle(normalDateStyle);

				// customer sat
				String custSat = "";
				String tmpSat = result.getString(row, "customer_sat");
				if (tmpSat != null) {
					custSat = tmpSat;
				}
				cell = HRow.createCell((short) 6);
				cell.setCellValue(custSat);
				cell.setCellStyle(normalTextStyle);

				// start date
				String strStartDate = "";
				Date startDate = result.getDate(row, "start_date");
				if (startDate != null) {
					strStartDate = dateFormater.format(startDate);
				}
				cell = HRow.createCell((short) 7);
				cell.setCellValue(strStartDate);
				cell.setCellStyle(normalDateStyle);

				// end date
				String strEndDate = "";
				Date endDate = result.getDate(row, "end_date");
				if (endDate != null) {
					strEndDate = dateFormater.format(endDate);
				}
				cell = HRow.createCell((short) 8);
				cell.setCellValue(strEndDate);
				cell.setCellStyle(normalDateStyle);

				// close status
				String status = "";
				String tmpStatus = result.getString(row, "contract_status");
				if (tmpStatus != null) {
					status = tmpStatus;
				}
				cell = HRow.createCell((short) 9);
				cell.setCellValue(status);
				cell.setCellStyle(normalTextStyle);

				// contract type
				String contractType = "";
				String tmpContractType = result.getString(row, "contract_type");
				if (tmpContractType != null) {
					contractType = tmpContractType;
				}
				cell = HRow.createCell((short) 10);
				cell.setCellValue(contractType);
				cell.setCellStyle(normalTextStyle);

				// Project Code
				String projectCode = "";
				String tmpProjectCode = result.getString(row, "project_code");
				if (tmpProjectCode != null) {
					projectCode = tmpProjectCode;
				}
				cell = HRow.createCell((short) 11);
				cell.setCellValue(projectCode);
				cell.setCellStyle(normalTextStyle);

				// Project Description
				String projectDesc = "";
				String tmpProjectDesc = result.getString(row, "project_name");
				if (tmpProjectDesc != null) {
					projectDesc = tmpProjectDesc;
				}
				cell = HRow.createCell((short) 12);
				cell.setCellValue(projectDesc);
				cell.setCellStyle(normalTextStyle);

				// Department
				String dept = "";
				String tmpDept = result.getString(row, "department");
				if (tmpDept != null) {
					dept = tmpDept;
				}
				cell = HRow.createCell((short) 13);
				cell.setCellValue(dept);
				cell.setCellStyle(normalTextStyle);

				// Customer
				String customer = "";
				String tmpCustomer = result.getString(row, "customer");
				if (tmpCustomer != null) {
					customer = tmpCustomer;
				}
				cell = HRow.createCell((short) 14);
				cell.setCellValue(customer);
				cell.setCellStyle(normalTextStyle);

				// Parent Project
				String parentProject = "";
				String tmpParentProject = result.getString(row, "parent_proj_name");
				if (tmpParentProject != null) {
					parentProject = tmpParentProject;
				}
				cell = HRow.createCell((short) 15);
				cell.setCellValue(parentProject);
				cell.setCellStyle(normalTextStyle);

				// Customer Paid Allowance
				String paidAllow = "";
				double tmpPaidAllow = result.getDouble(row, "customer_paid_allowance");
				if (tmpPaidAllow >= 0) {
					paidAllow = numFormater.format(tmpPaidAllow);
				}
				cell = HRow.createCell((short) 16);
				cell.setCellValue(paidAllow);
				cell.setCellStyle(normalTextStyle);

				// PM
				String pm = "";
				String tmpPM = result.getString(row, "project_manager");
				if (tmpPM != null) {
					pm = tmpPM;
				}
				cell = HRow.createCell((short) 17);
				cell.setCellValue(pm);
				cell.setCellStyle(normalTextStyle);

				// PA
				String pa = "";
				String tmpPA = result.getString(row, "project_assistant");
				if (tmpPA != null) {
					pa = tmpPA;
				}
				cell = HRow.createCell((short) 18);
				cell.setCellValue(pa);
				cell.setCellStyle(normalTextStyle);

				// Bill To
				String billTo = "";
				String tmpBillTo = result.getString(row, "bill_to");
				if (tmpBillTo != null) {
					billTo = tmpBillTo;
				}
				cell = HRow.createCell((short) 19);
				cell.setCellValue(billTo);
				cell.setCellStyle(normalTextStyle);

				// Contact Person
				String contactPerson = "";
				String tmpContactPerson = result.getString(row, "contact_person");
				if (tmpContactPerson != null) {
					contactPerson = tmpContactPerson;
				}
				cell = HRow.createCell((short) 20);
				cell.setCellValue(contactPerson);
				cell.setCellStyle(normalTextStyle);

				// Contact Person Tele
				String contactTel = "";
				String tmpContactTele = result.getString(row, "contact_tel");
				if (tmpContactTele != null) {
					contactTel = tmpContactTele;
				}
				cell = HRow.createCell((short) 21);
				cell.setCellValue(contactTel);
				cell.setCellStyle(normalTextStyle);

				// Customer PM
				String custPM = "";
				String tmpCustPM = result.getString(row, "customer_pm");
				if (tmpCustPM != null) {
					custPM = tmpCustPM;
				}
				cell = HRow.createCell((short) 22);
				cell.setCellValue(custPM);
				cell.setCellStyle(normalTextStyle);

				// Customer PM Tele
				String custPMTel = "";
				String tmpCustPMTel = result.getString(row, "customer_pm_tel");
				if (tmpCustPMTel != null) {
					custPMTel = tmpCustPMTel;
				}
				cell = HRow.createCell((short) 23);
				cell.setCellValue(custPMTel);
				cell.setCellStyle(normalTextStyle);

				// Need CAF
				String caf = "";
				String tmpCAF = result.getString(row, "caf_flag");
				if (tmpCAF != null) {
					if (tmpCAF.equals("Y")) {
						caf = "YES";
					}
					if (tmpCAF.equals("N")) {
						caf = "NO";
					}
				}
				cell = HRow.createCell((short) 24);
				cell.setCellValue(caf);
				cell.setCellStyle(normalTextStyle);

				// Need Renew
				String renew = "";
				String tmpRenew = result.getString(row, "renew_flag");
				if (tmpRenew != null) {
					if (tmpRenew.equals("Y")) {
						renew = "YES";
					}
					if (tmpRenew.equals("N")) {
						renew = "NO";
					}
				}
				cell = HRow.createCell((short) 25);
				cell.setCellValue(renew);
				cell.setCellStyle(normalTextStyle);

				excelRow++;
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

	private final static String ExcelTemplate = "ContractGeneralInformationReport.xls";

	private final static String FormSheetName = "Form";

	private final static String SaveToFileName = "Contract General Information Report.xls";

	private final int ListStartRow = 5;
}

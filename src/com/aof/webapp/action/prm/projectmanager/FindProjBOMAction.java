package com.aof.webapp.action.prm.projectmanager;

import java.io.FileInputStream;
import java.util.HashMap;
import java.util.Iterator;
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

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.ProjPlanBOMST;
import com.aof.component.prm.project.ProjPlanBom;
import com.aof.component.prm.project.ProjPlanBomMaster;
import com.aof.component.prm.project.ProjPlanType;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.project.EditContractProjectAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;

public class FindProjBOMAction extends ReportBaseAction {

	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		String action = request.getParameter("formaction");
		String dep = request.getParameter("dpt");
		String bid_id = request.getParameter("bid_id");
		String proj_id = request.getParameter("proj_id");
		String proj_name = request.getParameter("proj_name");
		String offSet = request.getParameter("offSet");
		String radioid = request.getParameter("radioid");
		String actionType = request.getParameter("actionType");
		if (action == null)
			action = "list";
		if (dep == null)
			dep = "";
		if ((actionType != null) && actionType.equalsIgnoreCase("export"))
			return ExportBOM(radioid, response);

		Logger log = Logger
				.getLogger(EditContractProjectAction.class.getName());
		SQLExecutor sqlExec = new SQLExecutor(Persistencer
				.getSQLExecutorConnection(EntityUtil
						.getConnectionByName("jdbc/aofdb")));
		try {
			String SqlStr;
			String strParty = "(";
			SQLResults sr;

			UserLogin ul = (UserLogin) request.getSession().getAttribute(
					Constants.USERLOGIN_KEY);

			PartyHelper ph = new PartyHelper();
			Session hs = Hibernate2Session.currentSession();
			Party p = (Party) hs.load(Party.class, ul.getParty().getPartyId());
			List depList = ph.getAllSubPartysByPartyId(hs, ul.getParty().getPartyId());
			depList.add(0, p);
			request.setAttribute("depList", depList);
			
			
			if(!dep.equals(""))
			{
				p = (Party) hs.load(Party.class, dep);
				depList = ph.getAllSubPartysByPartyId(hs, dep);
				depList.add(0, p);
				for (int i = 0; i < depList.size(); i++) {
					Party party = (Party) depList.get(i);
					strParty += "'" + party.getPartyId() + "',";
				}
				strParty = strParty.substring(0, strParty.length() - 1) + ")";
			}

			if (action.startsWith("list")) {
				SqlStr = "select distinct(pm.proj_id),bom_id as bom_no,pm.proj_name,bom.version,bom.mst_id,bom.bid_id,"
						+ "bid.bid_no,bid.bid_description, p.description as cust1, pp.description as cust2"
						+ " from proj_plan_bom_mstr as bom "
						+ " left join contract_profile as cp on bom.bid_id = cp.cp_bid_id"
						+ " left join proj_mstr as pm on pm.proj_id = bom.proj_id"
						+ " left join bid_mstr as bid on bom.bid_id = bid.bid_id "
						+ " left join PARTY as p ON p.PARTY_ID = pm.cust_id "
						+ " left join PARTY as pp ON pp.PARTY_ID = bid.bid_prospect_company_id "
						+ " where bom.enable='y'";
				if ((bid_id != null) && (bid_id.length() > 0)) {
					SqlStr = SqlStr + " and bid.bid_no like'%" + bid_id + "%'";
				}

				if ((proj_id != null) && (proj_id.length() > 0)) {
					SqlStr = SqlStr + " and bom.proj_id like'%" + proj_id
							+ "%'";
				}
				if ((proj_name != null) && (proj_name.length() > 0)) {
					SqlStr = SqlStr + " and pm.proj_name like'%" + proj_name
							+ "%'";
				}
//				if () {
					if (dep.equalsIgnoreCase(""))
						SqlStr = SqlStr + " and pm.proj_pm_user = '"
								+ ul.getUserLoginId() + "'";
					else {
						SqlStr = SqlStr
								+ " and isnull(bid.bid_dep_id,pm.dep_id) in "
								+ strParty + "";
					}
				//}  //else  SqlStr = SqlStr + " and bid.bid_dep_id in " + strParty + "";
				if (action.equalsIgnoreCase("listcost"))
					SqlStr = SqlStr + " and bom.reveconfirm ='confirm' ";
				SqlStr += " order by bom.bom_no asc";

				sqlExec = new SQLExecutor(Persistencer
						.getSQLExecutorConnection(EntityUtil
								.getConnectionByName("jdbc/aofdb")));
				sr = sqlExec.runQueryCloseCon(SqlStr);
				request.setAttribute("bomresult", sr);
			}
			request.setAttribute("offSet", offSet);

			if (action.equalsIgnoreCase("listreve"))
				return mapping.findForward("listreve");
			if (action.equalsIgnoreCase("listcost"))
				return mapping.findForward("listcost");
			if (action.equalsIgnoreCase("listtype"))
				return mapping.findForward("listtype");
			if (action.equalsIgnoreCase("listsche"))
				return mapping.findForward("listsche");

		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return mapping.findForward("list");
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return mapping.findForward("list");
	}

	public ActionForward ExportBOM(String masterid, HttpServletResponse response) {
		ProjPlanBomMaster master = null;
		try {
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();

			StringTokenizer stk = new StringTokenizer(masterid, ".");
			masterid = stk.nextToken();
			master = (ProjPlanBomMaster) hs.load(ProjPlanBomMaster.class,
					new Long(masterid));

			Query query = null;
			List bomList = null;
			List stList = null;
			query = hs
					.createQuery("from ProjPlanBom as bom where bom.master.id = ? order by bom.ranking asc");
			query.setLong(0, master.getId());
			bomList = query.list();

			query = hs
					.createQuery("from ProjPlanType as type where type.bom_id = ? and type.parent is null");
			query.setLong(0, master.getBom_id().longValue());
			stList = query.list();

			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""
					+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");

			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath
					+ "\\" + ExcelTemplate));
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			HSSFCellStyle boldTextStyle1 = sheet.getRow(0).getCell((short) 1)
					.getCellStyle();
			HSSFCellStyle stStyle = sheet.getRow(0).getCell((short) 2)
					.getCellStyle();

			HSSFRow row = sheet.createRow(0);
			HSSFCell cell = null;

			cell = row.createCell((short) 1);
			if (master.getBid() != null) {
				cell.setCellValue(master.getBid().getNo() + "-"
						+ master.getBid().getDescription());
			} else if (master.getProject() != null) {
				cell.setCellValue(master.getProject().getProjId() + "-"
						+ master.getProject().getProjName());
			}
			cell.setCellStyle(stStyle);

			row = sheet.createRow(1);
			if (stList != null) {
				for (int i = 0; i < stList.size(); i++) {
					ProjPlanType type = (ProjPlanType) stList.get(i);
					cell = row.createCell((short) (i + 2));
					cell.setCellValue(type.getDescription() + "("
							+ type.getCurrency().getCurrId() + type.getSTRate()
							+ ")");
					cell.setCellStyle(stStyle);
				}
			}

			row = sheet.createRow(2);

			if (bomList != null) {
				for (int i = 0; i < bomList.size(); i++) {
					StringBuffer sb = new StringBuffer();
					ProjPlanBom bom = (ProjPlanBom) bomList.get(i);
					HashMap map = new HashMap();
					Set set = bom.getTypes();
					Iterator it = set.iterator();
					while (it.hasNext()) {
						ProjPlanBOMST st = (ProjPlanBOMST) it.next();
						if (st.getType().getParent() == null) {
							map.put(new Long(st.getType().getId()), st);
						}
					}

					row = sheet.createRow(ListStartCol);
					cell = row.createCell((short) 0);
					cell.setCellValue(i);
					cell.setCellStyle(boldTextStyle1);

					for (int n = 0; n < bom.getRanking().length() / 3; n++) {
						sb.append("   ");
					}
					cell = row.createCell((short) 1);
					cell.setCellValue(sb + bom.getStepdesc());
					cell.setCellStyle(boldTextStyle1);

					if (stList != null) {
						for (int k = 0; k < stList.size(); k++) {
							double day = 0;
							int col = 2;
							ProjPlanType type = (ProjPlanType) stList.get(k);
							if (map.get(new Long(type.getId())) != null)
								day = ((ProjPlanBOMST) map.get(new Long(type
										.getId()))).getManday();
							if (day != 0) {
								cell = row.createCell((short) col);
								cell.setCellValue(day);
								cell.setCellStyle(boldTextStyle1);
							}
							col++;
						}
					}
					ListStartCol++;
				}
			}
			hs.flush();
			tx.commit();
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.setStatus(HttpServletResponse.SC_OK);
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;

	}

	private final static String ExcelTemplate = "ProjectBomDet.xls";

	private final static String FormSheetName = "BOM";

	private final static String SaveToFileName = "Project Bom Detail.xls";

	private int ListStartCol = 2;

}

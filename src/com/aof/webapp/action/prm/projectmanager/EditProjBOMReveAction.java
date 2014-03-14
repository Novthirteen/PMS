package com.aof.webapp.action.prm.projectmanager;

import java.io.FileInputStream;
import java.lang.reflect.Array;
import java.util.HashMap;
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

import com.aof.component.prm.project.ProjPlanBOMST;
import com.aof.component.prm.project.ProjPlanBom;
import com.aof.component.prm.project.ProjPlanBomMaster;
import com.aof.component.prm.project.ProjPlanType;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.prm.report.ReportBaseAction;

public class EditProjBOMReveAction extends ReportBaseAction {
	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(EditProjBOMReveAction.class.getName());
		String action = request.getParameter("formaction");
		String[] servicetype = request.getParameterValues("servicetypeid");
		String masterid = request.getParameter("masterid");

		String[] bom_id = request.getParameterValues("bom_id");
		String[] document = request.getParameterValues("document");
		log.info("action=" + action);
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();
			ProjPlanBomMaster master = null;
			if ((masterid != null) && (masterid.length() > 0)) {
				StringTokenizer st = new StringTokenizer(masterid, ".");
				masterid = st.nextToken();
				master = (ProjPlanBomMaster) hs.load(ProjPlanBomMaster.class,
						new Long(masterid));
			}
			if(action.equalsIgnoreCase("export"))
			{
				this.Export(master,response);
			}
			/*
			 * if (!isTokenValid(request)) { if (action.equals("create")) {
			 * System.out.println("token is invalid,change to select"); return
			 * mapping.findForward("redirect"); } } saveToken(request);
			 */
			if ((action.equalsIgnoreCase("confirm"))
					|| (action.equalsIgnoreCase("edit"))) {
				ProjPlanType[] arrPPT = new ProjPlanType[Array
						.getLength(servicetype)];
				for (int i = 0; i < Array.getLength(servicetype); i++) {
					ProjPlanType ppt = (ProjPlanType) hs.load(
							ProjPlanType.class, new Long(servicetype[i]));
					arrPPT[i] = ppt;
				}

				for (int i = 0; i < Array.getLength(bom_id); i++) {
					ProjPlanBom ppb = (ProjPlanBom) hs.load(ProjPlanBom.class,
							new Long(bom_id[i]));
					String[] hid_id = request.getParameterValues("hid_id" + i);
					String[] manday = request.getParameterValues("st" + i);
					ppb.setDocument(document[i]);
					hs.update(ppb);
					hs.flush();
					
					for (int j = 0; j < Array.getLength(hid_id); j++) {
						if (Integer.parseInt(hid_id[j]) != -1)// update
						{
							ProjPlanBOMST st = (ProjPlanBOMST) hs.load(
									ProjPlanBOMST.class, new Long(hid_id[j]));
							st.setManday(Double.parseDouble(manday[j]));
							hs.update(st);
						} else// create
						{
							if (Double.parseDouble(manday[j]) != 0) {
								ProjPlanBOMST st = new ProjPlanBOMST();
								st.setBom(ppb);
								st.setType(arrPPT[j]);
								st.setManday(Double.parseDouble(manday[j]));
								st.setMaster(master);
								hs.save(st);
								ppb.addType(st);
							}
						}
					}
				}
				request.setAttribute("actionflag", "update|y");

				if (action.equalsIgnoreCase("confirm")) {
					master.setReveConfirm("confirm");
					hs.update(master);
					request.setAttribute("actionflag", "confirm|y");
				}
			}
			hs.flush();
			tx.commit();
			List list = FindSTList(hs, master.getBom_id().longValue());
			HashMap map = new HashMap();
			for (int i = 0; i < list.size(); i++) {
				ProjPlanType ppt = (ProjPlanType) list.get(i);
				map.put(new Long(ppt.getId()), ppt);

			}
			request.setAttribute("stmap", map);
			request.setAttribute("servicetype", list);
			request.setAttribute("resultList", FindQueryList(hs, master));

			request.setAttribute("formaction", action);
			request.setAttribute("master", master);
			hs.flush();
			tx.commit();

		} catch (Exception e) {
			e.printStackTrace();
			return mapping.findForward("view");
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return mapping.findForward("view");

	}

	public List FindQueryList(Session hs, ProjPlanBomMaster master) {
		List resultlist = null;//
		String strquery = null;
		strquery = "from ProjPlanBom as ppb where  ppb.master.id=? order by ppb.ranking asc";
		try {
			Query query = hs.createQuery(strquery);
			query.setLong(0, master.getId());
			resultlist = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (resultlist == null)
			resultlist = new LinkedList();

		return resultlist;
	}

	public List FindSTList(Session hs, long id) {
		List resultlist = null;//
		String strquery = null;
		strquery = " from ProjPlanType as ppt where ppt.bom_id =? and ppt.parent.id is null";
		try {
			Query query = hs.createQuery(strquery);
			query.setLong(0, id);
			resultlist = query.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (resultlist == null)
			resultlist = new LinkedList();

		return resultlist;
	}
	
	public ActionForward Export(ProjPlanBomMaster master,HttpServletResponse response)
	{
		try{
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null)
				return null;

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();
			Query query = null;
			List bomList = null;
			List stList = null;
			query = hs.createQuery("from ProjPlanBom as bom where bom.master.id = ? order by bom.ranking asc");
			query.setLong(0,master.getId());
			bomList = query.list();

			query = hs.createQuery("from ProjPlanType as type where type.bom_id = ? and type.parent is null");
			query.setLong(0,master.getBom_id().longValue());
			stList = query.list();
			
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
					+ ExcelTemplate));
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			HSSFCellStyle boldTextStyle1 = sheet.getRow(0).getCell((short) 1).getCellStyle();
			HSSFCellStyle stStyle = sheet.getRow(0).getCell((short) 2).getCellStyle();

			
			HSSFRow row = sheet.createRow(0);
			HSSFCell cell = null;

			cell = row.createCell((short)1);
			cell.setCellValue(master.getBid().getNo()+"-"+master.getBid().getDescription());
			cell.setCellStyle(stStyle);
						
			row = sheet.createRow(1);
			if(stList!=null)
			{
				for(int i=0;i<stList.size();i++)
				{
					ProjPlanType type = (ProjPlanType)stList.get(i);
					cell = row.createCell((short)(i+2));
					cell.setCellValue(type.getDescription()+"("+type.getCurrency().getCurrId()+type.getSTRate()+")");
					cell.setCellStyle(stStyle);
				}
			}
			
			row = sheet.createRow(2);

			if(bomList!=null)
			{
				for(int i=0;i<bomList.size();i++)
				{
					StringBuffer sb = new StringBuffer();
					ProjPlanBom bom = (ProjPlanBom)bomList.get(i);
					HashMap map = new HashMap();
					Set set = bom.getTypes();
					Iterator it = set.iterator();
					while(it.hasNext())
					{
						ProjPlanBOMST st = (ProjPlanBOMST)it.next();
						if(st.getType().getParent()==null)
						{
							map.put(new Long(st.getType().getId()),st);
						}
					}
					
					row = sheet.createRow(ListStartCol);
					cell = row.createCell((short)0);
					cell.setCellValue(i);
					cell.setCellStyle(boldTextStyle1);
					
					for(int n=0;n<bom.getRanking().length()/3;n++)
					{
						sb.append("   ");
					}
					cell = row.createCell((short)1);
					cell.setCellValue(sb+bom.getStepdesc());
					cell.setCellStyle(boldTextStyle1);
					
					if(stList!=null)
					{
						for(int k=0;k<stList.size();k++)
						{
							double day=0;
							int col = 2;
							ProjPlanType type = (ProjPlanType)stList.get(k);
							if(map.get(new Long(type.getId()))!=null)
								day = ((ProjPlanBOMST)map.get(new Long(type.getId()))).getManday();
							if(day!=0){
							cell = row.createCell((short)col);
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
		}
		catch(Exception e)
		{e.printStackTrace();}
		finally{
			try{
//			Hibernate2Session.closeSession();			
			}
			catch(Exception e)
			{
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

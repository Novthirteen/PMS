/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.webapp.action.prm.projectmanager;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.prm.project.FMonth;
import com.aof.component.prm.project.ProjectCostToComplete;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;


/**
 * @author xxp 
 * @version 2003-7-2
 *
 */
public class EditPrjCTCAction extends BaseAction{

	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	Logger log = Logger.getLogger(EditPrjCTCAction.class.getName());
	
	public ActionForward perform(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
			// Extract attributes we will need
			ActionErrors errors = this.getActionErrors(request.getSession());
			
			Locale locale = getLocale(request);
			MessageResources messages = getResources();		
			String action = request.getParameter("FormAction");
		    SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			
			try{
				String ProjectId = request.getParameter("DataId");
				if ((ProjectId == null) || (ProjectId.length() < 1)) actionDebug.addGlobalError(errors,"error.context.required");
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				Transaction tx = null;
				
				if(action == null) action = "view";
				
				if(action.equals("Update")){
					tx = hs.beginTransaction();
					
					ProjectMaster CustProject = (ProjectMaster)hs.load(ProjectMaster.class,ProjectId);
					
					String endDate = request.getParameter("endDate");
					CustProject.setEndDate(UtilDateTime.toDate2(endDate + " 00:00:00.000"));
					hs.update(CustProject);
					
					String CTCType[] = request.getParameterValues("ctc_type");
					String VerFMId = request.getParameter("VerFMId");
					FMonth verFm = (FMonth)hs.load(FMonth.class,new Long(VerFMId));
					
					if (CTCType != null) {
						int RowSize = java.lang.reflect.Array.getLength(CTCType);
						String RecId[] = request.getParameterValues("RecId");
						String RecordVal[] =request.getParameterValues("RecordVal");
						ProjectCostToComplete ctc =null;
						for (int i = 0; i < RowSize; i++) {
							if (RecId[i].trim().equals("")) {
								//Create a new Record
								if (!RecordVal[i].equals("0")) {
									ctc = new ProjectCostToComplete();
									ctc.setFiscalMonth(verFm);
									
									ctc.setAmount((new Double(UtilString.removeSymbol(RecordVal[i],','))).doubleValue());
									ctc.setProject(CustProject);
									ctc.setType(CTCType[i]);
									ctc.setVersionFiscalMonth(verFm);
									hs.save(ctc);
								}
							} else {
								//Update Record
								ctc = (ProjectCostToComplete)hs.load(ProjectCostToComplete.class,new Long(RecId[i]));
								ctc.setAmount((new Double(UtilString.removeSymbol(RecordVal[i],','))).doubleValue());
								hs.update(ctc);
							}
						}
					}
					tx.commit();
					hs.flush();
				}
				if(action.equals("view") ||action.equals("Update")){
					ProjectMaster CustProject = (ProjectMaster)hs.load(ProjectMaster.class,ProjectId);
					
					List CustProjectCTCs = null;
					
					String nowDateStr = Date_formater.format((java.util.Date)UtilDateTime.nowTimestamp());
					Long CurrVerFMId = getCurrVerionFMId(hs,ProjectId);
					Long NewVerFMId = getNewVerionFMId(hs,nowDateStr);
										
					if (CustProject != null) {
						java.util.Date SDate=CustProject.getStartDate();
						java.util.Date EDate=CustProject.getEndDate();
						if (CurrVerFMId != null) {
							Query q=hs.createQuery("select ctc from ProjectCostToComplete as ctc inner join ctc.FiscalMonth as fm where ctc.Project.projId =:ProjectId and ctc.VersionFiscalMonth.Id =:CurrVerFMId order by ctc.Type DESC, fm.Year, fm.MonthSeq");
							q.setParameter("ProjectId", ProjectId);
							q.setParameter("CurrVerFMId", CurrVerFMId);
							CustProjectCTCs = q.list();
						}
						FetchActual(request,ProjectId,NewVerFMId);
					}
					
					request.setAttribute("CurrVerFMId",CurrVerFMId);
					request.setAttribute("NewVerFMId",NewVerFMId);
					request.setAttribute("CustProject",CustProject);
					request.setAttribute("CustProjectCTCs",CustProjectCTCs);
	
					return (mapping.findForward("view"));
				}
			
				if (!errors.empty()) {
					saveErrors(request, errors);
					return (new ActionForward(mapping.getInput()));
				}
				return (mapping.findForward("view"));
			}catch(Exception e){
				e.printStackTrace();
				log.error(e.getMessage());
				return (mapping.findForward("view"));	
			}finally{
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
	private void FetchActual(HttpServletRequest request,String ProjId, Long NewVerFMId){
		List ActualList = null;
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		String SqlStr = "Select Res.Type, isnull(sum(Res.TotalAmt),0) as TotalAmt from (";
		SqlStr = SqlStr + " select 'PSC' as Type, sum(ts.ts_hrs_user * ts.ts_user_rate) as TotalAmt from";
		SqlStr = SqlStr + " proj_ts_det as ts inner join proj_ts_mstr as tsm on ts.tsm_id = tsm.tsm_id";
		SqlStr = SqlStr + " inner join user_login as ul on (tsm.tsm_userlogin = ul.user_login_id and ul.note <>'EXT')";
		SqlStr = SqlStr + " where ts.ts_proj_Id = '"+ProjId+"' and ts.ts_status = 'Approved'";
		SqlStr = SqlStr + " Union ";
		SqlStr = SqlStr + " select 'Expense' as Type, sum(ea.ea_amt_user * em.em_Curr_Rate) as TotalAmt from Proj_Exp_Amt as ea, proj_exp_mstr as em";
		SqlStr = SqlStr + " where ea.em_id = em.em_id  and em.em_proj_Id = '"+ProjId+"' and isnull(em.em_approval_date,'1990-1-1')<>'1990-1-1'";
		SqlStr = SqlStr + " and em.em_claimtype='CN'";
		SqlStr = SqlStr + " Union ";
		SqlStr = SqlStr + " select 'Expense' as Type, sum(pcd.percentage * pcm.totalvalue * pcm.exchangerate)/100 as TotalAmt from proj_cost_det as pcd, proj_cost_mstr as pcm, Proj_Cost_Type as pct";
		SqlStr = SqlStr + " where pcd.costcode = pcm.costcode and pct.typeid=pcm.type and pcd.proj_Id = '"+ProjId+"' and isnull(pcm.approvalDate,'1990-1-1')<>'1990-1-1'";
		SqlStr = SqlStr + " and pcm.claimtype='CN' and pct.typeaccount ='Expense'";
		SqlStr = SqlStr + " Union ";
		SqlStr = SqlStr + " select 'ExtCost' as Type, sum(pcd.percentage * pcm.totalvalue * pcm.exchangerate)/100 as TotalAmt from proj_cost_det as pcd, proj_cost_mstr as pcm, Proj_Cost_Type as pct";
		SqlStr = SqlStr + " where pcd.costcode = pcm.costcode and pct.typeid=pcm.type and pcd.proj_Id = '"+ProjId+"' and isnull(pcm.approvalDate,'1990-1-1')<>'1990-1-1'";
		SqlStr = SqlStr + " and pcm.claimtype='CN' and pct.typeaccount ='ExtCost'";
		SqlStr = SqlStr + " ) as Res Group by Res.Type order by Res.Type DESC";
		SQLResults rs = sqlExec.runQueryCloseCon(SqlStr);
		if (rs != null) ActualList = getActualList(rs,NewVerFMId);
		request.setAttribute("ActualList",ActualList);
	}
	
	private List getActualList(SQLResults rs, Long NewVerFMId){
		List ActualList = new ArrayList();
		Object[] ActualMap = new Object[3];
		for (int row=0; row< rs.getRowCount();row++){
			ActualMap = new Object[3];
			ActualMap[0] = new Integer(NewVerFMId.toString());
			ActualMap[1] = rs.getString(row,0);
			ActualMap[2] = new Double(rs.getDouble(row,1));
			ActualList.add(ActualMap);
		}
		return ActualList;
	}
	private Long getNewVerionFMId (Session session,String nowDateStr) throws HibernateException{
		Long VerionFMId = null;
		String QryStr = "select min(fm.Id) from FMonth as fm where fm.DateFreeze > '"+nowDateStr+"'";
		Query q = session.createQuery(QryStr);
		Iterator itFind = q.list().iterator();
		if (itFind.hasNext()) {
			VerionFMId = (Long)itFind.next();
		}		
		return VerionFMId;
	}
	private Long getCurrVerionFMId (Session session,String ProjectId) throws HibernateException{
		Long VerionFMId = null;
		String QryStr = "select max(ctc.VersionFiscalMonth.Id) from ProjectCostToComplete as ctc inner join ctc.Project as p where p.projId =:ProjectId";
		Query q = session.createQuery(QryStr);
		q.setParameter("ProjectId", ProjectId);
		Iterator itFind = q.list().iterator();
		if (itFind.hasNext()) {
			VerionFMId = (Long)itFind.next();
		}		
		return VerionFMId;
	}
}


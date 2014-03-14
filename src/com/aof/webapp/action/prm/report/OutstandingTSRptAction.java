/* ====================================================================
*
* Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
*
* ==================================================================== *
* @author CN01558
* @version 2005-09-13
* ====================================================================
*/
package com.aof.webapp.action.prm.report;

import java.io.FileInputStream;
import java.sql.Date;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.sql.ResultSet;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;

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
import org.apache.commons.beanutils.RowSetDynaClass;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.util.GeneralException;
import com.aof.util.UtilDateTime;
import com.aof.webapp.form.prm.report.OutstandingTSRptForm;

public class OutstandingTSRptAction extends ReportBaseAction {
	
	private Log log = LogFactory.getLog(OutstandingTSRptAction.class);
	
	public ActionForward execute (ActionMapping mapping,
	                              ActionForm form,
								  HttpServletRequest request,
								  HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();

		OutstandingTSRptForm ansForm = (OutstandingTSRptForm)form;

		try {
			if ("QueryForList".equals(ansForm.getFormAction())) {
				ResultSet sr = findQueryResult(ansForm, request);
			}
			return (mapping.findForward("success"));
		} catch(Exception e) {
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
	}
	
	private ResultSet findQueryResult(OutstandingTSRptForm ansForm, HttpServletRequest request) throws Exception {
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		StringBuffer statement = new StringBuffer("");
		statement.append(" select 	det.ts_proj_id as proj_id, ");
		statement.append(" 		  st.ST_Desc as st_desc, ");
		statement.append(" 	 	  st.ST_Rate st_rate, ");
		statement.append(" 	 	  user_staff.name as staff, ");
		statement.append("        det.ts_status as status, ");
		statement.append("        det.ts_hrs_user as hrs, ");
		statement.append("        convert(varchar(10), st.ST_EstimateDate , (126)) as date, ");
		statement.append("        event.PEvent_name as event_name,");
		statement.append("        proj_mstr.proj_name as proj_name,");
		statement.append("        ul.name as pa_name,");
		statement.append("        uls.name as pm_name ");
		statement.append(" from 	Proj_TS_Mstr as ts_mstr  ");
		statement.append("          inner join Proj_TS_Det as det on ts_mstr.tsm_id=det.tsm_id   ");
		statement.append("          inner join ProjEvent as event on event.PEvent_id=det.ts_projevent  ");
		statement.append("          inner join Proj_Mstr as proj_mstr on proj_mstr.proj_id=det.ts_proj_id and proj_mstr.proj_status = 'WIP' ");
		statement.append("          inner join user_login as ul on ul.user_login_id = proj_mstr.proj_pa_id ");
		statement.append("          inner join user_login as uls on uls.user_login_id = proj_mstr.proj_pm_user ");
		statement.append("          inner join PARTY as p on p.PARTY_ID=proj_mstr.dep_id ");
		statement.append("          inner join Proj_ServiceType as st on st.ST_Id=det.ts_servicetype ");
		statement.append("			inner join user_login as user_staff on user_staff.user_login_id=ts_mstr.tsm_userlogin ");
		statement.append(" where 	");

		if(ansForm.getProject() != null && ansForm.getProject().trim().length() != 0){
			statement.append("(proj_mstr.proj_name like ? or proj_mstr.proj_id like ?) and ");     // Project Description
			sqlExec.addParam("%"+ansForm.getProject()+"%");
			sqlExec.addParam("%"+ansForm.getProject()+"%");
		}
		
		if(ansForm.getPa() != null && ansForm.getPa().trim().length() != 0){
			statement.append("(proj_mstr.proj_pa_id like ? or ul.name like ? ) and ");   // Project Manager Assistent
			sqlExec.addParam("%"+ansForm.getPa()+"%");
			sqlExec.addParam("%"+ansForm.getPa()+"%");
		}
		
		if(ansForm.getPm() != null && ansForm.getPm().trim().length() != 0){
			statement.append("(proj_mstr.proj_pm_user like ? or uls.name like ? ) and ");   // Project Manager
			sqlExec.addParam("%"+ansForm.getPm()+"%");
			sqlExec.addParam("%"+ansForm.getPm()+"%");
		}
		
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String PartyListStr = "''";
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (!ansForm.getDpt().trim().equals("")) {
			List partyList_dep=ph.getAllSubPartysByPartyId(session,ansForm.getDpt());
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'"+ansForm.getDpt()+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
			statement.append("p.PARTY_ID in ("+PartyListStr+") and ");     // Department 
		}else{
			statement.append("( proj_mstr.proj_pm_user like ('%"+ul.getUserLoginId()+"%') or uls.name like ('%"+ul.getName()+"%') ) and ");     // Department
		}
		String dateStart = "'"+ansForm.getDate_begin()+"'";
		String dateEnd = "'"+ansForm.getDate_end()+"'";
		
		statement.append("det.ts_date>="+dateStart+" and ");   //Start Date
		statement.append("det.ts_date<="+dateEnd+" and ");   //End Date
		statement.append("event.Billable='Yes' and ");
		statement.append("det.ts_hrs_user <> 0 and ");
		statement.append("(det.ts_status='Submitted' or det.ts_status='Rejected') ");

		log.info(statement.toString());
		
		ResultSet result = sqlExec.runQueryStreamResults(statement.toString());			
		RowSetDynaClass resultSet = new RowSetDynaClass(result,false);
		sqlExec.closeConnection();
		request.setAttribute("QryList",resultSet);

		return result;
	}
}

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
import com.aof.webapp.form.prm.report.OutstandingAcceptanceRptForm;

public class OutstandingAcceptanceRptAction extends ReportBaseAction {
	
	private Log log = LogFactory.getLog(OutstandingAcceptanceRptAction.class);
	
	public ActionForward execute (ActionMapping mapping,
	                              ActionForm form,
								  HttpServletRequest request,
								  HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();

		OutstandingAcceptanceRptForm ansForm = (OutstandingAcceptanceRptForm)form;

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
	
	private ResultSet findQueryResult(OutstandingAcceptanceRptForm ansForm, HttpServletRequest request) throws Exception {
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		StringBuffer statement = new StringBuffer("");
		statement.append(" select st.ST_Proj_Id as proj_id, ");
		statement.append("        mstr.proj_name as proj_name, case when(st.st_rate = 0) then (convert(varchar,cast(st.st_scrate as money),1)) when (st.st_scrate = 0) then (convert(varchar,cast(st.st_rate as money),1) ) end as value1 , ");
		statement.append("        cg.PC_Desc as proj_category, ");
		statement.append("        st.ST_Desc as proj_phase,");
		statement.append("        convert(varchar(10), st.ST_EstimateDate , (126)) as est_close_date,");
		statement.append("        ul.name as pa,");
		statement.append("        uls.name as pm, case when (mstr.proj_vendaddr is not null) then (p2.description) when ((mstr.proj_vendaddr is null) ) then (p1.description) end as pp ");
		statement.append(" from 	Proj_ServiceType as st  ");
		statement.append("          inner join Proj_Mstr as mstr on st.st_proj_id= mstr.proj_id ");
		statement.append("          inner join Proj_Category as cg on cg.PC_Id=mstr.proj_category  ");
		statement.append("          inner join PARTY as p on p.PARTY_ID=mstr.dep_id ");
		statement.append("          inner join user_login as ul on ul.user_login_id = mstr.proj_pa_id ");
		statement.append("          inner join user_login as uls on uls.user_login_id = mstr.proj_pm_user ");
		statement.append("          inner join party as p1 on p1.party_id = mstr.cust_id ");
		statement.append("          left join party as p2 on p2.party_id = mstr.proj_vendaddr ");
		statement.append(" where 	mstr.proj_status = 'WIP' and mstr.contracttype = 'FP' and ");

		if(ansForm.getProject() != null && ansForm.getProject().trim().length() != 0){
			statement.append("  (mstr.proj_name like ? or mstr.proj_id like ?) and ");     // Project Description
			sqlExec.addParam("%"+ansForm.getProject()+"%");
			sqlExec.addParam("%"+ansForm.getProject()+"%");
		}
		
		if(ansForm.getPa() != null && ansForm.getPa().trim().length() != 0){
			statement.append("  (mstr.proj_pa_id like ? or ul.name like ? ) and ");   // Project Manager Assistent
			sqlExec.addParam("%"+ansForm.getPa()+"%");
			sqlExec.addParam("%"+ansForm.getPa()+"%");
		}
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String PartyListStr = "''";
	
		if (!ansForm.getDpt().trim().equals("")) {
			List partyList_dep=ph.getAllSubPartysByPartyId(session,ansForm.getDpt());
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'"+ansForm.getDpt()+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
		}
		String dateStart = "'"+ansForm.getDate_begin()+"'";
		String dateEnd = "'"+ansForm.getDate_end()+"'";
		statement.append("p.PARTY_ID in ("+PartyListStr+") and ");     // Department
		statement.append("st.ST_EstimateDate > "+dateStart+" and ");   //Start Date
		statement.append("st.ST_EstimateDate<"+dateEnd+" and ");   //End Date
		statement.append("st.ST_CustAcceptance_Date is NULL and ");
		statement.append("st.ST_VendAcceptance_Date is NULL");

		//sqlExec.addParam(PartyListStr);
	
		//sqlExec.addParam(dateStart);
		//sqlExec.addParam(dateEnd);

		log.info(statement.toString());
		
		ResultSet result = sqlExec.runQueryStreamResults(statement.toString());			
		RowSetDynaClass resultSet = new RowSetDynaClass(result,false);
		sqlExec.closeConnection();
		request.setAttribute("QryList",resultSet);

		return result;
	}
}

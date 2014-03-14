/*
 * Created on 2005-10-21
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.report;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ProjectRenewCheckingRptAction extends ReportBaseAction {
	private Log log = LogFactory.getLog(OutstandingAcceptanceRptAction.class);
	
	public ActionForward execute (ActionMapping mapping,
	                              ActionForm form,
								  HttpServletRequest request,
								  HttpServletResponse response) {
		ActionErrors errors = this.getActionErrors(request.getSession());
		Locale locale = getLocale(request);
		MessageResources messages = getResources();

		String formAction = request.getParameter("FormAction");
		String proj = request.getParameter("proj");
		String cust = request.getParameter("cust");
		String pm = request.getParameter("pm");
		String pa = request.getParameter("pa");
		String depId = request.getParameter("depId");
		
		if(formAction==null)	formAction="";
		if(proj==null)			proj="";
		if(cust==null)			cust="";
		if(pm==null)			pm="";
		if(pa==null)			pa="";
		if(depId==null)			depId="";
		
		try {
			if ("QueryForList".equals(formAction)) {
				ResultSet sr = findQueryResult(request, proj, cust, pm, pa, depId);
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
	
	private ResultSet findQueryResult(HttpServletRequest request, String proj, String cust, String pm, String pa, String depId) throws Exception {
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		StringBuffer statement = new StringBuffer("");		
		statement.append(" select proj.proj_id as proj_id,	");
		statement.append(" 		proj.proj_name as proj_name,	");
		statement.append(" 		p.DESCRIPTION as cust_name,	");
		statement.append(" 		ul_pm.NAME as pm,	");
		statement.append(" 		case proj.ContractType when 'TM' then 'Time & Material' when 'FP' then 'Fixed Price' end as conType,	");
		statement.append(" 		proj.total_service_value as value,	");
		statement.append(" 		ul_pa.NAME as pa,	");
		statement.append(" 		proj.proj_status as status,	");
		statement.append(" 		convert(varchar(10),start_date,(126)) as start_date,	");
		statement.append(" 		convert(varchar(10),end_date,(126)) as end_date	");			

		statement.append(" from Proj_Mstr as proj	");
		statement.append(" 		inner join PARTY as p on p.PARTY_ID=proj.cust_id	");
		statement.append(" 		inner join USER_LOGIN as ul_pm on ul_pm.USER_LOGIN_ID=proj.proj_pm_user	");
		statement.append(" 		left join USER_LOGIN as ul_pa on ul_pa.USER_LOGIN_ID=proj.proj_pa_id	");

		statement.append(" where proj.proj_status = 'WIP'	"); 
		statement.append(" 		and proj.renew_flag='Y'	");
		statement.append(" 		and								");
		statement.append("   (									");
		statement.append("		(								");
		statement.append("			year(end_date)<year(getdate()) 	");
		statement.append(" 		)								");
		statement.append(" 		or								");
		statement.append(" 		(								");
		statement.append("			year(end_date)=year(getdate()) and ( month(end_date)-month(getdate()) ) <0	");
		statement.append(" 		)								");
		statement.append(" 		or								");
		statement.append(" 		(								");
		statement.append(" 		  (								");
		statement.append(" 		    year(end_date)=year(getdate()) and ( month(end_date)-month(getdate()) ) <=2 and  ( month(end_date)-month(getdate()) ) >=0	");
		statement.append(" 		  )								");
		statement.append(" 		  or							"); 
		statement.append(" 		  (								"); 
		statement.append(" 		    year(end_date)=year(getdate()) and ( month(end_date)-month(getdate()) ) <=3 and ( month(end_date)-month(getdate()) ) >=0 and ( day(end_date)-day(getdate()) ) <=0	");
		statement.append(" 		  )								");
		statement.append(" 		)								");
		statement.append(" 		or								");
		statement.append(" 		(								");
		statement.append(" 		  (								");
		statement.append(" 		    year(end_date)-year(getdate())=1 and ( month(end_date)-month(getdate())+12 ) <=2	");
		statement.append(" 		  )								");
		statement.append(" 		  or							"); 
		statement.append(" 		  (								"); 
		statement.append(" 		    year(end_date)-year(getdate())=1 and ( month(end_date)-month(getdate())+12 ) <=3 and ( day(end_date)-day(getdate()) ) <=0	");
		statement.append(" 		  )								");
		statement.append(" 		)								");
		statement.append(" 	  )									");

		if(proj != null && proj.trim().length() != 0){
			statement.append("  and (proj.proj_name like ? or proj.proj_id like ?) ");     // Project Description
			sqlExec.addParam("%"+proj+"%");
			sqlExec.addParam("%"+proj+"%");
		}
		
		if(cust != null && cust.trim().length() != 0){
			statement.append("  and (p.DESCRIPTION like ? or p.PARTY_ID like ?) ");     // Customer Description
			sqlExec.addParam("%"+cust+"%");
			sqlExec.addParam("%"+cust+"%");
		}
		
		if(pm != null && pm.trim().length() != 0){
			statement.append("  and (ul_pm.USER_LOGIN_ID like ? or ul_pm.NAME like ? ) ");   // Project Manager
			sqlExec.addParam("%"+pm+"%");
			sqlExec.addParam("%"+pm+"%");
		}
		
		if(pa != null && pa.trim().length() != 0){
			statement.append("  and (ul_pa.USER_LOGIN_ID like ? or ul_pa.NAME like ? ) ");   // Project Manager Assistent
			sqlExec.addParam("%"+pa+"%");
			sqlExec.addParam("%"+pa+"%");
		}
		
		net.sf.hibernate.Session session = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		String PartyListStr = "''";
	
		if (depId.trim().equals("")) {
			statement.append(" and proj.proj_pm_user='"+ul.getUserLoginId()+"' ");
		}else{
			List partyList_dep=ph.getAllSubPartysByPartyId(session,depId);
			Iterator itdep = partyList_dep.iterator();
			PartyListStr = "'"+depId+"'";
			while (itdep.hasNext()) {
				Party p =(Party)itdep.next();
				PartyListStr = PartyListStr +", '"+p.getPartyId()+"'";
			}
			statement.append(" and proj.dep_id in ("+PartyListStr+") ");
		}

		log.info(statement.toString());
		System.out.println(statement.toString());
		
		ResultSet result = sqlExec.runQueryStreamResults(statement.toString());			
		RowSetDynaClass resultSet = new RowSetDynaClass(result,false);
		sqlExec.closeConnection();
		request.setAttribute("QryList",resultSet);

		return result;
	}
}

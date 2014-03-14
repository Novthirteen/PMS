/*
 * Created on 2005-11-10
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.helpdesk;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.webapp.action.BaseAction;

/**
 * @author CN01558
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CallAssignRptAction extends BaseAction {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String formAction = request.getParameter("formAction");
		if(formAction==null){
			formAction = "";
		}
		
		if(formAction.equals("QueryForList")){
			this.findQueryResult1(mapping, form, request, response);
		}
		this.findQueryResult2(mapping, form ,request, response);
		
		return mapping.findForward("success");		
	}
	
	public void findQueryResult1(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws SQLException{
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
		
		String groupId = request.getParameter("gid");
		String start_date = request.getParameter("date_begin");
		String end_date = request.getParameter("date_end");
		
		StringBuffer statement = new StringBuffer("");
		statement.append("	select	ul.NAME as consultant,	");
		statement.append("			count(call_mstr.CM_ID) as total_calls,	");
		statement.append("			count(case when call_mstr.closed_date is null then call_mstr.CM_ID else null end) as open_calls,	");
		statement.append("			cast(sum(hstry.CMAH_Cost) as money) as hours	");
		statement.append("	from 	Call_Master call_mstr	");
		statement.append("			inner join Consultant_Assign assign on assign.consultant=call_mstr.CM_Assigned_User	");
		statement.append("			inner join USER_LOGIN ul on ul.USER_LOGIN_ID=call_mstr.CM_Assigned_User	");
		statement.append("			inner join CM_Action_History hstry on hstry.CM_ID=call_mstr.CM_ID	");
		statement.append("	where 	assign.group_id="+groupId+" and	");
		statement.append("			call_mstr.CM_Accepted_Date>='"+start_date+"' and	"); 
		statement.append("			call_mstr.CM_Accepted_Date<='"+end_date+"'	");
		statement.append("	group by ul.NAME	");
		statement.append("	order by consultant	");
		System.out.println(statement.toString());
		ResultSet result = sqlExec.runQueryStreamResults(statement.toString());			
		System.out.println("------------------------------------"+result.getRow());
		RowSetDynaClass resultSet = new RowSetDynaClass(result,false);
		sqlExec.closeConnection();
		request.setAttribute("QryList1",resultSet);
	}
	
	public void findQueryResult2(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws SQLException{
		
		SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));

		String status = request.getParameter("status");
		if(status==null){
			status = "unclose";
		}
		
		StringBuffer statement = new StringBuffer("");
		statement.append("	select top 10 ul.NAME as consultant,	");
		statement.append("			call_mstr.CM_Customer as cust,	");
		statement.append("			call_mstr.CM_Contact as contact,	");
		statement.append("			call_mstr.CM_Tele_Code as tele,	");
		statement.append("			call_mstr.CM_Email as email,	");
		statement.append("			call_mstr.ticket_number as tno,	");
		statement.append("			st.status_desc as status,	");
		statement.append("			convert(varchar(10),call_mstr.CM_Accepted_Date,(126)) as acc_date,	");
		statement.append("			convert(varchar(10),call_mstr.Response_date,(126)) as res_date,	");
		statement.append("			convert(varchar(10),call_mstr.solved_date,(126)) as slv_date,	");
		statement.append("			convert(varchar(10),call_mstr.closed_date,(126)) as cls_date	");
		statement.append("	from Call_Master call_mstr	");
		statement.append("			inner join USER_LOGIN ul on ul.USER_LOGIN_ID=call_mstr.CM_Assigned_User	");
		statement.append("			inner join Status_Type st on call_mstr.CM_Status=st.status_id	");
		statement.append("	where ul.party_id='006'	"); //006 is code of QAD
		
		if(status.equals("unclose")){
			statement.append("		and (st.status_desc<>'CLOSE' and st.status_desc<>'CANCELLED')	");
		}else if(!status.equals("All")){
			statement.append("		and st.status_desc='"+status+"'	");
		}
		
		statement.append("	order by CM_Accepted_Date desc	");
		
		System.out.println(statement.toString());
		
		ResultSet result = sqlExec.runQueryStreamResults(statement.toString());			
		RowSetDynaClass resultSet = new RowSetDynaClass(result,false);
		sqlExec.closeConnection();
		request.setAttribute("QryList2",resultSet);
	}
}
<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%try{%>
<%if (AOFSECURITY.hasEntityPermission("MANDAY_ACTUAL_VS_BUDGET_REPORT", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(1);
Num_formater.setMinimumFractionDigits(1);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
String projType = request.getParameter("projType");
String departmentId = request.getParameter("departmentId");
String texttype = request.getParameter("texttype");
if (projType == null) projType = "";
if (departmentId == null) departmentId = "";
if (texttype == null) texttype = "";
List partyList_dep=null;
try{
	PartyHelper ph = new PartyHelper();
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
	if (partyList_dep == null) partyList_dep = new ArrayList();
	partyList_dep.add(0,ul.getParty());
}catch(Exception e){
	e.printStackTrace();
}
%>
<script language="javascript">
function SearchResult() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> Actual VS Budget Man-Days Report</caption> 
<tr>
	<td>
		<Form action="pas.report.ActualVSBudgetMDRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction">
		<table width=100%>
			<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
			<%
				String textcode = request.getParameter("textcode");
				String textpm = request.getParameter("textpm");
				String textcust = request.getParameter("textcust");
				if (textcode == null) textcode ="";
				if (textpm == null) textpm ="";
				if (textcust == null) textcust ="";
			%>
			<tr>
				<td class="lblbold">Project:</td>
				<td class="lblLight"><input type="text" name="textcode" size="15" value="<%=textcode%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Project manager:</td>
				<td class="lblLight"><input type="text" name="textpm" size="15" value="<%=textpm%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Customer:</td>
				<td class="lblLight"><input type="text" name="textcust" size="15" value="<%=textcust%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
	    	</tr>
			<tr>
			 	<td class="lblbold">Project Status:</td>
				<%	
					SQLResults srr = (SQLResults)request.getAttribute("QryList");
					boolean find =  true;
					if(srr == null){
						find = false;
					} else if (srr.getRowCount() == 0) {
						find = false;
					}
					if(!find){ %>
				<td class="lblLight">
					<select name="projType">
						<option value="WIP" >WIP</option>
						<option value="PC" >Project Completed</option>
						<option value="Close">CLOSED</option>
					</select>
				</td>
					<%} else {
				%>
				<td class="lblLight">
					<select name="projType">
						<option value="WIP" <%if (srr.getString(0,"status").equals("WIP")) out.println("selected");%>>WIP</option>
						<option value="PC" <%if (srr.getString(0,"status").equals("PC")) out.println("selected");%>>Project Completed</option>
						<option value="Close" <%if (srr.getString(0,"status").equals("Close")) out.println("selected"); %>>CLOSED</option>
					</select>
				</td>
				<%}%>
				<td class="lblbold">Department:</td>
				<td class="lblLight">
					<select name="departmentId">
						
					<%
					if (AOFSECURITY.hasEntityPermission("PAS_PM_REPORT", "_ALL", session)) {
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(departmentId)) {%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%} else{%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%}
						}
					}%>
					</select>
				</td>
				<td class="lblbold">Category:</td>
				<td class="lblLight">
					<select name="texttype">
				  	<option value="">ALL</option>
				    <option value="TM" <%if (texttype.equals("TM")) out.print("selected");%>>Time & Material</option>
				    <option value="FP" <%if (texttype.equals("FP")) out.print("selected");%>>Fixed Price</option>
				    </select>
				</td>
			</tr>
			<tr>
				<td colspan=3 />
			<%
				boolean flag = false;
				if (request.getParameter("flag") != null) flag = true;
			%>
				<td align="left" class="lblbold" >
					<input type=checkbox class="checkboxstyle" name="flag" value="Y" <%if (flag) out.print("Checked");%>>
					Show PO project time sheet
				</td>

				<td colspan=2 align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
				</td>
			</tr>
			<tr>
				<td colspan=6 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr bgcolor="#e9eee9">
				<td align=center class="lblbold" rowspan="2">&nbsp;Customer&nbsp;</td>
				<td align=center class="lblbold" rowspan="2">&nbsp;Project ID&nbsp;</td>
				<td align=center class="lblbold" rowspan="2">&nbsp;Project Name&nbsp;</td>
				<td align=center class="lblbold" rowspan="2">&nbsp;Project Manager&nbsp;</td>
				<td align=center class="lblbold" rowspan="2">&nbsp;Contract Type&nbsp;</td>
				<td align=center class="lblbold" rowspan="2">&nbsp;Start Date&nbsp;</td>
				<td align=center class="lblbold" rowspan="2">&nbsp;End Date&nbsp;</td>
				<td align=center class="lblbold" rowspan="2">&nbsp;Service Type&nbsp;</td>
				<td align=center class="lblbold" rowspan="2">&nbsp;Budget Man-Day&nbsp;</td>
				<td align=center class="lblbold" colspan="4">Actual</td>
				
				<td align=center class="lblbold" rowspan="2">Remain Billable Man-Day</td>
				<td align=center class="lblbold" rowspan="2">CAF Remain</td> 
			</tr>
			<tr bgcolor="#e9eee9">
				<td align=center class="lblbold">&nbsp;Billable TS Days&nbsp;</td>
				<td align=center class="lblbold">&nbsp;TS Confirm days&nbsp;</td>
				<td align=center class="lblbold">&nbsp;CAF Confirm days&nbsp;</td>
				<td align=center class="lblbold">&nbsp;CAF Pending days&nbsp;</td>
			</tr>
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			Object resultSet_data;
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='15' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				// define several string variables to make groups upon the record
					String newPid = "";
					String oldPid = "";
				for (int row =0; row < sr.getRowCount(); row++) {
					double budgetDays =0;
					double tsDays = 0;
					double tsConfirmDays = 0;
					double cafConfirmDays = 0;
					double cafPendingDays = 0;
					double tsRemain = 0;
					double cafRemain = 0;
					
					newPid = sr.getString(row, "pid");

					budgetDays = sr.getDouble(row, "est_days");
					
					//if "TS Days" is "null" , it remains the default value "0" 
					resultSet_data = sr.getObject(row, "ts_days");
					if(resultSet_data != null)
						tsDays = sr.getDouble(row, "ts_days");
						
					//if "TS Confirm Days" is "null" , it remains the default value "0" 
					resultSet_data = sr.getObject(row, "ts_confirm");
					if(resultSet_data != null)
						tsConfirmDays = sr.getDouble(row, "ts_confirm");
						
					//if "CAF Confirm Days" is "null" , it remains the default value "0" 
					resultSet_data = sr.getObject(row, "caf_confirm");
					if(resultSet_data != null)
						cafConfirmDays = sr.getDouble(row, "caf_confirm");
						
					resultSet_data = sr.getObject(row, "caf_pending");
					if(resultSet_data != null)
						cafPendingDays = sr.getDouble(row, "caf_pending");
						
					tsRemain = budgetDays-tsDays;
					if(sr.getString(row, "cafflag").equals("N")){
						cafRemain =0;
					}else{
						cafRemain = budgetDays-cafConfirmDays-cafPendingDays;
					}
					cafRemain = budgetDays-cafConfirmDays-cafPendingDays;
					
					if(!newPid.equals(oldPid)){
						oldPid = newPid;
						
						//convert the contract type string for better understanding
						String c_type = "";
						c_type = sr.getString(row, "category");
						if(c_type.equals("TM")){
							c_type = "Time & Material";
						}else{
							c_type = "Fixed Price";
						}
				%>
				
					<tr bgcolor="#e9eee1"> 
						<td align=left><%=(((resultSet_data = sr.getObject(row,"cust_name"))==null) ? "":resultSet_data)%></td>
						<td align=left><%=(((resultSet_data = sr.getObject(row,"pid"))==null) ? "":resultSet_data)%></td>
						<td align=left><%=(((resultSet_data = sr.getObject(row,"pname"))==null) ? "":resultSet_data)%></td>
						<td align=left><%=(((resultSet_data = sr.getObject(row,"pm"))==null) ? "":resultSet_data)%></td>
						<td align=left><%=c_type%></td>
						<td align=left><%=(((resultSet_data = sr.getObject(row,"start_date"))==null) ? "":resultSet_data)%></td>
						<td align=left><%=(((resultSet_data = sr.getObject(row,"end_date"))==null) ? "":resultSet_data)%></td>
						<td align=left><%=(((resultSet_data = sr.getObject(row,"st_desc"))==null) ? "":resultSet_data)%></td>
						<td align=right><%=Num_formater.format(budgetDays)%></td>
						<td align=right><%=Num_formater.format(tsDays)%></td>
						<td align=right><%=Num_formater.format(tsConfirmDays)%></td>
						<td align=right><%=Num_formater.format(cafConfirmDays)%></td>
						<td align=right><%=Num_formater.format(cafPendingDays)%></td>
						<td align=right><%=Num_formater.format(tsRemain)%></td>
						<td align=right><%=Num_formater.format(cafRemain)%></td>
					</tr>
				<%} else { %>
					<tr bgcolor="#e9eee1"> 
						<td align=left>&nbsp;</td>
						<td align=left>&nbsp;</td>
						<td align=left>&nbsp;</td>
						<td align=left>&nbsp;</td>
						<td align=left>&nbsp;</td>
						<td align=left>&nbsp;</td>
						<td align=left>&nbsp;</td>
						<td align=left><%=(((resultSet_data = sr.getObject(row,"st_desc"))==null) ? "":resultSet_data)%></td>
						<td align=right><%=Num_formater.format(budgetDays)%></td>
						<td align=right><%=Num_formater.format(tsDays)%></td>
						<td align=right><%=Num_formater.format(tsConfirmDays)%></td>
						<td align=right><%=Num_formater.format(cafConfirmDays)%></td>
						<td align=right><%=Num_formater.format(cafPendingDays)%></td>
						 
						<td align=right><%=Num_formater.format(tsRemain)%></td>
						<td align=right><%=Num_formater.format(cafRemain)%></td>
					</tr>
				<%}}
			}%>
		</table>
	</td>
</tr>
</table>

<%
}else{
	out.println("没有访问权限.");
}
%>
<%}catch (Exception e){
			e.printStackTrace();
		}%>
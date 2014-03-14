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

<%//if (AOFSECURITY.hasEntityPermission("PM_PROJECT_REPORT", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat numFormat1 = NumberFormat.getInstance();
numFormat1.setMaximumFractionDigits(0);
numFormat1.setMinimumFractionDigits(0);
NumberFormat numFormat2 = NumberFormat.getInstance();
numFormat2.setMaximumFractionDigits(2);
numFormat2.setMinimumFractionDigits(2);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();

String PMId = request.getParameter("PMId");
if (PMId == null) PMId = "";
String PMName = request.getParameter("PMName");
if (PMName == null) PMName = "";
%>
<script language="javascript">
function showDialog_staff() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.frm.PMId.value=v.split("|")[0];
			document.frm.PMName.value=v.split("|")[1];	
			//labelPM.innerHTML=document.EditForm.projectManagerName.value;	
	}
}
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
<caption class="pgheadsmall"> Project Overall Status by Project Manager </caption> 
<tr>
	<td>
		<Form action="pas.report.ProjectByPMRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction">
		<table width=100%>
			<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Project Manager:</td>
				<td class="lblLight"><input  type="hidden" class="inputBox" name="PMId" size="22" value="<%=PMId%>">
				<input type="text" name="PMName" maxlength="100" value="<%=PMName%>">
				<a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
				</td>
			</tr>
			<tr>
			</tr>
			<tr>
			    <td colspan=4 align="left"/>
				<td  align="left" colspan=2>
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult();return false">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel();return false">
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
		<td align=center class="lblbold">No.&nbsp;</td>
		<td align=center class="lblbold">Project Manager&nbsp;</td>
		<td align=center class="lblbold">Customer&nbsp;</td>
		<td align=center class="lblbold">Project ID&nbsp;</td>
		<td align=center class="lblbold">Project Description&nbsp;</td>
		<td align=center class="lblbold">Status</td>
		<td align=center class="lblbold">Type</td>
		<td align=center class="lblbold">PA</td>
		<td align=center class="lblbold">TCV</td>
		<td align=center class="lblbold">Start Date</td>
		<td align=center class="lblbold">End Date</td>
		<td align=center class="lblbold">Estimated MD</td>
		<td align=center class="lblbold">Actual Approved MD</td>
		<td align=center class="lblbold">Outstanding CAF</td>
		<td align=center class="lblbold">Outstanding Acceptance</td>
		<td align=center class="lblbold">Billing Pending</td>
		<td align=center class="lblbold">Total Billed Amt</td>
		<td align=center class="lblbold">Last Billed Amt</td>
		<td align=center class="lblbold">Last Invoice Status</td>
		<td align=center class="lblbold">Total AR</td>
		<td align=center class="lblbold">Total Received Amt</td>
		<td align=center class="lblbold">Last Receipt Date</td>
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
				out.println("<br><tr><td colspan='23' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
			  for (int row =0; row < sr.getRowCount(); row++) {
				%>
					<tr bgcolor="#e9eee1"> 
						<td nowrap align=left><%=row+1%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"pm"))==null) ? "N/A":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"cust"))==null) ? "N/A":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"proj_id"))==null) ? "N/A":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"proj_name"))==null) ? "N/A":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"proj_status"))==null) ? "N/A":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"contracttype"))==null) ? "N/A":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"pa"))==null) ? "N/A":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"tcv"))==null) ? "N/A":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"start_date"))==null) ? "N/A":Date_formater.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"end_date"))==null) ? "N/A":Date_formater.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"estMD"))==null) ? "N/A":numFormat2.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"actualMD"))==null) ? "N/A":numFormat2.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"otcaf"))==null) ? "N/A":numFormat1.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"otaccp"))==null) ? "N/A":numFormat2.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"bill_pending"))==null) ? "N/A":numFormat2.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"total_billed_amount"))==null) ? "N/A":numFormat2.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"last_billed_amount"))==null) ? "N/A":numFormat2.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"last_inv_status"))==null) ? "N/A":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"AR"))==null) ? "N/A":numFormat2.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"total_receipt_amt"))==null) ? "N/A":numFormat2.format(resultSet_data))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"last_r_date"))==null) ? "N/A":Date_formater.format(resultSet_data))%></td>
						
					</tr>
				<%}%>

		<%	}%>
		</table>
	</td>
</tr>
</table>

<%
//}else{
//	out.println("没有访问权限.");
//}
%>
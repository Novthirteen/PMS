<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.report.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%if (AOFSECURITY.hasEntityPermission("PAS_COST_QUERY_REPORT", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
Calendar calendar = Calendar.getInstance();

int srcYR = calendar.get(Calendar.YEAR);

String srcYear = (String)request.getAttribute("SrcYear");
String srcMonth = (String)request.getAttribute("SrcMonth");
String project = request.getParameter("project");
String customer = request.getParameter("customer");
String projectManager = request.getParameter("projectManager");
String departmentId = request.getParameter("departmentId");

if (project == null) project = "";
if (customer == null) customer = "";
if (projectManager == null) projectManager = "";
if (departmentId == null) departmentId = "";

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
	formObj.elements["formAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
<caption class="pgheadsmall">Project Cost Query</caption> 
<tr>
	<td>
		<Form action="pas.report.ProjectCostRpt.do" name="frm" method="post">
		<input type="hidden" name="formAction">
		<table width=100%>
			<tr>
				<td colspan="18" valign="bottom"><hr color=red></hr></td>
			</tr>
			
			<tr>
				<td class="lblbold" width="120px">Fiscal Month:</td>
				<td class="lblLight" width="240px">
					<SELECT name="srcYear">
					<%for (int i = srcYR - 1; i <= srcYR; i++) {%>
						<Option value='<%=i%>' <%if (srcYear.equals(String.valueOf(i))) {%> Selected <%}%>><%=i%></OPTION>
					<%}%>
					</SELECT>
					-
					<SELECT name="srcMonth">
					<%for (int i = 0; i < 12; i++) {%>
						<Option value='<%=i%>' <%if (srcMonth.equals(String.valueOf(i))) {%> Selected <%}%>><%=i + 1%></OPTION>
					<%}%>
					</SELECT>
				</td>
				<td colspan="3"></td>
			</tr>
			<tr>
				<td class="lblbold" width="120px">Department:</td>
				<td class="lblLight" width="240px">
					<select name="departmentId">
						<option value="">(All Related to You)</option>
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
				<td class="lblbold" width="120px">projectManager:</td>
				<td class="lblLight" width="240px">
					<input type="text" class="inputBox" name="projectManager" size="12" value="<%=projectManager%>">
				</td>
				<td></td>
			</tr>
			<tr>
				<td class="lblbold" width="120px">Project:</td>
				<td class="lblLight" width="240px">
					<input type="text" class="inputBox" name="project" size="12" value="<%=project%>">
				</td>
				
				<td class="lblbold" width="100px">Customer:</td>
				<td class="lblLight" width="200px">
					<input type="text" class="inputBox" name="customer" size="12" value="<%=customer%>">
				</td>
				<td></td>
			</tr>
			<tr>
				<td colspan=5 align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
				</td>
				<%boolean detailFlg = false;
				if (request.getParameter("detailFlg") != null) detailFlg = true;%>
				<td align="left" class="lblbold"><input type=checkbox class="checkboxstyle" name=detailFlg value="Y" <%if (detailFlg) out.print("Checked");%>>Show Sub-Project Detail
				</td>
			</tr>
			<tr>
				<td colspan="18" valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
</table>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
	<tr>
		<td>
			<table border="0" cellpadding="2" cellspacing="2" width=100%>
				<tr bgcolor="#e9eee9">
					<td class="lblbold" width="73">ProjCode</td>
					<td class="lblbold" width="236">ProjName</td>
					<td class="lblbold" width="14">Project Start Date</td>
					<td class="lblbold" width="22">Orig Comp Date</td>
					<td class="lblbold" width="97">Service Sales Value (RMB)</td>
					<td class="lblbold" width="29">Total Proc./Sub Value (RMB)</td>
					<td class="lblbold" width="43">Days Budget</td>
					<td class="lblbold" width="1">Days In-Month</td>
					<td class="lblbold" width="1">Days To-Date</td>
					<td class="lblbold" width="1">PSC Budget (RMB)</td>
					<td class="lblbold" width="51">PSC In-Month (RMB)</td>
					<td class="lblbold" width="60">PSC To-date (RMB)</td>
					<td class="lblbold" width="43">Exps Budget (RMB)</td>
					<td class="lblbold" width="47">Exps In-Month (RMB)</td>
					<td class="lblbold" width="60">Exps To-date (RMB)</td>
					<td class="lblbold" width="43">Total Budget (RMB)</td>
					<td class="lblbold" width="47">Cost In-Month (RMB)</td>
					<td class="lblbold" width="74">Total Cost To-date (RMB)</td>
					<td class="lblbold" width="54">PSC Forecast (RMB)</td>
					<td class="lblbold" width="54">Exps Forecast (RMB)</td>
					<td class="lblbold" width="54">Forecast to Comp (RMB)</td>
				</tr>
				<%
				List list = (List)request.getAttribute("QryList");
				if(list == null || list.size() == 0){
					out.println("<br><tr><td colspan='31' class=lblerr align='center'>No Record Found.</td></tr>");
				} else {
					for (int row =0; row < list.size(); row++) {
						ProjectCost projectCost = (ProjectCost)list.get(row);
				%>
						<tr bgcolor="#e9eee1"> 
							<td class="lblbold" nowrap align="left"><%=projectCost.getProjCode()%></td>
							<td class="lblbold" nowrap align="left"><%=projectCost.getProjName()%></td>
							<td nowrap align="center"><%=projectCost.getProjectStartDateStr()%></td>
							<td nowrap align="center"><%=projectCost.getOrigCompDateStr()%></td>
							<td nowrap align="right"><%=projectCost.getServiceSalesValueStr()%></td>
							<td nowrap align="right"><%=projectCost.getLicenceSalesValueStr()%></td>
							<td nowrap align="right"><%=projectCost.getDaysBudgetStr()%></td>
							<td nowrap align="right"><%=projectCost.getDaysThisMonthStr()%></td>
							<td nowrap align="right"><%=projectCost.getDaysTodateStr()%></td>
							<td nowrap align="right"><%=projectCost.getPSCBudgetStr()%></td>
							<td nowrap align="right"><%=projectCost.getPSCThisMonthStr()%></td>
							<td nowrap align="right"><%=projectCost.getPSCTodateStr()%></td>
							<td nowrap align="right"><%=projectCost.getExpsBudgetStr()%></td>
							<td nowrap align="right"><%=projectCost.getExpsThisMonthStr()%></td>
							<td nowrap align="right"><%=projectCost.getExpsTodateStr()%></td>
							<td nowrap align="right"><%=projectCost.getTotalBudgetStr()%></td>
							<td nowrap align="right"><%=projectCost.getCostThisMonthStr()%></td>
							<td nowrap align="right"><%=projectCost.getTotalCostTodateStr()%></td>
							<td nowrap align="right"><%=projectCost.getPSCForecastStr()%></td>
							<td nowrap align="right"><%=projectCost.getExpsForecastStr()%></td>
							<td nowrap align="right"><%=projectCost.getForecasttoCompStr()%></td>
						</tr>
				<%
					}
				}
				%>
			</table>	
		</td>
	</tr>
</table>
<%
}else{
	out.println("没有访问权限.");
}
%>
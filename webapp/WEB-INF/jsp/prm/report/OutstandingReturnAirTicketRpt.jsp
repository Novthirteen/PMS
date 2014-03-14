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
<%if (AOFSECURITY.hasEntityPermission("OUTSTANDING_AIRTICKET_REPORT", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(1);
Num_formater.setMinimumFractionDigits(1);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();

String EmployeeId = request.getParameter("EmployeeId");
if (EmployeeId == null) EmployeeId = "";
String category = request.getParameter("category");
if (category == null) category = "";
String departmentId = request.getParameter("departmentId");
if (departmentId == null) departmentId = "";
String project = request.getParameter("project");
if (project == null) project = "";

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
<caption class="pgheadsmall"> Outstanding Returned Air-Ticket Report </caption> 
<tr>
	<td>
		<Form action="pas.report.OutstandingReturnAirTicketRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction">
		<table width=100%>
			<tr>
				<td colspan=8 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" >&nbsp;Employee:&nbsp;</td>
				<td class="lblbold" ><input  type="text" class="inputBox" name="EmployeeId" size="12" value="<%=EmployeeId%>"></td>
				<td class="lblbold" >&nbsp;project:&nbsp;</td>
				<td class="lblbold" ><input  type="text" class="inputBox" name="project" size="12" value="<%=project%>"></td>
				<td class="lblbold" >&nbsp;
				</td>
			</tr>
			<tr>
				<td class="lblbold" >Department:</td>
				<td class="lblbold" >
					<select name="departmentId">
					<%
					
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(departmentId)) {%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%} else{%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%}
						}
					%>
					</select>
				</td>
				<td class="lblbold" >Paid By: </td>
				<td class="lblbold" >
					<select name="category">
						<option value ="">All</option>
						<option value ="CN" <%if (category.equals("CN")) out.print("Selected");%>>Company</option>
						<option value ="CY" <%if (category.equals("CY")) out.print("Selected");%>>Customer</option>
					</select>
				</td>
		
			<td align="left" class="lblbold" >
				
			</td>
			</tr>
		</table>
		<table width=100%>
			<tr>	
			    <td width="75%"></td>
				<td align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult();return false">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel();return false">
				</td>

			</tr>
			
			<tr>
				<td colspan=8 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr bgcolor="#e9eee9">
				<td align=center  class="lblbold">&nbsp;Ticket Code&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Flight No.&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Ticket Value&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Department&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Traveller&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Flight Date&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Paid By&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Project Code&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Project Name&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Customer&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Travel Agency&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Outstanding Days&nbsp;</td>
			</tr>
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				int daytotal =0;
				for (int row =0; row < sr.getRowCount(); row++) {
					
					int dc = 0;
					if (sr.getInt(row,"dc")>0){
						dc = sr.getInt(row,"dc");
					}
					daytotal = daytotal+dc;
				%>
				
						<tr bgcolor="#e9eee1"> 
						<td class="lblbold" nowrap align=center><%= sr.getString(row,"formcode")%></td>
						<td class="lblbold" nowrap align=left><%=sr.getString(row,"refno")%></td>
						<td nowrap align=right><%=Num_formater.format(sr.getDouble(row,"totalvalue"))%> </td>
						<td nowrap align=left><%=sr.getString(row,"p_desc")%> </td>
						<td nowrap align=left><%=sr.getString(row,"name")%></td>
						<td nowrap align=center><%=Date_formater.format(sr.getDate(row,"costdate"))%></td>	
						<td nowrap align=left><%=sr.getString(row,"claimtype").equals("CN") ? "Company" : "Customer" %></td>
						<td nowrap align=left><%=sr.getString(row,"proj_id")%></td>
						<td nowrap align=left><%=sr.getString(row,"proj_name")%></td>
						<td nowrap align=left><%=sr.getString(row,"customer")%></td>
						<td nowrap align=left><%=sr.getString(row,"vendor")%></td>
						<td nowrap align=right><%=sr.getInt(row,"dc")<=0 ? 0 :sr.getInt(row,"dc") %></td>
	            </tr>
				<%}%>
				<TR bgcolor="#e9eee1"><td colspan = 11 class="lblbold" nowrap align=right>Total :</td>
				<td class="lblbold" nowrap align=right><%=daytotal%></td>
				</tr>
			<%}%>
		</table>
	</td>
</tr>
</table>

<%
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
<%}catch(Exception e){
			e.printStackTrace();
		}%>
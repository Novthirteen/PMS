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
<%if (AOFSECURITY.hasEntityPermission("SALES_PERFORMANCE", "_VIEW", session)) {%>
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
String dateStart = request.getParameter("dateStart");
String dateEnd = request.getParameter("dateEnd");
String SalesId = request.getParameter("SalesId");
if (SalesId == null) SalesId = "";
String departmentId = request.getParameter("departmentId");
if (departmentId == null) departmentId = "";
String project = request.getParameter("project");
if (project == null) project = "";
if (dateStart==null) dateStart=Date_formater.format(UtilDateTime.toDate(01,01,2005,0,0,0));
//if (dateStart==null) dateStart=Date_formater.format("2004-01-01 00:00:00.000");
if (dateEnd==null) dateEnd=Date_formater.format(nowDate);
Date dayStart;
if ( dateStart != null){
	dayStart = UtilDateTime.toDate2(dateStart + " 00:00:00.000");
}else{
	dayStart = UtilDateTime.toDate(01,01,2005,0,0,0);
}
Date dayEnd = UtilDateTime.toDate2(dateEnd + " 00:00:00.000");
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
<caption class="pgheadsmall"> Sales Performance Report </caption> 
<tr>
	<td>
		<Form action="pas.report.SalesPerformanceRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction" id="FormAction">
		<table width=100%>
			<tr>
				<td colspan=8 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">&nbsp;Employee:&nbsp;</td>
				<td>
				<input  type="text" class="inputBox" name="SalesId" size="16" value="<%=SalesId%>"></td>
				<td class="lblbold">&nbsp;project:&nbsp;</td>
				<td class="lblLight"><input  type="text" class="inputBox" name="project" size="16" value="<%=project%>"></td>
				<td class="lblbold">Department:</td>
				<td class="lblLight">
					<select name="departmentId">
					<%
					if (AOFSECURITY.hasEntityPermission("SALES_PERFORMANCE", "_ALL", session)) {
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
				<%
					boolean signedflag = false;
					if (request.getParameter("signedflag") != null) signedflag = true;
				%>
				<td align="left" class="lblbold" >
				<input type=checkbox class="checkboxstyle" name="signedflag" value="Y" <%if (signedflag) out.print("Checked");%>>
				Including Unsigned Contract Profile
				</td>		
			</tr>
		</table>
		<table width=100%>
			<tr>	
			    <td width ="75%"></td>
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
				<td align=center  class="lblbold">&nbsp;Salesperson&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Contract No.&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Project Description&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Customer Name&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Signed Date&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Department&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Project Manager&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Project Assistant&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Satrt Date&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;End Date&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Contract Amount&nbsp;</td>
				<td align=center  class="lblbold">&nbsp;Received Amount&nbsp;</td>
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
				for (int row =0; row < sr.getRowCount(); row++) {
				%>
				<tr bgcolor="#e9eee1"> 
					<td class="lblbold" nowrap align=left><%= sr.getString(row,"salesperson")%></td>
					<td class="lblbold" nowrap align=left><%=sr.getString(row,"contractno")%></td>
					<td nowrap align=left><%=sr.getString(row,"pdesc")%></td>
					<td nowrap align=left><%=sr.getString(row,"cust")%></td>
					<td nowrap align=left><%=sr.getDate(row,"signdate") == null ? "" : Date_formater.format(sr.getDate(row,"signdate"))%></td>
					<td nowrap align=left><%=sr.getString(row,"dep")%></td>
					<td nowrap align=left><%=sr.getString(row,"pmname")%></td>
					<td nowrap align=left><%=sr.getString(row,"paname")%></td>
					<td nowrap align=center><%=Date_formater.format(sr.getDate(row,"startdate"))%></td>	
					<td nowrap align=center><%=Date_formater.format(sr.getDate(row,"end_date"))%></td>	
					<td nowrap align=right><%=Num_formater.format(sr.getDouble(row,"conAmt"))%></td>
					<td nowrap align=right><%=Num_formater.format(sr.getDouble(row,"receiveAmt"))%></td>
	            </tr>
				<%}%>
				
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
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

<%if (AOFSECURITY.hasEntityPermission("PAS_TS_DETAIL", "_VIEW", session)) {%>
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
String EmployeeId = request.getParameter("EmployeeId");
String departmentId = request.getParameter("departmentId");
String project = request.getParameter("project");
if (project == null) project = "";
if (EmployeeId == null) EmployeeId = "";
if (departmentId == null) departmentId = "";

if (dateStart==null) dateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
if (dateEnd==null) dateEnd=Date_formater.format(nowDate);

Date dayStart = UtilDateTime.toDate2(dateStart + " 00:00:00.000");
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
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
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
<caption class="pgheadsmall"> Detailed Time Sheet Query</caption> 
<tr>
	<td>
		<Form action="pas.report.TSDetailRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction" id="FormAction">
		<table width=100%>
			<tr>
				<td colspan=8 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Date Range :</td>
				<td class="lblLight">
					<input  type="text" class="inputBox" name="dateStart" size="12" value="<%=Date_formater.format(dayStart)%>"><A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.dateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
					~
					<input  type="text" class="inputBox" name="dateEnd" size="12" value="<%=Date_formater.format(dayEnd)%>"><A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.dateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
				</td>
				<td class="lblbold" align = right>&nbsp;project:&nbsp;</td>
				<td class="lblLight" align =left><input  type="text" class="inputBox" name="project" size="18" value="<%=project%>"></td>
				<td class="lblbold">Employee ID:</td>
				<td class="lblLight"><input  type="text" class="inputBox" name="EmployeeId" size="12" value="<%=EmployeeId%>"></td>
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
			</tr>
			<tr>
			    <td colspan=4 align="left"/>
				<td align="left" colspan=2>
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
				<td align=center class="lblbold">&nbsp;Project ID&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Project Name&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Staff ID&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Staff Name&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Date Period&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Base Hours&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Approved Hours&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Description&nbsp;</td>
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
				out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				for (int row =0; row < sr.getRowCount(); row++) {
				%>
					<tr bgcolor="#e9eee1"> 
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"tpid"))==null) ? "":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"pname"))==null) ? "":resultSet_data)%></td>
						<td nowrap align=center><%=(((resultSet_data = sr.getObject(row,"tuserid"))==null) ? "":resultSet_data)%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"uname"))==null) ? "":resultSet_data)%></td>   
						<td nowrap align=center> <%=Date_formater.format(dayStart)%> ~ <%=Date_formater.format(dayEnd)%></td>
						<td nowrap align=right><%=Num_formater.format(sr.getDouble(row,"staff_hour"))%></td>
						<td nowrap align=right><%=Num_formater.format(sr.getDouble(row,"approved_hour"))%></td>
						<td nowrap align=left><%=(((resultSet_data = sr.getObject(row,"desp"))==null) ? "":resultSet_data)%></td>
					</tr>
				<%}
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

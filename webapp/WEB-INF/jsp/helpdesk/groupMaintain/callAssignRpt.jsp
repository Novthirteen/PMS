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
<%@ page import="com.aof.component.helpdesk.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
if (AOFSECURITY.hasEntityPermission("HELPDESK_CALL_ASSIGN_RPT", "", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
String date_begin = request.getParameter("date_begin");
String date_end	= request.getParameter("date_end");
String gid = request.getParameter("gid");
String status = request.getParameter("status");

if (date_begin == null) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	date_begin = dateFormat.format(UtilDateTime.toDate(01,01,2005,0,0,0));
}

if (date_end == null) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	date_end = dateFormat.format(new Date());
}

if (gid == null) {
	gid = "";
}

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
List groupList = hs.find("select cg from ConsultantGroup cg");

%>
<script language="javascript">
function SearchResult() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<Form action="helpdesk.callAssignReport.do" name="frm" method="post">
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Call Assignment Report</caption> 
	<tr>
		<td>
				<input type="hidden" name="formAction">
				<table width=100% >
					<tr>
						<td colspan="16" valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblbold">Group:</td>
						<td class="lblLight">
							<select name="gid">
								<%
								if(groupList!=null)
								{
									Iterator group_ite = groupList.iterator();
									while(group_ite.hasNext()){
									ConsultantGroup group = (ConsultantGroup)group_ite.next();
								%>
									<option value="<%=group.getId()%>" <%if(gid.equals(String.valueOf(group.getId().intValue()))) out.print("selected");%>><%=group.getDescription()%></option>
								<%}}%>
							</select>
						</td>
						<td class="lblbold">Date Range:</td>
						<td class="lblLight">
							<input  type="text" class="inputBox" name="date_begin" size="12" value="<%=date_begin%>">
							<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.date_begin,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
							&nbsp;~&nbsp;<input  type="text" class="inputBox" name="date_end" size="12" value="<%=date_end%>">
							<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.date_end,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
					
					    <td colspan=2 align="right"></td>
					    <td colspan=2 align="center">
							<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
						</td>
					</tr>
					<tr>
						<td colspan="16" valign="top"><hr color=red></hr></td>
					</tr>
				</table>
		</td>
	</tr>
</table>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
	<tr>
		<td>
			<display:table name="requestScope.QryList1.rows" export="true" class="ITS" requestURI="helpdesk.callAssignReport.do">
				<display:column property="consultant" title="Assignee"/>
				<display:column property="total_calls" title="Total Calls"/>
				<display:column property="open_calls" title="Open Calls"/>
				<display:column property="hours" title="Total Working Hours"/>
			</display:table>
		</td>
	</tr>
</table>
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Latest 10 Calls</caption> 
	<tr>
		<td valign="bottom" colspan="16"><hr color=red></hr></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
		<td colspan="4">Status:&nbsp;&nbsp;
			<select name="status">
				<option value="unclose" <%=(status!=null&&status.equals("unclose"))?"selected":""%>>Unclosed</option>
				<option value="All" <%=(status!=null&&status.equals("All"))?"selected":""%>>All</option>
				<option value="OPEN" <%=(status!=null&&status.equals("OPEN"))?"selected":""%>>Open</option>
				<option value="ACCEPT" <%=(status!=null&&status.equals("ACCEPT"))?"selected":""%>>Accept</option>
				<option value="SOLVE" <%=(status!=null&&status.equals("SOLVE"))?"selected":""%>>Solve</option>
				<option value="CLOSE" <%=(status!=null&&status.equals("CLOSE"))?"selected":""%>>Close</option>
			</select>
		</td>		
		<td colspan="2" align="center">
			<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
		</td>
	</tr>
</table>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
	<tr>
		<td>
			<display:table name="requestScope.QryList2.rows" class="ITS" requestURI="helpdesk.callAssignReport.do">
				<display:column property="consultant" title="Assignee"/>
				<display:column property="tno" title="Call Number"/>
				<display:column property="cust" title="Customer"/>
				<display:column property="contact" title="Contact"/>
				<display:column property="tele" title="Telephone Code"/>	
				<display:column property="email" title="Email"/>
				<display:column property="status" title="Status"/>	
				<display:column property="acc_date" title="Open Date"/>	
				<display:column property="res_date" title="Accept Date"/>
				<display:column property="slv_date" title="Slove Date"/>	
				<display:column property="cls_date" title="Close Date"/>
			</display:table>
		</td>
	</tr>
</table>
</form>
<%
}else{
	out.println("没有访问权限.");
}
} catch(Exception ex) {
	ex.printStackTrace();
}
%>
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
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
if (AOFSECURITY.hasEntityPermission("OUTSTANDING_ACCEPTANCE_RPT", "_VIEW", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
String date_begin = request.getParameter("date_begin");
String date_end	= request.getParameter("date_end");
String dpt = request.getParameter("dpt");
String project = request.getParameter("project");
String pa = request.getParameter("pa");
//List partyList = (List)request.getAttribute("PartyList");

if (date_begin == null) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	date_begin = dateFormat.format(UtilDateTime.toDate(01,01,2005,0,0,0));
}

if (date_end == null) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	date_end = dateFormat.format(new Date());
}

if (dpt == null) {
	dpt = "";
}

if (project == null) {
	project = "";
}

if (pa == null) {
	pa = "";
}
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
List partyList=null;
try{
	PartyHelper ph = new PartyHelper();
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	partyList=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
	if (partyList == null) partyList = new ArrayList();
	partyList.add(0,ul.getParty());
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
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Outstanding Acceptance Report</caption> 
	<tr>
		<td>
			<Form action="pas.report.OutstandingAcceptanceRpt.do" name="frm" method="post">
				<input type="hidden" name="formAction" id="formAction">
				<table width=100% >
					<tr>
						<td colspan="16" valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblbold">Project:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="project" size="12" value="">
						</td>
						<td class="lblbold">PA:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="pa" size="12" value="">
						</td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="dpt">
							<%
							if (AOFSECURITY.hasEntityPermission("OUTSTANDING_ACCEPTANCE_RPT", "_ALL", session)) {
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if (p.getPartyId().equals(dpt)) {
							%>
									<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%
									} else{
							%>
									<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%
									}
								}
							}
							%>
							</select>
						</td>
					</tr>
			
					<tr>

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
			</form>
		</td>
	</tr>
</table>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
	<tr>
		<td>
			<display:table name="requestScope.QryList.rows" export="true" class="ITS" requestURI="pas.report.OutstandingAcceptanceRpt.do" pagesize="15">
				<display:column property="proj_id" title="Project Code"/>
				<display:column property="proj_name" title="Project Name"/>
				<display:column property="pp" title="Customer/Supplier"/>
				<display:column property="proj_category" title="Contract Category"/>	
				<display:column property="proj_phase" title="Phase"/>	
				<display:column property="value1" title="Phase Value"/>	
				<display:column property="est_close_date" title="Estimated Close Date" sortable="true"/>
				<display:column property="pm" title="PM"/>	
				<display:column property="pa" title="PA"/>
			</display:table>
		</td>
	</tr>
</table>
<%
}else{
	out.println("没有访问权限.");
}
} catch(Exception ex) {
	ex.printStackTrace();
}
%>
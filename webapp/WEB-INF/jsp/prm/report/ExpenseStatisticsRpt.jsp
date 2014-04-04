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
if (AOFSECURITY.hasEntityPermission("EXPENSE_STATISTICS_RPT", "_VIEW", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
String begin_date = request.getParameter("begin_date");
String end_date	= request.getParameter("end_date");
String dpt = request.getParameter("dpt");

if (begin_date == null) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	begin_date = dateFormat.format(UtilDateTime.toDate(01,01,2005,0,0,0));
}

if (end_date == null) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	end_date = dateFormat.format(new Date());
}

if (dpt == null) {
	dpt = "All";
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
	<caption class="pgheadsmall">Expense Statistics Report</caption> 
	<tr>
		<td>
			<Form action="pas.report.ExpenseStatisticsRpt.do" name="frm" method="post">
				<input type="hidden" name="formAction" id="formAction">
				<table width=100% >
					<tr>
						<td colspan="16" valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="dpt">
							<%
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
							%>
									<option value="<%=p.getPartyId()%>" <%=dpt.equals(p.getPartyId())?"selected":""%>><%=p.getDescription()%></option>
							<%
								}
							%>
							</select>
						</td>
						<td class="lblbold">Date Range:</td>
						<td class="lblLight">
							<input  type="text" class="inputBox" name="begin_date" size="12" value="<%=begin_date%>">
							<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.begin_date,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
							&nbsp;~&nbsp;<input  type="text" class="inputBox" name="end_date" size="12" value="<%=end_date%>">
							<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.end_date,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
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
			<display:table name="requestScope.QryList.rows" export="true" class="ITS" requestURI="pas.report.ExpenseStatisticsRpt.do" pagesize="20">
				<display:column property="user_name" title="Employee"/>
				<display:column property="total" title="Total Claimed Amount"/>
				<display:column property="hotel" title="Hotel"/>
				<display:column property="meal" title="Meal"/>	
				<display:column property="travel" title="Transport(Travel)"/>	
				<display:column property="allowance" title="Allowance"/>	
				<display:column property="telephone" title="Telephone"/>
				<display:column property="misc" title="Misc"/>
				<display:column property="ot" title="Transport(OT)"/>
				<display:column property="entertainment" title="Entertainment"/>
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
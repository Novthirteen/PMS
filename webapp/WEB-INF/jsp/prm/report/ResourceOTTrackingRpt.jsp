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
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%try{%>
<%if (AOFSECURITY.hasEntityPermission("RESOURCE_OT_TRACKING_RPT", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(1);
Num_formater.setMinimumFractionDigits(1);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
String proj = request.getParameter("proj");
String departmentId = request.getParameter("departmentId");
String cust = request.getParameter("cust");
String user = request.getParameter("user");
String date_begin = request.getParameter("date_begin");
String date_end	= request.getParameter("date_end");
if (proj == null) proj = "";
if (departmentId == null) departmentId = "";
if (cust == null) cust = "";
if (user == null) user = "";
if (date_begin == null) {
	date_begin = Date_formater.format(UtilDateTime.toDate(01,01,2005,0,0,0));
}

if (date_end == null) {
	date_end = Date_formater.format(new Date());
}

%>
<script language="javascript">
function SearchResult() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
</script>
<style>
.mid{text-align:center}
</style>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> Resource Overtime Tracking Report</caption> 
<tr>
	<td>
		<Form action="pas.report.ResourceOTTrackingRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction">
		<table width=100%>
			<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Project:</td>
				<td class="lblLight"><input type="text" name="proj" size="15" value="<%=proj%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Staff:</td>
				<td class="lblLight"><input type="text" name="user" size="15" value="<%=user%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Customer:</td>
				<td class="lblLight"><input type="text" name="cust" size="15" value="<%=cust%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
	    	</tr>
	    	<tr>
	    		<td class="lblbold">Date:</td>
	    		<td class="lblLight">
	    			<input  type="text" class="inputBox" name="date_begin" size="12" value="<%=date_begin%>">
							<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.date_begin,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
	    					&nbsp;~&nbsp;<input  type="text" class="inputBox" name="date_end" size="12" value="<%=date_end%>">
							<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.date_end,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
	    		</td>
				<td class="lblbold">Department:</td>
				<td class="lblLight">
					<select name="departmentId">
					<option value="">All Related To You</option>	
					<%
					if (AOFSECURITY.hasEntityPermission("RESOURCE_OT_TRACKING_RPT", "_ALL", session)) {
						UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
						PartyHelper ph = new PartyHelper();
						List partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
						if (partyList_dep == null) partyList_dep = new ArrayList();
						partyList_dep.add(0,ul.getParty());
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
			    <td colspan=5 align="left"/>
				<td align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
				</td>
			</tr>
			<tr>
				<td colspan=6 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
</table>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
	<tr>
		<td>
			<display:table name="requestScope.QryList.rows" export="true" class="ITS" requestURI="pas.report.ResourceOTTrackingRpt.do" pagesize="15">
				<display:column property="proj_id" title="Project Code" group="1"/>
				<display:column property="proj_name" title="Project Name" group="2"/>
				<display:column property="customer" title="Customer" group="3"/>		
				<display:column property="name" title="Staff" group="4"/>
				<display:column property="ts_date" title="Date" class="mid"/>
				<display:column property="event" title="Event"/>
				<display:column property="hrs" title="TS_Hours"/>
			</display:table>
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
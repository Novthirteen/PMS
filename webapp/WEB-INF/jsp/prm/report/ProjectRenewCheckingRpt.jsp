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
<%if (AOFSECURITY.hasEntityPermission("PROJECT_RENEW_CHECKING_RPT", "_VIEW", session)) {%>
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
String cust = request.getParameter("cust");
String pm = request.getParameter("pm");
String pa = request.getParameter("pa");
String depId = request.getParameter("depId");
if (proj == null) proj = "";
if (cust == null) cust = "";
if (pm == null) pm = "";
if (pa == null) pa = "";
if (depId == null) depId = "";

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
<caption class="pgheadsmall"> Project Renew Checking Report</caption> 
<tr>
	<td>
		<Form action="pas.report.ProjectRenewCheckingRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction" id="FormAction">
		<table width=100%>
			<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Project:</td>
				<td class="lblLight"><input type="text" name="proj" size="15" value="<%=proj%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Customer:</td>
				<td class="lblLight"><input type="text" name="cust" size="15" value="<%=cust%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">PM:</td>
				<td class="lblLight"><input type="text" name="pm" size="15" value="<%=pm%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
	    	</tr>
	    	<tr>
	    		<td class="lblbold">PA:</td>
	    		<td class="lblLight">
	    			<input type="text" name="pa" size="15" value="<%=pa%>" style="TEXT-ALIGN: right" class="lbllgiht">
	    		</td>
				<td class="lblbold">Department:</td>
				<td class="lblLight">
					<select name="depId">
					<option value="">All Related To You</option>	
					<%
					if (AOFSECURITY.hasEntityPermission("PROJECT_RENEW_CHECKING_RPT", "_ALL", session)) {
						UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
						PartyHelper ph = new PartyHelper();
						List partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
						if (partyList_dep == null) partyList_dep = new ArrayList();
						partyList_dep.add(0,ul.getParty());
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(depId)) {%>
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
			<display:table name="requestScope.QryList.rows" export="true" class="ITS" requestURI="pas.report.ProjectRenewCheckingRpt.do" pagesize="15">
				<display:column property="proj_id" title="Project Code"/>
				<display:column property="proj_name" title="Project Name"/>
				<display:column property="cust_name" title="Customer"/>		
				<display:column property="pm" title="PM"/>
				<display:column property="conType" title="Contract Type"/>
				<display:column property="value" title="Total Value"/>
				<display:column property="pa" title="PA"/>
				<display:column property="status" title="Status"/>
				<display:column property="start_date" title="StartDate"/>
				<display:column property="end_date" title="EndDate"/>
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
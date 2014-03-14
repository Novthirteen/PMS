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
<%if (AOFSECURITY.hasEntityPermission("PAS_EXPSUMMARY_REPORT", "_VIEW", session)) {%>
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
String user = request.getParameter("user");
if (user == null) user = "";

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
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "QueryForList";
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
<caption class="pgheadsmall"> Expense Summary Report </caption> 
<tr>
	<td>
		<Form action="pas.report.ExpenseSummaryRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction">
		<table width=100%>
			<tr>
				<td colspan=8 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" >&nbsp;Employee:&nbsp;</td>
				<td class="lblbold" ><input  type="text" class="inputBox" name="user" size="12" value="<%=user%>"></td>
				<td class="lblbold" >&nbsp;project:&nbsp;</td>
				<td class="lblbold" ><input  type="text" class="inputBox" name="project" size="12" value="<%=project%>"></td>
				<td class="lblbold" >&nbsp;Date Range :&nbsp;
					<input  type="text" class="inputBox" name="dateStart" size="12" value="<%=Date_formater.format(dayStart)%>"><A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.dateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
					~
					<input  type="text" class="inputBox" name="dateEnd" size="12" value="<%=Date_formater.format(dayEnd)%>"><A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.dateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
				</td>
			</tr>
			<tr>
				<td class="lblbold" >Department:</td>
				<td class="lblbold" >
					<select name="departmentId">
					<option value="">All Related To You</option>
					<%
					if (AOFSECURITY.hasEntityPermission("PAS_EXPSUMMARY_REPORT", "_ALL", session)) {
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
				<td class="lblbold" > </td>
				<td class="lblbold" >
					
				</td>
			
			<td align="left" class="lblbold" >
				<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult();return false">
			</td>
			</tr>
		</table>
		</form>
	</td>
</tr>
</table>
<table width="100%">
<tr><td>
		<div width="100%">
		<display:table name="requestScope.QryList.rows" export="true" class="ITS" requestURI="pas.report.ExpenseSummaryRpt.do" pagesize="15">
			<display:column property="em_proj_id" title="Project Code"  sortable="true"/>
			<display:column property="em_code" title="Expense Form Code"  />
			<display:column property="expenseUser" title="User"  />
			<display:column property="description" title="Department"  />
			<display:column property="amt" title="Expense Amount"  />
			<display:column property="em_curr_id" title="Currency"  />
			<display:column property="expenseUser" title="User"  />
			<display:column property="paidby" title="Paid By"  />
			<display:column property="em_status" title="Status"  />
			<display:column property="entryDate" title="Entry Date"  />
			<display:column property="expDate" title="Expense Date"  />
			<display:column property="appDate" title="Approval Date"  />
			<display:column property="payDate" title="Claimed Date"  />
		</display:table>
		</div>
</td></tr>
</table>

<%
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
<%}catch(Exception e){
			e.printStackTrace();
		}%>
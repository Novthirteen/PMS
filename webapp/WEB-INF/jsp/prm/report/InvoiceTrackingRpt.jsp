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
if (AOFSECURITY.hasEntityPermission("INVOICE_TRACKING_RPT", "_VIEW", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
String invoiceCode = request.getParameter("invoiceCode");
String invoiceStatus = request.getParameter("invoiceStatus");
String dpt = request.getParameter("dpt");
String project = request.getParameter("project");
String pa = request.getParameter("pa");
String billto = request.getParameter("billto");
String outstandingDays = request.getParameter("outstandingDays");
String compareDate =  request.getParameter("compareDate");
//List partyList = (List)request.getAttribute("PartyList");

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
if (invoiceCode == null) {
	invoiceCode = "";
}
if (invoiceStatus == null) {
	invoiceStatus = "";
}
if (compareDate == null) {
	compareDate = dateFormat.format(new Date());
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
if (billto == null) {
	billto = "";
}
if (outstandingDays == null) {
	outstandingDays = "";
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
	if (formObj.elements["outstandingDays"].value == "" ){
		alert("Please specify the outstanding days.");
		return false;
	}
	formObj.elements["formAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function showBillToDialog()
{
	var code,desc;
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.customer.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			document.getElementById("billto").value = v.split("|")[1];
		}
	}
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">Invoice Tracking Report</caption> 
	<tr>
		<td>
			<Form action="pas.report.InvoiceTrackingRpt.do" name="frm" method="post">
				<input type="hidden" name="formAction" id="formAction">
				<table width=100% >
					<tr>
						<td colspan="16" valign="bottom"><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblbold">Invoice Code:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="invoiceCode" size="12" value="<%=invoiceCode%>">
						</td>
						<td class="lblbold">Project:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="project" size="12" value="<%=project%>">
						</td>
						<td class="lblbold">PA:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="pa" size="12" value="<%=pa%>">
						</td>
						<td class="lblbold">Bill To:</td>
						<td class="lblLight">
							<input type="text" name="billto" id="billto" size="15" value="<%=billto%>" style="TEXT-ALIGN: right" class="lbllgiht">
							<a href="javascript:void(0)" onclick="showBillToDialog();event.returnValue=false;">
										<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
						</td>
					</tr>
			
					<tr>
						<td class="lblbold">Outstanding Days:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="outstandingDays" size="8" value="<%=outstandingDays%>">
						</td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="dpt">
							<%
							if (AOFSECURITY.hasEntityPermission("INVOICE_TRACKING_RPT", "_ALL", session)) {
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
						<td class="lblbold">Invoice Status:</td>
						<td class="lblLight">
							<select name="invoiceStatus" >
								<option value="Undelivered" <%if (invoiceStatus.equals("Undelivered")) out.print("selected");%>>Undelivered</option>
								<option value="Delivered" <%if (invoiceStatus.equals("Delivered")) out.print("selected");%>>Delivered</option>
							<!--<option value="Confirmed" <%if (invoiceStatus.equals("Confirmed")) out.print("selected");%>>Confirmed</option>
								<option value="In Process" <%if (invoiceStatus.equals("In Process")) out.print("selected");%>>In Process</option>-->
						    </select>
					    </td>
						<td class="lblbold">Compare Date:</td>
						<td class="lblLight">
							<input  type="text" class="inputBox" name="compareDate" size="12" value="<%=compareDate%>">
							<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.compareDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
					</tr>
					<tr>
					    <td colspan=6 align="right"></td>
					    <td align="center">
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
			<display:table name="requestScope.QryList.rows" export="true" class="ITS" requestURI="pas.report.InvoiceTrackingRpt.do" pagesize="15">
				<display:column property="inv_code" title="Invoice Code" sortable="true"/>
				<display:column property="inv_status" title="Invoice Status"/>
				<display:column property="proj_name" title="Project Name"/>
				<display:column property="billAddr" title="Bill To"/>	
				<display:column property="department" title="Department"/>	
				<display:column property="paName" title="PA"/>
				<display:column property="inv_createdate" title="Create Date"/>	
				<display:column property="ems_date" title="EMS Date" />
				<display:column property="currency" title="Currency"/>	
				<display:column property="inv_amount" title="Invoice Amount"/>
				
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
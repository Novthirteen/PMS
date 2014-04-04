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
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
if (AOFSECURITY.hasEntityPermission("PAS_AR_AGING", "_VIEW", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
String date = request.getParameter("date");
String customerBranch = request.getParameter("customerBranch");
String billTo = request.getParameter("billTo");
String customer = request.getParameter("customer");
String project = request.getParameter("project");
String department = request.getParameter("department");
List partyList = (List)request.getAttribute("PartyList");

if (date == null) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	date = dateFormat.format(new Date());
}

Date day = UtilDateTime.toDate2(date + " 00:00:00.000");

if (customerBranch == null) {
	customerBranch = "";
}

if (billTo == null) {
	billTo = "";
}

if (customer == null) {
	customer = "";
}

if (project == null) {
	project = "";
}

if (department == null) {
	UserLogin userLogin = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
	if (userLogin != null) {
		department = userLogin.getParty().getPartyId();
	}
}
%>
<script language="javascript">
function showCustomerDialog()
{
	var code,desc;
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.customer.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			document.getElementById("customer").value = v.split("|")[1];
		}
	}
}
function showBillToDialog()
{
	var code,desc;
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.billto.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			document.getElementById("billTo").value = v.split("|")[1];
		}
	}
}
function showInvoiceDetail(invoiceId) {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.projectInvoice.showinovice.dialog.title&editInvoice.do?formAction=dialogView&invoiceId=" + invoiceId,
		null,
	'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
}
function SearchResult() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
function ExportSExcel() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "ExportToSummarizedExcel";
	formObj.target = "_self";
	formObj.submit();
}
function ExportPTExcel() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "ExportToPTExcel";
	formObj.target = "_self";
	formObj.submit();
}
function showARTracking(id){
	var param = "?projId=" + id;
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.projectInvoice.customer.dialog.title&listARTracking.do" + param,
	null,
	'dialogWidth:800px;dialogHeight:400px;status:no;help:no;scroll:no');		
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">AR Aging Report</caption> 
	<tr>
		<td>
			<Form action="pas.report.ARAgingRpt.do" name="frm" method="post">
				<input type="hidden" name="formAction" id="formAction">
				<table width=100%>
					<tr>
						<td colspan="18" valign="bottom"><hr color=red></hr></td>
					</tr>
			
					<tr>
						<td class="lblbold">Date:</td>
						<td class="lblLight">
							<input  type="text" class="inputBox" name="date" size="12" value="<%=date%>">
							<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.date,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
						<td class="lblbold">Customer Branch:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="customerBranch" size="12" value="<%=customerBranch%>">
						</td>
						<td class="lblbold">Bill To:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="billTo" id="billTo" size="12" value="<%=billTo%>">
							<a href="javascript:void(0)" onclick="showBillToDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
						</td>
					</tr>
					
					<tr>
						<td class="lblbold">Customer:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="customer" id="customer" size="12" value="<%=customer%>">
							<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
						</td>
						<td class="lblbold">Project:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="project" size="12" value="<%=project%>">
						</td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="department">
							<%
							if (AOFSECURITY.hasEntityPermission("PAS_AR_AGING", "_ALL", session)) {
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if (p.getPartyId().equals(department)) {
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
					    <td colspan=2 align="left"/>
						<td colspan=4 align="left">
							<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
							<input TYPE="button" class="button" name="btnExport" value="Export Detailed Excel" onclick="javascript:ExportExcel()">
							<input TYPE="button" class="button" name="btnExport" value="Export Summarized Excel" onclick="javascript:ExportSExcel()">
							<input TYPE="button" class="button" name="btnExport" value="Export Excel By Project Tracking" onclick="javascript:ExportPTExcel()">
						</td>
					</tr>
					<tr>
						<td colspan="18" valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
</table>

<table width="100%" cellpadding="1" border="0" cellspacing="1">
	<tr>
		<td>
			<table border="0" cellpadding="2" cellspacing="2" width=100%>
				<tr bgcolor="#e9eee9">
					<td class="lblbold" align="center" rowspan="2">Customer Branch</td>
					<td class="lblbold" align="center" rowspan="2">Bill To</td>
					<td class="lblbold" align="center" rowspan="2">Customer</td>
					<td class="lblbold" align="center" rowspan="2">Project</td>
					<td class="lblbold" align="center" rowspan="2">Inovice</td>
					<td class="lblbold" align="center" rowspan="2">Department</td>
					<td class="lblbold" align="center" rowspan="2">Outstanding</td>
					<td class="lblbold" align="center" colspan="9">Number of Days Overdue</td>
				</tr>
				<tr bgcolor="#e9eee9">
					<td class="lblbold" align="center">Current</td>
					<td class="lblbold" align="center">31 - 60</td>
					<td class="lblbold" align="center">61 - 90</td>
					<td class="lblbold" align="center">91 - 120</td>
					<td class="lblbold" align="center">121 - 150</td>
					<td class="lblbold" align="center">151 - 180</td>
					<td class="lblbold" align="center">181 - 210</td>
					<td class="lblbold" align="center">211 - 360</td>
					<td class="lblbold" align="center">Over 360</td>
				</tr>
				<%
				SQLResults sqlResult = (SQLResults)request.getAttribute("QryList");
				if(sqlResult == null || sqlResult.getRowCount() == 0){
					out.println("<br><tr><td colspan='31' class=lblerr align='center'>No Record Found.</td></tr>");
				} else {
					NumberFormat numFormat = NumberFormat.getInstance();
					numFormat.setMaximumFractionDigits(2);
					numFormat.setMinimumFractionDigits(2);
					
					String oldCustomerBranch = "";
					String oldCustomer = "";
					String oldProj = "";
					String oldBillTo = "";
					for (int row =0; row < sqlResult.getRowCount(); row++) {
						double invoiceAmount = sqlResult.getDouble(row, "invoiceAmount");
						double receiveAmount = sqlResult.getDouble(row, "receiveAmount");
						
						if(Math.abs(invoiceAmount-receiveAmount)<1)	continue;
						
						Date dueDate = sqlResult.getDate(row, "dueDate");
						long dayDiff = UtilDateTime.getDayDistance(day, dueDate);
						
						double outstandingAmt = 0L;
						double currAmt = 0L;
						double between31To60Amt = 0L;
						double between61To90Amt = 0L;
						double between91To120Amt = 0L;
						double between121To150Amt = 0L;
						double between151To180Amt = 0L;
						double between181To210Amt = 0L;
						double between211To360Amt = 0L;
						double over360Amt = 0L;
						
						outstandingAmt += invoiceAmount - receiveAmount;
						if (dayDiff <= 30) {
							currAmt += invoiceAmount - receiveAmount;
						} else if (dayDiff > 30 && dayDiff <= 60) {
							between31To60Amt += invoiceAmount - receiveAmount;
						} else if (dayDiff > 60 && dayDiff <= 90) {
							between61To90Amt += invoiceAmount - receiveAmount;
						} else if (dayDiff > 90 && dayDiff <= 120) {
							between91To120Amt += invoiceAmount - receiveAmount;
						} else if (dayDiff > 120 && dayDiff <= 150) {
							between121To150Amt += invoiceAmount - receiveAmount;
						} else if (dayDiff > 150 && dayDiff <= 180) {
							between151To180Amt += invoiceAmount - receiveAmount;
						} else if (dayDiff > 180 && dayDiff <= 210) {
							between181To210Amt += invoiceAmount - receiveAmount;
						} else if (dayDiff > 210 && dayDiff <= 360) {
							between211To360Amt += invoiceAmount - receiveAmount;
						} else {
							over360Amt += invoiceAmount - receiveAmount;
						}						
							
				%>
				<tr bgcolor="#e9eee1"> 
					<td class="lblbold"  align="left">
					<%
					String newCustomerBranch = sqlResult.getString(row, "customerBranch");
					if (!newCustomerBranch.equals(oldCustomerBranch))
					  {
					  	out.print(newCustomerBranch);
					  }
					%>
					</td>
					<td class="lblbold"  align="left">
					<%
					String newBillTo = sqlResult.getString(row, "billTo");
					if (!oldBillTo.equals(newBillTo))
					  {
					  	out.print(newBillTo);
					  }
					%>
					</td>
					<td class="lblbold"  align="left">
					<%
					String newCustomer = sqlResult.getString(row, "customer");
					if (!oldCustomer.equals(newCustomer))
					  {
					  	out.print(newCustomer);
					  }
					%>
					</td>
					<td class="lblbold"  align="left">
					<%
					String newProj = sqlResult.getString(row, "projectId");
					if (!oldProj.equals(newProj))
					  {
					  	out.print("<a href=# onclick=showARTracking('"+newProj+"')>"+newProj+ ":" + sqlResult.getString(row, "projectName")+"</a>");
					  }
					%>
					</td>
					<td class="lblbold"  align="left">
						<a href="#" onclick="showInvoiceDetail('<%=sqlResult.getLong(row, "invoiceID")%>');"><%=sqlResult.getString(row, "inoviceCode")%></a>
					</td>
					<td class="lblbold"  align="left"><%=sqlResult.getString(row, "department")%></td>
					<td  align="right"><%=numFormat.format(outstandingAmt)%></td>
					<td  align="right"><%=currAmt != 0L ? numFormat.format(currAmt) : ""%></td>
					<td  align="right"><%=between31To60Amt != 0L ? numFormat.format(between31To60Amt) : ""%></td>
					<td  align="right"><%=between61To90Amt != 0L ? numFormat.format(between61To90Amt) : ""%></td>
					<td  align="right"><%=between91To120Amt != 0L ? numFormat.format(between91To120Amt) : ""%></td>
					<td  align="right"><%=between121To150Amt != 0L ? numFormat.format(between121To150Amt) : ""%></td>
					<td  align="right"><%=between151To180Amt != 0L ? numFormat.format(between151To180Amt) : ""%></td>
					<td  align="right"><%=between181To210Amt != 0L ? numFormat.format(between181To210Amt) : ""%></td>
					<td  align="right"><%=between211To360Amt != 0L ? numFormat.format(between211To360Amt) : ""%></td>
					<td  align="right"><%=over360Amt != 0L ? numFormat.format(over360Amt) : ""%></td>
				</tr>
				<%
					oldCustomerBranch = newCustomerBranch;
					oldBillTo = newBillTo;
					oldCustomer = newCustomer;
					oldProj = newProj;
					}
				}
				%>
			</table>	
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
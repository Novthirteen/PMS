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
if (AOFSECURITY.hasEntityPermission("PAS_AP_AGING", "_VIEW", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
String date = request.getParameter("date");
String customerBranch = request.getParameter("customerBranch");
String payTo = request.getParameter("payTo");
String poProject = request.getParameter("poProject");
String department = request.getParameter("department");
List partyList = (List)request.getAttribute("PartyList");

if (date == null) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	date = dateFormat.format(new Date());
}

Date day = UtilDateTime.toDate2(date + " 00:00:00.000");

if (payTo == null) {
	payTo = "";
}

if (poProject == null) {
	poProject = "";
}

if (department == null) {
	UserLogin userLogin = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
	if (userLogin != null) {
		department = userLogin.getParty().getPartyId();
	}
}
%>
<script language="javascript">
function showVendorDialog()
{
	var code,desc;
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payto.dialog.title&crm.dialogVendorList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			document.getElementById("payTo").value = v.split("|")[1];
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
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
	<caption class="pgheadsmall">AP Aging Report</caption> 
	<tr>
		<td>
			<Form action="pas.report.APAgingRpt.do" name="frm" method="post">
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
						<td class="lblbold">Pay To:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="payTo" id="payTo" size="12" value="<%=payTo%>">
							<a href="javascript:void(0)" onclick="showVendorDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
						</td>
					</tr>
					
					<tr>
						<td class="lblbold">PO Project:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="poProject" size="12" value="<%=poProject%>">
						</td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="department">
							<%
							if (AOFSECURITY.hasEntityPermission("PAS_AP_AGING", "_ALL", session)) {
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
						<td colspan=4 align="left">
							<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">
							<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
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
					<td class="lblbold" align="center" rowspan="2">Vendor</td>
					<td class="lblbold" align="center" rowspan="2">Related Contract Project</td>
					<td class="lblbold" align="center" rowspan="2">PO Project</td>
					<td class="lblbold" align="center" rowspan="2">Supplier Invoice No.</td>
					<td class="lblbold" align="center" rowspan="2">Supplier Invoice Type</td>
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
					
					String oldContractProj = "";
					String oldPOProj = "";
					String oldVendor = "";
					for (int row =0; row < sqlResult.getRowCount(); row++) {
						double supplierInvoiceAmount = sqlResult.getDouble(row, "supplierInvoiceAmount");
						double paidAmount = sqlResult.getDouble(row, "paidAmount");
						
						//if(Math.abs(supplierInvoiceAmount-paidAmount)<1)	continue;
						
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
						
						outstandingAmt += supplierInvoiceAmount - paidAmount;
						if (dayDiff <= 30) {
							currAmt += supplierInvoiceAmount - paidAmount;
						} else if (dayDiff > 30 && dayDiff <= 60) {
							between31To60Amt += supplierInvoiceAmount - paidAmount;
						} else if (dayDiff > 60 && dayDiff <= 90) {
							between61To90Amt += supplierInvoiceAmount - paidAmount;
						} else if (dayDiff > 90 && dayDiff <= 120) {
							between91To120Amt += supplierInvoiceAmount - paidAmount;
						} else if (dayDiff > 120 && dayDiff <= 150) {
							between121To150Amt += supplierInvoiceAmount - paidAmount;
						} else if (dayDiff > 150 && dayDiff <= 180) {
							between151To180Amt += supplierInvoiceAmount - paidAmount;
						} else if (dayDiff > 180 && dayDiff <= 210) {
							between181To210Amt += supplierInvoiceAmount - paidAmount;
						} else if (dayDiff > 210 && dayDiff <= 360) {
							between211To360Amt += supplierInvoiceAmount - paidAmount;
						} else {
							over360Amt += supplierInvoiceAmount - paidAmount;
						}						
							
				%>
				<tr bgcolor="#e9eee1">
					<td class="lblbold"  align="left">
					<%
					String newVendor = sqlResult.getString(row, "vendorId");
					if (!oldVendor.equals(newVendor))
					  {
					  	out.print(sqlResult.getString(row, "vendorNm"));
					  }
					%>
					</td>
					<td class="lblbold"  align="left">
					<%
					String newContractProj = sqlResult.getString(row, "contractProjectId");
					if (!oldContractProj.equals(newContractProj))
					  {
					  	out.print(newContractProj+ ":" + sqlResult.getString(row, "contractProjectNm"));
					  }
					%>
					</td>
					<td class="lblbold"  align="left">
					<%
					String newPOProj = sqlResult.getString(row, "POProjectId");
					if (!oldPOProj.equals(newPOProj))
					  {
					  	out.print(newPOProj+ ":" + sqlResult.getString(row, "POProjectNm"));
					  }
					%>
					</td>
					<td class="lblbold"  align="left">
						<%=sqlResult.getString(row, "supplierInvoiceNo")%>
					</td>
					<td class="lblbold"  align="left">
						<%=sqlResult.getString(row, "supplierInvoicePayType")%>
					</td>
					<td class="lblbold"  align="left"><%=sqlResult.getString(row, "departmentNm")%></td>
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
					oldContractProj = newContractProj;
					oldPOProj = newPOProj;
					oldVendor = newVendor;
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
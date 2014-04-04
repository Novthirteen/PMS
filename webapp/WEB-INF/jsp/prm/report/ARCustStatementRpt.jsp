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
if (AOFSECURITY.hasEntityPermission("PAS_AR_CS", "_VIEW", session)) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
String date = request.getParameter("date");
String billTo = request.getParameter("billTo");
String customer = request.getParameter("customer");
String contractNo = request.getParameter("contractNo");
String department = request.getParameter("department");
String show0AmtOpen = request.getParameter("show0AmtOpen");
List partyList = (List)request.getAttribute("PartyList");

if (date == null) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	date = dateFormat.format(new Date());
}

if (billTo == null) {
	billTo = "";
}

if (customer == null) {
	customer = "";
}

if (contractNo == null) {
	contractNo = "";
}

if (department == null) {
	UserLogin userLogin = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
	if (userLogin != null) {
		department = userLogin.getParty().getPartyId();
	}
}

if (show0AmtOpen == null) {
	show0AmtOpen = "";
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
function showReceiptDetail(receiptId) {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.projectInvoice.showreceipt.dialog.title&editReceipt.do?formAction=dialogView&receiptId=" + receiptId,
		null,
	'dialogWidth:640px;dialogHeight:300px;status:no;help:no;scroll:auto');
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
	<caption class="pgheadsmall">Customer Statement Report</caption> 
	<tr>
		<td>
			<Form action="pas.report.ARCustStatementRpt.do" name="frm" method="post">
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
						<td class="lblbold">Bill To:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="billTo" id="billTo" size="12" value="<%=billTo%>">
							<a href="javascript:void(0)" onclick="showBillToDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
						</td>
						<td class="lblbold">Customer:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="customer" id="customer" size="12" value="<%=customer%>">
							<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
						</td>
					</tr>

					<tr>
						<td class="lblbold">ContractNo:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="contractNo" size="12" value="<%=contractNo%>">
						</td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="department">
							<%
							if (AOFSECURITY.hasEntityPermission("PAS_AR_CS", "_ALL", session)) {
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
						<td  class="lblbold" colspan="2">
							<input type="checkbox" class="checkboxstyle" name="show0AmtOpen" value="1" <%="1".equals(show0AmtOpen) ? "checked" : ""%>>&nbsp;Show Amount Open is Zero
						</td>
					</tr>

					<tr>
					    <td colspan=4 align="left"/>
						<td colspan=2 align="left">
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
					<td class="lblbold" align="center">Bill To</td>
					<td class="lblbold" align="center">Customer Name</td>
					<td class="lblbold" align="center">Contract No</td>
					<td class="lblbold" align="center">Invoice Date</td>
					<td class="lblbold" align="center">Invoice No.</td>
					<td class="lblbold" align="center">Amount</td>
					<td class="lblbold" align="center">Amount Open</td>
					<td class="lblbold" align="center">Currency</td>
					<td class="lblbold" align="center">Receipt No.</td>
					<td class="lblbold" align="center">Receipt Amount</td>
					<td class="lblbold" align="center">Receipt Date</td>
				</tr>
				<%
				SQLResults sqlResult = (SQLResults)request.getAttribute("QryList");
				if(sqlResult == null || sqlResult.getRowCount() == 0){
					out.println("<br><tr><td colspan='31' class=lblerr align='center'>No Record Found.</td></tr>");
				} else {
					NumberFormat numFormat = NumberFormat.getInstance();
					numFormat.setMaximumFractionDigits(2);
					numFormat.setMinimumFractionDigits(2);
					SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
					String newBillTo = null;
					String oldBillTo = null;
					String newInvoiceID = null;
					String oldInvoiceID = null;
					
					for (int row =0; row < sqlResult.getRowCount(); row++) {
						newBillTo = sqlResult.getString(row, "billToId");
						newInvoiceID = sqlResult.getString(row, "invoiceID");
				%>
				<tr bgcolor="#e9eee1"> 
					<%
						if (!newBillTo.equals(oldBillTo)) {
							oldBillTo = newBillTo;
							oldInvoiceID = null;
					%>
						<td class="lblbold"  align="left"><%=sqlResult.getString(row, "billToName")%></td>
					<%
						} else {
					%>
						<td class="lblbold"  align="left"></td>
					<%
						}
					%>
					
					<%
					
						if (!(oldBillTo + newInvoiceID).equals(oldBillTo + oldInvoiceID)) {
							oldInvoiceID = newInvoiceID;
							
					%>
					<td  align="left"><%=sqlResult.getString(row, "customerName")%></td>
					<td  align="left"><%=sqlResult.getString(row, "contractNo")%></td>
					<td  align="center"><%=dateFormat.format(sqlResult.getDate(row, "invoiceDate"))%></td>
					<td  align="left">
						<a href="#" onclick="showInvoiceDetail('<%=sqlResult.getLong(row, "invoiceID")%>');"><%=sqlResult.getString(row, "invoiceNo")%></a>
					</td>
					<td  align="right"><%=numFormat.format(sqlResult.getDouble(row, "amount"))%></td>
					<td  align="right"><%=numFormat.format(sqlResult.getDouble(row, "amountOpen"))%></td>
					<td  align="left"><%=sqlResult.getString(row, "currency")%></td>
					<%
						} else {
					%>
					<td  align="left"></td>
					<td  align="left"></td>
					<td  align="center"></td>
					<td  align="left"></td>
					<td  align="right"></td>
					<td  align="right"></td>
					<td  align="left"></td>
					<%
						}
					%>
					<%
						if (sqlResult.getString(row, "receiptNo") != null) {
					%>
					<td  align="left">
						<a href="#" onclick="showReceiptDetail('<%=sqlResult.getLong(row, "receiptID")%>');"><%=sqlResult.getString(row, "receiptNo")%></a>
					</td>
					<td  align="right"><%=numFormat.format(sqlResult.getDouble(row, "receiptAmount"))%></td>
					<td  align="center"><%=dateFormat.format(sqlResult.getDate(row, "receiptdate"))%></td>
					<%
						} else {
					%>
					<td  align="left"></td>
					<td  align="right"></td>
					<td  align="center"></td>
					<%
						}
					%>
				</tr>
				<%
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
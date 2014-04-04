<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
Log log = LogFactory.getLog("findInvoiceList.jsp");
try {
long timeStart = System.currentTimeMillis();   //for performance test
String process = (String)request.getAttribute("process");

if ((process.equals("maintenance") && AOFSECURITY.hasEntityPermission("PROJ_INVOICE", "_VIEW", session))
    || (process.equals("confirmation") && AOFSECURITY.hasEntityPermission("PROJ_INVOICE", "_VIEW", session))
    || (process.equals("receipt") && AOFSECURITY.hasEntityPermission("PROJ_RECEIPT", "_VIEW", session))) {

	

	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	
	String formAction =  request.getParameter("formAction");
	String Invoice = request.getParameter("invoice");
	String projectAssistant = request.getParameter("pa");
	String Billing = request.getParameter("billing");
	String Project = request.getParameter("project");
	String BillAddress = request.getParameter("billAddress");
	String Status = request.getParameter("status");
	//String DateFrom = request.getParameter("dateFrom");
	//String DateTo = request.getParameter("dateTo");
	String Department = request.getParameter("department");
	
	if (Department == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			Department = userLogin.getParty().getPartyId();
		}
	}
	
	//Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
	
	//if (DateFrom == null || DateFrom.trim().length() == 0) DateFrom = Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
	//if (DateTo == null || DateTo.trim().length() == 0) DateTo = Date_formater.format(nowDate);

	//Date dayStart = UtilDateTime.toDate2(DateFrom + " 00:00:00.000");
	//Date dayEnd = UtilDateTime.toDate2(DateTo + " 00:00:00.000");

	SQLResults sqlResult = (SQLResults)request.getAttribute("QueryList");
	List partyList = (List)request.getAttribute("PartyList");
	
	String offSetStr = request.getParameter("offSet");
	int offSet = 0;
	if (offSetStr != null && offSetStr.trim().length() != 0) {
		offSet = Integer.parseInt(offSetStr);
	}
	
	final int recordPerPage = 20;
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
	function turnPage(offSet) {
		document.queryForm.offSet.value = offSet;
		document.queryForm.submit();
	}
	
	function showDetail(billId, billType) {
		if (billType == "<%=Constants.BILLING_TYPE_NORMAL%>") {
			v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.billing.dialog.title&EditBillingInstruction.do?action=dialogView&billId=" + billId,
				null,
			'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
		} else {
			v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.billing.dialog.title&EditDownpaymentInstruction.do?formAction=dialogView&billId=" + billId,
				null,
			'dialogWidth:600px;dialogHeight:400px;status:no;help:no;scroll:auto');
		}
	}
	
	function doEdit(InvoiceId) {
		if (InvoiceId != null) {
			document.editForm.invoiceId.value = InvoiceId;
		}
		document.editForm.invoice.value = document.queryForm.invoice.value;
		document.editForm.project.value = document.queryForm.project.value;
		document.editForm.billAddress.value = document.queryForm.billAddress.value;
		document.editForm.status.value = document.queryForm.status.options[document.queryForm.status.selectedIndex].value;
		document.editForm.department.value = document.queryForm.department.options[document.queryForm.department.selectedIndex].value;
		document.editForm.billing.value = document.queryForm.billing.value;
		//document.editForm.dateFrom.value = document.queryForm.dateFrom.value;
		//document.editForm.dateTo.value = document.queryForm.dateTo.value;

		document.editForm.submit();
	}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<%
		if (process.equals("maintenance")) {
	%>
	<CAPTION align=center class=pgheadsmall>Invoice List(Maintenance)</CAPTION>
	<%
		} else if (process.equals("confirmation")) {
	%>
	<CAPTION align=center class=pgheadsmall>Invoice List(Confirmation)</CAPTION>
	<%
	    } else if (process.equals("receipt")) {
	%>
	<CAPTION align=center class=pgheadsmall>Invoice List(Receipt)</CAPTION>
	<%
		}
	%>
	<tr>
		<td>
			<%
				if (process.equals("maintenance")) {
			%>
			<form name="queryForm" action="findInvoice.do" method="post">
			<%
				} else if (process.equals("confirmation")) {
			%>
			<form name="queryForm" action="findInvoiceConfirm.do" method="post">
			<%
			    } else if (process.equals("receipt")) {
			%>
			<form name="queryForm" action="findReceipt.do" method="post">
			<%
				}
			%>
				<input type="hidden" name="formAction" id="formAction" value="query">
				<input type="hidden" name="offSet" id="offSet" value="0">
				<TABLE width="100%">
					<tr>
						<td colspan=8><hr color=red></hr></td>
					</tr>
					
					<tr>
						<td class="lblbold">Invoice Code:</td>
						<td class="lblLight"><input type="text" name="invoice" id="invoice" size="15" value="<%=Invoice != null ? Invoice : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Project:</td>
						<td class="lblLight"><input type="text" name="project" id="project" size="15" value="<%=Project != null ? Project : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Bill Address:</td>
						<td class="lblLight"><input type="text" name="billAddress" id="billAddress" size="15" value="<%=BillAddress != null ? BillAddress : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
					</tr>
					<tr>
						<td class="lblbold">Bill Code:</td>
						<td class="lblLight"><input type="text" name="billing" id="billing" size="15" value="<%=Billing != null ? Billing : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Status:</td>
						<td class="lblLight">						
							<select name="status">
								<option value="" selected>All</option>
								<%
									if (process.equals("maintenance") || process.equals("receipt")) {
								%>
								<option value="<%=Constants.INVOICE_STATUS_UNDELIVERED%>" <%=Constants.INVOICE_STATUS_UNDELIVERED.equals(Status) ? "selected" : "" %>><%=Constants.INVOICE_STATUS_UNDELIVERED%></option>
								<%
									}

									if (process.equals("maintenance") || process.equals("confirmation") || process.equals("receipt")) {
								%>
								<option value="<%=Constants.INVOICE_STATUS_DELIVERED%>" <%=Constants.INVOICE_STATUS_DELIVERED.equals(Status) ? "selected" : "" %>><%=Constants.INVOICE_STATUS_DELIVERED%></option>
								<%
									}

									if (process.equals("maintenance") || process.equals("confirmation") || process.equals("receipt")) {
								%>
								<option value="<%=Constants.INVOICE_STATUS_CONFIRMED%>" <%=Constants.INVOICE_STATUS_CONFIRMED.equals(Status) ? "selected" : "" %>><%=Constants.INVOICE_STATUS_CONFIRMED%></option>
								<option value="<%=Constants.INVOICE_STATUS_INPROSESS%>" <%=Constants.INVOICE_STATUS_INPROSESS.equals(Status) ? "selected" : "" %>><%=Constants.INVOICE_STATUS_INPROSESS%></option>
								<option value="<%=Constants.INVOICE_STATUS_COMPLETED%>" <%=Constants.INVOICE_STATUS_COMPLETED.equals(Status) ? "selected" : "" %>><%=Constants.INVOICE_STATUS_COMPLETED%></option>
								<%
									}

									if (process.equals("maintenance") || process.equals("receipt")) {
								%>
								<option value="<%=Constants.INVOICE_STATUS_CANCELED%>" <%=Constants.INVOICE_STATUS_CANCELED.equals(Status) ? "selected" : "" %>><%=Constants.INVOICE_STATUS_CANCELED%></option>
								<%
									}
								%>
							</select>
						</td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="department">
							<%
							if (AOFSECURITY.hasEntityPermission("PROJ_INVOICE", "_ALL", session)) {
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if (p.getPartyId().equals(Department)) {
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
						<td class="lblbold">PA:</td>
						<td class="lblLight"><input type="text" name="pa" size="15" value="<%=projectAssistant != null ? projectAssistant : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>				    	
				        <td colspan=3 />
				    	<td  align="center">
							<input type="submit" value="Query" class="button">
							<%
								if (process.equals("maintenance")) {
							%>
						    <input type="button" value="New" class="button" onclick="doEdit();">
						    <%
						    	}
						    %>
						</td>
					</tr>
					<tr>
						<td colspan=8 valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
			<form name="editForm" action="editInvoice.do" method="post">
				<input type="hidden" name="process" id="process" value="<%=process%>">
				<input type="hidden" name="formAction" id="formAction" value="view">
				<input type="hidden" name="invoiceId" id="invoiceId" value="">
				<input type="hidden" name="billing" id="billing" value="">
				<input type="hidden" name="invoice" id="invoice" value="">
				<input type="hidden" name="project" id="project" value="">
				<input type="hidden" name="billAddress" id="billAddress" value="">
				<input type="hidden" name="status" id="status" value="">
				<input type="hidden" name="department" id="department" value="">
			</form>
		</td>
	</tr>
</table>
	
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
 	<TR bgcolor="#e9eee9">
	  	<td class="lblbold">#&nbsp;</td>
	  	<td align="center" class="lblbold">Invoice Code</td>
	  	<td align="center" class="lblbold">Bill Code</td>
	    <td align="center" class="lblbold">Project</td>
		<td align="center" class="lblbold">Bill Address</td>
	    <td align="center" class="lblbold">Department</td>	   
	    <td align="center" class="lblbold">Currency</td>
	    <td align="center" class="lblbold">Amount</td>
	    <td align="center" class="lblbold">Received Amount (RMB)</td>
	    <td align="center" class="lblbold">Status</td>
	    <td align="center" class="lblbold">PA</td>
	    <td align="center" class="lblbold">Invoice Date</td>
	    <td align="center" class="lblbold">Create Date</td>
  	</tr>
  	
 	<%
 		DateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
 		NumberFormat formater = NumberFormat.getInstance();
		formater.setMaximumFractionDigits(2);
		formater.setMinimumFractionDigits(2);
		
		if(sqlResult != null && sqlResult.getRowCount() > 0){
			for (int row = offSet; row < sqlResult.getRowCount() && row < offSet + recordPerPage; row++) {
 	%>
 	<tr bgcolor="#e9eee9">
    	<td align="center"><%=row + 1%></td>
    	<td align="left"> 
			<a href="#" onclick="doEdit('<%=sqlResult.getLong(row, "inv_id")%>');"><%=sqlResult.getString(row, "inv_code")%></a> 
    	</td>
    	<td align="left"> 
    		<a href="#" onclick="showDetail('<%=sqlResult.getLong(row, "bill_id")%>', '<%=sqlResult.getString(row, "bill_type")%>');"><%=sqlResult.getString(row, "bill_code")%></a>
    	</td>
    	<td align="left">                 
       		<%=sqlResult.getString(row, "proj_id")%>:<%=sqlResult.getString(row, "proj_name")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "billAddr")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "department")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "currency")%>
        </td>        
        <td align="right">                 
           <%=formater.format(sqlResult.getDouble(row, "inv_amount"))%>
        </td>
        <td align="right">                 
           <%=formater.format(sqlResult.getDouble(row, "receivedAmount"))%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "inv_status")%>
        </td>
        <td align="center">
        	<%=sqlResult.getString(row, "paId")+":"+sqlResult.getString(row, "paName")%>
        </td>
        <td align="center">                 
           <%=dateFormater.format(sqlResult.getDate(row, "inv_invoicedate"))%>
        </td>
        <td align="center">                 
           <%=dateFormater.format(sqlResult.getDate(row, "inv_createdate"))%>
        </td>
    </tr>
   
 	<%
			}
	%>
	<tr>
		<td width="100%" colspan="16" align="right" class=lblbold>Pages&nbsp;:&nbsp;
			<%
			int recordSize = sqlResult.getRowCount();
			for (int j0 = 0; j0 < Math.ceil((double)recordSize / recordPerPage); j0++) {
				if (j0 == offSet / recordPerPage) {
			%>
			&nbsp;<font size="3"><%=j0 + 1%></font>&nbsp;
			<%
				} else {
			%>
			&nbsp;<a href="javascript:turnPage('<%=j0 * recordPerPage%>')" title="Click here to view next set of records"><%=j0 + 1%></a>&nbsp;
			<%
				}
			}
			%>
		</td>
	</tr>
	<%
		} else {
 	%>
 	<tr bgcolor="#e9eee9">
    	<td align="center" class="lblerr" colspan="13">
    		No Record Found.
    	</td>
    </tr>
 	<%
 		}
 	%>	
</table>

<%
}else{
	out.println("!!你没有相关访问权限!!");
}
long timeEnd = System.currentTimeMillis();       //for performance test
log.info("it takes " + (timeEnd - timeStart) + " ms to dispaly...");
} catch(Exception e) {
	e.printStackTrace();
}
%>
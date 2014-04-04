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
if (AOFSECURITY.hasEntityPermission("PROJ_INVOICE", "_VIEW", session)) {
	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	
	String formAction =  request.getParameter("formAction");
	String emsId = request.getParameter("emsId");
	String Invoice = request.getParameter("invoice");
	String Billing = request.getParameter("billing");
	String Project = request.getParameter("project");
	String BillAddress = request.getParameter("billAddress");
	//String Status = request.getParameter("status");
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
	
	final int recordPerPage = 10;
%>
<HTML>
	<HEAD>
		<script language="javascript">
			function showInvoiceDetail(invoiceId) {
				v = window.showModalDialog(
				"system.showDialog.do?title=prm.projectInvoice.showinovice.dialog.title&editInvoice.do?formAction=dialogView&invoiceId=" + invoiceId,
					null,
				'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
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
			
			function turnPage(offSet) {
				document.queryForm.offSet.value = offSet;
				document.queryForm.submit();
			}
			
			<%
				if (formAction != null && formAction.equals("OK")) {
			%>
				window.parent.close();
			<%
				}
			%>
			function doAdd() {
				document.queryForm.action = "editInvoice.do";
				document.queryForm.formAction.value = "add";
				document.queryForm.submit();
			}
			
			function doOK() {
				document.queryForm.action = "editInvoice.do";
				document.queryForm.formAction.value = "OK";
				document.queryForm.submit();
			}
		</script>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<form name="queryForm" action="findInvoice.do" method="post">
			<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
				marginWidth=0 noResize 
				scrolling=no src="includes/date/calendar.htm" 
				style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
			</IFRAME>
			<table width=100% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Invoice List</CAPTION>
				<tr>
					<td>
						<input type="hidden" name="formAction" id="formAction" value="dialogView">
						<input type="hidden" name="emsId" id="emsId" value="<%=emsId%>">
						<input type="hidden" name="status" id="status" value="<%=Constants.INVOICE_STATUS_UNDELIVERED%>">
						<input type="hidden" name="offSet" id="offSet" value="0">
						<TABLE width="100%">
							<tr>
								<td colspan=10><hr color=red></hr></td>
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
								<td class="lblLight"><input type="text" name="billing" size="15" value="<%=Billing != null ? Billing : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
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
						    	<td>
									<input type="submit" value="Query" class="button">
								</td>
							</tr>
							<tr>
								<td colspan=10 valign="top"><hr color=red></hr></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			
			<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
			 	<TR bgcolor="#e9eee9">
				  	<td align="center" class="lblbold">#&nbsp;</td>
				  	<td align="center" class="lblbold">Invoice Code</td>
				  	<td align="center" class="lblbold">Bill Code</td>
				    <td align="center" class="lblbold">Project</td>
					<td align="center" class="lblbold">Bill Address</td>
				    <td align="center" class="lblbold">Department</td>	   
				    <td align="center" class="lblbold">Currency</td>
				    <td align="center" class="lblbold">Amount</td>
				    <td align="center" class="lblbold">Received Amount</td>
				    <td align="center" class="lblbold">Status</td>
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
			 		<td align="center">
			 			<input type="checkbox" name="invoiceId" value="<%=sqlResult.getLong(row, "inv_id")%>">
					</td>
					<td align="left"> 
						<a href="#" onclick="showInvoiceDetail('<%=sqlResult.getLong(row, "inv_id")%>');"><%=sqlResult.getString(row, "inv_code")%></a>
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
			    	<td align="center" class="lblerr" colspan="12">
			    		No Record Found.
			    	</td>
			    </tr>
			 	<%
			 		}
			 	%>
			 	<tr>
					<td colspan="11" align="left">
						<input TYPE="button" class="button" name="add" value="Add" onclick="doAdd();">&nbsp;
						<input TYPE="button" class="button" name="ok" value="OK" onclick="doOK();">&nbsp;
						<input TYPE="button" class="button" name="cancel" value="Cancel" onclick="if (confirm("Do you want to cancel?")) {self.close();}">
					</td>
				</tr>	
			 </table>
		</form>
	</body>
</html>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception e) {
	e.printStackTrace();
}
%>

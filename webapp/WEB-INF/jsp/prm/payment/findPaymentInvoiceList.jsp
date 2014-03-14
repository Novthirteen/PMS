<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.prm.payment.*"%>
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
Log log = LogFactory.getLog("findPaymentInvoiceList.jsp");
try {
long timeStart = System.currentTimeMillis();   //for performance test

if ( AOFSECURITY.hasEntityPermission("PAYMENT_INVOICE", "_VIEW", session))
{
	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	String formAction =  request.getParameter("formAction");
	String Invoice = request.getParameter("invoice");
	String Payment = request.getParameter("payment");
	String Project = request.getParameter("project");
	String PayAddress = request.getParameter("payAddress");
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
	
	function showDetail(payId, payType) {
		if (payType == "<%=Constants.PAYMENT_TYPE_NORMAL%>") {
			v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payment.dialog.title&EditPaymentInstruction.do?action=dialogView&payId=" + payId,
				null,
			'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
		} else {
			v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payment.dialog.title&EditPaymentInstruction.do?formAction=dialogView&payId=" + payId,
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
		document.editForm.payAddress.value = document.queryForm.payAddress.value;
		document.editForm.status.value = document.queryForm.status.options[document.queryForm.status.selectedIndex].value;
		document.editForm.department.value = document.queryForm.department.options[document.queryForm.department.selectedIndex].value;
		document.editForm.payment.value = document.queryForm.payment.value;
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

	<CAPTION align=center class=pgheadsmall>Payment List </CAPTION>

	<tr>
		<td>
			<form name="queryForm" action="findPaymentInvoice.do" method="post">
				<input type="hidden" name="formAction" value="query">
				<input type="hidden" name="offSet" value="0">
				<TABLE width="100%">
					<tr>
						<td colspan=8><hr color=red></hr></td>
					</tr>
					
					<tr>
						<td class="lblbold">Supplier Invoice Code:</td>
						<td class="lblLight"><input type="text" name="invoice" size="15" value="<%=Invoice != null ? Invoice : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Project:</td>
						<td class="lblLight"><input type="text" name="project" size="15" value="<%=Project != null ? Project : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Pay To:</td>
						<td class="lblLight"><input type="text" name="payAddress" size="15" value="<%=PayAddress != null ? PayAddress : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
					</tr>
					<tr>
						<td class="lblbold">Payment Code:</td>
						<td class="lblLight"><input type="text" name="payment" size="15" value="<%=Payment != null ? Payment : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Status:</td>
						<td class="lblLight">						
							<select name="status">
								<option value="" selected>All</option>
								<option value="<%=Constants.PAYMENT_INVOICE_STATUS_DRAFT%>" <%=Constants.PAYMENT_INVOICE_STATUS_DRAFT.equals(Status) ? "selected" : "" %>><%=Constants.PAYMENT_INVOICE_STATUS_DRAFT%></option>
								<option value="<%=Constants.PAYMENT_INVOICE_STATUS_CONFIRMED%>" <%=Constants.PAYMENT_INVOICE_STATUS_CONFIRMED.equals(Status) ? "selected" : "" %>><%=Constants.PAYMENT_INVOICE_STATUS_CONFIRMED%></option>
								<option value="<%=Constants.PAYMENT_INVOICE_STATUS_CANCELED%>" <%=Constants.PAYMENT_INVOICE_STATUS_CANCELED.equals(Status) ? "selected" : "" %>><%=Constants.PAYMENT_INVOICE_STATUS_CANCELED%></option>
							</select>
						</td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="department">
							<%
							if (AOFSECURITY.hasEntityPermission("PAYMENT_INVOICE", "_ALL", session)) {
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
				        <td colspan=5 />
				    	<td  align="center">
							<input type="submit" value="Query" class="button">
							<input type="button" value="New" class="button" onclick="doEdit();">
						</td>
					</tr>
					<tr>
						<td colspan=8 valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
			<form name="editForm" action="editPaymentInvoice.do" method="post">
				<input type="hidden" name="formAction" value="view">
				<input type="hidden" name="invoiceId" value="">
				<input type="hidden" name="invoiceCode" value="">
				<input type="hidden" name="payment" value="">
				<input type="hidden" name="invoice" value="">
				<input type="hidden" name="project" value="">
				<input type="hidden" name="payAddress" value="">
				<input type="hidden" name="status" value="">
				<input type="hidden" name="department" value="">
			</form>
		</td>
	</tr>
</table>
	
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
 	<TR bgcolor="#e9eee9">
	  	<td class="lblbold">#&nbsp;</td>
	  	<td align="center" class="lblbold">Posted Payment Code</td>
	  	<td align="center" class="lblbold">Supplier Invoice Code</td>
	  	<td align="center" class="lblbold">Payment Code</td>
	    <td align="center" class="lblbold">Project</td>
		<td align="center" class="lblbold">Pay To</td>
	    <td align="center" class="lblbold">Department</td>	   
	    <td align="center" class="lblbold">Currency</td>
	    <td align="center" class="lblbold">Paid Amount</td>
	    <td align="center" class="lblbold">Status</td>
	    <td align="center" class="lblbold">Create Date</td>
	    <td align="center" class="lblbold">Last Modify Date</td>
	    <td align="center" class="lblbold">Pay Date</td>
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
			<%=sqlResult.getString(row, "formcode")%> 
    	</td>
    	<td align="left"> 
			<%=sqlResult.getString(row, "inv_code")==null?"":sqlResult.getString(row, "inv_code")%>
    	</td>
    	<td align="left"> 
    		<a href="#" onclick="showDetail('<%=sqlResult.getLong(row, "pay_id")%>', '<%=sqlResult.getString(row, "pay_type")%>');"><%=sqlResult.getString(row, "pay_code")%></a>
    	</td>
    	<td align="left">                 
       		<%=sqlResult.getString(row, "proj_id")%>:<%=sqlResult.getString(row, "proj_name")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "payAddr")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "dep")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "currency")%>
        </td>        
        <td align="right">                 
           <%=formater.format(sqlResult.getDouble(row, "inv_amount"))%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "inv_status")%>
        </td>
        <td align="center">                 
           <%=dateFormater.format(sqlResult.getDate(row, "inv_createdate"))%>
        </td>
         <td align="center">         
         <% if (sqlResult.getDate(row, "inv_modifydate") != null)
         { %>      
           <%String md = dateFormater.format(sqlResult.getDate(row, "inv_modifydate"));
           		out.println(md);
           }%>
        </td>
        <td align="center">         
         <% if (sqlResult.getDate(row, "inv_paydate") != null)
         { %>      
           <%String md = dateFormater.format(sqlResult.getDate(row, "inv_paydate"));
           		out.println(md);
           }%>
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
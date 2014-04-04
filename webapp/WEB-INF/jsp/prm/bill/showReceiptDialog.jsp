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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language="javascript">
    function showReceiptDialog()    
	{
		var code,desc;
		with(document.editForm)
		{
			v = window.showModalDialog(
				"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&dialogReceiptList.do",
				null,
				'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
			if (v != null) {
				//code=v.split("|")[0];
				//desc=v.split("|")[1];
				//labelCustomer.innerHTML=code+":"+desc;
				//customerId.value=code;		
				labelreceiptNo.innerHTML = v.split("|")[1];
				receiptNo.value = v.split("|")[1];
				labelreceiveDate.innerHTML = v.split("|")[6];
				receiveDate.value = v.split("|")[6];
				labelreceiptAmount.innerHTML = v.split("|")[2] ;
				receiptAmount.value = v.split("|")[2];	
				labelcurrency.innerHTML = v.split("|")[4];
				currency.value  = v.split("|")[4];
				labelcurrencyRate.innerHTML = v.split("|")[5];
				currencyRate.value  = v.split("|")[5];
				labelremainAmount.innerHTML = v.split("|")[7];
				remainAmount.value = v.split("|")[7];	
				receiveAmount.value = v.split("|")[7];
				labelfareceiptNo.innerHTML = v.split("|")[8];
				faReceiptno.value = v.split("|")[8];
				labelreceiptType.innerHTML = v.split("|")[9];				
			}
		}
	}
</script>
<%
try {
if (AOFSECURITY.hasEntityPermission("PROJ_RECEIPT", "_CREATE", session)) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	NumberFormat numFormat = NumberFormat.getInstance();
	numFormat.setMaximumFractionDigits(2);
	numFormat.setMinimumFractionDigits(2);
	Double d1 = (Double)request.getSession().getAttribute("InvoiceAmountForReceipt");
	System.out.println(d1);
	String invoiceId = request.getParameter("invoiceId");
	ProjectReceipt pr = (ProjectReceipt)request.getAttribute("Receipt");
	List currencyList = (List)request.getAttribute("Currency");
	String receiptNo = pr==null ? null : pr.getReceiptNo();
	ReceiptService service = new ReceiptService();
	ProjectReceiptMaster prm = null;
	Double remainAmount = new Double(0.0);
	if(receiptNo != null && !receiptNo.equals("")){
        prm = service.getView(receiptNo);
		remainAmount = service.getRemainAmount(prm);
	}
	String faReceiptno = "";
	if(prm != null)	faReceiptno = prm.getFaReceiptNo();
	String receiptType = "";
	if(prm != null) receiptType = prm.getReceiptType();
	boolean canUpdate = true;
	if ("dialogView".equals(request.getParameter("formAction"))) {
		canUpdate = false;
	}
%>
<HTML>
	<HEAD>
		<script language="javascript" type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunctions.js'></script>
		<script language="javascript" type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
		<script language="javascript" type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
		<script language="javascript" type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
		<SCRIPT language="javascript">
		<%
		if ("nextClose".equals(request.getParameter("nextClose"))) {
		%>
			window.parent.close();
		<%
		}
		%>
		function checkSubmit() {
			if (document.editForm.receiptNo.value == "") {
				alert("Receipt No can not be ignored");
				return false;
			}
			removeComma(document.editForm.remainAmount);
			removeComma(document.editForm.invoiceAmount);
			if (document.editForm.receiveAmount.value == ""  
			    || parseFloat(document.editForm.receiveAmount.value) > parseFloat(document.editForm.remainAmount.value)
			    || parseFloat(document.editForm.receiveAmount.value) > parseFloat(document.editForm.invoiceAmount.value)
			    ) {
				alert("Receive Amount Invalid");
				return false;
			}else{
				document.editForm.receiveAmount.value = parseFloat(document.editForm.receiveAmount.value);
			}
			
			if (document.editForm.receiveDate.value == "") {
				alert("Receive Date can not be ignored");
				return false;
			}
			
			document.editForm.save.disabled = true;
		}
		</script>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<a><a>
		
		<form name="editForm" action="settleReceipt.do" method="post" onSubmit="return checkSubmit();">
			<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
				marginWidth=0 noResize 
				scrolling=no src="includes/date/calendar.htm" 
				style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
			</IFRAME>
			<input type='hidden' name="invoiceAmount" id="invoiceAmount" value='<%=d1%>'>
			<table width=100% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Receipt</CAPTION>
				<tr>
					<td font="bold" class="lblbold">&nbsp; Select Receipt: &nbsp;&nbsp;<a href="javascript:void(0)" onclick="showReceiptDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a></td>
				</tr>	
				<tr>
					<td>
						<input type="hidden" name="formAction" id="formAction" value="edit">
						<input type="hidden" name="invoiceId" id="invoiceId" value="<%=invoiceId%>">
						<input type="hidden" name="receiptId" id="receiptId" value="<%= pr != null ? pr.getId() + "" : "" %>">
						<input type="hidden" name="nextClose" id="nextClose" value="nextClose">

						<TABLE width="100%">
							<tr>
								<td width="100%" colspan=4><hr color=red></hr></td>
							</tr>
							<tr>
								<td class="lblbold" align=right >Receipt No:</td>
								<td  class="lblLight" >
									<%
										if (canUpdate) {
									%>
									<div style="display:inline" id="labelreceiptNo"><%=pr!= null ? pr.getReceiptNo() : ""%>&nbsp;</div>
									<input  type="hidden" class="inputBox" name="receiptNo" id="receiptNo" size="12" value="<%= pr!= null ? pr.getReceiptNo() : "" %>">
									<%
										} else {
									%>
									<%= pr!= null ? pr.getReceiptNo() : "" %>
									<%
										}
									%>
								</td>
								<td class="lblbold" align=right >F&A Receipt No:</td>
								<td class="lblLight">
									<%
										if (canUpdate) {
									%>
									<div style="display:inline" id="labelfareceiptNo"><%=faReceiptno%>&nbsp;</div>
									<input  type="hidden" class="inputBox" name="faReceiptno" id="faReceiptno" size="12" value="">
									<%
										} else {
									%>
									<%= faReceiptno%>
									<%
										}
									%>
								</td>
								
							</tr>	
							<tr>
								<td class="lblbold" align=right >Receipt Amount:</td>
								<td class="lblLight" >
									<%
										if (canUpdate) {
									%>
									<div style="display:inline" id="labelreceiptAmount"><%=prm!= null ? numFormat.format(prm.getReceiptAmount()) : ""%>&nbsp;</div>
									<input type="hidden" style="TEXT-ALIGN:right" name="receiptAmount" id="receiptAmount" value="<%=prm!= null ? numFormat.format(prm.getReceiptAmount()) : ""%>" size="15" onblur="checkDeciNumber2(this,1,2,'Amount',-9999999999,9999999999);">									
									<%
										} else {
									%>
									<%=prm!= null ? numFormat.format(prm.getReceiptAmount()) : ""%>
									<%
										}
									%>
								</td>
								<td class="lblbold" align=right >Remain Amount (RMB):</td>
								<td class="lblLight" >
									<%
										if (canUpdate) {
									%>
									<div style="display:inline" id="labelremainAmount"><%=numFormat.format(remainAmount)%>&nbsp;</div>
									<input type="hidden" style="TEXT-ALIGN:right" name="remainAmount" id="remainAmount" value="<%=remainAmount%>" size="15" onblur="checkDeciNumber2(this,1,2,'Amount',-9999999999,9999999999);">									
									<%
										} else {
									%>
									<%=numFormat.format(remainAmount)%>
									<%
										}
									%>
								</td>
							</tr>
							<tr>
								<td class="lblbold" align=right >Currency:</td>
								<td class="lblLight" >
									<%
										if (canUpdate) {
									%>
									<div style="display:inline" id="labelcurrency"><%=pr != null ? pr.getCurrency().getCurrName() : ""%>&nbsp;</div>
									<input  type="hidden" class="inputBox" name="currency" id="currency" size="12" value="<%= pr != null ? pr.getCurrency().getCurrName() : "" %>">									
									<%
										} else {
									%>
									<%=pr != null ? pr.getCurrency().getCurrName() : ""%>
									<%
										}
									%>
									</select>
								</td>
								
								<td class="lblbold" align=right >Exchange Rate:</td>
								<td class="lblLight" >
									<%
										if (canUpdate) {
									%>
									<div style="display:inline" id="labelcurrencyRate"><%=pr!= null ? pr.getCurrencyRate() + "" : "1.0"%>&nbsp;</div>
									<input type="hidden" style="TEXT-ALIGN:right" name="currencyRate" id="currencyRate" value="<%=pr!= null ? pr.getCurrencyRate() + "" : "1.0"%>" size="15" onblur="checkDeciNumber2(this,1,2,'Amount',-9999999999,9999999999);addComma(this, '.', '.', ',');">																		
									<%
										} else {
									%>
									<%=pr!= null ? pr.getCurrencyRate() + "" : "1.0"%>
									<%
										}
									%>
								</td>
							</tr>
							<tr>
								<td class="lblbold" align=right >Receipt Type:</td>
								<td class="lblLight">
									<%
										if (canUpdate) {
									%>
									<div style="display:inline" id="labelreceiptType"><%=receiptType%>&nbsp;</div>

									<%
										} else {
									%>
									<%= receiptType%>
									<%
										}
									%>
								</td>	
								<td class="lblbold" align=right >Receive Date:</td>
								<td class="lblLight" >
									<%
										if (canUpdate) {
									%>
									<div style="display:inline" id="labelreceiveDate"><%= pr!= null ? dateFormat.format(pr.getReceiveDate()) : "" %>&nbsp;</div>
									<input  type="hidden" class="inputBox" name="receiveDate" id="receiveDate" size="12" value="<%= pr!= null ? dateFormat.format(pr.getReceiveDate()) :"" %>">
									<%
										} else {
									%>
									<%= pr!= null ? dateFormat.format(pr.getReceiveDate()) : dateFormat.format(new Date()) %>
									<%
										}
									%>
								</td>
															
							</tr>
							<tr>
								<td class="lblbold" align=right>Settlement Amount (RMB):</td>
								<td class="lblLight" >
									<%
										if (canUpdate) {
									%>
									<input type="text" style="TEXT-ALIGN:right" name="receiveAmount" value="<%=pr!= null ? numFormat.format(pr.getReceiveAmount()) : ""%>" size="15" onblur="checkDeciNumber2(this,1,2,'Amount',-9999999999,9999999999);addComma(this, '.', '.', ',');">									
									<%
										} else {
									%>
									<%=pr!= null ? numFormat.format(pr.getReceiveAmount()) : ""%>
									<%
										}
									%>
								</td>
							</tr>
							<tr>
								<td class="lblbold" align=right width="15%">Note:</td>
								<td class="lblLight" width="85%" colspan="3">
									<%
										if (canUpdate) {
									%>
									<textarea name="note" cols="77" rows="3"><%=pr!= null ? pr.getNote() : ""%></textarea>
									<%
										} else {
									%>
									<%=pr!= null ? pr.getNote() : ""%>
									<%
										}
									%>
								</td>
							</tr>
							<tr>
								<td colspan="4" align="left">
									<%
										if (canUpdate) {
									%>
									<input type="submit" value="Save" name="save" class="button" onclick = "removeComma(document.editForm.receiveAmount)">
									<%
										} else {
									%>
									<input type="button" value="Close" name="close" class="button" onclick="window.parent.close();">
									<%
										}
									%>
								</td>
							</tr>
							<tr>
								<td width="100%" colspan=4><hr color=red></hr></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
<%
service.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception e) {
	e.printStackTrace();
}
%>


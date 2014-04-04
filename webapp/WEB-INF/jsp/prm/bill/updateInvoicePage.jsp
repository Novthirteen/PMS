<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
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
function showCustomerDialog()
{
	var code,desc;
	with(document.updateForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.billto.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		alert(v);
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			document.getElementById("labelBillAddress").innerHTML = desc;			
			document.getElementById("billAddressId").value=code;
		}
	}
}
function showEMSDialog()
{
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.projectInvoice.ems.dialog.title&findEMS.do?formAction=dialogView&emsInvoiceId="+<%=pi.getId()%>,
	null,
	'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
	if (v != null) {
		var emsId = v.split("|")[0];
		var emsType = v.split("|")[1];
		var emsNo = v.split("|")[2];
		document.getElementById("labelEMS").innerHTML = emsNo;			
		document.getElementById("emsId").value=emsId;
		//removeComma(document.updateForm.amount);
		//document.updateForm.submit();
	}
}
function showEMSDetailDialog(emdId)
{
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.projectInvoice.ems.dialog.title&editEMS.do?emsId="+emdId+"&formAction=dialogView",
	null,
	'dialogWidth:800px;dialogHeight:400px;status:no;help:no;scroll:auto');
}
function checkSubmit() {
	if (document.updateForm.amount.value == ""
		|| document.updateForm.amount.value == "0.00") {
		alert("Amount Value can not be ignored or zero");
		
		return false;
	} else {
		removeComma(document.updateForm.amount);
	}
	
	if (document.updateForm.invoiceDate.value == "") {
		alert("Invoice Date can not be ignored");
		return false;
	}
	
	return true;
}

function onCurrSelect(){
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	with(document.updateForm) {
		currencyRate.value = RateArr[currency.selectedIndex];
	}

}

function doDelete() {
if (confirm("Do you want to delete?")) {
	document.updateForm.formAction.value = "delete";
	document.updateForm.submit();
}
}
function FnCancel() {
	if (confirm("Do you want to cancel?")) {
		document.form1.formAction.value='cancel';
		document.form1.submit();
	}
}
</script>
<%
	String formAction = request.getParameter("formAction");
	ProjectBill pb = null;
	if (pi.getBilling() != null) {
		pb = pi.getBilling();
	}
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	
	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);	
	
	boolean canUpdate = true; 
	if (!pi.getStatus().equals(Constants.INVOICE_STATUS_UNDELIVERED) || "dialogView".equals(formAction)) {
		canUpdate = false;
	}
	 Float defaultCurrRate = null;
%>
<form name="form1" action="editInvoice.do" method="post">
	<input type="hidden" name="formAction" id="formAction" value="">
	<input type="hidden" name="process" id="process" value="<%=request.getParameter("process")%>">
	<input type="hidden" name="invoiceId" id="invoiceId" value="<%=pi.getId()%>">
	<input type="hidden" name="invoice" id="invoice" value="<%=Invoice%>">
	<input type="hidden" name="project" id="project" value="<%=Project%>">
	<input type="hidden" name="billAddress" id="billAddress" value="<%=BillAddress%>">
	<input type="hidden" name="status" id="status" value="<%=Status%>">
	<input type="hidden" name="department" id="department" value="<%=Department%>">
</form>
<form name="updateForm" action="editInvoice.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" id="formAction" value="update">
	<input type="hidden" name="process" id="process" value="<%=request.getParameter("process")%>">
	<input type="hidden" name="invoiceId" id="invoiceId" value="<%=pi.getId()%>">
	<input type="hidden" name="confirmId" id="confirmId" value="">
	<input type="hidden" name="receiptId" id="receiptId" value="">
	<input type="hidden" name="invoiceType" id="invoiceType" value="<%=Constants.INVOICE_TYPE_NORMAL%>">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<%
			if ("dialogView".equals(formAction)) {
		%>
			<CAPTION align=center class=pgheadsmall>Invoice Detail</CAPTION>
		<%
			}
		%>
		<%
			if ("maintenance".equals(request.getParameter("process"))) {
		%>
		<CAPTION align=center class=pgheadsmall>Invoice Maintenance</CAPTION>
		<%
			} else if ("confirmation".equals(request.getParameter("process"))) {
		%>
		<CAPTION align=center class=pgheadsmall>Invoice Confirmation</CAPTION>
		<%
			} else if ("receipt".equals(request.getParameter("process"))) {
		%>
		<CAPTION align=center class=pgheadsmall>Receipt</CAPTION>
		<%
			}
		%>
		<tr>
			<td>
				<TABLE width="100%">
					<TR>
    					<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
            				Invoice Detail
          				</TD>
  					</TR>
  					<%
  						if (request.getAttribute("ErrorMessage") != null) {
  					%>
  					<TR>
    					<TD align=left colspan="4" width='100%'>
            				<font color="red" size="4">
            					<%=(String)request.getAttribute("ErrorMessage")%>
            				</font>
          				</TD>
  					</TR>
  					<%
  						}
  					%>
					<tr>
						<td class="lblbold" align=right width="15%">Invoice Code:</td>
						<td class="lblLight" width="35%">
							<%=pi.getInvoiceCode()%>							
						</td>
						<td class="lblbold" align=right width="15%">Bill Code:</td>
						<td class="lblLight" width="35%">			
							<a href="#" onclick="showDetail('<%=pb.getId()%>', '<%=pb.getBillType()%>');"><%=pb.getBillCode()%></a>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject">
								<%=pi.getProject().getProjId()%>:<%=pi.getProject().getProjName() != null ? pi.getProject().getProjName() : ""%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="15%">Contract Type:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelContractType">
								<%
									if (pi.getProject().getContractType().equals("FP")) {
								%>
									Fixed Price
								<%
									} else {
								%>
									Time & Material
								<%
									}
								%>
							</div>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Department:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelDepartment">
								<%=pi.getProject().getDepartment().getDescription()%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="15%">Project Manager:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProjectManager">
								<%=pi.getProject().getProjectManager().getName()%>
							</div>
						</td>
					</tr>
					<tr>				
						<td class="lblbold" align=right width="15%">Bill Address:</td>
						<td class="lblLight" width="35%">							
							<div style="display:inline" id="labelBillAddress">
								<%=pi.getBillAddress().getDescription() != null ? pi.getBillAddress().getDescription() : ""%>
							</div>
							<input type="hidden" name="billAddressId" id="billAddressId" value="<%=pi.getBillAddress().getPartyId()%>">	
							<%
								if (canUpdate) {
							%>
							<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
							<%
								}
							%>
						</td>
						
						<td class="lblbold" align=right width="15%">Amount:</td>
						<td class="lblLight" width="35%">
							<%
								if (canUpdate) {
							%>
							<input type="text" name="amount" size="30" value="<%=numFormater.format(pi.getAmount())%>" style="TEXT-ALIGN: right<%=request.getAttribute("ErrorMessage") != null ? ";background-color:#FFAFD3" : ""%>" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
							<%
								} else {
							%>
							<%=numFormater.format(pi.getAmount().doubleValue())%>
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Currency:</td>
						<td class="lblLight" width="35%">
							<%
								if (canUpdate) {
							%>
					          <select name="currency" onchange="javascript:onCurrSelect()">
							  <%						
							     
							      CurrencyType defaultCurr = null;
								  for (int i0 = 0; i0 < currencyList.size(); i0++) {
									CurrencyType curr = (CurrencyType)currencyList.get(i0);
									if(pi!= null && pi.getCurrency() != null && curr.getCurrId().equals(pi.getCurrency().getCurrId())){
									defaultCurrRate = pi.getCurrency().getCurrRate();
								%>
									<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
								<%  }else{ %>
									<option value="<%=curr.getCurrId()%>"><%=curr.getCurrName()%></option>
								<%}}%>
							  </select>
							<%
								} else {
							%>
							<%=pi.getCurrency().getCurrName()%>
							<%
								}
							%>
						</td>
						<td class="lblbold" align=right width="15%">Exchange Rate(RMB):</td>
						<td class="lblLight" width="35%">	
							<%
								if (canUpdate) {
							%>						
							<input type="text" name="currencyRate" size="30" value="<%if(defaultCurrRate != null) out.print(defaultCurrRate.floatValue());%>" style="TEXT-ALIGN: right" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Exchange Rate',-99999,99999)">
							<%
								} else {
							%>
							<%=pi.getCurrencyRate()%>
							<%
								}
							%>
						</td>
					</tr>
					<tr>						
						<td class="lblbold" align=right width="15%">Invoice Date:</td>
						<td class="lblLight" width="35%">	
							<%
								if (canUpdate) {
							%>						
							<input  type="text" name="invoiceDate" size="12" value="<%=dateFormat.format(pi.getInvoiceDate())%>">
							<A href="javascript:ShowCalendar(document.updateForm.dimg1, document.updateForm.invoiceDate,null,0,330)" onclick=event.cancelBubble=true;>
								<IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" >
							</A>
							<%
								} else {
							%>
							<%=dateFormat.format(pi.getInvoiceDate())%>
							<%
								}
							%>					
						</td>
						<td class="lblbold" align=right width="15%">EMS No/Contactor:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelEMS">
								<%
									if (pi.getEMS() != null) {
								%>
								<a href="#" onclick="showEMSDetailDialog('<%=pi.getEMS().getId()%>');"><%=pi.getEMS().getNo()%></a>
								<%
									}
								%>
							</div>
							<input type="hidden" name="emsId" id="emsId" value="<%=pi.getEMS() != null ? pi.getEMS().getId() + "" : ""%>">	
							<%
								if (canUpdate && AOFSECURITY.hasEntityPermission("PROJ_EMS", "_VIEW", session)) {
							%>
							<a href="javascript:void(0)" onclick="showEMSDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
							<%
								}
							%>						
						</td>
					</tr>					
					<tr>
						<td class="lblbold" align=right width="15%">Create User:</td>
						<td class="lblLight" width="35%">
							<%=pi.getCreateUser().getName()%>
						</td>
						<td class="lblbold" align=right width="15%">Create Date:</td>
						<td class="lblLight" width="35%">							
							<%=dateFormat.format(pi.getCreateDate())%>			
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
							<%
								if (canUpdate) {
							%>	
							<textarea name="note" cols="130" rows="3"><%=pi.getNote() != null ? pi.getNote() : ""%></textarea>							
							<%
								} else {
							%>
							<%=pi.getNote() != null ? pi.getNote() : ""%>
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td colspan=4>
							<%
								if ("dialogView".equals(formAction)) {
							%>
							<input type="button" class="button" name="Close" value="Close" onclick="window.parent.close();">
							<%
								} else {
							%>
							<%
									if (canUpdate) {
							%>
							<input type="submit" class="button" name="Save" value="Save">
							<input type="button" class="button" name="Delete" value="Delete" onclick="doDelete();">
							<%
									}
							%>
							<input type="button" value="Back to List" name="Back" class="button" onclick="document.backForm.submit();">
							<%
									if ("confirmation".equals(request.getParameter("process"))
									&& pi.getStatus().equals(Constants.INVOICE_STATUS_DELIVERED)) {
							%>
							<input type="button" class="button" name="Confirm" value="Confirm Invoice" onclick="document.form1.formAction.value='confirm';document.form1.submit();">
							<%
									}
							%>
							<%
									if (("confirmation".equals(request.getParameter("process")) 
										|| "maintenance".equals(request.getParameter("process")))
										&& (pi.getStatus().equals(Constants.INVOICE_STATUS_UNDELIVERED)
										|| pi.getStatus().equals(Constants.INVOICE_STATUS_DELIVERED))) {
							%>
							<input type="button" class="button" name="Cancel" value="Cancel Invoice" onclick="javascript:FnCancel();">
							<%
									}
								}
							%>
						</td>
					</tr>
					
					<%
						if (("confirmation".equals(request.getParameter("process")) 
						&& pi.getStatus().equals(Constants.INVOICE_STATUS_CONFIRMED))
						|| pi.getConfirms() != null && pi.getConfirms().size() > 0) {
					%>
					<%@ include file="invoiceConfirmationPage.jsp" %>
					<%
						}
					%>
					
					<%
						if ("receipt".equals(request.getParameter("process"))
						|| pi.getReceipts() != null && pi.getReceipts().size() > 0) {
					
					 	request.getSession().setAttribute("BillAddressForReceipt",pi.getBillAddress().getPartyId());
					 	java.util.Set set = pi.getReceipts();
					 	java.util.Iterator i = set.iterator();
					 	double amount = 0.0;
					 	while(i.hasNext()){
					 		amount += ((ProjectReceipt)i.next()).getReceiveAmount().doubleValue();
					 	}
						request.getSession().setAttribute("InvoiceAmountForReceipt",new Double(pi.getAmount().doubleValue()-amount));
					%>
					<%@include file="receiptPage.jsp" %>
					<%
						}
					%>
					
				</table>
			</td>
		</tr>
	</table>
</form>
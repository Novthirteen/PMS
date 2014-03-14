<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
function doDelete() {
if (confirm("Do you want to delete?")) {
	document.updateForm.formAction.value = "delete";
	document.updateForm.submit();
}
}
function ExportExcel() {
		document.rptForm.submit();
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
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelBillAddress.innerHTML=desc;			
			billAddr.value=code;
		}
	}
}
function checkSubmit() {
	
	if (document.updateForm.billAddr.value == "") {
		alert("Customer can not be ignored");
		return false;
	}
	
	if (document.updateForm.billAddr.value == "") {
		alert("Bill Address can not be ignored");
		return false;
	}
	
	if (document.updateForm.creditAmount.value == "") {
		alert("Credit-Down-Payment Amount can not be ignored");
		return false;
	}
	
	if (document.updateForm.creditAmount.value.substring(0, 1) != "-"
		&& parseFloat(document.updateForm.creditAmount.value) != 0) {
		alert("Credit-Down-Payment Amount can not be positive");
		return false;
	}
	
	removeComma(document.updateForm.downAmount);
	removeComma(document.updateForm.creditAmount);
	
	return true;
}
</script>
<%
BillTransactionDetail td  = (BillTransactionDetail)request.getAttribute("CreidtDownpayment");
String formAction = request.getParameter("formAction");
boolean canUpdate = true;
if ((formAction != null && formAction.equals("dialogView"))
    || pb.isFreezed() || (td != null && td.getTransactionMaster() != null)) {
	canUpdate = false;
}

NumberFormat numFormater = NumberFormat.getInstance();
numFormater.setMaximumFractionDigits(2);
numFormater.setMinimumFractionDigits(2);	

DateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
%>
<form name="rptForm" action="pas.report.Billingprint.do" method="post">
	<input type="hidden" name="action" value="ExportToExcel">
	<input type="hidden" name="billId" value="<%=pb.getId()%>">
	<input type="hidden" name="category" value="<%=Constants.TRANSACATION_CATEGORY_DOWN_PAYMENT%>">
</form>
<form name="createInvoiceForm" action="editInvoice.do" method="post">
	<input type="hidden" name="formAction" value="view">
	<input type="hidden" name="billId" value="<%=pb.getId()%>">
</form>
<form name="updateForm" action="EditDownpaymentInstruction.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" value="update">
	<input type="hidden" name="billType" value="<%=Constants.BILLING_TYPE_DOWN_PAYMENT%>">
	<input type="hidden" name="billId" value="<%=pb.getId()%>">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>
			<%
				if (canUpdate && !"dialogView".equals(formAction)) {
			%>
			Down-Payment Instruction Maintenance
			<%
				} else {
			%>
			Down-Payment Instruction
			<%
				}
			%>
		</CAPTION>
		<tr>
			<td>
				<TABLE width="100%">
					<TR>
    					<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
            				Billing Instruction Head
          				</TD>
  					</TR>
  					
					<tr>
						<td class="lblbold" align=right width="15%">Bill Code:</td>
						<td class="lblLight" width="35%">
							<%=pb.getBillCode()%>
						</td>
					
						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject">
								<%=pb.getProject().getProjId()%>:<%=pb.getProject().getProjName() != null ? pb.getProject().getProjName() : ""%>
							</div>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Contract Type:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelContractType">
								<%
									String contractType = pb.getProject().getContractType();
									if (contractType.equals("FP")) {
										out.println("Fixed Price");
									} else {
										out.println("Time & Material");
									}
								%>
							</div>				
						</td>
						
						<td class="lblbold" align=right width="15%">Department:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelDepartment">
								<%=pb.getProject().getDepartment().getDescription()%>
							</div>				
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Project Manager:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelPM">
								<%=pb.getProject().getProjectManager().getName()%>
							</div>						
						</td>
						
						<td class="lblbold" align=right width="15%">Bill Address:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelBillAddress">
								<%=pb.getBillAddress().getDescription() != null ? pb.getBillAddress().getDescription() : ""%>
							</div>
							<%
								if (canUpdate) {
							%>
							<input type=hidden name="billAddr" value="<%=pb.getBillAddress().getPartyId()%>">
							<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Down-Payment Amount:</td>
						<td class="lblLight" width="35%">
							<%
								if (canUpdate) {
							%>
							<input type="text" name="downAmount" size="30" value="<%=numFormater.format(pb.getDownPaymentAmount())%>" style="TEXT-ALIGN: right" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
							<%
								} else {
							%>
							<%=numFormater.format(pb.getCalAmount() != null ? pb.getCalAmount().doubleValue() : 0D)%>
							<%
								}
							%>
						</td>						
						<td class="lblbold" align=right width="15%">Credit-Down-Payment Amount:</td>
						<td class="lblLight" width="35%">
							<%
								if (canUpdate) {
							%>
							<input type="text" name="creditAmount" size="30" value="<%=td != null ? numFormater.format(td.getAmount().doubleValue() * td.getExchangeRate().doubleValue()) : "0.00"%>" style="TEXT-ALIGN: right" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
							<%
								} else {
							%>
							<%=td != null ? numFormater.format(td.getAmount().doubleValue() * td.getExchangeRate().doubleValue()) : "0.00"%>
							<%
								}
							%>
						</td>				
					</tr>
					<tr>
												
						<td class="lblbold" align=right width="15%">Currency:</td>
						<td class="lblLight" width="35%">RMB</td>					
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Create Date:</td>
						<td class="lblLight" width="35%">
							<%=dateFormater.format(pb.getCreateDate())%>
						</td>
						<td class="lblbold" align=right width="15%">Create User:</td>
						<td class="lblLight" width="35%">
							<%=pb.getCreateUser().getName()%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Remaining Amount:</td>
						<td class="lblLight" width="35%">
							<%=numFormater.format(pb.getRemainingAmount())%>
						</td>
						<td class="lblbold" align=right width="15%">Status:</td>
						<td class="lblLight" width="35%">
							<%=pb.getStatus()%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
						<%
							if (canUpdate) {
						%>
							<textarea name="note" cols="130" rows="3"><%=pb.getNote() != null ? pb.getNote() : ""%></textarea>	
						<%
							} else {
						%>
							<%=pb.getNote() != null ? pb.getNote() : ""%>
						<%
							}
						%>				
						</td>
					</tr>
					<tr>
						<td colspan=4>
						<%
							if (canUpdate) {
						%>
							<input type="submit" class="button" name="save" value="Save">
							<input type="button" class="button" name="delete" value="Delete" onclick="doDelete();">
						<%
							}
						%>
						<%
							if (!"dialogView".equals(formAction)) {
						%>
						<input type="button" value="Back to List" name="Back" class="button" onclick="document.backForm.submit();">
						<input type="button" value="Billing Excel Form" name="Print" class="button" onclick="javascript:ExportExcel()">
						<%
							if (!pb.getStatus().equals("Closed")) {
						%>
						<input type="button" value="Create Invoice" name="createInvoice" class="button" onclick="javascript:document.createInvoiceForm.submit()">
						<%
							}
						%>
						<%
							} else {
						%>
						<input type="button" value="Close" name="Close" class="button" onclick="window.parent.close();">
						<%
							}
						%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
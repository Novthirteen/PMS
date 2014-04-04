<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
function doAddInv(){
		var param = "paymentId=" + "<%=pp.getId()%>" + "&formAction=view";
		v = window.showModalDialog(
		"system.showDialog.do?title=prm.projectPayment.settleSupplierInvoice.dialog.title&settleSupplierInvoice.do?" + param,
			null,
		'dialogWidth:800px;dialogHeight:400px;status:no;help:no;scroll:auto');
		if(v==null||v!="justView"){
			document.editForm.formAction.value = "view";
			document.editForm.submit();
		}
}
function doDelete() {
	document.editForm.formAction.value = "delete";
	document.editForm.submit();
}
function post(){
	document.editForm.formAction.value="post";
	document.editForm.submit();
}
function removeSupplierInv(tran){
		with(document.deleteSuppInvForm){
			formAction.value = "removeSupplierInvoice";
			paymentId.value = tran;
			submit();
		}
}
function ExportExcel() {
		document.rptForm.submit();
}
function showVendorDialog()
{
	var code,desc;
	with(document.editForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payto.dialog.title&crm.dialogVendorList.do",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelPayAddress.innerHTML=desc;			
			payAddr.value=code;
		}
	}
}
function checkSubmit() {
	
	if (document.editForm.payAddr.value == "") {
		alert("Supplier can not be ignored");
		return false;
	}
	
	if (document.editForm.payAddr.value == "") {
		alert("Pay-To Address can not be ignored");
		return false;
	}
	
	if (document.editForm.creditAmount.value == "") {
		alert("Credit-Down-Payment Amount can not be ignored");
		return false;
	}
	
	if (document.editForm.creditAmount.value.substring(0, 1) != "-"
		&& parseFloat(document.editForm.creditAmount.value) != 0) {
		alert("Credit-Down-Payment Amount can not be positive");
		return false;
	}
	
	removeComma(document.editForm.downAmount);
	removeComma(document.editForm.creditAmount);
	
	return true;
}
</script>
<%
PaymentTransactionDetail td  = (PaymentTransactionDetail)request.getAttribute("CreidtDownpayment");
String formAction = request.getParameter("formAction");

String category = request.getParameter("category");
if (category == null) category = Constants.TRANSACATION_CATEGORY_CAF;

boolean canUpdate = true;
if ((formAction != null && formAction.equals("dialogView"))
    || pp.isFreezed() || (td != null && td.getTransactionMaster() != null)) {
	canUpdate = false;
}
NumberFormat numFormater = NumberFormat.getInstance();
numFormater.setMaximumFractionDigits(2);
numFormater.setMinimumFractionDigits(2);	

DateFormat dateFormater = new SimpleDateFormat("yyyy/MM/dd");
%>
<form name="createInvoiceForm" action="editPaymentInvoice.do" method="post">
	<input type="hidden" name="formAction" id="formAction" value="view">
	<input type="hidden" name="payId" id="payId" value="<%=pp.getId()%>">
</form>
<form name="rptForm" action="EditPaymentInstruction.do" method="post">
	<input type="hidden" name="action" id="action" value="ExportToExcel">
	<input type="hidden" name="payId" id="payId" value="<%=pp.getId()%>">
</form>
<form name="deleteSuppInvForm" action="EditPaymentDownpaymentInstruction.do" method="post">
	<input type="hidden" name="paymentId" id="paymentId" value="">
	<input type="hidden" name="formAction" id="formAction" value="">
	<input type="hidden" name="payId" id="payId" value="<%=pp.getId()%>">
	<input type="hidden" name="category" id="category" value="<%=category%>">
</form>
<form name="editForm" action="EditPaymentDownpaymentInstruction.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" id="formAction" value="update">
	<input type="hidden" name="payType" id="payType" value="<%=Constants.PAYMENT_TYPE_DOWN_PAYMENT%>">
	<input type="hidden" name="payId" id="payId" value="<%=pp.getId()%>">
	
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
            				Payment Instruction Head
          				</TD>
  					</TR>
  					
					<tr>
						<td class="lblbold" align=right width="15%">Payment Code:</td>
						<td class="lblLight" width="35%">
							<%=pp.getPaymentCode()%>
						</td>
					
						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject">
								<%=pp.getProject().getProjId()%>:<%=pp.getProject().getProjName() != null ? pp.getProject().getProjName() : ""%>
							</div>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Contract Type:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelContractType">
								<%
									String contractType = pp.getProject().getContractType();
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
								<%=pp.getProject().getDepartment().getDescription()%>
							</div>				
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Project Manager:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelPM">
								<%=pp.getProject().getProjectManager().getName()%>
							</div>						
						</td>
						
						<td class="lblbold" align=right width="15%">Payment Address:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelPayAddress">
								<%=pp.getPayAddress().getDescription() != null ? pp.getPayAddress().getDescription() : ""%>
							</div>
							<%
								if (canUpdate) {
							%>
							<input type="hidden" name="payAddr" id="payAddr" value="<%=pp.getPayAddress().getPartyId()%>">
							<a href="javascript:void(0)" onclick="showVendorDialog();event.returnValue=false;">
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
							<input type="text" name="downAmount" size="30" value="<%=numFormater.format(pp.getDownPaymentAmount())%>" style="TEXT-ALIGN: right" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
							<%
								} else {
							%>
							<%=numFormater.format(pp.getCalAmount() != null ? pp.getCalAmount().doubleValue() : 0D)%>
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
							<%=dateFormater.format(pp.getCreateDate())%>
						</td>
						<td class="lblbold" align=right width="15%">Create User:</td>
						<td class="lblLight" width="35%">
							<%=pp.getCreateUser().getName()%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Offset Remaining Amount:</td>
						<td class="lblLight" width="35%"> 
							<%=numFormater.format(pp.getCalAmount().doubleValue()-pp.getSettledAmount().doubleValue())%>
						</td>
						<td class="lblbold" align=right width="15%">Status:</td>
						<td class="lblLight" width="35%">
							<%=pp.getStatus()%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
						<%
							if (canUpdate) {
						%>
							<textarea name="note" cols="130" rows="3"><%=pp.getNote() != null ? pp.getNote() : ""%></textarea>	
						<%
							} else {
						%>
							<%=pp.getNote() != null ? pp.getNote() : ""%>
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
						<%
				
								if (pp.getStatus().equals("Draft")) {
						%>
							<input type="button" class="button" name="delete" value="Delete" onclick="doDelete();">
						<%
								}
							}
						%>
						<%
							if (!"dialogView".equals(formAction)) {
						%>
						<input type="button" value="Back to List" name="Back" class="button" onclick="document.backForm.submit();">
						<%
							}
						%>
						</td>
					</tr>
				</table>
	<table width=100%>
		<tr>
			<td>
				<hr color=red></hr>
			</td>
		</tr>
	</table>
	<table width="100%">
		<TR>
			<TD align=left colspan="10" width='100%' class="wpsPortletTopTitle">
			Supplier Invoice Mapping List
			</TD>
		</TR>
			<%@ include file="paymentSupplierInvPage.jsp" %>
		<tr>
			<TD align="left" colspan="10">
				<%if(!pp.getStatus().equals("Completed")){%>
					<input type="button" class="button" name="addInv" value="Add Supplier Invoice" onclick="doAddInv();">&nbsp;
				<%}%>
				<input type="button" value="Post Selected To FA" name="PostToFA" class="button" onclick="post();">&nbsp;
				<%
					if (!canUpdate){
				%>
						<input type="button" value="Payment Excel Form" name="Print" class="button" onclick="javascript:ExportExcel()">
				<%
					}
				%>
			</TD>
		</tr>
  	</table>
	<table width=100%>
		<tr>
			<td>
				<hr color=red></hr>
			</td>
		</tr>
	</table>
			</td>
		</tr>
	</table>
</form>
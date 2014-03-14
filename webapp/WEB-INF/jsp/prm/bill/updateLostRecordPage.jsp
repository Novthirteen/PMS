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
function checkSubmit() {
	if (document.updateForm.amount.value == ""
		|| document.updateForm.amount.value == "0.00") {
		alert("Amount Value can not be ignored or zero");
		
		return false;
	} else {
		removeComma(document.updateForm.amount);
	}
	
	return true;
}

function onCurrSelect(){
	
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	
	with(document.updateForm) {
		exchangeRate.value = RateArr[currency.selectedIndex];
		labelCurrencyRate.innerHTML=exchangeRate.value;
	}
}

function doDelete() {
if (confirm("Do you want to delete?")) {
	document.updateForm.formAction.value = "delete";
	document.updateForm.submit();
	}
}
function doConfirm(){
	if(checkSubmit()){
		document.updateForm.formAction.value = "confirm";
		document.updateForm.submit();
	}
}

</script>
<%
	ProjectBill pb = null;
	if (pi.getBilling() != null) {
		pb = pi.getBilling();
	}
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	
	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);	
	
	boolean canUpdate = true;
%>
<form name="updateForm" action="editLost.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" value="update">
	<input type="hidden" name="lostRecordId" value="<%=pi.getId()%>">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>Lost Record Maintenance</CAPTION>
		<tr>
			<td>
				<TABLE width="100%">
					<TR>
    					<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
            				Lost Record Detail
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
						<td class="lblbold" align=right width="15%">Bill Code:</td>
						<td class="lblLight" width="35%">			
							<a href="#" onclick="showDetail('<%=pb.getId()%>', '<%=pb.getBillType()%>');"><%=pb.getBillCode()%></a>
						</td>

						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject">
								<%=pi.getProject().getProjId()%>:<%=pi.getProject().getProjName() != null ? pi.getProject().getProjName() : ""%>
							</div>
						</td>
					</tr>
					<tr>	
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
					
						<td class="lblbold" align=right width="15%">Department:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelDepartment">
								<%=pi.getProject().getDepartment().getDescription()%>
							</div>
						</td>
					</tr>
					<tr>	
						<td class="lblbold" align=right width="15%">Project Manager:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProjectManager">
								<%=pi.getProject().getProjectManager().getName()%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="15%">Amount:</td>
						<td class="lblLight" width="35%">
							<input type="text" name="amount" size="30" value="<%=numFormater.format(pi.getAmount())%>" style="TEXT-ALIGN: right<%=request.getAttribute("ErrorMessage") != null ? ";background-color:#FFAFD3" : ""%>" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
						</td>
					</tr>
				      <tr>
				        <td align="right" class="lblbold">
				          <span class="tabletext">Currency:&nbsp;</span>
				        </td>
				        <td align="left">
				       
				          <select name="currency" onchange="javascript:onCurrSelect()">
						  <%						
						      for (int i0 = 0; i0 < currencyList.size(); i0++) {
								CurrencyType curr = (CurrencyType)currencyList.get(i0);
								if(currency != null && curr.getCurrId().equals(currency.getCurrId())){
								exchangeRate = curr.getCurrRate();
							%>
								<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
							<%  }else if(currency== null && curr.getCurrId().equals("RMB")){
								exchangeRate = curr.getCurrRate();
							%>	
								<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
											
							<%  }else{%>
								<option value="<%=curr.getCurrId()%>"><%=curr.getCurrName()%></option>
							<%}}%>
						  </select>
					
				        </td>
				        <td align="right" class="lblbold">
				          <span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
				        </td>
						<td class="lblLight" width="35%">
							<div style="display:none" id="labelCurrencyRate"></div>	
							<input type=text name="exchangeRate" value="<%if(exchangeRate !=null) out.print(exchangeRate); %>">	
							
						</td>
				      </tr>

					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
							<textarea name="note" cols="130" rows="3"><%=pi.getNote() != null ? pi.getNote() : ""%></textarea>
						</td>
					</tr>
					<tr>
						<td colspan=4>
							<%if(pi.getStatus() == null || (pi.getStatus() != null && !pi.getStatus().equals("Confirmed"))){%>
							<input type="submit" class="button" name="Save" value="Save">
							<%}%>
							<%if(pi.getStatus() != null && !pi.getStatus().equals("Confirmed")){%>
							<input type="button" class="button" name="Delete" value="Delete" onclick="doDelete();">
							<%}%>
							<%if(AOFSECURITY.hasEntityPermission("LOST_RECORD", "_CONFIRM", session) && pi.getStatus() != null && !pi.getStatus().equals("Confirmed")){%>
							<input type="button" class="button" name="Confirm" value="Confirm" onclick="doConfirm();">
							<%}%>
							<input type="button" value="Back to List" name="Back" class="button" onclick="document.backForm.submit();">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
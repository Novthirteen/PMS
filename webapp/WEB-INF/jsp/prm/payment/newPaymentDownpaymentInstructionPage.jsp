<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
function showProjctDialog() {
	var code,desc;
	with(document.newForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.project.dialog.title&payProjectList.do?",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null && v.length > 8) {
			projectCode=v.split("|")[0];
			projectName=v.split("|")[1];
			contractType=v.split("|")[2];
			departmentId=v.split("|")[3];
			departmentNm=v.split("|")[4];
			payToId=v.split("|")[5];
			payToNm=v.split("|")[6];
			pmId=v.split("|")[7];
			pmName=v.split("|")[8];
			labelProject.innerHTML=projectCode+":"+projectName;
			if (contractType == "FP") {
				labelContractType.innerHTML="Fixed Price";
			} else {
				labelContractType.innerHTML="Time & Material";
			}
			labelDepartment.innerHTML=departmentNm;
			labelPM.innerHTML=pmName;
			if (document.newForm.payAddr.value == "") {
				labelPayAddress.innerHTML=payToNm;
				document.newForm.payAddr.value=payToId;
			}
			
			projId.value=projectCode;
		}
	}
}
function showVendorDialog()
{
	var code,desc;
	with(document.newForm)
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
	if (document.newForm.projId.value == "") {
		alert("Project can not be ignored");
		return false;
	}
	
	if (document.newForm.payAddr.value == "") {
		alert("Vendor can not be ignored");
		return false;
	}
	
	if (document.newForm.downAmount.value == "") {
		alert("Down-Payment Amount can not be ignored");
		return false;
	}
	
	if (document.newForm.creditAmount.value == "") {
		alert("Credit-Down-Payment Amount can not be ignored");
		return false;
	}
	
	if (document.newForm.creditAmount.value.substring(0, 1) != "-"
		&& parseFloat(document.newForm.creditAmount.value) != 0) {
		alert("Credit-Down-Payment Amount can not be positive");
		return false;
	}
	
	removeComma(document.newForm.downAmount);
	removeComma(document.newForm.creditAmount);
	
	return true;
}
</script>
<form name="newForm" action="EditPaymentDownpaymentInstruction.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" id="formAction" value="new">
	<input type="hidden" name="payType" id="payType" value="<%=Constants.PAYMENT_TYPE_DOWN_PAYMENT%>">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>Payment Down-Payment Instruction Maintenance</CAPTION>
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
							<!-- does not support user input the paycode this time -->
							<!--<input type="text" name="payCode" size="30" value="" style="TEXT-ALIGN: left" class="lbllgiht">-->
						</td>
					
						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject">&nbsp;</div>
							<input type="hidden" name="projId" id="projId" value="">
							<a href="javascript:void(0)" onclick="showProjctDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Contract Type:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelContractType">&nbsp;</div>							
						</td>
						
						<td class="lblbold" align=right width="15%">Department:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelDepartment">&nbsp;</div>							
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Project Manager:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelPM">&nbsp;</div>							
						</td>
						
						<td class="lblbold" align=right width="15%">Payment Address:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelPayAddress">&nbsp;</div>
							<input type="hidden" name="payAddr" id="payAddr">
							<a href="javascript:void(0)" onclick="showVendorDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Down-Payment Amount:</td>
						<td class="lblLight" width="35%">
							<input type="text" name="downAmount" size="30" value="" style="TEXT-ALIGN: right" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
						</td>						
						<td class="lblbold" align=right width="15%">Credit-Down-Payment Amount:</td>
						<td class="lblLight" width="35%">
							<input type="text" name="creditAmount" size="30" value="0.00" style="TEXT-ALIGN: right" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
						</td>				
					</tr>
					<tr>
												
						<td class="lblbold" align=right width="15%">Currency:</td>
						<td class="lblLight" width="35%">RMB</td>					
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Create Date:</td>
						<td class="lblLight" width="35%">
						</td>
						<td class="lblbold" align=right width="15%">Create User:</td>
						<td class="lblLight" width="35%">
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Remaining Amount:</td>
						<td class="lblLight" width="35%"></td>
						<td class="lblbold" align=right width="15%">Status:</td>
						<td class="lblLight" width="35%">Draft</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
							<textarea name="note" cols="130" rows="3"></textarea>							
						</td>
					</tr>
					<tr>
						<td colspan=4>
							<input type="submit" class="button" name="Save" value="Continue >>">
							<input type="button" value="Back to List" name="Back" class="button" onclick="document.backForm.submit();">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
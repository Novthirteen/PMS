<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>

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
	
	return true;
}
</script>
<form name="newForm" action="EditPaymentInstruction.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="action" id="action" value="new">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>Payment Instruction Maintenance</CAPTION>
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
						<td class="lblbold" align=right width="15%">Total Amount:</td>
						<td class="lblLight" width="35%"></td>						
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
						<td class="lblLight" width="35%"><%=Constants.PAYMENT_STATUS_DRAFT%></td>
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

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
function showProjctDialog() {
	var code,desc;
	with(document.newForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.project.dialog.title&projectList.do?projProfileType=C",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null && v.length > 8) {
			projectCode=v.split("|")[0];
			projectName=v.split("|")[1];
			contractType=v.split("|")[2];
			departmentId=v.split("|")[3];
			departmentNm=v.split("|")[4];
			billToId=v.split("|")[5];
			billToNm=v.split("|")[6];
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
			if (document.newForm.billAddr.value == "") {
				labelBillAddress.innerHTML=billToNm;
				document.newForm.billAddr.value=billToId;
			}
			
			projId.value=projectCode;
		}
	}
}
function showCustomerDialog()
{
	var code,desc;
	with(document.newForm)
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
	if (document.newForm.projId.value == "") {
		alert("Project can not be ignored");
		return false;
	}
	
	if (document.newForm.billAddr.value == "") {
		alert("Customer can not be ignored");
		return false;
	}
	
	return true;
}
</script>
<form name="newForm" action="EditBillingInstruction.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="action" value="new">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>Billing Instruction Maintenance</CAPTION>
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
							<!-- does not support user input the billcode this time -->
							<!--<input type="text" name="billCode" size="30" value="" style="TEXT-ALIGN: left" class="lbllgiht">-->
						</td>
					
						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject">&nbsp;</div>
							<input type=hidden name="projId" value="">
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
						
						<td class="lblbold" align=right width="15%">Bill Address:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelBillAddress">&nbsp;</div>
							<input type=hidden name="billAddr">
							<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
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
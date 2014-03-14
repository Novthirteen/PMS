<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
function checkSubmit() {
	if (document.newForm.emsNo.value == "") {
		alert("EMS No/Contactor can not be ignored");
		return false;
	}
	
	if (document.newForm.emsDate.value == "") {
		alert("Deliver Date can not be ignored");
		return false;
	}
	
	return true;
}

function doBack() {
	document.newForm.action = "findEMS.do";
	document.newForm.formAction.value = "view";
	document.newForm.submit();
}
</script>
<form name="newForm" action="editEMS.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" value="new">
	<input type="hidden" name="qryEMSType" value="<%=qryEMSType%>">
	<input type="hidden" name="qryEMSNo" value="<%=qryEMSNo%>">
	<input type="hidden" name="qryDepartment" value="<%=qryDepartment%>">
	<input type="hidden" name="emsInvoiceId" value="<%=emsInvoiceId%>">

	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>EMS Maintenance</CAPTION>
		<tr>
			<td>
				<TABLE width="100%">
					<tr>
						<td colspan="8"><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Deliver Type:</td>
						<td class="lblLight" width="35%">
							<input type="radio" name="emsType" value="<%=Constants.EMS_TYPE_EMS_DELIVER%>" checked><%=Constants.EMS_TYPE_EMS_DELIVER%>&nbsp;
							<input type="radio" name="emsType" value="<%=Constants.EMS_TYPE_OTHER_DELIVER%>"><%=Constants.EMS_TYPE_OTHER_DELIVER%>
						</td>
					</tr>
					<tr>	
						<td class="lblbold" align=right width="15%">EMS No/Contactor:</td>
						<td class="lblLight" width="35%">							
							<input type="text" name="emsNo" size="30" value="" style="TEXT-ALIGN: left" class="lbllgiht">
						</td>
					</tr>
					<tr>						
						<td class="lblbold" align=right width="15%">Deliver Date:</td>
						<td class="lblLight" width="35%">							
							<input  type="text" name="emsDate" size="12" value="<%=dateFormat.format(new Date())%>">
							<A href="javascript:ShowCalendar(document.newForm.dimg1,document.newForm.emsDate,null,0,330)" onclick=event.cancelBubble=true;>
								<IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" >
							</A>					
						</td>
					</tr>					
					<tr>
						<td class="lblbold" align=right width="15%">Create User:</td>
						<td class="lblLight" width="35%"></td>
						<td class="lblbold" align=right width="15%">Create Date:</td>
						<td class="lblLight" width="35%"></td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
							<textarea name="emsNote" cols="130" rows="3"></textarea>							
						</td>
					</tr>					
					<tr>
						<td colspan=4>
							<input type="submit" class="button" name="Save" value="Continue >>">
							<input type="button" value="Back to List" name="Back" class="button" onclick="doBack();">
						</td>
					</tr>
					<tr>
						<td colspan="8"><hr color=red></hr></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
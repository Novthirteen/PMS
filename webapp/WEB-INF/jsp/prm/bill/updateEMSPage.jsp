<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
function showInvoice() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.projectInvoice.invoice.dialog.title&findInvoice.do?formAction=dialogView&emsId=<%=pe.getId()%>&status=<%=Constants.INVOICE_STATUS_UNDELIVERED%>",
		null,
	'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
	
	document.newForm.formAction.value = "view";
	document.newForm.submit();
}
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
function doDelete() {
	if (confirm("Do you want to delete?")) {
	document.newForm.formAction.value = "delete";
	document.newForm.submit();
	}
}
function doDeleteInvoice(invoiceId) {
    if (confirm("Do you want to delete?")) {
	document.newForm.formAction.value = "deleteInvoice";
	document.newForm.invoiceId.value = invoiceId;
	document.newForm.submit();
	}
}
</script>
<%
	String formAction = request.getParameter("formAction");
	boolean canNotRemove = false;
	if (pe.getInvoices() != null) {
 		Iterator invoices = pe.getInvoices().iterator();
 		while(invoices.hasNext()) {
 			ProjectInvoice pi = (ProjectInvoice)invoices.next();
 			if (pi.getStatus().equals(Constants.INVOICE_STATUS_CONFIRMED)
 				|| pi.getStatus().equals(Constants.INVOICE_STATUS_CANCELED)) {
 				canNotRemove = true;
 				break;
 			}
 		}		
	}
%>
<form name="newForm" action="editEMS.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" id="formAction" value="update">
	<input type="hidden" name="qryEMSType" id="qryEMSType" value="<%=qryEMSType%>">
	<input type="hidden" name="qryEMSNo" id="qryEMSNo" value="<%=qryEMSNo%>">
	<input type="hidden" name="qryDepartment" id="qryDepartment" value="<%=qryDepartment%>">
	<input type="hidden" name="emsId" id="emsId" value="<%=pe.getId()%>">
	<input type="hidden" name="invoiceId" id="invoiceId" value="">

	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>EMS Maintenance</CAPTION>
		<tr>
			<td>
				<TABLE width="100%">
					<tr>
						<td colspan="4"><hr color=red></hr></td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Deliver Type:</td>
						<td class="lblLight" width="35%">
							<%
								if ("dialogView".equals(formAction)) { 
							%>
							<%=pe.getType()%>
							<%
								} else {
							%>
							<input type="radio" name="emsType" value="<%=Constants.EMS_TYPE_EMS_DELIVER%>" <%=Constants.EMS_TYPE_EMS_DELIVER.equals(pe.getType()) ? "checked" : ""%>><%=Constants.EMS_TYPE_EMS_DELIVER%>&nbsp;
							<input type="radio" name="emsType" value="<%=Constants.EMS_TYPE_OTHER_DELIVER%>" <%=Constants.EMS_TYPE_OTHER_DELIVER.equals(pe.getType()) ? "checked" : ""%>><%=Constants.EMS_TYPE_OTHER_DELIVER%>
							<%
								}
							%>
						</td>
					</tr>
					<tr>	
						<td class="lblbold" align=right width="15%">EMS No/Contactor:</td>
						<td class="lblLight" width="35%">	
							<%
								if ("dialogView".equals(formAction)) { 
							%>
							<%=pe.getNo()%>
							<%
								} else {
							%>
							<input type="text" name="emsNo" size="30" value="<%=pe.getNo()%>" style="TEXT-ALIGN: left" class="lbllgiht">													
							<%
								}
							%>
						</td>
					</tr>
					<tr>						
						<td class="lblbold" align=right width="15%">Deliver Date:</td>
						<td class="lblLight" width="35%">		
							<%
								if ("dialogView".equals(formAction)) { 
							%>		
							<%=dateFormat.format(pe.getEmsDate())%>
							<%
								} else {
							%>	
							<input  type="text" name="emsDate" size="12" value="<%=dateFormat.format(pe.getEmsDate())%>">
							<A href="javascript:ShowCalendar(document.newForm.dimg1,document.newForm.emsDate,null,0,330)" onclick=event.cancelBubble=true;>
								<IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" >
							</A>
							<%
								}
							%>
						</td>
					</tr>					
					<tr>
						<td class="lblbold" align=right width="15%">Create User:</td>
						<td class="lblLight" width="35%">
							<%=pe.getCreateUser().getName()%>
						</td>
						<td class="lblbold" align=right width="15%">Create Date:</td>
						<td class="lblLight" width="35%">
							<%=dateFormat.format(pe.getCreateDate())%>			
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
							<%
								if ("dialogView".equals(formAction)) { 
							%>	
							<%=pe.getNote()%>
							<%
								} else {
							%>	
							<textarea name="emsNote" cols="130" rows="3"><%=pe.getNote()%></textarea>
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
							<input type="submit" class="button" name="save" value="Save">
							<%
								if (!canNotRemove) {
							%>
							<input type="button" class="button" name="delete" value="Delete" onclick="doDelete();">
							<%
								}
							%>
							<input type="button" value="Back to List" name="Back" class="button" onclick="doBack();">
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td colspan="4"><hr color=red></hr></td>
					</tr>
					<tr>
				        <TD align=left colspan=4 class="wpsPortletTopTitle">
				            Invoice Information
				        </TD>
			        </tr>
					<tr>
						<td colspan="4">
							<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
 								<TR bgcolor="#e9eee9">
									<td align="center" class="lblbold">#&nbsp;</td>
								  	<td align="center" class="lblbold">Invoice Code</td>
								  	<td align="center" class="lblbold">Bill Code</td>
								    <td align="center" class="lblbold">Project</td>
									<td align="center" class="lblbold">Bill Address</td>
								    <td align="center" class="lblbold">Department</td>	   
								    <td align="center" class="lblbold">Currency</td>
								    <td align="center" class="lblbold">Amount</td>
								    <td align="center" class="lblbold">Status</td>
								    <td align="center" class="lblbold">Create Date</td>
								    <%
										if (!"dialogView".equals(formAction)) { 
									%>	
								    <td class="lblbold">&nbsp;</td>
								    <%
										}
									%>
								 </tr>
								 
								 <%
								 	if (pe.getInvoices() != null) {
								 		Iterator invoices = pe.getInvoices().iterator();
								 		int count = 1;
								 		while(invoices.hasNext()) {
								 			ProjectInvoice pi = (ProjectInvoice)invoices.next();
								 %>
								 <TR bgcolor="#e9eee9">
								 	<td align="center"><%=count++%></td>
							    	<td align="left"> 
										<%=pi.getInvoiceCode()%>
							    	</td>
							    	<td align="left"> 
							    		<%
							    			if (pi.getBilling() != null) {
							    				ProjectBill billing = pi.getBilling();
							    		%>
							    		<%=billing.getBillCode()%>
										<%
											}
										%>
							    	</td>
							    	<td align="left">                 
							       		<%=pi.getProject().getProjId()%>:<%=pi.getProject().getProjName() != null ? pi.getProject().getProjName() : ""%>
							        </td>
							        <td align="left">                 
							           <%=pi.getBillAddress().getDescription() != null ? pi.getBillAddress().getDescription() : ""%>
							        </td>
							        <td align="left">                 
							           <%=pi.getProject().getDepartment().getDescription() != null ? pi.getProject().getDepartment().getDescription() : ""%>
							        </td>
							        <td align="left">                 
							           <%=pi.getCurrency().getCurrName() != null ? pi.getCurrency().getCurrName() : ""%>
							        </td>        
							        <td align="right">                 
							           <%=numFormat.format(pi.getAmount())%>
							        </td>
							        <td align="left">                 
							           <%=pi.getStatus()%>
							        </td>
							        <td align="center">                 
							           <%=pi.getCreateDate() != null ? dateFormat.format(pi.getCreateDate()) : ""%>
							        </td>	
							        <td align="center">						        
							        <%
											if (Constants.INVOICE_STATUS_DELIVERED.equals(pi.getStatus()) && !"dialogView".equals(formAction)) {
									%>
							           <a href="#" onclick="doDeleteInvoice(<%=pi.getId()%>);">Delete</a>
									<%
											}
									%>
									</td>
								 <%
								 		}
								 	}
								 %>
								<tr>
									<%
										if (!"dialogView".equals(formAction)) { 
									%>	
									<td colspan="10">
										<input type="button" value="Add Invoice" name="add" class="button" onclick="showInvoice();">
									</td>
									<%
									 	}
									 %>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
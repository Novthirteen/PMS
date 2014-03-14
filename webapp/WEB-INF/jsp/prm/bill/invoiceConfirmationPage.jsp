<script language="javascript">
	function showConfirm(confirmId) {
		var param = "invoiceId=" + "<%=pi.getId()%>" + "&formAction=view";
		if (confirmId != null) {
			param += "&confirmId=" + confirmId;
		}
		
		v = window.showModalDialog(
		"system.showDialog.do?title=prm.projectInvoice.addconfirmation.dialog.title&editInvoiceConfirm.do?" + param,
			null,
		'dialogWidth:640px;dialogHeight:300px;status:no;help:no;scroll:auto');
		
		document.updateForm.formAction.value = "view";
		document.updateForm.submit();
	}
	
	function doDeleteConfirm(confirmId) {
	if (confirm("Do you want to delete?")) {
		document.updateForm.confirmId.value = confirmId;
		document.updateForm.formAction.value = "deleteConfirm";
		document.updateForm.submit();
		}
	}
</script>
<TR>
	<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
		Invoice Confirmation
	</TD>
</TR>
<tr>
	<td colspan="4">
		<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
			<tr bgcolor="#e9eee9">
				<td align="center" class="lblbold">#&nbsp;</td>
			  	<td align="center" class="lblbold">Contact Date</td>
			  	<td align="center" class="lblbold">Contact Person</td>
			    <td align="center" class="lblbold">Responsible Person</td>
				<td align="center" class="lblbold">Confirm Amount</td>
				<td align="center" class="lblbold">Currency</td>
			    <td align="center" class="lblbold">Confirm Date</td>
			    <td align="center" class="lblbold">Create Date</td>
			<%
				if ("confirmation".equals(request.getParameter("process")) 
					&& pi.getStatus().equals(Constants.INVOICE_STATUS_CONFIRMED)) {
			%>
			    <td class="lblbold">&nbsp;</td>
			<%
				}
			%>
			 </tr>				 		 
			 <%
			 	if (pi.getConfirms() != null) {
			 		Iterator confirms = pi.getConfirms().iterator();
			 		int count = 1;
			 		while(confirms.hasNext()) {
			 			ProjectInvoiceConfirmation pic = (ProjectInvoiceConfirmation)confirms.next();
			 %>
			 <TR bgcolor="#e9eee9">
			 	<td align="center"><%=count++%></td>
		    	<td align="center"> 
					<%=pic.getContactDate() != null ? dateFormat.format(pic.getContactDate()) : ""%>
		    	</td>
		    	<td align="left"> 
					<%=pic.getContactor() != null ? pic.getContactor() : ""%>
		    	</td>
		    	<td align="left"> 
					<%=pic.getResponsiblePerson() != null ? pic.getResponsiblePerson().getName() : ""%>
		    	</td>
		    	<td align="right"> 
					<%=pic.getPayAmount() != null ? numFormater.format(pic.getPayAmount()) : ""%>
		    	</td>
		    	<td align="left"> 
					<%=pic.getCurrency() != null ? pic.getCurrency().getCurrName() : ""%>
		    	</td>
		    	<td align="center"> 
					<%=pic.getPayDate() != null ? dateFormat.format(pic.getPayDate()) : ""%>
		    	</td>
		    	<td align="center"> 
					<%=pic.getCreateDate() != null ? dateFormat.format(pic.getCreateDate()) : ""%>
		    	</td>
		    <%
				if ("confirmation".equals(request.getParameter("process")) 
					&& pi.getStatus().equals(Constants.INVOICE_STATUS_CONFIRMED)) {
			%>
		    	<td align="center"> 
					<a href="#" onclick="showConfirm('<%=pic.getId()%>');">Edit</a>
					&nbsp;
					<a href="#" onclick="doDeleteConfirm('<%=pic.getId()%>');">Delete</a>
		    	</td>
		    <%
		    	}
		    %>
		     </tr>
			 <%
			 		}
			 	}
			 %>
			 <%
			 	if ("confirmation".equals(request.getParameter("process")) 
					&& pi.getStatus().equals(Constants.INVOICE_STATUS_CONFIRMED)
					&& AOFSECURITY.hasEntityPermission("PROJ_INVOICE", "_CREATE", session)) {
			 %>
			 <tr>
				<td colspan="10" align="left">
					<input type="button" value="Add Confirmation" name="add" class="button" onclick="showConfirm();">
				</td>
			</tr>
			<%
				}
			%>
		</table>
	</td>
</tr>
<script language="javascript">
	function showReceipt(receiptId) {
		var param = "invoiceId=" + "<%=pi.getId()%>" + "&formAction=view";
		if (receiptId != null) {
			param += "&receiptId=" + receiptId;
		}
		v = window.showModalDialog(
		"system.showDialog.do?title=prm.projectInvoice.addreceipt.dialog.title&settleReceipt.do?" + param,
			null,
		'dialogWidth:800px;dialogHeight:400px;status:no;help:no;scroll:auto');
		document.updateForm.formAction.value = "view";
		document.updateForm.submit();
	}

	
	function doDeleteReceipt(receiptId) {
	if (confirm("Do you want to delete?")) {
		document.updateForm.receiptId.value = receiptId;
		document.updateForm.formAction.value = "deleteReceipt";
		document.updateForm.submit();
		}
	}
</script>
<TR>
	<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
		Receipt
	</TD>
</TR>
<tr>
	<td colspan="4">
		<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
			<tr bgcolor="#e9eee9">
				<td align="center" class="lblbold">#&nbsp;</td>
			  	<td align="center" class="lblbold">Receipt No</td>
			  	<td align="center" class="lblbold">Receive Amount (RMB)</td>
			    <td align="center" class="lblbold">Currency</td>
			    <td align="center" class="lblbold">Exchange Rate</td>
				<td align="center" class="lblbold">Receive Date</td>
			    <td align="center" class="lblbold">Create Date</td>
			 <%
				if ("receipt".equals(request.getParameter("process"))) {
			 %>
			    <td class="lblbold">&nbsp;</td>
			 <%
			 	}
			 %>
			 </tr>				 		 
			 <%
			 	if (pi.getReceipts() != null) {
			 		Iterator receipts = pi.getReceipts().iterator();
			 		int count = 1;
			 		while(receipts.hasNext()) {
			 			ProjectReceipt pr = (ProjectReceipt)receipts.next();
			 %>
			 <TR bgcolor="#e9eee9">
			 	<td align="center"><%=count++%></td>
		    	<td align="left"> 
					<%=pr.getReceiptNo() != null ? pr.getReceiptNo() : ""%>
		    	</td>
		    	<td align="right"> 
					<%=pr.getReceiveAmount() != null ? numFormater.format(pr.getReceiveAmount()) : ""%>
		    	</td>
		    	<td align="left"> 
					<%=pr.getCurrency() != null ? pr.getCurrency().getCurrName() : ""%>
		    	</td>
		    	<td align="right"> 
					<%=pr.getCurrencyRate() != null ? String.valueOf(pr.getCurrencyRate()) : ""%>
		    	</td>
		    	<td align="center"> 
					<%=pr.getReceiveDate() != null ? dateFormat.format(pr.getReceiveDate()) : ""%>
		    	</td>
		    	<td align="center"> 
					<%=pr.getCreateDate() != null ? dateFormat.format(pr.getCreateDate()) : ""%>
		    	</td>
		   	 <%
				if ("receipt".equals(request.getParameter("process"))) {
			 %>
		    	<td align="center">
					<a href="#" onclick="doDeleteReceipt('<%=pr.getId()%>');">Delete</a>
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
			 	if (AOFSECURITY.hasEntityPermission("PROJ_RECEIPT", "_CREATE", session)
			 	&& "receipt".equals(request.getParameter("process"))) {
			 %>
			 <tr>
				<td colspan="10" align="left">
					<input type="button" value="Add Receipt" name="add" class="button" 	onclick="showReceipt()">
				</td>
			</tr>
			<%
				}
			%>
		</table>
	</td>
</tr>
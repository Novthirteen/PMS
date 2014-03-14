<tr align="center" bgcolor="#e9eee9">
	<td class="lblbold" align="center">&nbsp;
		<%
			if (canUpdate) {
		%>
		<input type="checkbox"  class="checkboxstyle" name="chkAllBill" onclick="checkUncheckAllBox(document.editForm.chkAllBill, document.editForm.payDetailId)">
		<%
			} else {
		%>
		#
		<%
			}
		%>
	&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Project&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Payment Address&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Currency&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Amount&nbsp;</td>
</tr>
<%
		List paymentCDPList = pp.getCreditDownPaymentDetails();
		if (paymentCDPList != null && paymentCDPList.size() > 0) {
			for (int i0 = 0; i0 < paymentCDPList.size(); i0++) {
				PaymentTransactionDetail ptd = (PaymentTransactionDetail)paymentCDPList.get(i0);
%>
<tr align="center" bgcolor="#e9eee9">
	<TD align="center">
		<%
			if (canUpdate) {
		%>
		<input type="checkbox" class="checkboxstyle" name="payDetailId" value="<%=ptd.getTransactionId()%>" onclick="checkTopBox(document.editForm.chkAllPayment, document.editForm.payDetailId)">
		<%
			} else {
		%>
			<%=i0 + 1%>
		<%
			}
		%>
	</TD>
	<TD align="left">
		<%=ptd.getProject().getProjId()%>:<%=ptd.getProject().getProjName() != null ? ptd.getProject().getProjName() : ""%>
	</TD>
	<TD align="left">
		<%=ptd.getTransactionParty().getDescription()%>
	</TD>
	<TD align="left">
		<%=ptd.getCurrency().getCurrId()%>
	</TD>
	<TD align="right">
		<%=ptd.getAmount() != null ? numFormater.format(ptd.getAmount()) : ""%>
	</TD>
</TR>
<%	
			}
		} else {
%>
<tr align="center">
	<td colspan="6">
		<font color="red">No Record Found</font>
	<td>
</tr>
<%
		}
		
%>
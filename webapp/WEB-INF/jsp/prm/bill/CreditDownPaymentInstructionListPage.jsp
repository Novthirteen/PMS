<tr align="center" bgcolor="#e9eee9">
	<td class="lblbold" align="center">&nbsp;
		<%
			if (canUpdate) {
		%>
		<input type="checkbox"  class="checkboxstyle" name="chkAllBill" onclick="checkUncheckAllBox(document.editForm.chkAllBill, document.editForm.billDetailId)">
		<%
			} else {
		%>
		#
		<%
			}
		%>
	&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Project&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Bill Address&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Currency&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Amount&nbsp;</td>
</tr>
<%
		List billingList = pb.getCreditDownPaymentDetails();
		if (billingList != null && billingList.size() > 0) {
			for (int i0 = 0; i0 < billingList.size(); i0++) {
				BillTransactionDetail btd = (BillTransactionDetail)billingList.get(i0);
%>
<tr align="center" bgcolor="#e9eee9">
	<TD align="center">
		<%
			if (canUpdate) {
		%>
		<input type="checkbox" class="checkboxstyle" name="billDetailId" value="<%=btd.getTransactionId()%>" onclick="checkTopBox(document.editForm.chkAllBill, document.editForm.billDetailId)">
		<%
			} else {
		%>
			<%=i0 + 1%>
		<%
			}
		%>
	</TD>
	<TD align="left">
		<%=btd.getProject().getProjId()%>:<%=btd.getProject().getProjName() != null ? btd.getProject().getProjName() : ""%>
	</TD>
	<TD align="left">
		<%=btd.getTransactionParty().getDescription()%>
	</TD>
	<TD align="left">
		<%=btd.getCurrency().getCurrId()%>
	</TD>
	<TD align="right">
		<%=btd.getAmount() != null ? numFormater.format(btd.getAmount()) : ""%>
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
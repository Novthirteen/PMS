<tr align="center" bgcolor="#e9eee9">
	<td class="lblbold" align="center">&nbsp;
		<%
			if (canUpdate) {
		%>
		<input type="checkbox"  class="checkboxstyle" name="chkAllPayment" onclick="checkUncheckAllBox(document.editForm.chkAllPayment, document.editForm.payDetailId)">
		<%
			} else {
		%>
		#
		<%
			}
		%>
	&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Project&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Staff Name&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Event&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Service Type&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;CAF Date&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;CAF Work Hrs&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Currency&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Rate&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Amount&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Confirm Date&nbsp;</td>
</tr>
<%
		List CAFList = pp.getCAFDetails();
		if (CAFList != null && CAFList.size() > 0) {
			for (int i0 = 0; i0 < CAFList.size(); i0++) {
				PaymentTransactionDetail ptd = (PaymentTransactionDetail)CAFList.get(i0);
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
		<%=ptd.getTransactionUser() != null ? ptd.getTransactionUser().getName() : ""%>
	</TD>
	<TD align="left">
		<%=ptd.getDesc1() != null ? ptd.getDesc1() : ""%>
	</TD>
	<TD align="left">
		<%=ptd.getDesc2() != null ? ptd.getDesc2() : ""%>
	</TD>
	<TD align="center">
		<%=ptd.getTransactionDate() != null ? dateFormater.format(ptd.getTransactionDate()) : ""%>
	</TD>
	<TD align="right">
		<%=ptd.getTransactionNum1() != null ? numFormater.format(ptd.getTransactionNum1()) : ""%>
	</TD>
	<TD align="left">
		<%=ptd.getCurrency().getCurrId()%>
	</TD>
	<TD align="right">
		<%=ptd.getTransactionNum2() != null ? numFormater.format(ptd.getTransactionNum2()) : ""%>
	</TD>
	<TD align="right">
		<%=ptd.getAmount() != null ? numFormater.format(ptd.getAmount()) : ""%>
	</TD>
	<TD align="center">
		<%=ptd.getTransactionDate1() != null ? dateFormater.format(ptd.getTransactionDate1()) : ""%>
	</TD>
</TR>
<%	
			}
		} else {
%>
<tr align="center">
	<td colspan="10">
		<font color="red">No Record Found</font>
	<td>
</tr>
<%
		}
		
%>
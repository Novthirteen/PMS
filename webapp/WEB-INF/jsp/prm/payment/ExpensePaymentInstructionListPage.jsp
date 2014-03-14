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
	<td align="center" class="lblbold">&nbsp;ER No.&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Staff Name&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Expense Date&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Currency&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Amount&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Claim Date&nbsp;</td>
</tr>
<%
		List expenseList = pp.getExpenseDetails();
		if (expenseList != null && expenseList.size() > 0) {
			for (int i0 = 0; i0 < expenseList.size(); i0++) {
				PaymentTransactionDetail ptd = (PaymentTransactionDetail)expenseList.get(i0);
%>
<tr align="center" bgcodlor="#e9eee9">
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
		<%
			if (ptd.getTransactionCategory().trim().equals(Constants.TRANSACATION_CATEGORY_EXPENSE)) {
		%>
		<a href="#" onclick="showExpDetail('<%=ptd.getTransactionRecId()%>');"><%=ptd.getDesc1() != null ? ptd.getDesc1() : ""%></a> 
		<%
			} else {
		%>
		<a href="#" onclick="showOtherCostDetail('<%=ptd.getTransactionRecId()%>');"><%=ptd.getDesc1() != null ? ptd.getDesc1() : ""%></a>
		<%
			}
		%>
	</TD>
	<TD align="left">
		<%=ptd.getTransactionUser() != null ? ptd.getTransactionUser().getName() : ""%>
	</TD>
	<TD align="center">
		<%=ptd.getTransactionDate() != null ? dateFormater.format(ptd.getTransactionDate()) : ""%>
	</TD>
	<TD align="left">
		<%=ptd.getCurrency().getCurrId()%>
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
	<td colspan="8">
		<font color="red">No Record Found</font>
	<td>
</tr>
<%
		}
		
%>
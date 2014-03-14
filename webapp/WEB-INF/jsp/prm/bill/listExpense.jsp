<tr align="center" bgcolor="#e9eee9">
	<td class="lblbold" size="1">
		#
	</td>
	<td align="center" class="lblbold">&nbsp;Project&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;ER No.&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Staff Name&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Expense Date&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Currency&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Amount&nbsp;</td>
</tr>
<%
		List expenseList = pb.getExpenseDetails();
	
		if (expenseList != null && expenseList.size() > 0) {
			for (int i0 = 0; i0 < expenseList.size(); i0++) {
				BillTransactionDetail btd = (BillTransactionDetail)expenseList.get(i0);
%>
<tr align="center" bgcolor="#e9eee9">
	<TD align="center">
		<input type="checkbox" class="checkboxstyle" name="billDetailId" value="<%=btd.getTransactionId()%>">
	</TD>
	<TD align="left">
		<%=btd.getProject().getProjId()%>:<%=btd.getProject().getProjName() != null ? btd.getProject().getProjName() : ""%>
	</TD>
	<TD align="left">
		<%=btd.getDesc1() != null ? btd.getDesc1() : ""%>
	</TD>
	<TD align="left">
		<%=btd.getTransactionUser() != null ? btd.getTransactionUser().getName() : ""%>
	</TD>
	<TD align="center">
		<%=btd.getTransactionDate() != null ? dateFormater.format(btd.getTransactionDate()) : ""%>
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
	<td colspan="7">
		<font color="red">No Record Found</font>
	<td>
</tr>
<%
		}
		
%>
<tr>
	<TD align="left" colspan="7">
		<input type="button" class="button" name="remove" value="remove from billing list">
	</TD>
</tr>
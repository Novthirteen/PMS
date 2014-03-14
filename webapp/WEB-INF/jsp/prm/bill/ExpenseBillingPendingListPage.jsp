<tr align="center" bgcolor="#e9eee9">
	<td class="lblbold" align="center">&nbsp;
		<%
			String readonlyFlg = (String)request.getAttribute("readonly");
			if (!"1".equals(readonlyFlg)) {
		%>
		<input type="checkbox"  class="checkboxstyle" name="chkAllPending" onclick="checkUncheckAllBox(document.editForm.chkAllPending, document.editForm.transactionId)">
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
	<td align="center" class="lblbold">&nbsp;Amount in RMB&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Claim Date&nbsp;</td>
</tr>
<%
		List etList = (List)request.getAttribute("ExpenseTransactionList");
		if (etList != null && etList.size() > 0) {
			for (int i0 = 0; i0 < etList.size(); i0++) {
				BillTransactionDetail btd = (BillTransactionDetail)etList.get(i0);
%>
<tr align="center" bgcolor="#e9eee9">
	<TD align="center">
		<%
			if ("1".equals(readonlyFlg)) {
		%>
		<%=i0 + 1%>
		<%
			} else {
		%>
		<input type="checkbox" class="checkboxstyle" name="transactionId" value="<%=btd.getTransactionId()%>" onclick="checkTopBox(document.editForm.chkAllPending, document.editForm.transactionId)">
		<%
			}
		%>
	</TD>
	<TD align="left">
		<%=btd.getProject().getProjId()%>:<%=btd.getProject().getProjName() != null ? btd.getProject().getProjName() : ""%>
	</TD>
	<TD align="left">
		<%
			if (btd.getTransactionCategory().trim().equals(Constants.TRANSACATION_CATEGORY_EXPENSE)) {
		%>
		<a href="#" onclick="showExpDetail('<%=btd.getTransactionRecId()%>');"><%=btd.getDesc1() != null ? btd.getDesc1() : ""%></a>
		<%
			} else {
		%>
		<a href="#" onclick="showOtherCostDetail('<%=btd.getTransactionRecId()%>');"><%=btd.getDesc1() != null ? btd.getDesc1() : ""%></a>
		<%
			}
		%>
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
	<%
		double a = 0;
		if (btd.getAmount() != null && btd.getExchangeRate()!=null ){
			 a = btd.getAmount().floatValue()*btd.getExchangeRate().floatValue();
		}
	%>
	<TD align="right">
		<%=numFormater.format(a)%>
	</TD>
	<TD align="center">
		<%=btd.getTransactionDate1() != null ? dateFormater.format(btd.getTransactionDate1()) : ""%>
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
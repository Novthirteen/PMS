<%
boolean ff = true;
		List btList1 = (List)request.getAttribute("BillingTransactionList");
		if (btList1 != null && btList1.size() > 0) {
				BillTransactionDetail btd1 = (BillTransactionDetail)btList1.get(0);
				if (btd1.getProject().getContractGroup().equalsIgnoreCase("material")) {
					ff = false;
					}
			}
%>
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
	<%if (!ff ) {%>
		<td align="center" class="lblbold">&nbsp;Acceptance Description&nbsp;</td>
	<%}else{%>
		<td align="center" class="lblbold">&nbsp;Phase&nbsp;</td>
	<%}%>	
	<td align="center" class="lblbold">&nbsp;Customer Acceptance Date&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Currency&nbsp;</td>
	<%if (ff ) {%>
	<td align="center" class="lblbold">&nbsp;Actual Man Days&nbsp;</td>
	<%}%>
	<td align="center" class="lblbold">&nbsp;Total Amount&nbsp;</td>
</tr>
<%
		List btList = (List)request.getAttribute("BillingTransactionList");
		if (btList != null && btList.size() > 0) {
			for (int i0 = 0; i0 < btList.size(); i0++) {
				BillTransactionDetail btd = (BillTransactionDetail)btList.get(i0);
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
		<%=btd.getDesc1() != null ? btd.getDesc1() : ""%>
	</TD>
	<TD align="center">
		<%=btd.getTransactionDate() != null ? dateFormater.format(btd.getTransactionDate()) : ""%>
	</TD>
	<TD align="left">
		<%=btd.getCurrency().getCurrId()%>
	</TD>
	<%if (ff ) {%>
	<TD align="right">
		<%=btd.getTransactionNum2() != null ? numFormater.format(btd.getTransactionNum2()) : ""%>
	</TD>
	<%}%>
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
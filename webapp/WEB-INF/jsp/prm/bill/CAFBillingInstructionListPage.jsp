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
		List CAFList = pb.getCAFDetails();
		if (CAFList != null && CAFList.size() > 0) {
			for (int i0 = 0; i0 < CAFList.size(); i0++) {
				BillTransactionDetail btd = (BillTransactionDetail)CAFList.get(i0);
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
		<%=btd.getTransactionUser() != null ? btd.getTransactionUser().getName() : ""%>
	</TD>
	<TD align="left">
		<%=btd.getDesc1() != null ? btd.getDesc1() : ""%>
	</TD>
	<TD align="left">
		<%=btd.getDesc2() != null ? btd.getDesc2() : ""%>
	</TD>
	<TD align="center">
		<%=btd.getTransactionDate() != null ? dateFormater.format(btd.getTransactionDate()) : ""%>
	</TD>
	<TD align="right">
		<%=btd.getTransactionNum1() != null ? numFormater.format(btd.getTransactionNum1()) : ""%>
	</TD>
	<TD align="left">
		<%=btd.getCurrency().getCurrId()%>
	</TD>
	<TD align="right">
		<%=btd.getTransactionNum2() != null ? numFormater.format(btd.getTransactionNum2()) : ""%>
	</TD>
	<TD align="right">
		<%=btd.getAmount() != null ? numFormater.format(btd.getAmount()) : ""%>
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
	<td colspan="10">
		<font color="red">No Record Found</font>
	<td>
</tr>
<%
		}
		
%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults" %>
<tr align="center" bgcolor="#e9eee9">
	<td class="lblbold" align="center">&nbsp;#&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Project&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Customer&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Invoice Code&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Invoice Amount&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Receive Amount&nbsp;</td>
</tr>
<%
		SQLResults result = (SQLResults)request.getAttribute("CheckBillingList");
		if (result != null && result.getRowCount() > 0) {
			for(int i=0; i<result.getRowCount(); i++){
%>
<tr align="center" bgcolor="#e9eee9">
	<TD align="center">
		<%=i + 1%>
	</TD>
	<TD align="left">
		<%=result.getString(i, "proj_id")%>:<%=result.getString(i, "proj_name")%>
	</TD>
	<TD align="left">
		<%=result.getString(i, "cust_name") != null?result.getString(i, "cust_name"):""%>
	</TD>
	<TD align="center">
		<%=result.getString(i, "inv_code")%>
	</TD>
	<TD align="center">
		<%=numFormater.format(result.getDouble(i, "inv_amt"))%>
	</TD>
	<TD align="right">
		<%=numFormater.format(result.getDouble(i, "rec_amt"))%>
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
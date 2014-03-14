<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.payment.ProjectPayment"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<%
	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);	
	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy/MM/dd");
	
	ProjectPayment pp = (ProjectPayment)request.getAttribute("InstructionList");
%>
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Payment Instruction Detail</CAPTION>
<TR>
	<td colspan="4"><hr color="red"></hr></td>
</TR>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Payment Code:&nbsp;</td>
<td><%=pp.getPaymentCode()%></td>
<td align="right" class="lblbold">Payment Type:&nbsp;</td>
<td><%=pp.getType()%></td>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Total Amount:&nbsp;</td>
<td><%=numFormater.format(pp.getCalAmount())%></td>
<td align="right" class="lblbold">Remaining Amount:&nbsp;</td>
<td><%=numFormater.format(pp.getCalAmount().doubleValue()-pp.getSettledAmount().doubleValue())%></td>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Create User:&nbsp;</td>
<td><%=pp.getCreateUser().getName()%></td>
<td align="right" class="lblbold">Create Date:&nbsp;</td>
<td><%=dateFormater.format(pp.getCreateDate())%></td>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Vendor:&nbsp;</td>
<td><%=pp.getPayAddress().getDescription()%></td>
<td align="right" class="lblbold">Status:&nbsp;</td>
<td><%=pp.getStatus()%></td>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Note:&nbsp;</td>
<td><%=pp.getNote()==null?"":pp.getNote()%></td>
<td colspan="2"/>
</tr>
<TR>
	<td colspan="4">
		&nbsp;&nbsp;<input type="button" class="button" name="Close" value="Close" onclick="self.close();">
	</td>
</TR>
</table>
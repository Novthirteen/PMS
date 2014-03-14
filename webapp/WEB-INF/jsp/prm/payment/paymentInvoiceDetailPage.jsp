<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.payment.ProjectPaymentMaster"%>
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
	
	ProjectPaymentMaster ppm = (ProjectPaymentMaster)request.getAttribute("InvoiceList");
%>
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Supplier Invoice Detail</CAPTION>
<TR>
	<td colspan="4"><hr color="red"></hr></td>
</TR>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Supplier Invoice Code:&nbsp;</td>
<td><%=ppm.getPayCode()%></td>
<td align="right" class="lblbold">Invoice Type:&nbsp;</td>
<td><%=ppm.getPayType()%></td>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Total Amount:&nbsp;</td>
<td><%=ppm.getPayAmount()%></td>
<td align="right" class="lblbold">Paid Remaining Amount&nbsp;</td>
<td><%=ppm.getPaidRemainingAmount()%></td>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Currency:&nbsp;</td>
<td><%=ppm.getCurrency().getCurrName()%></td>
<td align="right" class="lblbold">Exchange Rate:&nbsp;</td>
<td><%=numFormater.format(ppm.getExchangeRate())%></td>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Create Date:&nbsp;</td>
<td><%=dateFormater.format(ppm.getCreateDate())%></td>
<td align="right" class="lblbold">Create User:&nbsp;</td>
<td><%=ppm.getCreateUser().getName()%></td>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Status:&nbsp;</td>
<td><%=ppm.getPayStatus()%></td>
<td align="right" class="lblbold">Vendor:&nbsp;</td>
<td><%=ppm.getVendorId().getDescription()%></td>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Invoice Date:&nbsp;</td>
<td><%=ppm.getPayDate()==null?"":dateFormater.format(ppm.getPayDate())%></td>
<td colspan="2"/>
</tr>
<tr bgcolor="#e9eee9">
<td align="right" class="lblbold">Note:&nbsp;</td>
<td><%=ppm.getNote()==null?"":ppm.getNote()%></td>
<td colspan="2"/>
</tr>
<TR>
	<td colspan="4">
		&nbsp;&nbsp;<input type="button" class="button" name="Close" value="Close" onclick="self.close();">
	</td>
</TR>
</table>
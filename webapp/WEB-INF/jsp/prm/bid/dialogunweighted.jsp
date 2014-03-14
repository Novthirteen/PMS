<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.aof.component.prm.bid.BidMaster"%>
<%@ page import="com.aof.component.prm.bid.BidUnweightedValue"%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
NumberFormat Num_formater2 = NumberFormat.getInstance();
Num_formater2.setMaximumFractionDigits(5);
Num_formater2.setMinimumFractionDigits(2);

List unweightedList=(List)request.getAttribute("BidUnweightedValueList");
%>
<form name="EditForm" action="dialogBidMaster.do" method="post">
<input type="hidden"  name="yearAdd" value="">
<table border=0 width='100%' cellspacing='0' cellpadding='1'>
	<tr>
    	<td width='100%'>
      		<table width='100%' border='0' cellspacing='0' cellpadding='0'>
        		<tr>
          			<td align=left width='90%' class="wpsPortletTopTitle">&nbsp;&nbsp; Unweighted Value List</td>
        		</tr>
      		</table>
    	</td>
	</tr>
	<tr>
		<td width='100%'colspan=4>
			<table border=0 width='100%'>
				<tr bgcolor="#e9eee9">
				  	<td align="center" class="lblbold">year</td>
				  	<td align="center" class="lblbold">Amount (RMB)</td>
					<td align="center" class="lblbold">Action</td>
				</tr>
				<%
				if (unweightedList != null){
					Iterator tmpIt = unweightedList.iterator();
					while (tmpIt.hasNext()) {
						String year = "";
						double value = 0;
						BidUnweightedValue bv = (BidUnweightedValue)tmpIt.next();
						year = bv.getYear();
						value = bv.getValue().doubleValue();
				%>
  				<tr>
					<td align="center">
  						<input type="text" class="inputBox" style="text-align:center"  style="border:0px" readonly name="year" value="<%=year%>" size="20">
  					</td>
  					<td align="center">
  						<input type="text" class="inputBox" style="text-align:right" style="border:0px" readonly name="unweightedValue" value="<%=Num_formater.format(value)%>" size="20">
  					</td>
  					
  					<td align="center" colspan=2>
  					&nbsp;
  					</td>
  				</tr>
  				<%
  					}
  				} else {
  				%>
  				<tr><td>&nbsp;</td></tr>
  				<%
  				}
  				%>
  				<tr><td colspan=5 valign="bottom"><hr color="#B5D7D6"></hr></td></tr>
  			</table>
  		</td>
  	</tr>
</table>
</form>

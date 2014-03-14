<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.aof.component.prm.bid.BidMaster"%>
<%@ page import="com.aof.component.prm.bid.BMHistory"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<%
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");

BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
//Set bmhistoryList = (Set)bidMaster.getBmhistory();

List bmhistoryList = (List)request.getAttribute("bidmasterhistory");

//Set bmhistoryList = (Set)request.getAttribute("bidmasterhistory");

//if(bmhistoryList==null){
//	bmhistoryList = new HashSet();
//}
%>
<form name="EditForm" action="dialogBidMaster.do" method="post">
	<input type="hidden"  name="yearAdd" value="">
	<table border=0 width='100%' cellspacing='0' cellpadding='1'>
		<tr>
			<td align=left width='100%' class="wpsPortletTopTitle" colspan=8>Bid Master History</td>
		</tr>
		<tr>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="2%"># </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Modify Date </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Modify User </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Contract Start Date </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Contract End Date </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Contract Sign Date </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Status </td>
			<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Reason </td>
		</tr>
		<%
		if (bmhistoryList != null && bmhistoryList.size() > 0) {
			Iterator it = bmhistoryList.iterator();
			int v=1;
			while (it.hasNext()) {
				BMHistory bmh = (BMHistory) it.next();
		%>
		<tr>
			<td align ="center"><%=v%></td>
			<td align ="center"><%=formater.format(bmh.getModify_date())%></td>
			<td align ="center"><%=bmh.getUser_id().getName()%></td>
			<td align ="center"><%=formater.format(bmh.getCon_st_date())%></td>
			<td align ="center"><%=formater.format(bmh.getCon_ed_date())%></td>
			<td align ="center"><%=formater.format(bmh.getCon_sign_date())%></td>
			<td align ="center"><%=bmh.getStatus()%></td>
			<td align ="center"><%=bmh.getReason() == null ? "" : bmh.getReason()%></td>
		</tr>
		<%
				v++;
			}
			
		} else {
		%>
		<tr><td>&nbsp;</td></tr>
		<%
		}
		%>
	</table>
</form>
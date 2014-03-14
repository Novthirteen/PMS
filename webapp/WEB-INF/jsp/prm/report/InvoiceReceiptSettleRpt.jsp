<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%if (AOFSECURITY.hasEntityPermission("INV_RECP_SET", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat numFormat1 = NumberFormat.getInstance();
numFormat1.setMaximumFractionDigits(0);
numFormat1.setMinimumFractionDigits(0);
NumberFormat numFormat2 = NumberFormat.getInstance();
numFormat2.setMaximumFractionDigits(1);
numFormat2.setMinimumFractionDigits(1);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
String dateStart = request.getParameter("dateStart");
String dateEnd = request.getParameter("dateEnd");
String customer = request.getParameter("customer");
if (customer == null) customer = "";

if (dateStart==null) dateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
if (dateEnd==null) dateEnd=Date_formater.format(nowDate);

Date dayStart = UtilDateTime.toDate2(dateStart + " 00:00:00.000");
Date dayEnd = UtilDateTime.toDate2(dateEnd + " 00:00:00.000");
%>
<script language="javascript">
	function showCustomerDialog()
{
	var code,desc;
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.customer.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			document.getElementById("customer").value = v.split("|")[0];
		}
	}
}
function SearchResult() {
	var formObj = document.frm;
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> Invoice - Receipt Settlement Report </caption> 
<tr>
	<td>
		<Form action="pas.report.InvoiceReceiptSettleRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction">
		<table width=100%>
			<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Date Range :</td>
				<td class="lblLight">
					<input  type="text" class="inputBox" name="dateStart" size="12" value="<%=Date_formater.format(dayStart)%>"><A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.dateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
					~
					<input  type="text" class="inputBox" name="dateEnd" size="12" value="<%=Date_formater.format(dayEnd)%>"><A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.dateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
				</td>
				<td class="lblbold">Customer:</td>
						<td class="lblLight">
							<input type="text" class="inputBox" name="customer" size="12" value="<%=customer%>">
							<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
						</td>
				<td  align="left" colspan=2>
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult();return false">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel();return false">
				</td>
			</tr>
			
			<tr>
			</tr>
			
			<tr>
				<td colspan=6 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
		<tr bgcolor="#e9eee9">
		<td align=center class="lblbold" >&nbsp;Invoice Code &nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Bill To &nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Project &nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Invoice Date&nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Invoice Amount&nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Invoice Currency&nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Receipt No.&nbsp;</td>
		<td align=center class="lblbold" >&nbsp;FA Receipt No.&nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Receipt Customer&nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Receipt Amount&nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Receipt Currency&nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Receipt Date&nbsp;</td>
		<td align=center class="lblbold" >&nbsp;Settled Amount (RMB)&nbsp;</td>
		</tr>
	
			<%
			SQLResults sr = (SQLResults)request.getAttribute("InvoiceQryList");
			Object resultSet_data;
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				for (int row =0; row < sr.getRowCount(); row++) {
				%>
					<tr bgcolor="#e9eee1"> 
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"inv_code"))==null) ? "":resultSet_data)%></td>
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"description1"))==null) ? "":resultSet_data)%></td>
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"inv_proj_id"))==null) ? "":resultSet_data)%></td>
						<td  align="center"><%=Date_formater.format(sr.getDate(row, "inv_invoicedate"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"inv_amount"))%></td>
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"inv_curr_id"))==null) ? "":resultSet_data)%></td>
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"receipt_no"))==null) ? "":resultSet_data)%></td>
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"fa_receiptno"))==null) ? "":resultSet_data)%></td>
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"description"))==null) ? "":resultSet_data)%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"receipt_amt"))%></td>
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"currency"))==null) ? "":resultSet_data)%></td>
						<td  align="center"><%=Date_formater.format(sr.getDate(row, "receipt_date"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"receive_amount"))%></td>
						
						</tr>
				<%}
			}%>
		</table>
	</td>
</tr>
</table>

<%
}else{
	out.println("没有访问权限.");
}
%>
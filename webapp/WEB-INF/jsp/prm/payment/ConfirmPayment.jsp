<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.component.prm.payment.ProjPaymentTransaction"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%try{%>
<%if (AOFSECURITY.hasEntityPermission("MANDAY_ACTUAL_VS_BUDGET_REPORT", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<%
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat numFormat = NumberFormat.getInstance();
numFormat.setMaximumFractionDigits(2);
numFormat.setMinimumFractionDigits(2);

String project = request.getParameter("project");
String vendor = request.getParameter("customer");
String status = request.getParameter("status");
String invCode = request.getParameter("invCode");
String paymentCode = request.getParameter("paymentCode");
String dateStart = request.getParameter("dateStart");
String dateEnd = request.getParameter("dateEnd");

if(project==null){
	project = "";
}
if(vendor==null){
	vendor = "";
}
if(status==null){
	status = "Post";
}
if(invCode==null){
	invCode = "";
}
if(paymentCode==null){
	paymentCode = "";
}
if(dateStart==null){
	dateStart = "";
}
if(dateEnd==null){
	dateEnd = "";
}
%>
<script language="javascript">
function SearchResult() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "view";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	formObj.elements["formAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
function doPay(){
	with(document.frm){
		formAction.value="pay";
		submit();
	}
}
function doCancel(tran){
	with(document.frm){
		formAction.value="cancel";
		tranId.value=tran;
		submit();
	}
}
function showInvoiceDialog(invId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectPayment.InvoiceDetail.dialog.title&findPaymentInvoice.do?invId="+invId,
		                null,
		                'dialogWidth:650px;dialogHeight:300px;status:no;help:no;scroll:no');
}
function showInstructionDialog(paymentId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectPayment.InstructionDetail.dialog.title&findInstruction.do?paymentId="+paymentId,
		                null,
		                'dialogWidth:650px;dialogHeight:300px;status:no;help:no;scroll:no');
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<Form action="ConfirmPayment.do" name="frm" method="post">
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall">Payment Confirmation</caption> 
<tr>
	<td>
		<input type="hidden" name="formAction" id="formAction">
		<input type="hidden" name="tranId" id="tranId">
		<table width=100%>
			<tr>
				<td colspan=8 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Invoice Code:</td>
				<td class="lblLight"><input type="text" name="invCode" size="15" value="<%=invCode%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Payment Code:</td>
				<td class="lblLight"><input type="text" name="paymentCode" size="15" value="<%=paymentCode%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Pay Date Range:</td>
				<td class="lblLight">
					<input TYPE="text" maxlength="15" size="10" name="dateStart" value="<%=dateStart%>">
					<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.dateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
					~
					<input TYPE="text" maxlength="15" size="10" name="dateEnd" value="<%=dateEnd%>">
					<A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.dateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
				</td>
			</tr>
			<tr>
				<td class="lblbold">Project:</td>
				<td class="lblLight"><input type="text" name="project" size="15" value="<%=project%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Vendor:</td>
				<td class="lblLight"><input type="text" name="vendor" size="15" value="<%=vendor%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
	    		<td class="lblbold">Status:</td>
				<td class="lblLight">
					<select name="status">
						<option value="All" <%=status.equals("All")?"selected":""%>>All</option>
						<option value="Post" <%=status.equals("Post")?"selected":""%>>Post</option>
						<option value="Paid" <%=status.equals("Paid")?"selected":""%>>Paid</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="4"/>
				<td colspan="2" align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult()">&nbsp;
					<input type="button" class="button" value="Pay Selected" onclick="doPay();">&nbsp;
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
				</td>
			</tr>
			<tr>
				<td colspan=8 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr bgcolor="#e9eee9">
				<td align=center class="lblbold"><input type=checkbox class="checkboxstyle" name=chkAll value='' onclick="javascript:checkUncheckAllBox(document.frm.chkAll,document.frm.chk)"></td>
				<td align=center class="lblbold">&nbsp;Invoice Code&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Payment Code&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Project&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Contract&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Contract Type&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Vendor&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Pay Amount&nbsp;</td>				
				<td align=center class="lblbold">&nbsp;Currency&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Exchange Rate&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Status&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Post Date&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Pay Date&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Export Date&nbsp;</td>
				<td align=center class="lblbold">&nbsp;&nbsp;</td>
			</tr>
			<%
			SQLResults sr = (SQLResults)request.getAttribute("result");
			Object resultSet_data;
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='14' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				for (int row =0; row < sr.getRowCount(); row++) {
					//convert the contract type string for better understanding
					String c_type = "";
					if(sr.getString(row, "con_type")!=null){
						c_type = sr.getString(row, "con_type");
						if(c_type.equals("TM")){
							c_type = "Time & Material";
						}else{
							c_type = "Fixed Price";
						}
					}
				%>
					<tr bgcolor="#e9eee1">
						<td align="left">
							<%if(sr.getString(row, "status").equals("Post")){%>
								<input type=checkbox class="checkboxstyle" name=chk value="<%=sr.getLong(row, "tran_id")%>" onclick='javascript:checkTopBox(document.frm.chkAll,document.frm.chk)'>
							<%}%>
						</td>
						<TD align="left">
							<a href="javascript:void(0)" onclick="showInvoiceDialog('<%=sr.getString(row, "invoice_id")%>');event.returnValue=false;"><%=sr.getString(row, "invoice_id")!=null ? sr.getString(row, "invoice_id"):""%></a>
						</TD>
						<TD align="left">
							<a href="javascript:void(0)" onclick="showInstructionDialog(<%=sr.getLong(row, "payment_id")%>);event.returnValue=false;"><%=sr.getString(row, "invoice_id")!=null ? sr.getString(row, "payment_code"):""%></a>
						</TD>
						<TD align="left">
							<%=sr.getString(row, "proj_id")!=null ?(sr.getString(row, "proj_id")+":"+sr.getString(row, "proj_name")):""%>
						</TD>
						<TD align="left">
							<%=sr.getString(row, "contract_no")!=null ?sr.getString(row, "contract_no"):""%>
						</TD>
						<TD align="left">
							<%=c_type%>
						</TD>
						<TD align="left">
							<%=sr.getString(row, "vendor")%>
						</TD>
						<TD align="left">
							<%=numFormat.format(sr.getDouble(row, "pay_amount"))%>
						</TD>
						<TD align="left">
							<%=sr.getString(row, "curr_name")%>
						</TD>
						<TD align="left">
							<%=numFormat.format(sr.getDouble(row, "rate"))%>
						</TD>
						<TD align="left">
							<%=sr.getString(row, "status")%>
						</TD>
						<TD align="left">
							<%=sr.getDate(row, "post_date") != null ? format.format(sr.getDate(row, "post_date")) : ""%>
						</TD>	
						<TD align="left">
							<%=sr.getDate(row, "pay_date") != null ? format.format(sr.getDate(row, "pay_date")) : ""%>
						</TD>
						<TD align="left">
							<%=sr.getDate(row, "export_date") != null ? format.format(sr.getDate(row, "export_date")) : ""%>
						</TD>
						<TD align="left">
							<%if(sr.getString(row, "status").equals("Post")){%>
								<input type="button" value="Reject" onclick="doCancel('<%=sr.getLong(row, "tran_id")%>');">
							<%}%>
						</TD>
					</tr>
				<%}
			}%>
		</table>
	</td>
</tr>
</table>
</form>
<%
}else{
	out.println("没有访问权限.");
}
%>
<%}catch (Exception e){
			e.printStackTrace();
		}%>
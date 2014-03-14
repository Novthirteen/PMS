<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
if (AOFSECURITY.hasEntityPermission("PROJ_INVOICE", "_CREATE", session)) {
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	NumberFormat numFormat = NumberFormat.getInstance();
	numFormat.setMaximumFractionDigits(2);
	numFormat.setMinimumFractionDigits(2);
	
	String invoiceId = request.getParameter("invoiceId");
	ProjectInvoiceConfirmation pic = (ProjectInvoiceConfirmation)request.getAttribute("InvoiceConfirmation");
	List currencyList = (List)request.getAttribute("Currency");
%>
<HTML>
	<HEAD>
		<script language="javascript" type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunctions.js'></script>
		<script language="javascript" type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
		<script language="javascript" type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
		<script language="javascript" type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
		<SCRIPT language="javascript">
		<%
		if ("nextClose".equals(request.getParameter("nextClose"))) {
		%>
			window.parent.close();
		<%
		}
		%>
		function showStaff() {
			v = window.showModalDialog(
			"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
			
			if (v != null && v.length > 3) {
				document.getElementById("responsiblePerson").value=v.split("|")[0];	
				document.getElementById("labelBillResponsiblePerson").innerHTML=v.split("|")[1];
			}
		}
		function checkSubmit() {
			if (document.editForm.contactDate.value == "") {
				alert("Contact Date can not be ignored");
				return false;
			}
			
			if (document.editForm.contactor.value == "") {
				alert("Contact Person can not be ignored");
				return false;
			}
			
			if (document.editForm.responsiblePerson.value == "") {
				alert("Responsible Person can not be ignored");
				return false;
			}
			
			if (document.editForm.payAmount.value != "") {
				removeComma(document.editForm.payAmount);
			}
		}
		</script>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<form name="editForm" action="editInvoiceConfirm.do" method="post" onSubmit="return checkSubmit();">
			<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
				marginWidth=0 noResize 
				scrolling=no src="includes/date/calendar.htm" 
				style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
			</IFRAME>
			<table width=100% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Invoice Confirmation</CAPTION>
				<tr>
					<td>
						<input type="hidden" name="formAction" value="edit">
						<input type="hidden" name="invoiceId" value="<%=invoiceId%>">
						<input type="hidden" name="confirmId" value="<%= pic != null ? pic.getId() + "" : "" %>">
						<input type="hidden" name="nextClose" value="nextClose">

						<TABLE width="100%">
							<tr>
								<td width="100%" colspan=4><hr color=red></hr></td>
							</tr>
							<tr>
								<td class="lblbold" align=right width="15%">Contact Date:</td>
								<td class="lblLight" width="35%">
									<input  type="text" class="inputBox" name="contactDate" size="12" value="<%= pic != null ? dateFormat.format(pic.getContactDate()) : dateFormat.format(new Date()) %>"><A href="javascript:ShowCalendar(document.editForm.dimg1,document.editForm.contactDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align="absMiddle" border="0" id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
								</td>
								
								<td class="lblbold" align=right width="15%">Contact Person:</td>
								<td class="lblLight" width="35%">
									<input type="text" name="contactor" size="15" value="<%=pic != null ? pic.getContactor() : ""%>" style="TEXT-ALIGN: left" class="lbllgiht">
								</td>
							</tr>
							<tr>
								<td class="lblbold" align=right width="15%">Responsible Person:</td>
								<td class="lblLight" width="35%">
									<%
										UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
									%>
									<div style="display:inline" id="labelBillResponsiblePerson">
										<%=pic != null ? pic.getResponsiblePerson().getName() : ul.getName()%>
									</div>
									<input type="hidden" name="responsiblePerson" value="<%=pic != null ? pic.getResponsiblePerson().getUserLoginId() : ul.getUserLoginId()%>">
									<a href="javascript:showStaff()"><img align="absmiddle" alt="select" src="images/select.gif" border="0" /></a>
								</td>
								
								<td class="lblbold" align=right width="15%">Confirm Amount:</td>
								<td class="lblLight" width="35%">
									<input type="text" style="TEXT-ALIGN:right" name="payAmount" value="<%=pic != null ? numFormat.format(pic.getPayAmount()) : ""%>" size="15" onblur="checkDeciNumber2(this,1,2,'Amount',-9999999999,9999999999);addComma(this, '.', '.', ',');">									
								</td>
							</tr>
							<tr>
								<td class="lblbold" align=right width="15%">Currency:</td>
								<td class="lblLight" width="35%">
									<select name="currency">
									<%									
										for (int i0 = 0; currencyList != null && i0 < currencyList.size(); i0++) {
											CurrencyType curr = (CurrencyType)currencyList.get(i0);
											String isSelected = "";
											if (pic == null && curr.getCurrId().equals("RMB"))
												isSelected = "selected";
											if (pic != null && pic.getCurrency().getCurrId().equals(curr.getCurrId())) {
												isSelected = "selected";
											}
									%>
											<option value="<%=curr.getCurrId()%>" <%=isSelected%>><%=curr.getCurrName()%></option>
									<%
										}
									%>
									</select>
								</td>
								
								<td class="lblbold" align=right width="15%">Confirm Date:</td>
								<td class="lblLight" width="35%">
									<input  type="text" class="inputBox" name="payDate" size="12" value="<%= pic != null && pic.getPayDate() != null ? dateFormat.format(pic.getPayDate()) : "" %>"><A href="javascript:ShowCalendar(document.editForm.dimg2,document.editForm.payDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align="absMiddle" border="0" id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
								</td>
							</tr>
							
							<tr>
								<td class="lblbold" align=right width="15%">Create User:</td>
								<td class="lblLight" width="35%">
									<%=pic != null ? pic.getCreateUser().getName() : ""%>
								</td>
								<td class="lblbold" align=right width="15%">Create Date:</td>
								<td class="lblLight" width="35%">							
									<%=pic != null ? dateFormat.format(pic.getCreateDate()) : ""%>			
								</td>
							</tr>
							
							<tr>
								<td class="lblbold" align=right width="15%">Note:</td>
								<td class="lblLight" width="85%" colspan="3">
									<textarea name="note" cols="77" rows="3"><%=pic != null ? pic.getNote() : ""%></textarea>
								</td>
							</tr>
							<tr>
								<td colspan="4" align="left">
									<input type="submit" value="Save" name="save" class="button">
								</td>
							</tr>
							<tr>
								<td width="100%" colspan=4><hr color=red></hr></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception e) {
	e.printStackTrace();
}
%>

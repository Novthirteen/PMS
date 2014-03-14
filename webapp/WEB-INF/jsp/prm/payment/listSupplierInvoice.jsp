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
<%@ page import="org.apache.commons.logging.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<%
try{ 
long timeStart = System.currentTimeMillis();   //for performance test
if (AOFSECURITY.hasEntityPermission("SUPPLIER_INVOICE_MSTR", "_VIEW", session)) {
	String payCode = request.getParameter("payCode");
	String vendorId = request.getParameter("vendorId");
	String paidStatus = request.getParameter("paidStatus");
	String settledStatus = request.getParameter("settledStatus");
	String type = request.getParameter("type");
	String FormAction = request.getParameter("FormAction");
	
	UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	
	//List paymentList = (List)request.getAttribute("PaymentList");
	List partyList = (List)request.getAttribute("PartyList");
	
	String action = request.getParameter("action");
	
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	String dateStart = request.getParameter("dateStart");
	String dateEnd = request.getParameter("dateEnd");
	Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
	if (dateStart==null) dateStart=formatter.format(UtilDateTime.toDate(01,01,Calendar.getInstance().get(Calendar.YEAR),0,0,0));
	if (dateEnd==null) dateEnd=formatter.format(nowDate);
	
%>
<script language="javascript">
	function doEdit(DataId) {
		if (DataId != null) {
			document.editForm.DataId.value = DataId;			
		}
		//document.editForm.billCode.value = document.queryForm.billCode.value;
		//document.editForm.project.value = document.queryForm.project.value;
		//document.editForm.vendor.value = document.queryForm.vendor.value;
		//document.editForm.billTo.value = document.queryForm.billTo.value;
		//document.editForm.department.value = document.queryForm.department.options[document.queryForm.department.selectedIndex].value;
		//document.editForm.status.value = document.queryForm.status.value;
		document.editForm.submit();
	}
</script>
<table width=100% cellpadding="1" border="0" cellspacing="1">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
	<CAPTION align=center class=pgheadsmall>Supplier Invoice List</CAPTION>
	<tr>
		<td>
			<form name="listPaymentForm" action="listSupplierInvoice.do" method="post">
				<input type="hidden" name="FormAction" value="query">
				<TABLE width="100%">
					<tr>
						<td colspan=12><hr color=red></hr></td>
					</tr>
					
					<tr>
						<td class="lblbold">Supplier Invoice Code:</td>
						<td class="lblLight"><input type="text" name="payCode" size="15" value="<%=((payCode != null) && (FormAction.equals("query"))) ? payCode : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Vendor:</td>
						<td class="lblLight"><input type="text" name="vendorId" size="15" value="<%=((vendorId != null) && (FormAction.equals("query"))) ? vendorId : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Type:</td>
						<td class="lblLight">
							<select name="type">
								<option value="">Select All</option>
								<option value="Normal" <%=(("Normal".equals(type)) && (FormAction.equals("query"))) ? "selected" : ""%>>Normal</option>
								<option value="Credit" <%=(("Credit".equals(type)) && (FormAction.equals("query"))) ? "selected" : ""%>>Credit</option>
							</select>
						</td>			
					</tr>
					
					<tr>
						<td class="lblbold">Supplier Invoice Date:</td>
						<td class="lblLight">
							<input TYPE="text" maxlength="15" size="10" name="dateStart" value="<%=dateStart%>">
							<A href="javascript:ShowCalendar(document.listPaymentForm.dimg1,document.listPaymentForm.dateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
							~
							<input TYPE="text" maxlength="15" size="10" name="dateEnd" value="<%=dateEnd%>">
							<A href="javascript:ShowCalendar(document.listPaymentForm.dimg2,document.listPaymentForm.dateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
						</td>
						
						<td class="lblbold">Paid Status:</td>
						<td class="lblLight">
							<select name="paidStatus">
								<option value="">Select All</option>
								<option value="<%=Constants.SUPPLIER_INVOICE_PAY_STATUS_DRAFT%>" <%=((Constants.SUPPLIER_INVOICE_PAY_STATUS_DRAFT.equals(paidStatus)) && (FormAction.equals("query"))) ? "selected" : ""%>><%=Constants.SUPPLIER_INVOICE_PAY_STATUS_DRAFT%></option>
								<option value="<%=Constants.SUPPLIER_INVOICE_PAY_STATUS_WIP%>" <%=((Constants.SUPPLIER_INVOICE_PAY_STATUS_WIP.equals(paidStatus)) && (FormAction.equals("query"))) ? "selected" : ""%>><%=Constants.SUPPLIER_INVOICE_PAY_STATUS_WIP%></option>
								<option value="<%=Constants.SUPPLIER_INVOICE_PAY_STATUS_COMPLETED%>" <%=((Constants.SUPPLIER_INVOICE_PAY_STATUS_COMPLETED.equals(paidStatus)) && (FormAction.equals("query"))) ? "selected" : ""%>><%=Constants.SUPPLIER_INVOICE_PAY_STATUS_COMPLETED%></option>
							</select>
						</td>
						
						<td class="lblbold">Settled Status:</td>
						<td class="lblLight">
							<select name="settledStatus">
								<option value="">Select All</option>
								<option value="<%=Constants.SUPPLIER_INVOICE_SETTLE_STATUS_DRAFT%>" <%=((Constants.SUPPLIER_INVOICE_SETTLE_STATUS_DRAFT.equals(settledStatus)) && (FormAction.equals("query"))) ? "selected" : ""%>><%=Constants.SUPPLIER_INVOICE_SETTLE_STATUS_DRAFT%></option>
								<option value="<%=Constants.SUPPLIER_INVOICE_SETTLE_STATUS_WIP%>" <%=((Constants.SUPPLIER_INVOICE_SETTLE_STATUS_WIP.equals(settledStatus)) && (FormAction.equals("query"))) ? "selected" : ""%>><%=Constants.SUPPLIER_INVOICE_SETTLE_STATUS_WIP%></option>
								<option value="<%=Constants.SUPPLIER_INVOICE_SETTLE_STATUS_COMPLETED%>" <%=((Constants.SUPPLIER_INVOICE_SETTLE_STATUS_COMPLETED.equals(settledStatus)) && (FormAction.equals("query"))) ? "selected" : ""%>><%=Constants.SUPPLIER_INVOICE_SETTLE_STATUS_COMPLETED%></option>
							</select>
						</td>
			   		</tr>
				    <tr>
				        <td colspan=6/>
				    	<td colspan=4>
							<input type="submit" value="Query" class="button">
						    <input type="button" value="New" class="button" onclick="doEdit();">
						</td>
					</tr>
					<tr>
						<td colspan=12 valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
			<form name="editForm" action="editSupplierInvoice.do" method="post">
				<input type="hidden" name="FormAction" value="edit">
				<input type="hidden" name="DataId" value="">
			</form>
		</td>
	</tr>
</table>
<table width="100%">
<tr><td>
		<div width="100%">
		<display:table name="requestScope.PaymentList.rows" export="true" class="ITS" requestURI="listSupplierInvoice.do" pagesize="15">
			<display:column property="inv_code" title="Supplier Invoice Code" href="editSupplierInvoice.do?FormAction=edit" paramId="DataId" sortable="true"/>
			<display:column property="vendor_info" title="Vendor" />
			<display:column property="tot_amt" title="Total Invoice Amount" paramId="DataId" paramProperty="inv_code"/>
			<display:column property="currency" title="Currency" />
			<display:column property="rate" title="Exchange Rate" />	
			<display:column property="pay_date" title="Invoice Date" />
			<display:column property="settled_status" title="Settled Status" />
			<display:column property="settled_amount" title="Settled Amount (RMB)" />
			<display:column property="paid_status" title="Paid Status" />
			<display:column property="paid_amount" title="Paid Amount (RMB)"/>
			<display:column property="create_user" title="Create User" />	
			<display:column property="create_date" title="Create Date" />				
		</display:table>
		</div>
</td></tr>
</table>
	
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
long timeEnd = System.currentTimeMillis();       //for performance test
System.out.println(timeEnd-timeStart);
} catch(Exception e) {
	e.printStackTrace();
}
%>

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
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
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
if (AOFSECURITY.hasEntityPermission("RECEIPT_MSTR", "_VIEW", session)) {
	String receiptNo = request.getParameter("receiptNo");
	String customerId = request.getParameter("customerId");
	String status = request.getParameter("status");
	String FormAction = request.getParameter("FormAction");
	String type = request.getParameter("type");
	
	UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	
	//List receiptList = (List)request.getAttribute("ReceiptList");
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
		//document.editForm.customer.value = document.queryForm.customer.value;
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
	<CAPTION align=center class=pgheadsmall>Receipt List</CAPTION>
	<tr>
		<td>
			<form name="listReceiptForm" action="listReceipt.do" method="post">
				<input type="hidden" name="FormAction" id="FormAction" value="query">
				<TABLE width="100%">
					<tr>
						<td colspan=12><hr color=red></hr></td>
					</tr>
					
					<tr>
						<td class="lblbold">Receipt No.:</td>
						<td class="lblLight"><input type="text" name="receiptNo" id="receiptNo" size="15" value="<%=((receiptNo != null) && (FormAction.equals("query"))) ? receiptNo : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Customer:</td>
						<td class="lblLight"><input type="text" name="customerId" id="customerId" size="15" value="<%=((customerId != null) && (FormAction.equals("query"))) ? customerId : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Type:</td>
						<td class="lblLight">
							<select name="type">
								<option value="">Select All</option>
								<option value="Normal" <%=(("Normal".equals(type)) && (FormAction.equals("query"))) ? "selected" : ""%>>Normal</option>
								<option value="Lost" <%=(("Lost".equals(type)) && (FormAction.equals("query"))) ? "selected" : ""%>>Lost</option>
							</select>
						</td>								
					</tr>
					
					<tr>
						<td class="lblbold">Receipt Date:</td>
						<td class="lblLight">
							<input TYPE="text" maxlength="15" size="10" name="dateStart" value="<%=dateStart%>">
							<A href="javascript:ShowCalendar(document.listReceiptForm.dimg1,document.listReceiptForm.dateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
							~
							<input TYPE="text" maxlength="15" size="10" name="dateEnd" value="<%=dateEnd%>">
							<A href="javascript:ShowCalendar(document.listReceiptForm.dimg2,document.listReceiptForm.dateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
						</td>
						
						<td class="lblbold">Status:</td>
						<td class="lblLight">
							<select name="status">
								<option value="">Select All</option>
								<option value="<%=Constants.RECEIPT_STATUS_DRAFT%>" <%=((Constants.RECEIPT_STATUS_DRAFT.equals(status)) && (FormAction.equals("query"))) ? "selected" : ""%>><%=Constants.RECEIPT_STATUS_DRAFT%></option>
								<option value="<%=Constants.RECEIPT_STATUS_WIP%>" <%=((Constants.RECEIPT_STATUS_WIP.equals(status)) && (FormAction.equals("query"))) ? "selected" : ""%>><%=Constants.RECEIPT_STATUS_WIP%></option>
								<option value="<%=Constants.RECEIPT_STATUS_COMPLETED%>" <%=((Constants.RECEIPT_STATUS_COMPLETED.equals(status)) && (FormAction.equals("query"))) ? "selected" : ""%>><%=Constants.RECEIPT_STATUS_COMPLETED%></option>
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
			<form name="editForm" action="editReceipt.do" method="post">
				<input type="hidden" name="FormAction" id="FormAction" value="edit">
				<input type="hidden" name="DataId" id="DataId" value="">
			</form>
		</td>
	</tr>
</table>
<table width="100%">
<tr><td>
		<div width="100%">
		<display:table name="requestScope.ReceiptList.rows" export="true" class="ITS" requestURI="listReceipt.do" pagesize="15">
			<display:column property="rec_no" title="Receipt No." href="editReceipt.do?FormAction=edit" paramId="DataId" sortable="true"/>
			<display:column property="rec_amt" title="Receipt Amount" href="editReceipt.do?FormAction=view" paramId="DataId" paramProperty="rec_no"/>
			<display:column property="remain_amt" title="Remaining Amout (RMB)" />
			<display:column property="currency" title="Currency" />
			<display:column property="rate" title="Exchange Rate" />	
			<display:column property="create_user" title="Create User" />		
			<display:column property="cust_name" title="Customer" />
			<display:column property="status" title="Status" />
			<display:column property="rec_date" title="Receipt Date" />
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

} catch(Exception e) {
	e.printStackTrace();
}
%>

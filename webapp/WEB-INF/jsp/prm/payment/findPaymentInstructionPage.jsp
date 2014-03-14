<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.payment.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
if (AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT", "_VIEW", session)) {
	String payCode = request.getParameter("payCode");
	String project = request.getParameter("project");
	String vendor = request.getParameter("payTo");
	String department = request.getParameter("department");
	String status = request.getParameter("status");
	
	SQLResults sqlResult = (SQLResults)request.getAttribute("QueryList");
	List partyList = (List)request.getAttribute("PartyList");
	
	String action = request.getParameter("action");
	
	String offSetStr = request.getParameter("offSet");
	int offSet = 0;
	if (offSetStr != null && offSetStr.trim().length() != 0) {
		offSet = Integer.parseInt(offSetStr);
	}
	
	final int recordPerPage = 10;
%>
<script language="javascript">

	function doQuery() {
		document.queryForm.offSet.value = "0";
		document.queryForm.action.value = "query"
		document.queryForm.submit();
	}

	function turnPage(offSet) {
		document.queryForm.offSet.value = offSet;
		document.queryForm.submit();
	}
	
	function doExport() {
		document.queryForm.action.value = "export"
		document.queryForm.submit();
	}
	
	function doEdit(payId) {
		if (payId != null) {
			document.editForm.payId.value = payId;

		}
		document.editForm.payCode.value = document.queryForm.payCode.value;
		document.editForm.project.value = document.queryForm.project.value;
		document.editForm.vendor.value = document.queryForm.payTo.value;
		document.editForm.department.value = document.queryForm.department.options[document.queryForm.department.selectedIndex].value;
		document.editForm.status.value = document.queryForm.status.value;

		document.editForm.submit();
	}
	function showCheckBillingDialog(projectId) {
		window.showModalDialog("system.showDialog.do?title=prm.projectPayment.showcheckbilling.dialog.title&findCheckBilling.do?pid="+projectId,
			                null,
			                'dialogWidth:650px;dialogHeight:300px;status:no;help:no;scroll:no');
	}
</script>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<CAPTION align=center class=pgheadsmall>Payment Instruction List</CAPTION>
	<tr>
		<td>
			<form name="queryForm" action="FindPaymentInstruction.do" method="post">
				<input type="hidden" name="action" value="query">
				<input type="hidden" name="payId" value="">
				<input type="hidden" name="offSet" value="0">
				<TABLE width="100%">
					<tr>
						<td colspan=12><hr color=red></hr></td>
					</tr>
					
					<tr>
						<td class="lblbold">Payment Code:</td>
						<td class="lblLight"><input type="text" name="payCode" size="15" value="<%=payCode != null ? payCode : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Project:</td>
						<td class="lblLight"><input type="text" name="project" size="15" value="<%=project != null ? project : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Supplier:</td>
						<td class="lblLight"><input type="text" name="payTo" size="15" value="<%=vendor != null ? vendor : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Status:</td>
						<td class="lblLight">
							<select name="status">
								<option value="">Select All</option>
								<option value="<%=Constants.PAYMENT_STATUS_DRAFT%>" <%=Constants.PAYMENT_STATUS_DRAFT.equals(status) ? "selected" : ""%>><%=Constants.PAYMENT_STATUS_DRAFT%></option>
								<option value="<%=Constants.PAYMENT_STATUS_WIP%>" <%=Constants.PAYMENT_STATUS_WIP.equals(status) ? "selected" : ""%>><%=Constants.PAYMENT_STATUS_WIP%></option>
								<option value="<%=Constants.PAYMENT_STATUS_COMPLETED%>" <%=Constants.PAYMENT_STATUS_COMPLETED.equals(status) ? "selected" : ""%>><%=Constants.PAYMENT_STATUS_COMPLETED%></option>
							</select>
						<td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="department">
								
							<%
							if (AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT", "_ALL", session)) {
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if (p.getPartyId().equals(department)) {
							%>
									<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%
									} else{
							%>
									<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%
									}
								}
							}
							%>
							</select>
						</td>
			   		</tr>
				    <tr>
				        <td colspan=8 />
				    	<td colspan=3 align="center">
							<input type="button" value="Query" class="button" onclick="doQuery();">
						    <input type="button" value="New" class="button" onclick="doEdit();">
						    <input type="button" value="Export To Excel" class="button" onclick="doExport();">
						</td>
					</tr>
					<tr>
						<td colspan=12 valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
			<form name="editForm" action="EditPaymentInstruction.do" method="post">
				<input type="hidden" name="action" value="view">
				<input type="hidden" name="payId" value="">
				<input type="hidden" name="payCode" value="">
				<input type="hidden" name="project" value="">
				<input type="hidden" name="vendor" value="">
				<input type="hidden" name="department" value="">
				<input type="hidden" name="status" value="">
			</form>
		</td>
	</tr>
</table>
	
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
 	<TR bgcolor="#e9eee9">
	  	<td class="lblbold">#&nbsp;</td>
	  	<td align="center" class="lblbold">Payment Code</td>
	    <td align="center" class="lblbold">Project</td>
		<td align="center" class="lblbold">Contract No.</td>
		<td align="center" class="lblbold">Contract Type</td>
	    <td align="center" class="lblbold">Project Manager</td>
		<td align="center" class="lblbold">Payment Address</td>
	    <td align="center" class="lblbold">Department</td>
	    <td align="center" class="lblbold">CAF Amount (RMB)</td>
	    <td align="center" class="lblbold">Acceptance Amount (RMB)</td>
	    <td align="center" class="lblbold">Credit-Down-Payment Amount (RMB)</td>
	    <td align="center" class="lblbold">Total Amount (RMB)</td>
	    <td align="center" class="lblbold">Settled Amount (RMB)</td>
	    <td align="center" class="lblbold">Remaining Amount (RMB)</td>
	    <td align="center" class="lblbold">Status</td>
	    <td align="center" class="lblbold">Create Date</td>
  	</tr>
  	
 	<%
 		DateFormat dateFormater = new SimpleDateFormat("yyyy/MM/dd");
 		NumberFormat formater = NumberFormat.getInstance();
		formater.setMaximumFractionDigits(2);
		formater.setMinimumFractionDigits(2);

		if(sqlResult != null && sqlResult.getRowCount() > 0){
			for (int row = offSet; row < sqlResult.getRowCount() && row < offSet + recordPerPage; row++) {
 	%>
 	<tr bgcolor="#e9eee9">  
    	<td align="center"><%=row + 1%></td>
    	<td align="left"> 
			<a href="#" onclick="doEdit('<%=sqlResult.getLong(row, "pay_id")%>');"><%=sqlResult.getString(row, "pay_code")%></a> 
    	</td>
    	<td align="left">                 
       		<a href="javascript:void(0)" onclick="showCheckBillingDialog('<%=sqlResult.getString(row, "proj_id")%>');event.returnValue=false;"><%=sqlResult.getString(row, "proj_id")%>:<%=sqlResult.getString(row, "proj_name")%></a>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "proj_contract_no")%>
        </td>
        
        <td align="left">                 
           <%if(sqlResult.getString(row, "contracttype").equals("FP")) out.print("Fixed Price"); else out.print("Time & Material");%>
        </td>
        
        <td align="left">                 
           <%=sqlResult.getString(row, "pmName")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "payAddr")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "department")%>
        </td>
        <td align="right">                 
           <%=formater.format(sqlResult.getDouble(row, "cafAmount"))%>
        </td>
        <td align="right">                 
           <%=formater.format(sqlResult.getDouble(row, "acceptanceAmount"))%>
        </td>
        <td align="right">                 
           <%=formater.format(sqlResult.getDouble(row, "creditDownPayAmount"))%>
        </td>
        <td align="right">     
           <%=formater.format(sqlResult.getDouble(row, "pay_calamount"))%>
        </td>
        <td align="right">     
           <%=formater.format(sqlResult.getDouble(row, "settledAmount"))%>
        </td>
        <td align="right">     
           <%=formater.format(sqlResult.getDouble(row, "pay_calamount") - sqlResult.getDouble(row, "settledAmount"))%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "pay_status")%>
        </td>
        <td align="center">                 
           <%=dateFormater.format(sqlResult.getDate(row, "pay_createDate"))%>
        </td>
    </tr>
 	<%
			}
	%>
	<tr>
		<td width="100%" colspan="16" align="right" class=lblbold>Pages&nbsp;:&nbsp;
			<%
			int recordSize = sqlResult.getRowCount();
			for (int j0 = 0; j0 < Math.ceil((double)recordSize / recordPerPage); j0++) {
				if (j0 == offSet / recordPerPage) {
			%>
			&nbsp;<font size="3"><%=j0 + 1%></font>&nbsp;
			<%
				} else {
			%>
			&nbsp;<a href="javascript:turnPage('<%=j0 * recordPerPage%>')" title="Click here to view next set of records"><%=j0 + 1%></a>&nbsp;
			<%
				}
			}
			%>
		</td>
	</tr>
	<%
		} else {
 	%>
 	<tr bgcolor="#e9eee9">
    	<td align="center" class="lblerr" colspan="16">
    		No Record Found.
    	</td>
    </tr>
 	<%
 		}
 	%>
</table>
<%
}else{
	out.println("!!��û����ط���Ȩ��!!");
}
} catch(Exception e) {
	e.printStackTrace();
}
%>

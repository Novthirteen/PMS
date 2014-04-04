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
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
Log log = LogFactory.getLog("findBillPendingList.jsp");
try{ 
long timeStart = System.currentTimeMillis();   //for performance test
if (AOFSECURITY.hasEntityPermission("PROJECT_DOWNPAYMENT", "_VIEW", session)) {
	String billCode = request.getParameter("billCode");
	String project = request.getParameter("project");
	String customer = request.getParameter("customer");
	String billTo = request.getParameter("billTo");
	String department = request.getParameter("department");
	String status = request.getParameter("status");
	
	if (department == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			department = userLogin.getParty().getPartyId();
		}
	}
	
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
	function turnPage(offSet) {
		document.queryForm.offSet.value = offSet;
		document.queryForm.submit();
	}
	
	function doEdit(billId) {
		if (billId != null) {
			document.editForm.billId.value = billId;
		}
		document.editForm.billCode.value = document.queryForm.billCode.value;
		document.editForm.project.value = document.queryForm.project.value;
		document.editForm.customer.value = document.queryForm.customer.value;
		document.editForm.billTo.value = document.queryForm.billTo.value;
		document.editForm.department.value = document.queryForm.department.options[document.queryForm.department.selectedIndex].value;
		document.editForm.status.value = document.queryForm.status.value;
		
		document.editForm.submit();
	}
</script>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<CAPTION align=center class=pgheadsmall>Down-Payment Instruction List</CAPTION>
	<tr>
		<td>
			<form name="queryForm" action="FindDownpaymentInstruction.do" method="post">
				<input type="hidden" name="action" id="action" value="query">
				<input type="hidden" name="billId" id="billId" value="">
				<input type="hidden" name="offSet" id="offSet" value="0">
				<TABLE width="100%">
					<tr>
						<td colspan=12><hr color=red></hr></td>
					</tr>
					
					<tr>
						<td class="lblbold">Bill Code:</td>
						<td class="lblLight"><input type="text" name="billCode" id="billCode" size="15" value="<%=billCode != null ? billCode : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Project:</td>
						<td class="lblLight"><input type="text" name="project" id="project" size="15" value="<%=project != null ? project : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Customer:</td>
						<td class="lblLight"><input type="text" name="customer" id="customer" size="15" value="<%=customer != null ? customer : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Bill To:</td>
						<td class="lblLight"><input type="text" name="billTo" id="billTo" size="15" value="<%=billTo != null ? billTo : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
					</tr>
					
					<tr>
						<td class="lblbold">Status:</td>
						<td class="lblLight">
							<select name="status">
								<option value="">Select All</option>
								<option value="<%=Constants.BILLING_STATUS_DRAFT%>" <%=Constants.BILLING_STATUS_DRAFT.equals(status) ? "selected" : ""%>><%=Constants.BILLING_STATUS_DRAFT%></option>
								<option value="<%=Constants.BILLING_STATUS_WIP%>" <%=Constants.BILLING_STATUS_WIP.equals(status) ? "selected" : ""%>><%=Constants.BILLING_STATUS_WIP%></option>
								<option value="<%=Constants.BILLING_STATUS_COMPLETED%>" <%=Constants.BILLING_STATUS_COMPLETED.equals(status) ? "selected" : ""%>><%=Constants.BILLING_STATUS_COMPLETED%></option>
							</select>
						</td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="department">
							<%
							if (AOFSECURITY.hasEntityPermission("PROJECT_DOWNPAYMENT", "_ALL", session)) {
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
				        <td colspan=6/>
				    	<td colspan=2 align="center">
							<input type="submit" value="Query" class="button">
						    <input type="button" value="New" class="button" onclick="doEdit();">
						</td>
					</tr>
					<tr>
						<td colspan=12 valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
			<form name="editForm" action="EditDownpaymentInstruction.do" method="post">
				<input type="hidden" name="formAction" id="formAction" value="view">
				<input type="hidden" name="billId" id="billId" value="">
				<input type="hidden" name="billCode" id="billCode" value="">
				<input type="hidden" name="project" id="project" value="">
				<input type="hidden" name="customer" id="customer" value="">
				<input type="hidden" name="billTo" id="billTo" value="">
				<input type="hidden" name="department" id="department" value="">
				<input type="hidden" name="status" id="status" value="">
			</form>
		</td>
	</tr>
</table>
	
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
 	<TR bgcolor="#e9eee9">
	  	<td class="lblbold">#&nbsp;</td>
	  	<td align="center" class="lblbold">Bill Code</td>
	    <td align="center" class="lblbold">Project</td>
		<td align="center" class="lblbold">Contract No.</td>
		<td align="center" class="lblbold">Contract Type</td>
	    <td align="center" class="lblbold">Project Manager</td>
		<td align="center" class="lblbold">Bill Address</td>
	    <td align="center" class="lblbold">Department</td>
	    <td align="center" class="lblbold">Down-Payment Amount (RMB)</td>
	    <td align="center" class="lblbold">Credit-Down-Payment Amount (RMB)</td>
	    <td align="center" class="lblbold">Remaining Amount (RMB)</td>
	    <td align="center" class="lblbold">Status</td>
	    <td align="center" class="lblbold">Create Date</td>
  	</tr>
  	
 	<%
 		DateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
 		NumberFormat formater = NumberFormat.getInstance();
		formater.setMaximumFractionDigits(2);
		formater.setMinimumFractionDigits(2);

		if(sqlResult != null && sqlResult.getRowCount() > 0){
			for (int row = offSet; row < sqlResult.getRowCount() && row < offSet + recordPerPage; row++) {
 	%>
 	<tr bgcolor="#e9eee9">  
    	<td align="center"><%=row + 1%></td>
    	<td align="left">
			<a href="#" onclick="doEdit('<%=sqlResult.getLong(row, "bill_id")%>');"><%=sqlResult.getString(row, "bill_code")%></a> 
    	</td>
    	<td align="left">                 
       		<%=sqlResult.getString(row, "proj_id")%>:<%=sqlResult.getString(row, "proj_name")%>
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
           <%=sqlResult.getString(row, "billAddr")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "department")%>
        </td>
        <td align="right">
          <%=formater.format(sqlResult.getDouble(row, "bill_calamount"))%>
        </td>
        <td align="right">   
          <%=formater.format(sqlResult.getDouble(row, "creditDownPayAmount"))%>
        </td>
        <td align="right">   
          <%=formater.format(sqlResult.getDouble(row, "bill_calamount") - sqlResult.getDouble(row, "invoicedAmount"))%>
        </td>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "bill_status")%>
        </td>
        <td align="center">                 
           <%=dateFormater.format(sqlResult.getDate(row, "bill_createDate"))%>
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
	out.println("!!你没有相关访问权限!!");
}
long timeEnd = System.currentTimeMillis();       //for performance test
log.info("it takes " + (timeEnd - timeStart) + " ms to dispaly...");
} catch(Exception e) {
	e.printStackTrace();
} finally {
	Hibernate2Session.closeSession();
}
%>

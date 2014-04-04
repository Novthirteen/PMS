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
Log log = LogFactory.getLog("showBillingDialog.jsp");
try {
long timeStart = System.currentTimeMillis();   //for performance test
if (AOFSECURITY.hasEntityPermission("PROJECT_BILLING", "_VIEW", session)) {
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
<HTML>
	<HEAD>
		<script language="javascript">
			function turnPage(offSet) {
				document.queryForm.offSet.value = offSet;
				document.queryForm.submit();
			}
			
			function showDetail(billId, billType) {
				if (billType == "<%=Constants.BILLING_TYPE_NORMAL%>") {
					v = window.showModalDialog(
					"system.showDialog.do?title=prm.projectInvoice.billing.dialog.title&EditBillingInstruction.do?action=dialogView&billId=" + billId,
						null,
					'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
				} else {
					v = window.showModalDialog(
					"system.showDialog.do?title=prm.projectInvoice.billing.dialog.title&EditDownpaymentInstruction.do?formAction=dialogView&billId=" + billId,
						null,
					'dialogWidth:600px;dialogHeight:400px;status:no;help:no;scroll:auto');
				}
			}
			
			function chooseBilling() {
				var radbills = document.getElementsByName("radBill");
				var billCode = document.getElementsByName("hiBillCode");
				var projId = document.getElementsByName("projId");
				var projName = document.getElementsByName("projName");
				var billAddrId = document.getElementsByName("billAddrId");
				var billAddrNm = document.getElementsByName("billAddrNm");
				var remainingAmount = document.getElementsByName("remainingAmount");
				var contractType = document.getElementsByName("contractType");
				var depId = document.getElementsByName("depId");
				var depNm = document.getElementsByName("depNm");
				var pmId = document.getElementsByName("pmId");
				var pmNm = document.getElementsByName("pmNm");
				
				for (var i = 0; i < radbills.length; i++) {
					if (radbills[i].checked) {
						window.parent.returnValue = radbills[i].value 
						             + "$" + billCode[i].value 
						             + "$" + projId[i].value 
						             + "$" + projName[i].value 
						             + "$" + billAddrId[i].value 
						             + "$" + billAddrNm[i].value
						             + "$" + remainingAmount[i].value
						             + "$" + contractType[i].value 
						             + "$" + depId[i].value 
						             + "$" + depNm[i].value 
						             + "$" + pmId[i].value 
						             + "$" + pmNm[i].value;
						break;
					}
				}
				
				window.parent.close();
			}
		</script>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<table width=100% cellpadding="1" border="0" cellspacing="1">
			<CAPTION align=center class=pgheadsmall>Billing Instruction List</CAPTION>
			<tr>
				<td>
					<form name="queryForm" action="FindBillingInstruction.do" method="post">
						<input type="hidden" name="action" id="action" value="showDialog">
						<input type="hidden" name="offSet" id="offSet" value="0">
						<TABLE width="100%">
							<tr>
								<td colspan=8><hr color=red></hr></td>
							</tr>
							
							<tr>
								<td class="lblbold">Bill Code:</td>
								<td class="lblLight"><input type="text" name="billCode" id="billCode" size="15" value="<%=billCode != null ? billCode : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
								<td class="lblbold">Project:</td>
								<td class="lblLight"><input type="text" name="project" id="project" size="15" value="<%=project != null ? project : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
								<td class="lblbold">Customer:</td>
								<td class="lblLight"><input type="text" name="customer" id="customer" size="15" value="<%=customer != null ? customer : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
							</tr>
							
							<tr>
								<td class="lblbold">Bill To:</td>
								<td class="lblLight"><input type="text" name="billTo" id="billTo" size="15" value="<%=billTo != null ? billTo : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
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
									if (AOFSECURITY.hasEntityPermission("PROJECT_BILLING", "_ALL", session)
									|| AOFSECURITY.hasEntityPermission("PROJECT_DOWNPAYMENT", "_ALL", session)) {
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
						    	<td>
									<input type="submit" value="Query" class="button">
								</td>
							</tr>
							<tr>
								<td colspan=8 valign="top"><hr color=red></hr></td>
							</tr>
						</table>
					</form>
					<form name="editForm" action="EditBillingInstruction.do" method="post" target="BillingDetail">
						<input type="hidden" name="action" id="action" value="view">
						<input type="hidden" name="billId" id="billId" value="">
					</form>
				</td>
			</tr>
		</table>
			
		<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
		 	<TR bgcolor="#e9eee9">		 		
			  	<td align="center">#&nbsp;</td>
			  	<td align="center" class="lblbold">Bill Code</td>
			    <td align="center" class="lblbold">Project</td>
				<td align="center" class="lblbold">Bill To</td>
			    <td align="center" class="lblbold">Department</td>
			    <td align="center" class="lblbold">Total Amount (RMB)</td>
			    <td align="center" class="lblbold">Remaining Amount (RMB)</td>
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
		    	<td align="center">
		    		<input type="radio" name="radBill" value="<%=sqlResult.getLong(row, "bill_id")%>">
				</td>
		    	<td align="left"> 
					<a href="#" onclick="showDetail('<%=sqlResult.getLong(row, "bill_id")%>', '<%=sqlResult.getString(row, "bill_type")%>');"><%=sqlResult.getString(row, "bill_code")%></a> 
					<input type="hidden" name="hiBillCode" id="hiBillCode" value="<%=sqlResult.getString(row, "bill_code")%>">
		    	</td>
		    	<td align="left">                 
		       		<%=sqlResult.getString(row, "proj_id")%>:<%=sqlResult.getString(row, "proj_name")%>
		       		<input type="hidden" name="projId" id="projId" value="<%=sqlResult.getString(row, "proj_id")%>">
		       		<input type="hidden" name="projName" id="projName" value="<%=sqlResult.getString(row, "proj_name")%>">
		       		<input type="hidden" name="contractType" id="contractType" value="<%=sqlResult.getString(row, "contracttype")%>">
		       		<input type="hidden" name="depId" id="depId" value="<%=sqlResult.getString(row, "departmentId")%>">
		       		<input type="hidden" name="depNm" id="depNm" value="<%=sqlResult.getString(row, "department")%>">
		       		<input type="hidden" name="pmId" id="pmId" value="<%=sqlResult.getString(row, "pmId")%>">
		       		<input type="hidden" name="pmNm" id="pmNm" value="<%=sqlResult.getString(row, "pmName")%>">
		        </td>
		        <td align="left">                 
		           <%=sqlResult.getString(row, "billAddr")%>
		           <input type="hidden" name="billAddrId" id="billAddrId" value="<%=sqlResult.getString(row, "billAddrId")%>">
		       	   <input type="hidden" name="billAddrNm" id="billAddrNm" value="<%=sqlResult.getString(row, "billAddr")%>">
		        </td>
		        <td align="left">                 
		           <%=sqlResult.getString(row, "department")%>
		        </td>
		        <td align="right">                 
		           <%=formater.format(sqlResult.getDouble(row, "bill_calamount"))%>
		        </td>
		        <td align="right">                 
		           <%=formater.format(sqlResult.getDouble(row, "bill_calamount") - sqlResult.getDouble(row, "invoicedAmount"))%>
		           <input type="hidden" name="remainingAmount" id="remainingAmount" value="<%=formater.format(sqlResult.getDouble(row, "bill_calamount") - sqlResult.getDouble(row, "invoicedAmount"))%>">
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
		    	<td align="center" class="lblerr" colspan="8">
		    		No Record Found.
		    	</td>
		    </tr>
		 	<%
		 		}
		 	%>
		 	<TR>		 		
			  	<td align="left" colspan="8">
			  		&nbsp;<input type="button" class="button" name="OK" value="OK" onclick="chooseBilling();">
			  		&nbsp;<input type="button" class="button" name="Cancel" value="Cancel" onclick="if (confirm("Do you want to cancel?")) {self.close();}">
			  	</td>
		  	</tr>
		</table>
	</body>
</html>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
long timeEnd = System.currentTimeMillis();       //for performance test
log.info("it takes " + (timeEnd - timeStart) + " ms to dispaly...");
} catch(Exception e) {
	e.printStackTrace();
}
%>

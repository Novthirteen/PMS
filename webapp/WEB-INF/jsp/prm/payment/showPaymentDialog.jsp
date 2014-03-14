<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.payment.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
if (AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT", "_VIEW", session)) {
	String payCode = request.getParameter("payCode");
	String project = request.getParameter("project");
	String vendor = request.getParameter("vendor");
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
<HTML>
	<HEAD>
		<script language="javascript">
			function turnPage(offSet) {
				document.queryForm.offSet.value = offSet;
				document.queryForm.submit();
			}
			
			function showDetail(payId, payType) {
				if (payType == "<%=Constants.PAYMENT_TYPE_NORMAL%>") {
					v = window.showModalDialog(
					"system.showDialog.do?title=prm.projectPayment.payment.dialog.title&EditPaymentInstruction.do?action=dialogView&payId=" + payId,
						null,
					'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
				} else {
					v = window.showModalDialog(
					"system.showDialog.do?title=prm.projectPayment.payment.dialog.title&EditPaymentDownpaymentInstruction.do?formAction=dialogView&payId=" + payId,
						null,
					'dialogWidth:600px;dialogHeight:300px;status:no;help:no;scroll:auto');
				}
			}
			
			function choosePayment() {
				var radpays = document.getElementsByName("radPay");
				var payCode = document.getElementsByName("hiPayCode");
				var projId = document.getElementsByName("projId");
				var projName = document.getElementsByName("projName");
				var payAddrId = document.getElementsByName("payAddrId");
				var payAddrNm = document.getElementsByName("payAddrNm");
				var remainingAmount = document.getElementsByName("remainingAmount");
				var contractType = document.getElementsByName("contractType");
				var depId = document.getElementsByName("depId");
				var depNm = document.getElementsByName("depNm");
				var pmId = document.getElementsByName("pmId");
				var pmNm = document.getElementsByName("pmNm");
				
				for (var i = 0; i < radpays.length; i++) {
					if (radpays[i].checked) {
						window.returnValue = radpays[i].value 
						             + "$" + payCode[i].value 
						             + "$" + projId[i].value 
						             + "$" + projName[i].value 
						             + "$" + payAddrId[i].value 
						             + "$" + payAddrNm[i].value
						             + "$" + remainingAmount[i].value
						             + "$" + contractType[i].value 
						             + "$" + depId[i].value 
						             + "$" + depNm[i].value 
						             + "$" + pmId[i].value 
						             + "$" + pmNm[i].value;
						break;
					}
				}
				
				self.close();
			}
		</script>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<table width=100% cellpadding="1" border="0" cellspacing="1">
			<CAPTION align=center class=pgheadsmall>Payment Instruction List</CAPTION>
			<tr>
				<td>
					<form name="queryForm" action="FindPaymentInstruction.do" method="post">
						<input type="hidden" name="action" value="showDialog">
						<input type="hidden" name="offSet" value="0">
						<TABLE width="100%">
							<tr>
								<td colspan=8><hr color=red></hr></td>
							</tr>
							
							<tr>
								<td class="lblbold">Payment Code:</td>
								<td class="lblLight"><input type="text" name="payCode" size="15" value="<%=payCode != null ? payCode : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
								<td class="lblbold">Project:</td>
								<td class="lblLight"><input type="text" name="project" size="15" value="<%=project != null ? project : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
								<td class="lblbold">Supplier:</td>
								<td class="lblLight"><input type="text" name="vendor" size="15" value="<%=vendor != null ? vendor : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
							</tr>
							
							<tr>
								<td class="lblbold">Status:</td>
								<td class="lblLight">
									<select name="status">
										<option value="">Select All</option>
										<option value="<%=Constants.PAYMENT_STATUS_DRAFT%>" <%=Constants.PAYMENT_STATUS_DRAFT.equals(status) ? "selected" : ""%>><%=Constants.PAYMENT_STATUS_DRAFT%></option>
										<option value="<%=Constants.PAYMENT_STATUS_WIP%>" <%=Constants.PAYMENT_STATUS_WIP.equals(status) ? "selected" : ""%>><%=Constants.PAYMENT_STATUS_WIP%></option>										
									</select>
								<td>
								<td class="lblbold">Department:</td>
								<td class="lblLight">
									<select name="department">
									<%
									if (AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT", "_ALL", session)
									|| AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT_DOWNPAYMENT", "_ALL", session)) {
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
					<form name="editForm" action="EditPaymentInstruction.do" method="post" target="PaymentDetail">
						<input type="hidden" name="action" value="view">
						<input type="hidden" name="payId" value="">
					</form>
				</td>
			</tr>
		</table>
			
		<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
		 	<TR bgcolor="#e9eee9">		 		
			  	<td align="center">#&nbsp;</td>
			  	<td align="center" class="lblbold">Payment Code</td>
			    <td align="center" class="lblbold">Project</td>
				<td align="center" class="lblbold">Supplier</td>
			    <td align="center" class="lblbold">Department</td>
			    <td align="center" class="lblbold">Total Amount (RMB)</td>
			    <td align="center" class="lblbold">Remaining Amount (RMB)</td>
			    <td align="center" class="lblbold">Status</td>
			    <td align="center" class="lblbold">Create Date</td>
		  	</tr>
		  	
		 	<%
		 		DateFormat dateFormater = new SimpleDateFormat("yyyy/MM/dd");
		 		NumberFormat formater = NumberFormat.getInstance();
				formater.setMaximumFractionDigits(2);
				formater.setMinimumFractionDigits(2);

				if (sqlResult != null && sqlResult.getRowCount() > 0) {
			 		for (int row = offSet; row < sqlResult.getRowCount() && row < offSet + recordPerPage; row++) {
		 	%>
		 	<tr bgcolor="#e9eee9">
		    	<td align="center">
		    		<input type="radio" name="radPay" value="<%=sqlResult.getLong(row, "pay_id")%>">
				</td>
		    	<td align="left"> 
					<a href="#" onclick="showDetail('<%=sqlResult.getLong(row, "pay_id")%>', '<%=sqlResult.getString(row, "pay_type")%>');"><%=sqlResult.getString(row, "pay_code")%></a> 
					<input type="hidden" name="hiPayCode" value="<%=sqlResult.getString(row, "pay_code")%>">
		    	</td>
		    	<td align="left">                 
		       		<%=sqlResult.getString(row, "proj_id")%>:<%=sqlResult.getString(row, "proj_name")%>
		       		<input type="hidden" name="projId" value="<%=sqlResult.getString(row, "proj_id")%>">
		       		<input type="hidden" name="projName" value="<%=sqlResult.getString(row, "proj_name")%>">
		       		<input type="hidden" name="contractType" value="<%=sqlResult.getString(row, "contracttype")%>">
		       		<input type="hidden" name="depId" value="<%=sqlResult.getString(row, "departmentId")%>">
		       		<input type="hidden" name="depNm" value="<%=sqlResult.getString(row, "department")%>">
		       		<input type="hidden" name="pmId" value="<%=sqlResult.getString(row, "pmId")%>">
		       		<input type="hidden" name="pmNm" value="<%=sqlResult.getString(row, "pmName")%>">
		        </td>
		        <td align="left">                 
		           <%=sqlResult.getString(row, "payAddr")%>
		           <input type="hidden" name="payAddrId" value="<%=sqlResult.getString(row, "payAddrId")%>">
		       	   <input type="hidden" name="payAddrNm" value="<%=sqlResult.getString(row, "payAddr")%>">
		        </td>
		        <td align="left">                 
		           <%=sqlResult.getString(row, "department")%>
		        </td>
		        <td align="right">                 
		           <%=formater.format(sqlResult.getDouble(row, "pay_calamount"))%>
		        </td>
		        <td align="right">                 
		           <%=formater.format(sqlResult.getDouble(row, "pay_calamount")-sqlResult.getDouble(row, "invoicedAmount"))%>
		           <input type="hidden" name="remainingAmount" value="<%=formater.format(sqlResult.getDouble(row, "pay_calamount")-sqlResult.getDouble(row, "invoicedAmount"))%>">
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
		    	<td align="center" class="lblerr" colspan="8">
		    		No Record Found.
		    	</td>
		    </tr>
		 	<%
		 		}
		 	%>
		 	<TR>		 		
			  	<td align="left" colspan="8">
			  		&nbsp;<input type="button" class="button" name="OK" value="OK" onclick="choosePayment();">
			  		&nbsp;<input type="button" class="button" name="Cancel" value="Cancel" onclick="self.close();">
			  	</td>
		  	</tr>
		</table>
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

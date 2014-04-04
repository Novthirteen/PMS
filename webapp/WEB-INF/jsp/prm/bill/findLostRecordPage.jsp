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
Log log = LogFactory.getLog("findLostRecordPage.jsp");
try {
long timeStart = System.currentTimeMillis();   //for performance test
String process = (String)request.getAttribute("process");

if (AOFSECURITY.hasEntityPermission("PROJ_LOST", "_VIEW", session)) {

	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	
	String formAction =  request.getParameter("formAction");
	String qryBillCode = request.getParameter("qryBillCode");
	String qryProject = request.getParameter("qryProject");
	String status = request.getParameter("status");
	if(status == null) status = "";
	//String qryDateFrom = request.getParameter("qryDateFrom");
	//String qryDateTo = request.getParameter("qryDateTo");
	String qryDepartment = request.getParameter("qryDepartment");
	
	if (qryDepartment == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			qryDepartment = userLogin.getParty().getPartyId();
		}
	}
	//Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
	
	//if (qryDateFrom == null || qryDateFrom.trim().length() == 0) qryDateFrom = Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
	//if (qryDateTo == null || qryDateTo.trim().length() == 0) qryDateTo = Date_formater.format(nowDate);

	//Date dayStart = UtilDateTime.toDate2(qryDateFrom + " 00:00:00.000");
	//Date dayEnd = UtilDateTime.toDate2(qryDateTo + " 00:00:00.000");
	
	SQLResults sqlResult = (SQLResults)request.getAttribute("QueryList");
	List partyList = (List)request.getAttribute("PartyList");
	
	String offSetStr = request.getParameter("offSet");
	int offSet = 0;
	if (offSetStr != null && offSetStr.trim().length() != 0) {
		offSet = Integer.parseInt(offSetStr);
	}
	
	final int recordPerPage = 20;
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
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
	
	function doEdit(lostRecordId) {
		if (lostRecordId != null) {
			document.editForm.lostRecordId.value = lostRecordId;
		}
		document.editForm.qryBillCode.value = document.queryForm.qryBillCode.value;
		document.editForm.qryProject.value = document.queryForm.qryProject.value;
		document.editForm.qryDepartment.value = document.queryForm.qryDepartment.options[document.queryForm.qryDepartment.selectedIndex].value;

		document.editForm.submit();
	}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<CAPTION align=center class=pgheadsmall>Lost Record List</CAPTION>
	<tr>
		<td>
			<form name="queryForm" action="findLost.do" method="post">
				<input type="hidden" name="formAction" id="formAction" value="query">
				<input type="hidden" name="offSet" id="offSet" value="0">
				<TABLE width="100%">
					<tr>
						<td colspan="10"><hr color=red></hr></td>
					</tr>
					
					<tr>
						<td class="lblbold">Bill Code:</td>
						<td class="lblLight"><input type="text" name="qryBillCode" id="qryBillCode" size="15" value="<%=qryBillCode != null ? qryBillCode : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Project:</td>
						<td class="lblLight"><input type="text" name="qryProject" id="qryProject" size="15" value="<%=qryProject != null ? qryProject : ""%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
						<td class="lblbold">Department:</td>
						<td class="lblLight">
							<select name="qryDepartment">
							<%
							if (AOFSECURITY.hasEntityPermission("PROJ_LOST", "_ALL", session)) {
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if (p.getPartyId().equals(qryDepartment)) {
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
						<td class="lblbold">Status:</td>
						<td><select name="status">
							<option value="Draft" <%=status.equals("Draft")?"selected":""%>>Draft</option>
							<option value="Confirmed" <%=status.equals("Confirmed")?"selected":""%>>Confirmed</option>
							</select>
						</td>
			   		</tr>
				    <tr>
				        <td colspan="6" >
				    	<td colspan="2" align="center">
							<input type="submit" value="Query" class="button">
						    <input type="button" value="New" class="button" onclick="doEdit();">
						</td>
					</tr>
					<tr>
						<td colspan="10" valign="top"><hr color=red></hr></td>
					</tr>
				</table>
			</form>
			<form name="editForm" action="editLost.do" method="post">
				<input type="hidden" name="formAction" id="formAction" value="view">
				<input type="hidden" name="lostRecordId" id="lostRecordId" value="">
				<input type="hidden" name="qryBillCode" id="qryBillCode" value="">
				<input type="hidden" name="qryProject" id="qryProject" value="">
				<input type="hidden" name="qryDepartment" id="qryDepartment" value="">
			</form>
		</td>
	</tr>
</table>
	
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
 	<TR bgcolor="#e9eee9">
	  	<td class="lblbold">#&nbsp;</td>
	  	<td align="center" class="lblbold">Bill Code</td>
	    <td align="center" class="lblbold">Project</td>
	    <td align="center" class="lblbold">Department</td>	   
	    <td align="center" class="lblbold">Currency</td>
	    <td align="center" class="lblbold">Amount</td>
	    <td align="center" class="lblbold">Create Date</td>
	    <td align="center" class="lblbold">Status</td>
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
    		<%=row + 1%>
    	</td>
    	<td align="left"> 
    		<a href="#" onclick="doEdit('<%=sqlResult.getLong(row, "inv_id")%>');"><%=sqlResult.getString(row, "bill_code")%></a>
    	</td>
    	<td align="left">                 
       		<%=sqlResult.getString(row, "proj_id")%>:<%=sqlResult.getString(row, "proj_name")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "department")%>
        </td>
        <td align="left">                 
           <%=sqlResult.getString(row, "currency")%>
        </td>        
        <td align="right">                 
           <%=formater.format(sqlResult.getDouble(row, "inv_amount"))%>
        </td>
        <td align="center">                 
           <%=dateFormater.format(sqlResult.getDate(row, "inv_createdate"))%>
        </td>
		<td align="center">                 
           <%=sqlResult.getString(row, "inv_status")%>
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
    	<td align="center" class="lblerr" colspan="14">
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
}
%>
<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults" %>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>

<%
try{
if (AOFSECURITY.hasEntityPermission("CUST_CONT_PROJECT", "_VIEW", session)) {

	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);
	
	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
	
	SQLResults result = (SQLResults)request.getAttribute("result");  

	List partyList = (List)request.getAttribute("partyList");
	if(partyList == null || partyList.size() <= 0){
		partyList = new ArrayList();
	}
%>
<script language="Javascript">

function fnQuery() {
	document.iForm.formAction.value = "query";
	document.iForm.submit();
}

function fnExport() {
	document.iForm.formAction.value = "export";
	document.iForm.submit();
}

function showCustomerDialog(){
	var code,desc;
	with(document.iForm){
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.customer.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			document.getElementById("textCustomer").value = v.split("|")[1];
		}
	}
}
</script>

<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<form name="iForm" action="pas.report.ContractGeneralInfoRpt.do" method="post">
	<input type="hidden" name="formAction" value="">
	<table width=100% cellpadding="1" border="0" cellspacing="1">		
		<table width=1010 cellpadding="1" border="0" cellspacing="1">
			<CAPTION align=center class=pgheadsmall>Contract General Information Report</CAPTION>
		</table>
		<tr><td>
			<table width=1010>
				<tr><td colspan=7><hr color=red></hr></td></tr>
				<%
		
				String textContract = request.getParameter("textContract");
				String textCustomer = request.getParameter("textCustomer");
				String textContractType = request.getParameter("textContractType");
				String textStatus = request.getParameter("textStatus");
				String textDept = request.getParameter("textDept");
				String textProjCode = request.getParameter("textProjCode");
				String textSignDateFrom = request.getParameter("textSignDateFrom");
				String textSignDateTo = request.getParameter("textSignDateTo");
				String textCreateDateFrom = request.getParameter("textCreateDateFrom");
				String textCreateDateTo = request.getParameter("textCreateDateTo");
			    
				if (textContract == null) textContract ="";
				if (textCustomer == null) textCustomer ="";
				if (textContractType == null) textContractType ="";
				if (textStatus == null) textStatus ="";
				if (textDept == null) textDept ="";
				if (textProjCode == null) textProjCode ="";
				if (textSignDateFrom == null) textSignDateFrom = "";
				if (textSignDateTo == null) textSignDateTo = "";
				if (textCreateDateFrom == null) textCreateDateFrom = "";
				if (textCreateDateTo == null) textCreateDateTo = "";
				%>
				<tr>
					<td class="lblbold" align="right" width=180>Contract No. or Description:&nbsp;</td>
					<td class="lblLight" width=100>
						<input type="text" name="textContract" size="15" value="<%=textContract%>" style="TEXT-ALIGN: right" class="lbllgiht">
					</td>
					<td width=5></td>
					<td class="lblbold" align="right" width=120>Customer:&nbsp;</td>
					<td class="lblLight"  width=125>
						<input type="text" name="textCustomer" size="15" value="<%=textCustomer%>" style="TEXT-ALIGN: right" class="lbllgiht">
						<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/>
						</a>
					</td>
	    			<td class="lblbold" align="right" width=180>Contract Type:&nbsp;</td>
	    			<td class="lblLight">
		   	 			<select name="textContractType" >
	    					<option value="" selected>ALL</option>
							<option value="FP" <%if (textContractType.equals("FP")) out.print("selected");%>>Fixed Price</option>
							<option value="TM" <%if (textContractType.equals("TM")) out.print("selected");%>>Time & Material</option>
			    		</select>
	     			</td>
	    		</tr>
	    		<tr>
	     			<td class="lblbold" width=180 align="right">Contract Status:&nbsp;</td>
		    		<td class="lblLight" width=100>
					    <select name="textStatus" >
			   	            <option value="" selected>ALL</option>
							<option value="Signed" <%if (textStatus.equals("Signed")) out.print("selected");%>>Signed</option>
							<option value="Unsigned" <%if (textStatus.equals("Unsigned")) out.print("selected");%>>Unsigned</option>
							<option value="Cancel" <%if (textStatus.equals("Cancel")) out.print("selected");%>>Cancel</option>
							<option value="Closed" <%if (textStatus.equals("Closed")) out.print("selected");%>>Closed</option>
					    </select>
	     			</td>
	     			<td  width=5></td>
	     			<td class="lblbold"  width=120 align="right">Department:&nbsp;</td>
					<td class="lblLight">
						<select name="textDept">
							<%
							if (AOFSECURITY.hasEntityPermission("CONTRACT_PROFILE", "_ALL", session)) {
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if (p.getPartyId().equals(textDept)) {
							%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%
									}else{
							%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%
									}
								}
							}
							%>
						</select>
					</td>
					<td class="lblbold" width=180 align="right">Project Code:&nbsp;</td>
					<td class="lblLight">
						<input type="text" name="textProjCode" size="15" value="<%=textProjCode%>" style="TEXT-ALIGN: right" class="lbllgiht">
					</td>
				</tr>
	   			<tr>
	    	 		<td class="lblbold" align="right">Sign Date Range:&nbsp;</td>
		 			<td class="lblLight" colspan="2">
						<input  type="text" class="inputBox" name="textSignDateFrom" size="10" value="<%=textSignDateFrom%>"><A href="javascript:ShowCalendar(document.iForm.dimg1,document.iForm.textSignDateFrom,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						~
						<input  type="text" class="inputBox" name="textSignDateTo" size="10" value="<%=textSignDateTo%>"><A href="javascript:ShowCalendar(document.iForm.dimg2,document.iForm.textSignDateTo,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
		 			</td>
			 		<td class="lblbold"  width=120 align="right">Create Date Range:&nbsp;</td>
			 		<td class="lblLight" colspan="3">
						<input  type="text" class="inputBox" name="textCreateDateFrom" size="10" value="<%=textCreateDateFrom%>"><A href="javascript:ShowCalendar(document.iForm.dimg3,document.iForm.textCreateDateFrom,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg3 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						~
						<input  type="text" class="inputBox" name="textCreateDateTo" size="10" value="<%=textCreateDateTo%>"><A href="javascript:ShowCalendar(document.iForm.dimg4,document.iForm.textCreateDateTo,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg4 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
			 		</td>
	   			</tr>
		    	<tr>
		        	<td colspan=4/>
		    		<td  align="right" colspan=3>
						<input type="button" value="Query" class="button" onclick="fnQuery()">
				    	<input type="button" value="Export Excel" class="button" onclick="fnExport()">
				    	&nbsp;
					</td>
				</tr>
				<tr>
					<td colspan=7 valign="top"><hr color=red></hr></td>
				</tr>
			</table>
		</td></tr>
		<tr>
			<td>
				<table border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
					<tr bgcolor="#e9eee9">
					  	<td class="lblbold">#&nbsp;</td>
					  	<td align="left" class="lblbold">Contract No.</td>
					  	<td align="left" class="lblbold">Account Manager</td>
						<td align="left" class="lblbold">Total Contract Value (RMB)</td>
						<td align="left" class="lblbold">Sign Date</td>
						<td align="left" class="lblbold">Create Date</td>
						<td align="left" class="lblbold">Legal Review Date</td>
						<td align="left" class="lblbold">Customer Sat.</td>
						<td align="left" class="lblbold">Start Date</td>
						<td align="left" class="lblbold">End Date</td>
						<td align="left" class="lblbold">Contract Status</td>
						<td align="left" class="lblbold">Contract Type</td>
					    <td align="left" class="lblbold">Project Code</td>
					    <td align="left" class="lblbold">Project Description</td>
					    <td align="left" class="lblbold">Department</td>
						<td align="left" class="lblbold">Customer</td>
						<td align="left" class="lblbold">Parent Project</td>
						<td align="left" class="lblbold">Customer Paid Allowance</td>
						<td align="left" class="lblbold">Project Manager</td>
						<td align="left" class="lblbold">Project Assistant</td>
						<td align="left" class="lblbold">Bill To</td>
						<td align="left" class="lblbold">Contact Person</td>
						<td align="left" class="lblbold">Contact Person Tele</td>
						<td align="left" class="lblbold">Customer PM</td>
						<td align="left" class="lblbold">Customer PM Tele</td>
						<td align="left" class="lblbold">Need CAF</td>
						<td align="left" class="lblbold">Need Renew</td>
					</tr>
					<%
					if(result == null || result.getRowCount() <=0){
						out.println("<br><tr><td colspan='27' class=lblerr align='center'>No Record Found.</td></tr>");
					} else {
						int rowSize = result.getRowCount();
						int flag = 1;
						for(int row = 0; row < rowSize; row++){
					%>
					<tr bgcolor="#e9eee9">
					  	<td align="left" nowrap><%=flag++%></td>
					    <td align="left" nowrap>
							<div class="tabletext"><p><%=result.getString(row, "contract_no") == null ? "" : result.getString(row, "contract_no")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="tabletext"><p><%=result.getString(row, "account_manager") == null ? "" : result.getString(row, "account_manager")%></div>   
					    </td>            
					    <td align="left" nowrap> 
					    <%
					    String strTotal = "0.00";
					    double total = result.getDouble(row, "total_contract_value");
					    if(total >= 0){
					    	strTotal = numFormater.format(total);
					    }
					    %>
					    	<div class="head4"><p><%=strTotal%></div>
					    </td>
						<td align="left" nowrap> 
					      	<div class="head4"><p><%=result.getDate(row, "signed_date") == null ? "" : dateFormater.format(result.getDate(row, "signed_date"))%></div>
					    </td>
						<td align="left" nowrap> 
					      	<div class="head4"> <p><%=result.getDate(row, "create_date") == null ? "" : dateFormater.format(result.getDate(row, "create_date"))%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getDate(row, "legal_review_date") == null ? "" : dateFormater.format(result.getDate(row, "legal_review_date"))%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p> <%=result.getString(row, "customer_sat") == null ? "" : result.getString(row, "customer_sat")%></div>
					    </td>
					    <td align="left" nowrap> 
					      	<div class="head4"> <p><%=result.getDate(row, "start_date") == null ? "" : dateFormater.format(result.getDate(row, "start_date"))%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getDate(row, "end_date") == null ? "" : dateFormater.format(result.getDate(row, "end_date"))%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "contract_status") == null ? "" : result.getString(row, "contract_status")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "contract_type") == null ? "" : result.getString(row, "contract_type")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "project_code") == null ? "" : result.getString(row, "project_code")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "project_name") == null ? "" : result.getString(row, "project_name")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "department") == null ? "" : result.getString(row, "department")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "customer") == null ? "" : result.getString(row, "customer")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "parent_proj_name") == null ? "" : result.getString(row, "parent_proj_name")%> </div>
					    </td>
					    <td align="left" nowrap>
					    <%
					    String strPaidAllow = "0.00";
					    double paidAllow = result.getDouble(row, "customer_paid_allowance");
					    if(paidAllow >= 0){
					    	strPaidAllow = numFormater.format(paidAllow);
					    }
					    %>
					        <div class="head4"><p><%=strPaidAllow%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "project_manager") == null ? "" : result.getString(row, "project_manager")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "project_assistant") == null ? "" : result.getString(row, "project_assistant")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "bill_to") == null ? "" : result.getString(row, "bill_to")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "contact_person") == null ? "" : result.getString(row, "contact_person")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "contact_tel") == null ? "" : result.getString(row, "contact_tel")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "customer_pm") == null ? "" : result.getString(row, "customer_pm")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p><%=result.getString(row, "customer_pm_tel") == null ? "" : result.getString(row, "customer_pm_tel")%></div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p>
					        	<% 
						        	String nf = "";
									String cafFlag = result.getString(row, "caf_flag");
									if(cafFlag != null){
										if(cafFlag.equals("Y")) nf = "YES";
										if(cafFlag.equals("N")) nf = "NO";
									}
								%>
								<%=nf%>
					        </div>
					    </td>
					    <td align="left" nowrap>
					        <div class="head4"><p>
					        	<%
					        		String nr = "";
					        		String renewFlag = result.getString(row, "renew_flag");
					        		if(renewFlag != null){
					        			if(renewFlag.equals("Y")) nr = "YES";
										if(renewFlag.equals("N")) nr = "NO";
					        		}
					        	%>
					        	<%=nr%>
					        </div>
					    </td>
					</tr>
					<%
						}
					}
					%>
				</table>
			</td>
		</tr>
	</table>
</form>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
}catch(Exception e){
e.printStackTrace();
}
%>

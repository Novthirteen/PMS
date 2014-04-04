<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
Log log = LogFactory.getLog("findBillPendingList.jsp");
try{ 
long timeStart = System.currentTimeMillis();   //for performance test
if (AOFSECURITY.hasEntityPermission("PROJECT_BILLING", "_VIEW", session)) { %>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>	
<%	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

	NumberFormat Num_formater = NumberFormat.getInstance();
	Num_formater.setMaximumFractionDigits(2);
	Num_formater.setMinimumFractionDigits(2);	
	String offSetStr = request.getParameter("offSet");
	int offSet = 0;
	if (offSetStr != null && offSetStr.trim().length() != 0) {
		offSet = Integer.parseInt(offSetStr);
	}

  //  request.setAttribute("offSet", offSet);
 //   request.setAttribute("length", length);	
    
    int i = offSet+1;
    
	final int recordPerPage = 10;
	String textcode = request.getParameter("textcode");
	String textbillto = request.getParameter("textbillto");
	String textcust = request.getParameter("textcust");
	String textdep = request.getParameter("textdep");
	if (textcode == null) textcode ="";
	if (textbillto == null) textbillto ="";
	if (textcust == null) textcust ="";
	if (textdep == null) {
		UserLogin userLogin = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			textdep = userLogin.getParty().getPartyId();
		}
	}
	String ck ="";
	List partyList_dep=null;
	try{
		PartyHelper ph = new PartyHelper();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
		if (partyList_dep == null) partyList_dep = new ArrayList();
		partyList_dep.add(0,ul.getParty());
	}catch(Exception e){
		e.printStackTrace();
	}
%>
<script language="Javascript">
function showBillDetail(billId, billType) {
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
function fnSubmit1(start) {
	with (document.frm) {
		offSet.value=start;
		submit();
	}
}
function SearchResult() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
function NewInstruction() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "create";
	formObj.target = "_self";
	formObj.submit();
}
function ClearRadio() {
	var pids = document.getElementsByName("pid");
	for (var i = 0; i < pids.length; i++) {
		pids[i].checked = false;
	}
}

function showExpDialog(projectId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectInvoice.showexpense.dialog.title&findBillingDetail.do?pid="+projectId+"&category=<%=Constants.TRANSACATION_CATEGORY_EXPENSE%>",
			                null,
			                'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:no');
}
function showCAFDialog(projectId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectInvoice.showcaf.dialog.title&findBillingDetail.do?pid="+projectId+"&category=<%=Constants.TRANSACATION_CATEGORY_CAF%>",
			                null,
			                'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:no');
}
function showAlownceDialog(projectId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectInvoice.showallowance.dialog.title&findBillingDetail.do?pid="+projectId+"&category=<%=Constants.TRANSACATION_CATEGORY_ALLOWANCE%>",
			                null,
			                'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:no');
}
function showAccpDialog(projectId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectInvoice.showbillingacceptance.dialog.title&findBillingDetail.do?pid="+projectId+"&category=<%=Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE%>",
			                null,
			                'dialogWidth:650px;dialogHeight:300px;status:no;help:no;scroll:no');
}
function showDownPayDialog(projectId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectInvoice.showdownpay.dialog.title&findBillingDetail.do?pid="+projectId+"&category=<%=Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT%>",
			                null,
			                'dialogWidth:650px;dialogHeight:300px;status:no;help:no;scroll:no');
}
</script>

<form name="frm" action="findBillPendingList.do" method="post">
<input type="hidden" name="FormAction" id="FormAction">
<input type="hidden" name="recordPerPage" id="recordPerPage" value="<%=recordPerPage%>">
<input type="hidden" name="offSet" id="offSet" value="0">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Billing Pending List </CAPTION>
<tr>
	<td>
	<TABLE width="100%">
			<tr>
				<td colspan=20><hr color=red></hr></td>
			</tr>
		
		<tr>
			<td class="lblbold">Project:</td>
			<td class="lblLight"><input type="text" name="textcode" size="15" value="<%=textcode%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
			
			<td class="lblbold">Bill To:</td>
			<td class="lblLight"><input type="text" name="textbillto" size="15" value="<%=textbillto%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
			
			<td class="lblbold">Customer:</td>
			<td class="lblLight"><input type="text" name="textcust" size="15" value="<%=textcust%>" style="TEXT-ALIGN: left" class="lbllgiht"></td>
	  	    
	    	<td class="lblbold">Department:</td>
			<td class="lblLight">
				<select name="textdep">
					<%
					if (AOFSECURITY.hasEntityPermission("PROJECT_BILLING", "_ALL", session)) {
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(textdep)) {
					%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
					<%		} else{		%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
					<%
							}
						}
					}
					%>
				</select>
			</td>
			<%
				boolean detailflag = false;
				if (request.getParameter("detailflag") != null) detailflag = true;
			%>
			<td align="left" class="lblbold">
				<input type=checkbox class="checkboxstyle" name="detailflag" value="Y" <%if (detailflag) out.print("Checked");%>>
				Show Sub-Project Detail
			</td>
	    </tr>
	    
		<tr>
		        <td colspan=8 align="left"></td>
				<td  align="center">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="SearchResult();">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel()">
				</td>
			</tr>
			<tr>
				<td colspan=20 valign="top"><hr color=red></hr></td>
			</tr>
	</table>
	</td>
</tr>
<tr>
	<td>
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
  <TR bgcolor="#e9eee9">
  	<td class="lblbold">#&nbsp;</td>
  	<td align="left" class="lblbold">Bill To</td>
  	<td align="left" class="lblbold">Project</td>
  	<td align="left" class="lblbold">Customer</td>
    <td align="left" class="lblbold">Contract Type</td>
    <td align="left" class="lblbold">CAF Days</td>
	<td align="left" class="lblbold">CAF Amount (RMB)</td>
	<td align="left" class="lblbold">Alownce Amount (RMB)</td>
	<td align="left" class="lblbold">Expense Amount (RMB)</td>
    <td align="left" class="lblbold">Acceptance Amount (RMB)</td>
    <td align="left" class="lblbold">Credit-Down-Payment Amount (RMB)</td>
	<td align="left" class="lblbold">Total Calculated Amount (RMB)</td>
    <td align="left" class="lblbold">Last Bill Instruction No.</td> 
    <td align="left" class="lblbold">Last Bill Date</td>
  </tr>
  <%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			Object resultSet_data;
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
				String newBillTo = null;
				String oldBillTo = null;
				for (int row =offSet; row < sr.getRowCount()&& row < offSet + recordPerPage; row++) {
					newBillTo = sr.getString(row, "billto");

					String CAFDays="";
					
					String BCode="";
					String BDate="";
					
					if (sr.getString(row,"CAFDays") == null ) CAFDays="0"; else CAFDays= (sr.getString(row,"CAFDays"));
					//if (sr.getString(row,"BillCode") == null) BCode="N/A"; else BCode= sr.getString(row,"BillCode");
					if (sr.getString(row,"BillDate") == null) BDate="N/A"; else BDate= sr.getString(row,"BillDate");
				%>
					<tr bgcolor="#e9eee1"> 
						<%
							String projectId = sr.getString(row,"pid");
							String type="";
							if  (sr.getString(row,"contracttype").equals("FP"))
							{
								type="Fixed Price";
								}else{
								type="Time & Material";}
						%>
						<td nalign=left><input TYPE="RADIO" class="radiostyle" name="pid" value="<%=projectId%>" ></td>
						<%
							if (!newBillTo.equals(oldBillTo)) {
								oldBillTo = newBillTo;
						%>
						<td  align=left><%=sr.getString(row,"billto")%></td>
						<%
							} else {
						%>
						<td  align=left></td>
						<%
							}
						%>
						<td  align=left><%=projectId%>:<%=sr.getString(row,"pname")%></td>
						<td  align=left><%=sr.getString(row,"customer")%></td>
						<td  align=left><%=type%></td>
						<%if(CAFDays.equals("0")){%>
							<td nowrap align=right></td>
						<%}else{%>
							<td  align=right><a href="javascript:void(0)" onclick="showCAFDialog('<%=projectId%>');event.returnValue=false;"><%=CAFDays%></a></td>
						<%}%>
						<%if((sr.getDouble(row,"CAFAmt")==0d)){%>
							<td nowrap align=right></td>
						<%}else{%>
							<td  align=right><a href="javascript:void(0)" onclick="showCAFDialog('<%=projectId%>');event.returnValue=false;"><%=Num_formater.format(sr.getDouble(row,"CAFAmt"))%></a></td>
						<%}%>
						<%if((sr.getDouble(row,"AlwnceAmt")==0d)){%>
							<td nowrap align=right></td>
						<%}else{%>
							<td  align=right><a href="javascript:void(0)" onclick="showAlownceDialog('<%=projectId%>');event.returnValue=false;"><%=Num_formater.format(sr.getDouble(row,"AlwnceAmt"))%></a></td>
						<%}%>
						<%if((sr.getDouble(row,"ExpAmt")==0d)){%>
							<td nowrap align=right></td>
						<%}else{%>	
							<td  align=right><a href="javascript:void(0)" onclick="showExpDialog('<%=projectId%>');event.returnValue=false;"><%=Num_formater.format(sr.getDouble(row,"ExpAmt"))%></a></td>
						<%}%>
						<%if((sr.getDouble(row,"AccpAmt")==0d)){%>
							<td nowrap align=right></td>
						<%}else{%>	
							<td  align=right><a href="javascript:void(0)" onclick="showAccpDialog('<%=projectId%>');event.returnValue=false;"><%=Num_formater.format(sr.getDouble(row,"AccpAmt"))%></a></td>
						<%}%>
						<%if((sr.getDouble(row,"CDPAmt")==0d)){%>
							<td nowrap align=right></td>
						<%}else{%>
							<td  align=right><a href="javascript:void(0)" onclick="showDownPayDialog('<%=projectId%>');event.returnValue=false;"><%=Num_formater.format(sr.getDouble(row,"CDPAmt"))%></a></td>
						<%}%>
						<%if((sr.getDouble(row,"AccpAmt")+sr.getDouble(row,"AlwnceAmt")+sr.getDouble(row,"CAFAmt")+sr.getDouble(row,"ExpAmt")+sr.getDouble(row,"CDPAmt"))==0d){%>
							<td nowrap align=right></td>
						<%}else{%>
							<td  align=right><%=Num_formater.format(sr.getDouble(row,"AccpAmt")+sr.getDouble(row,"AlwnceAmt")+sr.getDouble(row,"CAFAmt")+sr.getDouble(row,"ExpAmt")+sr.getDouble(row,"CDPAmt"))%></a></td>
						<%}%>
						<%
							if (sr.getString(row,"BillCode") != null) {
						%>
						<td  align=right><a href="javascript:void(0)" onclick="showBillDetail('<%=sr.getLong(row,"BillId")%>', '<%=sr.getString(row,"BillType")%>');event.returnValue=false;"><%=sr.getString(row,"BillCode")%></a></td>
						<%
							} else {
						%>
						<td  align=right>N/A</td>
						<%
							}
						%>
						<td  align=right><%=BDate%></td>
					</tr>
				<%}
			}%>	
			<tr>
				<td colspan=6 align="left">
					<input TYPE="button" class="button" name="Clear" value="Clear" onclick="javascript: ClearRadio()">
					<input TYPE="button" class="button" name="CreateNew" value="Create Instruction" onclick="javascript: NewInstruction()">
				</td>
			</tr>	
			<tr>

				
				<td width="100%" colspan="16" align="right" class=lblbold>Pages&nbsp;:&nbsp;
			<%
			int recordSize = sr.getRowCount();
			for (int j0 = 0; j0 < Math.ceil((double)recordSize / recordPerPage); j0++) {
				if (j0 == offSet / recordPerPage) {
			%>
			&nbsp;<font size="3"><%=j0 + 1%></font>&nbsp;
			<%
				} else {
			%>
			&nbsp;<a href="javascript:fnSubmit1('<%=j0 * recordPerPage%>')" title="Click here to view next set of records"><%=j0 + 1%></a>&nbsp;
			<%
				}
			}
			%>
		</td>
			</tr>
          </table>
         </td>
        </tr>
</table>
</form>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}
		Hibernate2Session.closeSession();
long timeEnd = System.currentTimeMillis();       //for performance test
log.info("it takes " + (timeEnd - timeStart) + " ms to dispaly...");
}catch(Exception e){
		e.printStackTrace();
	}%>

<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.payment.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{ 
if (AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT", "_VIEW", session)) { %>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>	
<%	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

	NumberFormat Num_formater = NumberFormat.getInstance();
	Num_formater.setMaximumFractionDigits(2);
	Num_formater.setMinimumFractionDigits(2);	
	Integer offset = null;	
	if( request.getParameter("offset") == null || request.getParameter("offset").equals("") ){
		offset = new Integer(0);
	}else{
		offset = new Integer(request.getParameter("offset"));
	} 
	
	Integer length = new Integer(15);	

    request.setAttribute("offset", offset);
    request.setAttribute("length", length);	
    
    int i = offset.intValue()+1;

	String textcode = request.getParameter("textcode");
	String textcust = request.getParameter("textcust");
	String textdep = request.getParameter("textdep");
	if (textcode == null) textcode ="";
	if (textcust == null) textcust ="";
	if (textdep == null) textdep ="";
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
function showPayDetail(payId, payType) {
	if (payType == "<%=Constants.PAYMENT_TYPE_NORMAL%>") {
		v = window.showModalDialog(
		"system.showDialog.do?title=prm.projectPayment.payment.dialog.title&EditPaymentInstruction.do?action=dialogView&payId=" + payId,
			null,
		'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
	} else {
		v = window.showModalDialog(
		"system.showDialog.do?title=prm.projectPayment.payment.dialog.title&EditPaymentDownpaymentInstruction.do?formAction=dialogView&payId=" + payId,
			null,
		'dialogWidth:600px;dialogHeight:400px;status:no;help:no;scroll:auto');
	}
}
function fnSubmit1(start) {
	with (document.frm) {
		offset.value=start;
		submit();
	}
}
function SearchResult() {
	var formObj = document.frm;
	formObj.elements["FormAction"].value = "QueryForList";
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
	window.showModalDialog("system.showDialog.do?title=prm.projectPayment.showexpense.dialog.title&findPaymentDetail.do?pid="+projectId+" &category=<%=Constants.TRANSACATION_CATEGORY_EXPENSE%>",
			                null,
			                'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:no');
}
function showCAFDialog(projectId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectPayment.showcaf.dialog.title&findPaymentDetail.do?pid="+projectId+"&category=<%=Constants.TRANSACATION_CATEGORY_CAF%>",
			                null,
			                'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:no');
}

function showAccpDialog(projectId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectPayment.showpaymentacceptance.dialog.title&findPaymentDetail.do?pid="+projectId+"&category=<%=Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE%>",
			                null,
			                'dialogWidth:650px;dialogHeight:300px;status:no;help:no;scroll:no');
}
function showDownPayDialog(projectId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectPayment.showdownpay.dialog.title&findPaymentDetail.do?pid="+"&category=<%=Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT%>",
			                null,
			                'dialogWidth:650px;dialogHeight:300px;status:no;help:no;scroll:no');
}

function showCheckBillingDialog(projectId) {
	window.showModalDialog("system.showDialog.do?title=prm.projectPayment.showcheckbilling.dialog.title&findCheckBilling.do?pid="+projectId,
			                null,
			                'dialogWidth:650px;dialogHeight:300px;status:no;help:no;scroll:no');
}
</script>

<form name="frm" action="findPaymentPendingList.do" method="post">
<input type="hidden" name="FormAction">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Payment Pending List </CAPTION>
<tr>
	<td>
	<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
		
		<tr>
			<td class="lblbold">Project:</td>
			<td class="lblLight"><input type="text" name="textcode" size="15" value="<%=textcode%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
			
			<td class="lblbold">Supplier:</td>
			<td class="lblLight"><input type="text" name="textcust" size="15" value="<%=textcust%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
	  	    
	    	<td class="lblbold">Department:</td>
			<td class="lblLight">
				<select name="textdep">
					
					<%
					if (AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT", "_ALL", session)) {
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
				boolean detailflag = true;
				//if (request.getParameter("detailflag") != null) detailflag = true;
			%>
			<!--<td align="left" class="lblbold">
				<input type=checkbox class="checkboxstyle" name="detailflag" value="Y" <%//if (detailflag) out.print("Checked");%>>
				Show Sub-Project Detail
			</td>  -->
	    </tr>
	    
		<tr>
		        <td colspan=6 align="left"/>
				<td  align="center">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="SearchResult();">
				</td>
			</tr>
			<tr>
				<td colspan=8 valign="top"><hr color=red></hr></td>
			</tr>
	</table>
	</td>
</tr>
<tr>
	<td>
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
  <TR bgcolor="#e9eee9">
  	<td class="lblbold">#&nbsp;</td>
    <td align="left" class="lblbold">Supplier</td>
    <td align="left" class="lblbold">Pay To</td>
    <td align="left" class="lblbold">Project</td>
    <td align="left" class="lblbold">Contract Type</td>
    <td align="left" class="lblbold">CAF Days</td>
	<td align="left" class="lblbold">CAF Amount (RMB)</td>
    <td align="left" class="lblbold">Acceptance Amount (RMB)</td>
    <td align="left" class="lblbold">Credit-Down-Payment Amount (RMB)</td>
	<td align="left" class="lblbold">Total Calculated Amount (RMB)</td>
    <td align="left" class="lblbold">Last Payment Instruction No.</td> 
    <td align="left" class="lblbold">Last Payment Date</td>
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
				for (int row =0; row < sr.getRowCount(); row++) {
					String CAFDays="";
					
					String PCode="";
					String PDate="";
					
					if (sr.getString(row,"CAFDays") == null ) CAFDays=""; else CAFDays= (sr.getString(row,"CAFDays"));
					if (sr.getString(row,"PayCode") == null) PCode="N/A"; else PCode= sr.getString(row,"PayCode");
					if (sr.getString(row,"PayDate") == null) PDate="N/A"; else PDate= sr.getString(row,"PayDate");
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
						<td nowrap align=left><input TYPE="RADIO" class="radiostyle" name="pid" value="<%=projectId%>" ></td>
						<td nowrap align=left><%=sr.getString(row,"customer")%></td>
						<td nowrap align=left><%=sr.getString(row,"payto")%></td>
						<td nowrap align=left><a href="javascript:void(0)" onclick="showCheckBillingDialog('<%=projectId%>');event.returnValue=false;"><%=projectId%>:<%=sr.getString(row,"pname")%></a></td>
						<td nowrap align=left><%=type%></td>
						<%if(CAFDays.equals("0")){%>
							<td nowrap align=right>&nbsp;</td>
						<%}else{%>
							<td nowrap align=right><a href="javascript:void(0)" onclick="showCAFDialog('<%=projectId%>');event.returnValue=false;"><%=CAFDays%></a></td>
						<%}%>
						<%if(sr.getDouble(row,"CAFAmt")==0d){%>
							<td nowrap align=right>&nbsp;</td>
						<%}else{%>
							<td nowrap align=right><a href="javascript:void(0)" onclick="showCAFDialog('<%=projectId%>');event.returnValue=false;"><%=Num_formater.format(sr.getDouble(row,"CAFAmt"))%></a></td>
						<%}%>
						<%if(sr.getDouble(row,"AccpAmt")==0d){%>
							<td nowrap align=right>&nbsp;</td>
						<%}else{%>
							<td nowrap align=right><a href="javascript:void(0)" onclick="showAccpDialog('<%=projectId%>');event.returnValue=false;"><%=Num_formater.format(sr.getDouble(row,"AccpAmt"))%></a></td>
						<%}%>
						<%if(sr.getDouble(row,"CDPAmt")==0d){%>
							<td nowrap align=right>&nbsp;</td>
						<%}else{%>
							<td nowrap align=right><a href="javascript:void(0)" onclick="showDownPayDialog('<%=projectId%>');event.returnValue=false;"><%=Num_formater.format(sr.getDouble(row,"CDPAmt"))%></a></td>
						<%}%>
						<%if(((sr.getObject(row,"AccpAmt")==null?0:sr.getDouble(row,"AccpAmt"))+(sr.getObject(row,"CAFAmt")==null?0:sr.getDouble(row,"CAFAmt"))+(sr.getObject(row,"CDPAmt")==null?0:sr.getDouble(row,"CDPAmt")))==0d){%>
							<td nowrap align=right>&nbsp;</td>
						<%}else{%>
							<td nowrap align=right><%=Num_formater.format(sr.getDouble(row,"AccpAmt")+sr.getDouble(row,"CAFAmt")+sr.getDouble(row,"CDPAmt"))%></td>
						<%}%>
						<%
							if (sr.getString(row,"PayCode") != null) {
						%>
						<td  align=right><a href="javascript:void(0)" onclick="showPayDetail('<%=sr.getLong(row,"PayId")%>', '<%=sr.getString(row,"PayType")%>');event.returnValue=false;"><%=sr.getString(row,"PayCode")%></a></td>
						<%}else{%>
							<td  align=right>N/A</td>
						<%}%>
							<td nowrap align=right><%=PDate%></td>
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
				<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<input type=hidden name="offset" value="<%=offset%>">
				<%
				int RecordSize = sr.getRowCount();
				int l = 0;
				while ((l * length.intValue()) < RecordSize) {
					if (offset.intValue() == l*length.intValue()) {%>
					&nbsp;<%=l+1%>&nbsp;
					<%} else {%>
					&nbsp;<a href="javascript:fnSubmit1(<%=l*length.intValue()%>)" title="Click here to view next set of records"><%=l+1%></a>&nbsp;
					<%};
					l++;
				}%>
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
}catch(Exception e){
		e.printStackTrace();
	}%>

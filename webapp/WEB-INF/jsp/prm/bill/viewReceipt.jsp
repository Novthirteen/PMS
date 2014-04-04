<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.contract.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.crm.customer.CustomerProfile"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.prm.Bill.ProjectReceiptMaster"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="net.sf.hibernate.Query"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script>
function showInvoiceDetail(invoiceId) {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.projectInvoice.showinovice.dialog.title&editInvoice.do?formAction=dialogView&invoiceId=" + invoiceId,
		null,
	'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
}
</script>
<%
try{
if (AOFSECURITY.hasEntityPermission("PROJ_RECEIPT", "_VIEW", session)) {
String errorMessage = (String)request.getAttribute("ErrorMessage");
ProjectReceiptMaster prm = (ProjectReceiptMaster)request.getAttribute("ProjectReceiptMaster");
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
String receiptNo = null;
Double receiptAmount = null;
CurrencyType currency = null;
Float exchangeRate = null;
UserLogin createUser = null;
CustomerProfile customer = null;
java.util.Date createDate = null;
java.util.Date receiptDate = null;
String status = null;
String createDateString = null;
String receiptDateString = null;
Double remainAmount = (Double)request.getAttribute("RemainAmount");

if(prm != null){
receiptNo = prm.getReceiptNo();
receiptAmount = prm.getReceiptAmount();
currency = prm.getCurrency();
exchangeRate = prm.getExchangeRate();
createUser = prm.getCreateUser();
customer = prm.getCustomerId();
createDate = prm.getCreateDate();
receiptDate = prm.getReceiptDate();
status = prm.getReceiptStatus(); if(status == null) status = "";
}
if(createDate != null)
createDateString = formatter.format(createDate);
if(receiptDate != null)
receiptDateString = formatter.format(receiptDate);

UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);

//new code are all above 
//original code 
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
NumberFormat Num_formater2 = NumberFormat.getInstance();
Num_formater2.setMaximumFractionDigits(5);
Num_formater2.setMinimumFractionDigits(2);
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;


ProjectHelper projHelper = new ProjectHelper();
List currencyList = projHelper.getAllCurrency(hs);
if(currencyList==null){
	currencyList = new ArrayList();
}
Iterator itCurr = currencyList.iterator();
String rateStr = "";
while(itCurr.hasNext()){
	com.aof.component.prm.project.CurrencyType curr = (com.aof.component.prm.project.CurrencyType)itCurr.next();
	rateStr = rateStr+curr.getCurrRate().toString()+"$";
%>
<script language="javascript">
var rateArray = "<%=rateStr%>".split("$");
</script>
<%}%>

<script language="javascript">

function FnDelete() {
	if (confirm("Do you want delete this receipt?")) {
		document.EditReceiptForm.FormAction.value = "delete";
		document.EditReceiptForm.submit();
	}
}
function FnUpdate() {
	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{
	   // if(validate()&& validateSignDate()){
	      	document.EditReceiptForm.FormAction.value = "Save";
	      	document.EditReceiptForm.process.value = "update";
			document.EditReceiptForm.submit();
		//  }

	}
}

function ValidateData() {
	var errormessage="";
	
	if(document.EditReceiptForm.receiptNo.value == "")
	{
		errormessage="You must input the Receipt No.";
		return errormessage;
    }
	
	if(document.EditReceiptForm.customerId.value == "")
	{
		errormessage="You must select a customer";
		return errormessage;
    }
    
    return errormessage;
}

function FnCreate() {
  	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{   
	      //if(validate()&& validateSignDate()){
	      	document.EditReceiptForm.FormAction.value = "Save";
	      	document.EditReceiptForm.process.value = "create";
		  	document.EditReceiptForm.submit();
		  //}
	}
}
function fieldCheck(field){
	if (field.value ==""){
		alert("You must enter at least one Service Type Name" );
	}
}

function validateSignDate(){
  if(document.EditReceiptForm.signedDate.value.length>0){
	         return dataOneCheck(document.EditReceiptForm.signedDate);
   }
   return true;
}
function validate(){
   var startDate = document.EditReceiptForm.startDate;
   var endDate = document.EditReceiptForm.endDate;
   var signedDate = document.EditReceiptForm.signedDate;
	    if (startDate.value.length>0 && endDate.value.length==0){
	      return dataOneCheck(startDate);
	    }
	    if((startDate.value.length>0 && endDate.value.length>0) ){
	       return dataCheck(startDate,endDate);
	    }
	    if(startDate.value.length==0 && endDate.value.length>0){
	        alert("endDate is earlier than startDate");
	        return false;
	    }
	     
	return true;
}

function onCurrSelect(){
	with(document.EditReceiptForm) {
		document.EditReceiptForm.exchangeRate.value = rateArray[ExpenseCurrency.selectedIndex];
	}
}


function showCustomerDialog()
{
	var code,desc;
	with(document.EditReceiptForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelCustomer.innerHTML=code+":"+desc;
			customerId.value=code;
			
		}
	}
}

function showDialog_account()
{
	var code,desc;
	with(document.EditReceiptForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelAccount.innerHTML=code+":"+desc;
			document.EditReceiptForm.createUser.value=code;
		} else {
			labelAccount.innerHTML="";
			document.EditReceiptForm.createUser.value="";
		}
	}
}
</script>

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
             Receipt Settlement List 
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
	<TD width='100%'>

<form action="editReceipt.do" method="post" name="EditReceiptForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
    <input type="hidden" name="FormAction" id="FormAction" >
    <input type="hidden" name="process" id="process" >
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>

      <tr>
        <td align="right" class="lblbold">
          <span class="tabletext">Receipt No.:&nbsp;</span>
        </td>
        <%if(receiptNo == null){%>
        <td>
          <input type="text" name="receiptNo" value="">
        </td>
        <%}else{%>
        <td>
        	<%=receiptNo%><input type="hidden" name="receiptNo" id="receiptNo" value="<%=receiptNo%>">
        </td>
        <%}%>
        <td align="right" class="lblbold">
          <span class="tabletext">Receipt Status:&nbsp;</span>
        </td>
        <td align="left">
            <%=status==null?"Draft":status%><input type="hidden" name="status" id="status" value="<%=status%>">
        </td>        
      </tr>
      
      <tr>
        <td align="right" class="lblbold">
          <span class="tabletext">Receipt Amount:&nbsp;</span>
        </td>
        <td align="left">
          <%=UtilFormat.format(receiptAmount)%><input type="hidden" class="inputBox" name="receiptAmount" id="receiptAmount" value="<%=receiptAmount==null?new Double(0.0):receiptAmount%>" size="30">
        </td>
        <td align="right" class="lblbold">
          <span class="tabletext">Remain Amount (RMB):&nbsp;</span>
        </td>
		<td align="left">
			<%=UtilFormat.format(remainAmount)%>
		 </td>
      </tr>
      
      <tr>
        <td align="right" class="lblbold">
          <span class="tabletext">Currency:&nbsp;</span>
        </td>
        <td align="left">
			<div style="display:inline"><%=currency.getCurrName()%></div>
        </td>
        <td align="right" class="lblbold">
          <span class="tabletext">Exchange Rate:&nbsp;</span>
        </td>
		<td class="lblLight" width="35%">	
			<div style="display:inline"><%=exchangeRate%></div>
		</td>
      </tr>
      
      <tr>
	    <td align="right" class="lblbold">
          <span class="tabletext">Create User:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
			<% String cUserId = ""; String cUserName = ""; if (createUser != null) { cUserId = createUser.getUserLoginId(); cUserName = createUser.getName(); } %>
			<div style="display:inline" id="labelAccount"><%=cUserId+":"+cUserName%>&nbsp;</div>
			<input type="hidden" name="createUser" id="createUser" value="<%=cUserId%>"><a href="javascript:void(0)" onclick="showDialog_account(); event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>			
        </td>
	    <td align="right" class="lblbold">
          <span class="tabletext">Customer:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
			<%String customerId = "";
			  String customerName = "";
			  if (customer != null) {
				customerId = customer.getPartyId();
				customerName = customer.getDescription();
			 }%>
			<div style="display:inline" id="labelCustomer"><%=customerId+":"+customerName%>&nbsp;</div>
			<input type="hidden" readonly="true" name="customerName" id="customerName" maxlength="100" value="<%=customerName%>">
			<input type="hidden" name="customerId" id="customerId" value="<%=customerId%>"><a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>       
      </tr>
	  
      <tr>
        <td align="right" class="lblbold"><span class="tabletext">Create Date:&nbsp;</span></td>
        <td align="left" class="lblbold"><input type="text" class="inputBox" name="createDate" value="<%=createDateString==null?formatter.format(java.util.Calendar.getInstance().getTime()):createDateString%>" size="10"><A href="javascript:ShowCalendar(document.EditReceiptForm.dimg1,document.EditReceiptForm.createDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
        <td align="right" class="lblbold"><span class="tabletext">Receipt Date:&nbsp;</span></td>
        <td align="left" class="lblbold"><input type="text" class="inputBox" name="receiptDate" value="<%=receiptDateString==null?"":receiptDateString%>" size="10"><A href="javascript:ShowCalendar(document.EditReceiptForm.dimg2,document.EditReceiptForm.receiptDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
      </tr>
      
      <tr>
        <td align="right"><span class="tabletext"></span></td>
        <td align="left">
       <input type="button" value="Back To List" class="loginButton" onclick="location.replace('listReceipt.do')">
		</td>      
		<td></td>
	    <td align="center"></td>
      </tr> 
    </table>
	</td>
  </tr>
</table>
</form>

		<td></td>
	    <td align="center">
		
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<br>
<br>
<br>
<table width="100%">
<tr><td>

		<div width="100%">
		<display:table name="requestScope.ReceiptSettlementList" export="true" class="ITS" requestURI="editReceipt.do" pagesize="15">
			<display:column property="receiptNo" title="Receipt No." sortable="true" />
			<display:column property="invoiceCode" title="Invoice Code"   sortable="true" />
			<display:column property="receiveAmount" title="Amount"  sortable="true" />
			<display:column property="currencyString" title="Currency" />
			<display:column property="currencyRate" title="Exchange Rate" />	
			<display:column property="userString" title="Create User" />		
			<display:column property="receiveDateString" title="Receipt Date"  sortable="true" />
			<display:column property="createDateString" title="Create Date" />							
		</display:table>
		</div>
</td></tr>
</table>

<%
	
Hibernate2Session.closeSession();
}else{
	out.println("你没有权限访问!");
}
}catch(Exception e){
	e.printStackTrace();
}
%>

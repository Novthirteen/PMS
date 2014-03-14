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
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<%
try{
if (AOFSECURITY.hasEntityPermission("RECEIPT_MSTR", "_CREATE", session)) {
String errorMessage = (String)request.getAttribute("ErrorMessage");
ProjectReceiptMaster prm = (ProjectReceiptMaster)request.getAttribute("ProjectReceiptMaster");
UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	NumberFormat numFormat = NumberFormat.getInstance();
	numFormat.setMaximumFractionDigits(2);
	numFormat.setMinimumFractionDigits(2);
String receiptNo = null;
String faReceiptno = null;
String note = null;
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
String location = null;
Double remainAmount = (Double)request.getAttribute("RemainAmount");
String type ="";

if(prm != null){
faReceiptno = prm.getFaReceiptNo();
note = prm.getNote();
type = prm.getReceiptType();
receiptNo = prm.getReceiptNo();
receiptAmount = prm.getReceiptAmount();
currency = prm.getCurrency();
exchangeRate = prm.getExchangeRate();
createUser = prm.getCreateUser();
customer = prm.getCustomerId();
createDate = prm.getCreateDate();
receiptDate = prm.getReceiptDate();
location = prm.getLocation();
status = prm.getReceiptStatus(); if(status == null) status = "";
//test
System.out.println(status);
}
if(createDate != null)
createDateString = formatter.format(createDate);
if(receiptDate != null)
receiptDateString = formatter.format(receiptDate);


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
		removeComma(document.EditReceiptForm.receiptAmount);
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
	if(document.EditReceiptForm.customerId.value == ""){
		errormessage="You must select a customer";
		return errormessage;
    }
    
    if(document.EditReceiptForm.receiptAmount.value == "" || parseFloat(document.EditReceiptForm.receiptAmount.value) <= 0.0){
		errormessage="Receipt Amount Invalid";
		return errormessage;
    }
	else
		removeComma(document.EditReceiptForm.receiptAmount);
		
    if(document.EditReceiptForm.receiptDate.value == ""){
		errormessage="You must input the Receipt Date";
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
	      //removecomma
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
	
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	
	with(document.EditReceiptForm) {
		exchangeRate.value = RateArr[currency.selectedIndex];
		labelCurrencyRate.innerHTML=exchangeRate.value;
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
<Form action="userList.do" name="UserListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<Form action="custList.do" name="CustListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<%if(errorMessage!=null){out.println(errorMessage);}else{ %>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Receipt Maintenance
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
    <input type="hidden" name="FormAction" >
    <input type="hidden" name="process" >
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>

      <tr>
        <td align="right" class="lblbold">
          <span class="tabletext">Receipt No.:&nbsp;</span>
        </td>
        <%if(receiptNo != null){%>
        <td>
        	<%=receiptNo%><input type="hidden" name="receiptNo" value="<%=receiptNo%>">
        </td>
        <%}else{%>
        <td>
			<input type="text" name="receiptNo" value="">
        </td>
		<%}%>
		<td align="right" class="lblbold">
          <span class="tabletext">F&A Receipt No.:&nbsp;</span>
        </td>
		<td>
		   <input type="text" name="faReceiptno" value="<%=faReceiptno==null?"":faReceiptno%>">
		</td>
      </tr>
      
      <tr>
        <td align="right" class="lblbold">
          <span class="tabletext">Receipt Amount:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="receiptAmount" value="<%=receiptAmount==null?new String("0.00"):numFormat.format(receiptAmount)%>" size="30" onblur="checkDeciNumber2(this,1,1,'procBudget',-9999999,9999999); addComma(this, '.', '.', ',');" >
        </td>
        <td align="right" class="lblbold">
          <span class="tabletext">Remain Amount (RMB):&nbsp;</span>
        </td>
		<td align="left">
			<%=remainAmount==null?(new Double(0.0)).toString():numFormat.format(remainAmount)%>
		 </td>
      </tr>
      
      <tr>
        <td align="right" class="lblbold">
          <span class="tabletext">Currency:&nbsp;</span>
        </td>
        <td align="left">
        <%if(status != null && !status.equals(Constants.RECEIPT_STATUS_DRAFT)){%>
		 <div style="display:inline" ><%=currency.getCurrName()%></div>
		 <input type=hidden name="currency" value="<%=currency.getCurrName()%>">
        <%}else{%>	
          <select name="currency" onchange="javascript:onCurrSelect()">
		  <%						
		      Float defaultCurrRate = null;
		      CurrencyType defaultCurr = null;
			  for (int i0 = 0; i0 < currencyList.size(); i0++) {
				CurrencyType curr = (CurrencyType)currencyList.get(i0);
				if (i0 == 0) {
					defaultCurr = curr;
					defaultCurrRate = curr.getCurrRate();
				}
				if(currency != null && curr.getCurrId().equals(currency.getCurrId())){
			%>
				<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
			<%  }else if(currency== null && curr.getCurrId().equals("RMB")){
				exchangeRate = curr.getCurrRate();
			%>	
				<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
							
			<%  }else{%>
				<option value="<%=curr.getCurrId()%>"><%=curr.getCurrName()%></option>
			<%}}%>
		  </select>
		 <%}%> 
        </td>
        <td align="right" class="lblbold">
          <span class="tabletext">Exchange Rate:&nbsp;</span>
        </td>
		<td class="lblLight" width="35%">
		<%if(status != null && !status.equals(Constants.RECEIPT_STATUS_DRAFT)){%>	
			<div style="display:inline" id="labelCurrencyRate"><%if(exchangeRate !=null) out.print(exchangeRate);%></div>
			<input type=hidden name="exchangeRate" value="<%if(exchangeRate !=null) out.print(exchangeRate);%>">
		<%}else{%>
			<div style="display:none" id="labelCurrencyRate"></div>	
			<input type=text name="exchangeRate" value="<%if(exchangeRate !=null) out.print(exchangeRate); %>">	
		<%}%>	
		</td>
      </tr>
      
      <tr>
	    <td align="right" class="lblbold">
          <span class="tabletext">Create User:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
			<% String cUserId = ""; String cUserName = ""; 
			   if (createUser != null) { cUserId = createUser.getUserLoginId(); cUserName = createUser.getName(); } 
			   else{ cUserId = ul.getUserLoginId(); cUserName = ul.getName(); }%>
			<div style="display:inline" id="labelAccount"><%=cUserId+":"+cUserName%>&nbsp;</div>
			<input type="hidden" name="createUser" value="<%=cUserId%>"><a href="javascript:void(0)" onclick="showDialog_account(); event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>			
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
			<input type="hidden" readonly="true" name="customerName" maxlength="100" value="<%=customerName%>">
			<input type="hidden" name="customerId" value="<%=customerId%>"><a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>       
      </tr>
	  
      <tr>
        <td align="right" class="lblbold"><span class="tabletext">Create Date:&nbsp;</span></td>
        <td align="left" class="lblbold"><input type="text" class="inputBox" name="createDate" value="<%=createDateString==null?formatter.format(java.util.Calendar.getInstance().getTime()):createDateString%>" size="10"><A href="javascript:ShowCalendar(document.EditReceiptForm.dimg1,document.EditReceiptForm.createDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
        <td align="right" class="lblbold"><span class="tabletext">Receipt Date:&nbsp;</span></td>
        <td align="left" class="lblbold"><input type="text" class="inputBox" name="receiptDate" value="<%=receiptDateString==null?"":receiptDateString%>" size="10"><A href="javascript:ShowCalendar(document.EditReceiptForm.dimg2,document.EditReceiptForm.receiptDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
      </tr>
      
      <tr>
  		<td align="right" class="lblbold"><span class="tabletext">Receipt Status:&nbsp;</span></td>
        <td align="left"><%=status==null?"Draft":status%><input type="hidden" name="status" value="<%=status%>"></td> 

  		<td align="right" class="lblbold"><span class="tabletext">Receipt Type:&nbsp;</span></td>
		<%if(!type.equals("") && type!=null){%>
		<td>
		<select name="receiptType">
			<option value="<%=type%>" ><%=type%></option>
			<option value="<%=type.equalsIgnoreCase("normal")?"Lost":"Normal"%>"><%=type.equalsIgnoreCase("normal")?"Lost":"Normal"%></option>
		</select>
		</td> 
		<%}else{%>
		<td>
		<select name="receiptType">
			<option value="Normal" >Normal</option>
			<option value="Lost" >Lost</option>
		</select>
		</td>
		<%}%>
      </tr> 
      <tr>
      	<td align="right" class="lblbold"><span class="tabletext">Location:&nbsp;</span></td>
      	<td>
      		<select name="location">
      			<option value="Beijing" <%=(location!=null&&location.equals("Beijing"))?"selected":""%> <%=(location==null && ul.getParty().getDescription().equals("Beijing"))?"selected":""%>>Beijing</option>
      			<option value="Shanghai" <%=(location!=null&&location.equals("Shanghai"))?"selected":""%> <%=(location==null && ul.getParty().getDescription().equals("Shanghai"))?"selected":""%>>Shanghai</option>
      		</select>
      	</td>
      	<%if(prm==null){%>
      		<td align="right">E-Mail Notification to PA:&nbsp;</td>
      		<td><input type="checkbox" class="checkboxstyle" name="notify" value="yes" checked></td>
      	<%}else{%>
      		<td colspan="2"/>
      	<%}%>
      </tr>
      <br>      
      <tr>
  		<td align="right" class="lblbold"><span class="tabletext">Note:&nbsp;</span></td>
		<td class="lblLight" width="85%" colspan="3">
			<textarea name="note" cols="120" rows="3"><%=note==null?"":note%></textarea>
		</td> 
      </tr>
       
      <tr>
        <td align="right"><span class="tabletext"></span></td>
        <td align="left">
        <%if(receiptNo == null){%>
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();"/>
		<%}else if(status.equals(Constants.RECEIPT_STATUS_DRAFT)){%>
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<%}%>		
	    <%if(receiptNo != null && status.equals(Constants.RECEIPT_STATUS_DRAFT)){%>
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();"/>
		<%}%>
		<input type="button" value="Back To List" class="loginButton" onclick="window.location.replace('listReceipt.do')">
		</td>      
		<td></td>
	    <td align="center"></td>
      </tr> 
    </table>
	</td>
  </tr>
</table>
<br>

</form>

		<td></td>
	    <td align="center">
		
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<%}%>
<%
	
Hibernate2Session.closeSession();
}else{
	out.println("你没有权限访问!");
}
}catch(Exception e){
	e.printStackTrace();
}
%>

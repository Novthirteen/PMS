<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.contract.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.crm.vendor.VendorProfile"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.prm.payment.ProjectPaymentMaster"%>
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
<%
try{
if (true || AOFSECURITY.hasEntityPermission("SUPPLIER_INVOICE_MSTR", "_VIEW", session)) {							//zdit
String errorMessage = (String)request.getAttribute("ErrorMessage");
ProjectPaymentMaster ppm = (ProjectPaymentMaster)request.getAttribute("ProjectPaymentMaster");
UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	NumberFormat numFormat = NumberFormat.getInstance();
	numFormat.setMaximumFractionDigits(2);
	numFormat.setMinimumFractionDigits(2);
String viewAction = (String)request.getAttribute("ViewAction");
String payCode = null;
String faPaymentno = null;
String note = null;
Double payAmount = null;
CurrencyType currency = null;
Float exchangeRate = null;
UserLogin createUser = null;
VendorProfile vendor = null;
java.util.Date createDate = null;
java.util.Date payDate = null;
String status = null;
String createDateString = null;
String payDateString = null;
Double remainAmount = (Double)request.getAttribute("RemainAmount");
String type ="";

if(ppm != null){
faPaymentno = ppm.getFaPaymentNo();;
note = ppm.getNote();
type = ppm.getPayType();
payCode = ppm.getPayCode();
payAmount = new Double(ppm.getPayAmount());
currency = ppm.getCurrency();
exchangeRate = ppm.getExchangeRate();
createUser = ppm.getCreateUser();
vendor = ppm.getVendorId();
createDate = ppm.getCreateDate();
payDate = ppm.getPayDate();
status = ppm.getPayStatus(); if(status == null) status = "";
}
if(createDate != null)
createDateString = formatter.format(createDate);
if(payDate != null)
payDateString = formatter.format(payDate);


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
	if (confirm("Do you want delete this payment?")) {
		document.EditPayForm.FormAction.value = "delete";
		document.EditPayForm.submit();
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
	      	document.EditPayForm.FormAction.value = "Save";
	      	document.EditPayForm.process.value = "update";
			document.EditPayForm.submit();
		//  }

	}
}

function ValidateData() {
	var errormessage="";
	/*
	if(document.EditPayForm.payNo.value == "")
	{
		errormessage="You must input the Pay No.";
		return errormessage;
    }
	*/
	if(document.EditPayForm.vendorId.value == "")
	{
		errormessage="You must select a vendor";
		return errormessage;
    }
    
    if(document.EditPayForm.payAmount.value == "" || parseFloat(document.EditPayForm.payAmount.value) <= 0.0)
	{
		errormessage="Payment Amount Invalid";
		return errormessage;
    }
    
    if(document.EditPayForm.payDate.value == "")
			{
				errormessage="You must input the Payment Date";
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
	      	document.EditPayForm.FormAction.value = "Save";
	      	document.EditPayForm.process.value = "create";
		  	document.EditPayForm.submit();
		  //}
	}
}
function fieldCheck(field){
	if (field.value ==""){
		alert("You must enter at least one Service Type Name" );
	}
}

function validateSignDate(){
  if(document.EditPayForm.signedDate.value.length>0){
	         return dataOneCheck(document.EditPayForm.signedDate);
   }
   return true;
}
function validate(){
   var startDate = document.EditPayForm.startDate;
   var endDate = document.EditPayForm.endDate;
   var signedDate = document.EditPayForm.signedDate;
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
	with(document.EditPayForm) {
		document.EditPayForm.exchangeRate.value = rateArray[ExpenseCurrency.selectedIndex];
	}
}


function showVendorDialog()
{
	var code,desc;
	with(document.EditPayForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogVendorList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelVendor.innerHTML=code+":"+desc;
			vendorId.value=code;
		} else {
			labelVendor.innerHTML="";
			vendorId.value="";
		}
	}
}

function showDialog_account()
{
	var code,desc;
	with(document.EditPayForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelAccount.innerHTML=code+":"+desc;
			document.EditPayForm.createUser.value=code;
		} else {
			labelAccount.innerHTML="";
			document.EditPayForm.createUser.value="";
		}
	}
}
</script>

<%if(errorMessage!=null){out.println(errorMessage);}else{ %>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <td align=left width='90%' class="wpsPortletTopTitle">Supplier Invoice Maintenance</td>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
	<TD width='100%'>

<form action="editSupplierInvoice.do" method="post" name="EditPayForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
    <input type="hidden" name="FormAction" >
    <input type="hidden" name="process" >
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>

      <tr>
        <td align="right" class="lblbold" width=20%>
          <span class="tabletext">Payment Code:&nbsp;</span>
        </td>
        <%if(payCode != null){%>
        <td>
        	<%=payCode%><input type="hidden" name="payCode" value="<%=payCode%>">
        </td>
        <%}else{%>
        <td>
			<input type="text" name="payCode" value="">
        </td>
		<%}%>
      </tr>
      
      <tr>
        <td align="right" class="lblbold">
          <span class="tabletext">Payment Amount:&nbsp;</span>
        </td>
        <td align="left"><%=payAmount==null?new String("0.00"):UtilFormat.format(payAmount)%>
        </td>
        <td align="right" class="lblbold">
          <span class="tabletext">Remain Amount:&nbsp;</span>
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
			<div style="display:inline"><%=currency.getCurrName()%></div>
        </td>
        <td align="right" class="lblbold">
          <span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
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
			<% String cUserId = ""; String cUserName = ""; 
			   if (createUser != null) { cUserId = createUser.getUserLoginId(); cUserName = createUser.getName(); } 
			   else{ cUserId = ul.getUserLoginId(); cUserName = ul.getName(); }%>
			<div style="display:inline" id="labelAccount"><%=cUserId+":"+cUserName%>&nbsp;</div>
			<input type="hidden" name="createUser" value="<%=cUserId%>">			
        </td>
	    <td align="right" class="lblbold">
          <span class="tabletext">Vendor:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
			<%String vendorId = "";
			  String vendorName = "";
			  if (vendor != null) {
				vendorId = vendor.getPartyId();
				vendorName = vendor.getDescription();
			 }%>
			<div style="display:inline" id="labelVendor"><%=vendorId+":"+vendorName%>&nbsp;</div>
			<input type="hidden" readonly="true" name="vendorName" maxlength="100" value="<%=vendorName%>">
			<input type="hidden" name="vendorId" value="<%=vendorId%>">
        </td>       
      </tr>
	  
      <tr>
        <td align="right" class="lblbold"><span class="tabletext">Create Date:&nbsp;</span></td>
        <td align="left" class="lblbold"><%=createDateString==null?formatter.format(java.util.Calendar.getInstance().getTime()):createDateString%></td>
        <td align="right" class="lblbold"><span class="tabletext">Payment Date:&nbsp;</span></td>
        <td align="left" class="lblbold"><%=payDateString==null?"":payDateString%></td>
      </tr>
      
      <tr>
  		<td align="right" class="lblbold"><span class="tabletext">Pay Status:&nbsp;</span></td>
        <td align="left"><%=status==null?"Draft":status%><input type="hidden" name="status" value="<%=status%>"></td> 

  		<td align="right" class="lblbold"><span class="tabletext">Pay Type:&nbsp;</span></td>
		<%if(!type.equals("") && type!=null){%>
		<td>
		<select name="payType">
			<option value="<%=type%>" ><%=type%></option>
			<option value="<%=type.equalsIgnoreCase("normal")?"Credit":"Normal"%>"><%=type.equalsIgnoreCase("normal")?"Credit":"Normal"%></option>
		</select>
		</td> 
		<%}else{%>
		<td>
		<select name="payType">
			<option value="Normal" >Normal</option>
			<option value="Credit" >Credit</option>
		</select>
		</td>
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
        <%if(viewAction != null && viewAction.equalsIgnoreCase("view")){%>
		<td align="left">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listSupplierInvoice.do')">
		</td>
		<%} else if(viewAction != null && viewAction.equalsIgnoreCase("dialogView")){%>      
		<td align="left">
		<input type="button" value="Close" class="loginButton" onclick="self.close()">
		</td>      
		<%}%>
	    <td align="center"></td>
      </tr> 
    </table>
	
  
</table>
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
<table width="100%">
<tr><td>
		<div width="100%">
		<display:table name="requestScope.SettlementList" export="true" class="ITS" requestURI="editSupplierInvoice.do" pagesize="15">
			<display:column property="formCode" title="Posted Payment Code" sortable="true" />
			<display:column property="refno" title="Supplier Invoice Code"   sortable="true" />
			<display:column property="totalvalueString" title="Amount"  sortable="true" />
			<display:column property="currencyString" title="Currency" />
			<display:column property="exchangerate" title="Exchange Rate" />	
			<display:column property="payStatus" title="Status" />		
			<display:column property="createDateString" title="Create Date" />							
		</display:table>
		</div>
</td></tr>
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

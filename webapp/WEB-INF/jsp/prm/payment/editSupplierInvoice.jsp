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
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<%
try{
if (AOFSECURITY.hasEntityPermission("SUPPLIER_INVOICE_MSTR", "_CREATE", session)) {							//zdit
String errorMessage = (String)request.getAttribute("ErrorMessage");
ProjectPaymentMaster ppm = (ProjectPaymentMaster)request.getAttribute("ProjectPaymentMaster");

String payCode = null;
//String faPaymentno = null;
String note = null;
double payAmount = 0;
CurrencyType currency = null;
Float exchangeRate = null;
UserLogin createUser = null;
VendorProfile vendor = null;
ProjectMaster project = null;
java.util.Date createDate = null;
java.util.Date payDate = null;
String paidStatus = null;
String settledStatus = null;
String createDateString = null;
String payDateString = null;
double paidAmount = 0;
double settledAmount = 0;
double paidRemainAmount = 0;
double settledRemainAmount = 0;
String type ="";

if(ppm != null){
//faPaymentno = ppm.getFaPaymentNo();;
	note = ppm.getNote();
	type = ppm.getPayType();
	payCode = ppm.getPayCode();
	payAmount = ppm.getPayAmount();
	currency = ppm.getCurrency();
	exchangeRate = ppm.getExchangeRate();
	createUser = ppm.getCreateUser();
	vendor = ppm.getVendorId();
	project = ppm.getPoProjId();
	createDate = ppm.getCreateDate();
	payDate = ppm.getPayDate();
	paidStatus = ppm.getPayStatus(); 
	settledStatus = ppm.getSettleStatus();
	paidAmount = ppm.getPaidAmount();
	paidRemainAmount = ppm.getPaidRemainingAmount();
	settledAmount = ppm.getSettledAmount();
	settledRemainAmount = ppm.getSettledRemainingAmount();	
}

SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat numFormat = NumberFormat.getInstance();
numFormat.setMaximumFractionDigits(2);
numFormat.setMinimumFractionDigits(2);

if(createDate != null) createDateString = formatter.format(createDate);
if(payDate != null) payDateString = formatter.format(payDate);
if (paidStatus == null) paidStatus = Constants.SUPPLIER_INVOICE_PAY_STATUS_DRAFT;
if (settledStatus == null) settledStatus = Constants.SUPPLIER_INVOICE_SETTLE_STATUS_DRAFT;

UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);

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
		removeComma(document.EditPayForm.payAmount);
		//alert(document.EditPayForm.payAmount.value);
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
    
    if(document.EditPayForm.payAmount.value == "" )
	{
		errormessage="Payment Amount Invalid";
		return errormessage;
    }else
    	removeComma(document.EditPayForm.payAmount);
    
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
	/*
	with(document.EditReceiptForm) {
		document.EditReceiptForm.exchangeRate.value = rateArray[ExpenseCurrency.selectedIndex];
	}
	*/
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	
	with(document.EditPayForm) {
		exchangeRate.value = RateArr[currency.selectedIndex];
		labelCurrencyRate.innerHTML=exchangeRate.value;
	}
}
function showPOProjectDialog()
{
	var code,desc,vendorId,vendorName;
	with(document.EditPayForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&POProjectList.do",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			labelProj.innerHTML=v.split("|")[0]+":"+v.split("|")[1];
			projId.value=v.split("|")[0];
			labelVendor.innerHTML=v.split("|")[2]+":"+v.split("|")[3];
			vendorId.value=v.split("|")[2];
		} else {
			labelProj.innerHTML="";
			projId.value="";
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

<%
	if (errorMessage!=null) {
		out.println(errorMessage);
%>
	<input type="button" name="history" value="back" onclick="window.history.back();">
<%
	} else { 
%>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <td align=left width='90%' class="wpsPortletTopTitle">
            Supplier Invoice Maintenance
          </td>
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
    <input type="hidden" name="FormAction" id="FormAction" >
    <input type="hidden" name="process" id="process" >
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>

      <tr>
        <td align="right" class="lblbold" width=20%>
          <span class="tabletext">Supplier Invoice Code:&nbsp;</span>
        </td>
        <%if(payCode != null){%>
        <td>
        	<%=payCode%><input type="hidden" name="payCode" id="payCode" value="<%=payCode%>">
        </td>
        <%}else{%>
        <td>
			<input type="text" name="payCode" value="">
        </td>
		<%}%>		
      </tr>
      <tr>
      	<td align="right" class="lblbold"><span class="tabletext">Project:&nbsp;</span></td>
      	<td>
      		<%String projId = "";
			  String projName = "";
			  if (project != null) {
				projId = project.getProjId();
				projName = project.getProjName();
			 }%>
			<div style="display:inline" id="labelProj"><%=projId+":"+projName%>&nbsp;</div>
			<%
			if (payCode == null) {
			%>
			<a href="javascript:void(0)" onclick="showPOProjectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
			<%
			}
			%>
			<input type="hidden" name="projName" id="projName" value="<%=projName%>">
			<input type="hidden" name="projId" id="projId" value="<%=projId%>">
      	</td>
      	<td align="right" class="lblbold">
          <span class="tabletext">Vendor:&nbsp;</span>
        </td>
        <td align="left">
			<%String vendorId = "";
			  String vendorName = "";
			  if (vendor != null) {
				vendorId = vendor.getPartyId();
				vendorName = vendor.getDescription();
			 }%>
			<div style="display:inline" id="labelVendor"><%=vendorId+":"+vendorName%>&nbsp;</div>
			<input type="hidden" name="vendorName" id="vendorName" value="<%=vendorName%>">
			<input type="hidden" name="vendorId" id="vendorId" value="<%=vendorId%>">
        </td>
      </tr>
      <tr>
        <td align="right" class="lblbold">
          <span class="tabletext">Supplier Invoice Amount:&nbsp;</span>
        </td>
        <td align="left">
        <%
        	if(!paidStatus.equals(Constants.SUPPLIER_INVOICE_PAY_STATUS_COMPLETED)){
        %>
          <input type="text" class="inputBox" name="payAmount" value="<%=numFormat.format(payAmount)%>" size="30" onblur="checkDeciNumber2(this,1,1,'Amount',-9999999,9999999);addComma(this, '.', '.', ',');" >
        <%
        	} else {
        %>
       	 <%=numFormat.format(payAmount)%>
        <%
        	}
        %>
        </td>
        
        <td align="right" class="lblbold"><span class="tabletext">Supplier Invoice Date:&nbsp;</span></td>
        <td align="left" class="lblbold">
        <%
        	if(!paidStatus.equals(Constants.SUPPLIER_INVOICE_PAY_STATUS_COMPLETED)){
        %>
        	<input type="text" class="inputBox" name="payDate" value="<%=payDateString==null?"":payDateString%>" size="10">
        	<A href="javascript:ShowCalendar(document.EditPayForm.dimg2,document.EditPayForm.payDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        <%
        	} else {
        %>
        	<%=payDateString==null?"":payDateString%>
        <%
        	}
        %>
        </td>
      </tr>
      
      <tr>
        <td align="right" class="lblbold">
          <span class="tabletext">Currency:&nbsp;</span>
        </td>
        <td align="left">
        <%if(!settledStatus.equals(Constants.SUPPLIER_INVOICE_SETTLE_STATUS_DRAFT)){%>
		 <div style="display:inline" ><%=currency.getCurrName()%></div>
		 <input type="hidden" name="currency" id="currency" value="<%=currency.getCurrName()%>">
        <%}else{%>	
          <select name="currency" onchange="javascript:onCurrSelect()">
		  <%						
		      Float defaultCurrRate = null;
		      CurrencyType defaultCurr = null;
			  for (int i0 = 0; i0 < currencyList.size(); i0++) {
				CurrencyType curr = (CurrencyType)currencyList.get(i0);
				
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
          <span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
        </td>
		<td class="lblLight" width="35%">
		<%if(!settledStatus.equals(Constants.SUPPLIER_INVOICE_SETTLE_STATUS_DRAFT)){%>	
			<div style="display:inline" id="labelCurrencyRate"><%if(exchangeRate !=null) out.print(exchangeRate);%></div>
			<input type="hidden" name="exchangeRate" id="exchangeRate" value="<%if(exchangeRate !=null) out.print(exchangeRate); %>">
		<%}else{%>
			<div style="display:none" id="labelCurrencyRate"></div>	
			<input type=text name="exchangeRate" value="<%if(exchangeRate !=null) out.print(exchangeRate); %>">	
		<%}%>	
		</td>
      </tr>
      
      <tr>
	      <td align="right" class="lblbold"><span class="tabletext">Supplier Invoice Type:&nbsp;</span></td>
	    <%
        	if(!paidStatus.equals(Constants.SUPPLIER_INVOICE_PAY_STATUS_COMPLETED)){
        %>
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
		<%
			} else {
		%>
			<td>
			<%=type%>
			</td>
		<%
			}
		%>
      </tr>
      
      <tr>
      	<td align="right" class="lblbold">
          <span class="tabletext">Settled Status:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
        <%=settledStatus%></td>
        
        <td align="right" class="lblbold">
          <span class="tabletext">Paid Status:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
        <%=paidStatus%></td>
        
      </tr>
      
      <tr>
      	<td align="right" class="lblbold">
          <span class="tabletext">Settled Amount:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
        <%=numFormat.format(settledAmount)%></td>
        
      	<td align="right" class="lblbold">
          <span class="tabletext">Paid Amount:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
        <%=numFormat.format(paidAmount)%></td>
      </tr>
      
      <tr>
      	<td align="right" class="lblbold">
          <span class="tabletext">Settled Remaining Amount:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
        <%=numFormat.format(settledRemainAmount)%></td>
        
        <td align="right" class="lblbold">
          <span class="tabletext">Paid Remaining Amount:&nbsp;</span>
        </td>
        <td align="left" class="lblbold">
        <%=numFormat.format(paidRemainAmount)%></td>
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
			<input type="hidden" name="createUser" id="createUser" value="<%=cUserId%>">
        </td>
        
        <td align="right" class="lblbold"><span class="tabletext">Create Date:&nbsp;</span></td>
        <td align="left" class="lblbold">
        	<%=createDateString==null?formatter.format(java.util.Calendar.getInstance().getTime()):createDateString%>
        	<input type="hidden" class="inputBox" name="createDate" id="createDate" value="<%=createDateString==null?formatter.format(java.util.Calendar.getInstance().getTime()):createDateString%>" size="10">
        </td>    
      </tr>
      <tr>
  		<td align="right" class="lblbold"><span class="tabletext">Note:&nbsp;</span></td>
		<td class="lblLight" width="85%" colspan="3">
		<%
        	if(!paidStatus.equals(Constants.SUPPLIER_INVOICE_PAY_STATUS_COMPLETED)){
        %>
			<textarea name="note" cols="120" rows="3"><%=note==null?"":note%></textarea>
		<%
			} else {
		%>
		<%=note==null?"":note%>
		<%
			}
		%>
		</td> 
      </tr>
       
      <tr>
        <td align="right"><span class="tabletext"></span></td>
        <td align="left">
        <%if(payCode == null){%>
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();"/>
		<%}else if(!paidStatus.equals(Constants.SUPPLIER_INVOICE_PAY_STATUS_COMPLETED)){%>
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<%}%>		
	    <%if(payCode != null && settledStatus.equals(Constants.SUPPLIER_INVOICE_SETTLE_STATUS_DRAFT)){%>
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();"/>
		<%}%>
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listSupplierInvoice.do')">
		</td>      
		<td></td>
	    <td align="center"></td>
      </tr> 
    </table>
</form>

		<td></td>
	    <td align="center">
		
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

<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.contract.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
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
<SCRIPT>

function showDialog_staff() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.EditForm.projectManagerId.value=v.split("|")[0];
			document.EditForm.projectManagerName.value=v.split("|")[1];			
	}
}

/*
function showDialog_account() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.EditForm.accountManagerId.value=v.split("|")[0];
			document.EditForm.accountManagerName.value=v.split("|")[1];			
	}
}*/
function showDialog_account()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelAccount.innerHTML=code+":"+desc;
			accountManagerId.value=code;
		} else {
			labelAccount.innerHTML="";
			accountManagerId.value="";
		}
	}
}
function showDialog_SalesPerson1()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelspName1.innerHTML=code+":"+desc;
			SalesPersonId1.value=code;
		} else {
			labelspName1.innerHTML="";
			SalesPersonId1.value="";
		}
	}
}
function showDialog_SalesPerson2()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelspName2.innerHTML=code+":"+desc;
			SalesPersonId2.value=code;
		} else {
			labelspName2.innerHTML="";
			SalesPersonId2.value="";
		}
	}
}
/*
function showDialog_staff() {
	var formObj = document.forms["EditForm"];
	openStaffSelectDialog("onCloseDialog_staff","EditForm");
}*/

function onCloseDialog_staff() {
	var formObj = document.forms["EditForm"];
	setStaffValue("hiddenStaffName","projectManagerName","EditForm");	
	setStaffValue("hiddenStaffCode","projectManagerId","EditForm");
}
</SCRIPT>
<%
try{
if (AOFSECURITY.hasEntityPermission("CONTRACT_PROFILE", "_CREATE", session)) {
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
NumberFormat Num_formater2 = NumberFormat.getInstance();
Num_formater2.setMaximumFractionDigits(5);
Num_formater2.setMinimumFractionDigits(2);
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");

String repeatName =(String)request.getAttribute("repeatName");

String contractId = request.getParameter("contractId");
if (contractId == null) contractId ="";

List partyList = null;
List partyList_dep=null;
List ptList=null;
List pcList=null;
List userLoginList=null;
List costCenterList=null;

int i=1;
ContractProfile CustProject = (ContractProfile)request.getAttribute("CustProject");

String hasProject = (String)request.getAttribute("hasProject");

UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);

PartyHelper ph = new PartyHelper();
partyList = ph.getAllCustomers(hs);

partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
if (partyList_dep == null) partyList_dep = new ArrayList();
partyList_dep.add(0,ul.getParty());
UserLoginHelper ulh = new UserLoginHelper();
userLoginList = ulh.getAllUser(hs);

ProjectHelper phh = new ProjectHelper();
List CurrencyList = phh.getAllCurrency(hs);
if(CurrencyList==null){
	CurrencyList = new ArrayList();
}
Iterator itCurr = CurrencyList.iterator();
String rateStr = "";
while(itCurr.hasNext()){
	CurrencyType curr = (CurrencyType)itCurr.next();
	rateStr = rateStr+curr.getCurrRate().toString()+"$";
}
String startDate = "";
String endDate = "";
String signedDate = "";
String legalReviewDate = "";
if (CustProject!=null){
	java.util.Date startdate = CustProject.getStartDate();
	
	if(CustProject.getStartDate()!=null){
		
	    startDate=formater.format(CustProject.getStartDate());
	    
	}
	java.util.Date enddate = CustProject.getEndDate();
	
	if(enddate!=null){
	    endDate=formater.format(enddate);
	}
	java.util.Date signeddate = CustProject.getSignedDate();
	
	if(signeddate!=null){
	    signedDate=formater.format(signeddate);
	}
	
	java.util.Date legalReviewdate = CustProject.getLegalReviewDate();
	if (legalReviewdate != null) {
		legalReviewDate = formater.format(legalReviewdate);
	}
}
	
String action = request.getParameter("action");
if(action == null){
	action = "create";
}
%>
<script language="javascript">
function refresh() {
	var displayRows = document.getElementById("displayRows").value;
	window.location = "editContractProject.do?contractId=<%=contractId%>&displayRows="+displayRows;
}
function FnDelete() {
	if (confirm("Do you want delete this contract?")) {
		document.EditForm.FormAction.value = "delete";
		document.EditForm.submit();
	}
}
function FnUpdate() {
	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}else{
		if(document.EditForm.textStatus.value == "Signed"){
    		if(document.EditForm.signedDate.value == ""){
    			alert("You must input signed date");
    			return;
    		}
    	}
	    if(validate()&& validateSignDate()){
			document.EditForm.FormAction.value = "update";
			document.EditForm.submit();
		  }

	}
}
function FnCancel() {
    if (confirm("Do you want cancel this contract?")) {
		document.EditForm.FormAction.value = "cancel";
		document.EditForm.submit();
	}
}
function FnClosed() {
    if (confirm("Do you want close this contract?")) {
		document.EditForm.FormAction.value = "closed";
		document.EditForm.submit();
	}
}
function FnUndoCancel() {
		document.EditForm.FormAction.value = "undoCancel";
		document.EditForm.submit();
}
function FnCreate() {
  	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{   
	      if(validate()&& validateSignDate()){
	      	document.EditForm.FormAction.value = "create";
		  	document.EditForm.submit();
		  }
	}
}

function fnCreateProject(){
	document.EditForm.action="editContractProject.do";
	document.EditForm.FormAction.value = "precreate";
	document.EditForm.submit();
}

function fieldCheck(field){
	if (field.value ==""){
		alert("You must enter at least one Service Type Name" );
	}
}
function fieldCheck1(field){
	if (field.value ==""){
		alert("You must enter at least one Milestone Name" );
	}
}
function validateSignDate(){
  if(document.EditForm.signedDate.value.length>0){
	         return dataOneCheck(document.EditForm.signedDate);
   }
   return true;
}
function validate(){
   var startDate = document.EditForm.startDate;
   var endDate = document.EditForm.endDate;
   var signedDate = document.EditForm.signedDate;
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
function ValidateData() {
	var errormessage="";
	
	if(document.EditForm.totalServiceValue.value == 0){
		errormessage="You must input the Total Contract Value";
		return errormessage;
    }
	
	if(document.EditForm.customerId.value == ""){
		errormessage="You must select a customer";
		return errormessage;
    }
	if(document.EditForm.accountManagerId.value == ""){
		errormessage="You must select a account manager";
		return errormessage;
    }    
    return errormessage;
}
function showCustomerDialog()
{
	var code,desc;
	with(document.EditForm)
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
function onCurrSelect(){
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	
	with(document.EditForm) {
		exchangeRate.value = RateArr[currency.selectedIndex];
		labelCurrencyRate.innerHTML=exchangeRate.value;
	}
}
function showBidMaster(){
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.project.contractSelect.title&ListSalesBid.do?formAction=dialogView",
	null,
	'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:no');
	if (v != null ) {
		var bidMasterId = v.split("|")[0];
		var description = v.split("|")[1];
		var salePersonId = v.split("|")[2];
		var salesPersonName = v.split("|")[3];
		var estimateAmount = v.split("|")[4];
		var exchangeRate = v.split("|")[5];
		var startDate = v.split("|")[6];
		var endDate = v.split("|")[7];
		var currencyId = v.split("|")[8];
		var departmentId = v.split("|")[9];
		var contractType = v.split("|")[13];
		var secondSalesId = v.split("|")[17];
		var secondSalesName = v.split("|")[18];
		var custName = v.split("|")[12];
		var custId = v.split("|")[18];
				
		document.getElementById("bidId").value = bidMasterId;
		document.getElementById("labelBid").innerHTML = description;
		document.getElementById("accountManagerId").value = salePersonId;
		document.getElementById("accountManagerName").value = salesPersonName;
		document.getElementById("labelAccount").innerHTML = salePersonId + ":" + salesPersonName;
		document.getElementById("totalServiceValue").value = estimateAmount;
		document.getElementById("exchangeRate").value = exchangeRate;
		document.getElementById("startDate").value = startDate;
		document.getElementById("endDate").value = endDate;
		
		document.getElementById("SalesPersonId1").value = salePersonId;
		document.getElementById("SalesPersonName1").value = salesPersonName;
		document.getElementById("labelspName1").innerHTML = salePersonId + ":" + salesPersonName;
		
		document.getElementById("customerId").value = custId;
		document.getElementById("labelCustomer").innerHTML = custId + ":" + custName;
		
		if(secondSalesId.value == null || secondSalesId.value == ""){
			document.getElementById("labelspName2").innerHTML = "";
		} else{
			document.getElementById("SalesPersonId2").value = secondSalesId;
			document.getElementById("SalesPersonName2").value = secondSalesName;
			document.getElementById("labelspName2").innerHTML = secondSalesId + ":" + secondSalesName;
		}
		
		var currency = document.getElementById("currency");
		for (var i = 0; i < currency.options.length; i++) {
			if (currency.options[i].value == currencyId) {
				currency.options[i].selected = true;
				break;
			}
		}
		
		var contract = document.getElementsByName("ContractType");
		for(var i = 0; i < contract.length; i++){
			if(contractType == contract[i].value){
				contract[i].checked = true;
			}
		}
		
		var department = document.getElementById("departmentId");
		for (var i = 0; i < department.options.length; i++) {
			if (department.options[i].value == departmentId) {
				department.options[i].selected = true;
				break;
			}
		}
	}
}
function ViewBidMaster(formAction,id){
	window.showModalDialog(
	"system.showDialog.do?title=prm.project.contractSelect.title&editBidMaster.do?formAction=" + formAction + "&id=" + id,
	null,
	'dialogWidth:800px;dialogHeight:530px;status:no;help:no;scroll:no');
}
</script>
<Form action="userList.do" name="UserListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<Form action="custList.do" name="CustListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Contract Maintenance
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
	<TD width='100%'>
<%
    if(CustProject != null){
    	boolean canceledFlg = false;
		if ("Cancel".equals(CustProject.getStatus()) || "Closed".equals(CustProject.getStatus())) {
			canceledFlg = true;
		}
		action="Update";
%>
<form action="editContractProfile.do" method="post" name="EditForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
    <input type="hidden" name="FormAction" >
    <input type="hidden" name="Id" value=<%=contractId%>>
    <input type="hidden" name="add">
    <input type="hidden" name="contractId" value="<%=CustProject.getId()%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
    <%
        if(repeatName != null && repeatName.equals("yes")){
     %>
     	<td align="left" class="lblerr" colspan="4" ><font size="3">Duplicate Contract No!!!</font></td>
     <%
     	}
     %>
      <tr>
        <td align="right">
          <span class="tabletext">Contract No.:&nbsp;</span>
        </td>
        <td>
          <%
          	if (canceledFlg) {
          %>
          <%=CustProject.getNo()%>
          <input type="hidden" name="contractNo" value="<%=CustProject.getNo()%>">
          <%
          	} else {
          %>
          <input type="text" name="contractNo" value="<%=CustProject.getNo()%>">
          <%
          	}
          %>
        </td>
        <td align="right">
          <span class="tabletext">Bid:&nbsp;</span>
        </td>
         <td align="left">
        <%
        	if(CustProject.getId()!= null && CustProject.getId().longValue() > 0){
        		if(CustProject.getBidMaster()!=null){
        			String bidDescription = CustProject.getBidMaster().getDescription();
        			Long bidId = CustProject.getBidMaster().getId();
        			String bidid = bidId + "";
        %>
        	<input type="hidden" class="inputBox" name="bidId" value="<%=bidid%>">
        	<%=bidDescription%>
        <%
        	}else{
        %>
	        &nbsp;
        <%
        	}
         }else{
        %>
        	<div style="display:inline" id="labelBid">&nbsp;</div>
	        <input type="hidden" class="inputBox" name="bidId" >
	        <a href="javascript:void(0)" onclick="showBidMaster();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
        <%
        }
        %>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Contract Description:&nbsp;</span>
        </td>
        <td align="left">
          <%
          	if (canceledFlg) {
          %>
          <%=CustProject.getDescription()%>
          <input type="hidden" class="inputBox" name="contractDes" value="<%=CustProject.getDescription()%>" size="30">
          <%
          	} else {
          %>
          <input type="text" class="inputBox" name="contractDes" value="<%=CustProject.getDescription()%>" size="30">
          <%
          	}
          %>
        </td>
        <td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
			<%
			String ContractType = CustProject.getContractType();
			if(ContractType.equals("FP")){
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"FP\" checked>Fixed Price");
				if (!canceledFlg) {
					out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"TM\">Time & Material");
			    }
			}else{
				if (!canceledFlg) {
                	out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"FP\">Fixed Price");
                }
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"TM\" checked>Time & Material");
			}
			%>
		 </td>
      </tr>
      <tr>
      	<td align="right">
          <span class="tabletext">Status:&nbsp;</span>
        </td>
        <td class="lblLight">
        	<select name="textStatus">
				<option value="Signed" <%if (CustProject.getStatus().equals("Signed")) out.print("selected");%>>Signed</option>
				<option value="Unsigned" <%if (CustProject.getStatus().equals("Unsigned")) out.print("selected");%>>Unsigned</option>
				<option value="Cancel" <%if (CustProject.getStatus().equals("Cancel")) out.print("selected");%>>Cancel</option>
		    </select>
        <td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Customer:&nbsp;</span>
        </td>
        <td align="left"><input type=hidden name="customerId" value="<%=CustProject.getCustomer().getPartyId()%>"><%=CustProject.getCustomer().getPartyId()%>:<%=CustProject.getCustomer().getDescription()%>
        </td>
        <td align="right">
          <span class="tabletext">Department:&nbsp;</span>
        </td>
        
        <td align="left">
          <select name="departmentId">
			<%
			Iterator itd = partyList_dep.iterator();
			while(itd.hasNext()){
				Party p = (Party)itd.next();
				String chk ="";
				if (p.getPartyId().equals(CustProject.getDepartment().getPartyId())){
					chk = "selected";
				}
				if (chk.trim().length() != 0 || !canceledFlg) {
			%>
			<option value="<%=p.getPartyId()%>" <%=chk%> ><%=p.getDescription()%></option>
			<%
				}
			}
			%>
		  </select>
        </td>
      </tr>
      <tr>
	    <td align="right">
          <span class="tabletext">Account Manager:&nbsp;</span>
        </td>
        <td align="left">
			<%String AMId = "";
			String AMName = "";
			if (CustProject.getAccountManager() != null) {
				AMId = CustProject.getAccountManager().getUserLoginId();
				AMName = CustProject.getAccountManager().getName();
			}
			%>
			<div style="display:inline" id="labelAccount"><%=AMName%>&nbsp;</div>
			<input type="hidden" readonly="true" name="accountManagerName" maxlength="100" value="<%=AMName%>">
			<input type="hidden" name="accountManagerId" value="<%=AMId%>">
			<%
				if (!canceledFlg) {
			%>
			<a href="javascript:showDialog_account()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
			<%
				}
			%>
        </td>
        <td align="right">
          <span class="tabletext">Signed Date:&nbsp;</span>
        </td>
        <td align="left">
        	<%
				if (canceledFlg) {
			%>
			<%=signedDate%>
			<input type="hidden" class="inputBox" name="signedDate" value="<%=signedDate%>" size="10">
			<%
				} else {
			%>
          <input type="text" class="inputBox" name="signedDate" value="<%=signedDate%>" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg6,document.EditForm.signedDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg6 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
		 
		  	<%
				}
			%>
        </td>
      </tr>
	  
      <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
        <td align="left">
        	<%
				if (canceledFlg) {
			%>
			<%=startDate%>
			<input type="hidden" class="inputBox" name="startDate" value="<%=startDate%>" size="10">
			<%
				} else {
			%>
          <input type="text" class="inputBox" name="startDate" value="<%=startDate%>" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg1,document.EditForm.startDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
			<%
				}
			%>
        </td>
        <td align="right">
          <span class="tabletext">End Date:&nbsp;</span>
        </td>
        <td align="left">
        	<%
				if (canceledFlg) {
			%>
			<%=endDate%>
			<input type="hidden" class="inputBox" name="endDate" value="<%=endDate%>" size="10">
			<%
				} else {
			%>
          <input type="text" class="inputBox" name="endDate" value="<%=endDate%>" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg2,document.EditForm.endDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
			<%
				}
			%>
        </td>
      </tr>
      <tr>
      	 <td align="right">
          <span class="tabletext">11Total Contract Value(RMB):&nbsp;</span>
        </td>
        <td>
        	<%
				if (canceledFlg) {
			%>
			<%=CustProject.getTotalContractValue() != null ? Num_formater.format(CustProject.getTotalContractValue().doubleValue()) : ""%>
          	<input type="hidden" class="inputBox" name="totalServiceValue" value="<%=CustProject.getTotalContractValue() != null ? Num_formater.format(CustProject.getTotalContractValue().doubleValue()) : ""%>">
          	<%
				} else {
			%>
			<input type="text" class="inputBox" name="totalServiceValue" value="<%=CustProject.getTotalContractValue() != null ? Num_formater.format(CustProject.getTotalContractValue().doubleValue()) : ""%>" size="30" onblur="checkDeciNumber2(this,1,1,'totalServiceValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
			<%
				}
			%>
        </td>
        <td align="right">
          <span class="tabletext">Customer Paid Allowance Rate:&nbsp;</span>
        </td>
     	 <td align="left">
     	 	<%
				if (canceledFlg) {
			%>
			<%=CustProject.getCustPaidAllowance() != null ? Num_formater.format(CustProject.getCustPaidAllowance()) : ""%>
			<input type="hidden" class="inputBox" name="alownceAmt" value="<%=CustProject.getCustPaidAllowance() != null ? Num_formater.format(CustProject.getCustPaidAllowance()) : ""%>">
			<%
				} else {
			%>
          	<input type="text" class="inputBox" name="alownceAmt" value="<%=CustProject.getCustPaidAllowance() != null ? Num_formater.format(CustProject.getCustPaidAllowance()) : ""%>" size="30" onblur="checkDeciNumber2(this,1,1,'alownceAmt',-9999999,9999999); addComma(this, '.', '.', ',');">
          	<%
				}
			%>
        </td>
        
      </tr>
      <tr>
        <td class="tabletext" align=right>Currency:</td>
				<td class="lblLight">
					<select name="currency" onchange="javascript:onCurrSelect()">
					<%
					itCurr = CurrencyList.iterator();
					float CurrencyRate = 0;
					while(itCurr.hasNext()){
						CurrencyType curr = (CurrencyType)itCurr.next();
						if(curr.getCurrId().equals(CustProject.getCurrency().getCurrId())){
							CurrencyRate = curr.getCurrRate().floatValue();
							out.println("<option value=\""+curr.getCurrId()+"\" selected>"+curr.getCurrName()+"</option>");
						}else{
							out.println("<option value=\""+curr.getCurrId()+"\">"+curr.getCurrName()+"</option>");
						}
					}
					%>
					</select>
				</td>
				<td class="tabletext" align=right>Exchange Rate(RMB):</td>
				<td class="lblLight">
					<div style="display:inline" id="labelCurrencyRate"><%=CurrencyRate%></div><input type=hidden name="exchangeRate" value="<%=CurrencyRate%>">
			</td>
      </tr>
      
      <tr>
      	<td align="right">
          <span class="tabletext">Legal Review Date:</span>
        </td>
        <td align="left">
        	<%
				if (canceledFlg) {
			%>
			<%=endDate%>
			<input type="hidden" class="inputBox" name="legalReviewDate" value="<%=legalReviewDate%>" size="10">
			<%
				} else {
			%>
          <input type="text" class="inputBox" name="legalReviewDate" value="<%=legalReviewDate%>" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg20,document.EditForm.legalReviewDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg20 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
			<%
				}
			%>
        </td>
        <td align="right">
          <span class="tabletext">Customer Sat.:</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="custSat" value="<%= CustProject.getCustomerSat()==null ? "" : CustProject.getCustomerSat()%>" size="20" onblur="checkDeciNumber2(this,1,1,'custSat',0,5);">
        </td>
      </tr>
        <tr>
	    <td align="right">
          <span class="tabletext">Sales Person 1:&nbsp;</span>
        </td>
        <td align="left">
			<%String spId1 = "";
			String spName1 = "";
			if (CustProject.getSalesPerson1() != null) {
				spId1 = CustProject.getSalesPerson1().getUserLoginId();
				spName1 = CustProject.getSalesPerson1().getName();
			}
			%>
			<div style="display:inline" id="labelspName1"><%=spName1%>&nbsp;</div>
			<input type="hidden" readonly="true" name="SalesPersonName1" maxlength="100" value="<%=spName1%>">
			<input type="hidden" name="SalesPersonId1" value="<%=spId1%>">
			<%
				if (!canceledFlg) {
			%>
			<a href="javascript:showDialog_SalesPerson1()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
			<%
				}
			%>
        </td>
        <td align="right">
          <span class="tabletext">Sales Person 2:&nbsp;</span>
        </td>
        <td align="left">
			<%String spId2 = "";
			String spName2 = "";
			if (CustProject.getSalesPerson2() != null) {
				spId2 = CustProject.getSalesPerson2().getUserLoginId();
				spName2= CustProject.getSalesPerson2().getName();
			}
			%>
			<div style="display:inline" id="labelspName2"><%=spName2%>&nbsp;</div>
			<input type="hidden" readonly="true" name="SalesPersonName2" maxlength="100" value="<%=spName2%>">
			<input type="hidden" name="SalesPersonId2" value="<%=spId2%>">
			<%
				if (!canceledFlg) {
			%>
			<a href="javascript:showDialog_SalesPerson2()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
			<%
				}
			%>
        </td>
      </tr>
      <tr>
	    <td align="right">
          <span class="tabletext">Comments:&nbsp;</span>
        </td>
        <td colspan=5>
      		<TEXTAREA NAME="contractComments" ROWS="5" COLS="90"><%if (CustProject.getComments()!= null) out.print(CustProject.getComments());%></TEXTAREA>
      	</td>
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
      <%
      	if(CustProject.getId()!= null && CustProject.getId().longValue() > 0){
			if (!canceledFlg) {
			
		%>
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<%
			if (CustProject.getStatus().equals(Constants.CONTRACT_PROFILE_STATUS_UNSIGNED)) {
		%>
		<input type="button" value="Cancel" class="loginButton" onclick="javascript:FnCancel();"/>
		<%
			}
		%>
		<%
			if (CustProject.getStatus().equals(Constants.CONTRACT_PROFILE_STATUS_SIGNED)) {
		%>
		<input type="button" value="Closed" class="loginButton" onclick="javascript:FnClosed();"/>
		<%
			}
		%>
		
		<%
			if ("false".equals(hasProject)) {
		%>
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();"/>
		<input type="button" value="Create Project" class="loginButton" onclick="javascript:fnCreateProject();"/>
		<%
			}
		%>
		<%
			}
		%>
		<%
			if (CustProject.getStatus().equals(Constants.CONTRACT_PROFILE_STATUS_CANCEL)) {
		%>
		<input type="button" value="Undo Cancel" class="loginButton" onclick="javascript:FnUndoCancel();"/>
		<%
			}
		}else{
		%>
			<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();return false"/>
		<%
			}
		%>
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('findContractProfile.do')">
		</td>      
		<td></td>
	    <td align="center">
		</td>
      </tr> 
    </table>
	</td>
  </tr>
</table>
<br>

</form>
<%
	}else{
%>
	<form action="editContractProfile.do" method="post" name="EditForm">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
		marginWidth=0 noResize 
		scrolling=no src="includes/date/calendar.htm" 
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
    <input type="hidden" name="FormAction" value="<%=action%>">
	
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
        <td align="right">
          <span class="tabletext">Contract No.:&nbsp;</span>
        </td>
        <td>
          <input type="text" name="contractNo" value="">
        </td>
        <td align="right">
          <span class="tabletext">Bid:&nbsp;</span>
        </td>
        <td align="left">
          <div style="display:inline" id="labelBid">&nbsp;</div>
          <input type="hidden" class="inputBox" name="bidId" >
          <a href="javascript:void(0)" onclick="showBidMaster();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Contract Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="contractDes" value="" size="30">
        </td>
        <td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
			<input TYPE="RADIO" class="radiostyle" NAME="ContractType" VALUE="FP" checked>Fixed Price
			<input TYPE="RADIO" class="radiostyle" NAME="ContractType" VALUE="TM">Time & Material
		 </td>
      </tr>
      
      <tr>
        <td align="right">
          <span class="tabletext">Customer:&nbsp;</span>
        </td>
        <td align="left">
        	<div style="display:inline" id="labelCustomer">&nbsp;</div>
        	<input type=hidden name="customerId"><a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
		</td>
        <td align="right">
          <span class="tabletext">Department:&nbsp;</span>
        </td>
        <td align="left">
          <select name="departmentId">
			<%
			Iterator itd = partyList_dep.iterator();
			while(itd.hasNext()){
				Party p = (Party)itd.next();
			%>
			<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
			<%
			}
			%>
		  </select>
        </td>
      </tr>
      <tr>
	    <td align="right">
          <span class="tabletext">Account Manager:&nbsp;</span>
        </td>
        <td align="left">
        	<div style="display:inline" id="labelAccount">&nbsp;</div>
        	<input type=hidden name="accountManagerId">
        	<input type=hidden name="accountManagerName">
        	<a href="javascript:void(0)" onclick="showDialog_account();event.returnValue=false;">
        		<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/>
        	</a>
		</td>
        <td align="right">
          <span class="tabletext">Signed Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="signedDate" value="" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg9,document.EditForm.signedDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg9 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
		  &nbsp;&nbsp;
		  <input TYPE="checkbox" class="checkboxstyle" NAME="signedOrNot" VALUE="1" >Signed
        </td>
      </tr>
	  
      <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
         <td align="left">
          <input type="text" class="inputBox" name="startDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg8,document.EditForm.startDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg8 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
        <td align="right">
          <span class="tabletext">End Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="endDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg4,document.EditForm.endDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg4 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
      </tr>
      <tr>
      	 <td align="right">
          <span class="tabletext">Total Contract Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalServiceValue" value="0" size="30" onblur="checkDeciNumber2(this,1,1,'totalServiceValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Customer Paid Allowance Rate:&nbsp;</span>
        </td>
     	 <td align="left">
          <input type="text" class="inputBox" name="alownceAmt" value="0" size="30" onblur="checkDeciNumber2(this,1,1,'alownceAmt',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
      </tr>
      <tr>
       <td class="tabletext" align=right>Currency:</td>
		<td class="lblLight">
			<select name="currency" onchange="javascript:onCurrSelect()">
			<%
			itCurr = CurrencyList.iterator();
			float CurrencyRate = 0;
			while(itCurr.hasNext()){
				CurrencyType curr = (CurrencyType)itCurr.next();
				if(curr.getCurrId().equals("RMB")){
					CurrencyRate = curr.getCurrRate().floatValue();
					out.println("<option value=\""+curr.getCurrId()+"\" selected>"+curr.getCurrName()+"</option>");
				}else{
					out.println("<option value=\""+curr.getCurrId()+"\">"+curr.getCurrName()+"</option>");
				}
			}
			%>
			</select>
		</td>
		
		<td align="right">
          <span class="tabletext">Exchange Rate:</span>
        </td>
		<td class="lblLight">
					<div style="display:inline" id="labelCurrencyRate"><%=CurrencyRate%></div><input type=hidden name="exchangeRate" value="<%=CurrencyRate%>">
				</td>
      </tr>
      <tr>
      	<td align="right">
          <span class="tabletext">Legal Review Date:</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="legalReviewDate" value="" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg40,document.EditForm.legalReviewDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg40 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
        <td align="right">
          <span class="tabletext">Customer Sat.:</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="custSat" value="" size="20" onblur="checkDeciNumber2(this,1,1,'custSat',0,5);">
        </td>
      </tr>
       <tr>
	    <td align="right">
          <span class="tabletext">Sales Person 1:&nbsp;</span>
        </td>
        <td align="left">
			<div style="display:inline" id="labelspName1">&nbsp;</div>
			
			<input type="hidden" readonly="true" name="SalesPersonName1" maxlength="100" value="">
			<input type="hidden" name="SalesPersonId1" value="">
			
			<a href="javascript:showDialog_SalesPerson1()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
			
        </td>
        <td align="right">
          <span class="tabletext">Sales Person 2:&nbsp;</span>
        </td>
        <td align="left">
			<div style="display:inline" id="labelspName2">&nbsp;</div>
			<input type="hidden" readonly="true" name="SalesPersonName2" maxlength="100" value="">
			<input type="hidden" name="SalesPersonId2" value="">
			
			<a href="javascript:showDialog_SalesPerson2()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
			
        </td>
      </tr>
      <tr>
	    <td align="right">
          <span class="tabletext">Comments:&nbsp;</span>
        </td>
        <td colspan=5>
      		<TEXTAREA NAME="contractComments" ROWS="5" COLS="90"></TEXTAREA>
      	</td>
      <tr>
	  <tr><td>&nbsp;</td></tr>
	  <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();return false"/>
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('findContractProfile.do')">
        </td>
       </form>
		<td></td>
	    <td align="center">
		
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<%
	}
	Hibernate2Session.closeSession();
}else{
	out.println("你没有权限访问!");
}
}catch(Exception e){
	e.printStackTrace();
}
%>

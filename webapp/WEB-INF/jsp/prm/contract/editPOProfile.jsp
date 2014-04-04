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
/*
function showDialog_staff() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.EditForm.projectManagerId.value=v.split("|")[0];
			document.EditForm.projectManagerName.value=v.split("|")[1];			
	}
}*/
function showDialog_staff()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelPM.innerHTML=code+":"+desc;
			projectManagerId.value=code;
		} else {
			labelPM.innerHTML="";
			projectManagerId.value="";
		}
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
if (AOFSECURITY.hasEntityPermission("PO_PROFILE", "_CREATE", session)) {
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
NumberFormat Num_formater2 = NumberFormat.getInstance();
Num_formater2.setMaximumFractionDigits(5);
Num_formater2.setMinimumFractionDigits(2);
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");

String contractId = request.getParameter("contractId");
if (contractId == null) contractId ="";

String repeatName =(String)request.getAttribute("repeatName");

List partyList = null;
List partyList_dep=null;
List ptList=null;
List pcList=null;
List userLoginList=null;
List costCenterList=null;

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
int i=1;
POProfile CustProject = (POProfile)request.getAttribute("CustProject");
//String hasProjectFlag = request.getParameter("hasProjectFlag");
String hasProjectFlag = (String)request.getAttribute("hasProjectFlag");

	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	
	PartyHelper ph = new PartyHelper();
	partyList = ph.getAllCustomers(hs);
	
	partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
	if (partyList_dep == null) partyList_dep = new ArrayList();
	partyList_dep.add(0,ul.getParty());
	UserLoginHelper ulh = new UserLoginHelper();
	userLoginList = ulh.getAllUser(hs);

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
	if (confirm("Do you want delete this PO?")) {
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
    			errormessage="You must input signed date";
    			alert( errormessage);
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
    if (confirm("Do you want cancel this PO?")) {
		document.EditForm.FormAction.value = "cancel";
		document.EditForm.submit();
	}
}
function FnCreate() {
	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}else{	   
		if(validate()&& validateSignDate()){
			document.EditForm.FormAction.value = "create";
		  	document.EditForm.submit();
		  }
	}
}

function fnCreateProject(){
	document.EditForm.action="editPOProject.do";
	document.EditForm.FormAction.value = "precreate";
	document.EditForm.submit();
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
	
	var linkContractId = document.EditForm.linkContractId.value;
    if (linkContractId == "") {
    	errormessage="You must select Link Contract No";
       return errormessage;
    }
   
	if(document.EditForm.totalServiceValue.value == 0)
	{
		errormessage="You must input the Total PO Value";
		return errormessage;
    }
	
	if(document.EditForm.vendorId.value == "")
	{
		errormessage="You must select a vendor";
		return errormessage;
    }
	if(document.EditForm.accountManagerId.value == "")
	{
		errormessage="You must select a account manager";
		return errormessage;
    }    
    return errormessage;
}
function showVendorDialog()
{
	var code,desc;
	with(document.EditForm)
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

function showDialog_contract()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&findContractProfile.do?formAction=dialogView",
			null,
			'dialogWidth:800px;dialogHeight:530px;status:no;help:no;scroll:no');
		if (v != null) {
			id=v.split("|")[0];
			code=v.split("|")[1];
			desc=v.split("|")[2];
			labelLCNo.innerHTML=code+":"+desc;
			linkContractId.value=id;
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
</script>
<Form action="userList.do" name="UserListForm" method="post">
	<input type="hidden" name="CALLBACKNAME" id="CALLBACKNAME">
</Form>
<Form action="custList.do" name="CustListForm" method="post">
	<input type="hidden" name="CALLBACKNAME" id="CALLBACKNAME">
</Form>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Purchase Order Maintenance
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
		if ("Cancel".equals(CustProject.getStatus())) {
			canceledFlg = true;
		}
    	action="Update";
%>
<form action="editPOProfile.do" method="post" name="EditForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
    <input type="hidden" name="FormAction" id="FormAction">
    <input type="hidden" name="Id" id="Id" value=<%=contractId%>>
    <input type="hidden" name="add" id="add">
    <input type="hidden" name="contractId" id="contractId" value="<%=CustProject.getId()%>">
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
          <span class="tabletext">PO Code:&nbsp;</span>
        </td>
        <td>
          <%
          	if (canceledFlg) {
          %>
          <%=CustProject.getNo()%>
          <input type="hidden" name="contractNo" id="contractNo" value="<%=CustProject.getNo()%>">
          <%
          	} else {
          %>
          <input type="text" name="contractNo" id="contractNo" value="<%=CustProject.getNo()%>">
          <%
          	}
          %>
        </td>
        <td align="right">
          <span class="tabletext">Linked Contract No:&nbsp;</span>
        </td>
        <td align="left">
          <%String LCNId = "";
			String LCNNo = "";
			String LCNDES = "";
			if (CustProject.getLinkProfile() != null) {
				LCNId = "" + CustProject.getLinkProfile().getId();
				LCNNo = CustProject.getLinkProfile().getNo();
				LCNDES = CustProject.getLinkProfile().getDescription();
			}
			%>
			<div style="display:inline" id="labelLCNo"><%=LCNNo%>:<%=LCNDES%></div>
			<input type="hidden" name="linkContractNo" id="linkContractNo" maxlength="100" value="<%=LCNNo%>">
			<input type="hidden" name="linkContractId" id="linkContractId" value="<%=LCNId%>">
			<%
			  if(hasProjectFlag==null)hasProjectFlag="";
			  if(!hasProjectFlag.equals("true") && !canceledFlg){
			%>
          	<a href="javascript:showDialog_contract()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
            <%}
            %>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">PO Description:&nbsp;</span>
        </td>
        <td align="left">
          <%
          	if (canceledFlg) {
          %>
          <%=CustProject.getDescription()%>
           <input type="hidden" class="inputBox" name="contractDes" id="contractDes" value="<%=CustProject.getDescription()%>">
          <%
          	} else {
          %>
          <input type="text" class="inputBox" name="contractDes" id="contractDes" value="<%=CustProject.getDescription()%>" size="30">
          <%
          	}
          %>
        </td>
        <td align="right">
          <span class="tabletext">PO Type:&nbsp;</span>
        </td>
		<td align="left">
			<%String ContractType = CustProject.getContractType();
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
          <span class="tabletext">Vendor:&nbsp;</span>
        </td>
        <td align="left">
        	<input type="hidden" name="vendorId" id="vendorId" value="<%=CustProject.getVendor().getPartyId()%>">
        	<%=CustProject.getVendor().getPartyId()%>:<%=CustProject.getVendor().getDescription()%>
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
				if (p.getPartyId().equals(CustProject.getDepartment().getPartyId())) {
					chk = "selected";
				}
				
				if (!canceledFlg || chk.trim().length() != 0) {
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
			<input type="hidden" readonly="true" name="accountManagerName" id="accountManagerName" maxlength="100" value="<%=AMName%>">
			<input type="hidden" name="accountManagerId" id="accountManagerId" value="<%=AMId%>">
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
          <input type="hidden" class="inputBox" name="signedDate" id="signedDate" value="<%=signedDate%>">
          <%
          	} else {
          %>
          <input type="text" class="inputBox" name="signedDate" id="signedDate" value="<%=signedDate%>" size="10">
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
          <input type="hidden" class="inputBox" name="startDate" id="startDate" value="<%=startDate%>">
          <%
          	} else {
          %>
          <input type="text" class="inputBox" name="startDate" id="startDate" value="<%=startDate%>" size="10">
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
          <input type="hidden" class="inputBox" name="endDate" id="endDate" value="<%=endDate%>">
          <%
          	} else {
          %>
          <input type="text" class="inputBox" name="endDate" id="endDate" value="<%=endDate%>" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg2,document.EditForm.endDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
          <%
		  	}
		  %>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Total Contract Value(RMB):&nbsp;</span>
        </td>
        <td>
          <%
          	if (canceledFlg) {
          %>
          <%=CustProject.getTotalContractValue() != null ? Num_formater.format(CustProject.getTotalContractValue()) : ""%>
          <input type="hidden" class="inputBox" name="totalServiceValue" id="totalServiceValue" value="<%=CustProject.getTotalContractValue() != null ? Num_formater.format(CustProject.getTotalContractValue()) : ""%>">
          <%
          	} else {
          %>
          <input type="text" class="inputBox" name="totalServiceValue" id="totalServiceValue" value="<%=CustProject.getTotalContractValue() != null ? Num_formater.format(CustProject.getTotalContractValue()) : ""%>" size="30" onblur="checkDeciNumber2(this,1,1,'totalServiceValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
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
          <input type="hidden" class="inputBox" name="alownceAmt" id="alownceAmt" value="<%=CustProject.getCustPaidAllowance() != null ? Num_formater.format(CustProject.getCustPaidAllowance()) : ""%>">
          <%
          	} else {
          %>
          <input type="text" class="inputBox" name="alownceAmt" id="alownceAmt" value="<%=CustProject.getCustPaidAllowance() != null ? Num_formater.format(CustProject.getCustPaidAllowance()) : ""%>" size="30" onblur="checkDeciNumber2(this,1,1,'alownceAmt',-9999999,9999999); addComma(this, '.', '.', ',');">
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
					<div style="display:inline" id="labelCurrencyRate"><%=CurrencyRate%></div><input type="hidden" name="exchangeRate" id="exchangeRate" value="<%=CurrencyRate%>">
			</td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Legal Review Date:&nbsp;</span>
        </td>
        <td align="left">
          <%
          	if (canceledFlg) {
          %>
          <%=startDate%>
          <input type="hidden" class="inputBox" name="legalReviewDate" id="legalReviewDate" value="<%=legalReviewDate%>">
          <%
          	} else {
          %>
          <input type="text" class="inputBox" name="legalReviewDate" id="legalReviewDate" value="<%=legalReviewDate%>" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg100,document.EditForm.legalReviewDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id="dimg100" src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
		  <%
		  	}
		  %>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
      <%
      	if(CustProject.getId()!= null && CustProject.getId().longValue()>0){
			if (!canceledFlg) {
		%>
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<%
			if (CustProject.getSignedDate() == null) {
		%>
		<input type="button" value="Cancel" class="loginButton" onclick="javascript:FnCancel();"/>
		<%
			}
		%>
		<%
			if ("false".equals(hasProjectFlag)) {
		%>
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();"/>
		<input type="button" value="Create Project" class="loginButton" onclick="javascript:fnCreateProject();"/>
		<%
			}
		%>
		<%
			}
		}else{
		%>
			<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();return false"/>
		<%
			}
		%>
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('findPurchaseOrder.do')">
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
	<form action="editPOProfile.do" method="post" name="EditForm">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
		marginWidth=0 noResize 
		scrolling=no src="includes/date/calendar.htm" 
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
    <input type="hidden" name="FormAction" id="FormAction" value="<%=action%>">
	
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
	<tr>
        <td align="right">
          <span class="tabletext">PO Code:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="contractNo" size="15">
        </td>
        <td align="right">
            <span class="tabletext">Linked Contract No:&nbsp;</span>
          </td>
          </td>
        <td align="left"><div style="display:inline" id="labelLCNo">&nbsp;</div><input type="hidden" name="linkContractId" id="linkContractId"><a href="javascript:void(0)" onclick="showDialog_contract();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
		</td>
      </tr>
	  
      <tr>  
        <td align="right">
          <span class="tabletext">PO Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="contractDes" size="30">
        </td>
        <td align="right">
          <span class="tabletext">PO Type:&nbsp;</span>
        </td>
		<td align="left">
            <input TYPE="RADIO" class="radiostyle" NAME="ContractType" VALUE="FP" CHECKED>Fixed Price
			<input TYPE="RADIO" class="radiostyle" NAME="ContractType" VALUE="TM">Time & Material
		 </td>
      </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Vendor:&nbsp;</span>
        </td>
		<td align="left"><div style="display:inline" id="labelVendor">&nbsp;</div><input type="hidden" name="vendorId" id="vendorId"><a href="javascript:void(0)" onclick="showVendorDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
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
        <td align="left"><div style="display:inline" id="labelAccount">&nbsp;</div><input type="hidden" name="accountManagerId" id="accountManagerId"><a href="javascript:void(0)" onclick="showDialog_account();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
		</td>
        <td align="right">
          <span class="tabletext">Signed Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="signedDate" value="" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg6,document.EditForm.signedDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg6 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
		  &nbsp;&nbsp;
		  <input TYPE="checkbox" class="checkboxstyle" NAME="signedOrNot" VALUE="1" >Signed or Not
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
          <span class="tabletext">Total PO Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalServiceValue"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'totalServiceValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Customer Paid Allowance Rate:&nbsp;</span>
        </td>
     	 <td align="left">
          <input type="text" class="inputBox" name="alownceAmt" value="0" size="30" value="0" onblur="checkDeciNumber2(this,1,1,'alownceAmt',-9999999,9999999); addComma(this, '.', '.', ',');">
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
					<div style="display:inline" id="labelCurrencyRate"><%=CurrencyRate%></div><input type="hidden" name="exchangeRate" id="exchangeRate" value="<%=CurrencyRate%>">
				</td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Legal Review Date:&nbsp;</span>
        </td>
         <td align="left">
          <input type="text" class="inputBox" name="legalReviewDate" value="" size="10">
          <A href="javascript:ShowCalendar(document.EditForm.dimg80,document.EditForm.legalReviewDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg80 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
      </tr>
	  <tr><td>&nbsp;</td></tr>
	  <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();return false"/>
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('findPurchaseOrder.do')">
        </td>
       </form>
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

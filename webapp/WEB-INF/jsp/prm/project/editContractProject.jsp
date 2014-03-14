<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.component.prm.contract.ContractProfile"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="net.sf.hibernate.type.*"%>
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
			labelPM.innerHTML=document.EditForm.projectManagerName.value;	
	}
}

function showDialog_pa() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.EditForm.paId.value=v.split("|")[0];
			document.EditForm.projectAssistantName.value=v.split("|")[1];	
			document.getElementById("labelAssistant").innerHTML=v.split("|")[0] + ":" + v.split("|")[1]; 		
	}
}
function showDialog_contract() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.project.contractSelect.title&findContractProfile.do?formAction=dialogView",
	null,
	'dialogWidth:800px;dialogHeight:530px;status:no;help:no;scroll:no');
	if (v != null ) {
		var contractId = v.split("|")[0];
		var contractNo = v.split("|")[1];
		var description = v.split("|")[2];
		var departmentId = v.split("|")[3];
		//var projectManagerId = v.split("|")[4];
		//svar projectManagerName = v.split("|")[5];
		var totalContractValue = v.split("|")[4];
		var contractType = v.split("|")[5];
		//var needCAF = v.split("|")[6];
		var startDate = v.split("|")[6];
		var endDate = v.split("|")[7];
		var custPaidAllowance = v.split("|")[8];
		var customerId = v.split("|")[9];
		var customerName = v.split("|")[10];
		var comments = v.split("|")[11];
	//	alert(comments);
		document.getElementById("contractId").value = contractId;
		document.getElementById("contractNo").value = contractNo;
		//document.getElementById("labelContract").innerHTML = contractNo;
		document.getElementById("projName").value = description;
		var department = document.getElementById("departmentId");
		for (var i = 0; i < department.options.length; i++) {
			if (department.options[i].value == departmentId) {
				department.options[i].selected = true;
				break;
			}
		}
		//document.getElementById("projectManagerName").value = projectManagerName;
		//document.getElementById("projectManagerId").value = projectManagerId;
		document.getElementById("totalServiceValue").value = totalContractValue;
		var oCom = document.getElementsByName("contractComments");
		if(v.split("|")[11] != "null"){
			if(comments.length>1){
				oCom[0].value = comments;}
		}
		addComma(document.getElementById("totalServiceValue"), '.', '.', ',');
		var contractType1 = document.getElementsByName("ContractType");
		for (var i = 0; i < contractType1.length; i++) {
			if (contractType1[i].value == contractType) {
				contractType1[i].checked = true;
				break;
			}
		}
		//var CAFFlag = document.getElementsByName("CAFFlag");
		//for (var i = 0; i < CAFFlag.length; i++) {
			//if (CAFFlag[i].value == needCAF) {
				//CAFFlag[i].checked = true;
				//break;
			//}
		//}
		document.getElementById("startDate").value = startDate;
		document.getElementById("endDate").value = endDate;
		document.getElementById("alownceAmt").value = custPaidAllowance;
		document.getElementById("customerId").value = customerId;
		document.getElementById("labelCustomer").innerHTML =customerId+":"+customerName;
		document.getElementById("billToId").value = customerId;
		document.getElementById("labelBillTo").innerHTML = customerName;
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
function showProjectDetail(DataId) {
	v = window.showModalDialog(
		"system.showDialog.do?title=prm.project.projectDetail.title&editContractProject.do?FormAction=dialogView&DataId="+DataId,
		null,
		'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:no');
}
</SCRIPT>
<%
try{
if (AOFSECURITY.hasEntityPermission("CUST_CONT_PROJECT", "_CREATE", session)) {
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

String DataId = request.getParameter("DataId");
if (DataId == null) DataId ="";

String repeatName =(String)request.getAttribute("repeatName");

List partyList = null;
List partyList_dep=null;
List ptList=null;
List pcList=null;
List userLoginList=null;
List costCenterList=null;

int i=1;
ProjectMaster CustProject = (ProjectMaster)request.getAttribute("CustProject");
List ServiceTypeList = (List)request.getAttribute("ServiceTypeList");
Hashtable trtable =	(Hashtable)request.getAttribute("Hashtable");

String contractId = null;
String contractNo = null;
String projName = null;
String departmentId = null;
String totalServiceValue = null;
String contractType = null;
String startDate = null;
String endDate = null;
String alownceAmt = null;
String customerId = null;
String customerName = null;
String customerDesc = null;

ContractProfile contract = (ContractProfile)request.getAttribute("contract");

if(contract != null){

	contractId = contract.getId().toString();
	if(contractId == null){
		contractId = "";
	}
	
	contractNo = contract.getNo();
	if(contractNo == null){
		contractNo = "";
	}
	
	projName = contract.getDescription();
	if(projName == null){
		projName = "";
	}
	
	departmentId = contract.getDepartment().getPartyId();
	if(departmentId == null){
		departmentId = "";
	}
	
	totalServiceValue = contract.getTotalContractValue().toString();
	if(totalServiceValue == null){
		totalServiceValue = "0";
	}
	
	contractType = contract.getContractType();
	if(contractType == null){
		contractType = "";
	}
	
	startDate = formater.format(contract.getStartDate());
	if(startDate == null){
		startDate = "";
	}
	
	endDate = formater.format(contract.getEndDate());
	if(endDate == null){
		endDate = "";
	}
	
	alownceAmt = contract.getCustPaidAllowance().toString();
	if(alownceAmt == null){
		alownceAmt = "0";
	}
	
	customerId = contract.getCustomer().getPartyId();
	if(customerId == null){
		customerId = "";
	}
	
	customerName = contract.getCustomer().getDescription();
	if(customerName == null){
		customerName = "";
	}
	
	customerDesc = customerId + ":" + customerName;
	if((customerId == null || customerId.equals("")) || (customerName == null || customerName.equals(""))){
		customerDesc = "";
	}
}

if(ServiceTypeList==null){
	ServiceTypeList = new ArrayList();
}

if(trtable==null){
	trtable = new Hashtable();
}
	PartyHelper ph = new PartyHelper();
	partyList = ph.getAllCustomers(hs);
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
	if (partyList_dep == null) partyList_dep = new ArrayList();
	partyList_dep.add(0,ul.getParty());
	UserLoginHelper ulh = new UserLoginHelper();
	userLoginList = ulh.getAllUser(hs);
	//get all project type
	ProjectHelper proh= new ProjectHelper();
	ptList=proh.getAllProjectType(hs);
	pcList=proh.getAllProjectCategory(hs);

String action = request.getParameter("action");
if(action == null){
	action = "create";
}
%>
<script language="javascript">
function refresh() {
	var displayRows = document.getElementById("displayRows").value;
	window.location = "editContractProject.do?DataId=<%=DataId%>&displayRows="+displayRows;
}
function FnDelete() {
	if (confirm("Do you want delete this project?")) {
		document.EditForm.FormAction.value = "delete";
		document.EditForm.submit();
	}
}
function FnUpdate() {
	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{
	    if(validate()){
			document.EditForm.FormAction.value = "update";
			document.EditForm.submit();
		  }
	}
}
function FnCreate() {
	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{
		if(validate()){
			document.EditForm.FormAction.value = "create";
		  	document.EditForm.submit();
		  }
	}
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
function fieldCheck2(field){
	if (field.value ==""){
		alert("You must enter at least one type description" );
	}
}
function ValidateData() {
	var errormessage="";
	if(document.EditForm.customerId.value == "")
	{
		errormessage="You must select a customer";
		return errormessage;
    }
    if(document.EditForm.contractNo.value == "")
	{
		errormessage="You must select a contractNo";
		return errormessage;
    }
	if(document.EditForm.projectManagerId.value == "")
	{
		errormessage="You must select a project manager";
		return errormessage;
    }
    return errormessage;
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
			
			if (billToId.value == "") {
				labelBillTo.innerHTML=code+":"+desc;
				billToId.value=code;
			}
		}
	}
}
function showVendorDialog()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogVendorList.do",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
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
function showBillToDialog()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelBillTo.innerHTML=code+":"+desc;
			billToId.value=code;
		}
	}
}
function showProjectDialog()
{
	var code,desc;
	with(document.EditForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&projectList.do?projProfileType=C",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelParentProject.innerHTML= "<a href=\"#\" onclick=\"showProjectDetail('"+code+"');\">" + code+":"+desc+"</a>";
			ParentProjectId.value=code;
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
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Contract Project Maintenance
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
	<TD width='100%'>
<%
    if(CustProject != null){
    	action="Update";
%>
<form action="editContractProject.do" method="post" name="EditForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
    <input type="hidden" name="FormAction">
    <input type="hidden" name="Id" value=<%=DataId%>>
    <input type="hidden" name="add">
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
          <span class="tabletext">Project Code:&nbsp;</span>
        </td>
        <td>
        <%
        if(repeatName != null && repeatName.equals("yes")){
     	%>
          <input type="text" class="inputBox" name="DataId" size="30" value="<%=CustProject.getProjId()%>">
         <%
         	}else{
         %>
          <span class="tabletext"><%=CustProject.getProjId()%>&nbsp;</span><input type="hidden" name="DataId" value="<%=CustProject.getProjId()%>">
        <%
        	}
        %>
        </td>
        <td align="right">
          <span class="tabletext">Project Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="projName" value="<%=CustProject.getProjName()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Project Status:&nbsp;</span>
        </td>
        <td align="left">
          <select name="projectStatus">
			<option value="WIP" <%if (CustProject.getProjStatus().equals("WIP")) out.println("selected");%>>WIP</option>
			<option value="PC" <%if (CustProject.getProjStatus().equals("PC")) out.println("selected");%>>Project Completed</option>
			<option value="Close" <%if (CustProject.getProjStatus().equals("Close")) out.println("selected");%>>Close</option>
			
		  </select>
        </td>
		<td align="right">
          <span class="tabletext">Contract No:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="contractNo" value="<%=CustProject.getContractNo()%>" size="30">
          <input type="hidden" class="inputBox" name="contractId" value="<%=CustProject.getContract() != null ? CustProject.getContract().getId() + "" : ""%>">
          <a href="javascript:showDialog_contract()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Customer:&nbsp;</span>
        </td>
        
        <td align="left">
        <%
        	String id = "";
			String name = "";
			if (CustProject.getCustomer() != null) {
				id = CustProject.getCustomer().getPartyId();
				name = CustProject.getCustomer().getDescription();
			}
			if(repeatName != null && repeatName.equals("yes")){
     	%>
          <div style="display:inline" id="labelCustomer"><%=name%>&nbsp;</div>
          <input type=hidden name="customerId" value = "<%=id%>">
          <a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
         <%        	
         	}else{
         %>
          <div style="display:inline" id="labelCustomer"><%=CustProject.getCustomer().getPartyId()%>:<%=CustProject.getCustomer().getDescription()%></div>
          <input type=hidden name="customerId" value="<%=CustProject.getCustomer().getPartyId()%>">
        <%
        	}
        %>
        
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
			%>
			<option value="<%=p.getPartyId()%>" <%=chk%> ><%=p.getDescription()%></option>
			<%
			}
			%>
		  </select>
        </td>
      </tr>
         <tr>
        <td align="right">
          <span class="tabletext">Project Manager:&nbsp;</span>
        </td>
        <td align="left">
        	
			<%String PMId = "";
			String PMName = "";
			if (CustProject.getProjectManager() != null) {
				PMId = CustProject.getProjectManager().getUserLoginId();
				PMName = CustProject.getProjectManager().getName();
			}
			%>
			<div style="display:inline" id="labelPM"><%=PMName%>&nbsp;</div>
			<input type="hidden" name="projectManagerName" maxlength="100" value="<%=PMName%>">
			<input type="hidden" name="projectManagerId" value="<%=PMId%>">
			<a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>
         <td align="right">
          <span class="tabletext"> Open for All:&nbsp;</span>
        </td>
		<td border='0' align="left">
         <%	String PublicFlag = CustProject.getPublicFlag();
			if(PublicFlag.equals("Y")){
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"PublicFlag\" VALUE=\"Y\" CHECKED>Yes");
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"PublicFlag\" VALUE=\"N\">No");
			}else{
                out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"PublicFlag\" VALUE=\"Y\" >Yes");
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"PublicFlag\" VALUE=\"N\" checked>No");
			}
		  %>
		 </td>
	  </tr>	 
      <tr>
        <td align="right">
          <span class="tabletext">Total Service Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalServiceValue" value="<%=Num_formater.format(CustProject.gettotalServiceValue().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'totalServiceValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
		<td align="right">
          <span class="tabletext">Total Proc./Sub Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalLicsValue" value="<%=Num_formater.format(CustProject.gettotalLicsValue().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'totalLicsValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
      </tr> 
      <tr>
        <td align="right">
          <span class="tabletext">Service Budget(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="PSCBudget" value="<%=Num_formater.format(CustProject.getPSCBudget().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'PSCBudget',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Expense Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="EXPBudget" value="<%=Num_formater.format(CustProject.getEXPBudget().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'EXPBudget',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Proc./Sub Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="procBudget" value="<%=Num_formater.format(CustProject.getProcBudget().doubleValue())%>" size="30" onblur="checkDeciNumber2(this,1,1,'procBudget',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
		<td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
			<%String ContractType = CustProject.getContractType();
			if(ContractType.equals("FP")){
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"FP\" checked>Fixed Price");
				if(repeatName != null && repeatName.equals("yes")){
				 	out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"TM\" >Time & Material");
				 }
			}else{
				if(repeatName != null && repeatName.equals("yes")){
                	out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"FP\" >Fixed Price");
                }
				out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"ContractType\" VALUE=\"TM\" checked>Time & Material");
			}
			%>
		 </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Need CAF:&nbsp;</span>
        </td>
        <td align="left">
        	<%String CAFFlag = CustProject.getCAFFlag();%>
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="Y" <%if(CAFFlag.equals("Y")) out.print("CHECKED");%>>Yes
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="N" <%if(CAFFlag.equals("N")) out.print("CHECKED");%>>No
	    </td>
        <td align="right">
          <span class="tabletext">Parent Project:&nbsp;</span>
        </td>
		<td align="left">
		<%String ProjId = "";
		String ProjName = "";
		if (CustProject.getParentProject() != null) {
			ProjId = CustProject.getParentProject().getProjId();
			ProjName = CustProject.getParentProject().getProjName();
		}
		%>
			<div style="display:inline" id="labelParentProject">
				<%
					if (CustProject.getParentProject() != null) {
				%>
				<a href="#" onclick="showProjectDetail('<%=ProjId%>');"><%=ProjId%>:<%=ProjName%>&nbsp;</a>
				<%
					}
				%>
			</div>
			<input type=hidden name="ParentProjectId" Value="<%=ProjId%>">
			<a href="javascript:void(0)" onclick="showProjectDialog();event.returnValue=false;">
				<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/>
			</a>
		</td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="startDate" value="<%=formater.format((java.util.Date)CustProject.getStartDate())%>" size="30">
          <A href="javascript:ShowCalendar(document.EditForm.dimg6,document.EditForm.startDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg6 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
        <td align="right">
          <span class="tabletext">End Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="endDate" value="<%=formater.format((java.util.Date)CustProject.getEndDate())%>" size="30">
          <A href="javascript:ShowCalendar(document.EditForm.dimg2,document.EditForm.endDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Customer Paid Allowance Rate:&nbsp;</span>
        </td>
     	 <td align="left">
          <input type="text" class="inputBox" name="alownceAmt" value="<%=Num_formater.format(CustProject.getPaidAllowance())%>" size="30" onblur="checkDeciNumber2(this,1,1,'procBudget',-9999999,9999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Project Type:&nbsp;</span>
        </td>
        <td align="left">
			<select name="projectType">
			<%
			Iterator itPt = ptList.iterator();
			while(itPt.hasNext()){
				ProjectType pp = (ProjectType)itPt.next();
				String chk ="";
				if (CustProject.getProjectType()!= null){
					if(CustProject.getProjectType().getPtId().equals(pp.getPtId()) ) chk = " selected";
				}
				out.println("<option value=\""+pp.getPtId()+"\""+chk+">"+pp.getPtName()+"</option>");
			}
			%>
			</select>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Bill To Address:&nbsp;</span>
        </td>
     	<td align="left">
          <div style="display:inline" id="labelBillTo"><%=CustProject.getBillTo().getPartyId()%>:<%=CustProject.getBillTo().getDescription()%>&nbsp;</div>
          <input type=hidden name="billToId" value="<%=CustProject.getBillTo().getPartyId()%>">
          <a href="javascript:void(0)" onclick="showBillToDialog();event.returnValue=false;">
          	<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/>
          </a>
        </td>
        
        <td align="right">
          <span class="tabletext">Project Assistant:&nbsp;</span>
        </td>
        <td align="left">
			<%
			String PAId = "";
			String PAName = "";
			if (CustProject.getProjAssistant() != null) {
				PAId = CustProject.getProjAssistant().getUserLoginId();
				PAName = CustProject.getProjAssistant().getName();
			}
			%>
			<div style="display:inline" id="labelAssistant"><%=PAId%>:<%=PAName%>&nbsp;</div>
			<input type="hidden" readonly="true" name="projectAssistantName" maxlength="100" value="<%=PAName%>">
			<input type="hidden" name="paId" value="<%=PAId%>">
			<a href="javascript:showDialog_pa()">
				<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" />
			</a>
        </td>
      </tr>
      <tr>
	        <td align="right">
	          <span class="tabletext">Contact Person:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="contact" size="30" value="<%=CustProject.getContact() == null ? "" : CustProject.getContact()%>">
	        </td>
	        <td align="right">
	          <span class="tabletext">Contact Person Tele:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="contactTele" size="30" value="<%=CustProject.getContactTele() == null ? "" : CustProject.getContactTele()%>">
	        </td>
        </tr>
        <tr>
	        <td align="right">
	          <span class="tabletext">Customer PM:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="custPM" size="30" value="<%=CustProject.getCustPM() == null ? "" : CustProject.getCustPM()%>">
	        </td>
	        <td align="right">
	          <span class="tabletext">Customer PM Tele:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="custPMTele" size="30" value="<%=CustProject.getCustPMTele() == null ? "" : CustProject.getCustPMTele()%>">
	        </td>
        </tr>
         <tr>
        <td align="right">
          <span class="tabletext">VAT:&nbsp;</span>
        </td>
        <td align="left">
			<input TYPE="RADIO" class="radiostyle" NAME="VATFlag" VALUE="Y"  <%if (CustProject.getVAT()!= null&&CustProject.getVAT().equals("Y")) out.print("CHECKED");%>>Yes
			<input TYPE="RADIO" class="radiostyle" NAME="VATFlag" VALUE="N" <%if (CustProject.getVAT()!= null&&CustProject.getVAT().equals("N")) out.print("CHECKED");%>>No
	    </td>
	     <td align="right">
          <span class="tabletext">Project Category:&nbsp;</span>
        </td>
        <%String category="";
         if (CustProject.getCategory()!= null)
         category=CustProject.getCategory();
        %>
        <td align="left">
          <select name="projectCategory">
            <option value="Project Implementation" <%if(category.equals("Project Implementation")) out.print("selected");%>>Project Implementation </option>
            <option value="Technical Support" <%if(category.equals("Technical Support")) out.print("selected");%>>Technical Support</option>
			<option value="Software" <%if(category.equals("Software")) out.print("selected");%>>Software</option>
			<option value="Hardware" <%if(category.equals("Hardware")) out.print("selected");%>>Hardware</option>
			<option value="Maintenace" <%if(category.equals("Maintenace")) out.print("selected");%>>Maintenace</option>
			<option value="Customization" <%if(category.equals("Customization")) out.print("selected");%>>Customization</option>
			<option value="Post On Site Support" <%if(category.equals("Post On Site Support")) out.print("selected");%>>Post On Site Support</option>
			<option value="Other" <%if(category.equals("Other")) out.print("selected");%>>Other</option>
		  </select>
        </td>
	    </tr>
        <tr>
	        <td align='right'>
	          Need Mail Notification for TS Approval:&nbsp;
	        </td>
	        <td> <input type='checkbox' class='checkboxstyle' name='mailFlag' <%if((CustProject.getMailFlag()!=null)&&(CustProject.getMailFlag().equals("Y"))) out.print("checked");%>> </td>	
	    	<td align="right">
	    	  Need To Renew:&nbsp;
	    	</td>
	    	<%boolean renewFlag = (CustProject.getRenewFlag().equals("Y"))?true:false;%>
	    	<td>
	    		<select name="renewFlag">
	    			<option <%if(renewFlag) out.print("selected");%> value='Y'>Yes</option>
	    			<option <%if(!renewFlag) out.print("selected");%> value='N'>No</option>
	    		</select>
	    	</td>
	    </tr>
      <tr>
        <td  align=right>
          Customer Paid Expense Type:&nbsp;
        </td>
        <td >
        <%
        	List exTypeList = hs.createQuery("select et from ExpenseType as et order by et.expSeq ASC").list();
        	java.util.Set set = CustProject.getExpenseTypes();
			if(exTypeList==null)	exTypeList = new ArrayList();
			for(int j=0; j<exTypeList.size(); j++){
			ExpenseType et = (ExpenseType)exTypeList.get(j);
			boolean checked = (set.contains(et)==true)?true:false;
			if(et.getExpAccDesc().equalsIgnoreCase("CY")){
				if(checked)
				out.println("<input type='checkbox' class='checkboxstyle' name='exTypeChk' checked='"+checked+"' value='"+et.getExpId()+"'>"+et.getExpDesc()+"&nbsp;&nbsp;");
				else
				out.println("<input type='checkbox' class='checkboxstyle' name='exTypeChk' value='"+et.getExpId()+"'>"+et.getExpDesc()+"&nbsp;&nbsp;");
				}
			}
        %>
        </td>
        <%String congroup="";
         if (CustProject.getContractGroup()!= null)
         congroup=CustProject.getContractGroup();
        %>
        <td align="right">
	        	Contract Category:
	        </td>
	        <td>
	         <select name="contractCategory">
            <option value="Labor" <%if(congroup.equalsIgnoreCase("Labor")) out.print("selected");%>>By Labor </option>
            <option value="Material"<%if(congroup.equalsIgnoreCase("Material")) out.print("selected");%>>By Material</option>
		  </select>
		 </td>
      	</tr>
      </tr>
     <tr>
     <td>&nbsp;</td>
<td>&nbsp;</td>
	 <td align =right>
      	Type:
      </td>
      <td>  <select name="duration">
	         <%if(CustProject.getDuration()!=null){%>
            <option value="onetime" <%if(CustProject.getDuration().equalsIgnoreCase("onetime")) out.print("selected");%>>One Time </option>
            <option value="recurring"<%if(CustProject.getDuration().equalsIgnoreCase("recurring")) out.print("selected");%>>Recurring</option>
            <option value="other"<%if(CustProject.getDuration().equalsIgnoreCase("other")) out.print("selected");%>>Other</option>
	         <%}else{%>
            <option value="onetime" >One Time </option>
            <option value="recurring">Recurring</option>
            <option value="other" selected>Other</option>
	         <%}%>
		  </select>
		 </td>
     </tr>
      <tr>
      	<td align=right>
      		Notes for Customer Claimed Expense:
      	</td>
      	<td colspan=3>
      		<TEXTAREA NAME="expenseNote" ROWS="3" COLS="60"><%if (CustProject.getExpenseNote()!= null) out.print(CustProject.getExpenseNote());%></TEXTAREA>
      	</td>
      </tr>  
                  <tr>
	    <td align="right">
          <span class="tabletext">Comments:&nbsp;</span>
        </td>
        <td colspan=5>
      		<TEXTAREA NAME="contractComments" ROWS="5" COLS="90"><%if (CustProject.getComments()!= null) out.print(CustProject.getComments());%></TEXTAREA>
      	</td>
            
	  <br>      
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
        <%
        	if(repeatName !=null && repeatName.equals("yes")){
        %>
        	<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();"/>
        <%
        	}else{
        %>
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();"/>
		<%
			}
		%>
		
		</td>      
		<td></td>
	    <td align="center">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listContractProject.do')">
		</td>
      </tr> 
    </table>
	</td>
  </tr>
</table>
		<%
        	if(repeatName ==null || !repeatName.equals("yes")){
        %>
<br>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='50%' class="wpsPortletTopTitle">
          <%if (ContractType.equals("TM")) {
          	out.println("Project Service Type List");
          } else {
          	out.println("Project Payment Schedule List");
          }
          %>
          </TD>
          <TD align="right" valign="center" class="wpsPortletTopTitle">
          <%
          	String displayRowsStr = request.getParameter("displayRows");
          	
          	int displayRows = 5;
          	
          	if (displayRowsStr != null) {
          		try {
          			displayRows = Integer.parseInt(displayRowsStr);
          		} catch(NumberFormatException ex) {
          		}
          	}
          	
          	int rows = ServiceTypeList.size() > displayRows ? ServiceTypeList.size() : displayRows;
          %>
          	Display Rows:&nbsp;
          	<input type="text" class="inputBox" style="text-align:right" size="2" name="displayRows" value="<%=rows%>">
          	<input type="button" name="Refresh" value="Refresh" class="loginButton" onclick="refresh();">
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
	<TD width='100%'>
		<%
		if (ContractType.equals("TM") && congroup.equalsIgnoreCase("Labor")) {%>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
			<tr>
				<td class="lblbold" nowrap width=1%>&nbsp;#&nbsp</td>
				<td class="lblbold" nowrap width=25%>&nbsp;Name&nbsp;</td>
				<td class="lblbold" nowrap width=25%>&nbsp;Rate (RMB/DAY)&nbsp;</td>
		<!--		<td class="lblbold" nowrap width=25%>&nbsp;Sub Contract Rate (RMB/DAY)&nbsp;</td>	 -->
				<td class="lblbold" nowrap width=25%>&nbsp;Estimated Man Days&nbsp;</td>
			</tr>
			<%
			Iterator itst = ServiceTypeList.iterator();
			for (int j = 0; j < rows ; j++) {
				String StId = "";
				String STDescription = "";
				double STRate = 0;
				double SubContractRate = 0;
				String EstimateManDays = "0";
				String EstimateDate = formater.format((java.util.Date)UtilDateTime.nowTimestamp());
								String textprop="";
				if (itst.hasNext()){
					ServiceType st = (ServiceType)itst.next();
					StId = st.getId().toString();
					String str=(String)trtable.get(st.getId());				
					if(str==null)
					{	
							textprop="";
					}
					else{
					if(str.equals("y")){
					textprop="ReadOnly Style='background-color:#A9A9A9'";
					}
					else
					textprop="";
					}
					STDescription = st.getDescription();
					STRate = st.getRate().doubleValue();
					if (st.getSubContractRate() != null) SubContractRate = st.getSubContractRate().doubleValue();
					EstimateManDays = st.getEstimateManDays().toString();
					if (st.getEstimateAcceptanceDate() != null) EstimateDate = formater.format(st.getEstimateAcceptanceDate());
				}%>
			<tr>
				<td class="lblbold" nowrap>&nbsp;<%=j+1%></td>
				<td class="lblbold" nowrap>&nbsp;<input type = "hidden" name = "StId" value="<%=StId%>"><input type = "text" name = "STDescription" maxlength="100" size="35"  value="<%=STDescription%>" 
				<%if ((j==0)&&(ServiceTypeList.size()==1)){%>onblur="javascript:fieldCheck(this);"<%}%>   >
				</td>
				<td class="lblbold" nowrap>&nbsp;<input type = "text" name = "STRate" maxlength="100" size="25"  value="<%=Num_formater2.format(STRate)%>" onblur="checkDeciNumber3(this,1,1,'STRate',-9999999,9999999,5); addComma(this, '.', '.', ',');">
				</td>
			<!--	<td class="lblbold" nowrap>&nbsp;<input type = "text" name = "SubContractRate" maxlength="100" size="25"   value="<%=Num_formater2.format(SubContractRate)%>" onblur="checkDeciNumber3(this,1,1,'SubContractRate',-9999999,9999999,5); addComma(this, '.', '.', ',');">	
				</td>	-->
				<td class="lblbold" nowrap>&nbsp;<input type = "text" name = "EstimateManDays" maxlength="100" size="25"   value="<%=EstimateManDays%>" onblur="checkDeciNumber2(this,1,1,'EstimateManDays',-9999999,9999999); addComma(this, '.', '.', ',');">
				</td>
				<input type = "hidden" name = "EstimateDate" value="<%=EstimateDate%>">
			</tr>
			<%}%>
		</table>
		<%} else if (ContractType.equals("FP")&& congroup.equalsIgnoreCase("Labor")){%>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
			<tr>
				<td class="lblbold" nowrap width=1%>&nbsp;#&nbsp</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Phase&nbsp;</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Contracted Service Value (RMB)&nbsp;</td>
		<!--		<td class="lblbold" nowrap width=20%>&nbsp;Contracted Sub Contract Value (RMB)&nbsp;</td>	-->
				<td class="lblbold" nowrap width=20%>&nbsp;Estimated Man Days&nbsp;</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Estimated Close Date&nbsp;</td>
			</tr>
			<%
			Iterator itst = ServiceTypeList.iterator();
			for (int j = 0; j < rows ; j++) {
				String StId = "";
				String STDescription = "";
				double STRate = 0;
				double SubContractRate = 0;
				String EstimateManDays = "0";
				String EstimateDate = formater.format((java.util.Date)UtilDateTime.nowTimestamp());
				String textprop="";
				if (itst.hasNext()){
					ServiceType st = (ServiceType)itst.next();
					StId = st.getId().toString();
					STDescription = st.getDescription();
					STRate = st.getRate().doubleValue();	
					String str=(String)trtable.get(st.getId());				
					if(str!=null){
					if(str.equals("y")){
					textprop="ReadOnly Style='background-color:#A9A9A9'";
					}
					else
					textprop="";
					}
				//	STDescription = st.getDescription();
				//	STRate = st.getRate().doubleValue();
					if (st.getSubContractRate() != null) SubContractRate = st.getSubContractRate().doubleValue();
					EstimateManDays = st.getEstimateManDays().toString();
					if (st.getEstimateAcceptanceDate() != null) EstimateDate = formater.format(st.getEstimateAcceptanceDate());
				}%>
			<tr>
				<td class="lblbold" nowrap>&nbsp;<%=j+1%></td>
				<td class="lblbold" nowrap>&nbsp;<input type = "hidden" name = "StId" value="<%=StId%>"><input type = "text" name = "STDescription" maxlength="100" size="35" <%//=textprop%> value="<%=STDescription%>" 
				 <%if ((j==0)&&(ServiceTypeList.size()==1)){%>onblur="javascript:fieldCheck1(this);"<%}%> >
				</td>
				<td class="lblbold" nowrap>&nbsp;<input type = "text" name = "STRate" maxlength="100" size="25" <%//=textprop%> value="<%=Num_formater2.format(STRate)%>" onblur="checkDeciNumber3(this,1,1,'STRate',-9999999,9999999,5); addComma(this, '.', '.', ',');">
				</td>
		<!--		<td class="lblbold" nowrap>&nbsp;<input type = "text" name = "SubContractRate" maxlength="100" size="25"  <%//=textprop%>  value="<%=Num_formater2.format(SubContractRate)%>" onblur="checkDeciNumber3(this,1,1,'SubContractRate',-9999999,9999999,5); addComma(this, '.', '.', ',');">
				</td>	-->
				<td class="lblbold" nowrap>&nbsp;<input type = "text" name = "EstimateManDays" maxlength="100" size="25"  <%//=textprop%>  value="<%=EstimateManDays%>" onblur="checkDeciNumber2(this,1,1,'EstimateManDays',-9999999,9999999); addComma(this, '.', '.', ',');">
				</td>
				<td class="lblbold" nowrap>&nbsp;<input type = "text" name = "EstimateDate" Id="EstimateDate<%=j%>" maxlength="100" size="15"   <%//=textprop%>  value="<%=EstimateDate%>">
				<%	//if((textprop.length()<2)){%>
					<A href="javascript:ShowCalendar(document.EditForm.dimd<%=j%>,document.EditForm.EstimateDate<%=j%>,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimd<%=j%> src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
				<%//}%>			
				</td>
			</tr>
			<%}%>
		</table>
		<%}else if(congroup.equalsIgnoreCase("Material")){%>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
			<tr>
				<td class="lblbold" nowrap width=1%>&nbsp;#&nbsp</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Item Description&nbsp;</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Unit Price (RMB)&nbsp;</td>
				<td class="lblbold" nowrap width=20%>&nbsp;Estimated Quantity&nbsp;</td>
		<!--		<td class="lblbold" nowrap width=20%>&nbsp;Estimated Close Date&nbsp;</td> -->
			</tr>
			<%
			Iterator itst = ServiceTypeList.iterator();
			for (int j = 0; j < rows ; j++) {
				String StId = "";
				String STDescription = "";
				double STRate = 0;
				String quantity = "0";
				if (itst.hasNext()){
					ServiceType st = (ServiceType)itst.next();
					StId = st.getId().toString();
					STDescription = st.getDescription();
					STRate = st.getRate().doubleValue();	
				
					quantity = st.getEstimateManDays().toString();
				}%>
			<tr>
				<td class="lblbold" nowrap>&nbsp;<%=j+1%></td>
				<td class="lblbold" nowrap>&nbsp;<input type = "hidden" name = "StId" value="<%=StId%>"><input type = "text" name = "STDescription" maxlength="100" size="35"  value="<%=STDescription%>" 
				 <%if ((j==0)&&(ServiceTypeList.size()==1)){%>onblur="javascript:fieldCheck2(this);"<%}%> >
				</td>
				<td class="lblbold" nowrap>&nbsp;<input type = "text" name = "STRate" maxlength="100" size="25"  value="<%=Num_formater2.format(STRate)%>" onblur="checkDeciNumber3(this,1,1,'STRate',-9999999,9999999,5); addComma(this, '.', '.', ',');">
				</td>
				<td class="lblbold" nowrap>&nbsp;<input type = "text" name = "EstimateManDays" maxlength="100" size="25"    value="<%=quantity%>" onblur="checkDeciNumber2(this,1,1,'EstimateManDays',-9999999,9999999); addComma(this, '.', '.', ',');">
				</td>
			</tr>
			<%}%>
		</table>
		<%}%>
	</td>
  </tr>
</table>
	<%
		}
	%>
</form>
<%
	}else{
		if(contract == null){
%>
	<form action="editContractProject.do" method="post" name="EditForm">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
		marginWidth=0 noResize 
		scrolling=no src="includes/date/calendar.htm" 
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
    <input type="hidden" name="FormAction" value="<%=action%>">
	<INPUT TYPE="hidden" name="projectCategory" value="C">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
	<tr>
        <td align="right">
          <span class="tabletext">Project Code:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="DataId" size="30">
        </td>
        <td align="right">
          <span class="tabletext">Project Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="projName" size="30">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Project Status:&nbsp;</span>
        </td>
        <td align="left">
          <select name="projectStatus">
			<option value="WIP">WIP</option>
			<option value="PC">Project Completed</option>
			<option value="Close">Close</option>
		  </select>
        </td>
		<td align="right">
          <span class="tabletext">Contract No:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="contractNo" size="30">
          <%
          
          %>
          <input type="hidden" class="inputBox" name="contractId">
          <a href="javascript:showDialog_contract()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>
      </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Customer:&nbsp;</span>
        </td>
		<td align="left"><div style="display:inline" id="labelCustomer">&nbsp;</div><input type=hidden name="customerId"><a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
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
          <span class="tabletext">Project Manager:&nbsp;</span>
        </td>
        <td align="left">
        	<div style="display:inline" id="labelPM">&nbsp;</div>
			<input type="hidden" name="projectManagerName"  value="">
			<input type="hidden" name="projectManagerId" value=""><a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>  
        </td>
         <td align="right">
          <span class="tabletext"> Open for All:&nbsp;</span>
        </td>
		<td align="left">
            <input TYPE="RADIO" class="radiostyle" NAME="PublicFlag" VALUE="Y">Yes
			<input TYPE="RADIO" class="radiostyle" NAME="PublicFlag" VALUE="N" CHECKED>No
		 </td>
	  </tr>	
	  <tr>
        <td align="right">
          <span class="tabletext">Total Service Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalServiceValue"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'totalServiceValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Total Proc./Sub Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalLicsValue"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'totalLicsValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Service Budget(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="PSCBudget"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'PSCBudget',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Expense Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="EXPBudget" size="30" value="0" onblur="checkDeciNumber2(this,1,1,'EXPBudget',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Proc./Sub Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="procBudget" size="30" value="0" onblur="checkDeciNumber2(this,1,1,'procBudget',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
            <input TYPE="RADIO" class="radiostyle" NAME="ContractType" VALUE="FP" CHECKED>Fixed Price
			<input TYPE="RADIO" class="radiostyle" NAME="ContractType" VALUE="TM">Time & Material
		 </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Need CAF:&nbsp;</span>
        </td>
        <td align="left">
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="Y">Yes
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="N" CHECKED>No
	    </td>
        <td align="right">
          <span class="tabletext">Parent Project:&nbsp;</span>
        </td>
		<td align="left">
			<div style="display:inline" id="labelParentProject">&nbsp;</div><input type=hidden name="ParentProjectId"><a href="javascript:void(0)" onclick="showProjectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
		</td>
      </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
         <td align="left">
          <input type="text" class="inputBox" name="startDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>" size="30">
          <A href="javascript:ShowCalendar(document.EditForm.dimg8,document.EditForm.startDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg8 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
        <td align="right">
          <span class="tabletext">End Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="endDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>">
          <A href="javascript:ShowCalendar(document.EditForm.dimg4,document.EditForm.endDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg4 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        
        </td>
      </tr>   
      <tr>
        <td align="right">
          <span class="tabletext">Customer Paid Allowance Rate:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="alownceAmt"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'alownceAmt',-9999999,9999999); addComma(this, '.', '.', ',');" >
        </td>
        <td align="right">
          <span class="tabletext">Project Type:&nbsp;</span>
        </td>
        <td align="left">
         	<select name="projectType">
			<%
			Iterator itPt = ptList.iterator();
			while(itPt.hasNext()){
				ProjectType pt = (ProjectType)itPt.next();
				%>
				<option value="<%=pt.getPtId()%>"><%=pt.getPtName()%></option>
				<%
			}
			%>
			</select>
        </td>
      </tr>   
      <tr>
        <td align="right">
          <span class="tabletext">Bill To Address:&nbsp;</span>
        </td>
     	<td align="left">
          <div style="display:inline" id="labelBillTo">&nbsp;</div>
          <input type=hidden name="billToId">
          <a href="javascript:void(0)" onclick="showBillToDialog();event.returnValue=false;">
          	<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/>
          </a>
        </td>
        <td align="right">
          <span class="tabletext">Project Assistant:&nbsp;</span>
        </td>
        <td align="left"><div style="display:inline" id="labelAssistant">&nbsp;</div>
			<input type="hidden" readonly="true" name="projectAssistantName" maxlength="100" value="">
			<input type="hidden" name="paId" value="">
			<a href="javascript:showDialog_pa()">
				<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" />
			</a>
        </td>
        </tr>
        <tr>
	        <td align="right">
	          <span class="tabletext">Contact Person:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="contact" size="30">
	        </td>
	        <td align="right">
	          <span class="tabletext">Contact Person Tele:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="contactTele" size="30">
	        </td>
        </tr>
        <tr>
	        <td align="right">
	          <span class="tabletext">Customer PM:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="custPM" size="30">
	        </td>
	        <td align="right">
	          <span class="tabletext">Customer PM Tele:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="custPMTele" size="30">
	        </td>
        </tr>
        <tr>
        <td align="right">
          <span class="tabletext">VAT:&nbsp;</span>
        </td>
        <td align="left">
			<input TYPE="RADIO" class="radiostyle" NAME="VATFlag" VALUE="Y">Yes
			<input TYPE="RADIO" class="radiostyle" NAME="VATFlag" VALUE="N" CHECKED>No
	    </td>
	    <td align="right">
          <span class="tabletext">Project Category:&nbsp;</span>
        </td>
        <td align="left">
          <select name="projectCategory">
            <option value="Project Implementation" selected>Project Implementation </option>
            <option value="Technical Support">Technical Support</option>
			<option value="Software">Software</option>
			<option value="Hardware">Hardware</option>
			<option value="Maintenace">Maintenace</option>
			<option value="Customization">Customization</option>
			<option value="Post On Site Support">Post On Site Support</option>
			<option value="Other">Other</option>
		  </select>
	    </tr>
        <tr>
	        <td align='right'>
	          Need Mail Notification for TS Approval:&nbsp;
	        </td>
	        <td> <input type='checkbox' class='checkboxstyle' name='mailFlag'> </td>
	        <td align="right">
	        	Email Notification to PM and PA:
	        </td>
	        <td><input type="checkbox" class="checkboxstyle" name="notifyPMPA" checked></td>
	    </tr>
        <tr>
        <td align='right'>
          Customer Paid Expense Type:&nbsp;
        </td>
        <td >
        <%
        	List exTypeList = hs.createQuery("select et from ExpenseType as et order by et.expSeq ASC").list();
			if(exTypeList==null)	exTypeList = new ArrayList();
			for(int j=0; j<exTypeList.size(); j++){
			if(((ExpenseType)exTypeList.get(j)).getExpAccDesc().equalsIgnoreCase("CY"))
			out.println("<input type='checkbox' class='checkboxstyle' name='exTypeChk' value='"+((ExpenseType)exTypeList.get(j)).getExpId()+"'>"+((ExpenseType)exTypeList.get(j)).getExpDesc()+"&nbsp;&nbsp;");
			}
        %>
        </td>
		<td align="right">
	        	Contract Category:
	        </td>
	        <td>
	         <select name="contractCategory">
            <option value="Labor" selected>By Labor </option>
            <option value="Material">By Material</option>
		  </select>
		</td>
      	</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td align=right>Type:</td>
	        <td>
	         <select name="duration">
            <option value="onetime" selected>One Time </option>
            <option value="recurring" >Recurring</option>
            <option value="recurring" >Other</option>
		  </select>
		 </td>
</tr>      	
       <tr>
      	<td align=right>
      		Notes for Customer Claimed Expense:
      	</td>
      	<td colspan=3>
      		<TEXTAREA NAME="expenseNote" ROWS="3" COLS="60"></TEXTAREA>
      	</td>
      	        <td align="right">
	        	
	        </td>
      	
      </tr>        
	  	<br>      
                
	  <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();"/>
        </td>
       </form>
		<td></td>
	    <td align="center">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listContractProject.do')">
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<%
		}else{
%>
	<form action="editContractProject.do" method="post" name="EditForm">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
    <input type="hidden" name="FormAction" value="<%=action%>">
	<INPUT TYPE="hidden" name="projectCategory" value="C">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
	<tr>
        <td align="right">
          <span class="tabletext">Project Code:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="DataId" size="30">
        </td>
        <td align="right">
          <span class="tabletext">Project Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="projName" size="30" value="<%=projName%>">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Project Status:&nbsp;</span>
        </td>
        <td align="left">
          <select name="projectStatus">
			<option value="WIP">WIP</option>
			<option value="PC">Project Completed</option>
			<option value="Close">Close</option>

		  </select>
        </td>
		<td align="right">
          <span class="tabletext">Contract No:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="contractNo" size="30" value="<%=contractNo%>">
          <input type="hidden" class="inputBox" name="contractId" value="<%=contractId%>">
          <a href="javascript:showDialog_contract()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
        </td>
      </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Customer:&nbsp;</span>
        </td>
		<td align="left">
			<div style="display:inline" id="labelCustomer"><%=customerDesc%></div>
			<input type=hidden name="customerId" value="<%=customerId%>">
			<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
				<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/>
			</a>
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
			<option value="<%=p.getPartyId()%>" <%if(departmentId.equals(p.getPartyId())) out.print("selected");%>><%=p.getDescription()%></option>
			<%
			}
			%>
		  </select>
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext">Project Manager:&nbsp;</span>
        </td>
        <td align="left">
        	<div style="display:inline" id="labelPM">&nbsp;</div>
			<input type="hidden" name="projectManagerName"  value="">
			<input type="hidden" name="projectManagerId" value=""><a href="javascript:showDialog_staff()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>  
        </td>
         <td align="right">
          <span class="tabletext"> Open for All:&nbsp;</span>
        </td>
		<td align="left">
            <input TYPE="RADIO" class="radiostyle" NAME="PublicFlag" VALUE="Y">Yes
			<input TYPE="RADIO" class="radiostyle" NAME="PublicFlag" VALUE="N" CHECKED>No
		 </td>
	  </tr>	
	  <tr>
        <td align="right">
          <span class="tabletext">Total Service Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalServiceValue"  size="30" value="<%=totalServiceValue%>" onblur="checkDeciNumber2(this,1,1,'totalServiceValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Total Proc./Sub Value(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="totalLicsValue"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'totalLicsValue',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Service Budget(RMB):&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="PSCBudget"  size="30" value="0" onblur="checkDeciNumber2(this,1,1,'PSCBudget',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Expense Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="EXPBudget" size="30" value="0" onblur="checkDeciNumber2(this,1,1,'EXPBudget',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Proc./Sub Budget(RMB):&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="procBudget" size="30" value="0" onblur="checkDeciNumber2(this,1,1,'procBudget',-9999999999,9999999999); addComma(this, '.', '.', ',');">
        </td>
        <td align="right">
          <span class="tabletext">Contract Type:&nbsp;</span>
        </td>
		<td align="left">
            <input TYPE="RADIO" class="radiostyle" NAME="ContractType" VALUE="FP" <%if(contractType.equals("FP")) out.print("CHECKED");%>>Fixed Price
			<input TYPE="RADIO" class="radiostyle" NAME="ContractType" VALUE="TM" <%if(contractType.equals("TM")) out.print("CHECKED");%>>Time & Material
		 </td>
      </tr>
	  <tr>
        <td align="right">
          <span class="tabletext">Need CAF:&nbsp;</span>
        </td>
        <td align="left">
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="Y">Yes
			<input TYPE="RADIO" class="radiostyle" NAME="CAFFlag" VALUE="N" CHECKED>No
	    </td>
        <td align="right">
          <span class="tabletext">Parent Project:&nbsp;</span>
        </td>
		<td align="left">
			<div style="display:inline" id="labelParentProject">&nbsp;</div><input type=hidden name="ParentProjectId"><a href="javascript:void(0)" onclick="showProjectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
		</td>
      </tr>
       <tr>
        <td align="right">
          <span class="tabletext">Start Date:&nbsp;</span>
        </td>
         <td align="left">
          <input type="text" class="inputBox" name="startDate" value="<%=startDate%>" size="30">
          <A href="javascript:ShowCalendar(document.EditForm.dimg8,document.EditForm.startDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg8 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
        <td align="right">
          <span class="tabletext">End Date:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="endDate" value="<%=endDate%>">
          <A href="javascript:ShowCalendar(document.EditForm.dimg4,document.EditForm.endDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg4 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        
        </td>
      </tr>   
      <tr>
        <td align="right">
          <span class="tabletext">Customer Paid Allowance Rate:&nbsp;</span>
        </td>
        <td>
          <input type="text" class="inputBox" name="alownceAmt"  size="30" value="<%=alownceAmt%>" onblur="checkDeciNumber2(this,1,1,'alownceAmt',-9999999,9999999); addComma(this, '.', '.', ',');" >
        </td>
        <td align="right">
          <span class="tabletext">Project Type:&nbsp;</span>
        </td>
        <td align="left">
         	<select name="projectType">
			<%
			Iterator itPt = ptList.iterator();
			while(itPt.hasNext()){
				ProjectType pt = (ProjectType)itPt.next();
				%>
				<option value="<%=pt.getPtId()%>"><%=pt.getPtName()%></option>
				<%
			}
			%>
			</select>
        </td>
      </tr>   
      <tr>
        <td align="right">
          <span class="tabletext">Bill To Address:&nbsp;</span>
        </td>
     	<td align="left">
          <div style="display:inline" id="labelBillTo"><%=customerName%></div>
          <input type=hidden name="billToId" value="<%=customerId%>">
          <a href="javascript:void(0)" onclick="showBillToDialog();event.returnValue=false;">
          	<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/>
          </a>
        </td>
        <td align="right">
          <span class="tabletext">Project Assistant:&nbsp;</span>
        </td>
        <td align="left"><div style="display:inline" id="labelAssistant">&nbsp;</div>
			<input type="hidden" readonly="true" name="projectAssistantName" maxlength="100" value="">
			<input type="hidden" name="paId" value="">
			<a href="javascript:showDialog_pa()">
				<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" />
			</a>
        </td>
        </tr>
        <tr>
	        <td align="right">
	          <span class="tabletext">Contact Person:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="contact" size="30">
	        </td>
	        <td align="right">
	          <span class="tabletext">Contact Person Tele:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="contactTele" size="30">
	        </td>
        </tr>
        <tr>
	        <td align="right">
	          <span class="tabletext">Customer PM:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="custPM" size="30">
	        </td>
	        <td align="right">
	          <span class="tabletext">Customer PM Tele:&nbsp;</span>
	        </td>
	        <td align="left">
	          <input type="text" class="inputBox" name="custPMTele" size="30">
	        </td>
        </tr>
        <tr>
        <td align="right">
          <span class="tabletext">VAT:&nbsp;</span>
        </td>
        <td align="left">
			<input TYPE="RADIO" class="radiostyle" NAME="VATFlag" VALUE="Y">Yes
			<input TYPE="RADIO" class="radiostyle" NAME="VATFlag" VALUE="N" CHECKED>No
	    </td>
	    <td align="right">
          <span class="tabletext">Project Category:&nbsp;</span>
        </td>
        <td align="left">
          <select name="projectCategory">
            <option value="Project Implementation" selected>Project Implementation </option>
            <option value="Technical Support">Technical Support</option>
			<option value="Software">Software</option>
			<option value="Hardware">Hardware</option>
			<option value="Maintenace">Maintenace</option>
			<option value="Customization">Customization</option>
			<option value="Post On Site Support">Post On Site Support</option>
			<option value="Other">Other</option>
		  </select>
	    </tr>
        <tr>
	        <td align='right'>
	          Need Mail Notification for TS Approval:&nbsp;
	        </td>
	        <td> <input type='checkbox' class='checkboxstyle' name='mailFlag'> </td>
	        <td align="right">
	        	Email Notification to PM and PA:
	        </td>
	        <td><input type="checkbox" class="checkboxstyle" name="notifyPMPA" checked></td>
	    </tr>
        <tr>
        <td align='right'>
          Customer Paid Expense Type:&nbsp;
        </td>
        <td >
        <%
        	List exTypeList = hs.createQuery("select et from ExpenseType as et order by et.expSeq ASC").list();
			if(exTypeList==null)	exTypeList = new ArrayList();
			for(int j=0; j<exTypeList.size(); j++){
			if(((ExpenseType)exTypeList.get(j)).getExpAccDesc().equalsIgnoreCase("CY"))
			out.println("<input type='checkbox' class='checkboxstyle' name='exTypeChk' value='"+((ExpenseType)exTypeList.get(j)).getExpId()+"'>"+((ExpenseType)exTypeList.get(j)).getExpDesc()+"&nbsp;&nbsp;");
			}
        %>
        </td>
		<td align="right">
	        	Contract Category:
	        </td>
	        <td>
	         <select name="contractCategory">
            <option value="Labor" selected>By Labor </option>
            <option value="Material">By Material</option>
		  </select>
		</td>
      	</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td align=right>Type:</td>
	        <td>
	         <select name="duration">
            <option value="onetime" selected>One Time </option>
            <option value="recurring" >Recurring</option>
            <option value="recurring" >Other</option>
		  </select>
		 </td>
</tr>      	
       <tr>
      	<td align=right>
      		Notes for Customer Claimed Expense:
      	</td>
      	<td colspan=3>
      		<TEXTAREA NAME="expenseNote" ROWS="3" COLS="60"></TEXTAREA>
      	</td>
      	        <td align="right">
	        	
	        </td>
      	
      </tr>        
	  	<br>      
                
	  <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();"/>
        </td>
       </form>
		<td></td>
	    <td align="center">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listContractProject.do')">
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<%
		}
	}
	Hibernate2Session.closeSession();
}else{
	out.println("你没有权限访问!");
}
}catch(Exception e){
	e.printStackTrace();
}
%>

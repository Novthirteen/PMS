<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.presale.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.webapp.action.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="net.sf.hibernate.type.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.component.prm.bid.*"%>
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
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<SCRIPT>
function showDialog_staff() {
	var formObj = document.forms["EditForm"];
	openStaffSelectDialog("onCloseDialog_staff","EditForm");
}


function onCloseDialog_staff() {
	var formObj = document.forms["EditForm"];
	if (document.EditForm.PsId.value == ""){
		setStaffValue("hiddenStaffName","RequestorName","EditForm");	
		setStaffValue("hiddenStaffCode","requestor","EditForm");
		}
}

</SCRIPT>
<%
try{
if (AOFSECURITY.hasEntityPermission("PROJ_PRESALE", "_CREATE", session)) {
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

net.sf.hibernate.Transaction tx =null;

hs.flush();
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");

int i=1;
PreSaleMaster PreSaleProject = (PreSaleMaster)request.getAttribute("PreSaleProject");
BidMaster bidMaster = (BidMaster)request.getAttribute("bidMaster");
ArrayList activityList = (ArrayList)request.getAttribute("activityList");
ArrayList activityIdList = (ArrayList)request.getAttribute("activityIdList");

List PreSaleDetailList = (List)request.getAttribute("PreSaleDetailList");
if(PreSaleDetailList==null){
	PreSaleDetailList = new ArrayList();
}

String PsId = request.getParameter("PsId");
if (PsId == null || PsId.trim().length() == 0){
	if (PreSaleProject == null) {
		PsId = "";
	}else{
		PsId =PreSaleProject.getPsId().toString();
	}
}

String FreezeFlag = (String)request.getAttribute("FreezeFlag");
if (FreezeFlag == null) FreezeFlag = "N";

String actionFreeze[] = (String[])request.getAttribute("actionFreeze");

String action = request.getParameter("action");
if(action == null){
	action = "view";
}
UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);

String startDateStr = "";
String endDateStr = "";
String postDateStr = "";
String estimateAmountStr = "";
String exchangeRateStr = "";
String description = "";
String status = "";
String department = "";
String currency = "";
String id = "";
String no = "";
String contractType = "";
String prospectCompany = "";

if(bidMaster!=null){
		no = bidMaster.getNo();
		contractType = bidMaster.getContractType();
		description = bidMaster.getDescription();
		id = bidMaster.getId() + "";
		if(bidMaster.getDepartment() != null){
			department = bidMaster.getDepartment().getDescription() + "";
		}
		if(bidMaster.getCurrency() != null){
			currency = bidMaster.getCurrency().getCurrName() + "";
		}
		java.util.Date startdate = bidMaster.getEstimateStartDate();
		if(startdate!=null){
	    	startDateStr=formater.format(startdate);
	    }
	    
		java.util.Date endDate = bidMaster.getEstimateEndDate();
		if(endDate!=null){
	    	endDateStr=formater.format(endDate);
		}
		
		java.util.Date postDate = bidMaster.getPostDate();
		if(postDate!=null){
	    	postDateStr=formater.format(postDate);
		}
		
		if(bidMaster.getEstimateAmount()!=null){
			estimateAmountStr = Num_formater.format(bidMaster.getEstimateAmount());
		}
		if(bidMaster.getExchangeRate()!=null){
			exchangeRateStr = Num_formater.format(bidMaster.getExchangeRate());
		}
		if(bidMaster.getStatus()!=null){
			status = bidMaster.getStatus();
		}	
		
		if(bidMaster.getProspectCompany()!=null){
			prospectCompany = bidMaster.getProspectCompany().getName();
		}
}
%>
<script language="javascript">
function FnDelete() {
	if (confirm("Do you want delete this project?")) {
		document.EditForm.FormAction.value = "delete";
		document.EditForm.submit();
	}
}
function FnDel() {
	document.EditForm.FormAction.value = "deleteDetail";
	document.EditForm.submit();
}
function FnAddDetail() {
	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}else
	{
		document.EditForm.FormAction.value = "addDetail";
		document.EditForm.submit();
	}
}
function FnAddDetail1() {

	if(document.EditForm.aHours.value == "0")
	{
		alert("Hours cannot be 0");
		
	}else
	{
		document.EditForm.FormAction.value = "addDetail";
		document.EditForm.submit();
	}
}
function FnUpdate() {
	if(document.EditForm.hours.value == "0")
	{
		alert("Hours cannot be 0");
    }else
	{
		document.EditForm.FormAction.value = "update";
		document.EditForm.submit();
	}
}

function FnCreate() {
	if(document.EditForm.bidId.value == ""){
		alert("You must select a bid Master");
	}else{
		document.EditForm.FormAction.value = "new";
		document.EditForm.submit();
	}
}

function ValidateData() {
	var errormessage="";
	if(document.EditForm.requestor.value == "")
	{
		errormessage="You must select an Account manager";
		return errormessage;
    }
	if((document.EditForm.perspective.value == "") && (document.EditForm.perspectiveDesc.value == ""))
	{
		errormessage="You must either select a perspective or enter a perspective";
		return errormessage;
    }
	if((document.EditForm.aHours.value == "0") || (document.EditForm.hours.value == "0"))
	{
		errormessage="Hours cannot be 0";
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
			perspective.value=code;
			perspectiveDesc.value="";
		}
	}
}
function showStaff(i) {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	
	if (v != null && v.length > 3) {
		if (document.EditForm.PsId.value == ""){
			document.EditForm.Assignee.value=v.split("|")[0];
			AssigneeName.innerHTML=v.split("|")[1];
		}else{
			document.getElementsByName("Assignee")[i].value=v.split("|")[0];
			AssigneeName[i].innerHTML=v.split("|")[1];
		}
	}
}
function showStaff2() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	
	if (v != null && v.length > 3) {
		document.EditForm.Assignee.value=v.split("|")[0];
		AssigneeName.innerHTML=v.split("|")[1];	
	}
}
function showStaff1() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	
	if (v != null && v.length > 3) {
		if (document.EditForm.PsId.value == ""){
			document.EditForm.requestor.value=v.split("|")[0];
			RequestorName.innerHTML=v.split("|")[1];
		}
	}
}
function showBidMaster(){
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.project.contractSelect.title&ListSalesBid.do?formAction=dialogView",
	null,
	'dialogWidth:800px;dialogHeight:530px;status:no;help:no;scroll:no');
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
		var no = v.split("|")[10];
		var currency = v.split("|")[11];
		var prospectCompany = v.split("|")[12];
		var contractType = v.split("|")[13];
		var status = v.split("|")[14];
		var department = v.split("|")[15];
		
		document.getElementById("bidId").value = bidMasterId;
		document.getElementById("labelBid").innerHTML = no;
		document.getElementById("spName").value = salePersonId + ":" + salesPersonName;
		document.getElementById("labelSPName").innerHTML = salePersonId + ":" + salesPersonName;
		document.getElementById("estimateAmountStr").value = estimateAmount;
		document.getElementById("labelEstimateAmt").innerHTML = estimateAmount;
		document.getElementById("exchangeRateStr").value = exchangeRate;
		document.getElementById("labelExchangeRate").innerHTML = exchangeRate;
		document.getElementById("startDateStr").value = startDate;
		document.getElementById("labelSDate").innerHTML = startDate;
		document.getElementById("endDateStr").value = endDate;
		document.getElementById("labelEDate").innerHTML = endDate;
		document.getElementById("currency").value = currency;
		document.getElementById("labelCurrency").innerHTML = currency;
		document.getElementById("contractType").value = contractType;
		document.getElementById("labelCType").innerHTML = contractType;
		document.getElementById("prospectCompany").value = prospectCompany;
		document.getElementById("labelPCompany").innerHTML = prospectCompany;
		document.getElementById("bidstatus").value = status;
		document.getElementById("labelStatus").innerHTML = status;
		document.getElementById("description").value = description;
		document.getElementById("labelDesc").innerHTML = description;
		document.getElementById("department").value = department;
		document.getElementById("labelDep").innerHTML = department;
	}
}
</script>

<Form action="userList.do" name="UserListForm" method="post">
	<input type="hidden" name="CALLBACKNAME" id="CALLBACKNAME">
</Form>
<Form action="custList.do" name="CustListForm" method="post">
	<input type="hidden" name="CALLBACKNAME" id="CALLBACKNAME">
</Form>

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0'>
	<CAPTION align=center class=pgheadsmall>Pre-Sale Activity Maintenance </CAPTION>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan=8 valign="bottom"><hr color=red></hr></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  	<TR>
		<TD width='100%'>
<%
if(PreSaleProject != null)
{
	action="Update";
	String conDesc="";
	int cnt =0;
%>
			<form action="EditPreSaleProject.do" method="post" name="EditForm">
			<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
				marginWidth=0 noResize 
				scrolling=no src="includes/date/calendar.htm" 
				style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
			</IFRAME>
			<input type="hidden" name="FormAction" id="FormAction" value="update">
		    <input type="hidden" name="PsId" id="PsId" value=<%=PsId%>>
		    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
		    	<tr>
			    	<td align="right" class="lblbold">
			          <span class="tabletext">Bid:&nbsp;</span>
			        </td>
			        <td align="left">
			        <%
			        	String bidNo = "";
			        	String bidid = "";
			        	if(PreSaleProject!= null){
			        		if(PreSaleProject.getBidMaster()!=null){
			        			bidNo = PreSaleProject.getBidMaster().getNo();
			        			Long bidId = PreSaleProject.getBidMaster().getId();
			        			bidid = String.valueOf(bidId);
			        		}
			        	}
			        %>	
		        	<div style="display:inline" id="labelBid"><%=bidNo%>&nbsp;</div>
			        <input type="hidden" class="inputBox" name="bidId" id="bidId" value = <%=bidid%>>
	        	         
			    	</td>
			    	<td>
			    	</td>
			    	<td>
			    	</td>
		    	</tr>
				<tr>
					<td align="right" class="lblbold">
      					<span class="tabletext">Description:&nbsp;</span>
   	 				</td>
    				<td>
						<%=description%>
    				</td>
    				<td  align="right" class="lblbold">Department:&nbsp;</td>
					<td class="lblLight">
						<%=department%>
					</td>
				
					<td align="right" class="lblbold">
 	 					<span class="tabletext">Status:&nbsp;</span>
					</td>
					<td align="left">
						<%=status%>
					</td>
				</tr>
				<tr>					
					<td align="right" class="lblbold">
			          <span class="tabletext">Sales Person:&nbsp;</span>
			        </td>
			        <td align="left">
						<%String spId = "";
						String spName = "";
						if(bidMaster != null){
							if (bidMaster.getSalesPerson() != null) {
								spId = bidMaster.getSalesPerson().getUserLoginId();
								spName = bidMaster.getSalesPerson().getName();
							}
						}
						%>
						<%=spName%>
					</td>

					<td align="right" class="lblbold">
      					<span class="tabletext">Currency:&nbsp;</span>
    				</td>
					<td>
						<%=currency%>
					</td>
					<td align="right" class="lblbold">
      					<span class="tabletext">Contract Type:&nbsp;</span>
    				</td>
					<td>
					<%
						if(contractType != null && !contractType.equals("") && !contractType.equals("null") ){
							if(contractType.equals("FP")){
								out.println("Fixed Price");
							}else{
								out.println("Time & Material");
							}
						}
					%>
					</td>
				</tr>
				<tr>
					<td align="right" class="lblbold">
      					<span class="tabletext">Total Contract Value(RMB):&nbsp;</span>
   	 				</td>
    				<td>
						<%=estimateAmountStr%>
    				</td>
				
					<td align="right" class="lblbold">
      					<span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
   	 				</td>
    				<td>
    					<%=exchangeRateStr%>
    				</td>

					<td align="right" class="lblbold">
      					<span class="tabletext">Estimated Start Date:&nbsp;</span>
   	 				</td>
    				<td>
    					<%=startDateStr%>
					</td>
				</tr>
				<tr>
					<td align="right" class="lblbold">
      					<span class="tabletext">Estimated End Date:&nbsp;</span>
   	 				</td>
    				<td>
    					<%=endDateStr%>
					</td>

					<td align="right" class="lblbold">
      					<span class="tabletext">Post Date:&nbsp;</span>
   	 				</td>
    				<td>
    					<%=postDateStr%>
					</td>
					<td align="right" class="lblbold">
      					<span class="tabletext">Prospect Company:&nbsp;</span>
   	 				</td>
    				<td>
    					<%=prospectCompany%>
					</td>					
				</tr>		
				
				<tr>
					<td colspan=8 valign="bottom"><hr color=red></hr></td>
				</tr>
				<table border="0" cellpadding="2" cellspacing="3" width="100%">
					<tr>
						<td align="left" class="lblbold" width="5%"></td>
						<td align="left" class="lblbold" bgcolor="#e9eee9" width="20%">Assignee</td>
						<td align="left" class="lblbold" bgcolor="#e9eee9" width="20%">Action Date</td>
						<td align="left" class="lblbold" bgcolor="#e9eee9" width="15%">Hours</td>
						<td align="left" class="lblbold" bgcolor="#e9eee9"  >Description</td>
						<td align="left" class="lblbold" bgcolor="#e9eee9"  >Activity</td>
						<td align="left" class="lblbold" bgcolor="#e9eee9">Action</td>
						<td width="5%">&nbsp;</td>
					</tr>
					<%
					
					Iterator itst = PreSaleDetailList.iterator();
					if ((PreSaleDetailList.size()==0) && (status.equals(Constants.BID_MASTER_STATUS_WIP))){
					%>
					<tr>
						<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
					</tr>
					<tr>
						<td width="5%"></td>
						<td align="left">
							<div style="display:inline" id="AssigneeName"><%=ul.getName()%></div>
							<input type="hidden" name="Assignee" id="Assignee" value="<%=ul.getUserLoginId()%>">
							<input type="hidden" name="aName" id="aName" value="<%=ul.getName()%>">
							<input type="hidden" name="aId" id="aId" value="<%=ul.getUserLoginId()%>">
							<%if (AOFSECURITY.hasEntityPermission("PROJ_PRESALE", "_ALL", session)) {%>
								<a href="javascript:showStaff2(0)">
									<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" />
								</a>  
							<%}%>
							
				        </td>
				        
				        <td align="left">
							<input type="text" class="inputBox" name="actionDate" id="actionDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>" size="20">
							<input type="hidden" name="aDate" id="aDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>">
							<A href="javascript:ShowCalendar(document.EditForm.dimg1,document.EditForm.actionDate,null,0,330)" 
											onclick=event.cancelBubble=true;>
								<IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" >
							</A>
						</td>
						<td align="left">
			          		<input type="text" class="inputBox" name="aHours" id="aHours" size="15" onblur="checkDeciNumber2(this,1,1,'aHours',0,24);" value="0">
			          	</td>
			        	<td align="left">
			          		<input type="text" class="inputBox" name="aDesc" id="aDesc" size="40">
			        	</td>
			        	<td>
				        	<select name="aActivityId" id="aActivityId">
							<%
								Iterator itd = activityList.iterator();
								Iterator itId = activityIdList.iterator();
								while(itd.hasNext()){
									String name = (String)itd.next();
									String ids = (String)itId.next();
							%>
									<option value="<%=ids%>"><%=name%></option>
							<%
								}
							%>
							</select>
			        	</td>
			        	<td>
			        		<input type="button" value="Add" class="loginButton" onclick="javascript:FnAddDetail1();"/>
			        	</td>
			        	<td>&nbsp;</td>
			        </tr>
					<%}else {
						int count =0;
						int cc=0;
						while (itst.hasNext()){
							PreSaleDetail psd = (PreSaleDetail)itst.next();
					%>
					<tr >
						<td width="5%"></td>
				        <td bgcolor="#e9eef9">
					       	<div style="display:inline" id="AssigneeName"><%=psd.getAssignee().getName()%></div>
							<input type="hidden" name="Assignee" id="Assignee" value="">
							<input type="hidden" name="detailId" id="detailId" value="<%=psd.getPdId()%>">
							<%if (AOFSECURITY.hasEntityPermission("PROJ_PRESALE", "_ALL", session)) {%>
								<a href="javascript:showStaff(<%=count%>)">
									<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" />
								</a>
							<%}%>
				        </td>
				        <td bgcolor="#e9eef9">
				        	<input type="text" class="inputBox" name="actionDate<%=cc%>" id="actionDate<%=cc%>" value="<%=formater.format(psd.getActionDate())%>" size="20">
							<A href="javascript:ShowCalendar(document.EditForm.dimg<%=cc%>,document.EditForm.actionDate<%=cc%>,null,0,330)" 
										onclick=event.cancelBubble=true;>
								<IMG align=absMiddle border=0 id=dimg<%=cc%> src="<%=request.getContextPath()%>/images/datebtn.gif" >
							</A>
							
			        	</td>
			        	<td bgcolor="#e9eef9">
			           		<input type="text" class="inputBox" name="hours" id="hours" size="15" onblur="checkDeciNumber2(this,1,1,'hours',0,24);" value="<%=Num_formater.format(psd.getHours())%>">
			        	</td>
			        	<td bgcolor="#e9eef9">
							<input type="text" class="inputBox" name="actionDesc" id="actionDesc" size="40" value="<%=psd.getDescription()%>">
						</td>
						<td bgcolor="#e9eef9">
							<select name="activityId" id="activityId">
							<%
								String actId = "";
								if(psd.getSalesActivity()!= null){
									actId = psd.getSalesActivity().getId() + "";
								}
								Iterator itd = activityList.iterator();
								Iterator itId = activityIdList.iterator();
								while(itd.hasNext()){
									String name = (String)itd.next();
									String ids = (String)itId.next();
									if (ids.equals(actId)) {
									%>
											<option value="<%=ids%>" selected><%=name%></option>
									<%
											} else{
									%>
											<option value="<%=ids%>"><%=name%></option>
									<%
											}
										}
									%>
							</select>
						</td>
						<td bgcolor="#e9eef9">
			        	<% if (actionFreeze.length == 0){%>
			        		&nbsp;&nbsp;<a href="EditPreSaleProject.do?psdId=<%=psd.getPdId()%>&PsId=<%=PreSaleProject.getPsId()%>&FormAction=deleteDetail">Delete</a>
			        	<%}else {
				        	if (actionFreeze[count].equals("N")) 
							{%>
								&nbsp;&nbsp;<a href="EditPreSaleProject.do?psdId=<%=psd.getPdId()%>&PsId=<%=PreSaleProject.getPsId()%>&FormAction=deleteDetail">Delete</a>
							<%}%>
						<%}%>
			        	</td>
			        	<td>&nbsp;</td>
			        </tr>
					<% 	count=count+1;
						cc=cc+1;
					}%>
						<input type="hidden" name="cc" id="cc" value="<%=cc%>">
					<%if (status.equals(Constants.BID_MASTER_STATUS_WIP)) { %>
					<tr>
						<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
					</tr>
					<tr>
						<td width="5%"></td>
						<td align="left">
							<div style="display:inline" id="AssigneeName"><%=ul.getName()%></div>
							<input type="hidden" name="Assignee" id="Assignee" value="<%=ul.getUserLoginId()%>">
							<%if (AOFSECURITY.hasEntityPermission("PROJ_PRESALE", "_ALL", session)) {%>
							<a href="javascript:void(0)" onclick="showStaff(<%=count%>);event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>  
							<%}%>
							<input type="hidden" name="cnt" id="cnt" value="<%=count%>">
							<input type="hidden" name="aName" id="aName" value="<%=ul.getName()%>">
							<input type="hidden" name="aId" id="aId" value="<%=ul.getUserLoginId()%>">
				        </td>
				        
				        <td align="left">
						<input type="text" class="inputBox" name="aDate" id="aDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>" size="20">
						<!-- <input type="hidden" name="aDate" id="aDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>">	-->
						<A href="javascript:ShowCalendar(document.EditForm.dimgi,document.EditForm.aDate,null,0,330)" 
										onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimgi src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
						<td align="left">
			          		<input type="text" class="inputBox" name="aHours" id="aHours" size="15" onblur="checkDeciNumber2(this,1,1,'aHours',0,24);" value="0">
			        	</td>
			        	<td align="left">
			          		<input type="text" class="inputBox" name="aDesc" id="aDesc" size="40" >
			          	</td>
			          	<td >
				        	<select name="aActivityId" id="activityId">
							<%
								Iterator itd = activityList.iterator();
								Iterator itId = activityIdList.iterator();
								while(itd.hasNext()){
									String name = (String)itd.next();
									String ids = (String)itId.next();
							%>
									<option value="<%=ids%>"> <%=name%></option>
							<%
								}
							%>
							</select>
			          	</td>
			          	<td>
			          		<input type="button" value="Add" class="loginButton" onclick="javascript:FnAddDetail1();"/>
			        	</td>
			        	<td>
			        		&nbsp;	
			        	</td>
			        </tr>
			        <%}%>
					<%}%>
					<tr>  
					</tr> 	
				</Table>
				
				
	<!-- -------------------------------------------------------------------------------- -->			
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
				        <td width="60%">&nbsp;</td>
			        	<td align="left">
							<input type="button" value="Update" class="loginButton" onclick="javascript:FnUpdate();"/>
						<%
						if (FreezeFlag.equals("N")) {%>	
							<input type="button" value="Delete All" class="loginButton" onclick="javascript:FnDelete();"/>
						<%}%>
						</td>      
						<td></td>
				    	<td align="center">
						<input type="button" value="Back To List" class="loginButton" onclick="location.replace('ListPreSaleProject.do')">
						</td>
						<td width="5%">&nbsp;</td>
			      	</tr> 
		      	</table>
			</table>
		</TD>
  	</TR>
</table>

<%
}else{
%>

	<form action="EditPreSaleProject.do" method="post" name="EditForm">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
		marginWidth=0 noResize 
		scrolling=no src="includes/date/calendar.htm" 
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
    <input type="hidden" name="FormAction" id="FormAction" value="<%=action%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
    	<table width='100%' border='0' cellpadding='0' cellspacing='2'>
	    	<tr>
		    	<td width="20%" align="right" class="lblbold">
		          <span class="tabletext">Bid:&nbsp;</span>
		        </td>
		        <td width="17%" align="left">
	        	<div style="display:inline" id="labelBid">&nbsp;</div>
		        <input type="hidden" class="inputBox" name="bidId" id="bidId" value ="">
		        <a href="javascript:void(0)" onclick="showBidMaster();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>		        	         
		    	</td>
		    	<td width="16%">
		    	</td>
		    	<td width="15%">
		    	</td>
	    	</tr>
			<tr>
				<td align="right" class="lblbold">
      				<span class="tabletext">Description:&nbsp;</span>
   	 			</td>
    			<td>
    				<div style="display:inline" id="labelDesc">&nbsp;</div>
					<input type="hidden" class="inputBox" name="description" id="description" value="" size="30" />
    			</td>
    			<td  align="right" class="lblbold">Department:&nbsp;</td>
				<td class="lblLight">
					<div style="display:inline" id="labelDep">&nbsp;</div>
					<input type="hidden" class="inputBox" name="department" id="department" value="" size="30" />
				</td>
			
				<td width="16%" align="right" class="lblbold">
 	 				<span class="tabletext">Status:&nbsp;</span>
				</td>
				<td width="16%" align="left">
					<div style="display:inline" id="labelStatus">&nbsp;</div>
					<input type="hidden" class="inputBox" name="bidstatus" id="bidstatus" value="" size="30" />
				</td>	
			</tr>
			<tr>				
				<td align="right" class="lblbold">
			         <span class="tabletext">Sales Person:&nbsp;</span>
			    </td>
			    <td align="left">
			    	<div style="display:inline" id="labelSPName">&nbsp;</div>
					<input type="hidden" class="inputBox" name="spName" id="spName" value="" size="30" />
				</td>
			
				<td align="right" class="lblbold">
  					<span class="tabletext">Currency:&nbsp;</span>
				</td>
				<td>
					<div style="display:inline" id="labelCurrency">&nbsp;</div>
					<input type="hidden" class="inputBox" name="currency" id="currency" value="" size="30" />
				</td>
				<td align="right" class="lblbold">
  					<span class="tabletext">Contract Type:&nbsp;</span>
				</td>
				<td>
					<div style="display:inline" id="labelCType">&nbsp;</div>
					<input type="hidden" class="inputBox" name="contractType" id="contractType" value="" size="30" />
				</td>
			</tr>
			<tr>
				<td align="right" class="lblbold">
      				<span class="tabletext">Total Contract Value(RMB):&nbsp;</span>
   	 			</td>
    			<td>
    				<div style="display:inline" id="labelEstimateAmt">&nbsp;</div>
    				<input type="hidden" class="inputBox" name="estimateAmountStr" id="estimateAmountStr" value="" size="30" />
    			</td>
				
				<td align="right" class="lblbold">
      				<span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
   	 			</td>
    			<td>
    				<div style="display:inline" id="labelExChangeRate">&nbsp;</div>
    				<input type="hidden" class="inputBox" name="exchangeRateStr" id="exchangeRateStr" value="" size="30" />
    			</td>
			
				<td align="right" class="lblbold">
      				<span class="tabletext">Estimated Start Date:&nbsp;</span>
   	 			</td>
    			<td>
    				<div style="display:inline" id="labelSDate">&nbsp;</div>
    				<input type="hidden" class="inputBox" name="startDateStr" id="startDateStr" value="" size="30" />
				</td>
			<tr>
				<td align="right" class="lblbold">
      				<span class="tabletext">Estimated End Date:&nbsp;</span>
   	 			</td>
    			<td>
    				<div style="display:inline" id="labelEDate">&nbsp;</div>
    				<input type="hidden" class="inputBox" name="endDateStr" id="endDateStr" value="" size="30" />
				</td>
			
				<td align="right" class="lblbold">
      				<span class="tabletext">Post Date:&nbsp;</span>
   	 			</td>
    			<td>
    				<div style="display:inline" id="labelPDate">&nbsp;</div>
    				<input type="hidden" class="inputBox" name="postDateStr" id="postDateStr" value="" size="30" />
				</td>
				<td align="right" class="lblbold">
      				<span class="tabletext">Prospect Company:&nbsp;</span>
   	 			</td>
    			<td>
    				<div style="display:inline" id="labelPCompany">&nbsp;</div>
    				<input type="hidden" class="inputBox" name="prospectCompany" id="prospectCompany" value="" size="30" />
				</td>					
			</tr>
	</table>
<!-- 2-------------------------------------------------------------------------------- -->
		<tr>
			<td colspan=8 valign="bottom"><hr color=red></hr></td>
		</tr>

<!-- -------------------------------------------------------------------------------- -->
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td width="70%">&nbsp;</td>
		        <td align="left">
					<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();"/>
		        &nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" value="Back To List" class="loginButton" onclick="location.replace('ListPreSaleProject.do')">
				</td>
				<td width="5%">&nbsp;</td>
			</tr>
		</table>
		<tr><td>&nbsp;</td></tr>
	</table>
	</form>
<%
	}
	Hibernate2Session.closeSession();
}else{
	out.println("你没有权限访问!");
}
}catch (Exception ex){
	ex.printStackTrace();
}
%>


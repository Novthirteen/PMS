<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.crm.vendor.VendorProfile"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld"prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld"prefix="tiles"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/projectCostMaintain.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script>
function showVendorDialog()
{
	var code,desc;
	with(document.ProjectListForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payto.dialog.title&crm.dialogVendorList.do",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelPayFor.innerHTML=code+":"+desc;			
			document.ProjectCostMaintainForm.payFor.value=code;
		}
	}
}
function onCurrSelect() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	formObj.elements["FormAction"].value = "currencySelect";
	formObj.submit();
}
function showDialog(i) {
	var code,desc,CYExpFlag;
	with(document.ProjectCostMaintainForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&projectList.do?",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			CYExpFlag=v.split("|")[9];
			labelProject.innerHTML=code + ":" + desc;
			projId.value=code;
			projName.value="";
			if (CYExpFlag == "Y"){
				ClaimTypeSelect.value ="CY";
				labelNotice.innerHTML="Travel Expense CAN be paid by customer.";
			}else{
				ClaimTypeSelect.value ="CN";
				labelNotice.innerHTML="Travel Expense CAN NOT be paid by customer.";
			}
		}
	}
}
function showDialog_staff(i) {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	
	if (v != null && v.length > 3) {
	    var formObj = document.forms["ProjectCostMaintainForm"];
	    formObj.elements["hiddenNumber"].value = i;
	    document.getElementById("staffId").value=v.split("|")[0];
	    document.getElementById("staffName").value=v.split("|")[1];
	    document.getElementById("staff").value=v.split("|")[0]+":"+v.split("|")[1];
	    labelStaff.innerHTML=v.split("|")[0] + ":" + v.split("|")[1];
	    //document.getElementById("projId").value=v.split("|")[2];
	    //document.getElementById("projName").value=v.split("|")[3];
	    
	}
}
/*
function showDialog_staff(i) {
	var formObj = document.forms["ProjectCostMaintainForm"];
	formObj.elements["hiddenNumber"].value = i;
	openStaffSelectDialog("onCloseDialog_staff" ,"ProjectCostMaintainForm");
}*/

function onCloseDialog_staff() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	var i = formObj.elements["hiddenNumber"].value;
	setValue_staff("hiddenStaffCode","staffId");
	setStaffValue("hiddenStaffCode","hiddenStaffName","staff");	
}

function SaveRecords() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	if (check(formObj)== false){
		return;
	}
	formObj.elements["FormAction"].value = "save";
	formObj.submit();	
}
function ConfirmRecords() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	if (check(formObj)== false){
		return;
	}
	if ( (formObj.elements["ClaimTypeSelect"].value =='CY') &&(formObj.elements["projId"].value == "")){
		alert ("Please select a project in order to claim from customer !");
		return;
	}
	formObj.elements["FormAction"].value = "confirm";
	formObj.submit();	
}

function UNConfirmRecords(){
	var formObj = document.forms["ProjectCostMaintainForm"];
	formObj.elements["FormAction"].value = "unconfirm";
	formObj.submit();	
}
function check(formObj) {
	var errorMessage = "";
	
	if (formObj.elements["bookDate"].value > formObj.elements["costDate"].value ) {
		errorMessage =  "Book date can not be later than flight date !";
 	}
	if(formObj.elements["totalValue"].value==0) {
		errorMessage =  "Flight price can not be ignored !";
	}
 	if (formObj.elements["bookDate"].value == "") {
		errorMessage =  "Book date can not be ignored !";
 	}
 	if (formObj.elements["costDate"].value == "") {
		errorMessage =  "Flight date can not be ignored !";
 	}
 	if (formObj.elements["takeOffTime"].value == "") {
		errorMessage =  "Flight time can not be ignored !";
 	}
 	if (formObj.elements["refNo"].value == "") {
		errorMessage =  "Flight number can not be ignored !";
 	}
 	if (formObj.elements["payFor"].value == "" ) {
		errorMessage =  "Supplier can not be ignored !";
 	}
 	if (formObj.elements["exchangeRate"].value == "") {
		errorMessage =  "Please select currency !";
 	}
 	if (formObj.elements["staff"].value == "") {
		errorMessage =  "Staff can not be ignored !";
 	}
 	if (formObj.elements["projName"].value == "" && formObj.elements["projId"].value == "") {
		errorMessage =  "Project can not be ignored !";
 	}
 	
	if (errorMessage != "") {
		alert(errorMessage);
		return false;
	}
	return true;
	
}
function OnDelete() {
	var formObj = document.forms["ProjectCostMaintainForm"];
	formObj.elements["FormAction"].value = "delete";
	formObj.submit();
}
</script>
<style>
.hid{display:none}
</style>
<%
try{
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	ProjectAirFareCost findmaster = (ProjectAirFareCost)request.getAttribute("findmaster");
	String DataId=request.getParameter("DataId");
	if(DataId == null ) DataId = "";
	
	ProjectAirFareCost pcm = null;
	
	if(!DataId.equals("")){
		pcm = (ProjectAirFareCost) hs.load(ProjectAirFareCost.class,new Integer(DataId));
	}
	
	String projDesc="";
	if (findmaster != null) {
		DataId = findmaster.getCostcode().toString();
		projDesc=findmaster.getPayType();
	}
	SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
	NumberFormat Num_formater = NumberFormat.getInstance();
	Num_formater.setMaximumFractionDigits(2);
	Num_formater.setMinimumFractionDigits(2);
	String FreezeFlag = (String)request.getAttribute("FreezeFlag");
	if (FreezeFlag == null) FreezeFlag = "N";
	
	String Type = request.getParameter("Type");
	String costType = request.getParameter("CostType");
	
    if (Type == null) Type = "";
    String tt = "";
    if (Type.equals("Expense")) {
		tt = "OTHER_COST";
	}else{
		tt = "PROCU_SUB";
	}
		
	boolean isPA;
//	if(AOFSECURITY.hasEntityPermission("AIRFARE_PA", "_CONFIRM", session)){
//		isPA = true;
//	}else{
		isPA = false;
//	}	
		
    if (AOFSECURITY.hasEntityPermission(tt, "_CREATE", session)) {
%>

<Form action="projectList.do" name="ProjectListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<Form action="userList.do" name="UserListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
</Form>
<html:form action="projectCostMaintain.do" method="post">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<input type="hidden" name="FormAction">
<input type="hidden" name="hiddenNumber">
<input type="hidden" name="Type" value="<%=Type%>">
<input type="hidden" name="CostType" value="<%=costType%>">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table border="0" width="100%" cellspacing="0" cellpadding="0">
	<tr>
	<!-- Left Spacer -->
	<td width=1%>
	<img src="images/spacer.gif" width="2" height="1" border="0">
	</td>
	<td width="98%" valign="bottom" align="right">
		<!-- Contents -->
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<CAPTION align=center class=pgheadsmall>Airfare Maintenance</CAPTION>
			<!-- Document Header Information -->
			<tr height="15">
				<td colspan=3><img src="images/spacer.gif" width="4" height="4" border="0"></td>
			</tr>
			<!-- Area Header Information -->
			<!-- Area Contents Information -->
			<tr bgcolor="#DEEBEB">
				<td>
				</td>
				<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
					<%
					//List DetResult = (List)request.getAttribute("QryDetail");
					//if(DetResult==null){
					//	DetResult = new ArrayList();
					//}
					//Iterator it = DetResult.iterator();
					//String pcdId = request.getParameter("pcdId");
					String projId = request.getParameter("projId");
					String proj = request.getParameter("proj");
					String staffId = request.getParameter("staffId");
					String staff = request.getParameter("staff");
					String destination=request.getParameter("destination");
					String payFor = null;
					String vendor = null;
					
										
					for (int i = 0; i < 1 ; i++) {
						if (findmaster != null){
						//	ProjectCostDetail pcd = (ProjectCostDetail)it.next();
							if (proj == null && findmaster.getProjectMaster()!=null) proj = findmaster.getProjectMaster().getProjId()+":"+findmaster.getProjectMaster().getProjName();
							//pcdId[i] = new Integer(pcd.getPcdid()).toString();
							if (projId == null && findmaster.getProjectMaster()!=null) projId = findmaster.getProjectMaster().getProjId();
							UserLogin ul = findmaster.getUserLogin();
							if(findmaster.getPayFor() != null)
								payFor = findmaster.getPayFor();
							else
								payFor = "";
							    
							VendorProfile vp = findmaster.getVendor();
							if(vp != null)
								vendor = payFor+":"+vp.getDescription();
							else
								vendor = "";
					
							if (ul == null) {
								if (staffId == null) staffId = "";
								if (staff == null) staff = "";
							} else {
								if (staffId == null) staffId = ul.getUserLoginId();
								if (staff == null) staff = ul.getUserLoginId()+":"+ul.getName();
							}
						}else{
							if (proj == null) proj = "";
							if (projId == null) projId = "";
							if (staffId == null) staffId = "";
							if (staff == null) staff = "";
							if (payFor == null) payFor = "";
							if (vendor == null) vendor = "";
						}
					%>
					
					<tr height="15">
						<td class="lblbold" bgcolor="#b4d4d4" colspan="4">Main Information:</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap><bean:message key="prm.timesheet.projectLable"/>:&nbsp</td>
						<td class="lblbold" nowrap colspan="3">&nbsp;

							<%if(!isPA){%>
								<div style="display:inline" id="labelProject"><%=projId != null && projId.trim().length() != 0  && findmaster!=null && findmaster.getProjectMaster() !=null ?  proj : ""%></div>
								<a href="javascript:void(0)" onclick="showDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0" /></a>
								&nbsp;&nbsp; 
								<input type = "hidden" name = "projName" size="30" value="<%=projId != null && projId.trim().length() != 0 && findmaster!=null && findmaster.getProjectMaster() !=null ? "" : projDesc%>" onchange="document.getElementsByName('projId').value = '';labelProject.innerHTML = '';">							
								<input type = "hidden" name = "projId" value="<%=projId != null ? projId : ""%>">
							<%}else{%>
								<div style="display:inline" id="labelProject"><%=projId != null && projId.trim().length() != 0  && findmaster!=null && findmaster.getProjectMaster() !=null ?  proj : ""%></div>
								<input type = "text" style="display:none" name = "projName" size="30" value="<%=projId != null && projId.trim().length() != 0 && findmaster!=null && findmaster.getProjectMaster() !=null ? "" : projDesc%>" onchange="document.getElementsByName('projId').value = '';labelProject.innerHTML = '';">							
								<input type = "hidden" name = "projId" value="<%=projId != null ? projId : ""%>">
							<%}%>
							
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap>Notice:&nbsp</td>
						<td class="lblbold" nowrap colspan="3">&nbsp;
						<%String word ="";
						if (projId != null && projId.trim().length() != 0  && findmaster!=null && findmaster.getProjectMaster() !=null && findmaster.getProjectMaster().getCYTransport() !=null&& findmaster.getProjectMaster().getCYTransport().equals("Y")){
							word = "Travel Expense CAN be paid by customer.";
							}else if (projId != null && projId.trim().length() != 0  && findmaster!=null && findmaster.getProjectMaster() !=null && findmaster.getProjectMaster().getCYTransport() !=null&& findmaster.getProjectMaster().getCYTransport().equals("N")){
							word = "Travel Expense CAN NOT be paid by customer.";
							}
						%>
							<div style="display:inline" id="labelNotice"><%=word%></div>						
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.staffNameLable"/>:&nbsp</td>
						<td class="lblbold">&nbsp;
							<div style="display:inline" id="labelStaff"><%=staff%></div>
							<%if(!isPA){%>
								<a href='javascript: showDialog_staff(<%=i%>)'><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
							<%}%>
							<input type = "hidden" name = "staffId" value="<%=staffId%>">
							<input type = "hidden" name = "staffName">	
							<input type = "hidden" name = "staff" value="<%=staff%>">						
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap>Cost <bean:message key="prm.projectCostMaintain.typeLable"/>:&nbsp</td>
						<td class="lblbold" nowrap>&nbsp;
							<%if(!isPA){%>
								<html:select property = "typeSelect" size="1">
								<html:optionsCollection name="typeSelectArr" value="key" label="value" />
								</html:select>							
							<%}else{%>
								<html:select property = "typeSelect" size="1" styleClass="hid">
								<html:optionsCollection name="typeSelectArr" value="key" label="value" />
								</html:select>	
								<%= pcm!=null?pcm.getProjectCostType().getTypename():""%>
							<%}%>
						</td>

						<td class="lblbold" nowrap>Paid By:&nbsp</td>
						<td class="lblbold" nowrap>&nbsp;
						<%String cncy="";%>

							<html:select property = "ClaimTypeSelect" size="1">

								<option value="CN" <%if(findmaster!=null && findmaster.getClaimType().equals("CN") ) out.print("selected");%>>Company</option>
								<option value="CY" <%if(findmaster!=null && findmaster.getClaimType().equals("CY")) out.print("selected");%>>Customer</option>
							</html:select>
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.currencyLable"/>:&nbsp</td>
						<td class="lblbold" nowrap>&nbsp;
							<%if(!isPA){%>
								<html:select property = "currencySelect"  onchange = "javascript:onCurrSelect()" size="1">
								<html:optionsCollection name="currencySelectArr" value="key" label="value" />
								</html:select>
							<%}else{%>
								<html:select property = "currencySelect"  onchange = "javascript:onCurrSelect()" size="1" styleClass="hid">
								<html:optionsCollection name="currencySelectArr" value="key" label="value" />
								</html:select>
								<%= pcm!=null ?pcm.getCurrency().getCurrName():""%>
							<%}%>
						</td>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.exchangeRateLable"/>(RMB):&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="exchangeRate" size="30"/>
							<%}else{%>
								<html:text property="exchangeRate" size="30" styleClass="hid"/>
								<%=pcm.getExchangerate()%>
							<%}%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap><bean:message key="prm.projectCostMaintain.PayForLable"/>:&nbsp</td>
						<td class="lblbold" nowrap>&nbsp;
							<div style="display:inline" id="labelPayFor">
								<%=vendor%>
							</div>
							<input type=hidden name="payFor" value="<%=payFor%>">
							<%if(!isPA){%>
								<a href="javascript:void(0)" onclick="showVendorDialog();event.returnValue=false;">
								<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
							<%}%>
						</td>
						<td class="lblbold" nowrap width=20%>Cost Description:&nbsp</td>
						<td class="lblbold" width=30%>&nbsp;
							<%if(!isPA){%>
								<html:text property="costDescription" size="30"/>
							<%}else{%>
								<html:text property="costDescription" size="30" styleClass="hid"/>
								<%=pcm.getCostdescription()%>
							<%}%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap>Create Date:&nbsp</td>
						<td class="lblbold">&nbsp;
							<bean:write name="createDate"/>
						</td>
						<td class="lblbold" nowrap>
							<bean:message key="prm.projectCostMaintain.approvalDateLable"/>:&nbsp
						</td>
						<td class="lblbold">&nbsp;
							<bean:write name="approvalDate"/>
						</td>
					</tr>
				<%if(findmaster!=null){%>
						<tr>
						<td class="lblbold" nowrap>Air Ticket Return Date:&nbsp</td>
						<td class="lblbold">&nbsp;
							<input TYPE="text" maxlength="15" size="10" name="returnDate" value="<%=findmaster!=null && findmaster.getReturnDate() !=null ? formater.format(findmaster.getReturnDate()) : ""%>">
					<A href="javascript:ShowCalendar(document.ProjectCostMaintainForm.dimg5,document.ProjectCostMaintainForm.returnDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg5 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
						</td>
						<td class="lblbold" nowrap>
							
						</td>
						<td class="lblbold">&nbsp;
							
						</td>
					</tr>
					<%}%>
					<tr height="15">
						<td class="lblbold" bgcolor="#b4d4d4" colspan="4">Current Travel Agent:</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap width=20%>Flight No.:&nbsp</td>
						<td class="lblbold" nowrap width=30%>&nbsp;
							<%if(!isPA){%>
								<html:text property="refNo" size="30"/>
							<%}else{%>
								<html:text property="refNo" size="30" styleClass="hid"/>
								<%=pcm.getRefno()%>
							<%}%>
						</td>
						<td class="lblbold" nowrap>Issue Date:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="bookDate" size="30"/>
							<A href="javascript:ShowCalendar(document.ProjectCostMaintainForm.dimg1,document.ProjectCostMaintainForm.bookDate,null,0,330)" 
								onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
							<%}else{%>
								<html:text property="bookDate" size="30" styleClass="hid"/>
								<%=formater.format(pcm.getBookDate())%>
							<%}%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap>Flight Date(YYYY-MM-DD):&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="costDate" size="30"/>
								<A href="javascript:ShowCalendar(document.ProjectCostMaintainForm.dimg2,document.ProjectCostMaintainForm.costDate,null,0,330)" 
									onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
							<%}else{%>
								<html:text property="costDate" size="30" styleClass="hid"/>
								<%=formater.format(pcm.getCostdate())%>
							<%}%>
						</td>
						<td class="lblbold" nowrap>Flight time:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="takeOffTime" size="30"/>
							<%}else{%>
								<html:text property="takeOffTime" size="30" styleClass="hid"/>
								<%=pcm.getTakeOffTime()%>
							<%}%>
						</td>
					</tr>	
					<tr>
						<td class="lblbold" nowrap>Price:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="totalValue" size="30" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999); addComma(this, '.', '.', ',');"/>
							<%}else{%>
								<html:text property="totalValue" size="30" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999); addComma(this, '.', '.', ',');" styleClass="hid"/>
								<%=pcm.getTotalvalue()%>
							<%}%>
						</td>
						<td class="lblbold" nowrap>Destination:&nbsp;</td>
						<td>&nbsp;
							<%if(!isPA){
							  if (destination==null||destination.equals("")){%>
								<input type="text" name="destination" value="<%=pcm!=null ? pcm.getDestination():""%>" size="30">
							<%}else{%>
							<input type="text" name="destination" value="<%=destination%>" size="30">
							<%}
							}else{%>
							<%=pcm!=null ? pcm.getDestination():""%>
								
							<%}%>
						</td>
					</tr>					
					<tr height="15">
						<td class="lblbold" bgcolor="#b4d4d4" colspan="4">From cTrip - www.ctrip.com:</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap>Price of Same Flight:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="sameFlightPrice" size="30" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999); addComma(this, '.', '.', ',');"/>
							<%}else{%>
								<html:text property="sameFlightPrice" size="30" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999); addComma(this, '.', '.', ',');" styleClass="hid"/>
								<%=pcm.getSameFlightPrice()%>
							<%}%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" colspan="2" nowrap align="center">
							<font color="#9A2929">
								Lowest in 4 hours
							</font>
						</td>
						<td class="lblbold" colspan="2" nowrap align="center">
							<font color="#9A2929">
								Lowest that day
							</font>
						</td>
					</tr>			
					<tr>
						<td class="lblbold" nowrap>Flight No.:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="flightNoIn4" size="30"/>
							<%}else{%>
								<html:text property="flightNoIn4" size="30" styleClass="hid"/>
								<%=pcm.getFlightNoIn4()%>
							<%}%>
						</td>
						<td class="lblbold" nowrap>Flight No.:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="flightNoInDay" size="30"/>
							<%}else{%>
								<html:text property="flightNoInDay" size="30" styleClass="hid"/>
								<%=pcm.getFlightNoInDay()%>
							<%}%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap>Flight time:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="takeOffTimeIn4" size="30"/>
							<%}else{%>
								<html:text property="takeOffTimeIn4" size="30" styleClass="hid"/>
								<%=pcm.getTakeOffTimeIn4()%>
							<%}%>
						</td>
						<td class="lblbold" nowrap>Flight time:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="takeOffTimeInDay" size="30"/>
							<%}else{%>
								<html:text property="takeOffTimeInDay" size="30" styleClass="hid"/>
								<%=pcm.getTakeOffTimeInDay()%>
							<%}%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" nowrap>Price:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="priceIn4" size="30" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999); addComma(this, '.', '.', ',');"/>
							<%}else{%>
								<html:text property="priceIn4" size="30" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999); addComma(this, '.', '.', ',');" styleClass="hid"/>
								<%=pcm.getPriceIn4()%>
							<%}%>
						</td>
						<td class="lblbold" nowrap>Price:&nbsp</td>
						<td class="lblbold">&nbsp;
							<%if(!isPA){%>
								<html:text property="priceInDay" size="30" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999); addComma(this, '.', '.', ',');"/>
							<%}else{%>
								<html:text property="priceInDay" size="30" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999); addComma(this, '.', '.', ',');" styleClass="hid"/>
								<%=pcm.getPriceInDay()%>
							<%}%>
						</td>
					</tr>
					<%}%>
					<tr>
						<td colspan=4>
						<%
							String approvalDate = (String)request.getAttribute("approvalDate");
							String paConfirm = (String)request.getAttribute("paConfirm");
							if(approvalDate==null)	approvalDate = "";
							if(paConfirm==null)	paConfirm = "";
						%>
						<%if(isPA){%>
							<%if (paConfirm.equals("no")) {%>
							<input TYPE="button" class="button" name="save" value="Save" onclick="javascript:SaveRecords('no')">&nbsp;&nbsp;
							<%}%>
						<%}%>
						<%if(!isPA){%>
							<%//if (FreezeFlag.equals("N") && (approvalDate == null || approvalDate.trim().length() == 0)) {%>
							<input TYPE="button" class="button" name="save" value="Save" onclick="javascript:SaveRecords('yes')">&nbsp;&nbsp;
							<%//}%>
							<%if (FreezeFlag.equals("N")) {%>
							<input TYPE="button" class="button" name="confirm" value="Confirm" onclick="javascript:ConfirmRecords()">&nbsp;&nbsp;
							<%}%>
							<%if ((FreezeFlag.equals("N")) && (approvalDate.trim().length() != 0)) {%>
							<input TYPE="button" class="button" name="unconfirm" value="Un-Confirm" onclick="javascript:UNConfirmRecords()">&nbsp;&nbsp;
							<%}%>
							<%if (FreezeFlag.equals("N") && (approvalDate == null || approvalDate.trim().length() == 0)) {%>
							<input TYPE="button" class="button" name="delete" value="Delete" onclick="javascript:OnDelete()">&nbsp;&nbsp;
							<%} }
							%>
							<input type="button" value="Back to List" name="Back" class="button" onclick="location.replace('findCostSelfPage.do?Type=<%=Type%>&CostType=<%=costType%>');">
						</td>
					</tr>
				</table>
				</td>
				<td></td>
			</tr>
			<!-- Area Footer Information -->
			<tr height="8">
				<td width="8" bgcolor="#deebeb" valign="bottom" align="left"><img src="images/corner3grey.gif" width="4" height="4" border="0"></td>
				<td bgcolor="#deebeb"><img src="images/spacer.gif" width="1" height="8" border="0"></td>
				<td width="8" bgcolor="#deebeb" valign="bottom" align="right"><img src="images/corner4grey.gif" width="4" height="4" border="0"></td>
			</tr>
		</table>
	</td>
	<!-- Right Spacer -->
	<td width=1%>
	<img src="images/spacer.gif" width="2" height="1" border="0">
	</td>
	</tr>
</table>
<input type="hidden" name="DataId" value="<%=DataId%>">
</html:form>
<script language="javascript">
	if (document.getElementById("totalValue").value == "") {
		document.getElementById("totalValue").value = "0";
	}
	if (document.getElementById("sameFlightPrice").value == "") {
		document.getElementById("sameFlightPrice").value = "0";
	}
	if (document.getElementById("priceIn4").value == "") {
		document.getElementById("priceIn4").value = "0";
	}
	if (document.getElementById("priceInDay").value == "") {
		document.getElementById("priceInDay").value = "0";
	}
	addComma(document.getElementById("totalValue"), '.', '.', ',');
	addComma(document.getElementById("sameFlightPrice"), '.', '.', ',');
	addComma(document.getElementById("priceIn4"), '.', '.', ',');
	addComma(document.getElementById("priceInDay"), '.', '.', ',');
</script>
<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
}catch (Exception e){
	e.printStackTrace();
	}
%>

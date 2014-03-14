<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="java.util.*"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<%
List currencyList = (List)request.getAttribute("currencyList");

Iterator itCurr = currencyList.iterator();
String rateStr = "";
while(itCurr.hasNext()){
	com.aof.component.prm.project.CurrencyType curr = (com.aof.component.prm.project.CurrencyType)itCurr.next();
	rateStr = rateStr+curr.getCurrRate().toString()+"$";
}
try{
	List partyList = (List)request.getAttribute("PartyList");
	String dept = (String)request.getAttribute("dept");
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	List slList = (List)request.getAttribute("slList");
	if(slList == null) slList = new ArrayList();

	String action = request.getParameter("formAction");
	if(action == null) action = "new";

	String exchangeRateStr = "";
	
	String offSet = "";
	if((String)request.getAttribute("offSet") != null){
		offSet = (String)request.getAttribute("offSet");
	}
%>
<script language="javascript">

function caculateRMB(){
	var amount = 0;
	var estimateAmt = 0;
	var exchangeRate = 0;
	estimateAmt = parseFloat(document.EditForm.estimateAmount.value);
	exchangeRate = parseFloat(document.EditForm.exchangeRate.value);
	amount = estimateAmt * exchangeRate;
	document.EditForm.caculatedAmt.value = Math.round(amount*100)/100;
	addComma(document.EditForm.caculatedAmt, '.', '.', ',');
}

function FnCreate() {
	var errormessage= ValidateData();
	if (errormessage != "") {
		alert(errormessage);
	}else{   
		if(validate()){
			document.EditForm.formAction.value = "new";
	  		document.EditForm.submit();
	  	}
	}
}

function checkStartDate(sDate){
	var t = new Date(sDate.replace(/\-/g,"/"));
	var nowDate = new Date();
	
	if(nowDate>t){
		if(window.confirm("Estimated Contract Start Date should not be today or earlier! Want to save change?")){
			return true;
		} else {
			return false;
		}
	}else{
		return true;
	}
}

function validate(){
   	var startDate = document.EditForm.estimateStartDate;
   	var endDate = document.EditForm.estimateEndDate;
   	var contractValue = document.EditForm.estimateAmount;
   	
   	if(contractValue.value == "" || contractValue.value == 0){
   		alert("Total Contract Value cannot be ignored or 0!");
		return false;
   	}
	if(startDate.value==""){
		alert("Estimated Contract Start Date cannot be ignored!");
		return false;
	}
	if(endDate.value==""){
		alert("Estimated Contract End Date cannot be ignored!");
		return false;
	}
	if (startDate.value.length>0 && endDate.value.length==0){
	  	if(dataOneCheck(startDate)){
	  		if(!checkStartDate(startDate.value))	return false;
	  	}else{
	  		return false;
	  	}
	}
	if(document.getElementById("expectedEndDate").value == ""){
		alert("The Expected Contract Sign Date cannot be ignored!");
		return false;
	}
	if ((document.getElementById("expectedEndDate").value != "")&(document.getElementById("expectedEndDate").value > document.getElementById("estimateStartDate").value)){
		if (!confirm("The Contract Sign Date should not be later than Contract Start Date! Do you want to continue?")){
			return false;
		}
	}
	if(document.getElementById("PresalePMId").value == ""){
		alert("The presale manager cannot be ignored!");
		return false;
	}
	if(document.getElementById("prospectCompanyId").value == ""){
		alert("The Customer cannot be ignored!");
		return false;
	 	}
	if((startDate.value.length>0 && endDate.value.length>0) ){
	   	if(dataCheck(startDate,endDate)){
	   		if(!checkStartDate(startDate.value))	return false;
	   	}else{
	   		return false;
	   	}
	}
	if(startDate.value.length==0 && endDate.value.length>0){
	    alert("End Date cannot be earlier than Start Date!");
	    return false;
	}
	var a = document.getElementsByName("unweightedValue");
	if(a[0]==null){
		return true;
	}
	var estValueByYear = 0;
	for(i=0;i<a.length;i++){
		removeComma(a[i]);
		estValueByYear = estValueByYear+parseFloat(a[i].value);
	}
	
	removeComma(document.EditForm.caculatedAmt);
	var estValue = parseFloat(document.EditForm.caculatedAmt.value);
	addComma(document.EditForm.caculatedAmt, '.', '.', ',');
	
	if(Math.abs(estValueByYear-estValue)>1){
		alert("Yearly Amount must be equal to the Estimated Contract Value !");
		return false;
	}
	return true;
}

function ValidateData() {
	var errormessage="";
	if(document.EditForm.description.value == 0){
		errormessage="Bid Description cannot be ignored!";
		document.EditForm.description.focus();
		return errormessage;
    }
    return errormessage;
}

function showProspectDialog(){
	var code,desc;

		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogProspectList.do",
			null,
			'dialogWidth:560px;dialogHeight:660px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			document.getElementById("prospectCompanyId").value=code;
			desc=v.split("|")[1];
			document.getElementById("name").innerHTML=desc;
			document.getElementById("chineseName").innerHTML  = v.split("|")[2];
			document.getElementById("address").innerHTML = v.split("|")[4];
			document.getElementById("industry").innerHTML = v.split("|")[5];
			document.getElementById("bankno").innerHTML = v.split("|")[3];
			document.getElementById("custGroup").innerHTML = v.split("|")[6];
			document.getElementById("postCode").innerHTML = v.split("|")[7];
			document.getElementById("teleNo").innerHTML = v.split("|")[8];
			document.getElementById("faxNo").innerHTML  = v.split("|")[9];
			var industryId = v.split("|")[10];
			var customerGroupId = v.split("|")[11];
	}
}
function showProspectDialog1(){
	var code,desc,pid;
	pid=document.getElementById("prospectCompanyId").value;

		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&editProspect.do?openType=dialogView&PartyId="+pid,
			null,
			'dialogWidth:560px;dialogHeight:660px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			document.getElementById("prospectCompanyId").value=code;
			desc=v.split("|")[1];
			document.getElementById("name").innerHTML=desc;
			document.getElementById("chineseName").innerHTML  = v.split("|")[2];
			document.getElementById("address").innerHTML = v.split("|")[4];
			document.getElementById("industry").innerHTML = v.split("|")[5];
			document.getElementById("bankno").innerHTML = v.split("|")[3];
			document.getElementById("custGroup").innerHTML = v.split("|")[6];
			document.getElementById("postCode").innerHTML = v.split("|")[7];
			document.getElementById("teleNo").innerHTML = v.split("|")[8];
			document.getElementById("faxNo").innerHTML  = v.split("|")[9];
			var industryId = v.split("|")[10];
			var customerGroupId = v.split("|")[11];		
	}
}

function showDialog_account(){
	var code,desc;
	with(document.EditForm){
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&SalesUserList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:550px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelSales.innerHTML=code+":"+desc;
			salesPersonId.value=code;
		} else {
			labelSales.innerHTML="";
			salesPersonId.value="";
		}
	}
}
function showDialog_account2(){
	var code,desc;
	with(document.EditForm){
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&SalesUserList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:550px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelSales2.innerHTML=code+":"+desc;
			salesPersonId2.value=code;
		} else {
			labelSales2.innerHTML="";
			salesPersonId2.value="";
		}
	}
}

function showDialog_presalePM(){
	var code,desc;
	with(document.EditForm){
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelPresalePM.innerHTML=code+":"+desc;
			PresalePMId.value=code;
		} else {
			labelPresalePM.innerHTML="";
			PresalePMId.value="";
		}
	}
}

function onDepSelect(){
	var slFlag = false;
	<%
	for(int i = 0; i < slList.size(); i++){
		UserLogin tmpUser = (UserLogin)slList.get(i);
	%>
	if(document.EditForm.dapartmentId.value == "<%=tmpUser.getParty().getPartyId()%>"){
		var slFlag = true;
		document.getElementById("labelPresalePM").innerHTML="<%=tmpUser.getName()%>";
		document.EditForm.PresalePMId.value="<%=tmpUser.getUserLoginId()%>";
	}
	<%
	}
	%>
	
	if(!slFlag){
		document.getElementById("labelPresalePM").innerHTML="Please define";
		document.EditForm.PresalePMId.value="";
	}
}


function onCurrSelect(){
	
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	
	with(document.EditForm) {
		exchangeRate.value = RateArr[currencyId.selectedIndex];
		labelCurrencyRate.innerHTML=exchangeRate.value;
		
		var estValue = 0.0;
		
		if(estimateAmount.value != ""){
			estValue = parseFloat(estimateAmount.value.replace(/,/g, ""));
		}
		
		caculatedAmt.value = parseFloat(estimateAmount.value.replace(/,/g, "")) * parseFloat(exchangeRate.value);
		checkDeciNumber2(caculatedAmt,1,1,'caculatedAmt',-9999999999,9999999999);
		addComma(caculatedAmt, '.', '.', ',');
	}
}
</script>
<form action="editBidMaster.do" method="post" name="EditForm">
	<IFRAME
		frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize
		scrolling=no src="includes/date/calendar.htm"
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
	<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
	<table width=100% cellpadding="1" border="0" cellspacing="1">	
		<tr>
			<td align=left width='90%' class="wpsPortletTopTitle" colspan=6>New Bid Master</td>
		</tr>
		<tr>
			<td width='100%'>
			
				<input type="hidden" name="formAction" value="new"> 
				<input type="hidden" name="prospectCompanyId" value="">
				<input type="hidden" name="departmentId" value="<%=dept%>">
				<input type="hidden" name="offSet" value="<%=offSet%>">
				
				<table width='100%' border='0' cellspacing='2' cellpadding='0'>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Bid No.:&nbsp;</span></td>
						<td colspan=2>System Auto Generate</td>
						<td align="right" class="lblbold"><span class="tabletext">Bid Description:&nbsp;</span></td>
						<td colspan=2><input type="text" class="inputBox" name="description" value="" size="50" /></td>
					</tr>
					<tr>
						<td align="right" class="lblbold">Department:&nbsp;</td>
						<td class="lblLight" colspan=2>
							<select name="dapartmentId" onchange="javascript:onDepSelect()" class="inputBox">
								<%
								Iterator itd = partyList.iterator();
								while(itd.hasNext()){
									Party p = (Party)itd.next();
								%>
								<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
								<% 
								}
								%>
							</select>
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Presale PM:&nbsp;</span></td>
						<td align="left" colspan=2>
							<%
							String tmpPartyId = ((Party)partyList.get(0)).getPartyId();
							UserLogin tmpSL = null;
							for(int s=0;s<slList.size();s++){
								UserLogin tmpValue = (UserLogin)slList.get(s);
								if(tmpValue.getParty().getPartyId().equals(tmpPartyId)){
									tmpSL = tmpValue;
									break;
								}
							}
							%>
							<div style="display:inline" id="labelPresalePM"><%=tmpSL == null ? "" : tmpSL.getName()%></div>
							<input type="hidden" name="PresalePM" maxlength="100" value=""> 
							<input type="hidden" name="PresalePMId" value="<%=tmpSL == null ? "" : tmpSL.getUserLoginId()%>">
							<a href="javascript:showDialog_presalePM()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						</td>	
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Sales Person:&nbsp;</span>
						</td>
						<td align="left" colspan=2>
							<%
							String spId = "";
							String spName = "";
							spId = ul.getUserLoginId();
							spName = ul.getName();
							%>
							<div style="display:inline" id="labelSales"><%=spName%>&nbsp;</div>
							<input type="hidden" name="salesPersonName" maxlength="100" value="<%=spName%>">
							<input type="hidden" name="salesPersonId" value="<%=spId%>">
							<a href="javascript:showDialog_account()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Secondary Sales Person:&nbsp;</span></td>
						<td align="left" colspan=2>
							<div style="display:inline" id="labelSales2">&nbsp;</div>
							<input type="hidden" name="salesPersonName2" maxlength="100" value="">
							<input type="hidden" name="salesPersonId2" value="">
							<a href="javascript:showDialog_account2()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Currency:&nbsp;</span></td>
						<td colspan=2>
							<select name="currencyId" onchange="javascript:onCurrSelect()" class="inputBox">
							<%
							
							for (int i0 = 0; i0 < currencyList.size(); i0++) {
								CurrencyType curr = (CurrencyType)currencyList.get(i0);
								if (curr.getCurrId().equals("RMB")){
									exchangeRateStr = curr.getCurrRate().toString();
								%>
								<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
								<%
								} else {
								%>
								<option value="<%=curr.getCurrId()%>"><%=curr.getCurrName()%></option>
							<%
								}
							}
							%>
							</select>
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Total Contract Value:&nbsp;</span></td>
	        			<td colspan=2>
							<input type="text" class="inputBox" name="estimateAmount" value="0.00" size="30" onblur="checkDeciNumber2(this,1,1,'estimateAmount',-9999999999,9999999999); caculateRMB(); addComma(this, '.', '.', ',');">
	        			</td>
					</tr>
					<tr>			
						<td align="right" class="lblbold" class="inputBox"><span class="tabletext">Exchange Rate(RMB):&nbsp;</span></td>
	    				<td colspan=2>
							<div style="display:none" id="labelCurrencyRate"></div>	
							<input type=text name="exchangeRate" readonly style="border:0px;" value="<%if(exchangeRateStr !=null) out.print(exchangeRateStr); %>" class="inputBox">	      				
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Total Contract Value(RMB):&nbsp;</span></td>
	    				<td colspan=5>
							<input type="text"  class="inputBox" style="border:0px" readonly name="caculatedAmt" value="">
	    				</td>
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Estimated Start Date:&nbsp;</span></td>
	    				<td colspan=2>
		    				<input type="hidden" name="hid_estimateStartDate" value="no">
		    				<input type="text" class="inputBox" name="estimateStartDate" oldvalue="" value="" size="10">
		      				<A href="javascript:ShowCalendar(document.EditForm.dimgs,document.EditForm.estimateStartDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimgs src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Contract Type:</span></td>
						<td colspan=2 align="left">
							<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="FP" checked>Fixed Price
							<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="TM">Time &amp; Material
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Estimated End Date:&nbsp;</span></td>
	    				<td colspan=2>
	    					<input type="hidden" name="hid_estimateEndDate" value="no">
	      					<input type="text" class="inputBox" name="estimateEndDate" oldvalue="" value="" size="10">
	      					<A href="javascript:ShowCalendar(document.EditForm.dimge,document.EditForm.estimateEndDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimge src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Expected Sign Date:</span></td>
	        			<td colspan=2>
	        				<input type="hidden" name="hid_expectedEndDate" value="no">
	        				<input type="text" class="inputBox" name="expectedEndDate" oldvalue="" value="" size="10">
	          				<A href="javascript:ShowCalendar(document.EditForm.dimgx,document.EditForm.expectedEndDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimgx src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
					</tr>
					<tr>
						<td colspan=5 align=right>
						<input type="button" value="Save" class="button" onclick="javascript:FnCreate();"/>
						<input type="button" value="Back To List" class="button" onclick="location.replace('ListSalesBid.do?qryDepartmentId=<%=dept%>&offSet=<%=offSet%>')"/>		
						</td>
					</tr>
				</table>
			</td>
		</tr>
	
	</table>
	
	<table width=100%><tr><td><hr color=red></hr></td></tr></table>
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<tr>
			<td>
				<table width=100% cellpadding="1" border="0" cellspacing="1">
					<tr><td class="lblLight">
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<span style="color:#1E90FF"><font size="4px">Customer Details</font></span>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
					</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width='100%' border='0' cellspacing='2' cellpadding='0'>
					<tr>
						<td align=left width='100%' class="wpsPortletTopTitle" colspan=6>Customer Details</TD>
					</tr>
					<tr>
						<td align="right"  class="lblbold">
							<span class="tabletext">Customer Name:&nbsp;</span>
							<input type="hidden" name="prospectCompanyId" value="">
						</td>
						<td align="left" width=25% colspan=2>
							<a href="javascript:void(0)" onclick="showProspectDialog1();event.returnValue=false;"><div style="display:inline" id="name"></div></a>
							<a href="javascript:void(0)" onclick="showProspectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0" /></a>  
						</td>
						<td align="right" width=25% class="lblbold"><span class="tabletext" >Chinese Name:&nbsp;</span></td>
						<td align="left" width=25% colspan=2><div style="display:inline" id="chineseName">&nbsp;</div></td>
					</tr>
					<tr>
						<td align="right" width=25% class="lblbold"><span class="tabletext">Industry:&nbsp;</span></td>
						<td align="left" width=25% colspan=2><div style="display:inline" id="industry">&nbsp;</div></td>
						<td align="right" width=25% class="lblbold"><span class="tabletext">Group:&nbsp;</span></td>
						<td align="left" width=25% colspan=2><div style="display:inline" id="custGroup">&nbsp;</div></td>
						<td align="right" width=25% class="lblbold"></td>
					</tr>
					<tr>
						<td align="right" width=25% class="lblbold"><span class="tabletext">Address:&nbsp;</span></td>
						<td align="left" width=25% colspan=2><div style="display:inline" id="address">&nbsp;</div></td>
						<td align="right" width=25% class="lblbold"><span class="tabletext">Post Code:&nbsp;</span></td>
						<td align="left" width=25% colspan=2><div style="display:inline" id="postCode">&nbsp;</div></td>
					</tr>
					<tr>
						<td align="right" align="right" width=25% class="lblbold"><span class="tabletext">Telephone No.:&nbsp;</span></td>
						<td align="left" width=25% colspan=2><div style="display:inline" id="teleNo">&nbsp;</div></td>
						<td align="right" width=25% class="lblbold"><span class="tabletext">Fax No:&nbsp;</span></td>
						<td align="left" width=25% colspan=2><div style="display:inline" id="faxNo">&nbsp;</div></td>
					</tr>
					<tr>
						<td align="right" width=25% class="lblbold"><span class="tabletext">Bank No.:&nbsp;</span></td>
						<td align="left" width=25% colspan=2><div style="display:inline" id="bankno">&nbsp;</div></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
<%
	}catch(Exception e){
		e.printStackTrace();
	}
%>
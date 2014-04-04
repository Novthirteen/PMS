<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>


<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
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
}
try{
    NumberFormat Num_formater = NumberFormat.getInstance();
    Num_formater.setMaximumFractionDigits(2);
	Num_formater.setMinimumFractionDigits(2);
	NumberFormat Num_formater2 = NumberFormat.getInstance();
	Num_formater2.setMaximumFractionDigits(5);
	Num_formater2.setMinimumFractionDigits(2);
	SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
	
	BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
	List partyList = (List)request.getAttribute("PartyList");
	List slList = (List)request.getAttribute("slList");
	if(slList == null) slList = new ArrayList();
	
	String dept = (String)request.getAttribute("dept");
	String offSet = "";
	if((String)request.getAttribute("offSet") != null){
		offSet = (String)request.getAttribute("offSet");
	}
	
	String con = (String)request.getSession().getAttribute("oldURL");
	
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	
	CurrencyType currency = null;
	String startDateStr = "";
	String endDateStr = "";
	String postDateStr = "";
	String expectedEndDate="";
	String createDateStr = "";
	String estimateAmountStr = "";
	String exchangeRateStr = "";
	String description = "";
	String status = "";
	String departmentId = "";
	String currencyId = "";
	
	String id = null;
	String no = "";
	String contractType = "";
		
	if (bidMaster!=null){
    	no = bidMaster.getNo();
    	contractType = bidMaster.getContractType();
    	currency = bidMaster.getCurrency();
    	description = bidMaster.getDescription();

    	id = bidMaster.getId() + "";
    	if(bidMaster.getDepartment() != null){
    		departmentId = bidMaster.getDepartment().getPartyId() + "";
    	}
    	if(bidMaster.getCurrency() != null){
    		currencyId = bidMaster.getCurrency().getCurrId() + "";
    	}
		java.util.Date startdate = bidMaster.getEstimateStartDate();
		if(startdate!=null){
	    	startDateStr=formater.format(startdate);
	    }
	    
		java.util.Date endDate = bidMaster.getEstimateEndDate();
		if(endDate!=null){
	    	endDateStr=formater.format(endDate);
		}
		
		java.util.Date createDate = bidMaster.getCreateDate();
		if(createDate!=null){
	    	createDateStr=formater.format(createDate);
		}
		
		java.util.Date postDate = bidMaster.getPostDate();
		if(postDate!=null){
	    	postDateStr=formater.format(postDate);
		}
		java.util.Date expectedDate = bidMaster.getExpectedEndDate();
		if(expectedDate!=null){
	    	expectedEndDate=formater.format(expectedDate);
		}
		if(bidMaster.getEstimateAmount()!=null){
			estimateAmountStr = Num_formater.format(bidMaster.getEstimateAmount());
		}
		if(bidMaster.getExchangeRate()!=null){
			exchangeRateStr = Num_formater.format(bidMaster.getExchangeRate());
		}
		if(bidMaster.getDescription()!=null){
			description = bidMaster.getDescription();
		}
		if(bidMaster.getStatus()!=null){
			status = bidMaster.getStatus();
		}
			
	}
	String action = request.getParameter("formAction");
	if(action == null){
		action = "update";
	}

	String column = request.getParameter("column");
	if (column == null || column.equals("")) {
		column = "Prospect";
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

	function FnUpdate() {
	  	var errormessage= ValidateData();
	  	var stDate = document.EditForm.estimateStartDate;
		var hid_stDate = document.EditForm.hid_estimateStartDate;
		var edDate = document.EditForm.estimateEndDate;
		var hid_edDate = document.EditForm.hid_estimateEndDate;
		var exDate = document.EditForm.expectedEndDate;
		var hid_exDate = document.EditForm.hid_expectedEndDate;
		var stus = document.EditForm.statusValue;
		var oldStus = "<%=bidMaster!=null?bidMaster.getStatus():""%>";
		if (errormessage != "") {
			alert(errormessage);
		} else {
			if ((stus.value !=oldStus )){
				if(stus.value == "Lost/Drop"){
					if(!fnChangeStatus()){
						return;
					}
				}else{
					if(window.confirm('Do you want to Leave a reson for status change?'))
						fnChangeStatus();
				}
				hid_stDate.value="yes";
			}
			if(stDate.value != stDate.oldvalue) {
				hid_stDate.value="yes";
			}
			if(edDate.value!=edDate.oldvalue) {
				hid_edDate.value="yes";
			}
			if(exDate.value!=exDate.oldvalue) {
				hid_exDate.value="yes";
			}
	      	if(validate()){
	      	
	      		var oldStartDate = document.EditForm.estimateStartDate.oldvalue;
	      		var newStartDate = document.EditForm.estimateStartDate.value;
	      		
	      		var oldEndDate = document.EditForm.estimateEndDate.oldvalue;
	      		var newEndDate = document.EditForm.estimateEndDate.value;
	      		
	      		var oldTCV = parseFloat(document.EditForm.caculatedAmt.oldvalue.replace(/,/g, ""));
	      		var newTCV = parseFloat(document.EditForm.caculatedAmt.value.replace(/,/g, ""));
	      		
	      		if(oldStartDate != newStartDate){
	      			alert("Estimated Start Date has been changed, Unweighted Value maybe need recalculation, please check it!");
	      		}
	      		
	      		if(oldEndDate != newEndDate){
	      			alert("Estimated End Date has been changed, Unweighted Value maybe need recalculation, please check it!");
	      		}
	      		
	      		if(oldTCV != newTCV){
	      			alert("Total Contract Value (RMB) has been changed, Unweighted Value maybe need recalculation, please check it!");
	      		}

	      		document.EditForm.formAction.value = "update";
		  		document.EditForm.submit();

		  	}
		}
	}

	function checkStartDate(sDate){
		var t = new Date(sDate.replace(/\-/g,"/"));
		var nowDate = new Date();
		var status = "<%=bidMaster!=null?bidMaster.getStatus():""%>";
		
		if(nowDate>t && status!="Won"){
			if(window.confirm("Estimated Contract Start Date should not be today or earlier! Do you realy want to save change?")){
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
	    if((startDate.value.length>0 && endDate.value.length>0)){
	       	if(dataCheck(startDate,endDate)){
	       		if(!checkStartDate(startDate.value)){
	       			return false;
	       		}	
	       	}else{
	       		return false;
	       	}
	    }
	    if(startDate.value.length==0 && endDate.value.length>0){
	        alert("End Date cannot be earlier than Start Date!");
	        return false;
	    }
	    
		return true;
	}

	function ValidateData(){
		var errormessage="";
		if(document.EditForm.description.value == 0){
			errormessage="Bid Description cannot be ignored!";
			document.EditForm.description.focus();
			return errormessage;
	    }
	    return errormessage;
	}

	function FnDelete() {
		if (confirm("Do you want delete this Bid?")){
			v = window.showModalDialog(
				"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&editBidMaster.do?formAction=predel",
				null,
				'dialogWidth:400px;dialogHeight:250px;status:no;help:no;scroll:no');
			
			if (v !=null && v != ""){
				document.EditForm.formAction.value = "delete";
				document.EditForm.reason.value = v;
				document.EditForm.submit();
			}else{
				alert("You must input the reason for delete the bid master.");
				return;
			}
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

	function ExportExcel(){
		var formObj = document.EditForm;
		formObj.formAction.value = "ExportToExcel";
//		formObj.target = "_self";
		formObj.submit();
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

	function fnChangeStatus(){
		var status = document.EditForm.status.value;
		if(status == "Lost/Drop"){
			var param = "?formAction=dialog";
			param += "&id=" + <%=id%>;
				
			v = window.showModalDialog(
				"system.showDialog.do?title=prm.pms.precal.title&editBidMaster.do" + param,
				null,
				'dialogWidth:400px;dialogHeight:250px;status:no;help:no;scroll:no');
			if (v !=null && v != ""){
				document.EditForm.changeReason.value = v;
				return true;
			}else{
				alert("You must input the reason for changing the bid master's status to Lost/Drop.");
				return false;
			}
		}else{
			var param = "?formAction=dialog";
			param += "&id=" + <%=id%>;
				
			v = window.showModalDialog(
				"system.showDialog.do?title=prm.pms.precal.title&editBidMaster.do" + param,
				null,
				'dialogWidth:400px;dialogHeight:250px;status:no;help:no;scroll:no');
			if (v !=null && v != ""){
				document.EditForm.changeReason.value = v;
			}else{
				document.EditForm.changeReason.value = "";
			}
			return true;
		}
	}
	
	function fnOnchangeStatus(){
		document.EditForm.statusValue.value = document.EditForm.status.value;
	}

	function changeColumn(column) {
		document.EditForm.formAction.value = "view";
		document.EditForm.column.value = column;
		document.EditForm.submit();
	}
	
</script>
<form action="editBidMaster.do" method="post" name="EditForm">
	<IFRAME
		frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize
		scrolling=no src="includes/date/calendar.htm"
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
	</IFRAME>
	<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">

	<table width=100% cellpadding="1" border="0" cellspacing="1">	
		<tr>
			<td align=left width='90%' class="wpsPortletTopTitle" colspan=6>Bid Master Maintenance</td>
		</tr>
		<tr>
			<td width='100%'>
				<input type="hidden" name="formAction" id="formAction" value="">
				<input type="hidden" name="id" id="id" value="<%=id != null ? id : ""%>">
				<input type="hidden" name="reason" id="reason">
				<input type="hidden" name="changeReason" id="changeReason">
				<input type="hidden" name="departmentId" id="departmentId" value="<%=dept%>">
				<input type="hidden" name="offSet" id="offSet" value="<%=offSet%>">
				<input type="hidden" name="column" id="column" value="<%=column%>">
				
				<table width='100%' border='0' cellspacing='2' cellpadding='0'>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Bid No.:&nbsp;</span></td>
						<td colspan=2><%=no%></td>
						<td align="right" class="lblbold"><span class="tabletext">Bid Description:&nbsp;</span></td>
						<td colspan=2><input type="text" class="inputBox" name="description" id="description" value="<%=description%>" size="50" /></td>
					</tr>
					<tr>
						<td align="right" class="lblbold">Department:&nbsp;</td>
						<td class="lblLight" colspan=2>
							<select name="dapartmentId" id="dapartmentId" onchange="javascript:onDepSelect()" class="inputbox">
								<%
								String sqlStr = "";
								String pmid="";
								String pmname="";
								Iterator itd = partyList.iterator();
								String slk ="";
								while(itd.hasNext()){
									Party p = (Party)itd.next();
									if((bidMaster!=null)&&(p!=null)){
										if (p.getPartyId().equals(bidMaster.getDepartment().getPartyId() )) {
											slk="selected";
										}
									}
								%>
								<option value="<%=p.getPartyId()%>" <%=slk%>><%=p.getDescription()%></option>
								<% 
								slk ="";
								}
								%>
							</select>
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Presale PM:&nbsp;</span></td>
						<td align="left" colspan=2>
							<%
							String presalePMId = "";
							String presalePMName = "";
							if(bidMaster != null){
								if (bidMaster.getPresalePM()!= null) {
									presalePMId= bidMaster.getPresalePM().getUserLoginId();
									presalePMName = bidMaster.getPresalePM().getName();
								}
							}
							%>
							<div style="display:inline" id="labelPresalePM"><%=presalePMName%>&nbsp;</div>
							<input type="hidden" readonly="true" name="PresalePM" id="PresalePM" maxlength="100" value="<%=presalePMName%>"> 
							<input type="hidden" name="PresalePMId" id="PresalePMId" value="<%=presalePMId%>"> 
							<a	href="javascript:showDialog_presalePM()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						</td>	
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Sales Person:&nbsp;</span></td>
						<td align="left" colspan=2>
							<%
							String spId = "";
							String spName = "";
							if(bidMaster != null){
								if (bidMaster.getSalesPerson() != null) {
									spId = bidMaster.getSalesPerson().getUserLoginId();
									spName = bidMaster.getSalesPerson().getName();
								}
							}
							%>
							<div style="display:inline" id="labelSales"><%=spName%>&nbsp;</div>
							<input type="hidden" readonly="true" name="salesPersonName" id="salesPersonName" maxlength="100" value="<%=spName%>"> 
							<input type="hidden" name="salesPersonId" id="salesPersonId" value="<%=spId%>">
							<a href="javascript:showDialog_account()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						</td>
						<td align="right" class="lblbold"><span class="tabletext">Secondary Sales Person:&nbsp;</span></td>
						<td align="left" colspan=2>
							<%
							String spId2 = "";
							String spName2 = "";
							if(bidMaster != null){
								if (bidMaster.getSecondarySalesPerson()!= null) {
									spId2= bidMaster.getSecondarySalesPerson().getUserLoginId();
									spName2 = bidMaster.getSecondarySalesPerson().getName();
								}
							}
							%>
							<div style="display:inline" id="labelSales2"><%=spName2%>&nbsp;</div>
							<input type="hidden" name="salesPersonName2" id="salesPersonName2" maxlength="100" value="<%=spName2%>"> 
							<input type="hidden" name="salesPersonId2" id="salesPersonId2" value="<%=spId2%>"> 
							<a href="javascript:showDialog_account2()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Currency:&nbsp;</span></td>
						<td colspan=2>
							<select name="currencyId" id="currencyId" onchange="javascript:onCurrSelect()" class="inputbox">
								<%						
								for (int i0 = 0; i0 < currencyList.size(); i0++) {
									CurrencyType curr = (CurrencyType)currencyList.get(i0);
									if(currency != null && curr.getCurrId().equals(currency.getCurrId())){
								%>
								<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
								<%  
								}else if(currency == null && curr.getCurrId().equals("RMB")){
									exchangeRateStr =curr.getCurrRate().toString();
								%>
								<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
								<%  
								}else{
								%>
								<option value="<%=curr.getCurrId()%>"><%=curr.getCurrName()%></option>
							<%	
								}
							}
							%>
							</select>
						</td>
						<td align="right" class="lblbold">
          					<span class="tabletext">Total Contract Value:&nbsp;</span>
       	 				</td>
        				<td colspan=2>
						<input type="text" class="inputBox" name="estimateAmount" id="estimateAmount" value="<%=estimateAmountStr%>" oldvalue="<%=estimateAmountStr%>" size="30" onblur="checkDeciNumber2(this,1,1,'estimateAmount',-9999999999,9999999999); caculateRMB(); addComma(this, '.', '.', ',');">
        				</td>
					</tr>
					<tr>		
						<td align="right" class="lblbold">
          					<span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
       	 				</td>
        				<td colspan=2>
							<div style="display:none" id="labelCurrencyRate"></div>	
							<input type="text" name="exchangeRate" id="exchangeRate" class="inputbox" readonly style="border:0px;" value="<%if(exchangeRateStr !=null) out.print(exchangeRateStr); %>">	      				
						</td>
						<td align="right" class="lblbold">
          					<span class="tabletext">Total Contract Value(RMB):&nbsp;</span>
       	 				</td>
        				<td colspan=2>
							<input type="text"  class="inputBox" style="border:0px" readonly name="caculatedAmt" id="caculatedAmt" oldvalue="<%=bidMaster!=null?Num_formater.format(bidMaster.getEstimateAmount().doubleValue()*bidMaster.getExchangeRate().floatValue()):""%>" value="<%=bidMaster!=null?Num_formater.format(bidMaster.getEstimateAmount().doubleValue()*bidMaster.getExchangeRate().floatValue()):""%>">
        				</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
          					<span class="tabletext">Estimated Start Date:&nbsp;</span>
       	 				</td>
        				<td colspan=2>
        				<input type="hidden" name="hid_estimateStartDate" id="hid_estimateStartDate" value="no">
        				<%
        				if(startDateStr!=null && startDateStr.length()>0){
        				%>
						    <input type="text" class="inputBox" name="estimateStartDate" id="estimateStartDate" oldvalue="<%=startDateStr%>" value="<%=startDateStr%>" size="10">
          				<%
          				}else{
          				%>
          					 <input type="text" class="inputBox" name="estimateStartDate" id="estimateStartDate" oldvalue="" value="" size="10">
          				<%
          				}
          				%>
          					<A href="javascript:ShowCalendar(document.EditForm.dimgs,document.EditForm.estimateStartDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimgs src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
						<td align="right" class="lblbold">
          					<span class="tabletext">Contract Type:</span>
       	 				</td>
						<td colspan=2 align="left">
							<%
							if(contractType != null && !contractType.equals("") && !contractType.equals("null") ){
								if(contractType.equals("FP")){
							%>
							<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="FP" checked>Fixed Price
							<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="TM">Time & Material
							<%	
								}else{
							%>
							<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="FP">Fixed Price
							<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="TM" checked>Time & Material
							<%
								}
							}else{
							%>
							<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="FP" checked>Fixed Price
							<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="TM">Time &amp; Material
							<%
							}
							%>
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
          					<span class="tabletext">Estimated End Date:&nbsp;</span>
       	 				</td>
        				<td colspan=2>
        				<input type="hidden" name="hid_estimateEndDate" id="hid_estimateEndDate" value="no">
        				<%
        				if(endDateStr!=null && endDateStr.length()>0){

        				%>
							<input type="text" class="inputBox" name="estimateEndDate" id="estimateEndDate" oldvalue="<%=endDateStr%>" value="<%=endDateStr%>" size="10">
          				<%
          				}else{
          				%>	
          					<input type="text" class="inputBox" name="estimateEndDate" id="estimateEndDate" oldvalue="" value="" size="10">
          				<%
          				}
          				%>
          					<A href="javascript:ShowCalendar(document.EditForm.dimge,document.EditForm.estimateEndDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimge src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
						<td align="right" class="lblbold" class="inputBox"><span class="tabletext">Status:&nbsp;</span></td>
						<td align="left" colspan=2>
							<% 	
							status = "";
							String display = "none";
							if(bidMaster != null && bidMaster.getStatus() != null){
								status = bidMaster.getStatus();
							}
							if(!status.equalsIgnoreCase("Won")){
								display = "block";
							}
							%>
							<input type="hidden" name="statusValue" id="statusValue" value="<%=status%>">
							<div id="other" style="display:<%=display%>">
  							<select name="status" id="otherStus" class="inputBox" onChange="fnOnchangeStatus()">
  								<option value="Active" <%if (status.equalsIgnoreCase("active")) out.println("selected");%>>Active</option>
								<option value="Lost/Drop" <%if (status.equalsIgnoreCase("Lost/drop")) out.println("selected");%>>Lost/Drop</option>
								<option value="Suspect" <%if (status.equalsIgnoreCase("suspect")) out.println("selected");%>>Suspect</option>
								<option value="Pending" <%if (status.equalsIgnoreCase("pending")) out.println("selected");%>>Pending</option>								
								<option value="Offer" <%if (status.equalsIgnoreCase("offer")) out.println("selected");%>>Offer</option>
								<option value="Prefer Supplier" <%if (status.equalsIgnoreCase("prefer supplier")) out.println("selected");%>>Prefer Supplier</option>
  							</select>
  							</div>
  							<%  if(status.equalsIgnoreCase("Won"))
								display = "block";
								else
								display = "none"; %>
  							<div id="won" style="display:<%=display%>">Won
  							</div>
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
          					<span class="tabletext">Expected Sign Date:</span>
       	 				</td>
        				<td colspan=2>
        					<input type="hidden" name="hid_expectedEndDate" id="hid_expectedEndDate" value="no">
        				<%
        				if(expectedEndDate!=null && expectedEndDate.length()>0){
        				%>
							<input type="text" class="inputBox" name="expectedEndDate" id="expectedEndDate" oldvalue="<%=expectedEndDate%>" value="<%=expectedEndDate%>" size="10">
          				<%
          				}else{
          				%>	
          					<input type="text" class="inputBox" name="expectedEndDate" id="expectedEndDate" oldvalue="" value="" size="10">
          				<%
          				}
          				%>	
          					<A href="javascript:ShowCalendar(document.EditForm.dimgx,document.EditForm.expectedEndDate,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimgx src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
						<!-- 
						<td align="right" class="lblbold">
          					<span class="tabletext">Bid Current WIN %:</span>
       	 				</td>
       	 				<%
						int curr = 0;
						if(bidMaster.getCurrentStep()!=null){
							curr = (bidMaster.getCurrentStep().getPercentage().intValue());
						}
						%>
						<td align="left" class="lblbold"><span class="tabletext"><div style="display:inline" id="winPer"><%=curr%></div>%</span></td>
					-->
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Bid Create Date:</span></td>
        				<%
        				if(createDateStr!=null && createDateStr.length()>0){
        				%>
        				<td  colspan=2><%=createDateStr%></td>
          				<%
          				}
          				%>
						<td colspan="3" align="right">
							<input type="button" value="Save" class="button" onclick="javascript:FnUpdate();"/>
							<%
							if(!status.equalsIgnoreCase("Won")){
							%>
							<input type="button" value="Delete" class="button" onclick="javascript:FnDelete()"/>
							<%
							}
							%>
							<input type="button" class="button" name="btnExport" value="Print Request Form" onclick="javascript:ExportExcel()"/>
							<input type="button" value="Back To List" class="button" onclick="location.replace('ListSalesBid.do?<%=con%>')"/>
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
						<%
						if (column.equals("Prospect")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Customer Details</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('Prospect');"><font size="2px">Customer Details</font></a>
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<%
						if (column.equals("Unweighted")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Unweighted Value List</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('Unweighted');"><font size="2px">Unweighted Value List</font></a>
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<%
						if (column.equals("Contact")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Contact List</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('Contact');"><font size="2px">Contact List</font></a>
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<%
						if (column.equals("Activity")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Sales Phases Tracking</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('Activity');"><font size="2px">Sales Phases Tracking</font></a>		
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
						<nobr>
						<%
						if (column.equals("History")) {
						%>
							<span style="color:#1E90FF"><font size="4px">Bid Master History</font></span>
						<%	
						} else {
						%>
							<a href="#" onclick="changeColumn('History');"><font size="2px">Bid Master History</font></a>
						<%
						}
						%>
						</nobr>
						<span style="color:#999999">&nbsp;|&nbsp;</span>
					</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%">
					<tr><td>
					<%
					if (column.equals("Prospect")) {
					%>
						<jsp:include page="prospectPage.jsp"/>
					<%
					}
					if (column.equals("Unweighted")) {
					%>
						<jsp:include page="unweightedPage.jsp"/>
					<%
					}
					if (column.equals("Contact")) {
					%>
						<jsp:include page="contactPage.jsp"/>
					<%
					}
					if (column.equals("Activity")) {
					%>
						<jsp:include page="activityPage.jsp"/>
					<%
					}
					if (column.equals("History")) {
					%>
						<jsp:include page="historyPage.jsp"/>
					<%
					}
					%>
					</td></tr>
				</table>
			</td>
		</tr>
	</table>
</form>

<%	
	Hibernate2Session.closeSession();

	}catch(Exception e){
		e.printStackTrace();
	}
%>
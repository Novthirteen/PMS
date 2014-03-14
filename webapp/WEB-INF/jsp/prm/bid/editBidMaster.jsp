<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.component.prm.bid.BidUnweightedValue"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/app.tld" prefix="app"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security"
	scope="session" />
<script language='javascript' type="text/javascript"
	src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript"
	src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript"
	src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript"
	src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript"
	src='<%=request.getContextPath()%>/includes/date/date.js'></script>
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
	
	boolean buttonFlag = true;
	
	Log log = LogFactory.getLog("editBidMaster.jsp");
	long timeStart = System.currentTimeMillis();   //for performance test
	
	if (AOFSECURITY.hasEntityPermission("SALES_FUNNEL", "_CREATE", session)) {
		BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
		CustomerProfile prospectCompany = (CustomerProfile)request.getAttribute("prospectCompany");
		Set contactSet = (Set)request.getAttribute("contactList");
		Set bidActivityObject = (Set)request.getAttribute("bidActivityObject");
		SalesStepGroup stepGroup = (SalesStepGroup)request.getAttribute("stepGroup");
		ArrayList steps = (ArrayList)request.getAttribute("stepsList");
		ArrayList bidActivities = (ArrayList) request.getAttribute("bidActivities");
		List partyList = (List)request.getAttribute("PartyList");
		List valueList=(List)request.getAttribute("BidUnweightedValueList");
		
		String dept = (String)request.getAttribute("dept");
		String offSet = "";
		if((String)request.getAttribute("offSet") != null){
			offSet = (String)request.getAttribute("offSet");
		}
		
		Set BidActDetailList = (Set)request.getAttribute("BidActDetailList");
		if(BidActDetailList==null){
			BidActDetailList = new HashSet();
		}
	    Set bmhistoryList = (Set)request.getAttribute("bidmasterhistory");
		if(bmhistoryList==null){
			bmhistoryList = new HashSet();
		}
		
	    UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	    
	    if(contactSet == null)contactSet = new HashSet();
	    
		
		List industryList = null;
		List accountList = null;
		List T2List = null;
		try{
			// 所有机构列表
			CustomerHelper ph = new CustomerHelper();
			industryList = ph.getAllIndustry(hs);
			accountList = ph.getAllAccounts(hs);
			T2List = ph.getAllT2Code(hs);
		}catch(Exception e){
			out.println(e.getMessage());
		}
		
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
		String stepGroupId = null;
		String id = null;
		String no = "";
		String contractType = "";
		
		String prospectCompanyId = "";
		String name = "";
		String chineseName = "";
		String city = "";
		String address = "";
		String bankno = "";
		String industry = "";
		String custGroup = "";
		String postCode = "";
		String faxNo = "";
		String teleNo = "";
		String customerStatus = "";
		if(prospectCompany !=null){
	//		prospectCompanyId = prospectCompany.getPartyId()+"";
//System.out.println("*************prospectCompanyId is +"+prospectCompanyId);
			name = prospectCompany.getDescription();
			chineseName = prospectCompany.getChineseName();
			if (chineseName==null||chineseName.length()<1){
			       chineseName="";
			}
			city = prospectCompany.getCity();
			if (city==null||city.length()<1){
			       city="";
			}
			address = prospectCompany.getAddress();
			if (address==null||address.length()<1){
			       address="";
			}
			bankno = prospectCompany.getAccountCode();
			if (bankno==null||bankno.length()<1){
			       bankno="";
			}
			if(prospectCompany.getIndustry()!=null){
				industry = prospectCompany.getIndustry().getDescription();
			}/*else if(bidMaster.getIndustry()!=null){
			    industry = bidMaster.getIndustry().getDescription();
			    if(industry==null||industry.length()<1){
			    	industry = "";
			    }
			}*/
			//custGroup ="";
			if (prospectCompany.getAccount() !=null){
				custGroup = prospectCompany.getAccount().getDescription();
			}
			postCode = prospectCompany.getPostCode();
			if (postCode==null||postCode.length()<1){
			       postCode="";
			}
			faxNo = prospectCompany.getFaxCode();
			if (faxNo==null||faxNo.length()<1){
			       faxNo="";
			}
			teleNo = prospectCompany.getTeleCode();
			if (teleNo==null||teleNo.length()<1){
			       teleNo="";
			}
			customerStatus = prospectCompany.getNote();
			if (customerStatus==null||customerStatus.length()<1){
			       customerStatus="";
			}
		}
		
		if(stepGroup != null){
			stepGroupId = stepGroup.getId() + "";
		}
		
	    if (bidMaster!=null){
	    	no = bidMaster.getNo();
	    	contractType = bidMaster.getContractType();
	    	currency = bidMaster.getCurrency();
	    	description = bidMaster.getDescription();
	    	if(bidMaster.getProspectCompany()!=null){
	    		prospectCompanyId = bidMaster.getProspectCompany().getPartyId();
	    	}else{
	    		prospectCompanyId = "";
	    	}
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
	}
	else
	{   
	      if(validate()&& validatePostDate()){
	      	document.EditForm.formAction.value = "new";
		  	document.EditForm.submit();
		  }
	}
}
function FnUpdate() {
  	var errormessage= ValidateData();
  	var stDate = document.EditForm.estimateStartDate;
	var hid_stDate = document.EditForm.hid_estimateStartDate;
	var edDate = document.EditForm.estimateEndDate;
	var hid_edDate = document.EditForm.hid_estimateEndDate;
	var exDate = document.EditForm.expectedEndDate;
	var hid_exDate = document.EditForm.hid_expectedEndDate;
	var stus = document.EditForm.status;
	var oldStus = "<%=bidMaster!=null?bidMaster.getStatus():""%>";
	if (errormessage != "") {
		alert(errormessage);
	} else {
		if ((stus.value !=oldStus )){
		
		if(stus.value == "Lost/Drop"){
			fnChangeStatus();		
		}
		else
		{
			if(window.confirm('Do you want to Leave a reson for status change?'))
				fnChangeStatus();
		}	
		/*
			if(stus.value == "Lost/Drop"){
				var stusReason = document.EditForm.changeReason.value;
				if(stusReason == null || stusReason == ""){
					alert("You must input the reason for changing the bid master's status to Lost/Drop.");
					return;
				}
			}
		*/	
			hid_stDate.value="yes";
		}
		if(stDate.value != stDate.oldvalue) 
		{
			hid_stDate.value="yes";
		}
		if(edDate.value!=edDate.oldvalue)
		{
			hid_edDate.value="yes";
		}
		if(exDate.value!=exDate.oldvalue)
		{
			hid_exDate.value="yes";
		}
	
      if(validate()&& validatePostDate()){
      	document.EditForm.formAction.value = "update";
      	if(parseInt(document.getElementById("currStep").innerHTML)==100)
      	{
 //     		var oSelect = document.getElementsByName("status");
//			oSelect[0].value = "Won";
      	}
	  	document.EditForm.submit();
	  }
	}
}

function validatePostDate(){
//	var postDate = document.EditForm.postDate;
// 	if (postDate.value.length>0){
//	      return dataOneCheck(postDate);
//	    } 
   return true;
}
function checkStartDate(sDate){
	var t = new Date(sDate.replace(/\-/g,"/"));
	var nowDate = new Date();
	var oSelect = document.getElementsByName("status");
	var status = oSelect[0].value;
	
	if(nowDate>t && status!="Won"){
		if (!confirm("Estimated Contract Start Date cannot be today or earlier! Do you want to continue?")){
		return false;
		}
	}else{
		return true;
	}
}
function validate(){
   var startDate = document.EditForm.estimateStartDate;
   var endDate = document.EditForm.estimateEndDate;
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
	     if(document.getElementById("expectedEndDate").value == "")
	{
		alert("The Expected Contract Sign Date cannot be ignored!");
		return false;
    }
	    if ((document.getElementById("expectedEndDate").value != "")&(document.getElementById("expectedEndDate").value > document.getElementById("estimateStartDate").value)){
	    	if (!confirm("The Contract Sign Date should not be later than Contract Start Date! Do you want to continue?")){
	    		return false;
	    	}
	    }
	 if(document.getElementById("PresalePMId").value == "")
	{
		alert("The presale manager cannot be ignored!");
		return false;
    }
    if(document.getElementById("prospectCompanyId").value == "")
	{
		alert("The Prospect OR Customer cannot be ignored!");
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
	if(document.EditForm.description.value == 0)
	{
		errormessage="Bid Description cannot be ignored!";
		document.EditForm.description.focus();
		return errormessage;
    }
    

    /*var flag = "";
    if(document.EditForm.clname != null ){
	    for(var i=0;i<document.EditForm.clname.length;i++) {
	    	alert("11" + document.EditForm.clname[i].value);
	    	if(document.EditForm.clname[i].length > 0){
				flag = "error";
	        }
	    }
	    if(flag != "error"){
	    	errormessage="You must input the Contact List";
			document.EditForm.clname[0].focus();
			return errormessage;
	    }
	}else{
		errormessage="You must input the Contact List";
		return errormessage;
	}*/
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
function deleteContactList(contactId){
	if (confirm("Do you want delete this Contact?")){
		document.EditForm.formAction.value = "deleteContact";
		document.EditForm.contactId.value = contactId;
		document.EditForm.submit();
	}
}
function deleteUnweightedValueList(year){
	if (confirm("Do you want delete this year unweighted value?")){
		document.EditForm.formAction.value = "deleteUnweightedValue";
		document.EditForm.yearAdd.value = year;
		document.EditForm.submit();
	}
}
function showProspectDialog()
{
	var code,desc;

		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogProspectList.do",
			null,
			'dialogWidth:560px;dialogHeight:660px;status:no;help:no;scroll:no');
		if (v != null) {
		//alert(v);
			code=v.split("|")[0];
			//alert(code);
			document.getElementById("prospectCompanyId").value=code;
			desc=v.split("|")[1];
			document.getElementById("name").innerHTML=desc;
			document.getElementById("chineseName").innerHTML  = v.split("|")[2];
		//	document.getElementById("city").innerHTML = v.split("|")[6];
			document.getElementById("address").innerHTML = v.split("|")[4];
			document.getElementById("industry").innerHTML = v.split("|")[5];
			document.getElementById("bankno").innerHTML = v.split("|")[3];
			//document.getElementById("industry").innerHTML = v.split("|")[6];
			document.getElementById("custGroup").innerHTML = v.split("|")[6];
			document.getElementById("postCode").innerHTML = v.split("|")[7];
			document.getElementById("teleNo").innerHTML = v.split("|")[8];
			document.getElementById("faxNo").innerHTML  = v.split("|")[9];
			var industryId = v.split("|")[10];
			var customerGroupId = v.split("|")[11];
			/*
			for (var i = 0; i < industry.options.length; i++) {
				if (industry.options[i].value == industryId) {
					industry.options[i].selected = true;
					break;
				}
			}
			for (var i = 0; i < custGroup.options.length; i++) {
				if (custGroup.options[i].value == customerGroupId) {
					custGroup.options[i].selected = true;
					break;
				}
			}*/
		
	}
}
function showProspectDialog1()
{
	var code,desc,pid;
	pid=document.getElementById("prospectCompanyId").value;

		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&editProspect.do?openType=dialogView&PartyId="+pid,
			null,
			'dialogWidth:560px;dialogHeight:660px;status:no;help:no;scroll:no');
		if (v != null) {
		//alert(v);
			code=v.split("|")[0];
			//alert(code);
			document.getElementById("prospectCompanyId").value=code;
			desc=v.split("|")[1];
			document.getElementById("name").innerHTML=desc;
			document.getElementById("chineseName").innerHTML  = v.split("|")[2];
		//	document.getElementById("city").innerHTML = v.split("|")[6];
			document.getElementById("address").innerHTML = v.split("|")[4];
			document.getElementById("industry").innerHTML = v.split("|")[5];
			document.getElementById("bankno").innerHTML = v.split("|")[3];
			//document.getElementById("industry").innerHTML = v.split("|")[6];
			document.getElementById("custGroup").innerHTML = v.split("|")[6];
			document.getElementById("postCode").innerHTML = v.split("|")[7];
			document.getElementById("teleNo").innerHTML = v.split("|")[8];
			document.getElementById("faxNo").innerHTML  = v.split("|")[9];
			var industryId = v.split("|")[10];
			var customerGroupId = v.split("|")[11];		
	}
}
function newCustomer(){
	var customer = new Object();
	customer.name = document.EditForm.name.value;
	customer.chineseName = document.EditForm.chineseName.value;
	customer.address = document.EditForm.address.value;
	customer.teleNo = document.EditForm.teleNo.value;
	customer.postCode = document.EditForm.postCode.value;
	customer.custGroup = document.EditForm.custGroup.value;
	customer.industry = document.EditForm.industry.value;
	
	var prospectCompanyId = document.EditForm.prospectCompanyId.value;
	var id = document.EditForm.id.value;
	var param = "?openType=dialogView&flag=bid&prospectCompanyId=" + prospectCompanyId;
	param += "&id=" + id;
	param += "&custGroup=" + customer.custGroup;
	param += "&industry=" + customer.industry;
	
	v = window.showModalDialog(
		"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&editCustParty.do" + param,
		customer,
		'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
	if(v!=null){
		document.EditForm.formAction.value = "view";
		document.EditForm.submit();
		var sectorId = v.split("|")[2];
		var sectorName = v.split("|")[3];
		var clientId = v.split("|")[4];
		var clientName = v.split("|")[5];
		var industry = document.getElementById("industry");
		var flag1 = "";
		for (var i = 0; i < industry.options.length; i++) {
			if (document.EditForm.industry.options[i].value == sectorId) {
				document.EditForm.industry.options[i].selected = true;
				flag1 = "true";
				break;
			}
		}
		if(flag1 != "true"){
			industry.options[industry.options.length] = new Option(sectorName, sectorId);
			industry.options[industry.options.length].selected = true;
		}
		
		var custGroup = document.getElementById("custGroup");
		flag1 = "";
		for (var i = 0; i < custGroup.options.length; i++) {
			if (custGroup.options[i].value == clientId) {
				custGroup.options[i].selected = true;
				flag1 = "true";
				break;
			}
		}
		if(flag1!= "true"){
			document.EditForm.custGroup.options[custGroup.options.length] = new Option(clientName, clientId);
			document.EditForm.custGroup.options[custGroup.options.length].selected = true;
		}
		
		document.EditForm.customerStatus = checked;
	}
	
}

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
			labelSales.innerHTML=code+":"+desc;
			salesPersonId.value=code;
		} else {
			labelSales.innerHTML="";
			salesPersonId.value="";
		}
	}
}
function showDialog_account2()
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
			labelSales2.innerHTML=code+":"+desc;
			salesPersonId2.value=code;
		} else {
			labelSales2.innerHTML="";
			salesPersonId2.value="";
		}
	}
}

function showDialog_presalePM()
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
			labelPresalePM.innerHTML=code+":"+desc;
			PresalePMId.value=code;
		} else {
			labelPresalePM.innerHTML="";
			PresalePMId.value="";
		}
	}
}

function onDepSelect()
{
//	alert(document.EditForm.dapartmentId.value);
with(document.EditForm){
	if(dapartmentId.value=='007')
	{
		labelPresalePM.innerHTML="Khoy Eng Khoon";
		PresalePMId.value="CN01273";
	}else	if(dapartmentId.value=='006')
	{
		labelPresalePM.innerHTML="Wu Zhaoxian, Zoe";
		PresalePMId.value="CN01266";
	}else	if(dapartmentId.value=='005')
	{
		labelPresalePM.innerHTML="Hao li";
		PresalePMId.value="CN01068";
	}else{
		labelPresalePM.innerHTML="Please define";
		PresalePMId.value="";
	}
}
}

function ExportExcel() {
	var formObj = document.EditForm;
	formObj.formAction.value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
function addContactList(){
	var errormessage= "";
	if(document.EditForm.description.value == 0)
	{
		errormessage="You must input the description";
		document.EditForm.description.focus();
    }
    
    if(document.EditForm.name.value == 0)
	{
		errormessage="You must input the Prospect Company Name";
		document.EditForm.name.focus();
    }
    
	if(document.EditForm.clname1.value == 0){
		errormessage="You must input the Contact List";
	}
	
	if (errormessage != "") {
		alert(errormessage);
	}
	else
	{   
	      if(validate()&& validatePostDate()){
	      	document.EditForm.formAction.value = "addContact";
		  	document.EditForm.submit();
		  }
	}
}
function addUnweightedValueList(){
   var errormessage= ValidateData();
   if (errormessage != "") {
		alert(errormessage);
		return ;
	}
   var year=document.EditForm.yearNew.value;
   var value=document.EditForm.unweightedValueNew.value;
	if(!year) {
	alert("You must input the year!");
	return ;
	}
	if (!value) {
	alert("You must input the value!");
	return ;
	}
  var strP=/^\d+(\.\d+)?$/;
  if(!strP.test(year)){
   alert("Invalid year value!");
   return ;
   }else if(year.length !=4)
   {
   alert("Invalid year value!");
   return ;
   }
   else if  (year.length<0){
   alert("Invalid year value!");
   return ;
   }
   if(!strP.test(value)){
   alert("Invalid amount value!");
   return ;
   }
  try{
  if(parseFloat(year)!=year) {
  alert("Invalid year value!");
  return ;
  }
  if(parseFloat(value)!=value) {
  alert("Invalid amount value!");
  return ;
  }
  }
  catch(ex)
  {
   return ;
  }
  document.EditForm.formAction.value = "addUnweightedValueList";
 // document.EditForm.year.value=year;
  //  document.EditForm.unweightedValue.value=year;
  document.EditForm.submit();

}
function showAction(bidActId, bidId){
	var param = "?FormAction=view";
	param += "&bidActId=" + bidActId;
	param += "&bidId=" + bidId;
	v = window.showModalDialog(
		"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&EditBidActDet.do" + param,
		null,
		'dialogWidth:800px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null)	{
		var actListSize = v.split("|")[1];
		document.getElementById("actSize"+bidActId).innerHTML=actListSize;
		document.getElementById("currStep").innerHTML=v.split("|")[2];
		document.getElementById("actHr"+bidActId).innerHTML=v.split("|")[3];
		if (actListSize >0){
			document.getElementById("actCheckBox"+bidActId+"1").style.display="block";
			document.getElementById("actCheckBox"+bidActId+"2").style.display="none";
			document.getElementById("actCheckBox"+bidActId+"3").style.display="none";
		}else{
			document.getElementById("actCheckBox"+bidActId+"2").style.display="block";
			document.getElementById("actCheckBox"+bidActId+"1").style.display="none";
			document.getElementById("actCheckBox"+bidActId+"3").style.display="none";
		}
		
		if(v.split("|")[2]==100)
		{
			var oDiv = document.getElementById("other");
			oDiv.style.display="none";
			
			oDiv = document.getElementById("won");
			oDiv.style.display="block";
			
			var oSelect = document.getElementsByName("status");
			oSelect[0].value = "Won";
		}
		else
		{
			var oDiv = document.getElementById("other");
			oDiv.style.display="block";
			
			oDiv = document.getElementById("won");
			oDiv.style.display="none";
			
			var oSelect = document.getElementsByName("status");
			oSelect[0].value = "Active";

		}
	}
}
function onCurrSelect(){
	
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	
	with(document.EditForm) {
		exchangeRate.value = RateArr[currencyId.selectedIndex];
		labelCurrencyRate.innerHTML=exchangeRate.value;
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
		}else{
			alert("You must input the reason for changing the bid master's status to Lost/Drop.");
			return;
		}
	}
	else
	{
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
				<TD align=left width='90%' class="wpsPortletTopTitle" colspan=6>Bid Master
				Maintenance</TD>
			</tr>
			<tr>
				<td width='100%'>
				<input type="hidden" name="formAction"> 
				<input type="hidden" name="stepGroupId"	value="<%=stepGroupId !=null ? stepGroupId : "" %>"> 
				<input type="hidden" name="prospectCompanyId" value="<%=prospectCompanyId%>"> 
				<input type="hidden" name="id" value="<%=id != null ? id : ""%>"> 
				
				<input type="hidden" name="contactId">
				<input type="hidden" name="reason">
				<input type="hidden" name="changeReason">
				<input type="hidden" name="departmentId" value="<%=dept%>">
				<input type="hidden" name="offSet" value="<%=offSet%>">
				
				<table width='100%' border='0' cellspacing='2' cellpadding='0'>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Bid No.:&nbsp;</span></td>
						<td colspan=2><%=no%></td>

						<td align="right" class="lblbold">Department:&nbsp;</td>
						<td class="lblLight" colspan=2><select name="dapartmentId" onchange="javascript:onDepSelect()">
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
									}}
							%>
							<option value="<%=p.getPartyId()%>" <%=slk%>><%=p.getDescription()%></option>
							<%
				//				sqlStr = "select ul from UserLogin as ul where ul.party.partyId ='"+ p.getPartyId() + "' and ul.type='slmanager'";
				//				Query query = hs.createQuery(sqlStr);
				//				List result = query.list();
				//				if((result!=null)&&(result.size()>0)){
				//					UserLogin preselaPM =(UserLogin)result.get(0);
				//					pmid = preselaPM.getUserLoginId();
				//					pmname=preselaPM.getName();
				//					System.out.println("--------------"+pmid);
				//					System.out.println("--------------"+pmname);
				//				}
							%>
							<% slk ="";
								}
							%>
						</select></td>

					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Description:&nbsp;</span>
						</td>
						<td colspan=2><input type="text" class="inputBox" name="description" 
							value="<%=description%>" size="50" /></td>
							
						<td align="right" class="lblbold"><span class="tabletext">Presale PM:&nbsp;</span></td>
						<td align="left" colspan=2>
						<%String presalePMId = "";
							String presalePMName = "";
							if(bidMaster != null){
								if (bidMaster.getPresalePM()!= null) {
									presalePMId= bidMaster.getPresalePM().getUserLoginId();
									presalePMName = bidMaster.getPresalePM().getName();
								}
							}
							%>
						<div style="display:inline" id="labelPresalePM"><%=presalePMName%>&nbsp;</div>
						<input type="hidden" readonly="true" name="PresalePM" maxlength="100" value="<%=presalePMName%>"> 
						<input type="hidden" name="PresalePMId" value="<%=presalePMId%>"> 
						<a	href="javascript:showDialog_presalePM()"><img align="absmiddle" 	alt="<bean:message key="helpdesk.call.select" />"
							src="images/select.gif" border="0" /></a></td>	
					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Sales Person:&nbsp;</span>
						</td>
						<td align="left" colspan=2><%String spId = "";
							String spName = "";
							if(bidMaster != null){
								if (bidMaster.getSalesPerson() != null) {
									spId = bidMaster.getSalesPerson().getUserLoginId();
									spName = bidMaster.getSalesPerson().getName();
								}
							}else{
								spId = ul.getUserLoginId();
								spName = ul.getName();
							}
							%>
						<div style="display:inline" id="labelSales"><%=spName%>&nbsp;</div>
						<input type="hidden" readonly="true" name="salesPersonName"
							maxlength="100" value="<%=spName%>"> <input type="hidden"
							name="salesPersonId" value="<%=spId%>"> <a
							href="javascript:showDialog_account()"><img align="absmiddle"
							alt="<bean:message key="helpdesk.call.select" />"
							src="images/select.gif" border="0" /></a></td>

						<td align="right" class="lblbold"><span class="tabletext">Secondary Sales
						Person:&nbsp;</span></td>
						<td align="left" colspan=2><%String spId2 = "";
							String spName2 = "";
							if(bidMaster != null){
								if (bidMaster.getSecondarySalesPerson()!= null) {
									spId2= bidMaster.getSecondarySalesPerson().getUserLoginId();
									spName2 = bidMaster.getSecondarySalesPerson().getName();
								}
							}
							%>
						<div style="display:inline" id="labelSales2"><%=spName2%>&nbsp;</div>
						<input type="hidden" readonly="true" name="salesPersonName2"
							maxlength="100" value="<%=spName2%>"> <input type="hidden"
							name="salesPersonId2" value="<%=spId2%>"> <a
							href="javascript:showDialog_account2()"><img align="absmiddle"
							alt="<bean:message key="helpdesk.call.select" />"
							src="images/select.gif" border="0" /></a></td>

					</tr>
					<tr>
						<td align="right" class="lblbold"><span class="tabletext">Currency:&nbsp;</span></td>

						<td colspan=2><select name="currencyId" onchange="javascript:onCurrSelect()">
							<%						
						      for (int i0 = 0; i0 < currencyList.size(); i0++) {
								CurrencyType curr = (CurrencyType)currencyList.get(i0);
								if(currency != null && curr.getCurrId().equals(currency.getCurrId())){
							%>
							<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
							<%  }else if(currency == null && curr.getCurrId().equals("RMB")){
								exchangeRateStr =curr.getCurrRate().toString();
							%>
							<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>

							<%  }else{%>
							<option value="<%=curr.getCurrId()%>"><%=curr.getCurrName()%></option>
							<%}}%>
						</select>
						</td>

						<td align="right" class="lblbold">
 	 						<span class="tabletext">Status:&nbsp;</span>
						</td>
						<td align="left" colspan=2>
							<% 	status = "";
							String display = "none";
							    if(bidMaster != null && bidMaster.getStatus() != null){
									status = bidMaster.getStatus();
								}
								if(!status.equalsIgnoreCase("Won")){
								display = "block";
								}
							%>
							<div id="other" style="display:<%=display%>">
  							<select name="status" >
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
          					<span class="tabletext">Total Contract Value:&nbsp;</span>
       	 				</td>
        				<td colspan=2>
						<input type="text" class="inputBox" name="estimateAmount" value="<%=estimateAmountStr%>" size="30" onblur="checkDeciNumber2(this,1,1,'estimateAmount',-9999999999,9999999999); caculateRMB(); addComma(this, '.', '.', ',');">
        				</td>				
						<td align="right" class="lblbold">
          					<span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
       	 				</td>
        				<td colspan=2>
							<div style="display:none" id="labelCurrencyRate"></div>	
							<input type=text name="exchangeRate" value="<%if(exchangeRateStr !=null) out.print(exchangeRateStr); %>">	      				
						</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
          					<span class="tabletext">Total Contract Value(RMB):&nbsp;</span>
       	 				</td>
        				<td colspan=5>
						<input type="text"  class="inputBox" style="border:0px" readonly="true" name="caculatedAmt" value="<%=bidMaster!=null?Num_formater.format(bidMaster.getEstimateAmount().doubleValue()*bidMaster.getExchangeRate().floatValue()):""%>">
        				</td>
					</tr>
					<tr>
						<td align="right" class="lblbold">
          					<span class="tabletext">Estimated Contract Start Date:&nbsp;</span>
       	 				</td>
        				<td colspan=2>
        				<input type="hidden" name="hid_estimateStartDate" value="no">
        				<%
        				if(startDateStr!=null && startDateStr.length()>0){
        				%>
						    <input type="text" class="inputBox" name="estimateStartDate" oldvalue="<%=startDateStr%>" value="<%=startDateStr%>" size="10">
          				<%
          				}else{
          				%>
          					 <input type="text" class="inputBox" name="estimateStartDate" oldvalue="" value="" size="10">
          				<%
          					}
          				%>
          					<A href="javascript:ShowCalendar(document.EditForm.dimgs,document.EditForm.estimateStartDate,null,0,330)" 
												onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimgs src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
							</td>
					
						<td align="right" class="lblbold">
          					<span class="tabletext">Estimated Contract End Date:&nbsp;</span>
       	 				</td>
        				<td colspan=2>
        				<input type="hidden" name="hid_estimateEndDate" value="no">
        				<%
        				if(endDateStr!=null && endDateStr.length()>0){

        				%>
							<input type="text" class="inputBox" name="estimateEndDate" oldvalue="<%=endDateStr%>" value="<%=endDateStr%>" size="10">
          				<%
          				}else{
          				%>	
          					<input type="text" class="inputBox" name="estimateEndDate" oldvalue="" value="" size="10">
          				<%
          				}
          				%>
          					<A href="javascript:ShowCalendar(document.EditForm.dimge,document.EditForm.estimateEndDate,null,0,330)" 
												onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimge src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
					</tr>
					<tr>
					<!-- 
						<td align="right" class="lblbold">
          					<span class="tabletext">Request Contract No. Date:</span>
       	 				</td>
        				<td colspan=2>
        				<%/*
        				if(postDateStr!=null && postDateStr.length()>0){
        				%>
							<input type="text" class="inputBox" name="postDate" value="<%=postDateStr%>" size="10">
          				<%
          				}else{
          				%>	
          					<input type="text" class="inputBox" name="postDate" value="" size="10">
          				<%
          				} */
          				%>	
          					<A href="javascript:ShowCalendar(document.EditForm.dimgp,document.EditForm.postDate,null,0,330)" 
												onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimgp src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
					-->
						<td align="right" class="lblbold">
          					<span class="tabletext">Expected Contract Sign Date:</span>
       	 				</td>
        				<td colspan=2>
        				<input type="hidden" name="hid_expectedEndDate" value="no">
        				<%
        				if(expectedEndDate!=null && expectedEndDate.length()>0){
        				%>
							<input type="text" class="inputBox" name="expectedEndDate" oldvalue="<%=expectedEndDate%>" value="<%=expectedEndDate%>" size="10">
          				<%
          				}else{
          				%>	
          					<input type="text" class="inputBox" name="expectedEndDate" oldvalue="" value="" size="10">
          				<%
          				}
          				%>	
          					<A href="javascript:ShowCalendar(document.EditForm.dimgx,document.EditForm.expectedEndDate,null,0,330)" 
												onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimgx src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
						</td>
						</tr>
						<TR>
						<td align="right" class="lblbold">
          					<span class="tabletext">Bid Create Date:</span>
       	 				</td>
						
        				<%if(createDateStr!=null && createDateStr.length()>0){
        				%>
        				<td  colspan=2>
        				<%=createDateStr%> 
        				</td>
          				<%
          				}else{%>
        				<td  colspan=2>
        				</td>
          				<%}%>
						
						
						<td colspan=3 align="center">
								<%
								if(contractType != null && !contractType.equals("") && !contractType.equals("null") ){
									if(contractType.equals("FP")){
										out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"contractType\" VALUE=\"FP\" checked>Fixed Price");
										out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"contractType\" VALUE=\"TM\">Time & Material");
									}else{
						                out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"contractType\" VALUE=\"FP\">Fixed Price");
										out.println("<input TYPE=\"RADIO\" class=\"radiostyle\" NAME=\"contractType\" VALUE=\"TM\" checked>Time & Material");
									}
								}else{%>
									<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="FP" checked>Fixed Price
									<input TYPE="RADIO" class="radiostyle" NAME="contractType" VALUE="TM">Time &amp; Material
								<%}
								%>
						</td>
						</TR>
						<%
       	 				if(bidMaster!=null){
       	 				%>
						<TR>
						<td align="right" class="lblbold">
          					<span class="tabletext">Bid Current WIN %:</span>
       	 				</td>
       	 				
						<td  colspan=2>	<div style="display:inline" id="currStep"> 
								<%int aa=0;
								if(bidMaster.getCurrentStep()!=null){
									aa = (bidMaster.getCurrentStep().getPercentage().intValue());
									}%>
								<%=aa%></div>% 
						</td>

       	 				<%}%>
				</table>
	
		<tr>
						<td width='100%'>		
			<table width='100%' border='0' cellspacing='2' cellpadding='0'>
			
            <tr>
				<TD align=left width='100%' class="wpsPortletTopTitle" colspan=6>
				Prospect Company Details</TD>
			</tr>
			<tr>
				<td align="right"  class="lblbold"><span class="tabletext">Prospect	Company Name:&nbsp;</span>
				<input type="hidden" name="prospectCompanyId" value="<%=prospectCompanyId%>">
					 </td>
				<td align="left" width=25% colspan=2>
				<a href="javascript:void(0)"
					onclick="showProspectDialog1();event.returnValue=false;"><div style="display:inline" id="name"><%=name%>
				
				</div></a><a
					href="javascript:void(0)"
					onclick="showProspectDialog();event.returnValue=false;"><img
					align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>"
					src="images/select.gif" border="0" /></a>  
					</td>

				<td align="right" width=25% class="lblbold"><span class="tabletext" >Chinese
				Name:&nbsp;</span></td>
				<td align="left" width=25% colspan=2>
				<div style="display:inline" id="chineseName">
				<%=chineseName%>
				</div>
				  </td>
			</tr>
			<tr>
			<td align="right" width=25% class="lblbold"><span class="tabletext">Industry:&nbsp;</span>
				</td>
				<td align="left" width=25% colspan=2>
				<div style="display:inline" id="industry">
				<%=industry%>
				</div>
				</td>
				
				<td align="right" width=25% class="lblbold"><span class="tabletext">Group:&nbsp;</span>
				</td>
				<td align="left" width=25% colspan=2>
				<div style="display:inline" id="custGroup">
				<%=custGroup%>
				</div>
			    </td>
				<td align="right" width=25% class="lblbold">
				</td>
				
			</tr>
			<tr>
			<td align="right" width=25% class="lblbold"><span class="tabletext">Address:&nbsp;</span>
				</td>
				<td align="left" width=25% colspan=2>
				<div style="display:inline" id="address">
				<%=address%>
				</div>
								</td>
								<td align="right" width=25% class="lblbold"><span class="tabletext">Post
				Code:&nbsp;</span></td>
				<td align="left" width=25% colspan=2>
				<div style="display:inline" id="postCode">
				<%=postCode%>
				</div>
				</td>
				
			</tr>
			<tr>
				<td align="right" align="right" width=25% class="lblbold"><span class="tabletext">Telephone
				No.:&nbsp;</span></td>
				<td align="left" width=25% colspan=2>
				<div style="display:inline" id="teleNo">
				<%=teleNo%>
				</div>
				</td>
				<td align="right" width=25% class="lblbold"><span class="tabletext">Fax No:&nbsp;</span>
				</td>
				<td align="left" width=25% colspan=2>
				<div style="display:inline" id="faxNo">
				<%=faxNo%>
				</div>
			    </td>
			</tr>
			<tr>
				<td align="right" width=25% class="lblbold"><span class="tabletext">Bank
				No.:&nbsp;</span></td>
				<td align="left" width=25% colspan=2>
				<div style="display:inline" id="bankno">
				<%=bankno%>
				</div>
				</td>
			</tr>
			</table>
	<%if(bidMaster!=null){%>
				</tr>
				
					<tr>
						<td width='100%'>
							<TABLE border=0 width='100%'  >
								
									<tr>
									<TD align=left width='90%' class="wpsPortletTopTitle" colspan=6>
								            Unweighted Value List
								     </TD>
								 </tr>
								 <TABLE border=0 width='100%'  class=''>
						  					<tr bgcolor="#e9eee9">
											  	<td align="middle" class="lblbold" colspan=2>year</td>
											  	<td align="middle" class="lblbold" colspan=2>Amount (RMB)</td>
											  	<td align="middle" class="lblbold" colspan=2>Action</td>
											</tr>
											<input type="hidden"  name="yearAdd"  />
									<%
										if (valueList != null){
										Iterator ValueItst = valueList.iterator();
										while (ValueItst.hasNext()) {
											String year = "";
											double value = 0;
												BidUnweightedValue bv = (BidUnweightedValue)ValueItst.next();
												year = bv.getYear();
												value =bv.getValue().doubleValue();
									%>
											<tr>
												<td  align = "center" colspan=2 >
							  						<input   type="text"  class="inputBox" style="text-align:center"  style="border:0px" readonly="true" name="year" value="<%=year%>" size="20" />
							  					</td>
							  					<td  colspan=2 align = "center">
							  						<input type="text" class="inputBox" style="text-align:right" style="border:0px" readonly="true"  name="unweightedValue" value="<%=Num_formater.format(value)%>" size="20" />
							  					</td>
							  					
							  					<td align="center" colspan=2>
							  						<a href="javascript:deleteUnweightedValueList(<%=year%>)">Delete</a>
							  					</td>
							  				</tr>
							  		<%
							  				
							  			}
							  			}
							  		%>
							  		<tr>
												<td align="center" colspan=2>
							  						<input type="text" class="inputBox" name="yearNew"  size="20" />
							  					</td>
							  					<td align="center" colspan=2>
							  						<input type="text" class="inputBox" name="unweightedValueNew"  size="20" style="text-align:right"/>
							  					</td>
							  					
							  					<td align="center" colspan=2>
							  						<a href="javascript:addUnweightedValueList()">Add</a>
							  					</td>
							  				</tr>
							  				</table>
								<tr>
									<TD align=left width='90%' class="wpsPortletTopTitle" colspan=4>
								            Contact List
								     </TD>
								 </tr>
								<tr>
									<td width='100%'colspan=4>
										<TABLE border=0 width='100%'  class=''>
						  					<tr bgcolor="#e9eee9">
											  	<td align="center" class="lblbold">name</td>
											  	<td align="center" class="lblbold">position</td>
											  	<td align="center" class="lblbold">chineseName</td>
												<td align="center" class="lblbold">teleNo</td>
												<td align="center" class="lblbold">email</td>
												<td align="center" class="lblbold">action</td>
											</tr>
									<%
										Iterator itst = contactSet.iterator();
										for (int j = 0; j < 3 ; j++) {
											String clid = "";
											String clname = "";
											String clposition = "";
											String clchinesename = "";
											String clteleno = "";
											String clemail = "";
								
											if(itst.hasNext()){
												ContactList contact = (ContactList)itst.next();
												clid = contact.getId() + "";
												clname = contact.getName();
												clposition = contact.getPosition();
												clchinesename = contact.getChineseName();
												clteleno = contact.getTeleNo();
												clemail = contact.getEmail();
									%>
											<tr>
												<td align="middle">
												<input type="hidden" class="inputBox" name="clid" value="<%=clid%>" size="30" />
							  						<input type="text" class="inputBox" name="clname" value="<%=clname%>" size="20" />
							  					</td>
							  					<td align="middle">
							  						<input type="text" class="inputBox" name="clposition" value="<%=clposition%>" size="20" />
							  					</td>
							  					<td align="middle">
							  						<input type="text" class="inputBox" name="clchinesename" value="<%=clchinesename%>" size="20" />
							  					</td>
							  					<td align="middle">
							  						<input type="text" class="inputBox" name="clteleno" value="<%=clteleno%>" size="20" />
							  					</td>
							  					<td align="middle">
							  						<input type="text" class="inputBox" name="clemail" value="<%=clemail%>" size="30" />
							  					</td>
							  					<td align="middle">
							  						<a href="javascript:deleteContactList(<%=clid%>)">Delete</a>
							  					</td>
							  				</tr>
							  		<%
							  				}
							  			}
							  		%>
							  				<tr>
												<td align="middle">
							  						<input type="text" class="inputBox" name="clname1" value="" size="20" />
							  					</td>
							  					<td align="middle">
							  						<input type="text" class="inputBox" name="clposition1" value="" size="20" />
							  					</td>
							  					<td align="middle">
							  						<input type="text" class="inputBox" name="clchinesename1" value="" size="20" />
							  					</td>
							  					<td align="middle">
							  						<input type="text" class="inputBox" name="clteleno1" value="" size="20" />
							  					</td>
							  					<td align="middle">
							  						<input type="text" class="inputBox" name="clemail1" value="" size="30" />
							  					</td>
							  					<td align="middle">
							  						<a href="javascript:addContactList()">add</a>
							  					</td>
							  				</tr>
						  				</table>
						  			</td>
						  		</tr>
						 	</table>
						 </td>
						</tr>
						<br>
							<tr>
				    <TD width='100%'>
				      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
				      
				        <tr>
				          <TD align=left width='90%' class="wpsPortletTopTitle">
				           Sales Phases Tracking
				          </TD>
				        </tr>
				      </table>
				    </TD>
				</tr>

					<%	
						if(steps != null){
							Iterator it = steps.iterator();
							while (it.hasNext()) {
								SalesStep step = (SalesStep)it.next();
								String description1 = step.getDescription();
								Integer seqNo = step.getSeqNo();
								Integer percentage = step.getPercentage();			
					%>
			
				
				<tr>
       	 				<td width='100%'>
							<TABLE border=0 width='100%'  >
							<tr>
								<td colspan = 5 align ="center" bgcolor="#e9eee9">
								<b><%=description1%>&nbsp;&nbsp;&nbsp;<%=percentage%>%</b>
				          	</TD>
							</tr>
			  					<tr >
								  	<td align="middle" class="lblbold" width='20%'>Activity No.</td>
								  	<td align="middle" class="lblbold" width='40%'>Description</td>
									<td width='2%'></td>
									<td width='20%'></td>
									<td align="middle" class="lblbold" width='8%'>Status</td>
								
								</tr>
				
									<%
										Set activities = null;
										if(step.getActivities()!=null && step.getActivities().size()>0){
											activities = step.getActivities();
											
											ArrayList activityList = new ArrayList();
											Object[] activityArray = activities.toArray();
											for(int i = 0;i<activities.size();i++){
												Integer seqNo1= ((SalesActivity)activityArray[i]).getSeqNo();
												for(int j=i+1;j<activities.size();j++){
													Integer seqNo2 = ((SalesActivity)activityArray[j]).getSeqNo();
													seqNo1= ((SalesActivity)activityArray[i]).getSeqNo();
													if(seqNo1.intValue()>seqNo2.intValue()){
														Object temp = activityArray[i];
														activityArray[i] = activityArray[j];
														activityArray[j] = temp;
													}
												}
												activityList.add(activityArray[i]);
											}
				//-----------------------------------------					
											Iterator itActi = activityList.iterator();
											while(itActi.hasNext()){
												SalesActivity activity = (SalesActivity)itActi.next();
												String description2 = activity.getDescription();
												Integer seqNoActivity = activity.getSeqNo(); 
												Long ida = activity.getId();
												String criticalFlg = activity.getCriticalFlg();
												String actionDateName = description2 + "Date";
										%>
									<tr>			
										<td align="center" class="lblight"><%=seqNoActivity.intValue()%></td>
										<td align="center" class="lblight"><%=description2%></td>
							
										<%
				//-------------------------------------
												String ck = "";
												String actionDateStr = "";
												int i = 0;
											//int size = 0;
												boolean flag = false;
												String bidActId = "";
												BidActivity bidtempt1 = null;
				//	System.out.println("*************************bidActivityObject is "+bidActivityObject);
												if(bidActivityObject != null){
													Iterator itBid = bidActivityObject.iterator();
													while(itBid.hasNext()){
														bidtempt1 = (BidActivity)itBid.next();
														if(bidtempt1.getActivity().getId().equals(ida)){
															bidActId = String.valueOf(bidtempt1.getId());
															break;
														}
													}
												}%>
							<input type="hidden" name="bidActId" value="<%=bidActId%>">
				<%			
							String actName = "actSize"+bidActId;
							String HrName = "actHr"+bidActId;
							String actCheckBox = "actCheckBox"+bidActId;
							Set ba = bidMaster.getBidActivities();
									Iterator i1 = ba.iterator();
									int ss =0;
									int hr = 0;
									while(i1.hasNext()){
										BidActivity bidActivity = (BidActivity)i1.next();
										if((bidActivity.getActivity().getId()==ida)&& (bidActivity.getBidActDetails()!=null)){
											ss = bidActivity.getBidActDetails().size();
											if (ss!= 0){ 
												ck="checked";
											}
											Iterator actSet = bidActivity.getBidActDetails().iterator();
											while(actSet.hasNext()){
											BidActDetail bad = (BidActDetail)actSet.next();
											hr=bad.getHours().intValue()+hr;
											}
										}
										
									}
					%>
										<td></td>
										<td align="left">
											<a href="javascript:showAction(<%=bidActId%>,<%=id%>)">Your Efforts (<div style="display:inline" id="<%=actName%>"><%=ss%></div>&nbsp;,&nbsp;<div style="display:inline" id="<%=HrName%>"><%=hr%></div>&nbsp;Hrs) </a>&nbsp;&nbsp;
										</td>
										
										<td align="center">
											<div style="display:none" id="<%=actCheckBox%>1"> 
											<input type="checkbox" name="bidActivitieId0" value="<%=String.valueOf(ida)%>"  Disabled class="checkboxstyle" checked>
											&nbsp;<font color =red>*</font>
											</div>
											<div style="display:none" id="<%=actCheckBox%>2"> 
											<input type="checkbox" name="bidActivitieId1" value="<%=String.valueOf(ida)%>"  Disabled class="checkboxstyle" >
											&nbsp;<font color =red>*</font>
											</div>
											<div style="display:block" id="<%=actCheckBox%>3"> 
											<input type="checkbox" name="bidActivitieId2" value="<%=String.valueOf(ida)%>"  Disabled class="checkboxstyle" <%=ck%>>
											&nbsp;<font color =red>*</font>
											</div>
										</td>									
									</tr>				
										<%	}
										} 
									%>		
							</table>
						</td>
					</tr>
			<%}%>
							<%}
						}
					%>
					<tr>
			    		<td  align="right"  colspan=4>
						<%
						if(buttonFlag){
							if(bidMaster!=null){
						%>
						<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
						<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete()"/>
						<input TYPE="button" class="loginButton" name="btnExport" value="Print Request Form" onclick="javascript:ExportExcel()"/>
						
						<%}else{
						%>
						<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();"/>
						<%
							}
						}
						%>

						<input type="button" value="Back To List" class="loginButton" onclick="location.replace('ListSalesBid.do?qryDepartmentId=<%=dept%>&offSet=<%=offSet%>')"/>
					
						</td>
					</tr>
				</table>
				
			<%
			if (bmhistoryList != null && bmhistoryList.size() > 0) {
					Iterator it = bmhistoryList.iterator();%>
			<table width='100%' border='0' cellspacing='2' cellpadding='0'>
            <tr>
				<TD align=left width='100%' class="wpsPortletTopTitle" colspan=8>
				Bid Master History</TD>
			</tr>
			<tr>
				<td align ="center" bgcolor="#e9eee9" class="lblbold" width="2%"># </td>
				<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Modify Date </td>
				<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Modify User </td>
				<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Contract Start Date </td>
				<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Contract End Date </td>
				<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Contract Sign Date </td>
				<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Status </td>
				<td align ="center" bgcolor="#e9eee9" class="lblbold" width="10%">Reason </td>
				<%	int v=1;
				while (it.hasNext()) {
					BMHistory bmh = (BMHistory) it.next();
					%>
			<tr>
				<td align ="center"><%=v%></td>
				<td align ="center"><%=formater.format(bmh.getModify_date())%></td>
				<td align ="center"><%=bmh.getUser_id().getName()%></td>
				<td align ="center"><%=formater.format(bmh.getCon_st_date())%></td>
				<td align ="center"><%=formater.format(bmh.getCon_ed_date())%></td>
				<td align ="center"><%=formater.format(bmh.getCon_sign_date())%></td>
				<td align ="center"><%=bmh.getStatus()%></td>
				<td align ="center"><%=bmh.getReason() == null ? "" : bmh.getReason()%></td>
			</tr>
					<%
					v++;
					}%>
					</tr>
				</table>
				<%}
			
			%>
			
</form>

<%	
	Hibernate2Session.closeSession();
	}else{
		out.println("!!你没有相关访问权限!!");
	}
	}catch(Exception e){
		e.printStackTrace();
	}
%>
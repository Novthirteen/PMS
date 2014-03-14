<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLExecutor" %>
<%@ page import="com.aof.core.persistence.util.EntityUtil" %>
<%@ page import="com.aof.core.persistence.Persistencer" %>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="com.aof.util.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/app.tld" prefix="app" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (AOFSECURITY.hasEntityPermission("EXPENSE", "_CREATE", session)) {

SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

String action = "";
String DataId = request.getParameter("DataId");

ExpenseMaster findmaster = (ExpenseMaster)request.getAttribute("findmaster");

Set claimedExTypeList = new HashSet(); 
if(findmaster != null){
	ProjectMaster projectMaster = findmaster.getProject();
	if(projectMaster != null)
		claimedExTypeList = projectMaster.getExpenseTypes();
}

List DateList = (List)request.getAttribute("DateList");
if(DateList==null){
	DateList = new ArrayList();
} 

List detailList = (List)request.getAttribute("detailList");
if(detailList==null){
	detailList = new ArrayList();
}

List ExpTypeList = hs.createQuery("select et from ExpenseType as et order by et.expSeq ASC").list();
if(ExpTypeList==null){
	ExpTypeList = new ArrayList();
}

List CommentsList = (List)request.getAttribute("CommentsList");
if(CommentsList==null){
	CommentsList = new ArrayList();
}

List AmountList = (List)request.getAttribute("AmountList");
if(AmountList==null){
	AmountList = new ArrayList();
}

ProjectHelper ph = new ProjectHelper();
List CurrencyList = ph.getAllCurrency(hs);
if(CurrencyList==null){
	CurrencyList = new ArrayList();
}
Iterator itCurr = CurrencyList.iterator();
String rateStr = "";
while(itCurr.hasNext()){
	CurrencyType curr = (CurrencyType)itCurr.next();
	rateStr = rateStr+curr.getCurrRate().toString()+"$";
}
	
String FreezeFlag = (String)request.getAttribute("FreezeFlag");
if (FreezeFlag == null) FreezeFlag = "N";

UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);

List partyList_dep=null;
try{
	//net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	PartyHelper phh = new PartyHelper();
	//UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	partyList_dep=phh.getAllParentPartysByPartyId(hs,ul.getParty().getPartyId());
	if (partyList_dep == null) partyList_dep = new ArrayList();
	partyList_dep.add(0,ul.getParty());
}catch(Exception e){
	e.printStackTrace();
}


%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script>
function fnSubmit(status) {
	if (checkAmtData() == 0 && status != "Draft") {
		alert("You must fill amount value!");
		return false;
	}
	with(document.frm) {
		if (check()) {
			FormStatus.value = status;
			action = "";
			target = "_self";
			submit();
		}
	}
}
function fnDelete() {
	with(document.frm) {
		action = "";
		FormAction.value = "delete";
		target = "_self";
		submit();
	}
}
function fnExportForm() {
	if (checkIdData() == 0) {
		alert("You must save amount value before export excel file!");
		return false;
	}
	with(document.frm) {
		if (check()) {
			FormStatus.value = status;
			action = "pas.report.expenseprint.do";
			target = "_blank";
			submit();
		}
	}
}
function showTsDialog(){
 with(document.frm)
	{   
	    var url = 'findTSPage.do?UserId='+document.getElementById("UserId").value+'&ProjectId='+document.getElementById("ProjectId").value+'&DataId='+document.getElementById("DatePeriod").value+'&ProjectNm='+document.getElementById("ProjectNm").value;
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.timesheet.viewtimesheet.title&" + url,
			null,
			'dialogWidth:800px;dialogHeight:500px;status:no;help:no;scroll:no');
   }
}
/*
function showTsDialog() {
	var windowprops	= "width=650,height=300,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,location=no,scrollbars=yes,status=no,menubars=no,toolbars=no,resizable=no";
	var url = 'findTSPage.do?UserId='+document.getElementById("ExUserId").value+'&ProjectId='+document.getElementById("ProjectId").value+'&DataId='+document.getElementById("DatePeriod").value+'&ProjectNm='+document.getElementById("ProjectNm").value;
	window.open(url, 'showTS', windowprops);
}*/
function showProjectDialog()
{
	var code,desc;
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&PRMProjectList.do?"+
			"UserId="+UserId.value+
			"&DataPeriod="+DataPeriod.value,
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelProject.innerHTML=code+":"+desc;
			//expenseNoteTr.style.display = 'block';
			expenseNote.innerHTML = v.split("|")[2];
			projId.value=code;
		}
	}
}
function onCurrSelect(){
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	
	with(document.frm) {
		CurrencyRate.value = RateArr[ExpenseCurrency.selectedIndex];
		labelCurrencyRate.innerHTML=CurrencyRate.value;
	}
}
function check() {
	var errorMessage = "";
	with(document.frm) {
		if (projId.value == "") errorMessage = errorMessage + "You must select a project!\n";
		
		if (errorMessage != "") {
			alert(errorMessage);
			return false;
		}
		return true;
	}
}
function clearProjectInfo() {
	with(document.frm) {
		labelProject.innerHTML="";
		projId.value="";
	}
}
function checkAmtData(){
	var oCust;
	var iCount = 0;
	var oText;
	oCust=document.getElementsByName("DateId");
	for(var i=0 ;i<oCust.length;i++)
	{
		oText=document.getElementsByName("RecordVal"+i);
		for(var j=0;j<oText.length;j++)
		{
			if (parseFloat(oText[j].value) != 0) iCount++;
		}
	}
	return iCount;
}
function checkIdData(){
	var oCust;
	var iCount = 0;
	var oText;
	oCust=document.getElementsByName("DateId");
	for(var i=0 ;i<oCust.length;i++)
	{
		oText=document.getElementsByName("RecId"+i);
		oText1=document.getElementsByName("RecordVal"+i);
		for(var j=0;j<oText.length;j++)
		{
			if (oText[j].value != "" && parseFloat(oText1[j].value) != 0) iCount++;
		}
	}
	return iCount;
}
</script>
<%if (findmaster == null) {
	action = "create";%>
<form name="frm" method="post">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<input type="hidden" name="FormAction" value="<%=action%>">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>  Expense Entry Maintenance </CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" align=right>ER No.:</td><td class="lblLight">&nbsp</td>
				<td class="lblbold" align=right>Department:</td><td class="lblLight"><%=ul.getParty().getDescription()%></td>
				<td class="lblbold" align=right>User:</td><td class="lblLight"><%=ul.getName()%><input type="hidden" name="UserId" value="<%=ul.getUserLoginId()%>"></td>
				<td class="lblbold" align=right>Status:</td>
				<td class="lblLight"><input type=hidden name="FormStatus" value="Draft">Draft&nbsp;</td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Entry Period:</td>
				<td class="lblLight"><%=Date_formater.format((java.util.Date)UtilDateTime.nowTimestamp())%></td>
				<td class="lblbold" align=right>Expense Period:</td>
				<td class="lblLight">
					<input align="center" TYPE="text" maxlength="25" size="10" name="DataPeriod" id="DataPeriod" value="<%=Date_formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>" readonly><A href="javascript:ShowCalendar(document.frm.dimg,document.frm.DataPeriod,null,0,330);clearProjectInfo()" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
				</td>
				<td class="lblbold" align=right>Currency:</td>
				<td class="lblLight">
					<select name="ExpenseCurrency" onchange="javascript:onCurrSelect()">
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
				<td class="lblbold" align=right>Exchange Rate(RMB):</td>
				<td class="lblLight">
					<div style="display:inline" id="labelCurrencyRate"><%=CurrencyRate%></div><input type=hidden name="CurrencyRate" value="<%=CurrencyRate%>">
				</td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Project:</td>
				<td class="lblLight">
					<div style="display:inline" id="labelProject">&nbsp;</div><input type=hidden name="projId"><a href="javascript:void(0)" onclick="showProjectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
				</td>
				<td class="lblbold" align=right>Customer:</td><td class="lblLight">&nbsp;</td>
				<td class="lblbold" align=right>Paid By:</td>
				<td class="lblLight">
					<select name="ClaimType">
						<option value="CY">Customer</option>
						<option value="CN" selected>Company</option>
					</select>
				</td>
				<td class="lblbold" align=right>Confirmer:</td><td class="lblLight">&nbsp;</td>
			</tr>
		<!--	<tr id='expenseNoteTr' style='display:none'> -->
			<tr>
				<td class="lblbold" align=right>Note:</td>
				<td class="lblLight" colspan=7><div style="display:inline" id="expenseNote">&nbsp;</div></td>
			</tr>
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr align="center">
				<td align="left" colspan="11">
					<input TYPE="button" class="button" name="Save" value="Continue >>" onclick="fnSubmit('Draft')">
					<input type="button" value="Back to List" name="Back" class="button" onclick="location.replace('findExpSelfPage.do');">
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</form>
<%} else {
	action = "update";
	String fRead = "";
	if ((findmaster.getApprovalDate() != null) || FreezeFlag.equals("Y")
		|| findmaster.getStatus().equals("Posted To F&A") || (findmaster.getReceiptDate() != null)) {
		fRead=" ReadOnly Style='background-color:#A9A9A9'";
	}
	%>
<script language="vbs">
function rndNum(tot)
 tot=FormatNumber(tot,2,-1,0,-1)
 rndNum=tot
end function
</script>

<script language="javascript">
window.onload=CalcTot;
function CalcTot()
{
	var oCust;
	var tot=0.00;
	var gtot=0.00;
	var oText;
	oCust=document.getElementsByName("DateId");
	oText=document.getElementsByName("RecordVal0");
	var stot = new Array(oText.length);
	for(var j=0;j<oText.length;j++)
	{
		stot[j] = 0;
	}
	for(var i=0 ;i<oCust.length;i++)
	{
		var oAmt;
		oText=document.getElementsByName("RecordVal"+i);
		tot=0.00;
		for(var j=0;j<oText.length;j++)
		{
			stot[j] = stot[j] + parseFloat(oText[j].value);
			tot = tot + parseFloat(oText[j].value);
		}
		var oTdtot=document.getElementById("tTot"+i);
		oTdtot.innerHTML=rndNum(tot);
	}
	for(var j=0;j<stot.length;j++)
	{
		oText=document.getElementById("tSubTot"+j);
		gtot = gtot + stot[j];
		oText.innerHTML=rndNum(stot[j]);
	}
	oTdtot=document.getElementById("tTot");
	oTdtot.innerHTML=rndNum(gtot);
}
function beforeFnSubmit(stat, claimtype){
	if(claimtype=="CN"){
		fnSubmit(stat);
		return true;
	}
	if(confirm("Fields with expense type not paid by customer will be set to ZERO!")){
		fnSubmit(stat);
	}else{
		document.frm.ClaimType.value="CN";
		return false;
	}
}
</script>
<form name="frm" method="post">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<input type="hidden" name="FormAction" value="<%=action%>">
<input type="hidden" name="DataId" value="<%=findmaster.getId().toString()%>">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>  Expense Entry Maintenance </CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" align=right>ER No.:</td><td class="lblLight"><%=findmaster.getFormCode()%></td>
				<td class="lblbold" align=right>Department :</td><td class="lblLight"><%=findmaster.getExpenseUser().getParty().getDescription()%></td>
				<td class="lblbold" align=right>User:</td><td class="lblLight"><%=ul.getName()%><input type="hidden" name="UserId" value="<%=findmaster.getExpenseUser().getUserLoginId()%>"></td>
				<td class="lblbold" align=right>Status:</td>
				<%if (findmaster.getStatus().equals("Rejected")){%>
					<td class="lblLight"><font color="Red"><%=findmaster.getStatus()%></font></td>
				<%}else{%>
					<td class="lblLight"><%=findmaster.getStatus()%>
				<%}%>
				<input type=hidden name="FormStatus" value="<%=findmaster.getStatus()%>">&nbsp;</td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Entry Period:</td>
				<td class="lblLight"><%=Date_formater.format(findmaster.getEntryDate())%>&nbsp;</td>
				<td class="lblbold" align=right>Expense Period:</td>
				<td class="lblLight"><%=Date_formater.format(findmaster.getExpenseDate())%>&nbsp;</td>
				<td class="lblbold" align=right>Currency:</td>
				<td class="lblLight">
					<select name="ExpenseCurrency" onchange="javascript:onCurrSelect()" <%if (!fRead.equals("")) out.println("disabled");%>>
					<%
					itCurr = CurrencyList.iterator();
					float CurrencyRate = 0;
					while(itCurr.hasNext()){
						CurrencyType curr = (CurrencyType)itCurr.next();
						if(curr.getCurrId().equals(findmaster.getExpenseCurrency().getCurrId())){
							CurrencyRate = curr.getCurrRate().floatValue();
							out.println("<option value=\""+curr.getCurrId()+"\" selected>"+curr.getCurrName()+"</option>");
						}else{
							out.println("<option value=\""+curr.getCurrId()+"\">"+curr.getCurrName()+"</option>");
						}
					}
					%>
					</select>
				</td>
				<td class="lblbold" align=right>Exchange Rate(RMB):</td>
				<td class="lblLight">
					<div style="display:inline" id="labelCurrencyRate"><%=CurrencyRate%></div><input type=hidden name="CurrencyRate" value="<%=CurrencyRate%>">
				</td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Project:</td>
				<td class="lblLight">
					<%=findmaster.getProject().getProjId()%>:<%=findmaster.getProject().getProjName()%>
					<input type = "hidden" name = "projId" value="<%=findmaster.getProject().getProjId()%>">
				</td>
				<td class="lblbold" align=right>Customer:</td><td class="lblLight"><%=findmaster.getProject().getCustomer().getDescription()%>&nbsp;</td>
				<td class="lblbold" align=right>Paid By :</td>
				<td class="lblLight">
					<%
						if(findmaster.getApprovalDate()!=null){
							if (findmaster.getClaimType().equals("CY")) {
					%>
							Customer
					<%
							} else {
					%>
							Company
					<%
							}
					%>
							<input type = "hidden" name = "ClaimType" value="<%=findmaster.getClaimType()%>">
					<%
						}else{
					%>
						<select name="ClaimType" onchange="return beforeFnSubmit('Draft', this.value)">
							<option value="CY">Customer</option>
							<option value="CN" <%=findmaster.getClaimType().equals("CY")?"":"selected"%>>Company</option>
						</select>
					<%
						}
					%>				
				</td>
				<td class="lblbold" align=right>Confirmer:</td>
				<td class="lblLight"><%=findmaster.getProject().getProjectManager().getName()%></td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Note:</td>
				<td class="lblLight" colspan=7><% if (findmaster.getProject().getExpenseNote() != null) out.print(findmaster.getProject().getExpenseNote());%></td>
			</tr>
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr bgcolor="#e9eee9">
				<td class="lblbold" align="center" width="13%">Date</td>
				<%
				int ExpLevel= 0;
				Iterator itExpType = ExpTypeList.iterator();
				while(itExpType.hasNext()){
					ExpenseType et = (ExpenseType)itExpType.next();
					ExpLevel= et.getExpSeq().length();
					if (!findmaster.getClaimType().equals("CY") || et.getExpAccDesc().equalsIgnoreCase("CY")) {
				%>
				<td class="lblbold" align="center" width="8%"><%=et.getExpDesc()%><input type="hidden" name="ExpType" value="<%=et.getExpId()%>"></td>
				<%
					}
				}
				%>
				<td class="lblbold" align="center" width="8%">Total</td>
				<td class="lblbold" align="center" width="24%">Comments</td>
			</tr>
			<%
			boolean NullData = true;
			int i=0;
			Iterator itDetail = detailList.iterator();
			ExpenseDetail ed = null;
			if (itDetail.hasNext()) {
				ed = (ExpenseDetail)itDetail.next();
			}

			Iterator itCmts = CommentsList.iterator();
			ExpenseComments ec = null;
			if (itCmts.hasNext()) {
				ec = (ExpenseComments)itCmts.next();
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////////
			//check if allowance can be claimed , Modified by Bill Yu at 2005-12-14
			Iterator itDate0 = DateList.iterator();
			HashSet dateSet = new HashSet();
			
			UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
			
			SQLExecutor sqlExec = new SQLExecutor(
				Persistencer.getSQLExecutorConnection(
						EntityUtil.getConnectionByName("jdbc/aofdb")));
						
			String statement = "";
			statement += "	select ts_date ts_date 	";
			statement += "	from proj_ts_det det 	";
			statement += "	inner join proj_ts_mstr mstr on det.tsm_id=mstr.tsm_id 	";
			statement += "	inner join proj_mstr proj_mstr on det.ts_proj_id=proj_mstr.proj_id 	";
			statement += "	inner join projevent as pe on pe.pevent_id = det.ts_projevent 	";
			statement += "	where ts_date in (";
			
			int first = 0;
			while(itDate0.hasNext()){
				Date fd0 = (Date)itDate0.next();
				if(first==0){
					statement = statement + "'"+ Date_formater.format(fd0) +"'";
				}else{
					statement = statement + ",'"+ Date_formater.format(fd0) +"'";
				}
				first++;
			}
			statement += ")";
			statement += "	and ts_hrs_user<>0 	";
			statement += "	and mstr.tsm_userlogin='"+userLogin.getUserLoginId()+"' 	";
			statement += "	and det.ts_proj_id='"+findmaster.getProject().getProjId()+"' 	";
			statement += "	and (pe.billable <> 'no'or det.ts_status='Approved')	";
			
			ResultSet resultSet = sqlExec.runQueryStreamResults(statement);
			while(resultSet.next()){
				dateSet.add(resultSet.getDate("ts_date"));
			}
			sqlExec.closeConnection();
			///////////////////////////////////////////////////////////////////////////////////////////////
			Iterator itDate = DateList.iterator();
			while(itDate.hasNext()){
				Date fd = (Date)itDate.next();%>
				<tr bgcolor="#e9eee9">
				<td class="lblbold"><%=Date_formater.format(fd)%><input type=hidden name=DateId value="<%=Date_formater.format(fd)%>"></td>
				<%itExpType = ExpTypeList.iterator();
				while(itExpType.hasNext()){
					ExpenseType et = (ExpenseType)itExpType.next();
					if (!findmaster.getClaimType().equals("CY") || et.getExpAccDesc().equalsIgnoreCase("CY")) {
						String RecId = "";
						String RecValue ="0";
						if (ed != null) {
							if (ed.getExpenseDate().equals(fd) && ed.getExpType().equals(et)) {
								RecId = ed.getId().toString();
								RecValue = ed.getUserAmount().toString();
								if (itDetail.hasNext()) {
									ed = (ExpenseDetail)itDetail.next();
								}
							}
						}
					//	if(claimedExTypeList.contains(et) || !findmaster.getClaimType().equals("CY")){
					String aa="";
					if (findmaster.getProject().getCategory()!=null)
					{	aa=findmaster.getProject().getCategory();}
						if(	claimedExTypeList.contains(et) || 
							(!findmaster.getClaimType().equals("CY") && !et.getExpDesc().equals("Allowance")) ||
							(!findmaster.getClaimType().equals("CY") && et.getExpDesc().equals("Allowance") && dateSet.contains(fd))
							|| (findmaster.getProject().getDepartment().getPartyId().equals("011"))
							|| aa.equals("General Expense")
							||((findmaster.getExpenseUser().getUserLoginId().equalsIgnoreCase("CN01264"))
								||(findmaster.getExpenseUser().getUserLoginId().equalsIgnoreCase("CN01061"))
								||(findmaster.getExpenseUser().getUserLoginId().equalsIgnoreCase("CN01175"))
								||(findmaster.getExpenseUser().getUserLoginId().equalsIgnoreCase("CN01548")))							
							){
				%>		
							<td align="right"><input type=hidden name="RecId<%=i%>" value="<%=RecId%>"><input type=text class=inputBox name="RecordVal<%=i%>" size=8 value="<%=RecValue%>" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999);CalcTot()" <%=fRead%>></td>
				<%		
						}else{%>
							<td align="right"><input type=hidden name="RecId<%=i%>" value="<%=RecId%>"><input type=text readonly Style='background-color:#A9A9A9' class=inputBox name="RecordVal<%=i%>" size=8 value="0" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999);CalcTot()" <%=fRead%>></td>
				<%
						}
					}	
				}
				%>
				<td align="right" class="lblbold" Id="tTot<%=i%>">0.0</td>
				<%String CmtRecId = "";
				String CmtValue ="";
				if (ec != null) {
					if (ec.getExpenseDate().equals(fd)) {
						CmtRecId = ec.getId().toString();
						CmtValue = ec.getComments();
						if (itCmts.hasNext()) {
							ec = (ExpenseComments)itCmts.next();
						}
					}
				} %>
				<td><input type=hidden name="CmtRecId<%=i%>" value="<%=CmtRecId%>"><input type=text class=inputBox name="CmtVal<%=i%>" size=50 value="<%=CmtValue%>" <%=fRead%>></td>
			<% i++;
			}%>
			<tr align="center" bgcolor="#e9eee9">
				<td align="left" class="lblbold">Total Entry:</td>
				<%
				int col = 0;
				itExpType = ExpTypeList.iterator();
				while(itExpType.hasNext()){
					ExpenseType et = (ExpenseType)itExpType.next();
					if (!findmaster.getClaimType().equals("CY") || et.getExpAccDesc().equalsIgnoreCase("CY")) {
				%>
					<td align="right" class="lblbold" id='tSubTot<%=col%>'>0</td>
				<%	col++;
					}
				}
				%>
				<td align="right" class="lblbold" id='tTot'>0</td>
				<td>&nbsp;</td>
			</tr>
			<tr align="center" bgcolor="#e9eee9">
				<td align="left" class="lblbold">Total Verified:</td>
				<%
				Iterator itAmt = AmountList.iterator();
				ExpenseAmount ea = null;
				if (itAmt.hasNext()) {
					ea = (ExpenseAmount)itAmt.next();
				}
				itExpType = ExpTypeList.iterator();
				float RowTotal = 0;
				while(itExpType.hasNext()){
					ExpenseType et = (ExpenseType)itExpType.next();
					if (!findmaster.getClaimType().equals("CY") || et.getExpAccDesc().equalsIgnoreCase("CY")) {
						String AmtStr = "&nbsp;";
						String RecId = "";
						if (ea != null) {
							if (ea.getExpType().equals(et)) {
								RecId = ea.getId().toString();
								if (ea.getConfirmedAmount() != null) {
									AmtStr = ea.getConfirmedAmount().toString();
									RowTotal = RowTotal + ea.getConfirmedAmount().floatValue();
								}
								if (itAmt.hasNext()) {
									ea = (ExpenseAmount)itAmt.next();
								}
							}
						} 
				%>
					<td align="right" class="lblbold"><%=AmtStr%><input type=hidden name="AmtRecId" value="<%=RecId%>"></td>
				<%
					}
				}
				%>
				<td align="right" class="lblbold"><%=RowTotal%></td>
				<td>&nbsp;</td>
			</tr>
			<tr align="center" bgcolor="#e9eee9">
				<td align="left" class="lblbold">Total Claimed:</td>
				<%
				itAmt = AmountList.iterator();
				if (itAmt.hasNext()) {
					ea = (ExpenseAmount)itAmt.next();
				}
				itExpType = ExpTypeList.iterator();
				RowTotal = 0;
				while(itExpType.hasNext()){
					ExpenseType et = (ExpenseType)itExpType.next();
					if (!findmaster.getClaimType().equals("CY") || et.getExpAccDesc().equalsIgnoreCase("CY")) {
						String AmtStr = "&nbsp;";
						if (ea != null) {
							if (ea.getExpType().equals(et)) {
								if (ea.getPaidAmount() != null) {
									AmtStr = ea.getPaidAmount().toString();
									RowTotal = RowTotal + ea.getPaidAmount().floatValue();
								}
								if (itAmt.hasNext()) {
									ea = (ExpenseAmount)itAmt.next();
								}
							}
						} 
				%>
					<td align="right" class="lblbold"><%=AmtStr%></td>
				<%
					}
				}
				%>
				<td align="right" class="lblbold"><%=RowTotal%></td>
				<td>&nbsp;</td>
			</tr>
			<tr align="center">
				<td align="left" colspan="9">
					<%if (FreezeFlag.equals("N")) {%>
						<%if (findmaster.getApprovalDate() == null && findmaster.getExpenseUser().getUserLoginId().equals(ul.getUserLoginId())) {%>
						<input TYPE="button" class="button" name="Save" value="Save As Draft" onclick="fnSubmit('Draft')">
						<input TYPE="button" class="button" name="Submit" value="Submit Record" onclick="fnSubmit('Submitted')">
						<input TYPE="button" class="button" name="Delete" value="Delete" onclick="fnDelete()">
						<%}%>
					<%}%>
					<% 
					String YN = "YES";
					Iterator itd = partyList_dep.iterator();
					while(itd.hasNext()){
						Party p = (Party)itd.next();
						if (findmaster.getStatus().equals("Draft") || findmaster.getStatus().equals("Submitted")){
							YN="NO";
						}
					}%>
					<%if (YN.equals("YES")||findmaster.getProject().getDepartment().getPartyId().equals("011")){%>
						<input TYPE="button" class="button" name="PrintForm" value="Excel Form" onclick="fnExportForm()">
					<%}%>
					<input type="button" value="Back to List" name="Back" class="button" onclick="location.replace('findExpSelfPage.do');">
					<input type="button" class="button" name="ViewTS" value="View TimeSheet" onclick="showTsDialog();">
					<input type="hidden" name="ExUserId" value="<%=ul.getUserLoginId()%>">
					<input type="hidden" name="ProjectId" value="<%=findmaster.getProject().getProjId()%>">
					<input type="hidden" name="ProjectNm" value="<%=findmaster.getProject().getProjName()%>">
					<input type="hidden" name="DatePeriod" value="<%=Date_formater.format((Date)DateList.iterator().next())%>">
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</form>
<%}
	request.removeAttribute("findmaster");
	request.removeAttribute("detailList");
	request.removeAttribute("DateList");
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
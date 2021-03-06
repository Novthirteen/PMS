<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/app.tld" prefix="app" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
try{
if (AOFSECURITY.hasEntityPermission("EXPENSE", "_CLAIM", session)) {

SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

String action = "";
String DataId = request.getParameter("DataId");

String SecId = request.getParameter("SecId");
if (SecId == null) SecId ="1";
String ListURLStr = "";

ExpenseMaster findmaster = (ExpenseMaster)request.getAttribute("findmaster");

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

String FreezeFlag = (String)request.getAttribute("FreezeFlag");
if (FreezeFlag == null){
if(findmaster.getStatus() != null && (findmaster.getStatus().equals("Confirmed")||findmaster.getStatus().equals("Claimed")))
FreezeFlag = "Y";
else FreezeFlag = "N";
}

UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
%>
<script>
function onCurrSelect() {
	var formObj = document.forms["frm"];
	formObj.elements["FormAction"].value = "currencySelect";
	formObj.submit();
}
function showDialog() {
	var formObj = document.forms["frm"];
	document.ProjectListForm.DataPeriod.value = document.frm.DataPeriod.value;
	openProjectSelectDialog("onCloseDialog" ,"frm");
}
function showTsDialog(){
 with(document.frm)
	{   
	    var url = 'findTSPage.do?UserId='+document.getElementById("ExUserId").value+'&ProjectId='+document.getElementById("ProjectId").value+'&DataId='+document.getElementById("DatePeriod").value+'&ProjectNm='+document.getElementById("ProjectNm").value;
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.timesheet.viewtimesheet.title&" + url,
			null,
			'dialogWidth:800px;dialogHeight:500px;status:no;help:no;scroll:no');
   }
}
function onCloseDialog() {
	var formObj = document.forms["frm"];
	setValue("hiddenProjectName","projName");	
	setValue("hiddenProjectCode","projId");
	setProjValue("hiddenProjectCode","hiddenProjectName","proj");
}

function fnSubmit(status) {
	var formObj = document.forms["frm"];
	formObj.FormStatus.value = status;
	formObj.action = "";
	formObj.target = "_self";
	formObj.submit();
}

function fnExportForm() {
	var formObj = document.forms["frm"];
	formObj.FormStatus.value = status;
	formObj.action = "pas.report.expenseprint.do";
	formObj.target = "_blank";
	formObj.submit();
}
</script>
<%if (findmaster != null) {
	action = "update";
	String fRead = "";
	if ( FreezeFlag.equals("Y")) {
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
	var tot=0.00;
	var oText;
	oText=document.getElementsByName("AmtRecValue");
	for(var j=0;j<oText.length;j++)
	{
		tot = tot + parseFloat(oText[j].value);
	}
	oTdtot=document.getElementById("tTot");
	oTdtot.innerHTML=rndNum(tot);
}
</script>
<form name="frm" method="post">
<input type="hidden" name="FormAction" id="FormAction" value="<%=action%>">
<input type="hidden" name="SecId" id="SecId" value="<%=SecId%>">
<input type="hidden" name="DataId" id="DataId" value="<%=findmaster.getId().toString()%>">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>  Expense Pay-Out Maintenance </CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Form Code :</td><td class="lblLight"><%=findmaster.getFormCode()%></td>
				<td class="lblbold" align=right>Deparment :</td><td class="lblLight"><%=findmaster.getExpenseUser().getParty().getDescription()%></td>
				<td class="lblbold" align=right>User:</td><td class="lblLight"><%=findmaster.getExpenseUser().getName()%><input type="hidden" name="UserId" id="UserId" value="<%=findmaster.getExpenseUser().getUserLoginId()%>"></td>
				<td class="lblbold" align=right>Status:</td>
				<td class="lblLight"><%=findmaster.getStatus()%>
				<input type="hidden" name="FormStatus" id="FormStatus" value="<%=findmaster.getStatus()%>">&nbsp;</td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Entry Period:</td>
				<td class="lblLight"><%=Date_formater.format(findmaster.getEntryDate())%>&nbsp;</td>
				<td class="lblbold" align=right>Expense Period:</td>
				<td class="lblLight"><%=Date_formater.format(findmaster.getExpenseDate())%>&nbsp;</td>
				<td class="lblbold" align=right>Currency:</td><td class="lblLight"><%=findmaster.getExpenseCurrency().getCurrId()%></td>
				<td class="lblbold" align=right>Exchange Rate(RMB):</td><td class="lblLight"><%=findmaster.getCurrencyRate()%></td>
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
					<%if (findmaster.getClaimType().equals("CY")) {
						out.println("Customer");
					} else {
						out.println("Company");
					}%>
				</td>
				<td class="lblbold" align=right>&nbsp;</td>
				<td class="lblLight">&nbsp;</td>
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
				<td class="lblbold" align="center">&nbsp;</td>
				<%
				int ExpLevel= 0;
				Iterator itExpType = ExpTypeList.iterator();
				while(itExpType.hasNext()){
					ExpenseType et = (ExpenseType)itExpType.next();
					if (!findmaster.getClaimType().equals("CY") || !et.getExpDesc().equals("Allowance")) {
					ExpLevel= et.getExpSeq().length();
				%>
				<td class="lblbold" align="center"><%=et.getExpDesc()%><input type="hidden" name="ExpType" id="ExpType" value="<%=et.getExpId()%>"></td>
				<%
					}
				}
				%>
				<td class="lblbold" align="center">Total</td>
				<td class="lblbold" align="center">Comments</td>
			</tr>
			<%
			boolean NullData = true;
			int i=0;
			float RowTotal = 0;
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

			Iterator itDate = DateList.iterator();
			while(itDate.hasNext()){
				Date fd = (Date)itDate.next();%>
				<tr bgcolor="#e9eee9">
				<td class="lblbold"><%=Date_formater.format(fd)%><input type="hidden" name="DateId" id="DateId" value="<%=Date_formater.format(fd)%>"></td>
				<%itExpType = ExpTypeList.iterator();
				RowTotal = 0;
				while(itExpType.hasNext()){
					ExpenseType et = (ExpenseType)itExpType.next();
					if (!findmaster.getClaimType().equals("CY") || et.getExpAccDesc().equalsIgnoreCase("CY")) {
						NullData = false;
						if (ed != null) {
							if (ed.getExpenseDate().equals(fd) && ed.getExpType().equals(et)) {
								RowTotal = RowTotal + ed.getUserAmount().floatValue();%>
								<td><%=ed.getUserAmount()%></td>
								<%if (itDetail.hasNext()) {
									ed = (ExpenseDetail)itDetail.next();
								}
							} else {
								NullData = true;
							}
						} else {
							NullData = true;
						}
						if (NullData) {
				%>
					<td>&nbsp;</td>
				<%	
						}
					}
				}
				%>
				<td class="lblbold"><%=RowTotal%></td>
				<%NullData = false;
				if (ec != null) {
					if (ec.getExpenseDate().equals(fd)) {%>
						<td><%=ec.getComments()%></td>
						<%if (itCmts.hasNext()) {
							ec = (ExpenseComments)itCmts.next();
						}
					} else {
						NullData = true;
					}
				} else {
					NullData = true;
				}
				if (NullData) {%>
				<td>&nbsp;</td>
				<%
				}
				%>
			<% i++;
			}%>
			<tr align="center" bgcolor="#e9eee9">
				<td align="left" class="lblbold">Total (Staff):</td>
				<%
				Iterator itAmt = AmountList.iterator();
				ExpenseAmount ea = null;
				if (itAmt.hasNext()) {
					ea = (ExpenseAmount)itAmt.next();
				}
				itExpType = ExpTypeList.iterator();
				RowTotal = 0;
				while(itExpType.hasNext()){
					ExpenseType et = (ExpenseType)itExpType.next();
					if (!findmaster.getClaimType().equals("CY") || et.getExpAccDesc().equalsIgnoreCase("CY")) {
						String AmtStr = "&nbsp;";
						String RecId = "";
						if (ea != null) {
							if (ea.getExpType().equals(et)) {
								RecId = ea.getId().toString();
								if (ea.getUserAmount() != null) {
									AmtStr = ea.getUserAmount().toString();
									RowTotal = RowTotal + ea.getUserAmount().floatValue();
								}
								if (itAmt.hasNext()) {
									ea = (ExpenseAmount)itAmt.next();
								}
							}
						} 
				%>
					<td align="left" class="lblbold"><%=AmtStr%><input type="hidden" name="AmtRecId" id="AmtRecId" value="<%=RecId%>"></td>
				<%
					}
				}
				%>
				<td align="left" class="lblbold"><%=RowTotal%></td>
				<td>&nbsp;</td>
			</tr>
			<tr align="center" bgcolor="#e9eee9">
				<td align="left" class="lblbold">Total (Verified):</td>
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
						String AmtStr = "0";
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
					<td align="left" class="lblbold"><%=AmtStr%></td>
				<%
					}
				}
				%>
				<td align="left" class="lblbold"><%=RowTotal%></td>
				<td>&nbsp;</td>
			</tr>
			<tr align="center" bgcolor="#e9eee9">
				<td align="left" class="lblbold">Total (Claimed):</td>
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
								} else {
									AmtStr = ea.getConfirmedAmount().toString();
									RowTotal = RowTotal + ea.getConfirmedAmount().floatValue();
								}
								if (itAmt.hasNext()) {
									ea = (ExpenseAmount)itAmt.next();
								}
							}
						} 
				%>
					<td align="left" class="lblbold"><input type="text" name="AmtRecValue" id="AmtRecValue" class=inputBox size=8 value="<%=AmtStr%>" <%=fRead%> onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999,9999999);CalcTot()"></td>
				<%
					}
				}
				%>
				<td align="left" class="lblbold" id='tTot'><%=RowTotal%></td>
				<td>&nbsp;</td>
			</tr>
			<tr align="center">
				<td align="left" colspan="7">
					<%if (findmaster.getReceiptDate() == null) {%>
						<input TYPE="button" class="button" name="Save" value="Save Record" onclick="fnSubmit('')">
						<input TYPE="button" class="button" name="Submit" value="Confirm" onclick="fnSubmit('Confirmed')">
						<input TYPE="button" class="button" name="Submit" value="Reject" onclick="fnSubmit('F&A Rejected')">
						<input TYPE="button" class="button" name="Submit" value="Pay-Out" onclick="fnSubmit('Claimed')">
					<%}%>
					<input TYPE="button" class="button" name="PrintForm" value="Excel Form" onclick="fnExportForm()">
					<input type="button" value="Back to List" name="Back" class="button" onclick="location.replace('findExpToClaimPage.do');">
					<input type="button" class="button" name="ViewTS" value="View TimeSheet" onclick="showTsDialog();">
					<input type="hidden" name="ExUserId" id="ExUserId" value="<%=findmaster.getExpenseUser().getName()%>">
					<input type="hidden" name="ProjectId" id="ProjectId" value="<%=findmaster.getProject().getProjId()%>">
					<input type="hidden" name="ProjectNm" id="ProjectNm" value="<%=findmaster.getProject().getProjName()%>">
					<input type="hidden" name="DatePeriod" id="DatePeriod" value="<%=Date_formater.format((Date)DateList.iterator().next())%>">
				</td>
			</tr>
			<%if(request.getAttribute("deleteErrorString") != null)
				{
			%>
				<tr><td align="middle" colspan="7" class="lblbold"><%=(String)request.getAttribute("deleteErrorString")%></td></tr>
			<%
				}
			%>
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
}catch(Exception e)
{
e.printStackTrace();
}
%>
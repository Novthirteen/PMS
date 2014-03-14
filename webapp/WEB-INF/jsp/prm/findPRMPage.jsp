<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (AOFSECURITY.hasEntityPermission("TIME_SHEET", "_VIEW", session)) {
	String chkSelect=request.getParameter("staffId");
	String chkParty=request.getParameter("partyId");
	String SecId=request.getParameter("SecId");
	String sltYR=request.getParameter("sltYR");

	String btnSave = request.getParameter("btnSave");
	String FormAction = request.getParameter("FormAction");

	if(chkSelect == null ) chkSelect = "";
	if(chkParty == null ) chkParty = "";
	if(sltYR == null ) sltYR = "";
	if(SecId == null ) SecId = "0";
	
	if(FormAction == null ) FormAction = "Select";
	
	UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
	List result = null;
	Party SltParty = null;
	String SltFlag="";
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/findPRMPage.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>

<SCRIPT>

function QueryData(SecId)
{
	document.FindPRMForm.chkSelect.value= document.FindPRMForm.staffId.value;
	document.FindPRMForm.chkParty.value= document.FindPRMForm.partyId.value;
	switch (SecId) {
		case 1:
			document.FindPRMForm.action="listTimeSheet.do";
			document.FindPRMForm.submit();
			break;
		case 2:
			document.FindPRMForm.action="listTSForecast.do";
			document.FindPRMForm.submit();
			break;
		case 3:
			document.FindPRMForm.action="listTSApproval.do";
			document.FindPRMForm.submit();
			break;
		case 4:
			document.FindPRMForm.action="listTSCAFUpdate.do";
			document.FindPRMForm.submit();
			break;
		default:
	}
}

function showStaff() {
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
			document.FindPRMForm.staffId.value=v.split("|")[0];
			document.FindPRMForm.staffName.value=v.split("|")[1];
			document.FindPRMForm.partyId.value=v.split("|")[2];
			document.FindPRMForm.partyName.value=v.split("|")[3];
	}
}

/*function showDialog(SecId,partyId) {
	var formObj = document.forms["FindPRMForm"];
	formObj.elements["SecId"].value = SecId;
	openStaffSelectDialog("onCloseDialog_staff" ,"FindPRMForm",partyId);
}*/

function onCloseDialog() {
	var formObj = document.forms["FindPRMForm"];
	setValue("hiddenStaffName","staffName");	
	setValue("hiddenStaffCode","staffId");
	setValue("hiddenPartyCode","partyId");
	setValue("hiddenPartyName","partyName");
}
</SCRIPT>
<Form action="PRMUserList.do" name="UserListForm" method="post">
	<input type="hidden" name="CALLBACKNAME">
	<input type="hidden" name="partyId">
</Form>
<FORM name="FindPRMForm" method=post>
<BR><BR>
<TABLE width=100% >
	<CAPTION class=pgheadsmall>Configuration Screen
	<%int SecCd = new Integer(SecId).intValue();
	switch (SecCd) {
		case 1:%>For Time Sheet Entry
		<%	break;
		case 2:%>For Time Sheet Forecast
		<%	break;
		case 3:%>For Time Sheet Approval
		<%	break;
		case 4:%>For Time Sheet CAF Update
	<%}%>
	</CAPTION>
	<tr>
		<td>
			<TABLE width=250 cellspacing=2 cellpadding=2 align=center FRAME=0 rules=none border=1>
				<tr>
					<TD class=lblbold>Department:</TD>
					<TD class=lblLight>
						<input type = "text" readonly="true" name = "partyName" maxlength="100" value="<%=ul.getParty().getDescription()%>">
						<input type = "hidden" name = "partyId" maxlength="100" value="<%=ul.getParty().getPartyId()%>">
					</TD>
				</tr>
				<tr>
					<TD class=lblbold><% switch (SecCd) {
						case 1:%>Staff:
						<%	break;
						case 2:%>Staff:
						<%	break;
						case 3:%>Approver:
						<%	break;
						case 4:%>Staff:
					<%}%>
							</TD>
					<TD class=lblLight>
						<input type = "text" readonly="true" name = "staffName" maxlength="100" value="<%=ul.getName()%>">
						<input type = "hidden" name = "staffId" maxlength="100" value="<%=ul.getUserLoginId()%>">
						<%if (AOFSECURITY.hasEntityPermission("TIME_SHEET", "_ALL", session)) {%>
						<!--a href='javascript: showDialog(<%=SecId%>,"<%=ul.getParty().getPartyId()%>")'><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0" /></a-->
						<a href='javascript: showStaff()'><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0" /></a>
						<%}%>
					</TD>
				</tr>
				<tr>
					<TD class=lblbold>Year</TD>
					<TD class=lblLight>
						<SELECT name=sltYR>
						<%
						int i;
						Calendar c = Calendar.getInstance();
						
						for (i=c.get(Calendar.YEAR)-1; i<c.get(Calendar.YEAR)+2; i++){%><Option value='<%=i%>' <%if (c.get(Calendar.YEAR) == i) {%> Selected <%}%>><%=i%></OPTION>
						<%}%>
						</SELECT>
					</TD>
				</tr>
				<tr>
					<TD class=lblbold align=center colspan=2>
						<INPUT class=button TYPE=button name=btnSave value='Proceed >>' onclick="QueryData(<%=SecId%>)">
					</TD>
				</tr>
			</TABLE>
		</td>
	</tr>
</TABLE>
<BR><BR>
<INPUT TYPE=hidden name=SecId value='<%=SecId%>'>
<INPUT TYPE=hidden name=chkSelect value="<%=chkSelect%>">
<INPUT TYPE=hidden name=chkParty value="<%=chkParty%>">
</Form>
<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
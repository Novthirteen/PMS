<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld"prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld"prefix="tiles"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/projectSelect.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<script>
function onSelect() {
	//var formObj = document.forms["ProjectSelectForm"];
	document.forms["ProjectSelectForm"].elements["FormAction"].value = "projectSelect";
	document.forms["ProjectSelectForm"].submit();
}
function onSubmit() {
	var projectSelect = document.getElementById("projectSelect").value;
	var eventSelect = document.getElementById("eventSelect").value;
	var ServiceTypeSelect = document.getElementById("ServiceTypeSelect").value;
	var descriptionSelect = "";
	if (document.getElementById("descriptionSelect") != null) {
		descriptionSelect = document.getElementById("descriptionSelect").value;
	}
	var textObj = document.getElementById("descriptionSelect");
	if (textObj != null) {
		if (projectSelect == "" && textObj.value == "") {
			alert("Project and Description can not be both ignore!");
		} else {
			window.parent.returnValue = projectSelect + "$" + eventSelect + "$" + ServiceTypeSelect + "$" + descriptionSelect;
			window.parent.close();
		}
	} else {
		if (projectSelect == "") {
			alert("Project can not be ignore!");
		} else {
		    window.parent.returnValue = projectSelect + "$" + eventSelect + "$" + ServiceTypeSelect + "$" + descriptionSelect;
			self.close();
		}
	}	
}
/*
function onSubmit() {

	var selObj = document.getElementById("projectSelect");

	var textObj = document.getElementById("descriptionSelect");

	if (textObj != null) {
		if (selObj.value == "" && textObj.value == "") {
			alert("Project and Description can not be both ignore!");
		} else {
			fnSave();
		}
	} else {
		if (selObj.value == "") {
			alert("Project can not be ignore!");
		} else {
			fnSave();
		}
	}
}*/
</script>
<%
if (AOFSECURITY.hasEntityPermission("CUST_PROJECT", "_SELECT", session)) {
	String chkSelect=request.getParameter("chkSelect");
	String chkParty=request.getParameter("chkParty");
	String sltYR=request.getParameter("sltYR");

	if(chkSelect == null ) chkSelect = "";
	if(chkParty == null ) chkParty = "";
	if(sltYR == null ) sltYR = "";

	String UserId=request.getParameter("UserId");
	String DataPeriod=request.getParameter("DataPeriod");
	String SelectType=request.getParameter("SelectType");

	if(UserId == null ) UserId = "";
	if(DataPeriod == null ) DataPeriod = "";
	if(SelectType == null ) SelectType = "";

%>
<html:form action="/projectSelect.do" method="POST">
<title>Project Selection</title>
<input type="hidden" name="CALLBACKNAME" id="CALLBACKNAME">
<input type="hidden" name="hiddenProjectCode" id="hiddenProjectCode">
<input type="hidden" name="hiddenEventCode" id="hiddenEventCode">
<input type="hidden" name="hiddenServiceType" id="hiddenServiceType">
<input type="hidden" name="hiddenDescription" id="hiddenDescription">
<input type="hidden" name="hiddenBillable" id="hiddenBillable">
<input type="hidden" name="FormAction" id="FormAction">
<input type="hidden" name="UserId" id="UserId" value="<%=UserId%>">
<input type="hidden" name="DataPeriod" id="DataPeriod" value="<%=DataPeriod%>">
<input type="hidden" name="SelectType" id="SelectType" value="<%=SelectType%>">

<link REL="Stylesheet" type="text/css" href="js/style2.css">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall><bean:message key="prm.timesheet.projectSelect.title"/></CAPTION>
</table>
<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
	<tr bgcolor="e9eee9">
		<td class=lblbold><bean:message key="prm.timesheet.projectLable"/>:</td>
		<td class=lblbold colspan=3>
			<html:select property="projectSelect" onchange="javascript:onSelect()"  size="1" styleId="projectSelect" >
			<html:option value="">(Select...)</html:option>
			<html:optionsCollection name="projectSelectArr" value="key" label="value" />
			</html:select>
		</td>
	</tr>
		<tr bgcolor="e9eee9">
			<td class=lblbold width=10% ><bean:message key="prm.timesheet.eventLable" />:</td>
			<td class=lblbold width=30% ><html:select property="eventSelect" styleId = "eventSelect" onchange="javascript:onSelect()" size="1">
				<html:optionsCollection name="eventSelectArr" value="key"
					label="value" />
			</html:select></td>
			<td width=10%  class=lblbold align=left>Billable:</td>
			<td class=lblbold width=50% >
			<html:select property="eventSelect" size="1"  disabled="true" styleId="eventSelect">
				<html:optionsCollection name="eventBillable" value="key"
					label="value" />
			</html:select>
			</td>
		</tr>
		<tr bgcolor="e9eee9">
			<td class=lblbold><bean:message key="prm.timesheet.servicetypeLable" />:</td>
			<td class=lblbold colspan=3>
				<html:select property="ServiceTypeSelect" size="1" styleId="ServiceTypeSelect">
				<html:optionsCollection name="ServiceTypeSelectArr" value="key"
					label="value" />
			</html:select></td>
		</tr>
		<%
		if ("TSForecast".equals(SelectType)) {
	%>
	<tr bgcolor="e9eee9">
		<td class=lblbold><bean:message key="prm.timesheet.descriptionLable"/>:</td>
		<td class=lblbold colspan=3>
			<html:textarea property = "descriptionSelect" cols="65" rows="3" styleId="descriptionSelect">
			</html:textarea>
		</td>
	</tr>
	<%
		}
	%>
	<tr>
		<td colspan=3 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:onSubmit()">&nbsp;&nbsp;
			&nbsp;&nbsp;<input type=button name="close" class=button value="Cancel" onclick="javascript:window.parent.close();">
		</td>
	</tr>
</table>
</html:form> 
<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>

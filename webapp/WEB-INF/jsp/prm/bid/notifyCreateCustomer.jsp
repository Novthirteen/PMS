<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
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
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<%
Object obj = request.getAttribute("toClose");
List result = null;
if(obj!=null){
%>
<script>self.close();</script>
<%}else{
Object resultObject = request.getAttribute("resultList");
	if(resultObject!=null){
		result = (List)resultObject;
	}
}%>
<script language="javascript">
function showDialogPerson(){
	var code,desc,email;
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			email=v.split("|")[4];
			labelSendTo.innerHTML=code+":"+desc;
			targetName.value=desc;
			emailAddr.value=email;
		} else {
			labelSendTo.innerHTML="";
			emailAddr.value="";
		}
	}
}
function toSubmit(){
with(document.frm){
	if(	custName.value==""||
		chnName.value==""||
		address.value==""||
		emailAddr.value==""||
		industry.options[industry.selectedIndex].value==""){
		alert("Please complete all the information");
		return false;
	}
	
	submitButton.disabled=true;
	formAction.value = "submit";
	submit();
}
}
</script>
<%try{	
if (AOFSECURITY.hasEntityPermission("SALES_FUNNEL", "_CREATE", session)) {
%>
<form action="notifyCreateCustomer.do" method="post" name="frm">
<table width='100%' border='0' cellspacing='2' cellpadding='0' align="center">
<tr>
	<TD align=left class="wpsPortletTopTitle" colspan=6>
	Required Customer Information</TD>
</tr>
<tr>
	<td align="right"  class="lblbold">
		<span class="tabletext">Customer Name:</span>
	</td>
	<td align="left"  class="lblbold">
		<input type="text" name="custName" value=""><font color="red" size="3">&nbsp;*</font>
	</td>
</tr>
<tr>
	<td align="right"  class="lblbold">
		<span class="tabletext">Chinese Name:</span>
	</td>
	<td align="left"  class="lblbold">
		<input type="text" name="chnName" value=""><font color="red" size="3">&nbsp;*</font>
	</td>
</tr>
<tr>
	<td align="right"  class="lblbold">
		<span class="tabletext">Address:</span>
	</td>
	<td align="left"  class="lblbold">
		<input type="text" name="address" value=""><font color="red" size="3">&nbsp;*</font>
	</td>
</tr>
<tr>
	<td align="right"  class="lblbold">
		<span class="tabletext">Industry:</span>
	</td>
	<td align="left"  class="lblbold">
		<select name="industry">
			<option value="">Select Industry...</option>
		<%if(result!=null){
			Iterator ite = result.iterator();
			while(ite.hasNext()){
				Industry ind = (Industry)ite.next();
		%>
			<option value="<%=ind.getDescription()%>"><%=ind.getDescription()%></option>
		<%}}%>
		</select>
		<font color="red" size="3">&nbsp;*</font>
	</td>
</tr>
<tr>
	<td align="right"  class="lblbold">
		<span class="tabletext">Send To:</span>
	</td>
	<td align="left"  class="lblbold">
		<div style="display:inline" id="labelSendTo">&nbsp;</div>
			<input type="hidden" name="emailAddr" value=""> 
			<input type="hidden" name="targetName" value="">
			<a href="javascript:showDialogPerson()"><img align="absmiddle"
			alt="<bean:message key="helpdesk.call.select" />"
			src="images/select.gif" border="0" /></a>
	</td>
</tr>
<tr>
	<td align="right"><input type="button" name="submitButton" value="Submit" onclick="return toSubmit();"></td>
	<td/>
</tr>
</table>
<input type="hidden" name="formAction" value="">
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
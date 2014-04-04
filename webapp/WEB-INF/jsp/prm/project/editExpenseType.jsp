<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("EXPENSE_TYPE", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();   
ExpenseType EditDataInfo = null;
String DataStr = request.getParameter("DataId");
Integer DataId = null;
if (DataStr == null || DataStr.length()<1) {
	
} else {
	DataId = new Integer(DataStr);					
}
int i=0;
List expTypeList = null;
try{
	// get expense type
	ProjectHelper ph = new ProjectHelper();
	expTypeList = ph.getAllExpenseType(hs);
	
}catch(Exception e){
	out.println(e.getMessage());
}


Iterator it =expTypeList.iterator();
	while(it.hasNext()){
	ExpenseType et = (ExpenseType)it.next();
	i++;
    } 


String FormAction = request.getParameter("FormAction");

if (DataId!=null){
	EditDataInfo = (ExpenseType)hs.load(ExpenseType.class,DataId);
}
	
if(FormAction == null){
	FormAction = "create";
}


	
%>
<script language="javascript">

function FnUpdate() {
	
	document.EditForm.FormAction.value = "update";
	document.EditForm.submit();
}
</script>
<br>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
<td width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
  <tr>
  <td align=left width='90%' class="wpsPortletTopTitle">
           Expense Type Maintenance
</td>
  </tr>
      </table>
  </td>
</tr>
  <TR>
<td width='100%'>
<%
    if(EditDataInfo != null){
    	FormAction="update";
%>
<form Action="editExpenseType.do" method="post" name="EditForm">
<input type="hidden" name="FormAction" id="FormAction" >
<input type="hidden" name="DataId" id="DataId" value="<%=DataId%>">
<table width='100%' border='0' cellpadding='0' cellspacing='2'>
	<tr>
		<td align="right">
			<span class="tabletext">Account Code(Paid by Customer):&nbsp;</span>
		</td>
		<td>
			<input type="text" class="inputBox" name="expCode" value="<%=EditDataInfo.getExpCode()%>">
		</td>
	</tr>
<!-- 	<tr>
		<td align="right">
			<span class="tabletext">Account Description(Paid by Customer):&nbsp;</span>
		</td>
		<td>
			<input type="text" class="inputBox" name="expAccDesc" value="<%=EditDataInfo.getExpAccDesc()%>">
		</td>
	</tr>
-->
	<tr>
		<td align="right">
			<span class="tabletext">Account Code(Paid by Company):&nbsp;</span>
		</td>
		<td>
			<input type="text" class="inputBox" name="expBillCode" value="<%=EditDataInfo.getExpBillCode()%>">
		</td>
	</tr>
<!-- 	<tr>
		<td align="right">
			<span class="tabletext">Account Description(Paid by Company):&nbsp;</span>
		</td>
		<td>
			<input type="text" class="inputBox" name="expBillAccDesc" value="<%=EditDataInfo.getExpBillAccDesc()%>">
		</td>
	</tr>
-->
	<tr>  
		<td align="right">
			<span class="tabletext">Expense Description:&nbsp;</span>
		</td>
		<td align="left">
			<input type="text" class="inputBox" name="expDesc" value="<%=EditDataInfo.getExpDesc()%>" size="30">
		</td>
	</tr>
	<tr>
		<td align="right">
			<span class="tabletext"></span>
		</td>
		<td align="left">
			<input type="button" value="save" class="loginButton" onclick="javascript:FnUpdate();">
			<input type="reset" value="Cancel" class="loginButton">
		</td>
		<td align="left">
			<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listExpenseType.do')">
		</td>
	</tr>
</table>
</form>
<%
	}else{
%>
<form Action="editExpenseType.do" method="post">
<input type="hidden" name="FormAction" id="FormAction" value="<%=FormAction%>">

<table width='100%' border='0' cellpadding='0' cellspacing='2'>
	<tr>
		<td align="right">
			<span class="tabletext">Account Code(Paid by Company):&nbsp;</span>
		</td>
		<td>
			<input type="text" class="inputBox" name="expCode" size="30" >
		</td>
	</tr>
	<tr>
		<td align="right">
			<span class="tabletext">Account Description(Paid by Company):&nbsp;</span>
		</td>
		<td>
			<input type="text" class="inputBox" name="expAccDesc" size="30" >
		</td>
	</tr>
	<tr>
		<td align="right">
			<span class="tabletext">Account Code(Paid by Customer):&nbsp;</span>
		</td>
		<td>
			<input type="text" class="inputBox" name="expBillCode" size="30" >
		</td>
	</tr>
	<tr>
		<td align="right">
			<span class="tabletext">Account Code(Paid by Customer):&nbsp;</span>
		</td>
		<td>
			<input type="text" class="inputBox" name="expBillAccDesc" size="30" >
		</td>
	</tr>
	<tr> 
		<td align="right">
			<span class="tabletext">Expense Description:&nbsp;</span>
		</td>
		<td align="left">
			<input type="text" class="inputBox" name="expDesc" size="30">
		</td>
	</tr>
	<tr>
		<td align="right">
			<span class="tabletext"></span>
		</td>
		<td align="left">
			<input type="submit" value="Save" class="loginButton">
		    <input type="reset" value="Cancel" class="loginButton">
		</td>
		<td align="left">
			<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listExpenseType.do')">
		</td>
	</tr>
</table>
</form>
<%
	}
%> 	
</td>
</tr>
    <tr><td>&nbsp;</td></tr>
</table> 
  

<%
Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>

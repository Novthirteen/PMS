<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.PageKeys"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("CUST_ACCOUNT", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

net.sf.hibernate.Transaction tx =null;

hs.flush();   
CustomerAccount EditDataInfo = null;
String DataStr= request.getParameter("DataId");
Long DataId = null;
if (DataStr == null || DataStr.length()<1) {
	
} else {
	DataId = new Long(DataStr);					
}

String FormAction = request.getParameter("FormAction");
if (DataId!=null){
	EditDataInfo = (CustomerAccount)hs.load(CustomerAccount.class,DataId);
}
if(FormAction == null){
	FormAction = "create";
}
%>
<script language="javascript">
function FnDelete() {
	
	document.EditForm.FormAction.value = "delete";
	document.EditForm.submit();
}
function FnUpdate() {
	document.EditForm.submit();
}
</script>
<br>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Customer Group Maintenance
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
<%
    if(EditDataInfo != null){
    	FormAction="update";
%>
<form Action="editCustomerAccount.do" method="post" name="EditForm">
<input type="hidden" name="FormAction" id = "FormAction" value="<%=FormAction%>">
<input type="hidden" name="DataId" id = "DataId" value="<%=EditDataInfo.getAccountId()%>">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id = "<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table width='100%' border='0' cellpadding='0' cellspacing='2'>
<tr>
	<td align="right">
		<span class="tabletext">Code:&nbsp;</span>
	</td>
	<td><%=EditDataInfo.getAccountId()%></td>
</tr>
<tr>
	<td align="right">
		<span class="tabletext">Name:&nbsp;</span>
	</td>
	<td align="left">
		<input type="text" class="inputBox" name="description" value="<%=EditDataInfo.getDescription()%>" size="30">
	</td>
</tr>
<tr>
	<td align="right">
		<span class="tabletext">Abbreviation:&nbsp;</span>
	</td>
	<td align="left">
		<input type="text" class="inputBox" name="Abbreviation" value="<%=EditDataInfo.getAbbreviation()%>" size="30">
	</td>
</tr>
<tr>
	<td align="right">
		<span class="tabletext">Type:&nbsp;</span>
	</td>
	<td align="left">
		<select name="Type">
		<%if (EditDataInfo.getType().equals("L")) {%>
		<option value="G">Global</option>
		<option value="L" selected>Local</option>
		<%} else {%>
		<option value="G" selected>Global</option>
		<option value="L">Local</option>
		<%}%>
		</select>
	</td>
</tr>
<tr>
	<td align="right">
		<span class="tabletext"></span>
	</td>
	<td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();">
		<input type="button" value="Delete" class="loginButton" onclick="javascript:FnDelete();">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listCustomerAccount.do')">
	</td>
</tr>
</table>
</form>
<%
	}else{
%>
<form Action="editCustomerAccount.do" method="post" name="EditForm">
<input type="hidden" name="FormAction" id = "FormAction" value="<%=FormAction%>">
<input type="hidden" name="DataId" id = "DataId" value="">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id = "<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table width='100%' border='0' cellpadding='0' cellspacing='2'>
<tr>
	<td align="right">
		<span class="tabletext">Code:&nbsp;</span>
	</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td align="right">
		<span class="tabletext">Name:&nbsp;</span>
	</td>
	<td align="left">
		<input type="text" class="inputBox" name="description" value="" size="30">
	</td>
</tr>
<tr>
	<td align="right">
		<span class="tabletext">Abbreviation:&nbsp;</span>
	</td>
	<td align="left">
		<input type="text" class="inputBox" name="Abbreviation" value="" size="30">
	</td>
</tr>
<tr>
	<td align="right">
		<span class="tabletext">Type:&nbsp;</span>
	</td>
	<td align="left">
		<select name="Type">
		<option value="G">Global</option>
		<option value="L" selected>Local</option>
		</select>
	</td>
</tr>
<tr>
	<td align="right">
		<span class="tabletext"></span>
	</td>
	<td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();">
		<input type="reset" value="Cancel" class="loginButton">
		<input type="button" value="Back To List" class="loginButton" onclick="location.replace('listCustomerAccount.do')">
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

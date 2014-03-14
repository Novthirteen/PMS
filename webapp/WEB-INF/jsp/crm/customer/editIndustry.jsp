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
if (AOFSECURITY.hasEntityPermission("INDUSTRY", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

net.sf.hibernate.Transaction tx =null;

hs.flush();   
Industry EditDataInfo = null;
String DataStr= request.getParameter("DataId");
Long DataId = null;
if (DataStr == null || DataStr.length()<1) {
	
} else {
	DataId = new Long(DataStr);					
}

String FormAction = request.getParameter("FormAction");
if (DataId!=null){
	EditDataInfo = (Industry)hs.load(Industry.class,DataId);
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
	
	document.EditForm.FormAction.value = "update";
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
            Industry Maintenance
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
	<form Action="editIndustry.do" method="post" name="EditForm">
    <input type="hidden" name="FormAction" >
    <input type="hidden" name="DataId" value="<%=EditDataInfo.getId()%>">
    <input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
      
        <tr>
        <td align="right">
          <span class="tabletext">Code:&nbsp;</span>
        </td>
        <td><%=EditDataInfo.getId()%></td>
        </tr>
        <tr>
        <td align="right">
          <span class="tabletext">Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" value="<%=EditDataInfo.getDescription()%>" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<input type="reset" value="Cancel" class="loginButton"/>
		</form>
		</td>
		<td align="left">
		<form action="listIndustry.do">
	    <input type="submit" value="Back To List" class="loginButton" size="30" >
		</form>
        </td>

      </tr>    
        <tr><td>&nbsp;</td></tr>  
    </table>

<%
	}else{
%>
	<form Action="editIndustry.do" method="post">
    <input type="hidden" name="FormAction" value="<%=FormAction%>">
   <input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
	<table width='100%' border='0' cellpadding='0' cellspacing='2'>
      <tr>
      <td>&nbsp;	
      </td>
      </tr>
        <tr>
        <td align="right">
          <span class="tabletext">Code:&nbsp;</span>
        </td>
        <td>
        </td>
        </tr>
        <tr>
        <td align="right">
          <span class="tabletext">Description:&nbsp;</span>
        </td>
        <td align="left">
          <input type="text" class="inputBox" name="description" size="30">
        </td>
      </tr>
      <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="submit" value="Save" class="loginButton"/>
        <input type="reset" value="Cancel" class="loginButton"/>
		</form>
		</td>
		<td align="left">
		<form action="listIndustry.do">
	    <input type="submit" value="Back To List" class="loginButton" size="30" >
		</form>
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

<%@ page contentType="text/html;charset=gb2312"%> 
<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%>
<%@ taglib uri="/tags/struts-html-el" prefix="html" %>
<%@ taglib uri="/tags/struts-logic-el" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>

<script language="JavaScript1.3">

function backform(){

}
</script>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html:html locale="true">
  <head>
    
    <title>ParQry.jsp</title>
    
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
  </head>
  
  <body>
    <html:form action="/Usersub.do" method="post" focus="desc">
		<table border="0" width="100%" cellspacing="0" cellpadding="0" height="100">
			<tr>
				<td width="10%"></td>
				<td width="30%" height="26"><font size="2">
				公司名(描述)</font></td>
				<td width="40%" height="26"><font face="Arial" size="2">
				<html:text property="desc" size="13" maxlength="255"/>
				</font></td>
				<td width="20%"></td>
			</tr>
			<tr>
				<td width="100"></td>
				<td width="50" height="26"><font size="2">
				姓名</font></td>
				<td width="171" height="26"><font face="Arial" size="2">
				<html:text property="name" size="13" maxlength="255"/>
				</font></td>
				<td width="271"></td>
			</tr>
			<tr>
				<td width="100"></td>
				<td width="50" height="26"><font face="Arial" size="2">
				备注</font></td>
				<td width="171" height="26"><font face="Arial" size="2">
				<html:text property="note" size="13" maxlength="255"/>
				</font></td>
				<td width="271"></td>
			</tr>
			<tr>
				<td width="100"></td>
				<td width="50" height="28"></td>
				<td width="171" height="28">
					<input type="submit" value="查询"> 
					<input type="reset" value="取消">
				</td>
				<td width="271"></td>
			</tr>
		</table>
    	<%String stype=request.getParameter("type");%>
    	<%
			  if (request.getParameter("type")==null){
			  	stype="";
			  	}
			  else{
			  	stype=request.getParameter("type").trim();
			  }
    	%>
    	<%if (stype!=""){%>
	    	<html:hidden property="type"  value="1"/>
	    <%}else{%>
	    	<html:hidden property="type"  value=""/>
	    <%}%>		
    </html:form>
  </body>
</html:html>

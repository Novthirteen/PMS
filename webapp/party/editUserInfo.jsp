<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<app:checkLogon/>

<tiles:insert page="/layouts/aof_layout_one.jsp" flush="true">
	  <tiles:put name="title"	value="Internal System" />
	  <tiles:put name="SysEnv"	value="/includes/layout_one/SysEnv.jsp" />
	    <%
      String overduePwd=(String)request.getAttribute("overduePwd");
      	if(overduePwd!=null&& overduePwd.length()>0){%>
	  <tiles:put name="AppBar"	value="/includes/layout_one/AppBar2.jsp" />
	  <%}else{%>
	   <tiles:put name="AppBar"	value="/includes/layout_one/AppBar.jsp" />
	   <%}%>
	  <tiles:put name="NavBar"	value="/includes/layout_one/NavBar.jsp" />
	  <tiles:put name="Menu"	value="/includes/layout_one/Menu.jsp" />
	  <tiles:put name="Body"	value="/party/editUserInfoBody.jsp" />
	  <tiles:put name="Footer"	value="/includes/layout_one/Footer.jsp" />
</tiles:insert>
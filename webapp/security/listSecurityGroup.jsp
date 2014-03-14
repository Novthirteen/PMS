<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<html:html>
<body bgcolor="white">

<html:errors/>

<html:form action="/editSecurityGroup">
<table border="0" width="100%">
  <tr>
    <th align="right">
	  权限组编码:
    </th>
    <td align="left">
      <html:text property="groupId" size="50"/>
    </td>
  </tr>

  <tr>
    <th align="right">
      权限组功能描述:
    </th>
    <td align="left">
      <html:text property="description" size="50"/>
    </td>
  </tr>

  <tr>
    <td align="right">
      <html:submit>
        确定
      </html:submit>
    </td>
    <td align="left">
      <html:reset>
        重置
      </html:reset>
    </td>
  </tr>

</table>
</html:form>
</html:html>

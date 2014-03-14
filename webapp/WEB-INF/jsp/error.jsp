<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.StringWriter"%>
<%@ page import="java.io.PrintWriter"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<br/>
<table border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
<tr>
  <td width='100%'>
    <table width='100%' border='0' cellspacing='0' cellpadding='0'>
    <tr>
      <td align=left width='90%' class="wpsPortletTopTitle">
        <bean:message key="error.page.title"/>
      </td>
    </tr>
    </table>
  </td>
</tr>
<tr>
  <td width='100%'>
    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>
        <logic:present name="X_exception">
          <pre>
<%
	StringWriter sw = new StringWriter();
	Exception ex = (Exception)request.getAttribute("X_exception");
	ex.printStackTrace(new PrintWriter(sw));
	out.print(sw.getBuffer().toString());
%>
          </pre>
        </logic:present>
        <logic:notPresent name="X_exception"><span class="tabletext"><html:errors/></span></logic:notPresent>
      </td>
    </tr>
  </td>
</tr>
</table>
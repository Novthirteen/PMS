<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.StringWriter"%>
<%@ page import="java.io.PrintWriter"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<table border=0 width='100%' height='100%' cellspacing='0' cellpadding='0'>
<tr><td colspan="2" height="3"><img src="images/spacer.gif" width="1" height="3"/></td></tr>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' height='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="error.page.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor='#deebeb' valign="top">
	    <div style="margin:5px"></div>
	    <table width='100%' border='0' cellpadding='0' cellspacing='10'>
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
	    <tr>
	      <td align="center">
	        <input type="button" value="<bean:message key="button.ok"/>" onclick="window.parent.close();"/>
	      </td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' height='4'>
	    <table width='100%' height='4' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="bottom" align="left" bgcolor="#deebeb"><img src="images/cornerLB.gif" width="4" height="4" border="0"></td>
	      <td bgcolor="#deebeb"><img src="images/spacer.gif" width="1" height="1"/></td>
	      <td width="8" valign="bottom" align="right" bgcolor="#deebeb"><img src="images/cornerRB.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	</table>
  </td>
</tr>
<tr><td colspan="2" height="3"><img src="images/spacer.gif" width="1" height="3"/></td></tr>
</table>
<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/app.tld" prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<html:javascript formName="requestTypeForm"/>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='285' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.call.requesttype.edit.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor='#deebeb'>
	    <html:form action="helpdesk.updateRequestType.do" method="post" onsubmit="return validateRequestTypeForm(this);">
	    <html:hidden property="id"/>
	    <div style="margin:5px">
	      <input type="submit" value="<bean:message key="button.save"/>"/>
	      <input type="reset" value="<bean:message key="button.reset"/>"/>
	      <input type="button" value="<bean:message key="button.cancel"/>" onclick="window.parent.close();"/>
	    </div>
	    <table border='0' cellpadding='0' cellspacing='2' style="margin:5px">
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.call.requesttype.calltype.label"/>:</td>
	      <td>&nbsp;<bean:write name="X_CallType"/><html:hidden property="callType_type"/></td>
	    </tr>
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.call.requesttype.description.label"/>:</td>
	      <td>&nbsp;<html:text property="description" maxlength="127" size="25"/></td>
	    </tr>
		<tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.call.requesttype.disabled.label"/>:</td>
	      <td><html:checkbox property="disabled" style="border-style:none;background-Color:transparent;"/></td>
	      </tr>
	    </table>
	 	</html:form>
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
</table>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
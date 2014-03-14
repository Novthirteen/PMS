<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<html:javascript formName="slaCategoryForm"/>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='485' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.category.edit.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor='#deebeb'>
	    <html:form action="helpdesk.updateSLACategory.do" method="post" onsubmit="return validateSlaCategoryForm(this);">
	    <html:hidden property="id"/>
	    <div style="margin:5px">
	      <input type="submit" value="<bean:message key="button.save"/>"/>
	      <input type="reset" value="<bean:message key="button.reset"/>"/>
	      <input type="button" value="<bean:message key="button.cancel"/>" onclick="window.parent.close();"/>
	    </div>
	    <table border='0' cellpadding='0' cellspacing='2' style="margin:5px">
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.category.code.label"/>:</td>
	      <td><bean:write name="slaCategoryForm" property="id"/></td>
	    </tr>
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.category.chsDesc.label"/>:</td>
	      <td><html:text property="chsDesc" maxlength="127" size="30"/></td>
	    </tr>
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.category.engDesc.label"/>:</td>
	      <td><html:text property="engDesc" maxlength="127" size="30"/></td>
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
	<tr><td height="5"><img src="images/spacer.gif" width="1" height="1"/></td></tr>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.master.modifylog.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor="#deebeb">
	    <table width='100%' border='0' cellspacing='0' cellpadding='0' style="margin:5px">
	    <tr>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.modifylog.createdate.label"/>:</span>
	        <bean:write name="slaCategoryForm" property="modifyLog_createDate"/>
	      </td>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.modifylog.createuser.label"/>:</span>
	        <bean:write name="slaCategoryForm" property="modifyLog_createUser_name"/>
	      </td>
	    </tr>
	    <tr>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.modifylog.modifydate.label"/>:</span>
	        <bean:write name="slaCategoryForm" property="modifyLog_modifyDate"/>
	      </td>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.modifylog.modifyuser.label"/>:</span>
	        <bean:write name="slaCategoryForm" property="modifyLog_modifyUser_name"/>
	      <td>
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
</table>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>

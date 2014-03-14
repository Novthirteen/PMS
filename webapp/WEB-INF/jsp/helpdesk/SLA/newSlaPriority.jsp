<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<html:javascript formName="slaPriorityForm"/>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='585' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.priority.new.title"/> - <bean:write name="X_categoryDesc"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor='#deebeb'>
	    <html:form action="helpdesk.insertSLAPriority.do" method="post" onsubmit="return validateSlaPriorityForm(this);">
	    <html:hidden property="category_id"/>
	    <div style="margin:5px">
	      <input type="submit" value="<bean:message key="button.save"/>"/>
	      <input type="reset" value="<bean:message key="button.reset"/>"/>
	      <input type="button" value="<bean:message key="button.cancel"/>" onclick="window.parent.close();"/>
	    </div>
	    <table border='0' cellpadding='0' cellspacing='2' style="margin:5px">
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.priority.chsDesc.label"/>:</td>
	      <td><html:text property="chsDesc" maxlength="127" size="20"/></td>
	      <td width='10'></td>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.priority.engDesc.label"/>:</td>
	      <td><html:text property="engDesc" maxlength="127" size="20"/></td>
	    </tr>
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.priority.responseWarningTime.label"/>:</td>
	      <td><html:text property="responseWarningTime" maxlength="5" size="20"/></td>   
	      <td width='10'></td>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.priority.responseTime.label"/>:</td>
	      <td><html:text property="responseTime" maxlength="5" size="20"/></td>   
	    </tr>
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.priority.solveWarningTime.label"/>:</td>
	      <td><html:text property="solveWarningTime" maxlength="5" size="20"/></td>
	      <td width='10'></td>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.priority.solveTime.label"/>:</td>
	      <td><html:text property="solveTime" maxlength="5" size="20"/></td>
	    </tr>
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.priority.closeWarningTime.label"/>:</td>
	      <td><html:text property="closeWarningTime" maxlength="5" size="20"/></td> 
	      <td width='10'></td>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.servicelevel.priority.closeTime.label"/>:</td>
	      <td><html:text property="closeTime" maxlength="5" size="20"/></td> 
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
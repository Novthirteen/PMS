<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<html:javascript formName="slaMasterForm"/>
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
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.master.edit.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor='#deebeb'>
	    <html:form action="helpdesk.updateSLAMaster.do" method="post" onsubmit="return validateSlaMasterForm(this);">
	    <html:hidden property="id"/>
	    <div style="margin:5px">
	      <input type="submit" value="<bean:message key="button.save"/>"/>
	      <input type="reset" value="<bean:message key="button.reset"/>"/>
	    </div>
	    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
	    <tr>
	      <td class="labeltext" align="right" width='100'><bean:message key="helpdesk.servicelevel.master.code.label"/>:</td>
	      <td><bean:write name="slaMasterForm" property="id"/></td>
	    </tr>
	    <tr>
	      <td class="labeltext" align="right" width='100'><bean:message key="helpdesk.servicelevel.master.desc.label"/>:</td>
	      <td><html:text property="desc" maxlength="127" size="30"/></td>
	    </tr>
	    <tr>
	      <td class="labeltext" align="right" width='100'><bean:message key="helpdesk.servicelevel.master.active.label"/>:</td>
	      <td>
	        <html:select property="active">
	          <html:option value="Y" key="helpdesk.servicelevel.master.active.choice.yes"/>
	          <html:option value="N" key="helpdesk.servicelevel.master.active.choice.no"/>
	        </html:select>
	      </td>
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
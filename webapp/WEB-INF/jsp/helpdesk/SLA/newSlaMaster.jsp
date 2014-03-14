<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/app.tld" prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<script language="javascript">
	function chooseCustomer() {
		with (document.slaMasterForm) {
	    	var v = window.showModalDialog("helpdesk.EnterQuery.do?style=1&tab=1", null, 'dialogWidth:428px;dialogHeight:597px;status:no;help:no;scroll:no');
	    	if (v != null) {
	    		party_name.value=v["party"]["description"];
				party_partyId.value=v["party"]["partyid"];
		    }
		}
	}
	
	function clearCustomer() {
		with (document.slaMasterForm) {
			party_name.value="<bean:message key="helpdesk.servicelevel.master.customer.choice.default"/>";
			party_partyId.value="";
		}
	}
</script>
<html:javascript formName="slaMasterForm"/>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='100%' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.master.new.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor='#deebeb'>
	    <html:form action="helpdesk.insertSLAMaster.do" method="post" onsubmit="return validateSlaMasterForm(this);">
	    <div style="margin:5px">
	      <input type="submit" value="<bean:message key="button.save"/>"/>
	      <input type="reset" value="<bean:message key="button.reset"/>"/>
	    </div>
	    <table width='100%' border='0' cellpadding='0' cellspacing='2'>
	    <tr>
	      <td class="labeltext" align="right" width='100'><bean:message key="helpdesk.servicelevel.master.customer.label"/>:</td>
	      <td>
	        <input type="text" name="party_name" size="30" value="<bean:message key="helpdesk.servicelevel.master.customer.choice.default"/>" readonly/>
	        <input type="button" value="<bean:message key="helpdesk.servicelevel.master.selectbutton.title"/>" onclick="chooseCustomer();"/>
	        <input type="button" value="<bean:message key="helpdesk.servicelevel.master.clearbutton.title"/>" onclick="clearCustomer();"/>
	        <html:hidden property="party_partyId"/>
	      </td>
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
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
</tr>
</table>
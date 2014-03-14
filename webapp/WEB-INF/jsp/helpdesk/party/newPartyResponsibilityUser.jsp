<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/app.tld" prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<html:javascript formName="partyResponsibilityUserForm"/>
<script langauge="javascript">
	function selectParty() {
		with (document.partyResponsibilityUserForm) {
	    	v = window.showModalDialog(
	    		"helpdesk.EnterQuery.do?type=1",
	    		 null,
	    		 'dialogWidth:428px;dialogHeight:597px;status:no;help:no;scroll:no'
	    	);
	    	
	    	if (v != null) {
	    		party.innerText = v["party"]["description"];
				party_partyId.value = v["party"]["partyid"];
				if (v["user"]["name"] != "") {
		    		user.innerText = v["user"]["name"];
					user_userLoginId.value = v["user"]["user_login_id"];
				}
		    }
		}
	}
	
	function selectUser() {
		with (document.partyResponsibilityUserForm) {
	    	v = window.showModalDialog(
	    		"helpdesk.EnterQuery.do?type=1",
	    		 null,
	    		 'dialogWidth:428px;dialogHeight:597px;status:no;help:no;scroll:no'
	    	);
	    	
	    	if (v != null) {
	    		user.innerText = v["user"]["name"];
				user_userLoginId.value = v["user"]["user_login_id"];
			}
		}
	}
</script>
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
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.partyresponsibilityuser.new.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor='#deebeb'>
	    <html:form action="helpdesk.insertPartyResponsibilityUser.do" method="post" onsubmit="return validatePartyResponsibilityUserForm(this);">
	    <div style="margin:5px">
	      <input type="submit" value="<bean:message key="button.save"/>"/>
	      <input type="reset" value="<bean:message key="button.reset"/>"/>
	      <input type="button" value="<bean:message key="button.cancel"/>" onclick="window.parent.close();"/>
	    </div>
	    <table border='0' cellpadding='0' cellspacing='2' style="margin:5px">
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.partyresponsibilityuser.party.label"/>:</td>
	      <td>
	        <span id="party"></span>
	        <img align="absmiddle" src="images/select.gif" alt="<bean:message key="helpdesk.partyresponsibilityuser.button.select"/>"  onclick="selectParty();">
	        <html:hidden property="party_partyId"/>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.partyresponsibilityuser.user.label"/>:</td>
	      <td>
	        <span id="user"></span>
	        <img align="absmiddle" src="images/select.gif" alt="<bean:message key="helpdesk.partyresponsibilityuser.button.select"/>"  onclick="selectUser();">
	        <html:hidden property="user_userLoginId"/>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" align="right"><bean:message key="helpdesk.partyresponsibilityuser.type.label"/>:</td>
	      <td>
       	    <html:select property="type_typeId">
       	      <html:options collection="X_PartyResponsibilityType" property="typeId" labelProperty="description"/>
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
<%@ page language="java" contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page"%>
<script language="javascript">
	function newPartyResponsibilityUser() {
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.partyresponsibilityuser.new.title&helpdesk.newPartyResponsibilityUser.do', null, 'dialogWidth:300px;dialogHeight:164px;status:no;help:no;scroll:no');
		if (v) {
			partyResponsibilityUserQueryForm.submit();
		}
	}

	function deletePartyResponsibilityUser(id) {
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.partyresponsibilityuser.delete.title&helpdesk.confirmDeleteDialog.do?title=helpdesk.partyresponsibilityuser.delete.title&message=helpdesk.partyresponsibilityuser.delete.message&helpdesk.deletePartyResponsibilityUser.do?id=' + id, null, 'dialogWidth:300px;dialogHeight:143px;status:no;help:no;scroll:no');
		if (v) {
			partyResponsibilityUserQueryForm.submit();
		}
	}
</script>
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr height="20">
  <td>
    <html:form method="post" action="helpdesk.listPartyResponsibilityUser.do" >
    <table width='100%' border='0' cellpadding='0' cellspacing='1'>
    <tr>
      <td>
        <bean:message key="helpdesk.partyresponsibilityuser.party.label"/>:
       	<html:text property="party" maxlength="255" size="15"/>
        <bean:message key="helpdesk.partyresponsibilityuser.user.label"/>:
       	<html:text property="user" maxlength="255" size="15"/>
        <bean:message key="helpdesk.partyresponsibilityuser.type.label"/>:
       	<html:select property="type">
       	  <html:options collection="X_PartyResponsibilityType" property="typeId" labelProperty="description"/>
       	</html:select>
       	<html:submit><bean:message key="button.search"/></html:submit>&nbsp;
       	<input type=button onclick="newPartyResponsibilityUser();" value="<bean:message key="button.add"/>"/>
      </td>
     </tr>
     </table>
     </html:form>
  </td>
</tr>
</table>
<table border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
<tr>
  <td width='100%'>
    <table width='100%' border='0' cellspacing='0' cellpadding='0'>
    <tr>
      <td align=left width='90%' class="topBox"><bean:message key="helpdesk.partyresponsibilityuser.list.title"/></td>
    </tr>
    </table>
  </td>
</tr>
<tr>
  <td width='100%'>
	<table width='100%' border='0' cellpadding='0' cellspacing='1'>
    <tr height="18">
      <td align="left" class="bottomBox"><bean:message key="helpdesk.partyresponsibilityuser.seq.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.partyresponsibilityuser.party.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.partyresponsibilityuser.user.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.partyresponsibilityuser.type.label"/></td> 
      <td align="left" class="bottomBox"><bean:message key="helpdesk.partyresponsibilityuser.action.label"/></td>
    </tr>
    <logic:iterate id="p" name="results">
    <tr>
      <td><bean:write name="partyResponsibilityUserQueryForm" property="pageNextSeq"/></td>
      <td><bean:write name="p" property="party.description"/> (<bean:write name="p" property="party.partyId"/>)</td>
      <td><bean:write name="p" property="user.name"/> (<bean:write name="p" property="user.userLoginId"/>)</td>
      <td><bean:write name="p" property="type.description"/></td>
      <td>
        <a href="javascript:void(0)" onclick="deletePartyResponsibilityUser(<bean:write name="p" property="id"/>); event.returnValue = false;"><bean:message key="helpdesk.partyresponsibilityuser.action.delete.label"/></a>
      </td>
    </tr>
    </logic:iterate>
    <tr class="bottomBox">
      <td colspan="5" >
        <page:form action="helpdesk.listPartyResponsibilityUser.do" method="post">			
        <table width='100%' border='0' cellpadding='0' cellspacing='0'>
        <tr>
          <td class="pageinfobold" align="right">
            <bean:message key="page.total"/>
            <page:pageCount/>
            <logic:greaterThan name="partyResponsibilityUserQueryForm" property="pageCount" value="1"><bean:message key="page.pages"/></logic:greaterThan>
            <logic:lessEqual name="partyResponsibilityUserQueryForm" property="pageCount" value="1"><bean:message key="page.page"/></logic:lessEqual>

            <bean:message key="page.now"/>
            <page:select styleClass="pageinfo" format="page.format" resource="true"/>
            <page:noPrevious><img align="absmiddle" alt="<bean:message key="page.prevpage"/>" src="images/noprev.gif" border=0/></page:noPrevious>
            <page:previous><img align="absmiddle" alt="<bean:message key="page.prevpage"/>" src="images/prev2.gif" border=0/></page:previous>
            <page:next><img align="absmiddle" alt="<bean:message key="page.nextpage"/>" src="images/next2.gif" border=0/></page:next>
            <page:noNext><img align="absmiddle" alt="<bean:message key="page.nextpage"/>" src="images/nonext.gif" border=0/></page:noNext>
          </td>
        </tr>
        </table>
        </page:form>		      
	  </td>
	</tr>
    </table>
  </td>
</tr>
</table>
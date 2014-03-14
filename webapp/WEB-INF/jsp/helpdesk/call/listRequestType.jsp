<%@ page language="java" contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page"%>
<script language="javascript">
	function newRequestType() {
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.call.requesttype.new.title&helpdesk.newRequestType.do?callType=' + requestTypeQueryForm.callType.options[requestTypeQueryForm.callType.selectedIndex].value, null, 'dialogWidth:300px;dialogHeight:168px;status:no;help:no;scroll:no');
		if (v) {
			requestTypeQueryForm.submit();
		}
	}

	function editRequestType(id) {
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.call.requesttype.edit.title&helpdesk.editRequestType.do?id=' + id, null, 'dialogWidth:300px;dialogHeight:163px;status:no;help:no;scroll:no');
		if (v) {
			requestTypeQueryForm.submit();
		}
	}

	function deleteRequestType(id) {
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.call.requesttype.delete.title&helpdesk.confirmDeleteDialog.do?title=helpdesk.call.requesttype.delete.title&message=helpdesk.call.requesttype.delete.message&helpdesk.deleteRequestType.do?id=' + id, null, 'dialogWidth:300px;dialogHeight:143px;status:no;help:no;scroll:no');
		if (v) {
			requestTypeQueryForm.submit();
		}
	}
</script>
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr height="20">
  <td>
    <html:form method="post" action="helpdesk.listRequestType.do" >
    <table width='100%' border='0' cellpadding='0' cellspacing='1'>
    <tr>
      <td>
        <bean:message key="helpdesk.call.requesttype.description.label"/>:
       	<html:text property="description" maxlength="255" size="15"/>
        <bean:message key="helpdesk.call.requesttype.calltype.label"/>:
       	<html:select property="callType">
       	  <html:options collection="X_CallType" property="type" labelProperty="typedesc"/>
       	</html:select>
        <bean:message key="helpdesk.call.requesttype.disabled.label"/>:
       	<html:select property="disabled">
       	  <html:option value=""/>
       	  <html:option value="true"><bean:message key="helpdesk.call.requesttype.disabled.choice.yes.label"/></html:option>
       	  <html:option value="false"><bean:message key="helpdesk.call.requesttype.disabled.choice.no.label"/></html:option>
       	</html:select>
       	<html:submit><bean:message key="button.search"/></html:submit>&nbsp;
       	<input type=button onclick="newRequestType();" value="<bean:message key="button.add"/>"/>
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
      <td align=left width='90%' class="topBox"><bean:message key="helpdesk.call.requesttype.list.title"/></td>
    </tr>
    </table>
  </td>
</tr>
<tr>
  <td width='100%'>
	<table width='100%' border='0' cellpadding='0' cellspacing='1'>
    <tr height="18">
      <td align="left" class="bottomBox"><bean:message key="helpdesk.call.requesttype.seq.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.call.requesttype.calltype.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.call.requesttype.description.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.call.requesttype.disabled.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.call.requesttype.action.label"/></td>
    </tr>
    <logic:iterate id="p" name="results">
    <tr>
      <td><bean:write name="requestTypeQueryForm" property="pageNextSeq"/></td>
      <td><bean:write name="p" property="callType.typedesc"/></td>
      <td><bean:write name="p" property="description"/></td>
      <td>
      	<logic:equal name="p" property="disabled" value="true"><bean:message key="helpdesk.call.requesttype.disabled.choice.yes.label"/></logic:equal>
      	<logic:notEqual name="p" property="disabled" value="true"><bean:message key="helpdesk.call.requesttype.disabled.choice.no.label"/></logic:notEqual>
      </td>
      <td>
        <a href="javascript:void(0)" onclick="editRequestType(<bean:write name="p" property="id"/>); event.returnValue = false;"><bean:message key="helpdesk.call.requesttype.action.edit.label"/></a>
        <a href="javascript:void(0)" onclick="deleteRequestType(<bean:write name="p" property="id"/>); event.returnValue = false;"><bean:message key="helpdesk.call.requesttype.action.delete.label"/></a>
      </td>
    </tr>
    </logic:iterate>
    <tr class="bottomBox">
      <td colspan="5" >
        <page:form action="helpdesk.listRequestType.do" method="post">			
        <table width='100%' border='0' cellpadding='0' cellspacing='0'>
        <tr>
          <td class="pageinfobold" align="right">
            <bean:message key="page.total"/>
            <page:pageCount/>
            <logic:greaterThan name="requestTypeQueryForm" property="pageCount" value="1"><bean:message key="page.pages"/></logic:greaterThan>
            <logic:lessEqual name="requestTypeQueryForm" property="pageCount" value="1"><bean:message key="page.page"/></logic:lessEqual>

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
<%@ page language="java" contentType="text/html; charset=gb2312"%>
<%@ page import="com.shcnc.struts.form.BaseQueryForm"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page"%>
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr height="20">
  <td>
    <html:form method="post" action="helpdesk.listSLAMaster.do" >
    <table width='100%' border='0' cellpadding='0' cellspacing='1'>
    <tr>
      <td>
        <bean:message key="helpdesk.servicelevel.master.search"/>:
       	<html:text property="desc" maxlength="255" size="15"/>
        <bean:message key="helpdesk.servicelevel.master.customer.label"/>:
        <html:text property="customer" maxlength="255" size="15"/>
        <bean:message key="helpdesk.servicelevel.master.active.label"/>:
       	<html:select property="active">
       	  <html:option value=""/>
       	  <html:option value="Y"><bean:message key="helpdesk.servicelevel.master.active.choice.yes"/></html:option>
       	  <html:option value="N"><bean:message key="helpdesk.servicelevel.master.active.choice.no"/></html:option>
       	</html:select>
       	<html:submit><bean:message key="button.search"/></html:submit>&nbsp;
       	<input type=button onclick="window.location.href = 'helpdesk.newSLAMaster.do';" value="<bean:message key="button.add"/>"/>
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
      <td align=left width='90%' class="topBox"><bean:message key="helpdesk.servicelevel.master.list.title"/></td>
    </tr>
    </table>
  </td>
</tr>
<tr>
  <td width='100%'>
	<table width='100%' border='0' cellpadding='0' cellspacing='1'>
    <tr height="18">
      <td align="left" class="bottomBox"><bean:message key="helpdesk.servicelevel.master.seq.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.servicelevel.master.desc.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.servicelevel.master.customer.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.servicelevel.master.active.label"/></td> 
      <td align="left" class="bottomBox"><bean:message key="helpdesk.servicelevel.master.action.label"/></td>
    </tr>
    <logic:iterate id="master" name="X_masters">
    <tr>
      <td><bean:write name="slaMasterQueryForm" property="pageNextSeq"/></td>
      <td><bean:write name="master" property="desc"/></td>
      <td>
        <logic:present name="master" property="party"><bean:write name="master" property="party.description"/></logic:present>
        <logic:notPresent name="master" property="party"><bean:message key="helpdesk.servicelevel.master.customer.choice.default"/></logic:notPresent>
      </td>
      <td>
      	<logic:equal name="master" property="active" value="Y"><bean:message key="helpdesk.servicelevel.master.active.choice.yes"/></logic:equal>
      	<logic:notEqual name="master" property="active" value="Y"><bean:message key="helpdesk.servicelevel.master.active.choice.no"/></logic:notEqual>
      </td>
      <td>
        <a href="helpdesk.viewSLAMaster.do?id=<bean:write name="master" property="id"/>"><bean:message key="helpdesk.servicelevel.master.action.view.label"/></a>
      </td>
    </tr>
    </logic:iterate>
    <tr class="bottomBox">
      <td colspan="5" >
        <page:form action="helpdesk.listSLAMaster.do" method="post">			
        <table width='100%' border='0' cellpadding='0' cellspacing='0'>
        <tr>
          <td class="pageinfobold" align="right">
            <bean:message key="page.total"/>
            <page:pageCount/>
            <logic:greaterThan name="slaMasterQueryForm" property="pageCount" value="1"><bean:message key="page.pages"/></logic:greaterThan>
            <logic:lessEqual name="slaMasterQueryForm" property="pageCount" value="1"><bean:message key="page.page"/></logic:lessEqual>

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
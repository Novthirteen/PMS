<%@ page language="java" contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="http://www.zknic.com/struts/page-taglib" prefix="page"%>
<script language="javascript">
	var companyInfoDialog = null;
	function viewCustomer(partyId) {
		sUrl = "helpdesk.listTable.do?company=" + partyId;
		if (companyInfoDialog && !companyInfoDialog.closed)	{
			companyInfoDialog.frames(0).navigate(sUrl);
			companyInfoDialog.focus();
			return;
		}
		sFeature = "status:no;resizable:no;scroll:yes;help:no;dialogWidth:800px;dialogHeight:400px";
		companyInfoDialog = window.showModelessDialog("helpdesk.showDialog.do?title=helpdesk.call.customerinfodialog.title&" + sUrl, null, sFeature);
	}

	function importCustomerUser(partyId) {
		sUrl = "helpdesk.newUploadExcel.do?partyId=" + partyId;
		sFeature = "status:no;resizable:no;scroll:yes;help:no;dialogWidth:340px;dialogHeight:180px";
		window.showModalDialog("helpdesk.showDialog.do?title=helpdesk.customer.import.title&" + sUrl, null, sFeature);
	}
</script>
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr height="20">
  <td>
    <html:form method="post" action="helpdesk.listCustomer.do" >
    <table width='100%' border='0' cellpadding='0' cellspacing='1'>
    <tr>
      <td>
        <bean:message key="helpdesk.customer.search.label"/>:
       	<html:text property="desc" maxlength="255" size="15"/>
       	<html:submit><bean:message key="button.search"/></html:submit>
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
      <td align=left width='90%' class="topBox"><bean:message key="helpdesk.customer.list.title"/></td>
    </tr>
    </table>
  </td>
</tr>
<tr>
  <td width='100%'>
	<table width='100%' border='0' cellpadding='0' cellspacing='1'>
    <tr height="18">
      <td align="left" class="bottomBox"><bean:message key="helpdesk.customer.seq.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.customer.description.label"/></td>
      <td align="left" class="bottomBox"><bean:message key="helpdesk.customer.action.label"/></td>
    </tr>
    <logic:iterate id="p" name="results">
    <tr>
      <td><bean:write name="customerQueryForm" property="pageNextSeq"/></td>
      <td><bean:write name="p" property="description"/> (<bean:write name="p" property="partyId"/>)</td>
      <td>
        <a href="javascript:void(0)" onclick="viewCustomer('<%=java.net.URLEncoder.encode(((com.aof.component.domain.party.Party)p).getPartyId())%>'); event.returnValue = false;"><bean:message key="helpdesk.customer.action.view.label"/></a>
        <a href="javascript:void(0)" onclick="importCustomerUser('<%=java.net.URLEncoder.encode(((com.aof.component.domain.party.Party)p).getPartyId())%>'); event.returnValue = false;"><bean:message key="helpdesk.customer.action.import.label"/></a>
      </td>
    </tr>
    </logic:iterate>
    <tr class="bottomBox">
      <td colspan="5" >
        <page:form action="helpdesk.listCustomer.do" method="post">			
        <table width='100%' border='0' cellpadding='0' cellspacing='0'>
        <tr>
          <td class="pageinfobold" align="right">
            <bean:message key="page.total"/>
            <page:pageCount/>
            <logic:greaterThan name="customerQueryForm" property="pageCount" value="1"><bean:message key="page.pages"/></logic:greaterThan>
            <logic:lessEqual name="customerQueryForm" property="pageCount" value="1"><bean:message key="page.page"/></logic:lessEqual>

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
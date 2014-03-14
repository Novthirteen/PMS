<%@ page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<html:javascript formName="kbForm"/>
<script language="javascript">
	function showCategoryTreeDialog() {
    	with(document.kbForm) {
	    	v = window.showModalDialog(
	    		"helpdesk.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&helpdesk.showSLACategoryTreeDialog.do?" +
	    		"partyid=" + customer_partyId.value +
	    		"&activeid=" + category_id.value,
	    		 null,
	    		 'dialogWidth:310px;dialogHeight:335px;status:no;help:no;scroll:no'
	    	);
	    	if (v != null) {
				category_id.value = v[0];
	    		category_pathdesc.innerText = v[1];
		    }
		}
	}
	
	function showChooseCustomerDialog() {	
		with(document.kbForm) {
	    	v = window.showModalDialog(
	    		"helpdesk.EnterQuery.do?style=1&tab=1",
	    		 null,
	    		 'dialogWidth:428px;dialogHeight:597px;status:no;help:no;scroll:no'
	    	);
	    	if (v != null) {
	    		if(customer_partyId.value != v["party"]["partyid"]) {
	    			category_id.value = '';
	    			category_pathdesc.innerText = '';
	    		}
				customer_partyId.value=v["party"]["partyid"];
				customer_description.innerText = v["party"]["description"];
		    }
		}
	}
</script>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='100%' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
	  <td height='20'>
	    <table border="0" height='20' cellpadding="0" cellspacing="0" width="100%">
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.kb.new.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
		</tr>
		</table>
	  </td>
	</tr>
	<tr>
	  <td bgcolor="#deebeb">
	    <html:form action="helpdesk.insertKnowledgeBase.do" method="post" focus="keyword" onsubmit="return validateKbForm(this);">
	  	<html:hidden property="problemAttachGroupId"/>
	  	<html:hidden property="solutionAttachGroupId"/>
	    <div style='margin:5px'>
	      <html:submit titleKey="button.save"><bean:message key="button.save"/></html:submit>
	      <html:reset titleKey="button.reset"><bean:message key="button.reset"/></html:reset>
	      <input type="button" value="<bean:message key="button.cancel"/>" onclick="window.location.href = 'helpdesk.listKnowledgeBase.do';"/>
	    </div>
	    <table border="0" cellpadding="0" cellspacing="2" width="100%">
	    <tr>
	      <td class="labeltext" width="120"><bean:message key="helpdesk.kb.published.label"/>:</td>
	      <td>
	        <html:select property="published">
	          <html:option value="true" key="helpdesk.kb.published.choice.yes"/>
	          <html:option value="false" key="helpdesk.kb.published.choice.no"/>
	        </html:select>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" width="120"><bean:message key="helpdesk.kb.customer.label"/>:</td>
	      <td>
	        <html:hidden property="customer_partyId"/>
	        <span id="customer_description"></span>
	        <img align="absmiddle" style="cursor:hand" src="images/select.gif" border="0" alt="<bean:message key="helpdesk.kb.selectbutton.title"/>" onclick="showChooseCustomerDialog();"/>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" width="120"><bean:message key="helpdesk.kb.category.label"/>:</td>
	      <td>
	        <html:hidden property="category_id"/>
	        <span id="category_pathdesc"></span>
	        <img align="absmiddle" style="cursor:hand" src="images/select.gif" border="0" alt="<bean:message key="helpdesk.kb.selectbutton.title"/>" onclick="showCategoryTreeDialog();"/>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" width="120"><bean:message key="helpdesk.kb.subject.label"/>:</td>
	      <td><html:text property="subject" size="80"/></td>
	    </tr>
	    </table>
	    <table border="0" cellpadding="0" cellspacing="3" width="100%">
	    <tr>
	      <td class="labeltext"><bean:message key="helpdesk.kb.problemdesc.label"/>:</td>
	    </tr>
	    <tr>
	      <td style="padding-left:20px;">
	        <html:textarea property="problemDesc" cols="150" rows="10"/>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext"><bean:message key="helpdesk.kb.solution.label"/>:</td>
	    </tr>
	    <tr>
	      <td style="padding-left:20px;">
	        <html:textarea property="solution" cols="150" rows="10"/>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext"><bean:message key="helpdesk.kb.problemattachmentlist.label"/>:</td>
	    </tr>
	    <tr>
	      <td style="padding-left:20px;">
	        <iframe frameborder="0" width="700" src="helpdesk.listAttachment.do?groupid=<bean:write name="kbForm" property="problemAttachGroupId"/>"></iframe>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext"><bean:message key="helpdesk.kb.solutionattachmentlist.label"/>:</td>
	    </tr>
	    <tr>
	      <td style="padding-left:20px;">
	        <iframe frameborder="0" width="700" src="helpdesk.listAttachment.do?groupid=<bean:write name="kbForm" property="solutionAttachGroupId"/>"></iframe>
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
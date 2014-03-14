<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<script language="javascript">
	function deleteKnowledgeBase() {
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.kb.delete.title&helpdesk.confirmDeleteDialog.do?title=helpdesk.kb.delete.title&message=helpdesk.kb.delete.message&helpdesk.deleteKnowledgeBase.do?id=<bean:write name="X_kb" property="id"/>', null, 'dialogWidth:300px;dialogHeight:143px;status:no;help:no;scroll:no');
		if (v == null) return;
		window.location.href = "helpdesk.listKnowledgeBase.do";
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
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.kb.show.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
		</tr>
		</table>
	  </td>
	</tr>
	<tr>
	  <td bgcolor="#deebeb">
	    <div style='margin:5px'>
	      <input type="button" value="<bean:message key="button.edit"/>" onclick="window.location.href = 'helpdesk.editKnowledgeBase.do?id=<bean:write name="X_kb" property="id"/>';"/>
	      <input type="button" value="<bean:message key="button.delete"/>" onclick="deleteKnowledgeBase();"/>
	      <input type="button" value="<bean:message key="helpdesk.kb.button.backtolist"/>" onclick="window.location.href = 'helpdesk.listKnowledgeBase.do';"/>
	    </div>
	    <table border="0" cellpadding="0" cellspacing="3" width="100%">
	    <tr>
	      <td class="labeltext" width="120"><bean:message key="helpdesk.kb.id.label"/>:</td>
	      <td><bean:write name="X_kb" property="id"/></td>
	      <td class="labeltext" width="100"><bean:message key="helpdesk.kb.published.label"/>:</td>
	      <td>
	        <logic:equal name="X_kb" property="published" value="true"><bean:message key="helpdesk.kb.published.choice.yes"/></logic:equal>
	        <logic:notEqual name="X_kb" property="published" value="true"><bean:message key="helpdesk.kb.published.choice.no"/></logic:notEqual>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" width="100"><bean:message key="helpdesk.kb.customer.label"/>:</td>
	      <td colspan="3">
	        <logic:present name="X_kb" property="customer"><bean:write name="X_kb" property="customer.description"/></logic:present>
	        <logic:notPresent name="X_kb" property="customer"><bean:message key="helpdesk.kb.customer.choice.default"/></logic:notPresent>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" width="100"><bean:message key="helpdesk.kb.category.label"/>:</td>
	      <td colspan="3"><bean:write name="X_categoryPathDesc"/></td>
	    </tr>
	    <tr><td colspan="4" height="1" bgcolor="black"><img src="images/spacer.gif" width="1" height="1"/></td></tr>
	    </table>
	    <table border="0" cellpadding="0" cellspacing="3" width="100%">
	    <tr>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.kb.subject.label"/>:</span>
	        <bean:write name="X_kb" property="subject"/>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext"><bean:message key="helpdesk.kb.problemdesc.label"/>:</td>
	    </tr>
	    <tr>
	      <td>
	        <pre style="margin-left:20px; margin-right:20px; padding:5px; background-Color:#EEF3FA"><bean:write name="X_kb" property="problemDesc"/></pre>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" colspan="2"><bean:message key="helpdesk.kb.solution.label"/>:</td>
	    </tr>
	    <tr>
	      <td>
	        <pre style="margin-left:20px; margin-right:20px; padding:5px; background-Color:#EEF3FA"><bean:write name="X_kb" property="solution"/></pre>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" colspan="2"><bean:message key="helpdesk.kb.problemattachmentlist.label"/>:</td>
	    </tr>
	    <tr>
	      <td style="padding-left:20px;">
	        <iframe frameborder="0" width="700" src="helpdesk.listAttachment.do?readonly=true&groupid=<bean:write name="X_kb" property="problemAttachGroupId"/>"></iframe>
	      </td>
	    </tr>
	    <tr>
	      <td class="labeltext" colspan="2"><bean:message key="helpdesk.kb.solutionattachmentlist.label"/>:</td>
	    </tr>
	    <tr>
	      <td style="padding-left:20px;">
	        <iframe frameborder="0" width="700" src="helpdesk.listAttachment.do?readonly=true&groupid=<bean:write name="X_kb" property="solutionAttachGroupId"/>"></iframe>
	      </td>
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
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
</tr>
</table>
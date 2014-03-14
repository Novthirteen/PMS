<%@page contentType="text/html;charset=gb2312" language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="/tags/jstl-core" prefix="c" %>
<script>
	function add()
	{
		v = window.showModalDialog(
    		"helpdesk.showDialog.do?title=helpdesk.attachment.upload.title&helpdesk.newAttachment.do?"+
    		"groupid="+	"<c:out value='${param.groupid}'/>",
    		 null,
    		 'dialogWidth:340px;dialogHeight:180px;status:no;help:no;scroll:no'
    	);
    	window.location.href=window.location.href;
	}
</script>
<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#DEEBEB">
<tr height=12>
  <td class="labeltext" nowrap width=15%><bean:message key="helpdesk.attachment.list.title" />&nbsp;</td>
  <td class="labeltext" nowrap width=15%><bean:message key="helpdesk.attachment.list.file" />&nbsp;</td>
  <td class="labeltext" nowrap width=7%><bean:message key="helpdesk.attachment.list.size" />&nbsp;</td>
  <td class="labeltext" nowrap width=8%><bean:message key="helpdesk.attachment.list.createUser" />&nbsp;</td>
  <td class="labeltext" nowrap width=7%><bean:message key="helpdesk.attachment.list.createDate" />&nbsp;</td>
  <c:if test="${empty(param.readonly)}"><td class="labeltext" nowrap width=6%><bean:message key="helpdesk.attachment.list.action" />&nbsp;</td></c:if>
</tr>
<logic:iterate id="attach" name="attachList">
<tr>
  <td><bean:write name="attach" property="title" /></td>
  <td>
	<a target="_black" href="helpdesk.viewAttachment.do?id=<c:out value='${attach.id}'/>"><bean:write name="attach" property="name" /></a>
  </td>
  <td><c:out value="${attach.size div 1000}" />k</td>
  <td><bean:write name="attach" property="createUser.name" /></td>
  <td><bean:write name="attach" property="createDate" format="yyyy-MM-dd" /></td>
  <c:if test="${empty(param.readonly)}"><td><a onClick="return confirm('<bean:message key="helpdesk.attachment.deleteConfirm" />');" href="helpdesk.deleteAttachment.do?id=<c:out value='${attach.id}'/>&groupid=<c:out value='${param.groupid}'/>" ><bean:message key="helpdesk.attachment.list.delete" /></a></td></c:if>
  <!--<html:link action="/deleteAttachment" paramId="id" paramName="attach" paramProperty="id">delete</html:link>-->
</tr>
</logic:iterate>
<tr height="5">
  <td colspan=6>&nbsp;</td>
</tr>
<tr>
  <td colspan="6">
    <c:if test="${empty(param.readonly)}"><input type="button" value="<bean:message key="helpdesk.attachment.add" />" onclick="add()" style="width:30px"/></c:if>
    <!--<input type="button" value="undelete"  />-->
  </td>
</tr>
</table>
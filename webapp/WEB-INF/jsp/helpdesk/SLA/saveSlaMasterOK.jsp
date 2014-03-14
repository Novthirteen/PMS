<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<bean:define id="active" name="X_master" property="active"/>
<script language='javascript'>
    var result = new Array();
    result['desc'] = '<bean:write name="X_master" property="desc"/>';
    <logic:equal name="active" value="Y">result['active'] = '<bean:message key="helpdesk.servicelevel.master.active.choice.yes"/>';</logic:equal>
    <logic:notEqual name="active" value="Y">result['active'] = '<bean:message key="helpdesk.servicelevel.master.active.choice.no"/>';</logic:notEqual>
    result['modifyUser'] = '';
    result['modifyDate'] = '';
    <logic:present name="X_master" property="modifyLog">
    result['modifyUser'] = '<bean:write name="X_master" property="modifyLog.modifyUser.name"/>';
    result['modifyDate'] = '<bean:write name="X_master" property="modifyLog.modifyDate" format="yyyy-MM-dd HH:mm"/>';
    </logic:present>
    window.parent.returnValue = result;
    window.parent.close();
</script>
<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<script language='javascript'>
    var result = new Array();
    result['id'] = '<bean:write name="X_priority" property="id"/>';
    result['categoryid'] = '<bean:write name="X_priority" property="category.id"/>';
    result['categoryDesc'] = '<bean:write name="X_priority" property="category.desc"/>';
    result['desc'] = '<bean:write name="X_priority" property="desc"/>';
    result['responseTime'] = '<bean:write name="X_priority" property="responseTime"/>';
    result['solveTime'] = '<bean:write name="X_priority" property="solveTime"/>';
    result['closeTime'] = '<bean:write name="X_priority" property="closeTime"/>';
    result['responseWarningTime'] = '<bean:write name="X_priority" property="responseWarningTime"/>';
    result['solveWarningTime'] = '<bean:write name="X_priority" property="solveWarningTime"/>';
    result['closeWarningTime'] = '<bean:write name="X_priority" property="closeWarningTime"/>';
    result['createUser'] = '';
    result['createDate'] = '';
    result['modifyUser'] = '';
    result['modifyDate'] = '';
    <logic:present name="X_priority" property="modifyLog">
    <logic:present name="X_priority" property="modifyLog.createUser">
    result['createUser'] = '<bean:write name="X_priority" property="modifyLog.createUser.userLoginId"/>';
    </logic:present>
    <logic:present name="X_priority" property="modifyLog.modifyUser">
    result['modifyUser'] = '<bean:write name="X_priority" property="modifyLog.modifyUser.userLoginId"/>';
    </logic:present>
    result['createDate'] = '<bean:write name="X_priority" property="modifyLog.createDate"/>';
    result['modifyDate'] = '<bean:write name="X_priority" property="modifyLog.modifyDate"/>';
    </logic:present>
    window.parent.returnValue = result;
    window.parent.close();
</script>
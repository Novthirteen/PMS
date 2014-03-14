<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<script language='javascript'>
    var result = new Array();
    result['id'] = '<bean:write name="X_category" property="id"/>';
    result['parentId'] = null;
    <logic:present name="X_category" property="parentId">
    result['parentId'] = '<bean:write name="X_category" property="parentId"/>';
    </logic:present>
    result['desc'] = '<bean:write name="X_category" property="desc"/>';
    result['createUser'] = '';
    result['createDate'] = '';
    result['modifyUser'] = '';
    result['modifyDate'] = '';
    <logic:present name="X_category" property="modifyLog">
    <logic:present name="X_category" property="createUser">
    result['createUser'] = '<bean:write name="X_category" property="modifyLog.createUser.userLoginId"/>';
    </logic:present>
    result['createDate'] = '<bean:write name="X_category" property="modifyLog.createDate"/>';
    <logic:present name="X_category" property="modifyUser">
    result['modifyUser'] = '<bean:write name="X_category" property="modifyLog.modifyUser.userLoginId"/>';
    </logic:present>
    result['modifyDate'] = '<bean:write name="X_category" property="modifyLog.modifyDate"/>';
    </logic:present>
    window.parent.returnValue = result;
    window.parent.close();
</script>
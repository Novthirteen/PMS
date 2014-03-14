<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=gb2312"%>
<%-- Set all pages that include this page (particularly tiles) to use XHTML --%>
<!--<app:checkLogon/>-->
<HTML>
<HEAD>
<meta http-equiv="Page-Enter" content="blendTrans(Duration=0.2)">
<meta http-equiv="Page-Exit" content="blendTrans(Duration=0.2)">
<title><tiles:getAsString name="title"/></title>
<script language='javascript' src='<%=request.getContextPath()%>/includes/layout_one/js/calendar.js' type='text/javascript'></script>
<script language='javascript' src='<%=request.getContextPath()%>/includes/layout_one/js/Cookie.js' type='text/javascript'></script>
<script language='javascript' src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunctions.js' type='text/javascript'></script>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/screen.css" rel=stylesheet type=text/css>
</head>
<BODY bgColor=#ffffff leftMargin=0 topMargin=10 marginheight="10" marginwidth="0" >
<!-- ϵͳ���������� -->
<tiles:insert attribute="AppBar" />
<table cellSpacing="0" cellPadding="0" width="100%" border="0">
  <tbody>
    <tr>
      <td width="150" bgColor=""><img height="10"  src="<%=request.getContextPath()%>/images/spacer.gif" width="150"></td>
    </tr>
  </tbody>
</table>
<!-- ϵͳ��������ʾ����,�����Ϊ������,��ߵĲ���������ʾϵͳ3���Ӳ˵�.�ұߵĲ�����ʾ�����ϵͳ����ҳ�� -->
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
  <TBODY>
  <TR>
  <!-- ��ʼ�ұ߲��ֵ���ʵ -->
    <TD vAlign=top width="100%">
    <!-- ϵͳ�������� -->
      <TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
      <!--Ԥ���ռ�-->
        <TBODY></TBODY>
      </TABLE>
	<!-- ϵͳλ�õ����� -->
	<tiles:insert attribute="Body" />
  <!-- �����ұ߲��ֵ���ʵ -->
  </TR>
  </TBODY>
</TABLE>
<br>
<!-- ϵͳ�ײ������� --> 
<tiles:insert attribute="Footer" />
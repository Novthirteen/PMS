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
<!-- 系统顶级导航栏 -->
<tiles:insert attribute="AppBar" />
<table cellSpacing="0" cellPadding="0" width="100%" border="0">
  <tbody>
    <tr>
      <td width="150" bgColor=""><img height="10"  src="<%=request.getContextPath()%>/images/spacer.gif" width="150"></td>
    </tr>
  </tbody>
</table>
<!-- 系统主内容显示区域,被拆分为两部分,左边的部分用来显示系统3级子菜单.右边的部分显示具体的系统功能页面 -->
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
  <TBODY>
  <TR>
  <!-- 开始右边部分的现实 -->
    <TD vAlign=top width="100%">
    <!-- 系统内容区域 -->
      <TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
      <!--预留空间-->
        <TBODY></TBODY>
      </TABLE>
	<!-- 系统位置导航栏 -->
	<tiles:insert attribute="Body" />
  <!-- 结束右边部分的现实 -->
  </TR>
  </TBODY>
</TABLE>
<br>
<!-- 系统底部导航栏 --> 
<tiles:insert attribute="Footer" />
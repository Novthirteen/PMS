<%@ page language="java" errorPage="/error/Error.jsp" %>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page contentType="text/html; charset=gb2312"%>
<%-- Set all pages that include this page (particularly tiles) to use XHTML --%>
<app:checkLogon/>
<HTML>
<HEAD>
<title><tiles:getAsString name="title"/></title>
<script language='javascript' src='<%=request.getContextPath()%>/includes/layout_one/js/calendar.js' type='text/javascript'></script>
<script language='javascript' src='<%=request.getContextPath()%>/includes/layout_one/js/Order.js' type='text/javascript'></script>
<script language='javascript' src='<%=request.getContextPath()%>/includes/layout_one/js/Cookie.js' type='text/javascript'></script>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
</head>
<BODY bgColor=#ffffff leftMargin=0 topMargin=10 marginheight="10" marginwidth="0" >

<!-- 系统主内容显示区域,被拆分为两部分,左边的部分用来显示系统3级子菜单.右边的部分显示具体的系统功能页面 -->
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100%>
  <TBODY>
  <TR>

  <!-- 开始右边部分的现实 -->
    <TD vAlign=top width="100%">
    <!-- 系统内容区域 -->
	      
      <TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
      <!--预留空间 -->
        <TBODY></TBODY>
      </TABLE>
	
	<!-- 系统位置导航栏 -->
	<tiles:insert attribute="Body" />

  <!-- 结束右边部分的现实 -->
  </TR>
  </TBODY>
</TABLE>
<br>

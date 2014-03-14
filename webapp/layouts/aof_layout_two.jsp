<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ page contentType="text/html; charset=gb2312"%>
<HTML>
<HEAD>
<title><tiles:getAsString name="title"/></title>
<META content=no-cache http-equiv=Pragma>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/styles.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
</head>

<BODY bgColor=#ffffff leftMargin=0 topMargin=10 marginheight="10" marginwidth="0" onLoad="writeMenus()" onResize="if (isNS4) nsResizeHandler()">

<!-- 系统顶级导航栏 -->
<tiles:insert attribute="SysEnv" />
<!-- 开始系统主导航栏 -->
<tiles:insert attribute="AppBar" />


<!-- 系统位置导航栏 -->
<tiles:insert attribute="NavBar" />


<table cellSpacing="0" cellPadding="0" width="100%" border="0">
  <tbody>
    <tr>
      <td width="150" bgColor="#cc0000"><img height="10"  src="images/spacer.gif" width="150"></td>
    </tr>
  </tbody>
</table>

<!-- 系统主内容显示区域,被拆分为两部分,左边的部分用来显示系统3级子菜单.右边的部分显示具体的系统功能页面 -->
<TABLE border=0 cellPadding=0 cellSpacing=0 width=750>
  <TBODY>
  <TR>

  <!-- 开始左边部分的现实 --><!-- 系统子菜单内容区域开始 -->
  <tiles:insert attribute="Menu" />
  <!-- 系统子菜单内容区域结束 --><!-- 结束左边部分的现实 -->
  

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

<!-- 系统底部导航栏 --> 
<tiles:insert attribute="Footer" />
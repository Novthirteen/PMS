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

<!-- ϵͳ���������� -->
<tiles:insert attribute="SysEnv" />
<!-- ��ʼϵͳ�������� -->
<tiles:insert attribute="AppBar" />


<!-- ϵͳλ�õ����� -->
<tiles:insert attribute="NavBar" />


<table cellSpacing="0" cellPadding="0" width="100%" border="0">
  <tbody>
    <tr>
      <td width="150" bgColor="#cc0000"><img height="10"  src="images/spacer.gif" width="150"></td>
    </tr>
  </tbody>
</table>

<!-- ϵͳ��������ʾ����,�����Ϊ������,��ߵĲ���������ʾϵͳ3���Ӳ˵�.�ұߵĲ�����ʾ�����ϵͳ����ҳ�� -->
<TABLE border=0 cellPadding=0 cellSpacing=0 width=750>
  <TBODY>
  <TR>

  <!-- ��ʼ��߲��ֵ���ʵ --><!-- ϵͳ�Ӳ˵���������ʼ -->
  <tiles:insert attribute="Menu" />
  <!-- ϵͳ�Ӳ˵������������ --><!-- ������߲��ֵ���ʵ -->
  

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

<!-- ϵͳ�ײ������� --> 
<tiles:insert attribute="Footer" />
<%@ page language="java" contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
  response.setHeader("Pragma","No-cache");
  response.setHeader("Cache-Control","no-cache");
  response.setDateHeader("Expires", 0);
%>
<html>
<head>
<title><bean:message name="X_title"/></title>
<link href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<link href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<script type="text/javascript">
    function setSize() {
        var availableWidth = 0;
        var availableHeight = 0;
        if (document.all) {
            availableWidth = document.body.clientWidth;
            availableHeight = document.body.clientHeight;
        } else {
            availableWidth = innerWidth;
            availableHeight = innerHeight;
        }

        var frameStyle = document.getElementById('dialogFrame').style;
        frameStyle.width = availableWidth;
        frameStyle.height = availableHeight;
    }
</script>
</head>
<body onload="setSize();" bgcolor="lightgrey">
  <table id="splash" style="position:absolute;top:0;left:0;width:100%;height:100%;background-color:#deebeb;">
  <tr><td align="center" class="labeltext"><bean:message key="helpdesk.dialog.waitingmessage"/></span></td></tr>
  <table>
  <iframe id="dialogFrame" src="<%=request.getAttribute("X_realpath")%>" allowtransparency="true" border=0 frameorder=0 hspace=0 vspace=0 marginheight=0 marginwidth=0 topmargin=0 leftmargin=0 style="position:absolute;top:0;left:0;"></iframe> 
</body>
</html>

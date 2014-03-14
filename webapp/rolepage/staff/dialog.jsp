<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.util.Constants"%>
<html>
<head>
<title>Merry Christmas ! ! !</title>
</head>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<div style="position:absolute;left:0px;top:0px"><img src="/webapp/images/01.jpg">
</div>
<div style="position:absolute;left:0px;top:400px"><img src="/webapp/images/19.gif" width="699">
</div>
<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
<embed style="left: 150px; width: 400px; position:
absolute; top: 200px; height: 300px" align=right src="/webapp/images/68.swf"
width=400 height=400 type=application/octet-stream quality="high" wmode="transparent"></embed>
<%UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	%>
<font face="Verdana, Arial, Helvetica, sans-serif" size="4" color="#004CCF">Dear <%=ul.getName()%> ,</font><br><br>
<font face="Verdana, Arial, Helvetica, sans-serif" size="3" color="#004CCF">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sincerely wish you a merry Christmas, <br> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hope Santa brings you everything you want! <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Also Appreciate you for the great support to PAS as always ! <br> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</font>

<font face="Verdana, Arial, Helvetica, sans-serif" size="4" color="#004CCF" align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PAS Develop Team<br></font><br>
<bgsound src="<%=context%>/images/x7.mid" loop="1">
</body>
</html>
<%@ page contentType="text/html; charset=gb2312"%>

<!-- Added by Will begin. 2006-06-26 -->
<%
//String skillFlag = null;
//skillFlag = (String)(request.getSession().getAttribute("skillFlag"));
//if(skillFlag == null || skillFlag.equals("")){
//	skillFlag = "no";
//}
%>

<script language="javascript">
//window.open('/webapp/rolepage/staff/dialog.jsp','','width=699 height=435,resizable=no');
//function onload(flag){
	//if(flag == "no"){
	//	alert("Your skill-set self evaluation have not been completed. Please take your time to complete it!");
	//}
//}
//onload('');
</script>
<!-- Added by Will end. 2006-06-26 -->

<table border="0" width="100%" >
<tr>
<td  colspan =3  align=center ><font size=5> Welcome to PAS System </font></td>
</tr>
<br><br>
<tr></tr>
<tr>
	<td  width=20% align=right>&nbsp;</td>
	<td height=5 width = 60% align=left >
	<ul><li><font size =3 color = red>More categories Added in Expense Entry . </font></ul>	
	<IMG SRC="<%=request.getContextPath()%>/images/newExpense2.jpg" BORDER=1 ALT="">
	</td>
	<td  width=30%>&nbsp;</td>
</tr>
<br>

<!-- Added by Will begin. 2006-06-06 -->
<tr>
	<td  width=20% align=right>&nbsp;</td>
	<td height=5 width = 40% align=left >
    <ul><li><font size =3 color = red>Please click <a href="bookingRoomAction.do?command=preview"><font size =3>here</font></a> to view the meeting room booking. </font></ul>
	</td>
	<td  width=30%>&nbsp;</td>
</tr>
<br>
<!-- Added by Will end. -->


<tr>
	<td  width=20% align=right>&nbsp;</td>
	<td height=5 width = 40% align=left >
    <ul><li><font size =3 color = red>Please click <a href="skillAction.do"><font size =3>here</font></a> to update your skill-set self evaluation.</font></ul>
	</td>
	<td  width=30%>&nbsp;</td>
</tr>
<br>

<!-- Added by Will end. -->

<tr>
	<td  width=20% align=right>&nbsp;</td>
	<td height=5 width = 40% align=left >
    <ul><li><font size =3>Please click <a href="syshelp.do"><font size =3>here</font></a> to view the PAS key functions. </font></ul>
	
	</td>
	<td  width=30%>&nbsp;</td>
</tr>
<br>
<tr>
	<td  width=20% align=right>&nbsp;</td>
	<td height=5 width = 40% align=left >
    <ul><li><font size =3> Issues about Allowance Claiming are updated in the latest version of <a href="syshelp.do"><font size =3>User Manual</font></a></font></ul>.
	
	</td>
	<td  width=30%>&nbsp;</td>
	
</tr>

<tr>
	<td height=10><td>
<tr>
<tr>
	<td  width=20% align=right>&nbsp;</td>
	<td height=5 width = 40% align=left >
    <%@ include file="\WEB-INF\jsp\prm\project\linkFisCalendar.jsp" %>
	</td>
	<td  width=30%>&nbsp;</td>
</tr>
<tr>
	<td height=10><td>
<tr>
</table>
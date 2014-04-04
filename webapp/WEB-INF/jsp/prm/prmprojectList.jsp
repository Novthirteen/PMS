<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld"prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld"prefix="tiles"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<script>
function returnValue() {
	var formObj = document.frm;
	var count;
	count=0;
	if(formObj.chk.length) {
		for(var i=0;i<formObj.chk.length;i++) {
			if(formObj.chk[i].checked) {
				count++;
				window.parent.returnValue = formObj.chk[i].value;
				window.parent.close();
			}
		}
	} else {
		if(formObj.chk.checked) {
			count++;
			window.parent.returnValue = formObj.chk.value;
			window.parent.close();
		}
	}
	if(count==0){
		alert("Choose a option")
		return;
	}
}
function fnSubmit1()
{
//	document.getElementById("pageNumber").value = "";
	document.frm.submit();
}
</script>
<%
if (true|| AOFSECURITY.hasEntityPermission("USER_LOGIN", "_VIEW", session)) {
	String pageNumber=request.getParameter("pageNumber");
	String lStrOpt=request.getParameter("rad");
	String srchproj=request.getParameter("srchproj");
//	if(pageNumber == null ) pageNumber = "";
	if(lStrOpt == null ) lStrOpt = "2";
	if(srchproj == null ) srchproj = "";

	String UserId=request.getParameter("UserId");
	String DataPeriod=request.getParameter("DataPeriod");

	if(UserId == null ) UserId = "";
	if(DataPeriod == null ) DataPeriod = "";
%>
<title>Project Selection</title>
<form action="PRMProjectList.do?UserId=<%=UserId%>&DataPeriod=<%=DataPeriod%>" name=frm method="POST">
<input type="hidden" name="UserId" id="UserId" value="<%=UserId%>">
<input type="hidden" name="DataPeriod" id="DataPeriod" value="<%=DataPeriod%>">
<!--
<input type="hidden" name="pageNumber" id="pageNumber" value="<%=pageNumber%>">
-->
<input type="hidden" name="FormAction" id="FormAction">
<table width=100% align=center >
	<CAPTION align=center class=pgheadsmall><bean:message key="prm.timesheet.projectSelect.title"/></CAPTION>
	<tr><td align='center' colspan=5>
<A HREF="#A">A</A>&nbsp;
<A HREF="#B">B</A>&nbsp;
<A HREF="#C">C</A>&nbsp;
<A HREF="#D">D</A>&nbsp;
<A HREF="#E">E</A>&nbsp;
<A HREF="#F">F</A>&nbsp;
<A HREF="#G">G</A>&nbsp;
<A HREF="#H">H</A>&nbsp;
<A HREF="#I">I</A>&nbsp;
<A HREF="#J">J</A>&nbsp;
<A HREF="#K">K</A>&nbsp;
<A HREF="#L">L</A>&nbsp;
<A HREF="#M">M</A>&nbsp;
<A HREF="#N">N</A>&nbsp;
<A HREF="#O">O</A>&nbsp;
<A HREF="#P">P</A>&nbsp;
<A HREF="#Q">Q</A>&nbsp;
<A HREF="#R">R</A>&nbsp;
<A HREF="#S">S</A>&nbsp;
<A HREF="#T">T</A>&nbsp;
<A HREF="#U">U</A>&nbsp;
<A HREF="#V">V</A>&nbsp;
<A HREF="#W">W</A>&nbsp;
<A HREF="#X">X</A>&nbsp;
<A HREF="#Y">Y</A>&nbsp;
<A HREF="#Z">Z</A>
	</td></tr>
	<tr><td colspan=5><hr colour="red"></td></tr>
</table>

<table width=100%  >
	<tr bgcolor="e9eee9">
		<td class=lblbold width=10>
			&nbsp;					
		</td>
		<td class=lblbold  width=40>Customer Name</td>
		<td class=lblbold width=35>Project Name</td>
		<td class=lblbold width=15>Project Code</td>
	</tr>
</table>

<table align="center" table width=100%  Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
<tr><td>
<div style="word-break : break-all;width:460px;height:240px;overflow:auto;">
<table  align="center" >
	<%
	
	List list = (List)request.getAttribute("resultList");
	if(list == null)
		list = new LinkedList();
	String pre = " ";
	for(int i=0;i<list.size();i++)
	{
		ProjectMaster pm = (ProjectMaster)list.get(i);
	if(!(pm.getCustomer().getDescription().startsWith(pre.toLowerCase())||pm.getCustomer().getDescription().startsWith(pre.toUpperCase())))
		{
			pre = pm.getCustomer().getDescription().substring(0,1);
		%>
		<tr><td>&nbsp;</td><td><a name="<%=pre%>"><%=pre%></a></td><td>&nbsp;</td><td>&nbsp;</td></tr>
		<%
		}
		%>
	<tr >
		<td  width="6%"><input type=radio name=chk value="<%=pm.getProjId()%>|<%=pm.getProjName()%>|<%=pm.getExpenseNote()%>">&nbsp;</td>
		<td  width="35%" ><%=pm.getCustomer().getDescription()%></td>
		<td  width="2%" ></td>
		<td  width="25%"><%=pm.getProjName()%>&nbsp;&nbsp;&nbsp;</td>
		<td  width="20%"><%=pm.getProjId()%></td>
	</tr>
		
		<%
	}
	%>
</table>
</div>		
</td></tr>
</table>
<table >
	<tr rowspan =1><td>&nbsp;</td></tr>
	<tr>
		<td class=lblbold colspan=6>
			&nbsp;					
		</td>
		<td colspan=4 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:returnValue()">&nbsp;&nbsp;
			&nbsp;&nbsp;<input type=button name="close" class=button value="Cancel" onclick="javascript:window.parent.close()">
		</td>
	</tr>		
	<tr>
			<td class=lblbold colspan=4>
			&nbsp;					
		</td>
      <td colspan=4>
         <table align=center border=0 cellspacing=1 cellpadding=5  rules=none>
         <tr>
          <td class=LblBold>Search for</td>
          <td><input type=text name=srchproj size=15 maxlength=20 value='<%=srchproj%>'></td>
          <td><input type=button class=button name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
         <tr>
          <td class=LblBold>Exact</td>
          <td colspan=2>
            <input type=radio name='rad' value='1'<%if (lStrOpt.equals("1")) {%> checked<%}%>>&nbsp;Yes&nbsp;&nbsp;&nbsp;
            <input type=radio name=rad value='2' <%if (lStrOpt.equals("2")) {%> checked<%}%>>&nbsp;No
          </td>
         </tr>
         </table>
      </td>
   </tr>
</table>
</form> 
<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>

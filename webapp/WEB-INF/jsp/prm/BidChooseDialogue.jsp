<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
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

function fnContinue()
{
var arr;
	var formObj = document.frm;
	var count;
	count=0;
	if(formObj.chk.length) {
		for(var i=0;i<formObj.chk.length;i++) {
			if(formObj.chk[i].checked) {
				count++;
				arr = formObj.chk[i].value.split("|");
			}
		}
	} else {
		if(formObj.chk.checked) {
			count++;
			arr = formObj.chk.value.split("|");
		}
	}
	if(count==0){
		alert("Choose a option")
		return;
	}
location.replace('ProjectChooseDialogue.do?bid='+parseInt(arr[0])+'&bno='+arr[1]+'&bname='+arr[2]);
}

function showProjectDialog()
{
	var code,desc;
	var cid,cdesc;
	var depid,depname;
	with(document.frm1)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&BidChooseDialogue.do?",
			null,
			'dialogWidth:900px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			cid = v.split("|")[2];
			cdesc = v.split("|")[3];
			depid = v.split("|")[4];
			depname = v.split("|")[5];
			labelProject.innerHTML=code+":"+desc;
			labelCustomer.innerHTML = cid+":"+cdesc;
			labelDepartment.innerHTML = depname;
			proj_id.value=code;
			proj_desc.value = desc;
			cust_id.value = cid;
			cust_desc.value = cdesc;
			dep_id.value = depid;
			dep_name.value = depname;
		}
	}
}

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
<form action="BidChooseDialogue.do?UserId=<%=UserId%>&DataPeriod=<%=DataPeriod%>" name=frm method="POST">
<input type="hidden" name="UserId" value="<%=UserId%>">
<input type="hidden" name="DataPeriod" value="<%=DataPeriod%>">
<input type="hidden" name="FormAction">
<input type="hidden" name="bid" value="<%=(String)request.getAttribute("bid")%>">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Bid Select</CAPTION>
	<tr><td align='center' colspan=5>
	</td></tr>
	<tr><td colspan=5><hr ></td></tr>
	<tbody>
	<tr bgcolor="e9eee9">
		<td class=lblbold align="center" width="52%" nowrap bgcolor="#4BEEE9">Customer Name</td>
		<td class=lblbold align="left" width="12%" nowrap>Department</td>
		<td class=lblbold align="left" width="22%" nowrap>Bid Name</td>
		<td class=lblbold align="left" width="15%" nowrap>Bid Code</td>	
	</tr>
	</tbody>
	<tbody align="center">
	<tr><td>
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
	</tbody>
</table>
<table align="center" width=100%  Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
<tr><td>
<div style="word-break : break-all;width:900px;height:340px;overflow:auto;">
<table width=100% align="center">
	<%
		SQLResults sr = (SQLResults)request.getAttribute("result");
	String pre = " ";
	for(int i=0;i<sr.getRowCount();i++)
	{
		String id = sr.getString(i,"id");
		String bid = sr.getString(i,"bid");
		String desc = sr.getString(i,"description");
		String cust_id = sr.getString(i,"cust_id");
		String custdesc = sr.getString(i,"cust_desc");

		String dep_id = sr.getString(i,"dep_id");
		String dep_name = sr.getString(i,"dep_desc");
		if(!(custdesc.startsWith(pre.toLowerCase())||(custdesc.startsWith(pre.toUpperCase()))))
		{
			pre = custdesc.substring(0,1).toUpperCase();
		%>
		<tr><td>&nbsp;</td><td><a name="<%=pre%>"><%=pre%></a></td><td>&nbsp;</td></tr>
		<%
		}%>
		<tr class="listbody">
		<td width="5%"><input type=radio name=chk style="border:0px;background-color:#ffffff" value="<%=id%>|<%=bid%>|<%=desc%>|<%=cust_id%>|<%=custdesc%>|<%=dep_id%>|<%=dep_name%>">&nbsp;</td>
		<td width="50%"><%=custdesc%></td>
		<td width="10%" align="left"><%=dep_name%></td>
		<td width="25%">&nbsp;&nbsp;<%=desc%>&nbsp;&nbsp;</td>
		<td width="10%" ><%=bid%></td>
	</tr>
	<%}%>
</table>
</div>		
</td></tr>
</table>
<table align="center">
	<tr ><td>&nbsp;</td></tr>
	<tr>
		<td class=lblbold colspan=6>
			&nbsp;					
		</td>
		<td colspan=4 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:fnContinue();">&nbsp;&nbsp;
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
}else{
	out.println("!!你没有相关访问权限!!");
}
%>

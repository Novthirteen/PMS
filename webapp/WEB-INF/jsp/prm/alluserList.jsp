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
<%
	String pageName = (String)request.getAttribute("pageName");
	if (pageName != null && pageName.equals("FindPRMPage")) {
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/findPRMPage.js'></script>
<% } else { %>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/projectCostMaintain.js'></script>
<% } %>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<script>
function onSelect_staff(i) {
	var formObj = document.forms["UserListForm"];
	var j = i;
	if (document.all.staffId.length) {
		var staffId = document.all.staffId[j].innerText;
		var staffName = document.all.staffName[j].innerText;	
		var partyId = document.all.SelPartyId[j].value;
		var partyName = document.all.partyName[j].innerText;
		var emailAddr = document.UserListForm.emailAddr[j].value;
	} else {
		var staffId = document.all.staffId.innerText;
		var staffName = document.all.staffName.innerText;	
		var partyId = document.all.SelPartyId.value;
		var partyName = document.all.partyName.innerText;
		var emailAddr = document.UserListForm.emailAddr.value;
	}

	formObj.elements["hiddenStaffCode"].value = staffId;
	formObj.elements["hiddenStaffName"].value = staffName;
	formObj.elements["hiddenPartyCode"].value = partyId;
	formObj.elements["hiddenPartyName"].value = partyName;
	formObj.elements["hiddenEmailAddr"].value = emailAddr;
}
function fnSubmit1()
{
	var formObj = document.forms["UserListForm"];
//	formObj.elements["pageNumber"].value = "";
	formObj.submit();
}
function returnValue() {
	window.parent.returnValue = document.UserListForm.hiddenStaffCode.value
	             + "|" + document.UserListForm.hiddenStaffName.value
	             + "|" + document.UserListForm.hiddenPartyCode.value
	             + "|" + document.UserListForm.hiddenPartyName.value
	             + "|" + document.UserListForm.hiddenEmailAddr.value;
	window.parent.close();
}
</script>
<%
if (true|| AOFSECURITY.hasEntityPermission("USER_LOGIN", "_VIEW", session)) {
	String partyId=request.getParameter("partyId");
	String lStrOpt=request.getParameter("rad");
	String srchStaff=request.getParameter("srchStaff");
	String srchDep=request.getParameter("srchDep");
	String pageNumber=request.getParameter("pageNumber");

	if(partyId == null ) partyId = "";
	if(lStrOpt == null ) lStrOpt = "2";
	if(srchStaff == null ) srchStaff = "";
	if(srchDep == null ) srchDep = "";
	if(pageNumber == null ) pageNumber = "";
%>
<html:form action="/userList.do" method="POST" >
<title>Staff Selection</title>
<input type="hidden" name="CALLBACKNAME">
<input type="hidden" name="hiddenStaffName">
<input type="hidden" name="hiddenStaffCode">
<input type="hidden" name="hiddenPartyCode">
<input type="hidden" name="hiddenPartyName">
<input type="hidden" name="hiddenEmailAddr">
<input type="hidden" name="openType" value="<%=request.getParameter("openType") != null ? request.getParameter("openType") : ""%>">
<input type="hidden" name="FormAction">
<input type="hidden" name="partyId" value="<%=partyId%>">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Staff Select</CAPTION>
	<tr><td align='center' colspan =4>
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
	<tr><td colspan =4><hr colour="red"></td></tr>
	<tr bgcolor="e9eee9">
		<td class=lblbold width=6>
			&nbsp;					
		</td>
		<td class=lblbold width=40 nowrap>Staff Name</td>
		<td class=lblbold width=10 nowrap>Staff ID</td>
		<td class=lblbold>Party Name</td>
	</tr>
</table>
<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
<tr><td>
<div style="word-break : break-all;width:470px;height:220px;overflow:auto;">
<table width=100% align=center>
	<%
	List list = (List)request.getAttribute("resultList");
	if(list==null)
		list = new LinkedList();
	String pre = " ";
	for(int i=0;i<list.size();i++)
	{
	UserLogin ul = (UserLogin)list.get(i);
	if(!(ul.getName().startsWith(pre.toLowerCase())||ul.getName().startsWith(pre.toUpperCase())))
		{
			pre = ul.getName().substring(0,1);
		%>
		<tr><td>&nbsp;</td><td><a name="<%=pre%>"><%=pre%></a></td><td>&nbsp;</td><td>&nbsp;</td></tr>
		<%
		}
	String strFunction = "onSelect_staff(" + i + ");";
	%>
		<tr>
		<td><input type="radio" value="<%=i%>" onclick="<%= strFunction %>" name="tt">
		</td>
		<td><label id="staffName"><%=ul.getName()%>&nbsp;</label></td>
		<td><label id="staffId"><%=ul.getUserLoginId()%></label></td>
		<td><input type="hidden" name="SelPartyId" value = "<%= ul.getParty().getPartyId()%>">
			<input type="hidden" name="emailAddr" value = "<%= ul.getEmail_addr().trim()%>">
			<label id="partyName"><%=ul.getParty().getDescription()%></label></td>
		</tr>	
	<%}
	%>
	</table>
	</div>		
</td></tr>
</table>
	<table>
	<tr>
	<td>&nbsp;</td>
		<td colspan=4 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:<%="showModalDialog".equals(request.getParameter("openType")) ? "returnValue();" : "fnSave_staff();" %>">&nbsp;&nbsp;
			&nbsp;&nbsp;<input type=button name="close" class=button value="Cancel" onclick="javascript:window.parent.close();">
		</td>
	</tr>
	<tr>
      <td colspan=4>
         <table align=center border=0 cellspacing=1 cellpadding=5  rules=none>
         <tr>
          <td class=LblBold>Search for Staff</td>
          <td><input type=text name=srchStaff size=15 maxlength=20 value='<%=srchStaff%>'></td>
          <td><input type=button class=button name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
		 <tr>
          <td class=LblBold>Search for Department</td>
          <td><input type=text name=srchDep size=15 maxlength=20 value='<%=srchDep%>'></td>
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
</html:form> 
<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>

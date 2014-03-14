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
	} else {
		var staffId = document.all.staffId.innerText;
		var staffName = document.all.staffName.innerText;	
		var partyId = document.all.SelPartyId.value;
		var partyName = document.all.partyName.innerText;
	}

	formObj.elements["hiddenStaffCode"].value = staffId;
	formObj.elements["hiddenStaffName"].value = staffName;
	formObj.elements["hiddenPartyCode"].value = partyId;
	formObj.elements["hiddenPartyName"].value = partyName;
}
function fnSubmit1()
{
	var formObj = document.forms["UserListForm"];
	formObj.elements["pageNumber"].value = "";
	formObj.submit();
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
<html:form action="/PRMUserList.do" method="POST">
<title>Staff Selection</title>
<input type="hidden" name="CALLBACKNAME">
<input type="hidden" name="hiddenStaffName">
<input type="hidden" name="hiddenStaffCode">
<input type="hidden" name="hiddenPartyCode">
<input type="hidden" name="hiddenPartyName">
<input type="hidden" name="pageNumber" value="<%=pageNumber%>">

<input type="hidden" name="FormAction">
<input type="hidden" name="partyId" value="<%=partyId%>">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Staff Select</CAPTION>
</table>
<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
	<tr bgcolor="e9eee9">
		<td class=lblbold>
			&nbsp;					
		</td>
		<td class=lblbold>Staff ID</td>
		<td class=lblbold>Staff Name</td>
		<td class=lblbold>Party Name</td>
	</tr>
		<bean:define id="offset" name="UserPageBean" property="offset" />
		<bean:define id="maxPage" name="UserPageBean"  property="maxPage" />		
		<logic:iterate id="ItemList"  name="UserPageBean" property="itemList" indexId="index" length="<%=maxPage.toString()%>" offset="<%=offset.toString()%>">								
			<tr class="listbody">
				<td><% String strFunction = "onSelect_staff(" + index.toString() + ");"; %>
					<html:radio property="selectRadio" value="<%= index.toString()%>" onclick="<%= strFunction %>"/></td>
				<td><label id="staffId"><bean:write property="userLoginId" name="ItemList"/></label></td>
				<td><label id="staffName"><bean:write property="name" name="ItemList"/></label></td>
				<td><input type="hidden" name="SelPartyId" value = "<%= ((UserLogin) ItemList).getParty().getPartyId()%>"><label id="partyName"><%=((UserLogin) ItemList).getParty().getDescription()%></label></td>
			</tr>
		</logic:iterate>
	<tr>
		<td colspan=4 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:fnSave_staff()">&nbsp;&nbsp;
			&nbsp;&nbsp;<input type=button name="close" class=button value="Cancel" onclick="javascript:window.parent.close();">
		</td>
	</tr>
	<tr>
		<td colspan=4 align=center>
		<bean:define id="totalPage" name="UserPageBean" property="allPage" />
		Total Pages: <%=totalPage %> &nbsp;&nbsp;
		<logic:iterate id="PageNumberList"  name="PageNumberList" >
			<logic:equal name="PageNumberList" property="pageLink" value="0">
				<bean:write name="PageNumberList" property="pageNumber" />
			</logic:equal>					
			<logic:notEqual name="PageNumberList" property="pageLink" value="0">
				<html:link page="/PRMUserList.do" paramId="pageNumber" paramName="PageNumberList" paramProperty="pageLink">
					<bean:write name="PageNumberList" property="pageNumber" />
				</html:link >
			</logic:notEqual>
			&nbsp
		</logic:iterate>
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
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
	document.getElementById("pageNumber").value = "";
	document.frm.submit();
}
</script>
<%
if (true|| AOFSECURITY.hasEntityPermission("USER_LOGIN", "_VIEW", session)) {
	String pageNumber=request.getParameter("pageNumber");
	String lStrOpt=request.getParameter("rad");
	String srchproj=request.getParameter("srchproj");
	if(pageNumber == null ) pageNumber = "";
	if(lStrOpt == null ) lStrOpt = "2";
	if(srchproj == null ) srchproj = "";

	String UserId=request.getParameter("UserId");
	String DataPeriod=request.getParameter("DataPeriod");

	if(UserId == null ) UserId = "";
	if(DataPeriod == null ) DataPeriod = "";
%>
<title>Project Selection</title>
<form action="POProjectList.do?UserId=<%=UserId%>&DataPeriod=<%=DataPeriod%>" name=frm method="POST">
<input type="hidden" name="UserId" value="<%=UserId%>">
<input type="hidden" name="DataPeriod" value="<%=DataPeriod%>">
<input type="hidden" name="pageNumber" value="<%=pageNumber%>">

<input type="hidden" name="FormAction">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall><bean:message key="prm.timesheet.projectSelect.title"/></CAPTION>
</table>
<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
	<tr bgcolor="e9eee9">
		<td class=lblbold>
			&nbsp;					
		</td>
		<td class=lblbold>Project Code</td>
		<td class=lblbold>Project Name</td>
		<td class=lblbold>Customer Name</td>
	</tr>
	<bean:define id="offset" name="ProjectPageBean" property="offset" />
	<bean:define id="maxPage" name="ProjectPageBean"  property="maxPage" />		
	<logic:iterate id="projectList"  name="ProjectPageBean" property="itemList" indexId="index" length="<%=maxPage.toString()%>" offset="<%=offset.toString()%>">								
	<tr class="listbody">
		<td><input type=radio name=chk value="<bean:write property="projId" name="projectList"/>|<bean:write property="projName" name="projectList"/>|<bean:write property="vendorId" name="projectList"/>|<bean:write property="vendorName" name="projectList"/>"></td>
		<td><bean:write property="projId" name="projectList"/></td>
		<td><bean:write property="projName" name="projectList"/></td>
		<td><bean:write property="customer.description" name="projectList"/></td>
	</tr>
	</logic:iterate>
	<tr>
		<td colspan=4 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:returnValue()">&nbsp;&nbsp;
			&nbsp;&nbsp;<input type=button name="close" class=button value="Cancel" onclick="javascript:window.parent.close()">
		</td>
	</tr>		
	<tr>
		<td colspan=4 align=center>
		<bean:define id="totalPage" name="ProjectPageBean" property="allPage" />
		Total Pages: <%=totalPage %> &nbsp;&nbsp;		
		<logic:iterate id="PageNumberList"  name="PageNumberList" >
			<logic:equal name="PageNumberList" property="pageLink" value="0">
				<bean:write name="PageNumberList" property="pageNumber" />
			</logic:equal>					
			<logic:notEqual name="PageNumberList" property="pageLink" value="0">
				<a href="POProjectList.do?UserId=<%=UserId%>&DataPeriod=<%=DataPeriod%>&pageNumber=<bean:write name="PageNumberList" property="pageLink"/>"><bean:write name="PageNumberList" property="pageNumber" /></a>
			</logic:notEqual>
			&nbsp
		</logic:iterate>
		</td>
	</tr>
	<tr>
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
	out.println("!!��û����ط���Ȩ��!!");
}
%>

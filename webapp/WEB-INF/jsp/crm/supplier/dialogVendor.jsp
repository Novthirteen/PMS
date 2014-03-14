<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="com.aof.component.crm.vendor.*"%>
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
	var formObj = document.frm;
	formObj.elements["pageNumber"].value = "";
	formObj.submit();
}
</script>
<%
if (true|| AOFSECURITY.hasEntityPermission("USER_LOGIN", "_VIEW", session)) {
	//String SrcIndustry = request.getParameter("SrcIndustry");
	//String SrcAccount = request.getParameter("SrcAccount");
	String SrcVendor = request.getParameter("SrcVendor");
	
	//if (SrcIndustry == null) SrcIndustry ="";
	//if (SrcAccount == null) SrcAccount ="";
	if (SrcVendor == null) SrcVendor ="";

	String pageNumber=request.getParameter("pageNumber");
	if(pageNumber == null ) pageNumber = "";
%>
<form action="crm.dialogVendorList.do" method="POST" name=frm>
<title>Customer Selection</title>
<input type="hidden" name="pageNumber" value="<%=pageNumber%>">
<input type="hidden" name="FormAction">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Supplier Select</CAPTION>
</table>
<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
	<tr bgcolor="e9eee9">
		<td class=lblbold>
			&nbsp;					
		</td>
		<td class=lblbold>Supplier ID</td>
		<td class=lblbold>Supplier Name</td>
		<td class=lblbold>Supplier Category</td>
	</tr>
		<bean:define id="offset" name="UserPageBean" property="offset" />
		<bean:define id="maxPage" name="UserPageBean"  property="maxPage" />		
		<logic:iterate id="ItemList"  name="UserPageBean" property="itemList" indexId="index" length="<%=maxPage.toString()%>" offset="<%=offset.toString()%>">								
			<tr class="listbody">
				<td>
					<input type=radio name=chk value="<bean:write property="partyId" name="ItemList"/>|<bean:write property="description" name="ItemList"/>">
				</td>
				<td><bean:write property="partyId" name="ItemList"/></td>
				<td><bean:write property="description" name="ItemList"/></td>
				<td><%=((VendorProfile) ItemList).getCategoryType().getDescription()%></td>
			</tr>
		</logic:iterate>
	<tr>
		<td colspan=4 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:returnValue()">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<%
				if (AOFSECURITY.hasEntityPermission("PROJ_VENDOR", "_CREATE", session)) {
			%>
			<input type=button name="new" class=button value="New" onclick="javascript:location.replace('editVendorParty.do?openType=dialogView')">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<%
				}
			%>
			<input type=button name="close" class=button value="Cancel" onclick="javascript:window.parent.close()">
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
				<html:link page="/crm.dialogVendorList.do" paramId="pageNumber" paramName="PageNumberList" paramProperty="pageLink">
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
          <td class=LblBold>Search for Supplier Name</td>
          <td><input type=text name=SrcVendor size=15 maxlength=20 value='<%=SrcVendor%>'></td>
          <td><input type=button class=button name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
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

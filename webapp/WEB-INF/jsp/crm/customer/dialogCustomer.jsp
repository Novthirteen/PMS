<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.crm.customer.*"%>
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
<%
	String bidId = request.getParameter("bidId");
	if(bidId ==null) bidId = "";
%>
function returnValue() {
	var formObj = document.frm;
	var count;
	count=0;
	if (formObj.chk != null) {
		if(formObj.chk.length) {
			for(var i=0;i<formObj.chk.length;i++) {
				if(formObj.chk[i].checked) {
					count++;
					window.parent.returnValue = formObj.chk[i].value + "|" + 
												formObj.chineseName[i].value + "|" +
												formObj.city[i].value + "|" +
												formObj.address[i].value + "|" +
												formObj.industry[i].value + "|" +
												formObj.customerGroup[i].value + "|" +
												formObj.postCode[i].value + "|" +
												formObj.teleNo[i].value + "|" +
												formObj.faxNo[i].value + "|" +
												formObj.industryId[i].value + "|" +
												formObj.customerGroupId[i].value;
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
if (true|| AOFSECURITY.hasEntityPermission("CUST_PARTY", "_VIEW", session)) {
	String SrcIndustry = request.getParameter("SrcIndustry");
	String SrcAccount = request.getParameter("SrcAccount");
	String SrcCustomer = request.getParameter("SrcCustomer");
	String SrcInitial = request.getParameter("SrcInitial");
	
	if (SrcIndustry == null) SrcIndustry ="";
	if (SrcAccount == null) SrcAccount ="";
	if (SrcCustomer == null) SrcCustomer ="";
	if (SrcInitial == null) SrcInitial ="";

	String pageNumber=request.getParameter("pageNumber");
	if(pageNumber == null ) pageNumber = "";
%>
<form action="crm.dialogCustomerList.do" method="POST" name=frm>
<title>Customer Selection</title>
<input type="hidden" name="pageNumber" value="<%=pageNumber%>">
<input type="hidden" name="FormAction">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Customer Select</CAPTION>
</table>
<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
	<tr bgcolor="e9eee9">
		<td class=lblbold>
			&nbsp;					
		</td>
		<td class=lblbold>Customer ID</td>
		<td class=lblbold>Customer Name</td>
		<td class=lblbold>Customer Account</td>
	</tr>
		<bean:define id="offset" name="UserPageBean" property="offset" />
		<bean:define id="maxPage" name="UserPageBean"  property="maxPage" />		
		<logic:iterate id="ItemList"  name="UserPageBean" property="itemList" type="com.aof.component.crm.customer.CustomerProfile" indexId="index" length="<%=maxPage.toString()%>" offset="<%=offset.toString()%>">								
			<tr class="listbody">
				<td>
					<input type=radio name=chk value="<bean:write property="partyId" name="ItemList"/>|<bean:write property="description" name="ItemList"/>">
				</td>
				<td><bean:write property="partyId" name="ItemList"/></td>
				<td><bean:write property="description" name="ItemList"/></td>
				<td><%=((CustomerProfile) ItemList).getAccount().getDescription()%></td>
			</tr>
			<input type="hidden" name="chineseName" value="<%=((CustomerProfile) ItemList).getChineseName()%>">
			<input type="hidden" name="city" value="<bean:write name="ItemList" property="city"/>">
			<input type="hidden" name="address" value="<bean:write name="ItemList" property="address"/>">
			<input type="hidden" name="industry" value="<%=((CustomerProfile) ItemList).getIndustry().getDescription()%>">
			<input type="hidden" name="industryId" value="<%=((CustomerProfile) ItemList).getIndustry().getId()%>">
			<input type="hidden" name="customerGroup" value="<%=((CustomerProfile) ItemList).getAccount().getDescription()%>">
			<input type="hidden" name="customerGroupId" value="<%=((CustomerProfile) ItemList).getAccount().getAccountId()%>">
			<input type="hidden" name="postCode" value="<bean:write name="ItemList" property="postCode"/>">
			<input type="hidden" name="teleNo" value="<bean:write name="ItemList" property="teleCode"/>">
			<input type="hidden" name="faxNo" value="<bean:write name="ItemList" property="faxCode"/>">
		</logic:iterate>
	<tr>
		<td colspan=4 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:returnValue()">&nbsp;&nbsp;
			&nbsp;&nbsp;
			<%
				if (AOFSECURITY.hasEntityPermission("CUST_PARTY", "_CREATE", session)) {
			%>
			<!--<input type=button name="new" class=button value="New" onclick="javascript:location.replace('editProspect.do?bidId=<%=bidId%>')">&nbsp;&nbsp;-->
			<input type=button name="new" class=button value="New" onclick="javascript:location.replace('editCustParty.do?openType=dialogView')">&nbsp;&nbsp;
			&nbsp;&nbsp;
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
				<html:link page="/crm.dialogCustomerList.do" paramId="pageNumber" paramName="PageNumberList" paramProperty="pageLink">
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
          <td class=LblBold>Search by initial</td>
          <td>
          	<select name="SrcInitial">
          		<option value="">Select...</option>
          		<%
          			for (byte i0 = 65; i0 <= 90; i0++) {
          				String initial = new String(new byte[] {i0});
          		%>
          			
          				<option value="<%=initial%>" <%=initial.equals(SrcInitial) ? "selected" : ""%>><%=initial%></option>
          		<%
          			}
          		%>
          	</select>
          </td>
          <td><input type=button class=button name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
		 <tr>
         <tr>
          <td class=LblBold>Search for Customer Name</td>
          <td><input type=text name=SrcCustomer size=15 maxlength=20 value='<%=SrcCustomer%>'></td>
          <td><input type=button class=button name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
		 <tr>
          <td class=LblBold>Search for Account</td>
          <td><input type=text name=SrcAccount size=15 maxlength=20 value='<%=SrcAccount%>'></td>
          <td><input type=button class=button name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
		 <tr>
          <td class=LblBold>Search for Industry</td>
          <td><input type=text name=SrcIndustry size=15 maxlength=20 value='<%=SrcIndustry%>'></td>
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

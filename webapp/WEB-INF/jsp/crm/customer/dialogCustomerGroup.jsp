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
					window.parent.returnValue = formObj.chk[i].value ;
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
try{
	String SrcIndustry = request.getParameter("SrcIndustry");
	String SrcAccount = request.getParameter("SrcAccount");
	String SrcCustomer = request.getParameter("SrcCustomer");
	String SrcInitial = request.getParameter("SrcInitial");
	String SrcType = request.getParameter("SrcType");
	
	if (SrcIndustry == null) SrcIndustry ="";
	if (SrcAccount == null) SrcAccount ="";
	if (SrcCustomer == null) SrcCustomer ="";
	if (SrcInitial == null) SrcInitial ="";
	if (SrcType == null) SrcType ="";

	String pageNumber=request.getParameter("pageNumber");
	if(pageNumber == null ) pageNumber = "";
%>
<form action="crm.dialogCustomerGroupList.do" method="POST" name=frm>
<title>Customer Group Selection</title>
<input type="hidden" name="pageNumber" value="<%=pageNumber%>">
<input type="hidden" name="FormAction">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Customer Group Selection</CAPTION>
</table>
<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
	<tr bgcolor="e9eee9">
		<td class=lblbold>
			&nbsp;					
		</td>
		<td class=lblbold>Description</td>
		<td class=lblbold>Abbreviation</td>
		<td class=lblbold>Type</td>
	</tr>
		<bean:define id="offset" name="UserPageBean" property="offset" />
		<bean:define id="maxPage" name="UserPageBean"  property="maxPage" />		
		<logic:iterate id="ItemList"  name="UserPageBean" property="itemList" type="com.aof.component.crm.customer.CustomerAccount" indexId="index" length="<%=maxPage.toString()%>" offset="<%=offset.toString()%>">								
			<tr class="listbody">
				<td>
					<input type=radio name=chk value="<bean:write property="accountId" name="ItemList"/>|<bean:write property="description" name="ItemList"/>">
				</td>
				<td><bean:write property="description" name="ItemList"/></td>
				<td><bean:write property="abbreviation" name="ItemList"/></td>
				<td><%=((CustomerAccount) ItemList).getType().equals("L") ? "Local" : "Global"%></td>
			</tr>
		</logic:iterate>
	<tr>
		<td colspan=4 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:returnValue()">&nbsp;&nbsp;
			&nbsp;&nbsp;
 			<input type="button" class=button value="Create New Group" class="loginButton" onclick="location.replace('editCustomerGroup.do?openType=dialogView')">
			&nbsp;&nbsp;
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
				<html:link page="/crm.dialogCustomerGroupList.do" paramId="pageNumber" paramName="PageNumberList" paramProperty="pageLink">
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
          <td class=LblBold>Search for Customer Group Description</td>
          <td><input type=text name=SrcCustomer size=15 maxlength=20 value='<%=SrcCustomer%>'></td>
          <td><input type=button class=button name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
         	
         <tr>
          <td class=LblBold>Search By Type</td>
        <!--  <td><input type=text name=SrcIndustry size=15 maxlength=20 value='<%=SrcIndustry%>'></td>-->
          <td>
          	<select name="SrcType">
          		<option value="" <%=SrcType.equals("") ? "selected" : ""%>>ALL</option>
          		<option value="C" <%=SrcType.equals("L") ? "selected" : ""%>>Local</option>
          		<option value="P" <%=SrcType.equals("G") ? "selected" : ""%>>Global</option>
          	</select>
          </td>
          <td><input type=button class=button name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
         </table>
      </td>
   </tr>
</table>
</form> 
<%
	Hibernate2Session.closeSession();
	}catch(Exception e)
	{
	e.printStackTrace();
	}	
}else{
	out.println("!!你没有相关访问权限!!");
}
%>

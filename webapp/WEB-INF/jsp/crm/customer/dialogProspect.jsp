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

try{
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
	String SrcType = request.getParameter("SrcType");
	
	if (SrcIndustry == null) SrcIndustry ="";
	if (SrcAccount == null) SrcAccount ="";
	if (SrcCustomer == null) SrcCustomer ="";
	if (SrcInitial == null) SrcInitial ="";
	if (SrcType == null) SrcType ="";

	String pageNumber=request.getParameter("pageNumber");
	if(pageNumber == null ) pageNumber = "";
	
	List result = (List)request.getAttribute("resultList");
	if (result == null)result = new ArrayList();
%>
<form action="crm.dialogProspectList.do" method="POST" name=frm>
<title>Customer / Prosepect Selection</title>
<input type="hidden" name="pageNumber" value="<%=pageNumber%>">
<input type="hidden" name="FormAction">
<table width=100% align=center >
	<CAPTION class=pgheadsmall>Customer / Prospect Selection</CAPTION>
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
	<tr><td colspan=5><hr color="red"></td></tr>
</table>


<table width=100%  >
	<tr bgcolor="e9eee9">
		<td class=lblbold width=5%>
			&nbsp;					
		</td>
		<td class=lblbold  width=10%>ID</td>
		<td class=lblbold width=40%>Description</td>
		<td class=lblbold width=20%>Customer Account</td>
		<td class=lblbold width=20%>Type</td>
	</tr>
</table>


<table align="center" width=100%  Frame=box rules=none border=1 bgcolor=white>
<tr><td>
	<div style="word-break : break-all;width:570px;height:330px;overflow:auto;">
	<table align="center">
		<%
		String pre = " ";
		for(int i=0;i<result.size();i++)
		{
		CustomerProfile cp = (CustomerProfile)result.get(i);
		if(!(cp.getDescription().startsWith(pre.toLowerCase())||cp.getDescription().startsWith(pre.toUpperCase())))
		{
			pre = cp.getDescription().substring(0,1);
		%>
		<tr><td>&nbsp;</td><td><a name="<%=pre%>"><%=pre%></a></td><td>&nbsp;</td><td>&nbsp;</td></tr>
		<%
		}
		%>
		<tr class="listbody">
				<td width="5%">
					<input type=radio name=chk 
					value="<%=cp.getPartyId()%>|<%=cp.getDescription()%>|<%=cp.getChineseName()%>|<%=cp.getCity()%>|<%=cp.getAddress()%>|<%=cp.getIndustry().getDescription()%>|<%=cp.getAccount().getDescription()%>|<%=cp.getPostCode() %>|<%=cp.getTeleCode()%> |<%=cp.getFaxCode()%>|<%=cp.getIndustry().getId()%>|<%=cp.getAccount().getAccountId()%>">					
				</td>
				<td width=10%><%=cp.getPartyId()%></td>
				<td width=45%>&nbsp;&nbsp;<%=cp.getDescription()%></td>
				<td width=20%><%=cp.getAccount().getDescription()%></td>
				<td width=20%><%=cp.getType().equals("C") ? "Customer" : "Prospect"%>
			<input type="hidden" name="chineseName" value="<%=cp.getChineseName()%>">
			<input type="hidden" name="city" value="<%=cp.getCity()%>">
			<input type="hidden" name="address" value="<%=cp.getAddress()%>">
			<input type="hidden" name="industry" value="<%=cp.getIndustry().getDescription()%>">
			<input type="hidden" name="industryId" value="<%=cp.getIndustry().getId()%>">
			<input type="hidden" name="customerGroup" value="<%=cp.getAccount().getDescription()%>">
			<input type="hidden" name="customerGroupId" value="<%=cp.getAccount().getAccountId()%>">
			<input type="hidden" name="postCode" value="<%=cp.getPostCode()%>">
			<input type="hidden" name="teleNo" value="<%=cp.getTeleCode()%>">
			<input type="hidden" name="faxNo" value="<%=cp.getFaxCode()%>">
			</td>
			</tr>
			<%}%>
	</table>
	</div>
	</td>
</tr>
</table>
<table align="center">
<tr><td>&nbsp;</td></tr>
<tr>
		<td colspan=4 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:returnValue()">&nbsp;&nbsp;
			&nbsp;&nbsp;
			
			<input type=button name="new" class=button value="New" onclick="javascript:location.replace('editProspect.do?openType=dialogView')">&nbsp;&nbsp;
			&nbsp;&nbsp;
			
			<input type=button name="close" class=button value="Cancel" onclick="javascript:window.parent.close()">
		</td>
</tr>
<tr>
      <td colspan=4>
         <table align=center border=0 cellspacing=1 cellpadding=5  rules=none>
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
         	
         <tr>
          <td class=LblBold>Search By Type</td>
        <!--  <td><input type=text name=SrcIndustry size=15 maxlength=20 value='<%=SrcIndustry%>'></td>-->
          <td>
          	<select name="SrcType">
          		<option value="" <%=SrcType.equals("") ? "selected" : ""%>>ALL</option>
          		<option value="C" <%=SrcType.equals("C") ? "selected" : ""%>>Customer</option>
          		<option value="P" <%=SrcType.equals("P") ? "selected" : ""%>>Prospect</option>
          	</select>
          </td>
          <td><input type=button class=button name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
         </table>
      </td>
   </tr>
<tr><td>&nbsp;</td></tr>
</table>
</form> 
<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
}catch(Exception e)
{
e.printStackTrace();
}
%>

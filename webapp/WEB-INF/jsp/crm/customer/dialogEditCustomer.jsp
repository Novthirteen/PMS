<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.util.PageKeys"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("CUST_PARTY", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

CustomerProfile CustParty = (CustomerProfile)request.getAttribute("CustParty");
String PartyId = request.getParameter("PartyId");

String action = request.getParameter("action");
if(action == null){
	action = "create";
}

String flag = request.getParameter("flag");
String industry = request.getParameter("industry");
String custGroup = request.getParameter("custGroup");
String prospectCompanyId = request.getParameter("prospectCompanyId");
String id = request.getParameter("id");
List industryList = null;
List accountList = null;
List T2List = null;
try{
	// 所有机构列表
	CustomerHelper ph = new CustomerHelper();
	industryList = ph.getAllIndustry(hs);
	accountList = ph.getAllAccounts(hs);
	T2List = ph.getAllT2Code(hs);
}catch(Exception e){
	out.println(e.getMessage());
}
%>
<%
	if ("false".equals(request.getParameter("firstVisit"))) {
%>
<script language="javascript">
	window.parent.returnValue = "<%=CustParty.getPartyId()%>" + "|" + "<%=CustParty.getDescription()%>" +
								"|" + "<%=CustParty.getIndustry()!=null ? String.valueOf(CustParty.getIndustry().getId()) : ""%>" +
								"|" + "<%=CustParty.getIndustry()!=null ? CustParty.getIndustry().getDescription() : ""%>" +
								"|" + "<%=CustParty.getAccount()!=null ? String.valueOf(CustParty.getAccount().getAccountId()) : ""%>" +
								"|" + "<%=CustParty.getAccount()!=null ? CustParty.getAccount().getDescription() : ""%>";
	window.parent.close();
</script>
<%
	} else {
%>
<HTML>
	<HEAD>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		<META http-equiv="Content-Type" content="text/html; charset=gbk">
		<script language="javascript">
			function initWindow() {
				var customer = window.dialogArguments;
				if (customer != null) {
					document.getElementById("description").value = customer.name;
					document.getElementById("ChineseName").value = customer.chineseName;
					document.getElementById("address").value = customer.address;
					document.getElementById("postcode").value = customer.postCode;
					document.getElementById("telecode").value = customer.teleNo;
				}
			}
			
			function FnCreate() {
			  	var errormessage= ValidateData();
				if (errormessage != "") {
					alert(errormessage);
				}
				else
				{   
				  	document.EditForm.submit();
				}
			}
			function ValidateData(){
				var errormessage="";
				if(document.getElementById("description").value == 0)
				{
					errormessage="You must input the Name";
					return errormessage;
			    }
				
				if(document.getElementById("AccountId").value=="")
				{
					errormessage="You must select a Customer Group";
					return errormessage;
			    }
				if(document.getElementById("IndustryId").value == "")
				{
					errormessage="You must select a Industry";
					return errormessage;
			    }
			    return errormessage;
			}
			function onClose(){
				window.parent.close();
			}
		</script>
	</HEAD>
	
	<BODY onload="initWindow();">
		<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  			<TR>
    			<TD width='100%'>
      				<table width='100%' border='0' cellspacing='0' cellpadding='0'>
        				<tr>
          					<TD align=left width='90%' class="wpsPortletTopTitle">
            					<bean:message key="System.Party.PageTitle2"/>
          					</TD>
        				</tr>
      				</table>
    			</TD>
  			</TR>
  			
	  		<TR>
	    		<TD width='100%'>
	    			<form action="editCustParty.do" method="post" name="EditForm">
    					<input type="hidden" name="action" value="<%=action%>">
						<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
						<input type="hidden" name="role" value="CUSTOMER">
						<input type="hidden" name="openType" value="dialogView">
						<input type="hidden" name="firstVisit" value="false">
						<input type="hidden" name="flag" value="<%=flag%>">
						<input type="hidden" name="prospectCompanyId" value="<%=prospectCompanyId%>">
						<input type="hidden" name="id" value="<%=id%>">
    					<table border=0 width='100%' cellspacing='0' cellpadding='2' >
					      	<tr>
					      		<td>&nbsp;</td>
					      	</tr>
					      	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.partyId2"/>:&nbsp;</span>
						        </td>
						        <td>
						          	<input type="text" class="inputBox" name="PartyId" size="30">
						        </td>
						        <td align="right">
						          	<span class="tabletext">&nbsp;</span>
						        </td>
						        <td align="left">&nbsp;</td>
					      	</tr>
						  	<tr>
								<td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.description2"/>:&nbsp;</span>
						        </td>
						        <td align="left">
						          	<input type="text" class="inputBox" name="description" size="30" value="">
						        </td>
						    </tr>
						  	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.cndescription2"/>:&nbsp;</span>
						        </td>
						        <td align="left">
						          	<input type="text" class="inputBox" name="ChineseName" size="30"  value="">
						        </td>
					      	</tr>
						  	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.account"/>:&nbsp;</span>
						        </td>
								<td align="left">
						
									<select name="AccountId">
									
									<%	String chk = "";
										if(custGroup == null || custGroup.equals("new") || custGroup.equals("")){
											chk = "selected";
											out.println("<option value=\"\""+chk+">new Customer Group</option>");
											Iterator itAcc = accountList.iterator();
											while(itAcc.hasNext()){
												CustomerAccount p = (CustomerAccount)itAcc.next();
												chk ="";
												out.println("<option value=\""+p.getAccountId()+"\""+chk+">"+p.getDescription()+"</option>");
											}
										}else{
											Iterator itAcc = accountList.iterator();
											while(itAcc.hasNext()){
												chk ="";
												CustomerAccount p = (CustomerAccount)itAcc.next();
												if(String.valueOf(p.getAccountId()).equals(custGroup))chk ="selected";
												out.println("<option value=\""+p.getAccountId()+"\""+chk+">"+p.getDescription()+"</option>");
											}
										}
									%>
									</select>
								
						        </td>
						    </tr>
						  	<tr>
								<td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.industry"/>:&nbsp;</span>
						        </td>
								<td align="left">
									<select name="IndustryId">
									<%
										if(industry ==null || industry.equals("new") || industry.equals("")){
											chk = "selected";
											out.println("<option value=\"\""+chk+">new Industry</option>");
											Iterator itInd = industryList.iterator();
											while(itInd.hasNext()){
												Industry p = (Industry)itInd.next();
												chk ="";
												out.println("<option value=\""+p.getId()+"\""+chk+">"+p.getDescription()+"</option>");
											}
										}else{
											Iterator itInd = industryList.iterator();
											while(itInd.hasNext()){
												chk ="";
												Industry p = (Industry)itInd.next();
												if(String.valueOf(p.getId()).equals(industry))chk ="selected";
												out.println("<option value=\""+p.getId()+"\""+chk+">"+p.getDescription()+"</option>");
											}
										}
									%>
									</select>
						        </td>
					      	</tr>
					      	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.address"/>:&nbsp;</span>
						        </td>
						        <td align="left">
						          	<input type="text" class="inputBox" name="address" size="30" value="">
						        </td>
						    </tr>
						  	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.postCode"/>:&nbsp;</span>
						        </td>
						        <td align="left">
						          	<input type="text" class="inputBox" name="postcode" size="30"  value="">
						        </td>
					      	</tr>
					      	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.teleCode"/>:&nbsp;</span>
						        </td>
						        <td>
						          	<input type="text" class="inputBox" name="telecode" size="30" value="">
						        </td>
						    </tr>
	      					<tr><td>&nbsp;</td><td><br></td></tr>  
					      	<tr>
						        <td></td>
						        <td align="left">
						        	<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();return false"/>
									&nbsp;&nbsp;&nbsp;&nbsp;
							<%
								if(flag == null || !"bid".equals(flag) || flag.equals("")){
							%>
									<input type="button" value="Back To List" class="loginButton" onclick="location.replace('crm.dialogCustomerList.do')">
						    <%
						    	}else{
						    %> 
						    		<input type="button" value="Close" class="loginButton" onclick="javascript:onClose()">
						    <%
						    	}
						    %> 
						        </td>
								<td></td>
								<td></td>
					      	</tr>
					      	
					      	<tr>
						        <td></td>
						        <td align="left" colspan="3">
									<input type="button" value="Create Customer Group" class="loginButton" onclick="location.replace('editCustomerAccount.do?openType=dialogView&flag=bid')">
						        </td>
					      	</tr>
					      	<tr>
						        <td></td>
						        <td align="left" colspan="3">
									<input type="button" value="Create Customer Industry" class="loginButton" onclick="location.replace('editIndustry.do?openType=dialogView&flag=bid')">
						        </td>
					      	</tr>
					      	
	    				</table>
	 				</form>
	  			</td>
	  		</tr>
	    	<tr><td>&nbsp;</td></tr>
		</table>
	</body>
</html>
<%
}
Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
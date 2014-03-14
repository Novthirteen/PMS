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
//if (AOFSECURITY.hasEntityPermission("PROSPECT_PARTY", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

CustomerProfile CustParty = (CustomerProfile)request.getAttribute("CustParty");
String PartyId  = request.getParameter("PartyId");
if ((PartyId !=null)&&PartyId.equals("null")) PartyId = null;
CustomerProfile CustParty1 = null;

if ((PartyId != null)){
 	CustParty1 = (CustomerProfile)hs.load(CustomerProfile.class,PartyId);
}
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
//List T2List = null;
try{
	// 所有机构列表
	CustomerHelper ph = new CustomerHelper();
//	industryList = ph.getAllIndustry(hs);
//	accountList = ph.getAllAccounts(hs);
	//T2List = ph.getAllT2Code(hs);
}catch(Exception e){
	out.println(e.getMessage());
}
%>
<%
	if ("false".equals(request.getParameter("firstVisit"))) {
%>
<script language="javascript">
	<% if(CustParty!=null){%>
	window.parent.returnValue = "<%=CustParty.getPartyId()%>" + "|" + "<%=CustParty.getDescription()%>" +
								"|" + "<%=CustParty.getChineseName()%>" +
								"|" + "<%=CustParty.getAccountCode()%>" +
								"|" + "<%=CustParty.getAddress()%>" +
								"|" + "<%=CustParty.getIndustry()!=null ? CustParty.getIndustry().getDescription() : ""%>" +
								"|" + "<%=CustParty.getAccount()!=null ? CustParty.getAccount().getDescription() : ""%>"+
								"|" + "<%=CustParty.getPostCode()%>" +
								"|" + "<%=CustParty.getTeleCode()%>" +
								"|" + "<%=CustParty.getFaxCode()%>" +
								"|" + "<%=CustParty.getIndustry().getId()%>" +
								"|" + "<%=CustParty.getAccount().getAccountId()%>";
	window.parent.close();
	<%}%>
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
function showCustomerGroupDialog()
{
//	var code,desc,pid;
//	pid=document.getElementById("prospectCompanyId").value;

		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogCustomerGroupList.do?",
			null,
			'dialogWidth:500px;dialogHeight:550px;status:no;help:no;scroll:no');
		if (v != null) {
			document.getElementById("account").innerHTML = v.split("|")[1];
			document.getElementById("AccountId").value = v.split("|")[0];
			//alert(document.getElementById("AccountId").value)			
	}
}

function showIndustryDialog()
{
	var code,desc,pid;
	pid=document.getElementById("prospectCompanyId").value;

		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogIndustryList.do",
			null,
			'dialogWidth:400px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			document.getElementById("industry").innerHTML = v.split("|")[1];
			var input = document.getElementsByName("IndustryId")
			input[0].value = v.split("|")[0];			
	}
}
			function initWindow() {
				var customer = window.dialogArguments;
				if (customer != null) {
					document.getElementById("description").value = customer.name;
					document.getElementById("ChineseName").value = customer.chineseName;
					document.getElementById("address").value = customer.address;
					document.getElementById("postcode").value = customer.postCode;
					document.getElementById("telecode").value = customer.teleNo;
					document.getElementById("faxNo").value = customer.faxCode;
					document.getElementById("BankNo").value = customer.bankNo;
					
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
			function FnUpdate() {
			  	document.EditForm.action.value ='update';
				document.EditForm.submit();
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
            					Prospect Maintenance
          					</TD>
        				</tr>
      				</table>
    			</TD>
  			</TR>
  			
	  		<TR>
	    		<TD width='100%'>
	    			<form action="editProspect.do" method="post" name="EditForm">
    					<input type="hidden" name="action" value=<%=action%>>
						<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value=<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>>
						<input type="hidden" name="role" value="CUSTOMER">
						<input type="hidden" name="openType" value="dialogView">
						<input type="hidden" name="firstVisit" value="false">
						<input type="hidden" name="flag" value=<%=flag%>>
						<input type="hidden" name="prospectCompanyId" value=<%=prospectCompanyId%>>
						<input type="hidden" name="id" value=<%=id%>>
						<input type="hidden" name="pid" value=<%=PartyId%>>
    					<table border=0 width='100%' cellspacing='0' cellpadding='2' >
					      	<tr>
					      		<td>&nbsp;</td>
					      	</tr>
					      	<tr>
						        <td align="right">
						          	<span class="tabletext">Code:&nbsp;</span>
						        </td>
						 <%if (CustParty1 == null) {%>
						        <td>
						          	System Auto-Generated
						        </td>
						   <%}else{%>
						        <td>
						          	<%=CustParty1.getPartyId()%>
						        </td>
						   <%}%>
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
						  <%if (CustParty1 == null) {%>
						          	<input type="text" class="inputBox" name="description" size="30" value="">
						   <%}else{
						   %>        	
						   			<input type="text" class="inputBox" name="description" size="30" value="<%=CustParty1.getDescription()== null ? "" : CustParty1.getDescription()%>">
						    <%}%>
						        </td>
						    </tr>
						  	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.cndescription2"/>:&nbsp;</span>
						        </td>
						        <td align="left">
						    <%if (CustParty1 == null) {%>
						          	<input type="text" class="inputBox" name="ChineseName" size="30"  value="">
						      <%}else{%>
	   						      	<input type="text" class="inputBox" name="ChineseName" size="30"  value="<%=CustParty1.getChineseName() == null ? "" :CustParty1.getChineseName()%>">
	   						   <%}%>   	
						        </td>
					      	</tr>
						  	<tr>
						        <td align="right">
						          	<span class="tabletext">Group:&nbsp;</span>
						        </td>
								<td align="left"><span id="account">
								<%if(CustParty1!=null)out.print(CustParty1.getAccount().getDescription());%>
								</span>
								<a
					href="javascript:void(0)"
					onclick="showCustomerGroupDialog();event.returnValue=false;"><img
					align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>"
					src="images/select.gif" border="0" /></a>
						<input type="hidden" id="AccountId" name="AccountId" value="<%if(CustParty1!=null)out.print(CustParty1.getAccount().getAccountId().longValue());%>">
						        </td>
						    </tr>
						  	<tr>
								<td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.industry"/>:&nbsp;</span>
						        </td>
								<td align="left"><span id="industry"><%if(CustParty1!=null)out.print(CustParty1.getIndustry().getDescription());%></span>
								<a
					href="javascript:void(0)"
					onclick="showIndustryDialog();event.returnValue=false;"><img
					align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>"
					src="images/select.gif" border="0" /></a>
					<input type="hidden" id="IndustryId" name="IndustryId" value="<%if(CustParty1!=null)out.print(CustParty1.getIndustry().getId());%>">
						        </td>
					      	</tr>
					      	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.address"/>:&nbsp;</span>
						        </td>
						        <td align="left">
						    <%if (CustParty1 == null) {%>
						          	<input type="text" class="inputBox" name="address" size="30" value="">
						   <%}else{%>        	
						   			<input type="text" class="inputBox" name="address" size="30" value="<%=CustParty1.getAddress()== null ? "" : CustParty1.getAddress()%>">
						    <%}%>
						          	
						        </td>
						    </tr>
						  	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.postCode"/>:&nbsp;</span>
						        </td>
						        <td align="left">
						     <%if (CustParty1 == null) {%>
						          	<input type="text" class="inputBox" name="postcode" size="30"  value="">
						   <%}else{%>        	
						   			<input type="text" class="inputBox" name="postcode" size="30"  value="<%=CustParty1.getPostCode()== null ? "" : CustParty1.getPostCode()%>">
						    <%}%>
						          	
						        </td>
					      	</tr>
					      	<tr>
						        <td align="right">
						          	<span class="tabletext"><bean:message key="System.Party.teleCode"/>:&nbsp;</span>
						        </td>
						    
						        <td>
						   <%if (CustParty1 == null) {%>
						          	<input type="text" class="inputBox" name="telecode" size="30" value="">
						   <%}else{%>        	
						   			<input type="text" class="inputBox" name="telecode" size="30" value="<%=CustParty1.getTeleCode()== null ? "" : CustParty1.getTeleCode()%>">
						    <%}%>
						          	
						        </td>
						    </tr>
						    <tr>
						        <td align="right">
						          	<span class="tabletext">Fax No.:&nbsp;</span>
						        </td>
						        <td align="left">
						   <%if (CustParty1 == null) {%>
						          	<input type="text" class="inputBox" name="faxNo" size="30"  value="">
						   <%}else{%>        	
						   			<input type="text" class="inputBox" name="faxNo" size="30"  value="<%=CustParty1.getFaxCode()== null ? "" : CustParty1.getFaxCode()%>">
						    <%}%>
						          	
						        </td>
					      	</tr>
					      	<tr>
						        <td align="right">
						          	<span class="tabletext">Bank No.:&nbsp;</span>
						        </td>
						        <td align="left">
						    <%if (CustParty1 == null) {%>
						          	<input type="text" class="inputBox" name="bankNo" size="30"  value="">
						   <%}else{%>        	
						   			<input type="text" class="inputBox" name="bankNo" size="30"  value="<%=CustParty1.getAccountCode()== null ? "" : CustParty1.getAccountCode()%>">
						    <%}%>
						          	
						        </td>
					      	</tr>
	      					<tr><td>&nbsp;</td><td><br></td></tr>  
					      	<tr>
						        <td></td>
						        <td align="left">
						        <%if (CustParty1 == null) {%>
						        	<input type="button" value="Save" class="loginButton" onclick="javascript:FnCreate();return false"/>
						       <%}else{%> 
						      	 <input type="button" value="Update" class="loginButton" onclick="javascript:FnUpdate();return false"/>
						      	  <%}%>
									&nbsp;&nbsp;&nbsp;&nbsp;
							<%
								if((flag == null || !"bid".equals(flag) || flag.equals("") ) && CustParty == null){
							%>
									<input type="button" value="Back To List" class="loginButton" onclick="location.replace('crm.dialogProspectList.do')">
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
					      	
 <!--					     	<tr>
						        <td></td>
						        <td align="left" colspan="3">
									<input type="button" value="Create New Group" class="loginButton" onclick="location.replace('editCustomerAccount.do?openType=dialogView&flag=bid')">
						        </td>
					      	</tr>
-->
					     <!--  	<tr>
						        <td></td>
						        <td align="left" colspan="3">
									<input type="button" value="Create New Industry" class="loginButton" onclick="location.replace('editIndustry.do?openType=dialogView&flag=bid')">
						        </td>
					      	</tr>
					     --> 	
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
//}else{
//	out.println("!!你没有相关访问权限!!");
//}
%>
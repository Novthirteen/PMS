<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="com.aof.component.prm.bid.BidMaster"%>
<%@ page import="com.aof.component.crm.customer.CustomerProfile"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<script>

	function showProspectDialog(){
		var code,desc;
	
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogProspectList.do",
			null,
			'dialogWidth:620px;dialogHeight:700px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			document.getElementById("prospectCompanyId").value=code;
			desc=v.split("|")[1];
			document.getElementById("name").innerHTML=desc;
			document.getElementById("chineseName").innerHTML  = v.split("|")[2];
			document.getElementById("address").innerHTML = v.split("|")[4];
			document.getElementById("industry").innerHTML = v.split("|")[5];
			document.getElementById("bankno").innerHTML = v.split("|")[3];
			document.getElementById("custGroup").innerHTML = v.split("|")[6];
			document.getElementById("postCode").innerHTML = v.split("|")[7];
			document.getElementById("teleNo").innerHTML = v.split("|")[8];
			document.getElementById("faxNo").innerHTML  = v.split("|")[9];
			var industryId = v.split("|")[10];
			var customerGroupId = v.split("|")[11];
		}
	}

	function showProspectDialog1(){
		var code,desc,pid;
		pid=document.getElementById("prospectCompanyId").value;
	
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&editProspect.do?openType=dialogView&PartyId="+pid,
			null,
			'dialogWidth:560px;dialogHeight:660px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			document.getElementById("prospectCompanyId").value=code;
			desc=v.split("|")[1];
			document.getElementById("name").innerHTML=desc;
			document.getElementById("chineseName").innerHTML  = v.split("|")[2];
			document.getElementById("address").innerHTML = v.split("|")[4];
			document.getElementById("industry").innerHTML = v.split("|")[5];
			document.getElementById("bankno").innerHTML = v.split("|")[3];
			document.getElementById("custGroup").innerHTML = v.split("|")[6];
			document.getElementById("postCode").innerHTML = v.split("|")[7];
			document.getElementById("teleNo").innerHTML = v.split("|")[8];
			document.getElementById("faxNo").innerHTML  = v.split("|")[9];
			var industryId = v.split("|")[10];
			var customerGroupId = v.split("|")[11];		
		}
	}
	
	function fnUpdateProspect(){
		if(document.EditForm.prospectCompanyId.value == 0){
			alert("The Prospect or Customer cannot be ignored!");
			return;
		}
		document.EditForm.formAction.value = "updateProspect";
		document.EditForm.submit();
	}
</script>
<%
try{
	BidMaster bidMaster = (BidMaster)request.getAttribute("BidMaster");
	//CustomerProfile prospectCompany = (CustomerProfile)request.getAttribute("prospectCompany");
	
	CustomerProfile prospectCompany = null;
	if(bidMaster != null){
		prospectCompany = (CustomerProfile)bidMaster.getProspectCompany();
		if(prospectCompany == null){
			prospectCompany = new CustomerProfile();
		}
	}
%>
	<table border=0 width='100%' cellspacing='0' cellpadding='1'>
		<tr>
	    	<td width='100%'colspan="10">
	      		<table width='100%' border='0' cellspacing='0' cellpadding='0'>
	        		<tr>
	          			<td align=left width='90%' class="wpsPortletTopTitle">&nbsp;&nbsp;Customer Details</td>
	        		</tr>
	      		</table>
	    	</td>
		</tr>
		<tr>
			<td align="right"  class="lblbold" width="25%">
				<span class="tabletext">Customer Name:&nbsp;</span>
				<input type="hidden" name="prospectCompanyId" id="prospectCompanyId" value="<%=prospectCompany.getPartyId()%>">
			</td>
			<td align="left" width=45% colspan=2>
				<a href="javascript:void(0)" onclick="showProspectDialog1();event.returnValue=false;"><div style="display:inline" id="name"><%=prospectCompany.getDescription() == null ? "" : prospectCompany.getDescription()%></div></a>
				<a href="javascript:void(0)" onclick="showProspectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0" /></a>  
			</td>
			<td align="right" width=15% class="lblbold"><span class="tabletext" >Chinese Name:&nbsp;</span></td>
			<td align="left" width=35% colspan=2>
				<div style="display:inline" id="chineseName"><%=prospectCompany.getChineseName() == null ? "" : prospectCompany.getChineseName()%></div>
			</td>
		</tr>
		<tr>
			<td align="right" class="lblbold"><span class="tabletext">Industry:&nbsp;</span></td>
			<td align="left" colspan=2><div style="display:inline" id="industry"><%=prospectCompany.getIndustry() == null ? "" : prospectCompany.getIndustry().getDescription()%></div></td>
			<td align="right" class="lblbold"><span class="tabletext">Group:&nbsp;</span></td>
			<td align="left" colspan=2><div style="display:inline" id="custGroup"><%=prospectCompany.getAccount() == null ? "" : prospectCompany.getAccount().getDescription()%></div></td>
			<td align="right" class="lblbold"></td>
		</tr>
		<tr>
			<td align="right" class="lblbold"><span class="tabletext">Address:&nbsp;</span></td>
			<td align="left" colspan=2><div style="display:inline" id="address"><%=prospectCompany.getAddress() == null ? "" : prospectCompany.getAddress()%></div></td>
			<td align="right" class="lblbold"><span class="tabletext">Post Code:&nbsp;</span></td>
			<td align="left" colspan=2><div style="display:inline" id="postCode"><%=prospectCompany.getPostCode() == null ? "" : prospectCompany.getPostCode()%></div></td>
		</tr>
		<tr>
			<td align="right" align="right" class="lblbold"><span class="tabletext">Telephone No.:&nbsp;</span></td>
			<td align="left" colspan=2><div style="display:inline" id="teleNo"><%=prospectCompany.getTeleCode() == null ? "" : prospectCompany.getTeleCode()%></div></td>
			<td align="right" class="lblbold"><span class="tabletext">Fax No:&nbsp;</span></td>
			<td align="left" colspan=2><div style="display:inline" id="faxNo"><%=prospectCompany.getFaxCode() == null ? "" : prospectCompany.getFaxCode()%></div></td>
		</tr>
		<tr>
			<td align="right" class="lblbold"><span class="tabletext">Bank No.:&nbsp;</span></td>
			<td align="left" colspan=2><div style="display:inline" id="bankno"><%=prospectCompany.getAccountCode() == null ? "" : prospectCompany.getAccountCode()%></div></td>
		</tr>
		<tr>
			<td align="right" colspan="6">
				<input type="button" value="Save" class="button" onclick="javascript:fnUpdateProspect();"/>
			</td>
		</tr>
	</table>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>

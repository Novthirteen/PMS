<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="com.aof.component.prm.bid.BidMaster"%>
<%@ page import="com.aof.component.crm.customer.CustomerProfile"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<script>

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
	          			<td align=left width='90%' class="wpsPortletTopTitle">&nbsp;&nbsp;Prospect Company Details</td>
	        		</tr>
	      		</table>
	    	</td>
		</tr>
		<tr>
			<td align="right"  class="lblbold" width="25%">
				<span class="tabletext">Prospect Company Name:&nbsp;</span>
				<input type="hidden" name="prospectCompanyId" value="<%=prospectCompany.getPartyId()%>">
			</td>
			<td align="left" width=45% colspan=2>
			<div style="display:inline" id="name"><%=prospectCompany.getDescription() == null ? "" : prospectCompany.getDescription()%></div></td>
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
	</table>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>

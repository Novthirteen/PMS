<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>

<title>AO-SYSTEM</title>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<FORM name="frm1" action="editProjBOM.do" method=post>
<BR><BR>
<input type="hidden" name="formaction" value="new">
<TABLE width=100% >
	<CAPTION class=pgheadsmall>Project BOM
	</CAPTION>
	<tr>
		<td>
			<TABLE width=400 cellspacing=2 cellpadding=2 align=center FRAME=0 rules=none border=1>
	
				<tr>
					<TD class=lblbold align="right">Template:&nbsp;</TD>
					<td class="lblbold">
					<input type="hidden" name="template_desc">
						<div style="display:inline" id="labeltemplate">&nbsp;</div>
					<input type="hidden" name="template_id"><a href="javascript:void(0)" onclick="showTemplateDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
					</td>
				</tr>

				<tr>
					<TD class=lblbold align="right">Bid:&nbsp;</TD>
					<td class="lblbold">
					<input type="hidden" name="bid_desc">
						<div style="display:inline" id="labelBid">&nbsp;</div>
					<input type="hidden" name="bid_id"><a href="javascript:void(0)" onclick="showBidDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
					</td>
				</tr>
				
				<tr>
					<TD class=lblbold align="right">Project:&nbsp;</TD>
					<td class="lblbold">
					<input type="hidden" name="proj_desc">
						<div style="display:inline" id="labelProject" size="50">&nbsp;</div>
						<a href="javascript:void(0)" onclick="showProjectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
					<input type="hidden" name="proj_id">
					</td>
				</tr>
				
				<tr>
					<TD class=lblbold align="right">Customer:&nbsp;</TD>
					<td class="lblbold" align='left' >
					<input type="hidden" name="cust_id">
					<input type="hidden" name="cust_desc">
						<div style="display:inline" id="labelCustomer" size="50">&nbsp;</div>
					</td>
				</tr>
				
				<tr>
					<TD class=lblbold align="right">Import from Similar Project BOM:&nbsp;</TD>
					<td class="lblbold">
						<input type="hidden" name="simBomId">
						<div style="display:inline" id="labelBom">&nbsp;</div>
						<a href="javascript:void(0)" onclick="showBOMDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
					</td>
				</tr>

				<tr><td>&nbsp;</td></tr>
				<tr>
					<TD class=lblbold align=center >&nbsp;</TD>
					<TD class=lblbold align=left >
						<INPUT class=button size="20" type="button" name=btnSave value='Continue >>' onclick="javascript:check()">
<!-- 						<INPUT class=button size="5" TYPE="button" name=btnSave value='Edit Type' onclick = "javascript:check()" >
-->
					</TD>					
				</tr>
			</TABLE>
		</td>
	</tr>
</TABLE>
<BR><BR>
<script language="JavaScript">
function check()
{
	with(document.frm1)
	{
		if((template_id.value.length<1)&&(simBomId.value.length<1))
		{
			alert("Template can't be ingored!")
			return;
		}
		
		if((proj_id.value.length<1)&&(bid_id.value.length<1))
		{
			alert("Please select a Project or a Bid")
			return;
		}
		submit();
		
	}	
}

function showBidDialog()
{
	var code,desc;
	var cid,cdesc;
	var depid,depname;
	var bid,bname;
	with(document.frm1)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&BidChooseDialogue.do?",
			null,
			'dialogWidth:950px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			cid = v.split("|")[2];
			cdesc = v.split("|")[3];
			depid = v.split("|")[4];
			
			bid = v.split("|")[5];
			bname = v.split("|")[6];
			bno = v.split("|")[7];
	
			labelProject.innerHTML=code+":"+desc;
			labelCustomer.innerHTML = cid+":"+cdesc;
			///labelProject.innerHTML="";
			//labelCustomer.innerHTML = "";
			
			labelBid.innerHTML = bno+":"+bname;
			
			proj_id.value=code;
			proj_desc.value = desc;
			cust_id.value = cid;
			cust_desc.value = cdesc;
			
		//	proj_id.value="";
		//	proj_desc.value = "";
		//	cust_id.value = "";
		//	cust_desc.value = "";
			
			bid_id.value = bid;
			bid_desc.value = bname;
		}
	}
}

function showBOMDialog(){

	var bomId;
	var bidNo;
	var bidDesc;

	with(document.frm1){
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&BOMChooseDialogue.do?",
			null,
			'dialogWidth:900px;dialogHeight:600px;status:no;help:no;scroll:no');
			
		if (v != null) {
			bomId = v.split("|")[0];
			bidNo = v.split("|")[1];
			bidDesc = v.split("|")[2];
			
			labelBom.innerHTML = bidNo + ":" + bidDesc;
		
			simBomId.value = bomId;
			template_id.value = v.split("|")[3];
//			alert(simBomId.value);
		}
	}
}

function showTemplateDialog()
{
	var id;
	var desc;
	var dep_desc;

	with(document.frm1){
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&TemplateChooseDialogue.do?",
			null,
			'dialogWidth:900px;dialogHeight:600px;status:no;help:no;scroll:no');
			
		if (v != null) {
			id = v.split("|")[0];
			desc = v.split("|")[1];
			dep_desc = v.split("|")[2];
			
			labeltemplate.innerHTML = dep_desc + ":" + desc;
			template_id.value = id;
		}
	}

}
 
 
function showProjectDialog()
{
	var id;
	var desc;
	var dep_desc;

	with(document.frm1){
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&ProjectChooseDialogue.do?",
			null,
			'dialogWidth:900px;dialogHeight:600px;status:no;help:no;scroll:no');
			
		if (v != null) {
			id = v.split("|")[0];
			desc = v.split("|")[1];
			labelCustomer.innerHTML = v.split("|")[2]+":"+v.split("|")[3]
			
			labelProject.innerHTML=id+":"+desc;
			proj_id.value=id;
			proj_desc.value = desc;
			
			labelBid.innerHTML = "";
			bid_id.value = "";
			bid_desc.value = "";
		}
	}

}

</script>
</Form>
<br>

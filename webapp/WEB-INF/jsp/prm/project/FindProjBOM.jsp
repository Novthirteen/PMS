<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta http-equiv="Page-Enter" content="blendTrans(Duration=0.2)">
<meta http-equiv="Page-Exit" content="blendTrans(Duration=0.2)">
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
<script language="JavaScript">
function check()
{
	document.frm1.action="editProjType.do";
	document.frm1.submit();
	
}
function showProjectDialog()
{
	var code,desc;
	var cid,cdesc;
	var depid,depname;
	with(document.frm1)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&ProjectChooseDialogue.do?",
			null,
			'dialogWidth:900px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			cid = v.split("|")[2];
			cdesc = v.split("|")[3];
			depid = v.split("|")[4];
			depname = v.split("|")[5];
			labelProject.innerHTML=code+":"+desc;
			labelCustomer.innerHTML = cid+":"+cdesc;
			labelDepartment.innerHTML = depname;
			proj_id.value=code;
			proj_desc.value = desc;
			cust_id.value = cid;
			cust_desc.value = cdesc;
			dep_id.value = depid;
			dep_name.value = depname;
		}
	}
}
</script>

<FORM name="frm1" action="editProjType.do" method=post>
<BR><BR>
<input type="hidden" name="formaction" value="new">
<TABLE width=100% >
	<CAPTION class=pgheadsmall>Project Service Type
	</CAPTION>
	<tr>
		<td>
			<TABLE width=300 cellspacing=2 cellpadding=2 align=center FRAME=0 rules=none border=1>
				<tr>
					<TD class=lblbold align="center">Project:</TD>
					<td class="lblbold">
					<input type="hidden" name="proj_desc">
						<div style="display:inline" id="labelProject" size="50">&nbsp;</div>
					<input type="hidden" name="proj_id"><a href="javascript:void(0)" onclick="showProjectDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<TD class=lblbold align="center">Customer:</TD>
					<td class="lblbold" align='left' >
					<input type="hidden" name="cust_id">
					<input type="hidden" name="cust_desc">
						<div style="display:inline" id="labelCustomer" size="50">&nbsp;</div>
					</td>
				</tr>
				<tr>
					<TD class=lblbold align="center">Department:</TD>
					<td class="lblbold" align='left' >
					<input type="hidden" name="dep_id">
					<input type="hidden" name="dep_name">
						<div style="display:inline" id="labelDepartment" size="50">&nbsp;</div>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<TD class=lblbold align=center >&nbsp;</TD>
					<TD class=lblbold align=left >
						<INPUT class=button size="20" TYPE="submit" name=btnSave value='Continue >>' >
					</TD>					
				</tr>
			</TABLE>
		</td>
	</tr>
</TABLE>
<BR><BR>
</Form>
<br>

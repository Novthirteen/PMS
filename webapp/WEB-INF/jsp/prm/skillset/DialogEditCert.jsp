<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.aof.util.UtilDateTime" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.skillset.SkillCert" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
if (AOFSECURITY.hasEntityPermission("SKILL_SET", "_MAINTENANCE", session)) {

	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
	Date nowDate = (Date)UtilDateTime.nowTimestamp();

	List valueList = (List)request.getAttribute("valueList");

	if(valueList == null){
		valueList = new ArrayList();
	}

%>


<HTML>
	<HEAD>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		
		<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
		<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
		<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

		<script language="javascript">
			
			function fnAdd() {
				if(document.editForm.iCertDesc == null ||document.editForm.iCertDesc.value == ""){
					alert("Please input the information of certification.");
					return;
				}
				var date = document.editForm.iDateGrant.value;
				
				if(date == 0) {
					alert("The date of grand can not be 0.");
					return;
			    }
				document.editForm.command.value = "createCert";
				document.editForm.submit();
			}
			
			function onClose() {
				var recordCount = document.editForm.recordCount.value;				
				window.parent.returnValue = recordCount;
				window.parent.close();
			}
			
			function loadParam() {
				var recordCount = document.editForm.recordCount.value;				
				window.parent.returnValue = recordCount;
			}
		</script>
	</HEAD>
	<BODY onunload="loadParam()">
	
		<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" 
			style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
		</IFRAME>
	
		<form name="editForm" action="skillAction.do" method="post">
			<input type="hidden" name="formAction" id="formAction" value="cert">
			<input type="hidden" name="command" id="command" value="">
			<input type="hidden" name="recordCount" id="recordCount" value="<%=valueList.size()%>">
			
			<table width=102% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Edit Personal Certification</CAPTION>
				<tr align="center">
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="60%">Professional Certification<br>(please input the name and level of the certification you have had)</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="15%">Date of Grant</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="10%">Action</td>
				</tr>
				<%
				if(valueList != null && valueList.size() > 0){
					for (int i =0; i < valueList.size(); i++) {						
						SkillCert tmpValue = (SkillCert)valueList.get(i);					
				%>
				<tr>
					<input type="hidden" name="certId" id="certId" value="<%=tmpValue.getCertId()%>">
			        <td bgcolor="#e9eef9" align="center"><%=tmpValue.getCertDesc() == null ? "" : tmpValue.getCertDesc()%></td>
			    	<td bgcolor="#e9eef9" align="center"><%=tmpValue.getDateGrant() == null ? "" : dateFormater.format(tmpValue.getDateGrant())%></td>
					<td bgcolor="#e9eef9" align="center">
						<a href="skillAction.do?formAction=cert&command=removeCert&certId=<%=tmpValue.getCertId()%>">Delete</a>
					</td>					
			    </tr>
				<%
					}
				}
				%>
				<tr>
					<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
				</tr>
				<tr>
					<td align="center">
						<input type="text" class="inputBox" name="iCertDesc" size="85" value="">
					</td>
					<td align="center">						
						<input type="text" class="inputBox" name="iDateGrant" size="12" oldvalue="<%=dateFormater.format(nowDate)%>" value="<%=dateFormater.format(nowDate)%>">
						<a href="javascript:ShowCalendar(document.editForm.dimgs,document.editForm.iDateGrant,null,0,330)" onclick=event.cancelBubble=true;>
							<img align=absMiddle border=0 id="dimgs" src="<%=request.getContextPath()%>/images/datebtn.gif" >
						</a>
			        </td>
			        <td align="center">
						<input type="button" value="Add" class="loginButton" onclick="javascript:fnAdd();"/>
			        </td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="center"><input type="button" value="Close" class="loginButton" onclick="javascript:onClose()"></td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>
<%	
	}else{
		out.println("!!你没有相关访问权限!!");
	}
}catch(Exception e){
	e.printStackTrace();
}
%>
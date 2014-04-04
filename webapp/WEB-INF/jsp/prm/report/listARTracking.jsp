<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.webapp.action.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="net.sf.hibernate.type.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunction.js'></script>
<%
if (true || AOFSECURITY.hasEntityPermission("SALES_FUNNEL", "_CREATE", session)) {	
	NumberFormat Num_formater = NumberFormat.getInstance();
	Num_formater.setMaximumFractionDigits(2);
	Num_formater.setMinimumFractionDigits(2);
	SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	String projId = request.getParameter("projId");
	String formAction = request.getParameter("FormAction");
	List ARTrackingList = (List)request.getAttribute("ARTrackingList");
	if(ARTrackingList==null){
		ARTrackingList = new java.util.ArrayList();
	}
	if(formAction == null){
		formAction = "view";
	}
%>
<HTML>
	<HEAD>
	
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		
<script language="javascript">
	function showStaff(i) {
		v = window.showModalDialog(
		"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
		null,
		'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		
		if (v != null ) {
			document.getElementsByName("Assignee")[i].value=v.split("|")[0];
			document.getElementsByName("AssigneeName")[i].innerHTML=v.split("|")[1];
		}
	}
	function showStaff1() {
		v = window.showModalDialog(
		"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
		null,
		'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		
		if (v != null) {
			document.EditForm.aAssignee.value=v.split("|")[0];
			aAssigneeName.innerHTML=v.split("|")[1];
		}
	}
	function FnUpdate() {
			document.EditForm.FormAction.value = "update";
			document.EditForm.submit();
		
	}
	function FnAddDetail1() {
		
			document.EditForm.FormAction.value = "addDetail";
			document.EditForm.submit();
		
	}
	function checkHour(){
		//var datafirst = document.EditForm.ahours.value;
	}
	
function checkDeci2(field,falert,mandateflag,fieldName,minNum,maxNum) 
{
 field.value=field.value.replace(/\s/g,'');
 field.value=field.value.replace(/[^0-9\.\-]/g,'');  
 fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
 if(field.value.length <= 0 && mandateflag == 1 && falert == 1) 
 { 
	alert(fieldName + " cannot be ignored"); 
	field.focus(); 
	return false; 
 }//end of if 
if(field.value.length > 0 && falert == 1) 
{ 
	var exp0 = /\./; 
	if (exp0.test(field.value)) 
	{ 
		myArray = field.value.match(exp0); 
		var ant = myArray.input.substring(0, myArray.index) 
		var pre = myArray.input.substring(myArray.index+1, myArray.index+3); 
		if (exp0.test(pre)) 
		{ 
			alert("Not a valid amount"); 
			field.focus(); 
			return false; 
		} 
		if (pre.length == 1) pre= pre + "0"; 
		if (pre.length == 0) pre= "00"; 
		if (ant.length == 0) ant = "0"; 
	field.value = ant + "." + pre; 
	}//end of if 
	if (parseFloat(field.value) > maxNum || parseFloat(field.value) < minNum) 
	{ 
		alert(fieldName +" out of range (" + minNum + " to " + maxNum +")"); 
		field.focus(); 
		return false; 
	} 
	return true; 
}//end of if; 
} 
</script>
	</HEAD>

	<BODY>
<form action="listARTracking.do" method="post" name="EditForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<CAPTION align=center class=pgheadsmall>
	AR Tracking History List
	</CAPTION>
	<input type="hidden" name="projId" id="projId" value="<%=projId==null?"":projId%>">
	<input type="hidden" name="FormAction" id="FormAction" value="<%=formAction==null?"":formAction%>">
	
	<tr>
		<td align="left" class="lblbold" bgcolor="#e9eee9" width="20%">Create User </td>
		<td align="left" class="lblbold" bgcolor="#e9eee9" width="20%">Create Date</td>

		<td align="left" class="lblbold" bgcolor="#e9eee9"  >Description</td>
		<td align="left" class="lblbold" bgcolor="#e9eee9"  >&nbsp;</td>
	</tr>
	<%
		Iterator itst = ARTrackingList.iterator();
		int cc = 0;
		if (ARTrackingList.size()> 0){
			int count =0;
			while (itst.hasNext()){
				ProjectARTracking part = (ProjectARTracking)itst.next();
	%>
		<tr >
	        <td bgcolor="#e9eef9">
		       	<div style="display:inline" id="AssigneeName"><%=part.getCreateUser().getName()%></div>
				<input type="hidden" name="Assignee" id="Assignee" value="<%=part.getCreateUser().getUserLoginId()%>">
				<input type="hidden" name="detailId" id="detailId" value="<%=part.getId()%>">
				<%if (true || AOFSECURITY.hasEntityPermission("SALES_FUNNEL", "_ALL", session)) {%>
					<a href="javascript:showStaff(<%=count%>)">
						<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" />
					</a>
				<%}%>
	        </td>
	        <td bgcolor="#e9eef9">
	        	<input size=12 type="text" readonly class="inputBox" name="createDate<%=cc%>" value="<%=formater.format(part.getCreateDate())%>" size="20">
        	</td>

        	<td bgcolor="#e9eef9">
				<textarea name="actionDesc" cols="60" rows="2"><%=part.getDescription()%></textarea>
				
			</td>
			<td bgcolor="#e9eef9">
				<a href="listARTracking.do?partId=<%=part.getId()%>&projId=<%=projId%>&FormAction=deleteDetail">Delete</a>
			</td>
			<td>&nbsp;</td>
        </tr>
	<%
				count=count+1;
				cc=cc+1;
			}
		}
	%>
	
	
		<input type="hidden" name="cc" id="cc" value="<%=cc%>">
		<tr>
			<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
		</tr>
		<tr>
			<td align="left">
				<div style="display:inline" id="aAssigneeName"><%=ul.getName()%></div>
				<input type="hidden" name="aAssignee" id="aAssignee" value="<%=ul.getUserLoginId()%>">
				<%if (true || AOFSECURITY.hasEntityPermission("PROJ_PRESALE", "_ALL", session)) {%>
				<a href="javascript:void(0)" onclick="showStaff1();event.returnValue=false;">
				<img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>  
				<%}%>
				<input type="hidden" name="aName" id="aName" value="<%=ul.getName()%>">
				<input type="hidden" name="aId" id="aId" value="<%=ul.getUserLoginId()%>">
	        </td>
	        <td align="left">
			<input type="text" class="inputBox" name="aDate" value="<%=formater.format((java.util.Date)UtilDateTime.nowTimestamp())%>" size="12">
			<A href="javascript:ShowCalendar(document.EditForm.dimg88,document.EditForm.aDate,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg88 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
			</td>
        	<td bgcolor="#e9eef9"><textarea name="aDesc" cols="60" rows="2"></textarea>
            </td>
        	<td bgcolor="#e9eee9">
          		<input type="button" value="Add" class="loginButton" onclick="javascript:FnAddDetail1();"/>
        	</td>
        	
        </tr>
        <%
        	if (ARTrackingList.size()> 0){
        %>
	    <tr>
	    	<td colspan = 3></td>
			<td colspan = 3 align="centre">
				<input type="button" value="Update" class="loginButton" onclick="javascript:FnUpdate();"/>
				<input type="button" value="Close" class="loginButton" onclick="javascript:window.parent.close();">
			</td>
        </tr>		
		<%
			}
		%>
</table>
</form>
</BODY>
</HTML>
<%	
	}else{
		out.println("");
	}
%>
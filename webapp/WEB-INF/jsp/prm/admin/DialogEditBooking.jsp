<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.admin.BookingRoomVO" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunction.js'></script>

<%
if (AOFSECURITY.hasEntityPermission("MEETING_ROOM_BOOKING", "_CREATE", session)) {

	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);

	List valueList = (List)request.getAttribute("valueList");
	String dateAdd = (String)request.getAttribute("dateAdd");
	String roomAdd = (String)request.getAttribute("roomAdd");

	if(valueList == null){
		valueList = new ArrayList();
	}

%>
<HTML>
	<HEAD>

		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>

		<script language="javascript">

			function fnUpdate() {

				var startTimeList = document.getElementsByName("startTime");
				var endTimeList = document.getElementsByName("endTime");
				
				var start = 0;
				var end = 0;
				
				for (var i=0; i<startTimeList.length; i++){
					start = startTimeList[i].value;
					end = endTimeList[i].value;					
					if (start == 0){
						alert("Beginning time cannot be 0");
						return;
					}
					if (end == 0){
						alert("Endding time cannot be 0");
						return;
					}					
				}
				document.editForm.formAction.value = "update";
				document.editForm.submit();
			}
			
			function fnAdd() {
				if(document.editForm.iPerson == null ||document.editForm.iPerson.value == ""){
					alert("Please select an employee who will book room.");
					return;
				}
				var start = document.editForm.iStartTime.value;
				var end = document.editForm.iEndTime.value;
				
				if(start == 0) {
					alert("Beginning time cannot be 0");
			    } else if(end == 0) {
					alert("Endding time cannot be 0");
			    } else {
					document.editForm.formAction.value = "create";
					document.editForm.submit();
				}
			}
			
			function onClose() {				
				document.editForm.command.value = "query";
				document.editForm.submit();
				window.parent.returnValue = "Refresh";
				window.parent.close();
			}
			
			function showDialog_account() {
				v = window.showModalDialog(
					"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&userList.do?openType=showModalDialog",
					null,
					'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
				if (v != null) {
					code=v.split("|")[0];
					desc=v.split("|")[1];
					document.getElementById("iPerson").value=code;
				} else {
					document.getElementById("iPerson").value="";
				}
			}
		</script>
	</HEAD>
	<BODY>
		<form name="editForm" action="bookingRoomAction.do" method="post">
			<table width=100% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Edit Meeting Room Booking</CAPTION>
				<input type="hidden" name="command" id = "command" value="list4Add">
				<input type="hidden" name="formAction" id = "formAction" value="">
				<input type="hidden" name="date" id = "date" value="<%=dateAdd%>">
				<input type="hidden" name="room" id = "room" value="<%=roomAdd%>">
				<tr align="center">
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="20%">Name</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="20%">Time</td>
					<td align="center" class="lblbold" bgcolor="#e9eee9" width="10%">Action</td>
				</tr>
				<%				
				if(valueList != null || valueList.size() > 0){
					for (int i =0; i < valueList.size(); i++) {
						BookingRoomVO tmpValue = (BookingRoomVO)valueList.get(i);					
				%>				
				<tr>
					<input type="hidden" name="bookingId" id = "bookingId" value="<%=tmpValue.getBookingId()%>">
			        <td bgcolor="#e9eef9" align="center"><%=tmpValue.getPerson().getName()%></td>
			    	<td bgcolor="#e9eef9" align="center">
			    		From:&nbsp;
			    		<input type="text" class="inputBox" name="startTime" size="10" value="<%=tmpValue.getStartTime()%>">
			    		&nbsp;To:&nbsp;
			    		<input type="text" class="inputBox" name="endTime" size="10" value="<%=tmpValue.getEndTime()%>">
			    	</td>
					<td bgcolor="#e9eef9" align="center">
						<a href="bookingRoomAction.do?command=list4Add&formAction=remove&bookingId=<%=tmpValue.getBookingId()%>&date=<%=dateAdd%>&room=<%=roomAdd%>">Delete</a>
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
						
						<input type="text" class="inputBox" name="iPerson" id="iPerson" size="15" value="" readonly>
						<a href="javascript:showDialog_account()"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a>
				    </td>
					<td align="center">
						From&nbsp;
						<input type="text" class="inputBox" name="iStartTime" size="10" value="0:00">
			    		&nbsp;To&nbsp;
			    		<input type="text" class="inputBox" name="iEndTime" size="10" value="0:00">
			        </td>
			        <td align="center">
						<input type="button" value="Add" class="loginButton" onclick="javascript:fnAdd();"/>
			        </td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="center">
					<%
					if(valueList != null || valueList.size() > 0){
					%>
					<input type="button" value="Update" class="loginButton" onclick="javascript:fnUpdate();"/>
					<%
					}
					%>
					<input type="button" value="Close" class="loginButton" onclick="javascript:onClose()">
					</td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>
<%	
	}else{
		out.println("!!你没有相关访问权限!!");
	}
%>
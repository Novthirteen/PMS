<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.aof.util.UtilDateTime" %>
<%@ page import="java.util.List" %>
<%@ page import="com.aof.component.prm.admin.BookingRoomVO" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<%try {
	if (AOFSECURITY.hasEntityPermission("MEETING_ROOM_BOOKING", "_VIEW", session)) {
%>

<%
	SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat weekFormater = new SimpleDateFormat("MM-dd(EEE)");
	
	Date startDay = (Date)request.getAttribute("startDay");
	Date nowDate = (Date)UtilDateTime.nowTimestamp();
	String strDate = request.getParameter("date");
	String room = request.getParameter("room");

	if (room == null) {
		room = "";
	}
	if (strDate == null) {
		strDate = dateFormater.format(nowDate);
	}

	Date date = UtilDateTime.toDate2(strDate + " 00:00:00.000");
%>
<script language="javascript">

	var actionURL="<%= request.getContextPath() %>/bookingRoomAction.do";

	function fnQuery(){
		bookingForm.command.value="query";
		bookingForm.action = actionURL;
		bookingForm.submit();
	}
	
	function fnAdd(){
		if(bookingForm.room.value == 0) {
			alert("Please select a room first!");
			return;
	    }
		var param = "?command=list4Add";
		var room = document.getElementById("room").value;
		var date = document.getElementById("date").value;
		param += "&date=" + date + "&room=" + room;
		
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.admin.meetingroom.dialog.title&bookingRoomAction.do" + param,
			null,
			'dialogWidth:800px;dialogHeight:500px;status:no;help:no;scroll:no');

		if (v !=null){
			bookingForm.command.value="query";
			bookingForm.action = actionURL;
			bookingForm.submit();
		}
	}
</script>

<IFRAME frameBorder=0 
		id=CalFrame 
		marginHeight=0 
		marginWidth=0 
		noResize 
		scrolling=no src="includes/date/calendar.htm" 
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<table width=100% cellpadding="1" border="0" cellspacing="1">
	<caption align=center class=pgheadsmall>Meeting Room Booking List</caption>
	<tr><td>
		<form name="bookingForm" action="" method="post">
			<input type="hidden" name="command">
			<table width="100%">
				<tr><td colspan=6><hr color=red></hr></td></tr>
				<tr>
					<td align="right"><span class="lblbold">Checking Date:&nbsp;</span></td>
					<td class="lblLight">
						<input type="text" class="inputBox" name="date" size="12" oldvalue="<%=dateFormater.format(date)%>" value="<%=dateFormater.format(date)%>">
						<a href="javascript:ShowCalendar(document.bookingForm.dimgs,document.bookingForm.date,null,0,330)" onclick=event.cancelBubble=true;>
							<img align=absMiddle border=0 id=dimgs src="<%=request.getContextPath()%>/images/datebtn.gif" >
						</a>						
					</td>
					<%
					if (AOFSECURITY.hasEntityPermission("MEETING_ROOM_BOOKING", "_CREATE", session)) {
					%>
					<td class="lblbold">Checking Room:&nbsp;</td>
    				<td class="lblLight">
    					<select name="room">
			                <option value="" selected>ALL</option>
			                <option value="Training Room">Training Room</option>
			                <option value="Board Room">Board Room</option>
			                <option value="Demo Room">Demo Room</option>
			                <option value="Small Room">Small Room</option>
			                <option value="Meeting Room 12F">Meeting Room 12F</option>
			              </select>
					</td>
					<% } %>
			    	<td colspan=2 align="middle">
			    		<input type="button"  name="btnQuery"  value="Query" class="button" onclick="fnQuery()">
			    		<%
						if (AOFSECURITY.hasEntityPermission("MEETING_ROOM_BOOKING", "_CREATE", session)) {
						%>
						<input type="button" name="btnAdd" value="New" class="button" onclick="fnAdd()">
						<% } %>
					</td>
				</tr>
				<tr>
					<td colspan=6 valign="top"><hr color=red></hr></td>
				</tr>
			</table>
			<table border="0" cellpadding="2" cellspacing="2" width=100%>
				<%
				List valueList = (List)request.getAttribute("valueList");
				if(valueList == null){
					out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
				} else if(valueList.size()==0){
				%>
				<tr bgcolor="#e9eee9">
					<td align=center class="lblbold">&nbsp;Date&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Period&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Person&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Training Room&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Board Room&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Demo Room&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Small Room&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Meeting Room 12F&nbsp;</td>
				</tr>
				<%
					int colorFlag1 = 0;
					for(int i = 0; i< 7; i++){
						String b1 = "";
						if ((colorFlag1%2) == 1){
		             		b1="#DBF0FF"; 
		             	 } else {
		              		b1="#E4EAC1"; 
		              	}
						Date tmpDate = UtilDateTime.getDiffDay(startDay,i);				
				%>
				<tr bgcolor=<%=b1%>>
					<td nowrap align=center class="lblbold"><%=weekFormater.format(tmpDate)%></td>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<td nowrap align=center class="lblbold">&nbsp;</td>										
					<td nowrap align=center class="lblbold">&nbsp;</td>					
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<td nowrap align=center class="lblbold">&nbsp;</td>
	            </tr>
				<%
						colorFlag1++;
					}
				} else {
				%>
				<tr bgcolor="#e9eee9">
					<td align=center class="lblbold">&nbsp;Date&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Period&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Person&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Training Room&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Board Room&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Demo Room&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Small Room&nbsp;</td>
					<td align=center class="lblbold">&nbsp;Meeting Room 12F&nbsp;</td>
				</tr>
				<%
					int colorFlag2 = 0;
					
					for(int j = 0; j<7; j++){
					
						String b2 = "";
							if ((colorFlag2%2) == 1){
		             			b2="#DBF0FF"; 
		             	 	} else {
		              			b2="#E4EAC1"; 
		              		}
		              		
						boolean haveDate = false;
						
						Date tmpDate = UtilDateTime.getDiffDay(startDay,j);	
						String strTmpDate = dateFormater.format(tmpDate).trim();
						
						for (int i =0; i < valueList.size(); i++) {
						
							BookingRoomVO tmpValue = (BookingRoomVO)valueList.get(i);
							String strValueDate = dateFormater.format(tmpValue.getBookingDate()).trim();
							
			              	if(strTmpDate.equals(strValueDate)){
			              		haveDate = true;
								if(i == 0){
				%>				
				<tr bgcolor=<%=b2%>>
					<td nowrap align=center class="lblbold"><%=weekFormater.format(tmpDate)%></td>
					<td nowrap align=center class="lblbold"><%=tmpValue.getStartTime()%>&nbsp;~&nbsp;<%=tmpValue.getEndTime()%></td>
					<td nowrap align=center class="lblbold"><%=tmpValue.getPerson().getName()%></td>
					<% if(tmpValue.getRoom().trim().equals("Training Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Board Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Demo Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Small Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Meeting Room 12F")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
	            </tr>
				<%
								} else {							
									BookingRoomVO valueComp = (BookingRoomVO)valueList.get(i-1);
									
									String date1 = dateFormater.format(tmpValue.getBookingDate());
									String date2 = dateFormater.format(valueComp.getBookingDate());
									
									if(date1.trim().equals(date2)){
				%>
				<tr bgcolor=<%=b2%>>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<td nowrap align=center class="lblbold"><%=tmpValue.getStartTime()%>&nbsp;~&nbsp;<%=tmpValue.getEndTime()%></td>
					<td nowrap align=center class="lblbold"><%=tmpValue.getPerson().getName()%></td>
					<% if(tmpValue.getRoom().trim().equals("Training Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Board Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Demo Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Small Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Meeting Room 12F")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
				</tr>
				<%								
									} else {
				%>
				<tr bgcolor=<%=b2%>>
					<td nowrap align=center class="lblbold"><%=weekFormater.format(tmpDate)%></td>
					<td nowrap align=center class="lblbold"><%=tmpValue.getStartTime()%>&nbsp;~&nbsp;<%=tmpValue.getEndTime()%></td>
					<td nowrap align=center class="lblbold"><%=tmpValue.getPerson().getName()%></td>
					<% if(tmpValue.getRoom().trim().equals("Training Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Board Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Demo Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Small Room")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
					<% if(tmpValue.getRoom().trim().equals("Meeting Room 12F")) {%>					
					<td nowrap align=center class="lblbold">booking</td>
					<% } else { %>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<% } %>
	            </tr>
				<%
									}
								}
							}
						}
						if(!haveDate){
				%>
				<tr bgcolor=<%=b2%>>
					<td nowrap align=center class="lblbold"><%=weekFormater.format(tmpDate)%></td>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<td nowrap align=center class="lblbold">&nbsp;</td>										
					<td nowrap align=center class="lblbold">&nbsp;</td>					
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<td nowrap align=center class="lblbold">&nbsp;</td>
					<td nowrap align=center class="lblbold">&nbsp;</td>
	            </tr>
	            <%
						}
						colorFlag2++;
					}
				}
				%>
			</table>
		</form>
	</td></tr>
</table>
<%
	}else{
		out.println("!!你没有相关访问权限!!");
	}
} catch(Exception ex) {
	ex.printStackTrace();
}
%>
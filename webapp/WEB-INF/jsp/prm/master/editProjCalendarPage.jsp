<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.component.prm.master.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>

<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%try{%>
<%
if (AOFSECURITY.hasEntityPermission("PROJECT_CALENDAR", "_CREATE", session)) {
	int year = ((Integer)request.getAttribute("CurrentYear")).intValue(); 
	int month = ((Integer)request.getAttribute("CurrentMonth")).intValue(); 
	String typeId = (String)request.getAttribute("TypeId");
	List type = (List)request.getAttribute("TypeList");
	
	String action = request.getParameter("action");
%>

<script language="javascript">
	function doUpdate() {
		document.form2.submit();
	}
	
	function FnPerv() {
		document.form2.action.value = "view";
		<%
			if ((month - 1) < 0) {
		%>
		document.form2.year.value = "<%=year - 1%>";
		document.form2.month.value = "<%=month - 1 + 12%>";
		<%
			} else {
		%>
		document.form2.year.value = "<%=year%>";
		document.form2.month.value = "<%=month - 1%>";
		<%
			}
		%>
		
		document.form2.submit()
	}
	
	function FnNext() {
		document.form2.action.value = "view";
		
		<%
			if ((month + 1) > 11) {
		%>
		document.form2.year.value = "<%=year + 1%>";
		document.form2.month.value = "<%=month + 1 - 12%>";
		<%
			} else {
		%>
		document.form2.year.value = "<%=year%>";
		document.form2.month.value = "<%=month + 1%>";
		<%
			}
		%>
		
		document.form2.submit()
	}
</script>

<br>

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
           Working Calendar Maintenance
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
		<form Action="editProjCalendar.do" method="post" name="form1">
			<input type="hidden" name="action" value="view">
			<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
				marginWidth=0 noResize 
				scrolling=no src="includes/date/calendar.htm" 
				style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
			</IFRAME>
			<table width="100%" cellpadding="1" border="0" cellspacing="1">
				<tr>
					<td>
						<table cellspacing="5" cellpadding="5" width=100%>
							<tr>
								<td class="lblbold">Year :</td>
								<td align="left">
									<select name="year">
										<option value="<%=year - 1%>"><%=year - 1%></option>
										<option value="<%=year%>" selected><%=year%></option>
										<option value="<%=year + 1%>"><%=year + 1%></option>
				    				</select> 
                				</td>
                				<td class="lblbold">Month :</td>
								<td align="left">
									<select name="month">
										<%
											for (int i0 = 0; i0 < 12; i0++) {
										%>
										<option value="<%=i0%>" <%= i0 == month ? "selected" : ""%>><%=i0 + 1%></option>
										<%
											}
										%>
				    				</select> 
                				</td>
                				<td class="lblbold">Calendar Type :</td>
                				<td align="left">
									<select name="typeId">
										<%
											for (int i0 = 0; type != null && i0 < type.size(); i0++) {
												ProjectCalendarType projectCalendarType = (ProjectCalendarType)type.get(i0);
										%>
										<option value="<%=projectCalendarType.getTypeId()%>" <%=projectCalendarType.getTypeId().equals(typeId) ? "selected" : ""%>><%=projectCalendarType.getDescription()%></option>
										<%
											}
										%>
				    				</select> 
                				</td>
								<td class="lblbold">
									<input type="submit" value="Detail Information" class="loginButton"/>
								</td>
							</tr>
						</table>
					</td>
				</tr>	
			</table>
		</form>
 	 </td>
  </tr>
    <tr><td>&nbsp;</td></tr>
</table> 
  
<%
	if (action != null) {
%>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
	<TR>
    	<TD width='100%'>
      		<table width='100%' border='0' cellspacing='0' cellpadding='0'>
        		<tr>
          			<TD align=left width='90%' class="wpsPortletTopTitle">
           				Working Calendar Detail Information
          			</TD>
        		</tr>
      		</table>
    	</TD>
  	</TR>
  	
  	<TR>
    	<TD width='100%'>
			<form Action="editProjCalendar.do" method="post" name="form2">
				<input type="hidden" name="action" value="update">
				<input type="hidden" name="year" value="<%= year + ""%>">
				<input type="hidden" name="month" value="<%= month + ""%>">
				<input type="hidden" name="typeId" value="<%= typeId + ""%>">
				<table width="100%" cellpadding="1" border="0" cellspacing="1">
				<%
					Calendar capCalendar = Calendar.getInstance();
					capCalendar.set(year, month, 1);
					
					DateFormat formatter = new SimpleDateFormat("MMM yyyy", Locale.ENGLISH);
					DateFormat formatter2 = new SimpleDateFormat("MMM", Locale.ENGLISH);
					String noRecordFlg = (String)request.getAttribute("NoRecord");
				%>
				<caption class="pgheadsmall"><%=formatter.format(capCalendar.getTime())%></caption>
				<%
					if (noRecordFlg.equals("true")) {
				%>
						<tr>
							<td colspan="15" align='center'>
								<font color=red>
									The working calendar for <%=formatter2.format(capCalendar.getTime())%> has not been updated.
								</font>
							</td>
						</tr>
						<tr>
							<td colspan="15" align='center'>
								<font color=red>
									Please check and update.
								</font>
							</td>
						</tr>
				<%
					} else {
				%>
						<tr>
							<td colspan="15" align='center'>
								<font color=black>
									The working calendar for <%=formatter2.format(capCalendar.getTime())%> has been updated.
								</font>
							</td>
						</tr>
				<%
					}
				%>
				<%
					int[] weekArray = {Calendar.SUNDAY, 
					                   Calendar.MONDAY, 
					                   Calendar.TUESDAY, 
					                   Calendar.WEDNESDAY, 
					                   Calendar.THURSDAY, 
					                   Calendar.FRIDAY, 
					                   Calendar.SATURDAY};
				%>
					<tr bgcolor="#e9eee9">
						<td class="lblbold" align="center" colspan="2">&nbsp;SUNDAY&nbsp;</td>
						<td class="lblbold" align="center" colspan="2">&nbsp;MONDAY&nbsp;</td>
						<td class="lblbold" align="center" colspan="2">&nbsp;TUESDAY&nbsp;</td>
						<td class="lblbold" align="center" colspan="2">&nbsp;WEDNESDAY&nbsp;</td>
						<td class="lblbold" align="center" colspan="2">&nbsp;THURSDAY&nbsp;</td>
						<td class="lblbold" align="center" colspan="2">&nbsp;FRIDAY&nbsp;</td>
						<td class="lblbold" align="center" colspan="2">&nbsp;SATURDAY&nbsp;</td>			
					</tr>
					<%
						List resultList = (List)request.getAttribute("ResultList");
						int count = 0;
						for (int i0 = 0; i0 < resultList.size(); i0++, count++) {
							ProjectCalendar projectCalendar = (ProjectCalendar)resultList.get(i0);
							Calendar calendar = Calendar.getInstance();
							calendar.setTime(projectCalendar.getCalendarDate());
							if (count % 7 == 0) {
					%>
						<tr bgcolor="#e9eee9">
					<%
							}
							
							if (i0 == 0) {
								//add blank td
								
								for (int j0 = 0; j0 < weekArray.length; j0++) {
									if (calendar.get(Calendar.DAY_OF_WEEK) == weekArray[j0]) {
										break;
									} else {
										count++;
					%>
							<td class="lblbold" colspan="2"></td>
					<%
									}
								}
							}
					%>
							<td class="lblbold" align="center">
								<%=calendar.get(Calendar.DATE)%>&nbsp;
							</td>
							<td align="center">
								<input type="hidden" name="Id" value="<%=projectCalendar.getId() != null ? projectCalendar.getId() + "" : ""%>">
								<input type="hidden" name="PC_Date_Year" value="<%=calendar.get(Calendar.YEAR)%>">
								<input type="hidden" name="PC_Date_Month" value="<%=calendar.get(Calendar.MONTH)%>">
								<input type="hidden" name="PC_Date_Date" value="<%=calendar.get(Calendar.DATE)%>">
								<input type="text" name="PC_Hours" size="2" value="<%=projectCalendar.getHours()%>">
							</td>
					<%
							if (count % 7 == 6) {	
					%>
						</tr>
					<%
							}
						}
					%>
					
					<%
						for (int i0 = 0; i0 < (7 - count % 7); i0++) {
					%>
						<td class="lblbold" colspan="2"></td>
					<%
						}
					%>
				</table>
			</form>
  		</td>
  	</tr>
  	
  	 <tr>
  	 	<td>
  	 		<table>
  	 			<tr>
		  	 		<td align="left">
						&nbsp;<input type="button" value="save" class="loginButton" onclick="doUpdate();">
			        </td>
			        <td align="center">
			        	<a href="javascript:FnPerv();"><image src="images/prev2.gif"  border="0"></a>  
			        	<a href="javascript:FnNext();"><image src="images/next.gif"  border="0"></a>  
			        </td>
			    </tr>
			</table>
  	 	</td>
     </tr>  
    <tr><td>&nbsp;</td></tr>
</table> 
				
<%
	}
%>

<%
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
<%}catch(Exception ex){ex.printStackTrace();}%>

<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%try{%>
<%if (AOFSECURITY.hasEntityPermission("PAS_RESOURCE_FORECAST", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat Date_formater1 = new SimpleDateFormat("MM-dd(EEE)");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(1);
Num_formater.setMinimumFractionDigits(1);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
String dateStart = request.getParameter("dateStart");
String dateEnd = request.getParameter("dateEnd");
String EmployeeId = request.getParameter("EmployeeId");
String departmentId = request.getParameter("departmentId");
if (EmployeeId == null) EmployeeId = "";
if (departmentId == null) departmentId = "";

if (dateStart==null) dateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-10));
if (dateEnd==null) dateEnd=Date_formater.format(nowDate);

Date dayStart = UtilDateTime.toDate2(dateStart + " 00:00:00.000");
Date dayEnd = UtilDateTime.toDate2(dateEnd + " 00:00:00.000");

Calendar calendar = Calendar.getInstance();
calendar.setTime(dayStart);

int count = 0;

List partyList_dep=null;
try{
	PartyHelper ph = new PartyHelper();
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
	if (partyList_dep == null) partyList_dep = new ArrayList();
	partyList_dep.add(0,ul.getParty());
}catch(Exception e){
	e.printStackTrace();
}
%>
<script language="javascript">
function SearchResult() {
	var formObj = document.frm;
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "QueryForList";
	formObj.target = "_self";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.frm;
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "ExportToExcel";
	formObj.target = "_self";
	formObj.submit();
}
</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> Resource Forecast Report</caption> 
<tr>
	<td>
		<Form action="pas.report.ResourceForecastRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction">
		<table width=100%>
			<tr>
				<td colspan=7 valign="bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Date Range :</td>
				<td class="lblLight">
					<input  type="text" class="inputBox" name="dateStart" size="12" value="<%=Date_formater.format(dayStart)%>"><A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.dateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
					~
					<input  type="text" class="inputBox" name="dateEnd" size="12" value="<%=Date_formater.format(dayEnd)%>"><A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.dateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
				</td>
				<td class="lblbold">Employee ID:</td>
				<td class="lblLight"><input  type="text" class="inputBox" name="EmployeeId" size="12" value="<%=EmployeeId%>"></td>
				<td class="lblbold">Department:</td>
				<td class="lblLight">
					<select name="departmentId">
					<%
					if (AOFSECURITY.hasEntityPermission("PAS_PM_REPORT", "_ALL", session)) {
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(departmentId)) {%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%} else{%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%}
						}
					}%>
					</select>
				</td>
				<%
				boolean zeroflag = false;
				if (request.getParameter("zeroflag") != null) zeroflag = true;
			    %>
				<td  class="lblbold"  align="left">
					<input type=checkbox class="checkboxstyle" name="zeroflag" value="Y" <%if (zeroflag) out.print("Checked");%>>
					Include External Staffs
				</td>
			</tr>
			
			<tr>
			    <td colspan=6 align="left"/>
				<td  align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult();return false">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel();return false">
				</td>

				
			</tr>
			<tr>
				<td colspan=7 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
	
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			
			Map resultMap = new TreeMap();
			
			if (sr!=null){
				for (int row =0; row < sr.getRowCount(); row++) {
					String staff = null;
					String date = null;
					if (sr.getDate(row,"date") != null) {
						date = Date_formater.format(sr.getDate(row,"date"));
					}
					staff = sr.getString(row,"name");
					
					Map dateMap = null;
					Map staffMap = null;
					
					if (resultMap.get(staff) != null) {
						staffMap= (Map)resultMap.get(staff);
					} else {
						staffMap = new HashMap();
						resultMap.put(staff, staffMap);
					}
					
					if (date != null) {
						if (staffMap.get(date) != null) {
							dateMap = (Map)staffMap.get(date);
						} else {
							dateMap = new HashMap();
							staffMap.put(date, dateMap);
						}
						
						Set forecastCustomerSet = null;
						if (dateMap.get("FORECAST_CUSTOMER_SET") != null) {
							forecastCustomerSet = (Set)dateMap.get("FORECAST_CUSTOMER_SET");
						} else {
							forecastCustomerSet = new HashSet();
							dateMap.put("FORECAST_CUSTOMER_SET", forecastCustomerSet);
						}
						if (sr.getObject(row, "proj") != null){
							forecastCustomerSet.add(sr.getString(row,"customer"));
						}else{
							forecastCustomerSet.add(sr.getString(row,"description"));
						}
					}
				}
			}

			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			} else if (sr != null) {
				%>
				<tr><td bgcolor="#e9eee1"></td>
				<%
					do {
				%>
						 <td class="lblbold" bgcolor="#e9eee1"><%=Date_formater1.format(calendar.getTime())%></td>			 
		    	<%
		    			count++;
						calendar.add(Calendar.DATE, 1);
					} while(calendar.getTime().compareTo(dayEnd) <= 0);
				%>
				</tr>
				<input type="hidden" name=dayCount value=<%=count%>
				<% 
				} //end if
			int cc =0;
			
			Date dateArray[];
				dateArray = new Date[count];
				calendar.setTime(dayStart);
				for (int c=0; c<count; c++){
					dateArray[c] = calendar.getTime();
					calendar.add(Calendar.DATE, 1);
				} //end for
			if(sr == null){
				out.println("<br><tr><td colspan='12' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {

			///---------------------------------		
				Iterator iterator = resultMap.keySet().iterator();
				while (iterator.hasNext()) {
					cc =cc+1;
					String b1 ="";
	           		if ((cc%2) == 1){ 
	             		b1="#DBF0FF"; 
	             	 } else {
	              		b1="#E4EAC1"; 
	              	}
					String staff = (String)iterator.next();
					Map staffMap = (Map)resultMap.get(staff);
					%>
					<tr > 
						<td  bgcolor=<%=b1%> class="lblbold" nowrap align=left><%=staff%></td>			
				<%	
					if(staffMap.keySet().size() == 0){
						for (int ic =0; ic < count; ic++){
							calendar.setTime(dateArray[ic]);
							if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
											&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
				%>
								<td  bgcolor=<%=b1%> class="lblbold" nowrap align=left></td>
				<%			}else{
				%>
								<td bgcolor="#E4E4E4"></td> 
				<%			}
						} // end for
					} else { //end if
						int nr=0;
						int or=0;
						for (int col = 0; col < dateArray.length; col++) {
							nr=or;
							calendar.setTime(dateArray[col]);
							
							Iterator staffMapItr = staffMap.keySet().iterator();
							while (staffMapItr.hasNext()) {
								String date = (String)staffMapItr.next();
								if (Date_formater.format(dateArray[col]).equals(date)) {
									nr++;
									Map dateMap = (Map)staffMap.get(date);
									Set forecastCustomerSet = (Set)dateMap.get("FORECAST_CUSTOMER_SET");
									Iterator custSetItr = forecastCustomerSet.iterator();
									String cust="";
									int ct = 0;
									while (custSetItr.hasNext()){
										if (ct==0){
											cust = (String)custSetItr.next();
										}else{
											cust = cust + " , " + (String)custSetItr.next();
										}
										ct++;
									}
									if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
											&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
					%>
										<td bgcolor=<%=b1%> class="lblbold"><%=cust%></td>
					<%				}else{
					%>
										<td bgcolor="#E4E4E4" class="lblbold"><%=cust%></td>
					<%
									}
								}//end if
							}// end while
							if ((nr==or)){
								if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
											&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
					%>
								<td  bgcolor=<%=b1%> class="lblbold" nowrap align=left></td>
					<%
								}else{
					%>
								<td bgcolor="#E4E4E4"></td>
					<%
								}
							}
						}//end date array for
					} // end if else
				%>
					</tr>
				<%
				} //end resultMap while
			}//end else
				%>
		</table>
	</td>
</tr>
</table>

<%
}else{
	out.println("没有访问权限。");
}
%>
<%}catch(Exception e){
			e.printStackTrace();
		}%>
<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.report.*"%>
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
<%if (AOFSECURITY.hasEntityPermission("PAS_ACTUAL_FORECAST", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat Date_formater1 = new SimpleDateFormat("MM-dd(EEE)");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
String dateStart = request.getParameter("dateStart");
String dateEnd = request.getParameter("dateEnd");
String EmployeeId = request.getParameter("EmployeeId");
String departmentId = request.getParameter("departmentId");
String billable = request.getParameter("Billable");
if (EmployeeId == null) EmployeeId = "";
if (departmentId == null) departmentId = "";
if (billable == null) billable = "";

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
<caption class="pgheadsmall"> Resource Forecast / Actual Report</caption> 
<tr>
	<td>
		<Form action="pas.report.ActualVSForecastRpt.do" name="frm" method="post">
		<input type="hidden" name="FormAction" id="FormAction">
		<table width=100%>
			<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
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
			</tr>
			<%
				boolean zeroflag = false;
				if (request.getParameter("zeroflag") != null) zeroflag = true;
			%>
			<tr>
				<td class="lblbold">Billable:</td>
				<td class="lblbold"  align="left">&nbsp; 
				<SELECT
					name="Billable" >
					<option value="all"  <%if (billable.equals("all"))out.print("selected");%>>all</option>
					<option value="non-billable" <%if (billable.equals("non-billable"))out.print("selected");%>>non-billable</option>
					<option value="billable" <%if (billable.equals("billable"))out.print("selected");%>>billable</option>
				</SELECT></td>
				<td class="lblbold" colspan="2" align="left"><input type=checkbox
					class="checkboxstyle" name="zeroflag" value="Y"
					<%if (zeroflag) out.print("Checked");%>> Include External Staffs</td>
				<td colspan=2 align="left"><input TYPE="button" class="button"
					name="btnSearch" value="Query"
					onclick="javascript: SearchResult();return false"> <input
					TYPE="button" class="button" name="btnExport" value="Export Excel"
					onclick="javascript:ExportExcel();return false"></td>

			</tr>
			<tr>
				<td colspan=6 valign="top"><hr color=red></hr></td>
			</tr>
		</table>
		</form>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
	
			<%
			SQLResults fsr = (SQLResults)request.getAttribute("forecastQryList");
	//------------------------------------------------------
			Map resultMap = new TreeMap();
			if (fsr!=null){
				for (int row =0; row < fsr.getRowCount(); row++) {
					String staff = null;
					String date = null;
					if (fsr.getDate(row,"date") != null) {
						date = Date_formater.format(fsr.getDate(row,"date"));
					}
					staff = fsr.getString(row,"name");
					
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
						AFCustomer AFCustomer;
						if (dateMap.get(date) != null) {
							AFCustomer = (AFCustomer)dateMap.get(date);
						} else {
							AFCustomer = new AFCustomer();
							dateMap.put(date, AFCustomer);
						}
						if (fsr.getObject(row, "proj") != null){
							AFCustomer.addForcastCustomer(fsr.getString(row,"customer"));
						}else{
							AFCustomer.addForcastCustomer(fsr.getString(row,"description"));
						}
					}
				}
			}
	//----------------------------------------------
	
			SQLResults asr = (SQLResults)request.getAttribute("actualQryList");
			if (asr!=null){
				for (int row =0; row < asr.getRowCount(); row++) {
					String aStaff = null;
					String aDate = null;
					if (asr.getDate(row,"adate") != null) {
						aDate = Date_formater.format(asr.getDate(row,"adate"));
					}
					aStaff = asr.getString(row,"name");
					Map dateMap = null;
					Map staffMap = null;
					
					if (resultMap.get(aStaff) != null) {
						staffMap= (Map)resultMap.get(aStaff);
					} else {
						staffMap = new HashMap();
						resultMap.put(aStaff, staffMap);
					}
					
					if (aDate != null) {
						if (staffMap.get(aDate) != null) {
							dateMap = (Map)staffMap.get(aDate);
						} else {
							dateMap = new HashMap();
							staffMap.put(aDate, dateMap);
						}
						
						AFCustomer ACustomer;
			
						if (dateMap.get(aDate) != null) {
							ACustomer = (AFCustomer)dateMap.get(aDate);
						} else {
							ACustomer = new AFCustomer();
							dateMap.put(aDate, ACustomer);
						}

						ACustomer.addActualCustomer(asr.getString(row,"acustomer"));
					}
				}
			}
			
	//----------------------------------------------

			Object resultSet_data;
			boolean findData =  true;
			if(fsr == null){
				findData = false;
			} else if (fsr.getRowCount() == 0) {
				findData = false;
			} else if (fsr != null){
				%>
				<tr ><td rowspan=2 bgcolor="#e9eee5" class="lblbold" align=center>Staff</td>
				
				<%
					do {
				%>
						 <td colspan=2 align=center class="lblbold" bgcolor="#e9eee1"><%=Date_formater1.format(calendar.getTime())%></td>			 
		    	<%
		    			count++;
						calendar.add(Calendar.DATE, 1);
					} while(calendar.getTime().compareTo(dayEnd) <= 0);
					
					 if(billable.equals("billable")){
				 %>
				 <td rowspan=2 bgcolor="#e9eee5" class="lblbold" align=center>Accurate Rate</td>
				 <%
				 }
				%>
				
				</tr>
				
				<tr>
					<%
					for(int t =0; t<count; t++){
				%>
						 <td align=center class="lblbold" bgcolor="#e9eee1">Forecast</td>		
						 <td align=center class="lblbold" bgcolor="#e9eee1">&nbsp;Actual&nbsp;</td>	 
		    	<%
		    		} 
				%>
				</tr>
				<input type="hidden" name="dayCount" id="dayCount" value=<%=count%>>
				<% 
				
			}
			int cc =0;
			Date dateArray[];
				dateArray = new Date[count];
				calendar.setTime(dayStart);
				for (int c=0; c<count; c++){
					dateArray[c] = calendar.getTime();
					calendar.add(Calendar.DATE, 1);
				}
			if(!findData){
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
					int acRate=0;
					int day=0;
					Map staffMap = (Map)resultMap.get(staff);
					%>
					<tr > 
						<td  bgcolor=<%=b1%> class="lblbold" nowrap align=left ><%=staff%></td>	
						
								
				<%	
					if(staffMap.keySet().size() == 0){
					    
					
						for (int ic =0; ic < count; ic++){
							calendar.setTime(dateArray[ic]);
							if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
											&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
				%>
								<td  bgcolor=<%=b1%> class="lblbold" nowrap align=left></td>
								<td  bgcolor=<%=b1%> class="lblbold" nowrap align=left></td>
				<%			}else{
				%>
								<td bgcolor="#E4E4E4"></td> 
								<td bgcolor="#E4E4E4"></td>
				<%			}
						} // end for
						
						if (billable.equals("billable")){
					
							%>
							<td  bgcolor=<%=b1%> class="lblbold" nowrap align=left >
							</td>
							
						<%	}
						
				
					} else { //end if
						int nr=0;
						int or=0;
						int anr=0;
						int aor=0;
						AFCustomer AFCustomer = new AFCustomer();
						for (int col = 0; col < dateArray.length; col++) {
						    String accuCust="";
						    String forcCust="";
							nr=or;
							anr=aor;
							calendar.setTime(dateArray[col]);
							
							Iterator staffMapItr = staffMap.keySet().iterator();
							while (staffMapItr.hasNext()) {
								String date = (String)staffMapItr.next();
								Map dateMap = (Map)staffMap.get(date);
								
								if (Date_formater.format(dateArray[col]).equals(date)) {
									AFCustomer = (AFCustomer)dateMap.get(date);	
									if (AFCustomer != null){
										if((AFCustomer.getForcastCustomerSet() !=null) ){
											nr++;
											Set forecastCustomerSet = AFCustomer.getForcastCustomerSet();
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
											forcCust=cust;
											if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
													&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
							%>
												<td bgcolor=<%=b1%> class="lblbold"><%=cust%></td>
							<%				}else{
							%>
												<td bgcolor="#E4E4E4" class="lblbold"><%=cust%></td>
							<%
											}

										}
										
										if((AFCustomer.getActualCustomerSet() !=null) ){
											anr++;
											Set actualCustomerSet = AFCustomer.getActualCustomerSet();
											Iterator acustSetItr = actualCustomerSet.iterator();
											String acust="";
											int act = 0;
											while (acustSetItr.hasNext()){
												if (act==0){
													acust = (String)acustSetItr.next();
												}else{
													acust = acust + " , " + (String)acustSetItr.next();
												}
												act++;
											}
											accuCust=acust;
											if(!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
													&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
												if((AFCustomer.getForcastCustomerSet() !=null) && (AFCustomer.getForcastCustomerSet().size() >0)){
							%>
													<td bgcolor=<%=b1%> class="lblbold"><%=acust%></td>
							<%					}else{
													nr++;
							%>
													<td bgcolor=<%=b1%> class="lblbold"></td><td bgcolor=<%=b1%> class="lblbold"><%=acust%></td>
							<%					}
											}else{
												if((AFCustomer.getForcastCustomerSet() !=null) && (AFCustomer.getForcastCustomerSet().size() >0) ){
							%>
													<td bgcolor="#E4E4E4" class="lblbold"><%=acust%></td>
							<%					}else{
													nr++;
							%>
													<td bgcolor="#E4E4E4" class="lblbold"></td><td bgcolor="#E4E4E4" class="lblbold"><%=acust%></td>	
							<%					}
							
											}
											
										}
									}
								}//end if
							
				    }
							
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
							if ((anr==aor)){
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
							if (accuCust.equals(forcCust)&& accuCust.trim().length()!=0 &&!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
											&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
						       acRate=acRate+1;
							}
							if (!(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
											&& !(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)){
						       day=day+1;
							}
							
							
						}//end date array for
						if (billable.equals("billable")){
						  double rate=0;
						  if (day>0){
						  rate=((double)acRate*100)/day;
						  }
							%>
							<td  bgcolor=<%=b1%> class="lblbold" nowrap align=left ><%=Num_formater.format(rate)%>%
							</td>
							
						<%	}
				
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
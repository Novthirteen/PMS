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

<%if (AOFSECURITY.hasEntityPermission("PAS_UTL_REPORT", "_VIEW", session)) {%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat numFormat1 = NumberFormat.getInstance();
numFormat1.setMaximumFractionDigits(0);
numFormat1.setMinimumFractionDigits(0);
NumberFormat numFormat2 = NumberFormat.getInstance();
numFormat2.setMaximumFractionDigits(1);
numFormat2.setMinimumFractionDigits(1);
Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
String dateStart = request.getParameter("dateStart");
String dateEnd = request.getParameter("dateEnd");
String EmployeeId = request.getParameter("EmployeeId");
String departmentId = request.getParameter("departmentId");
if (EmployeeId == null) EmployeeId = "";
if (departmentId == null) departmentId = "";

if (dateStart==null) dateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
if (dateEnd==null) dateEnd=Date_formater.format(nowDate);

Date dayStart = UtilDateTime.toDate2(dateStart + " 00:00:00.000");
Date dayEnd = UtilDateTime.toDate2(dateEnd + " 00:00:00.000");
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
function sendMail() {
	var formObj = document.frm;
	
	var dataFirst = formObj.dateStart;
	var dataSecond = formObj.dateEnd;
	if(!dataCheck(dataFirst,dataSecond)){
      return false;
    }
    
	formObj.elements["FormAction"].value = "sendMail";
	formObj.target = "_self";
	formObj.submit();
}

function mailStatus(){
	var status = "<%=(String)request.getAttribute("emailFlag")%>";
	//alert(status);
	if(status != null || status!=""){
		if(status == "emailSucess"){
			alert("Emails have been sended sucessed!");		
		}else if(status == "emailFalse"){
			alert("Emails send false! There was an error occured during sending email.");
		}else if(status == "emailEmpty"){
			alert("There is no employee need to send email.");
		}
	}
	status = null;
}

mailStatus();

</script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> Utilization Report </caption> 
<tr>
	<td>
		<Form action="pas.report.TSStatusSummaryRpt.do" name="frm" method="post">
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
				boolean InternFlag = false;
				if (request.getParameter("InternFlag") != null) InternFlag = true;
			%>
			<td colspan =2></td>
			<td> <input type=checkbox class="checkboxstyle" name="InternFlag" value="Y" <%if (InternFlag) out.print("Checked");%>>
					Include Interns
			</td>
			<tr>
			</tr>
			<tr>
			    <td colspan=2 align="left"/>
				<td  align="left" colspan=2>
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript: SearchResult();return false">
					<input TYPE="button" class="button" name="btnExport" value="Export Excel" onclick="javascript:ExportExcel();return false">
				</td>
				<td  align="left" colspan=2>
					<input TYPE="button" class="button" name="btnSearch" value="Mail Notification To Outstanding TS Users" onclick="javascript: sendMail();return false">
				</td>
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
		<tr bgcolor="#e9eee9">
		<td align=center class="lblbold" rowspan="3">&nbsp;Dept.&nbsp;</td>
		<td align=center class="lblbold" rowspan="3">&nbsp;Staff ID&nbsp;</td>
		<td align=center class="lblbold" rowspan="3">&nbsp;Staff Name&nbsp;</td>
		<td align=center class="lblbold" rowspan="3">&nbsp;Total Working Hours&nbsp;</td>
		<td align=center class="lblbold" rowspan="3">&nbsp;Total Submitted Hours&nbsp;</td>
		<td colspan =3 align=center class="lblbold">Not Counted Hrs</td>
		<td colspan =4 align=center class="lblbold">Utilizable Hrs</td>
		<td colspan =9 align=center class="lblbold">Non-Utilizable Hrs</td>
		</tr>
		<tr bgcolor="#e9eee9">	
		<td align=center class="lblbold" rowspan="2">&nbsp;Unpaid Vacation&nbsp;</td>
		<td align=center class="lblbold" rowspan="2">&nbsp;Annual Leave&nbsp;</td>
		<td align=center class="lblbold" rowspan="2">&nbsp;Compensation Leave&nbsp;</td>
		<td align=center class="lblbold" rowspan="2">&nbsp;Submitted Billable Hours&nbsp;</td>
		<td align=center class="lblbold" rowspan="2">&nbsp;Approved Billable Hours&nbsp;</td>
		<td align=center class="lblbold" rowspan="2">&nbsp;Submitted Util.%&nbsp;</td>
		<td align=center class="lblbold" rowspan="2">&nbsp;Approved Util.%&nbsp;</td>
		<td colspan =5 align=center class="lblbold">Non-Billable Hrs</td>
<!--		<td colspan =4 align=center class="lblbold">Inactivity Hrs</td>-->
		<td colspan =3 align=center class="lblbold">Inactivity Hrs</td>
		</tr>
			<tr bgcolor="#e9eee9">
				<td align=center class="lblbold">&nbsp;Pre-sale&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Training&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Meeting &Mgt.&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Research &Devep.&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Travel&nbsp;</td>
				
				<td align=center class="lblbold">&nbsp;Exceptional Holidays&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Sickness&nbsp;</td>
				<td align=center class="lblbold">&nbsp;Bentch&nbsp;</td>
		<!--		<td align=center class="lblbold">&nbsp;Other Inactivity&nbsp;</td>-->
			</tr>
			
			<%
			SQLResults sr = (SQLResults)request.getAttribute("QryList");
			Object resultSet_data;
			boolean findData =  true;
			if(sr == null){
				findData = false;
			} else if (sr.getRowCount() == 0) {
				findData = false;
			}
			if(!findData){
				out.println("<br><tr><td colspan='21' class=lblerr align='center'>No Record Found.</td></tr>");
			} else {
			   double tolSumUtil=0.0;
			    double tolAprvUtil=0.0;
				for (int row =0; row < sr.getRowCount(); row++) {
					double temp1 = sr.getDouble(row,"working_hours");
					double temp2 = sr.getDouble(row,"total_UnpaidVacation_hours")+sr.getDouble(row,"total_AnnualLeave_hours")+sr.getDouble(row,"total_CompensationLeave_hours");
					double total_SubmittedBillable_hours = temp1-temp2;
				%>
					<tr bgcolor="#e9eee1"> 
						<td class="lblbold" nowrap align=left><%=(sr.getString(row,"description"))%></td>
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"e_id"))==null) ? "":resultSet_data)%></td>
						<td class="lblbold" nowrap align=left><%=(((resultSet_data = sr.getObject(row,"e_name"))==null) ? "":resultSet_data)%>
						<%if (sr.getString(row,"intern").equals("Y")){out.println("(Intern)");}
						 else if (sr.getString(row,"type").equals("FTE")){out.println("(FTE)");}%>
						 </td>
						 <%double workHr=sr.getDouble(row,"working_hours");
						   double tolSbmHr=sr.getDouble(row,"total_Submitted_hours");
						 %>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"working_hours"))%></td>
						<td nowrap align=right <%if (tolSbmHr<workHr){out.println("class=lblerr");}%>
						><%=numFormat1.format(sr.getDouble(row,"total_Submitted_hours"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_UnpaidVacation_hours"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_AnnualLeave_hours"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_CompensationLeave_hours"))%></td>
						<td nowrap align=right>
						<% if(sr.getString(row,"type").equals("FTE"))
							out.print(numFormat1.format(total_SubmittedBillable_hours));
						else
							out.print(numFormat1.format(sr.getDouble(row,"total_SubmittedBillable_hours")));%></td>
						<td nowrap align=right>
						<% if(sr.getString(row,"type").equals("FTE"))
							out.print(numFormat1.format(total_SubmittedBillable_hours));
						else
							out.print(numFormat1.format(sr.getDouble(row,"total_ApprovedBillable_hours")));%></td>
						<% 	double uti = 0;
						    double uti2 = 0;
						    uti2 = (sr.getDouble(row,"SubmittedUtil" ));
							uti = (sr.getDouble(row,"ApprovedUtil" ));
							if (uti > 100) uti =100;
							if (uti2 > 100) uti2 =100;
							if (sr.getString(row,"type").equals("FTE"))
							{
							uti=100;
							uti2=100;}
							tolSumUtil=tolSumUtil+uti2;
			                tolAprvUtil=tolAprvUtil+uti;
						%>
						<td nowrap align=right>
							<%=numFormat2.format( uti2 )%>
						</td>
						<td nowrap align=right>
							<%=numFormat2.format( uti )%>
						</td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_Presales_hours"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_Training_hours"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_MeetingAndMng_hours"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_RschAndDevp_hours"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_Travel_hours"))%></td>
						
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_ExcpHoliday_hours"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_Sickness_hours"))%></td>
						<td nowrap align=right><%=numFormat1.format(sr.getDouble(row,"total_Bench_hours"))%></td>
			<!--			<td nowrap align=right><%//=numFormat1.format(sr.getDouble(row,"total_otherInactivity_hours"))%></td>-->
						</tr>
				<%}%>
			
			<tr bgcolor="#e9eee1"> 
						<td class="lblbold" colspan="3" align=center>Total Rate</td>
						<td class="lblbold" colspan="7" align=left></td>
						<td  nowrap align=right><%=numFormat2.format(tolSumUtil/sr.getRowCount())%></td>
						<td  nowrap align=right><%=numFormat2.format(tolAprvUtil/sr.getRowCount())%></td>
						<td  nowrap align=center colspan="9"></td>
			</tr>	
				
				
		<%	}%>
		</table>
	</td>
</tr>
</table>

<%
}else{
	out.println("没有访问权限.");
}
%>
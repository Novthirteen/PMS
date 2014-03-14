<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.TimeSheet.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<HTML>
<HEAD>
<title>AO-SYSTEM</title>
<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
</HEAD>
<BODY>
<%try{%>
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>TimeSheet</CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
			<%
				String[] WeekArray = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" };
				SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
				String nowTimestampString = UtilDateTime.nowTimestamp().toString();
				
				String UserId = request.getParameter("UserId");
				String DepartmentId = request.getParameter("DepartmentId");
				String DataPeriod = request.getParameter("DataId");
			
				if(UserId == null ) UserId = "";
				if(DepartmentId == null ) DepartmentId = "";
			
				String DateStart = "";
				if (DataPeriod == null)  {
					DateStart = nowTimestampString;
				} else {
					DateStart = DataPeriod + " 00:00:00.000";
				}
			
				Date dayStart= UtilDateTime.toDate2(DateStart);
			
				int i;
				int DayCount = 7;
				
				String DayArray[];
				DayArray =  new String[DayCount];
				
				List MstrResult = (List)request.getAttribute("QryList");
				if(MstrResult == null){
					MstrResult = new ArrayList();
				}
				
				List DetResult = (List)request.getAttribute("QryDetail");
				if(DetResult==null){
					DetResult = new ArrayList();
				} 
				String FreezeFlag = (String)request.getAttribute("FreezeFlag");
				if (FreezeFlag == null) FreezeFlag = "N";
	
				Iterator itMstr = MstrResult.iterator();
				if (itMstr.hasNext()) {
					TimeSheetMaster tsm = (TimeSheetMaster)itMstr.next();
			%>
			<tr>
				<td class="lblbold"><bean:message key="prm.timesheet.departmentLable"/> :</td>
				<td class="lblLight"><%=tsm.getTsmUser().getParty().getDescription()%></td>
				<td class="lblbold"><bean:message key="prm.timesheet.userLable"/> :</td>
				<td class="lblLight"><%=tsm.getTsmUser().getName()%></td>	
				<td class="lblbold"><bean:message key="prm.timesheet.projectLable"/> :</td>
				<td class="lblLight">
					<%
						String ProjectId = request.getParameter("ProjectId");
						String ProjectNm = request.getParameter("ProjectNm");
						if (ProjectId == null) ProjectId = "";
						if (ProjectNm == null) ProjectNm = ""; 
					%>
					<%=ProjectId%>:<%=ProjectNm%>
				</td>	
				<td class="lblbold"></td>
			</tr>
			<%
				}
			%>
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr bgcolor="#e9eee9">
				<td rowspan=2 class="lblbold" align="center" width='15%'><bean:message key="prm.timesheet.eventLable"/></td>
				<td rowspan=2 class="lblbold" align="center" width='15%'><bean:message key="prm.timesheet.servicetypeLable"/></td>
				<td rowspan=2 class="lblbold" align="center" width='5%'>Need CAF</td>
				<%	
					for (i=0;i < DayCount;i++) {
						DayArray[i] = Date_formater.format(UtilDateTime.getDiffDay(dayStart,i));
				%>
					<td class="lblbold" align="center" valign="top" width='10%'><%=DayArray[i]%></td>
				<%
					}
				%>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.totalLable"/></td>
			</tr>
			<tr bgcolor="#e9eee9">
			<%for (i=0;i < DayCount;i++) {
					
				%>
					
					<td class="lblbold" align="center" width='10%'><%=WeekArray[i]%></td>
					
					<%
				}%>
			</tr>
			<%
			Iterator it = DetResult.iterator();
			String CurrPart = "";
			String DisplayText = "";
			String rowClass = "";
			String CAFDisplayText = "";
			String tsId = "";
			String CAFStatusUser = "";
			String fRead = "";
			String fDisable = "";
			String fCAF = "";
			String tsStatus = "";
			float rowCount = 0;
			float[] colCount = {0,0,0,0,0,0,0};
			float totalCount = 0;
			int MaxCol = DayCount;
			int col = MaxCol;
			int row = 0;
			if (it.hasNext()){
				while(it.hasNext()){
					DisplayText = "";
					TimeSheetDetail ts = (TimeSheetDetail)it.next();
					String NewPart = ts.getProject().getProjId() + "$" + ts.getProjectEvent().getPeventId().toString() + "$" + ts.getTSServiceType().getId().toString();
					String NewDate = Date_formater.format(ts.getTsDate());
					
					if (!NewPart.equals(CurrPart)) {
						for (col=col; col < MaxCol; col++) {
							tsId = " ";
							DisplayText = DisplayText+"<td>0.0</td>";
						}
						if (CurrPart != "" && col == MaxCol) {
							DisplayText = DisplayText+"<td align=right class=lblbold>"+rowCount+"</td></tr>";
						}
						rowClass = rowClass.equals("") ? "" : "";
						rowCount = 0;
						row++;

						if (ts.getStatus().trim().equals("Approved") || ts.getConfirm().trim().equals("Confirmed")){
							fRead=" ReadOnly Style='background-color:#A9A9A9'";
							fDisable = "Disabled";
						} else {
							fRead="";
							fDisable = "";
						}
						DisplayText = DisplayText+"<tr class='"+rowClass+"' align='right' bgcolor='#e9eee9'><td class='bottom' align='left'>"+ts.getProjectEvent().getPeventName()+"</td><td class='bottom' align='left'>"+ts.getTSServiceType().getDescription()+"</td><td class='bottom' align='left'>"+ts.getProject().getCAFFlag()+"</td>";
						%>
						<input type="hidden" name="projId" value = "<%=ts.getProject().getProjId()%>">
						<input type="hidden" name="PEventId" value = "<%=ts.getProjectEvent().getPeventId()%>">
						<input type="hidden" name="PSTId" value = "<%=ts.getTSServiceType().getId()%>">
						<%
						CurrPart = NewPart;
						col = 0;
					} else {
						if (ts.getStatus().trim().equals("Approved") || ts.getConfirm().trim().equals("Confirmed")){
							fRead=" ReadOnly Style='background-color:#A9A9A9'";
							fDisable = "Disabled";
						} else {
							fRead="";
							fDisable = "";
						}
					}
					while (!DayArray[col].equals(NewDate)) {
						tsId = " ";
						DisplayText = DisplayText+"<td>0.0</td>";
						col++;
					}
					tsId = ts.getTsId().toString();
					CAFStatusUser = ts.getCAFStatusUser().toString();
					if (CAFStatusUser.equals("Y")) {
						fCAF = "checked";
					} else {
						fCAF = "";
					}
					DisplayText = DisplayText+"<td>" + ts.getTsHoursUser().toString() + "</td>";

					totalCount = totalCount + ts.getTsHoursUser().floatValue();
					rowCount = rowCount + ts.getTsHoursUser().floatValue();
					colCount[col] = colCount[col] + ts.getTsHoursUser().floatValue();
					col++;
					out.println(DisplayText);
				}
				DisplayText ="";
				for (col=col; col < MaxCol; col++) {
					tsId = " ";
					DisplayText = DisplayText+"<td>0.0</td>";
				}
				DisplayText = DisplayText+"<td align=right class=lblbold id=tTot"+row+">"+rowCount+"</td></tr>";
				out.println(DisplayText);
				
			%>
			<tr align="center">
				<td align="left" colspan="3" class="lblbold"><bean:message key="prm.timesheet.totalLable"/>:</td>
				<td align="right" class="lblbold" id='tSubTot1'><%=colCount[0]%></td>
				<td align="right" class="lblbold" id='tSubTot2'><%=colCount[1]%></td>
				<td align="right" class="lblbold" id='tSubTot3'><%=colCount[2]%></td>
				<td align="right" class="lblbold" id='tSubTot4'><%=colCount[3]%></td>
				<td align="right" class="lblbold" id='tSubTot5'><%=colCount[4]%></td>
				<td align="right" class="lblbold" id='tSubTot6'><%=colCount[5]%></td>
				<td align="right" class="lblbold" id='tSubTot7'><%=colCount[6]%></td>
				<td align="right" class="lblbold" id='tTot'><%=totalCount%></td>
			</tr>
			<%totalCount = 0;%>
			<%
		      } else {
				DisplayText = "<tr><td colspan='13' align='center'>No Record Found.</td></tr>";
				out.println(DisplayText);
			  }
			%>
		</table>
	</td>
</tr>

<!--  -->
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
			<%
//				String[] WeekArray = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" };
//				SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
//				String nowTimestampString = UtilDateTime.nowTimestamp().toString();
				
//				String UserId = request.getParameter("UserId");
//				String DepartmentId = request.getParameter("DepartmentId");
//				String DataPeriod = request.getParameter("DataId");
			
//				if(UserId == null ) UserId = "";
//				if(DepartmentId == null ) DepartmentId = "";
			
//				String DateStart = "";
//				if (DataPeriod == null)  {
//					DateStart = nowTimestampString;
//				} else {
//					DateStart = DataPeriod + " 00:00:00.000";
//				}
			
				 dayStart= UtilDateTime.getNextWeekDay(UtilDateTime.toDate2(DateStart));
			
				 i=0;
//				int DayCount = 7;
				
//				String DayArray[];
//				DayArray =  new String[DayCount];
				
				MstrResult = (List)request.getAttribute("QryList2");
				if(MstrResult == null){
					MstrResult = new ArrayList();
				}
				
				DetResult = (List)request.getAttribute("QryDetail2");
				if(DetResult==null){
					DetResult = new ArrayList();
				} 
	
//				itMstr = MstrResult.iterator();
//				if (itMstr.hasNext()) {
//					TimeSheetMaster tsm = (TimeSheetMaster)itMstr.next();
			%>

			<%
//				}
			%>
		</table>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr bgcolor="#e9eee9">
				<td rowspan=2 class="lblbold" align="center" width='15%'><bean:message key="prm.timesheet.eventLable"/></td>
				<td rowspan=2 class="lblbold" align="center" width='15%'><bean:message key="prm.timesheet.servicetypeLable"/></td>
				<td rowspan=2 class="lblbold" align="center" width='5%'>Need CAF</td>
				<%	
					for (i=0;i < DayCount;i++) {
						DayArray[i] = Date_formater.format(UtilDateTime.getDiffDay(dayStart,i));
				%>
					<td class="lblbold" align="center" valign="top" width='10%'><%=DayArray[i]%></td>
				<%
					}
				%>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.totalLable"/></td>
			</tr>
			<tr bgcolor="#e9eee9">
			<%for (i=0;i < DayCount;i++) {
					
				%>
					
					<td class="lblbold" align="center" width='10%'><%=WeekArray[i]%></td>
					
					<%
				}%>
			</tr>
			<%
			it = DetResult.iterator();
			CurrPart = "";
			DisplayText = "";
			rowClass = "";
			CAFDisplayText = "";
			tsId = "";
			CAFStatusUser = "";
			fRead = "";
			fDisable = "";
			fCAF = "";
			tsStatus = "";
			rowCount = 0;
			totalCount = 0;
			for(int c=0;c<7;c++)
				colCount[c] = 0;
			MaxCol = DayCount;
			col = MaxCol;
			row = 0;
			if (it.hasNext()){
				while(it.hasNext()){
					DisplayText = "";
					TimeSheetDetail ts = (TimeSheetDetail)it.next();
					String NewPart = ts.getProject().getProjId() + "$" + ts.getProjectEvent().getPeventId().toString() + "$" + ts.getTSServiceType().getId().toString();
					String NewDate = Date_formater.format(ts.getTsDate());
					
					if (!NewPart.equals(CurrPart)) {
						for (col=col; col < MaxCol; col++) {
							tsId = " ";
							DisplayText = DisplayText+"<td>0.0</td>";
						}
						if (CurrPart != "" && col == MaxCol) {
							DisplayText = DisplayText+"<td align=right class=lblbold>"+rowCount+"</td></tr>";
						}
						rowClass = rowClass.equals("") ? "" : "";
						rowCount = 0;
						row++;

						if (ts.getStatus().trim().equals("Approved") || ts.getConfirm().trim().equals("Confirmed")){
							fRead=" ReadOnly Style='background-color:#A9A9A9'";
							fDisable = "Disabled";
						} else {
							fRead="";
							fDisable = "";
						}
						DisplayText = DisplayText+"<tr class='"+rowClass+"' align='right' bgcolor='#e9eee9'><td class='bottom' align='left'>"+ts.getProjectEvent().getPeventName()+"</td><td class='bottom' align='left'>"+ts.getTSServiceType().getDescription()+"</td><td class='bottom' align='left'>"+ts.getProject().getCAFFlag()+"</td>";
						%>
						<input type="hidden" name="projId" value = "<%=ts.getProject().getProjId()%>">
						<input type="hidden" name="PEventId" value = "<%=ts.getProjectEvent().getPeventId()%>">
						<input type="hidden" name="PSTId" value = "<%=ts.getTSServiceType().getId()%>">
						<%
						CurrPart = NewPart;
						col = 0;
					} else {
						if (ts.getStatus().trim().equals("Approved") || ts.getConfirm().trim().equals("Confirmed")){
							fRead=" ReadOnly Style='background-color:#A9A9A9'";
							fDisable = "Disabled";
						} else {
							fRead="";
							fDisable = "";
						}
					}
					while (!DayArray[col].equals(NewDate)) {
						tsId = " ";
						DisplayText = DisplayText+"<td width='10%'>0.0</td>";
						col++;
					}
					tsId = ts.getTsId().toString();
					CAFStatusUser = ts.getCAFStatusUser().toString();
					if (CAFStatusUser.equals("Y")) {
						fCAF = "checked";
					} else {
						fCAF = "";
					}
					DisplayText = DisplayText+"<td>" + ts.getTsHoursUser().toString() + "</td>";

					totalCount = totalCount + ts.getTsHoursUser().floatValue();
					rowCount = rowCount + ts.getTsHoursUser().floatValue();
					colCount[col] = colCount[col] + ts.getTsHoursUser().floatValue();
					col++;
					out.println(DisplayText);
				}
				DisplayText ="";
				for (col=col; col < MaxCol; col++) {
					tsId = " ";
					DisplayText = DisplayText+"<td>0.0</td>";
				}
				DisplayText = DisplayText+"<td align=right class=lblbold id=tTot"+row+">"+rowCount+"</td></tr>";
				out.println(DisplayText);
				
			%>
			<tr align="center">
				<td align="left" colspan="3" class="lblbold"><bean:message key="prm.timesheet.totalLable"/>:</td>
				<td align="right" class="lblbold" id='tSubTot1'><%=colCount[0]%></td>
				<td align="right" class="lblbold" id='tSubTot2'><%=colCount[1]%></td>
				<td align="right" class="lblbold" id='tSubTot3'><%=colCount[2]%></td>
				<td align="right" class="lblbold" id='tSubTot4'><%=colCount[3]%></td>
				<td align="right" class="lblbold" id='tSubTot5'><%=colCount[4]%></td>
				<td align="right" class="lblbold" id='tSubTot6'><%=colCount[5]%></td>
				<td align="right" class="lblbold" id='tSubTot7'><%=colCount[6]%></td>
				<td align="right" class="lblbold" id='tTot'><%=totalCount%></td>
			</tr>
			<%totalCount = 0;%>
			<%
		      } else {
				DisplayText = "<tr><td colspan='13' align='center'>No Record Found.</td></tr>";
				out.println(DisplayText);
			  }
			%>
		</table>
	</td>
</tr>


</table>
<%
request.removeAttribute("QryList");}
catch(Exception e)
{e.printStackTrace();}

%>

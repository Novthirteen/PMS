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
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
if (AOFSECURITY.hasEntityPermission("TIME_SHEET_FORECAST", "_CREATE", session)) {
	
	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	String nowTimestampString = UtilDateTime.nowTimestamp().toString();
	
	String UserId=request.getParameter("UserId");
	String DepartmentId=request.getParameter("DepartmentId");
	String DataPeriod=request.getParameter("DataId");

	if(UserId == null ) UserId = "";
	if(DepartmentId == null ) DepartmentId = "";

	String DateStart = "";
	if (DataPeriod == null)  {
		DateStart = nowTimestampString;
	} else {
		DateStart = DataPeriod + " 00:00:00.000";
	}

	Date dayStart= UtilDateTime.toDate2(DateStart);
	String NextDataPeriod=Date_formater.format(UtilDateTime.getDiffDay(dayStart,7));
	String LastDataPeriod=Date_formater.format(UtilDateTime.getDiffDay(dayStart,-7));


	int i;
	int DayCount = 7;
	
	List MstrResult = (List)request.getAttribute("QryMaster");
	if(MstrResult==null){
		MstrResult = new ArrayList();
	} 

	List DetResult = (List)request.getAttribute("QryDetail");
	if(DetResult==null){
		DetResult = new ArrayList();
	} 

	String DayArray[];
	DayArray =  new String[DayCount];
	String[] WeekArray = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" };
	boolean fNoFreeze = true;
	boolean addDelFreeze = false;
	boolean[] dayFreeze = new boolean[7];
	String[] dayRead = new String[7];
	int i0 = 0;
	for (; i0 >= UtilDateTime.getDayDistance(dayStart, (Date)UtilDateTime.nowTimestamp()) && Math.abs(i0) < 7; i0--) {
		dayFreeze[Math.abs(i0)] = true;
		dayRead[Math.abs(i0)] = " ReadOnly Style='background-color:#A9A9A9'";
	}
	if (Math.abs(i0) >= 7) {
		fNoFreeze = false;
	}

	if ( UtilDateTime.getDayDistance(dayStart, (Date)UtilDateTime.nowTimestamp()) <= 0) {
		addDelFreeze = true;
	}
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/projectSelect.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>

<script language="vbs">
function rndNum(tot)
 tot=FormatNumber(tot,2,-1,0,-1)
 rndNum=tot
end function
</script>

<script language="javascript">
window.onload=CalcTot;
function CalcTot()
{
	var oCust;
	var tot=0.00;
	var gtot=0.00;
	var oText;
	oCust=document.getElementsByName("projId");
	oText=document.getElementsByName("RecordVal1");
	var stot = new Array(oText.length);
	for(var j=0;j<oText.length;j++)
	{
		stot[j] = 0;
	}
	for(var i=0 ;i<oCust.length;i++)
	{
		var oAmt;
		oText=document.getElementsByName("RecordVal"+(i+1));
		tot=0.00;
		for(var j=0;j<oText.length;j++)
		{
			stot[j] = stot[j] + parseFloat(oText[j].value);
			tot = tot + parseFloat(oText[j].value);
		}
		var oTdtot=document.getElementById("tTot"+(i+1));
		oTdtot.innerHTML=rndNum(tot);
	}
	for(var j=0;j<stot.length;j++)
	{
		oText=document.getElementById("tSubTot"+(j+1));
		gtot = gtot + stot[j];
		oText.innerHTML=rndNum(stot[j]);
	}
	oTdtot=document.getElementById("tTot");
	if (oTdtot != null)	oTdtot.innerHTML=rndNum(gtot);
}
</script>

<script language="javascript">
function gotoNeighberWeek(newData)
{
	document.EditTimeSheetForm.DataId.value =newData;
	document.EditTimeSheetForm.submit();
}
function showDialog(UserId,DataPeriod) {
       
		var v = window.showModalDialog('system.showDialog.do?title=helpdesk.call.actiontype.new.title&projectSelect.do?SelectType=TSForecast&UserId='+ UserId + '&DataPeriod='+DataPeriod, null, 'dialogWidth:600px;dialogHeight:250px;status:no;help:no;scroll:no');
		if (v != null && v != "") {
			var vv = v.split("$");
		
			document.getElementById("hiddenProjectCode").value = vv[0];
			document.getElementById("hiddenEventCode").value = vv[1];
			document.getElementById("hiddenServiceType").value = vv[2];
			document.getElementById("hiddenDescription").value = vv[3];
			document.getElementById("FormAction").value = "create";
			
			document.EditTimeSheetForm.submit();
		}
	}
/*
function showDialog() {
	openProjectSelectDialog("onCloseDialog","EditTimeSheetForm");
}*/
function onCloseDialog() {
	var formObj = document.forms["EditTimeSheetForm"];
	setValue("EditTimeSheetForm","hiddenProjectCode","hiddenProjectCode");	
	setValue("EditTimeSheetForm","hiddenEventCode","hiddenEventCode");	
	setValue("EditTimeSheetForm","hiddenServiceType","hiddenServiceType");
	setValue("EditTimeSheetForm","hiddenDescription","hiddenDescription");
	formObj.elements["FormAction"].value = "create";
	formObj.submit();
}
function OnDelete() {
	var formObj = document.forms["EditTimeSheetForm"];
	var templineId;
	formObj.elements["FormAction"].value = "delete";
	formObj.submit();
}

function SaveRecords() {
	var formObj = document.forms["EditTimeSheetForm"];
	formObj.elements["FormAction"].value = "update";
	formObj.submit();
}
function BackToList() {
	var formObj = document.forms["EditTimeSheetForm"];
	formObj.elements["FormAction"].value = "back";
	formObj.submit();
}

</script>
<Form action="projectSelect.do?UserId=<%=UserId%>&DataPeriod=<%=DataPeriod%>&SelectType=TSForecast" name="ProjectSelectForm" method="post">
	<input type="hidden" name="CALLBACKNAME" id="CALLBACKNAME">
</Form>
<Form action="editTSForecast.do" name="EditTimeSheetForm" method="post">
<input type="hidden" name="FormAction" id="FormAction">
<input type="hidden" name="hiddenProjectCode" id="hiddenProjectCode">
<input type="hidden" name="hiddenEventCode" id="hiddenEventCode">
<input type="hidden" name="hiddenServiceType" id="hiddenServiceType">
<input type="hidden" name="hiddenDescription" id="hiddenDescription">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" id="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>  TimeSheet Forecast Maintenance </CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
			<%
				Iterator itMstr = MstrResult.iterator();
				if (itMstr.hasNext()) {
					TimeSheetForecastMaster tsm = (TimeSheetForecastMaster)itMstr.next();
			%>
			<tr>
				<td class="lblbold">Deparment :</td><td class="lblLight"><%=tsm.getTsmUser().getParty().getDescription()%></td>
				<td class="lblbold">User :</td><td class="lblLight"><%=tsm.getTsmUser().getName()%></td>	
				<td class="lblbold">Entry Period :</td><td class="lblLight"><%=DataPeriod%></td>
			</tr>
			<%}%>
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
				<%if (!addDelFreeze) {%>
				<td rowspan=2 class="lblbold" align="center" align=left width=2%><input type=checkbox name=chkAll value="" onclick="javascript:checkUncheckAllBox(document.EditTimeSheetForm.chkAll,document.EditTimeSheetForm.chk)"></td>
				<%}%>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.projectLable"/></td>
				<td rowspan=2 class="lblbold" align="center">Customer</td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.eventLable"/></td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.servicetypeLable"/></td>
				<td rowspan=2 class="lblbold" align="center">Need CAF</td>
				<%for (i=0;i < DayCount;i++) {
					DayArray[i] = Date_formater.format(UtilDateTime.getDiffDay(dayStart,i));
				%>
					<td class="lblbold" align="center" width="8%" valign="top"><%=DayArray[i]%></td>
					<%
				}%>
				<td rowspan=2 class="lblbold" align="center">Total</td>
			</tr>
			<tr bgcolor="#e9eee9">
			<%for (i=0;i < DayCount;i++) {%>
				<td class="lblbold" align="center"><%=WeekArray[i]%></td>
			<%}%>
			</tr>
			<%
			Iterator it = DetResult.iterator();
			String CurrPart = "";
			String CurrProj = "";
			String CurrEvent = "";
			String DisplayText = "";
			String rowClass = "";
			String tsId = "";
			
			int MaxCol = DayCount;
			int col = MaxCol;
			int row = 0;
			if (it.hasNext()){
				int count = 0;
				while(it.hasNext()){
					DisplayText = "";
					TimeSheetForecastDetail ts = (TimeSheetForecastDetail)it.next();
					String NewPart = "";
					if (ts.getProject() != null) {
						NewPart = ts.getProject().getProjId() + "$" + ts.getProjectEvent().getPeventId().toString() + "$" + ts.getTSServiceType().getId().toString();
					} else {
						NewPart = ts.getDescription();
					}
					String NewProj = "";
					if (ts.getProject() != null) {
						NewProj = ts.getProject().getProjId();
					} else {
						NewProj = ts.getDescription();
					}
					String NewEvent = "";
					if (ts.getProjectEvent() != null) {
						NewEvent = ts.getProjectEvent().getPeventId().toString();
					}
					String NewDate = Date_formater.format(ts.getTsDate());
					if (!NewPart.equals(CurrPart)) {
						for (col=col; col < MaxCol; col++) {
							tsId = "";
							DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId+"'><input type=text class=inputBox name=RecordVal"+row+" size=3 value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-24,24);CalcTot()' "+dayRead[count++]+"></td>";
						}
						count = 0;
						if (!CurrPart.equals("") && col == MaxCol) {
							DisplayText = DisplayText+"<td align=right class=lblbold id=tTot"+row+">0</td>";
						}
						rowClass = rowClass.equals("") ? "" : "";
						row++;
						DisplayText = DisplayText+"</tr><tr class='"+rowClass+"' align='right' bgcolor='#e9eee9'>";
						if (!addDelFreeze) {
							DisplayText = DisplayText+ "<td><input type=checkbox name='chk' value='"+row+"' onclick='javascript:checkTopBox(document.EditTimeSheetForm.chkAll,document.EditTimeSheetForm.chk)'></td>";
						}
						if (NewProj.equals(CurrProj)) {
							DisplayText = DisplayText+ "<td class='bottom' align='left'>&nbsp;</td><td class='bottom' align='left'>&nbsp;</td>";
							if (NewEvent.equals(CurrEvent)) {
								DisplayText = DisplayText+"<td class='bottom' align='left'>&nbsp;</td>";
							} else {
								DisplayText = DisplayText+"<td class='bottom' align='left'>"+ts.getProjectEvent().getPeventName()+"</td>";
							}
							DisplayText = DisplayText+"<td class='bottom' align='left'>"+ts.getTSServiceType().getDescription()+"</td><td class='bottom' align='left'>"+ts.getProject().getCAFFlag()+"</td>";
						} else {
							if (ts.getProject() != null) {
								DisplayText = DisplayText+ "<td class='bottom' align='left'>"+ts.getProject().getProjId()+":"+ts.getProject().getProjName()+"</td><td class='bottom' align='left' nowrap>"+ts.getProject().getCustomer().getDescription()+"</td><td class='bottom' align='left'>"+ts.getProjectEvent().getPeventName()+"</td><td class='bottom' align='left'>"+ts.getTSServiceType().getDescription()+"</td><td class='bottom' align='left'>"+ts.getProject().getCAFFlag()+"</td>";
							} else {
								DisplayText = DisplayText+ "<td class='bottom' align='left' colspan='5'>" + ts.getDescription()+"</td>";
							}
						}
						%>
						<input type="hidden" name="projId" id="projId" value = "<%=ts.getProject() != null ? ts.getProject().getProjId() : ""%>">
						<input type="hidden" name="PEventId" id="PEventId" value = "<%=ts.getProjectEvent() != null ? ts.getProjectEvent().getPeventId().toString() : ""%>">
						<input type="hidden" name="PSTId" id="PSTId" value = "<%=ts.getTSServiceType() != null ? ts.getTSServiceType().getId().toString() : ""%>">
						<input type="hidden" name="description" id="description" value = "<%=ts.getDescription()%>">
						<%
						CurrPart = NewPart;
						CurrProj = NewProj;
						CurrEvent = NewEvent;
						col = 0;
					}
					while ((col < MaxCol) && !DayArray[col].equals(NewDate)) {
						tsId = " ";
						DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=3  value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-24,24);CalcTot()' "+dayRead[count++]+"></td>";
						col++;
					}
					tsId = ts.getTsId().toString();
					DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId+"'><input type=text class=inputBox name=RecordVal"+row+" size=3  value='"+ts.getTsHoursUser().toString()+"' onblur='checkDeciNumber2(this,1,1,this.name,-24,24);CalcTot()' "+dayRead[count++]+"></td>";
					col++;
					out.println(DisplayText);
				}
				DisplayText ="";
				for (col=col; col < MaxCol; col++) {
					tsId = " ";
					DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=3  value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-24,24);CalcTot()' "+dayRead[count++]+"></td>";
				}
				DisplayText = DisplayText+"<td align=right class=lblbold id=tTot"+row+">0</td>";
				out.println(DisplayText);
				
			%>
			<tr align="center">
				<td align="left" colspan="<%
				if (!addDelFreeze) {
					out.println("6");
				} else {
					out.println("5");
				}
				%>" class="lblbold">Total:</td>
				<td align="center" class="lblbold" id='tSubTot1'>0</td>
				<td align="center" class="lblbold" id='tSubTot2'>0</td>
				<td align="center" class="lblbold" id='tSubTot3'>0</td>
				<td align="center" class="lblbold" id='tSubTot4'>0</td>
				<td align="center" class="lblbold" id='tSubTot5'>0</td>
				<td align="center" class="lblbold" id='tSubTot6'>0</td>
				<td align="center" class="lblbold" id='tSubTot7'>0</td>
				<td align="right" class="lblbold" id='tTot'>0</td>
			</tr>
			<%} else {
				DisplayText = "<tr><td colspan='14' align='center'>No Record Found.</td></tr>";
				out.println(DisplayText);
			}
			%>
			<tr align="center">
				<td align="left" colspan="14">
					&nbsp;&nbsp;&nbsp;&nbsp;
					
					<%if (!addDelFreeze) {%>
					<input TYPE="button" class="button" name="btnRow" value="Add Line" onclick="javascript: showDialog('<%=UserId%>','<%=DataPeriod%>')">&nbsp;&nbsp;
					<input TYPE="submit" class="button" name="Del" value="Delete" onclick="javascript: return OnDelete()">&nbsp;&nbsp;
					<%}%>
					<%if (fNoFreeze) {%>
					<input TYPE="button" class="button" name="Save" value="Save Record" onclick="javascript: SaveRecords()">&nbsp;&nbsp;
					<%}%>
					<input TYPE="button" class="button" name="Back" value="Back" onclick="javascript: BackToList()">
					
				</td>
			</tr>
			<tr>
			<td></td>
			<td align="center"  >
			        	<a href="javascript:gotoNeighberWeek('<%=LastDataPeriod%>')"><image src="images/prev2.gif"  border="0"></a>  
			        	<a href="javascript:gotoNeighberWeek('<%=NextDataPeriod%>')"><image src="images/next.gif"  border="0"></a>  
			        </td>
			  <td colspan="10">  </td>      
			</tr>
		</table>
	</td>
</tr>
</table>
<input type="hidden" name="UserId" id="UserId" value="<%=UserId%>">
<input type="hidden" name="DepartmentId" id="DepartmentId" value="<%=DepartmentId%>">
<input type="hidden" name="DataId" id="DataId" value="<%=DataPeriod%>">
<input type="hidden" name="LastDataId" id="LastDataId" value="<%=LastDataPeriod%>">
<input type="hidden" name="NextDataId" id="NextDataId" value="<%=NextDataPeriod%>">
</form>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}
Hibernate2Session.closeSession();
} catch(Exception ex) {ex.printStackTrace();}
%>
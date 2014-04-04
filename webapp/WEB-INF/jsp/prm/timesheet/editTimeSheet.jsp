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
if (AOFSECURITY.hasEntityPermission("TIME_SHEET", "_CREATE", session)) {
	
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
	String FreezeFlag = (String)request.getAttribute("FreezeFlag");
	Object[] CanNotRemoved = (Object[])request.getAttribute("CanNotRemoved");
	if (FreezeFlag == null) FreezeFlag = "N";

	String DayArray[];
	DayArray =  new String[DayCount];
		
	String[] WeekArray = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" };
	
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
	document.EditTimeSheetForm.action='editTimeSheet.do';
	document.EditTimeSheetForm.submit();
}


function showDialog(UserId,DataPeriod) {
       
		var v = window.showModalDialog('system.showDialog.do?title=helpdesk.call.actiontype.new.title&projectSelect.do?UserId='+ UserId + '&DataPeriod='+DataPeriod, null, 'dialogWidth:800px;dialogHeight:250px;status:no;help:no;scroll:no');

		if (v != null && v != "") {
			var vv = v.split("$");
		
			document.getElementById("hiddenProjectCode").value = vv[0];
			document.getElementById("hiddenEventCode").value = vv[1];
			document.getElementById("hiddenServiceType").value = vv[2];
			document.getElementById("FormAction").value = "create";
			document.EditTimeSheetForm.action='editTimeSheet.do';
			document.EditTimeSheetForm.submit();
		}
		
	}
/*
function showDialog() {
	openProjectSelectDialog("onCloseDialog","EditTimeSheetForm");
}*/

function onCloseDialog() {

	var formObj = document.forms["EditTimeSheetForm"];
	formObj.action = "editTimeSheet.do";
	setValue("EditTimeSheetForm","hiddenProjectCode","hiddenProjectCode");	

	setValue("EditTimeSheetForm","hiddenEventCode","hiddenEventCode");

	setValue("EditTimeSheetForm","hiddenServiceType","hiddenServiceType");

	formObj.elements["FormAction"].value = "create";

	formObj.submit();
}

function OnDelete() {
	var formObj = document.forms["EditTimeSheetForm"];
	formObj.action = "editTimeSheet.do";
	var templineId;
	formObj.elements["FormAction"].value = "delete";
	formObj.submit();
}
/*
function SaveRecords() {
	var formObj = document.forms["EditTimeSheetForm"];
	formObj.elements["FormAction"].value = "update";
	formObj.submit();
}
*/
function FetchForecast() {
	var formObj = document.forms["EditTimeSheetForm"];
	formObj.action = "editTimeSheet.do";
	formObj.elements["FormAction"].value = "UpdateFromForecast";
	formObj.submit();
}
function FetchTimeSheet() {
	var formObj = document.forms["EditTimeSheetForm"];
	formObj.action = "editTimeSheet.do";
	formObj.elements["FormAction"].value = "UpdateFromTS";
	formObj.submit();
}
function ExportExcel() {
	var formObj = document.forms["EditTimeSheetForm"];
	for (var j = 0; j < document.getElementsByName("chk").length; j++) {
		if(document.getElementsByName("chk")[j].checked){
		formObj.action = "pas.report.TSCAFPrint.do";
		formObj.submit();
		}
	}
}
function OnSave() {
		//document.rptForm.submit();
	var formObj = document.forms["EditTimeSheetForm"];
	formObj.action = "editTimeSheet.do";
	formObj.submit();
	}
function OnSubmit() {
		//document.rptForm.submit();
	var formObj = document.forms["EditTimeSheetForm"];
	formObj.SaveType.value="Submit Record";
	formObj.action = "editTimeSheet.do";
	formObj.submit();
	}

</script>

<Form  name="EditTimeSheetForm" method="post">
<input type="hidden" Id="FormAction" name="FormAction" value="update">
<input type="hidden" Id="hiddenProjectCode" name="hiddenProjectCode">
<input type="hidden" Id="hiddenEventCode" name="hiddenEventCode">
<input type="hidden" Id="hiddenServiceType" name="hiddenServiceType">
<input type="hidden" Id="<%=PageKeys.TOKEN_PARA_NAME%>" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall><bean:message key="prm.timesheet.maintenance.title"/></CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
			<%
				Iterator itMstr = MstrResult.iterator();
				if (itMstr.hasNext()) {
					TimeSheetMaster tsm = (TimeSheetMaster)itMstr.next();
			%>
			<tr>
				<td class="lblbold"><bean:message key="prm.timesheet.departmentLable"/> :</td><td class="lblLight"><%=tsm.getTsmUser().getParty().getDescription()%></td>
				<td class="lblbold"><bean:message key="prm.timesheet.userLable"/> :</td><td class="lblLight"><%=tsm.getTsmUser().getName()%></td>	
				<td class="lblbold"><bean:message key="prm.timesheet.entryPeriodLable"/> :</td><td class="lblLight"><%=DataPeriod%></td>
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
				<td rowspan=2 class="lblbold" align="center" align=left width=2%><input type=checkbox  class="checkboxstyle" name=chkAll value="" onclick="javascript:checkUncheckAllBox(document.EditTimeSheetForm.chkAll,document.EditTimeSheetForm.chk)"></td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.projectLable"/></td>
				<td rowspan=2 class="lblbold" align="center">Customer</td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.eventLable"/></td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.servicetypeLable"/></td>
				<td rowspan=2 class="lblbold" align="center">Status</td>
				<td rowspan=2 class="lblbold" align="center">Need CAF</td>
				<td rowspan=2 class="lblbold" align="center">CAF Print No.</td>
				<%for (i=0;i < DayCount;i++) {
					DayArray[i] = Date_formater.format(UtilDateTime.getDiffDay(dayStart,i));
				%>
					
					<td class="lblbold" align="center"><%=DayArray[i]%></td>
					
					<%
				}%>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.totalLable"/></td>
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
			String CurrCust = "";
			String CurrEvent = "";
			String DisplayText = "";
			String rowClass = "";
			String CAFDisplayText = "";
			String tsId = "";
			String CAFStatusUser = "";
			String fRead = "";
			String fDisable = "";
			String delDisable = "";
			String fCAF = "";
			String tsStatus = "";
			float rowCount = 0;
			float[] colCount = {0,0,0,0,0,0,0};
			float totalCount = 0;
			int MaxCol = DayCount;
			int col = MaxCol;
			int row = 0;
			if (it.hasNext()){
				int count = 0;
				while(it.hasNext()){
					DisplayText = "";
					TimeSheetDetail ts = (TimeSheetDetail)it.next();
					String NewPart = ts.getProject().getProjId() + "$" + ts.getProjectEvent().getPeventId().toString() + "$" + ts.getTSServiceType().getId().toString();
					String NewCust = ts.getProject().getCustomer().getDescription();
					String NewProj = ts.getProject().getProjId();
					String NewEvent = ts.getProjectEvent().getPeventId().toString();
					String NewDate = Date_formater.format(ts.getTsDate());
					
					if (!NewPart.equals(CurrPart)) {
						for (col=col; col < MaxCol; col++) {
							tsId = " ";
							DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=5 value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-24,24);CalcTot()' "+fRead+"></td>";
						}
						if (CurrPart != "" && col == MaxCol) {
							DisplayText = DisplayText+"<td align=right class=lblbold id=tTot"+row+">0</td></tr>";
						}
						rowClass = rowClass.equals("") ? "" : "";
						rowCount = 0;
						row++;

						if (ts.getStatus().trim().equals("Approved")){
							fRead=" ReadOnly Style='background-color:#A9A9A9'";
							fDisable = "Disabled";
						} else {
							fRead="";
							fDisable = "";
						}
						if (((Boolean)CanNotRemoved[count++]).booleanValue() && !fDisable.equals("Disabled")) {
							delDisable = "Disabled";
						} else {
							delDisable = "";
						}
						String StatusDisply = "";
						if (ts.getStatus().equals("Rejected")) {
							StatusDisply = "<td class='lblbold' align='center' nowrap><font color='#FF0000'>"+ts.getStatus()+"</font></td>";
						} else {
							StatusDisply = "<td class='bottom' align='center' nowrap>"+ts.getStatus()+"</td>";
						}
						String cafNO ="";
						if (ts.getCAFPrintDate()!= null){
							cafNO = ts.getCAFPrintDate();
						}
						if (NewProj.equals(CurrProj)) {
						//  Modification : the checkbox is enabled at any time , by Bill Yu
						//	DisplayText = DisplayText+"<tr class='"+rowClass+"' align='right' bgcolor='#e9eee9'><td><input class='checkboxstyle' type=checkbox name='"+(delDisable.trim().length() == 0 ? "chk" : "")+"' value='"+row+"' onclick='javascript:checkTopBox(document.EditTimeSheetForm.chkAll,document.EditTimeSheetForm.chk)' "+fDisable + delDisable+"></td><td class='bottom' align='left'>&nbsp;</td><td class='bottom' align='left'>&nbsp;</td>";			
							DisplayText = DisplayText+"<tr class='"+rowClass+"' align='right' bgcolor='#e9eee9'><td><input class='checkboxstyle' type=checkbox name='"+(delDisable.trim().length() == 0 ? "chk" : "")+"' value='"+row+"' onclick='javascript:checkTopBox(document.EditTimeSheetForm.chkAll,document.EditTimeSheetForm.chk)' " + delDisable+"></td><td class='bottom' align='left'>&nbsp;</td><td class='bottom' align='left'>&nbsp;</td>";											
							
							if (NewEvent.equals(CurrEvent)) {
								DisplayText = DisplayText+"<td class='bottom' align='left'>&nbsp;</td>";
							} else {
								DisplayText = DisplayText+"<td class='bottom' align='left' nowrap>"+ts.getProjectEvent().getPeventName()+"</td>";
							}
							DisplayText = DisplayText+"<td class='bottom' align='center' nowrap>"+ts.getTSServiceType().getDescription()+"</td>"+StatusDisply+"<td class='bottom' align='center' nowrap>"+ts.getProject().getCAFFlag()+"</td>"+"<td class='bottom' align='center' nowrap>"+cafNO+"</td>";
						} else {
						//  Modification : the checkbox is enabled at any time , by Bill Yu
						//	DisplayText = DisplayText+"<tr class='"+rowClass+"' align='right' bgcolor='#e9eee9'><td><input class='checkboxstyle' type=checkbox name='"+(delDisable.trim().length() == 0 ? "chk" : "")+"' value='"+row+"' onclick='javascript:checkTopBox(document.EditTimeSheetForm.chkAll,document.EditTimeSheetForm.chk)' "+fDisable + delDisable+"></td><td class='bottom' align='left' nowrap>"+ts.getProject().getProjId()+":"+ts.getProject().getProjName()+"</td><td class='bottom' align='left' nowrap>"+ts.getProject().getCustomer().getDescription()+"</td><td class='bottom' align='left' nowrap>"+ts.getProjectEvent().getPeventName()+"</td><td class='bottom' align='center' nowrap>"+ts.getTSServiceType().getDescription()+"</td>"+StatusDisply+"<td class='bottom' align='center' nowrap>"+ts.getProject().getCAFFlag()+"</td>"+"<td class='bottom' align='center' nowrap>"+cafNO+"</td>";
							DisplayText = DisplayText+"<tr class='"+rowClass+"' align='right' bgcolor='#e9eee9'><td><input class='checkboxstyle' type=checkbox name='"+(delDisable.trim().length() == 0 ? "chk" : "")+"' value='"+row+"' onclick='javascript:checkTopBox(document.EditTimeSheetForm.chkAll,document.EditTimeSheetForm.chk)' " + delDisable+"></td><td class='bottom' align='left' nowrap>"+ts.getProject().getProjId()+":"+ts.getProject().getProjName()+"</td><td class='bottom' align='left' nowrap>"+ts.getProject().getCustomer().getDescription()+"</td><td class='bottom' align='left' nowrap>"+ts.getProjectEvent().getPeventName()+"</td><td class='bottom' align='center' nowrap>"+ts.getTSServiceType().getDescription()+"</td>"+StatusDisply+"<td class='bottom' align='center' nowrap>"+ts.getProject().getCAFFlag()+"</td>"+"<td class='bottom' align='center' nowrap>"+cafNO+"</td>";
						}
						%>
						<input type="hidden" name="projId" id="projId" value = "<%=ts.getProject().getProjId()%>">
						<input type="hidden" name="PEventId" id="PEventId" value = "<%=ts.getProjectEvent().getPeventId()%>">
						<input type="hidden" name="PSTId" id="PSTId" value = "<%=ts.getTSServiceType().getId()%>">
						<%
						CurrPart = NewPart;
						CurrProj = NewProj;
						CurrEvent = NewEvent;
						col = 0;
					} else {
						if (ts.getStatus().trim().equals("Approved")){
							fRead=" ReadOnly Style='background-color:#A9A9A9'";
							fDisable = "Disabled";
						} else {
							fRead="";
							fDisable = "";
						}
					}
					while (!DayArray[col].equals(NewDate)) {
						tsId = " ";
						DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=5  value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-24,24);CalcTot()' "+fRead+"></td>";
						col++;
					}
					tsId = ts.getTsId().toString();
					CAFStatusUser = ts.getCAFStatusUser().toString();
					if (CAFStatusUser.equals("Y")) {
						fCAF = "checked";
					} else {
						fCAF = "";
					}
					DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=5  value='"+ts.getTsHoursUser().toString()+"' onblur='checkDeciNumber2(this,1,1,this.name,-24,24);CalcTot()' "+fRead+"></td>";

					totalCount = totalCount + ts.getTsHoursUser().floatValue();
					rowCount = rowCount + ts.getTsHoursUser().floatValue();
					colCount[col] = colCount[col] + ts.getTsHoursUser().floatValue();
					col++;
					out.println(DisplayText);
				}
				DisplayText ="";
				for (col=col; col < MaxCol; col++) {
					tsId = " ";
					DisplayText = DisplayText+"<td><input type=hidden name=tsId"+row+" id=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=5  value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-24,24);CalcTot()' "+fRead+"></td>";
				}
				DisplayText = DisplayText+"<td align=right class=lblbold id=tTot"+row+">0</td></tr>";
				out.println(DisplayText);
				
			%>
			<tr align="center">
				<td align="left" colspan="8" class="lblbold"><bean:message key="prm.timesheet.totalLable"/>:</td>
				<td align="center" class="lblbold" id='tSubTot1'>0</td>
				<td align="center" class="lblbold" id='tSubTot2'>0</td>
				<td align="center" class="lblbold" id='tSubTot3'>0</td>
				<td align="center" class="lblbold" id='tSubTot4'>0</td>
				<td align="center" class="lblbold" id='tSubTot5'>0</td>
				<td align="center" class="lblbold" id='tSubTot6'>0</td>
				<td align="center" class="lblbold" id='tSubTot7'>0</td>
				<td align="right" class="lblbold" id='tTot'>0</td>
			</tr>
			<%totalCount = 0;%>
			<%} else {
				DisplayText = "<tr><td colspan='12' align='center'>No Record Found.</td></tr>";
				if (FreezeFlag.equals("N")) {
					DisplayText = DisplayText + "<tr><td colspan='12' align='center'>You can click <a href ='javascript:FetchForecast();'>here</a> to confirm this week's Time Sheet Forecast.</td></tr>";
					DisplayText = DisplayText + "<tr><td colspan='12' align='center'>Or click <a href ='javascript:FetchTimeSheet();'>here</a> to copy last week's Time Sheet data.</td></tr>";
				}
				out.println(DisplayText);
			}
			%>
			<tr align="center">
				<td align="left" colspan="12">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<%if (FreezeFlag.equals("N")) {%> 
					<input TYPE="button" class="button" Id="btnRow" name="btnRow" value="Add Line" onclick="javascript: showDialog('<%=UserId%>','<%=DataPeriod%>')">&nbsp;&nbsp;
					<input TYPE="button" class="button" Id="Del" name="Del" value="Delete Selected" onclick="javascript: OnDelete()">&nbsp;&nbsp;
					<input TYPE="submit" class="button" Id="SaveType" name="SaveType" value="Save Record" onclick="javascript: document.EditTimeSheetForm.action='editTimeSheet.do'">&nbsp;&nbsp;
					<input TYPE="submit" class="button" Id="SaveType" name="SaveType" value="Submit Record" onclick="javascript: document.EditTimeSheetForm.action='editTimeSheet.do'">&nbsp;&nbsp;
					<%}%>
					<input TYPE="button" class="button" name="Back" value="Back" onclick="javascript:location.replace('listTimeSheet.do')">
					&nbsp;&nbsp;&nbsp;
					
					 <input type="button" value="Print selected CAF" name="Print" class="button" onclick="javascript:ExportExcel()">
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
			<!-- Modification : display a warning that approved records cannot be deleted , by Bill Yu -->
			<%
				Object sign = request.getAttribute("deleteWarn");
			%>
			<%if(sign!=null){%>
				<tr><td colspan="12"></td></tr>
				<tr>
					<td colspan="12">
						<div style="font-size:12px;color:red">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							Approved records can not be deleted !
						</div>
					</td>
				</tr>
			<%}%>
		</table>
	</td>
</tr>
</table>
<input type="hidden" Id="UserId" name="UserId" value="<%=UserId%>">
<input type="hidden" Id="DepartmentId" name="DepartmentId" value="<%=DepartmentId%>">
<input type="hidden" Id="DataId" name="DataId" value="<%=DataPeriod%>">
<input type="hidden" Id="LastDataId" name="LastDataId" value="<%=LastDataPeriod%>">
<input type="hidden" Id="NextDataId" name="NextDataId" value="<%=NextDataPeriod%>">

</form>



<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}

		//Hibernate2Session.closeSession();
} catch(Exception ex) {ex.printStackTrace();}
%>
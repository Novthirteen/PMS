<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.TimeSheet.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.prm.payment.*"%>
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
if (AOFSECURITY.hasEntityPermission("TIME_SHEET", "_CAF", session)) {
	
	SimpleDateFormat Date_formater = new SimpleDateFormat("MM/dd(EEE)", Locale.ENGLISH);
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
	SimpleDateFormat Date_formater2= new SimpleDateFormat("yyyy-MM-dd");
	String NextDataPeriod=Date_formater2.format(UtilDateTime.getDiffDay(dayStart,7));
	String LastDataPeriod=Date_formater2.format(UtilDateTime.getDiffDay(dayStart,-7));
	
	

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
	
	Object[] hasCAFList = (Object[])request.getAttribute("hasCAFList");
	Object[] hasConfirmList = (Object[])request.getAttribute("hasConfirmList");
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
   
   var formObj = document.forms["EditTSCAFUpdateForm"];
   alert(formObj.elements["DataId"].value);
	formObj.elements["DataId"].value = newData;
	formObj.submit();

	//document.EditTSCAFUpdateForm.DataId.value =newData;
	//document.EditTSCAFUpdateForm.submit();
	//location.replace('editTSCAFUpdate.do')
	//document.EditTSCAFUpdateForm.submit();
}
function SaveRecords() {
	var formObj = document.forms["EditTSCAFUpdateForm"];
	formObj.elements["FormAction"].value = "update";
	formObj.submit();
}
function ConfirmRecords() {
	var formObj = document.forms["EditTSCAFUpdateForm"];
	formObj.elements["FormAction"].value = "confirm";
	formObj.submit();
}
function checkAllConfirm(obj) {
	var surffixNum = obj.value;
	var cascadeObjName = "Confirm" + surffixNum;
	var cascadeObj = document.getElementsByName(cascadeObjName);
	for (var i = 0; i < cascadeObj.length; i++) {
		if (cascadeObj[i].disabled == false) {
			cascadeObj[i].checked = obj.checked;
		}
	}
}
function checkAllCAF(obj) {
	var surffixNum = obj.value;
	var cascadeObjName = "CAF" + surffixNum;
	var recordValName = "RecordVal" + surffixNum;
	var allowanceName = "TSAllowance" + surffixNum;
	var cascadeObj = document.getElementsByName(cascadeObjName);
	var recordVal = document.getElementsByName(recordValName);
	var allowanceObj = document.getElementsByName(allowanceName);
	for (var i = 0; i < cascadeObj.length; i++) {
		if (cascadeObj[i].disabled == false) {
			if (parseFloat(recordVal[i].value) != 0) {
				cascadeObj[i].checked = obj.checked;
			} else if (allowanceObj.length != 0) {
				if (parseFloat(allowanceObj[i].value) != 0) {
					cascadeObj[i].checked = obj.checked;
				}
			}
		}
	}
}
function cascadeConfirmCheck() {
	
}
function cascadeCAFCheck() {
	
}


</script>
<Form action="editTSCAFUpdate.do" name="EditTSCAFUpdateForm" method="post">
<input type="hidden" name="FormAction">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall><bean:message key="prm.timesheet.cafUpdate.title"/></CAPTION>
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
				<td rowspan=2 class="lblbold" align="center">Conf.</td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.projectLable"/></td>
				<td rowspan=2 class="lblbold" align="center">Customer</td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.eventLable"/></td>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.servicetypeLable"/></td>
				<td rowspan=2 class="lblbold" align="center">CAF</td>
				<td rowspan=2 class="lblbold" align="center">CAF Print No.</td>
				<td rowspan=2 class="lblbold" align="center">Data Source</td>
				<%for (i=0;i < DayCount;i++) {
					DayArray[i] = Date_formater.format(UtilDateTime.getDiffDay(dayStart,i));
				%>
					<td class="lblbold" align="center" valign="top" colspan="4"><%=DayArray[i]%></td>
					<%
				}%>
				<td rowspan=2 class="lblbold" align="center"><bean:message key="prm.timesheet.totalLable"/></td>
			</tr>
			<tr bgcolor="#e9eee9">
			<%for (i=0;i < DayCount;i++) {
					
				%>
					
					<td class="lblbold" align="center">Work Hrs</td>
					<td class="lblbold" align="center">Alownce Days</td>
					<td class="lblbold" align="center">CAF</td>
					<td class="lblbold" align="center">Conf.</td>
					<%
				}%>
			</tr>
			<%
			TransactionServices transactionServices = new TransactionServices();
			Iterator it = DetResult.iterator();
			String CurrPart = "";
			String CurrProj = "";
			String CurrEvent = "";
			String DisplayText = "";
			String rowClass = "";
			String CAFDisplayText = "";
			String tsId = "";
			String CAFStatusUser = "";
			String temp_line = "";
			String ReadOnly=" ReadOnly Style='background-color:#A9A9A9'";
			String fRead = "";
			String fDisable = "";
			String fConfirm = "";
			String fCAF = "";
			String cafDisable = "";
			String CAFConfirm = "";
			String tsStatus = "";
			String allConfirm = "";
			String allCAF = "";
			float rowCount = 0;
			float[] colCount = {0,0,0,0,0,0,0};
			float totalCount = 0;
			int MaxCol = DayCount;
			int col = MaxCol;
			int row = 0;
			if (it.hasNext()){
				ProjectMaster projectMaster = null;
				int rowCount2 = 0;
				int colCount2 = 0;
				while(it.hasNext()){
					TimeSheetDetail ts = (TimeSheetDetail)it.next();

					String NewPart = ts.getProject().getProjId() + "$" + ts.getProjectEvent().getPeventId().toString()+ "$" + ts.getTSServiceType().getId().toString();
					String NewProj = ts.getProject().getProjId();
					String NewEvent = ts.getProjectEvent().getPeventId().toString();
					String NewDate = Date_formater.format(ts.getTsDate());
					if (!NewPart.equals(CurrPart)) {
						for (col=col; col < MaxCol; col++) {
							tsId = " ";
							DisplayText = DisplayText+"<td colspan=4>0.0</td>";
							temp_line = temp_line+"<td><input type=hidden name=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=2 value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-99,24);CalcTot()'></td>";
							if (projectMaster != null && projectMaster.getPaidAllowance() != null && projectMaster.getPaidAllowance().floatValue() != 0) {
								temp_line = temp_line+"<td><input type=text class=inputBox name=TSAllowance"+row+" size=2  value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-24,24)'></td>";
							} else {
								temp_line = temp_line+"<td></td>";
							}
							temp_line = temp_line+"<td><input type='checkbox' name=CAF"+row+" class='checkboxstyle' value='"+colCount2+"'></td>";
							temp_line = temp_line+"<td><input type='checkbox' name=Confirm"+row+" class='checkboxstyle' value='"+colCount2+"'></td>";
							colCount2 = (colCount2 + 1) % 7;
						}
						
						projectMaster = ts.getProject();
						
						if (CurrPart != "" && col == MaxCol) {
							DisplayText = DisplayText+"<td align=left class=lblbold>"+rowCount+"</td></tr>";
							temp_line = temp_line+"<td align=left class=lblbold id=tTot"+row+">0</td></tr>";
						}
						rowClass = rowClass.equals("") ? "" : "";
						rowCount = 0;
						out.println(DisplayText + temp_line);
						DisplayText = "";
						temp_line = "";
						row++;
						tsStatus = ts.getConfirm().trim();

						if (((Boolean)hasConfirmList[rowCount2]).booleanValue()) {
							allConfirm = " checked disabled";							
						} else {
							allConfirm = "";
						}
						
						if (((Boolean)hasCAFList[rowCount2]).booleanValue()) {
							allCAF = " checked";							
						} else {
							allCAF = "";
						}
						
						rowCount2++;
						String cafNO ="";
						if (ts.getCAFPrintDate()!= null){
							cafNO = ts.getCAFPrintDate();
						}
						if (NewProj.equals(CurrProj)) {
							DisplayText = DisplayText+"<tr class='"+rowClass+"' align='left' bgcolor='#e9eee9'><td class='bottom' rowspan = 2><input class='checkboxstyle' type=checkbox name='chk' value='"+row+"' onclick='checkAllConfirm(this)' "+allConfirm+"></td><td class='bottom' align='left' rowspan = 2>&nbsp;</td><td class='bottom' align='left' rowspan = 2>&nbsp;</td>";
							if (NewEvent.equals(CurrEvent)) {
								DisplayText = DisplayText+"<td class='bottom' align='left' rowspan = 2>&nbsp;</td>";
							} else {
								DisplayText = DisplayText+"<td class='bottom' align='left' rowspan = 2>"+ts.getProjectEvent().getPeventName()+"</td>";
							}
							DisplayText = DisplayText+"<td class='bottom' align='left' rowspan = 2>"+ts.getTSServiceType().getDescription()+"</td><td class='bottom' rowspan = 2><input  class='checkboxstyle' type=checkbox name='cafChk' onclick='checkAllCAF(this)' value='"+row+"' "+allConfirm+allCAF+"></td><td class='bottom' align='center' nowrap  rowspan = 2>"+cafNO+"</td><td>Staff</td>";
						} else {
							DisplayText = DisplayText+"<tr class='"+rowClass+"' align='left' bgcolor='#e9eee9'><td class='bottom' rowspan = 2><input class='checkboxstyle' type=checkbox name='chk' value='"+row+"' onclick='checkAllConfirm(this)' "+allConfirm+"></td><td class='bottom' align='left' rowspan = 2>"+ts.getProject().getProjId()+":"+ts.getProject().getProjName()+"</td><td class='bottom' align='left' rowspan = 2>"+ts.getProject().getCustomer().getDescription()+"</td><td class='bottom' align='left' rowspan = 2>"+ts.getProjectEvent().getPeventName()+"</td><td class='bottom' align='left' rowspan = 2>"+ts.getTSServiceType().getDescription()+"</td><td class='bottom' rowspan = 2><input  class='checkboxstyle' type=checkbox name='cafChk' onclick='checkAllCAF(this)' value='"+row+"' "+allConfirm+allCAF+"></td><td class='bottom' align='center' nowrap  rowspan = 2>"+cafNO+"</td><td>Staff</td>";
						}
						
						temp_line = temp_line+"<tr class='"+rowClass+"' align='left' bgcolor='#e9eee9'><td>CAF</td>";
						%>
						<input type="hidden" name="projId" value = "<%=ts.getProject().getProjId()%>">
						<input type="hidden" name="PEventId" value = "<%=ts.getProjectEvent().getPeventId()%>">
						<input type="hidden" name="PSTId" value = "<%=ts.getTSServiceType().getId()%>">
						<%
						CurrPart = NewPart;
						CurrProj = NewProj;
						CurrEvent = NewEvent;
						col = 0;
					}
					while (!DayArray[col].equals(NewDate)) {
						tsId = " ";
						DisplayText = DisplayText+"<td colspan=4>0.0</td>";
						temp_line = temp_line+"<td><input type=hidden name=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=2  value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-99,24);CalcTot()'></td>";
						if (projectMaster != null && projectMaster.getPaidAllowance() != null && projectMaster.getPaidAllowance().floatValue() != 0) {
							temp_line = temp_line+"<td><input type=text class=inputBox name=TSAllowance"+row+" size=2  value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-24,24)'></td>";
						} else {
							temp_line = temp_line+"<td></td>";
						}
						temp_line = temp_line+"<td><input type='checkbox' name=CAF"+row+" class='checkboxstyle' value='"+colCount2+"'></td>";
						temp_line = temp_line+"<td><input type='checkbox' name=Confirm"+row+" class='checkboxstyle' value='"+colCount2+"'></td>";
						colCount2 = (colCount2 + 1) % 7;
						col++;
					}
					tsId = ts.getTsId().toString();
					DisplayText = DisplayText+"<td colspan=4>"+ts.getTsHoursUser().toString()+"</td>";
					CAFConfirm = ts.getCAFStatusConfirm().trim().equalsIgnoreCase("Y") ? " checked" : "";
					tsStatus = ts.getConfirm().trim();
					if (tsStatus.equals("Confirmed")){
						List tsTrList = transactionServices.getInsertedTS(ts);
						fRead = ReadOnly;
						fDisable = "";
						if (tsTrList != null) {
							for (int i0 = 0;  i0 < tsTrList.size(); i0++) {
								TransacationDetail transacationDetail = (TransacationDetail)tsTrList.get(i0);
								if (transacationDetail instanceof BillTransactionDetail) {
									if (((BillTransactionDetail)transacationDetail).getTransactionMaster() != null) {
										fDisable = " disabled ";
										break;
									}
								} else {
									if (((PaymentTransactionDetail)transacationDetail).getTransactionMaster() != null) {
										fDisable = " disabled ";
										break;
									}
								}
							}
						} else {
							fDisable = " disabled ";
						}
						cafDisable = " disabled ";
						fConfirm = " checked ";
					} else {
						fRead="";
						fDisable = "";
						fConfirm = "";
						cafDisable = "";
					}
					temp_line = temp_line+"<td><input type=hidden name=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=2 value='"+ts.getTsHoursConfirm().toString()+"' onblur='checkDeciNumber2(this,1,1,this.name,-99,24);CalcTot()' "+fRead+"></td>";
					if (projectMaster != null && projectMaster.getPaidAllowance() != null && projectMaster.getPaidAllowance().floatValue() != 0) {
						String defaultValue = (ts.getTsHoursConfirm() != null && ts.getTsHoursConfirm().floatValue() != 0) ? "1.0" : "0.0";
						String tsAllowance = ts.getTSAllowance() != null ? ts.getTSAllowance().toString() : defaultValue;
						temp_line = temp_line+"<td><input type=text class=inputBox name=TSAllowance"+row+" size=2  value='"+tsAllowance+"' onblur='checkDeciNumber2(this,1,1,this.name,-24,24)' "+fRead+"></td>";
					} else {
						temp_line = temp_line+"<td></td>";
					}
					temp_line = temp_line+"<td><input type='checkbox' name=CAF"+row+" class='checkboxstyle' value='"+colCount2+"' "+cafDisable+CAFConfirm+"></td>";
					temp_line = temp_line+"<td><input type='checkbox' name=Confirm"+row+" class='checkboxstyle' value='"+colCount2+"' "+fConfirm+fDisable+"></td>";
					colCount2 = (colCount2 + 1) % 7;
					totalCount = totalCount + ts.getTsHoursUser().floatValue();
					rowCount = rowCount + ts.getTsHoursConfirm().floatValue();
					colCount[col] = colCount[col] + ts.getTsHoursConfirm().floatValue();
					col++;
				}
				for (col=col; col < MaxCol; col++) {
					tsId = " ";
					DisplayText = DisplayText+"<td colspan=4>0.0</td>";
					temp_line = temp_line+"<td><input type=hidden name=tsId"+row+" value = '"+tsId.toString()+"'><input type=text class=inputBox name=RecordVal"+row+" size=2  value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-99,24);CalcTot()'></td>";
					if (projectMaster != null && projectMaster.getPaidAllowance() != null && projectMaster.getPaidAllowance().floatValue() != 0) {
						temp_line = temp_line+"<td><input type=text class=inputBox name=TSAllowance"+row+" size=2  value='0.0' onblur='checkDeciNumber2(this,1,1,this.name,-24,24)'></td>";
					} else {
						temp_line = temp_line+"<td></td>";
					}
					temp_line = temp_line+"<td><input type='checkbox' name=CAF"+row+" class='checkboxstyle' value='"+colCount2+"'></td>";
					temp_line = temp_line+"<td><input type='checkbox' name=Confirm"+row+" class='checkboxstyle' value='"+colCount2+"'></td>";
					colCount2 = (colCount2 + 1) % 7;
				}
				DisplayText = DisplayText+"<td align=left class=lblbold>"+rowCount+"</td></tr>";
				temp_line = temp_line+"<td align=left class=lblbold id=tTot"+row+">0</td></tr>";
				out.println(DisplayText + temp_line);
				DisplayText = "";
				temp_line = "";
			%>		
			
			<tr align="center">
				<td align="left" colspan="8" class="lblbold">Updated <bean:message key="prm.timesheet.totalLable"/>:</td>
				<td align="left" colspan="4" class="lblbold" id='tSubTot1'>0</td>
				<td align="left" colspan="4" class="lblbold" id='tSubTot2'>0</td>
				<td align="left" colspan="4" class="lblbold" id='tSubTot3'>0</td>
				<td align="left" colspan="4" class="lblbold" id='tSubTot4'>0</td>
				<td align="left" colspan="4" class="lblbold" id='tSubTot5'>0</td>
				<td align="left" colspan="4" class="lblbold" id='tSubTot6'>0</td>
				<td align="left" colspan="4" class="lblbold" id='tSubTot7'>0</td>
				<td align="left" class="lblbold" id='tTot'>0</td>
			</tr>
			<%totalCount = 0;%>
			<%} else {
				DisplayText = "<tr><td colspan='21' align='center'>No Record Found.</td></tr>";
				out.println(DisplayText);
			}
			%>
			<tr align="center">
				<td align="left" colspan="21">
					&nbsp;&nbsp;&nbsp;&nbsp;<input TYPE="button" class="button" name="Del" value="Confirm" onclick="javascript:ConfirmRecords()">&nbsp;&nbsp;
					<input TYPE="button" class="button" name="Save" value="Save Record" onclick="javascript: SaveRecords()">&nbsp;&nbsp;
					<input TYPE="button" class="button" name="Back" value="Back" onclick="javascript:location.replace('listTSCAFUpdate.do')">
				    
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
<input type="hidden" name="UserId" value="<%=UserId%>">
<input type="hidden" name="DepartmentId" value="<%=DepartmentId%>">
<input type="hidden" name="DataId" value="<%=DataPeriod%>">
<input type="hidden" name="LastDataId" value="<%=LastDataPeriod%>">
<input type="hidden" name="NextDataId" value="<%=NextDataPeriod%>">

</form>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception ex) {ex.printStackTrace();
} finally { 
Hibernate2Session.closeSession();
}
%>
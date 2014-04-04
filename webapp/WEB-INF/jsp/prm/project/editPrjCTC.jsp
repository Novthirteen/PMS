<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<%
if (AOFSECURITY.hasEntityPermission("CUST_PROJECT_CTC", "_CREATE", session)) {%>
<%
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(2);
Num_formater.setMinimumFractionDigits(2);
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;
ProjectMaster CustProject = null;
String DataId = request.getParameter("DataId");
if (DataId!=null && !DataId.equals("")){
	CustProject = (ProjectMaster)hs.load(ProjectMaster.class,DataId);
}
String action = request.getParameter("FormAction");
if(action == null){
	action = "create";
}

List CTCResult = (List)request.getAttribute("CustProjectCTCs");
if(CTCResult==null){
	CTCResult = new ArrayList();
}

List ActualList = (List)request.getAttribute("ActualList");
if(ActualList==null){
	ActualList = new ArrayList();
}

Long CurrVerFMId = (Long)request.getAttribute("CurrVerFMId");
Long NewVerFMId = (Long)request.getAttribute("NewVerFMId");
boolean withData = false;
if (CurrVerFMId != null) {
	if (CurrVerFMId.longValue() == NewVerFMId.longValue()) withData = true;
}

UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);

%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="vbs">
function rndNum(tot)
 tot=FormatNumber(tot,2,-1,0,-1)
 rndNum=tot
end function
</script>

<script language="javascript">
function CalcTot()
{
	var oCust;
	oText=document.getElementsByName("RecordVal");
	for(var i=0 ;i<oText.length;i++)
	{
		var oTdtot;
		oTdtot=document.getElementById("tBudget"+i);
		var oBugAmt = parseFloat(oTdtot.value);
		
		oTdtot=document.getElementById("tActual"+i);
		var oActAmt = parseFloat(oTdtot.value);
		
		var oCTCAmt = parseFloat(oText[i].value);
		
		oTdtot=document.getElementById("tTot"+i);
		oTdtot.innerHTML=rndNum(oCTCAmt+oActAmt);
		oTdtot=document.getElementById("tVariance"+i);
		oTdtot.innerHTML=rndNum(oActAmt+oCTCAmt-oBugAmt);
		if (oBugAmt != 0) {
			oTdtot=document.getElementById("tVariancePercentage"+i);
			oTdtot.innerHTML=rndNum((oActAmt+oCTCAmt-oBugAmt)/oBugAmt*100);
		}
	}
}
</script>
<form name="frm" method="post">
<input type="hidden" name="FormAction" id="FormAction" value="Update">
<input type="hidden" name="VerFMId" id="VerFMId" value="<%=NewVerFMId%>">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>  Project Cost To Complete Forecast </CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" align=right >Department :</td>
				<td class="lblLight"><%=CustProject.getDepartment().getDescription()%></td>
				<td class="lblbold" align=right width="20%">User :</td>
				<td class="lblLight"><%=ul.getName()%></td>	
				<td class="lblbold" align=right width="20%">Customer :</td>
				<td class="lblLight"><%=CustProject.getCustomer().getDescription()%>&nbsp;</td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Project :</td>
				<td class="lblLight"><%=CustProject.getProjId()%>&nbsp;:&nbsp;<%=CustProject.getProjName()%><input type="hidden" name="projectId" id="projectId" value="<%=CustProject.getProjId()%>"></td>
				<td class="lblbold" align=right>Contranct No :</td>
				<td class="lblLight"><%=CustProject.getContractNo()%>&nbsp;</td>
				<td class="lblbold" align=right>Contract Type :</td>
				<td class="lblLight"><% String NC = "";
				String OC = CustProject.getContractType();
				if(OC.equals("TM")) NC = "Time & Material";
				if(OC.equals("FP")) NC = "Fixed Price";
				%>
				<%=NC%>&nbsp;</td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Start Date :</td>
				<td class="lblLight"><%=CustProject.getStartDate()%></td>
				<td class="lblbold" align=right>End Date(YYYY-MM-DD) :</td>
				<td class="lblLight"><input align="center" TYPE="text" style="TEXT-ALIGN: right" class="lbllgiht" maxlength="15" size="10" name="endDate" id="endDate" value="<%=CustProject.getEndDate()%>"><A  href="javascript:ShowCalendar(document.frm.dimg2,document.frm.endDate,null,0,330)"  onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
				<td class="lblbold" align=right>Status :</td>
				<td class="lblLight"><%=CustProject.getProjStatus()%>&nbsp;</td>
			</tr>
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
				<td class="lblbold" align="center" width="15%">Cost Type</td>
				<td class="lblbold" align="center" width="10%">Budget(RMB)</td>
				<td class="lblbold" align="center" width="10%">Cost To Date(RMB)</td>
				<td class="lblbold" align="center" width="10%">Cost To Complete (RMB)</td>
				<td class="lblbold" align="center" width="10%">Total Cost (RMB)</td>
				<td class="lblbold" align="center" width="10%">Budget Variance To Date (RMB)</td>
				<td class="lblbold" align="center" width="10%">Budget Variance To End Of Project(RMB)</td>
				<td class="lblbold" align="center" width="10%">Budget Variance (%)</td>
			</tr>
			<%
			String CTCType[] = {"PSC","ExtCost","Expense"};
			String CTCTypeDESC[] = {"Professional Service Cost","Procurement / SubContract","Expense"};
			boolean WithActual = false;
			double TotalActual = 0;
			
			Iterator itCTC = CTCResult.iterator();
			ProjectCostToComplete ctc = null;
			if (itCTC.hasNext()) {
				ctc = (ProjectCostToComplete)itCTC.next();
			}
			Object[] findActual = null;
			
			Iterator itActual = ActualList.iterator();
			if (itActual.hasNext()) {
				findActual = (Object[])itActual.next();
				WithActual = true;
			}
			for (int i=0; i<CTCType.length; i++) {%>
				<tr bgcolor="#e9eee9">
					<td class="lblbold"><%=CTCTypeDESC[i]%><input type="hidden" name="ctc_type" id="ctc_type" value="<%=CTCType[i]%>"></td>
					<%double BudValue = 0;
					if (CTCType[i].equals("PSC")) {
						BudValue = CustProject.getPSCBudget().doubleValue();
					} else if (CTCType[i].equals("ExtCost")) {
						BudValue = CustProject.getProcBudget().doubleValue();
					} else if (CTCType[i].equals("Expense")) {
						BudValue = CustProject.getEXPBudget().doubleValue();
					}%>
					<td class="lblbold" align="right">
						<%=Num_formater.format(BudValue)%>
						<input type="hidden" name="tBudget<%=i%>" Id="tBudget<%=i%>" value="<%=BudValue%>">
					</td>
					<%
					double ActualAmt = 0;
					if (WithActual) {
						if (findActual[1].equals(CTCType[i])) {
							ActualAmt = ((Double)findActual[2]).doubleValue();
							if (itActual.hasNext()) {
								findActual = (Object[])itActual.next();
							}
						}
					}%>
					<td align="right" class="lblbold">
						<%=Num_formater.format(ActualAmt)%>
						<input type="hidden" name="tActual<%=i%>" Id="tActual<%=i%>" value="<%=ActualAmt%>">
					</td>
					<%
					String RecId = "";
					double CTCAmt = 0;
					if (ctc != null) {
						if (ctc.getFiscalMonth().getId().equals(NewVerFMId) && ctc.getType().equals(CTCType[i])) {
							if (withData) RecId = ctc.getId().toString();
							CTCAmt = ctc.getAmount();
							if (itCTC.hasNext()) {
								ctc = (ProjectCostToComplete)itCTC.next();
							}
						}
					}%>
					<td align="center"><input type="hidden" name="RecId" Id="RecId" value="<%=RecId%>"><input type=text class=inputBox name="RecordVal" size=10 value="<%=CTCAmt%>" onblur="checkDeciNumber2(this,1,1,'CTC Value',-9999999,9999999);  CalcTot();  "></td>
					<td align="right" class="lblbold" Id="tTot<%=i%>"><%=Num_formater.format(CTCAmt+ActualAmt)%></td>
					<td align="right" class="lblbold" Id="tVarianceBudget<%=i%>"><%=Num_formater.format(ActualAmt-BudValue)%></td>
					<td align="right" class="lblbold" Id="tVariance<%=i%>"><%=Num_formater.format(CTCAmt+ActualAmt-BudValue)%></td>
					<td align="right" class="lblbold" Id="tVariancePercentage<%=i%>"><%if (BudValue != 0) out.print(Num_formater.format(((CTCAmt+ActualAmt-BudValue)/BudValue)*100));%></td>
				</tr>
			<%}%>
			<tr align="center">
				<td align="left" colspan="5">
					<input TYPE="submit" class="button" name="Save" value="Save Record">
					<input TYPE="button" class="button" name="Back" value="Back" onclick="javascript:location.replace('findPrjFCPage.do?SecId=1')">
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</form>
<%
Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
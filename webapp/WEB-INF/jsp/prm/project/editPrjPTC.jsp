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
<%
if (AOFSECURITY.hasEntityPermission("CUST_PROJECT_PTC_", "_CREATE", session)) {%>
<%
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
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

List DateResult = (List)request.getAttribute("DateList");
if(DateResult==null){
	DateResult = new ArrayList();
} 

List CTCResult = (List)request.getAttribute("CustProjectCTCs");
if(CTCResult==null){
	CTCResult = new ArrayList();
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
window.onload=CalcTot;
function CalcTot()
{
	var oCust;
	var tot=0.00;
	oCust=document.getElementsByName("ctc_type");
	for(var i=0 ;i<oCust.length;i++)
	{
		var oText;
		var oAmt;
		oText=document.getElementsByName("RecordVal"+i);
		tot=0.00;
		for(var j=0;j<oText.length;j++)
		{
			tot = tot + parseFloat(oText[j].value);
		}
		var oTdtot=document.getElementById("tTot"+i);
		oTdtot.innerHTML=rndNum(tot);
	}
}
</script>

<form name="frm" method="post">
<input type="hidden" name="FormAction" value="Update">
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>  Project Percentage To Complete Forecast </CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Deparment :</td><td class="lblLight"><%=CustProject.getDepartment().getDescription()%></td>
				<td class="lblbold" align=right>User:</td><td class="lblLight"><%=ul.getName()%></td>	
				<td class="lblbold" align=right>Customer:</td><td class="lblLight"><%=CustProject.getCustomer().getDescription()%>&nbsp;</td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Project :</td><td class="lblLight"><%=CustProject.getProjId()%>&nbsp;:&nbsp;<%=CustProject.getProjName()%><input type="hidden" name="projectId" value="<%=CustProject.getProjId()%>"></td>
				<td class="lblbold" align=right>Contranct No:</td><td class="lblLight"><%=CustProject.getContractNo()%>&nbsp;</td>	
				<td class="lblbold" align=right>Start Date :</td>
				<td class="lblLight"><%=CustProject.getStartDate()%></td>	
			</tr>
			<tr>
				<td class="lblbold" align=right>Total Sales :</td>
				<td class="lblLight"><%=CustProject.getTotalSales()%></td>
				<td class="lblbold" align=right>Total Budget :</td>
				<td class="lblLight"><%=CustProject.getTotalBudget()%></td>	
				<td class="lblbold" align=right>End Date(YYYY-MM-DD) :</td><td class="lblLight"><input align="center" TYPE="text" style="TEXT-ALIGN: right" class="lbllgiht" maxlength="15" size="10" name="YR1" id="YR1" value="<%=CustProject.getEndDate()%>"></td>
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
				<td class="lblbold" align="center">Type</td>
				<%
				Iterator itDate = DateResult.iterator();
				while(itDate.hasNext()){
					FMonth fm = (FMonth)itDate.next();%>
					<td class="lblbold" align="center"><%=fm.getDescription()%></td>
					<input type=hidden name=FMId value="<%=fm.getId()%>">
				<%}
				Iterator itCTC = CTCResult.iterator();
				ProjectPercentageToComplete ctc = null;
				if (itCTC.hasNext()) {
					ctc = (ProjectPercentageToComplete)itCTC.next();
				}
				String CTCType[] = {"JOB","PAY"};
				String CTCTypeDESC[] = {"Job (%)","Payment (%)"};
				%>
				<td class="lblbold" align="center">Total</td>
			</tr>
			<%
			boolean NullData = true;
			String fRead = "";
			for (int i=0; i<CTCType.length; i++) {%>
				<tr bgcolor="#e9eee9">
					<td class="lblbold"><%=CTCTypeDESC[i]%> 
					</td>
					<%
					itDate = DateResult.iterator();
					NullData = false;
					while(itDate.hasNext()){
						FMonth fm = (FMonth)itDate.next();
						NullData = false;
						fRead = "";
						if ( UtilDateTime.getDayDistance((Date)fm.getDateFreeze(), (Date)UtilDateTime.nowTimestamp()) < 0) {
							fRead=" ReadOnly Style='background-color:#A9A9A9'";
						}
						if (ctc != null) {
							if (ctc.getFiscalMonth().getId().equals(fm.getId()) && ctc.getType().equals(CTCType[i])) {%>
								<td><input type=hidden name="RecId<%=i%>" value="<%=ctc.getId()%>"><input type=text class=inputBox name="RecordVal<%=i%>" size=10 value="<%=ctc.getAmount()%>" onblur="CalcTot()" <%=fRead%>></td>
							<%
								if (itCTC.hasNext()) {
									ctc = (ProjectPercentageToComplete)itCTC.next();
								}
							} else {
								NullData = true;
							}
						} else {
							NullData = true;
						}
						if (NullData) {%>
						<td><input type=hidden name="RecId<%=i%>" value=""><input type=text class=inputBox name="RecordVal<%=i%>" size=10 value="0" onblur="CalcTot()" <%=fRead%>></td>
						<%}
					}
					%>
					<td class="lblbold" Id="tTot<%=i%>">0</td>
				</tr>
			<%}%>
			<tr align="center">
				<td align="left" colspan="11">
					<input TYPE="submit" class="button" name="Save" value="Save Record">
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
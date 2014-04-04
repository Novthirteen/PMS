<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.prm.TimeSheet.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
try{
if (AOFSECURITY.hasEntityPermission("TIME_SHEET", "_VIEW", session)) {
	String chkSelect=(String)session.getAttribute("se_UserId");
	String chkParty=(String)session.getAttribute("se_DepartmentId");
	String sltYR=(String)session.getAttribute("se_sltYR");

	if (chkSelect == null ) chkSelect = "";
	if (chkParty == null ) chkParty = "";
	if (sltYR == null ) sltYR = "";
	
	String UserName = "";
	String UserParty = "";
	
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	UserLogin ul = (UserLogin) hs.load(UserLogin.class, chkSelect);
	if (ul != null) UserName = ul.getName();
	Party up = (Party) hs.load(Party.class, chkParty);
	if (up != null) UserParty = up.getDescription();
	List MstrResult = (List)request.getAttribute("QryMaster");
	if(MstrResult==null){
		MstrResult = new ArrayList();
	}	

%>
<script language="JavaScript">
function OpenReqURL(ReqType, DataId)
{
	switch (ReqType) {
		case "Edit":
			document.frm.DataId.value =DataId;
			document.frm.submit();
			break;
		default:
	}
}
</script>
<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall">View Time Sheet Data For Entry</caption> 
<tr>
	<td>
		<table cellspacing="5" cellpadding="1" width=100%>
			<tr>
				<td colspan=6 valign = "bottom"><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Department :</td><td class="lblLight"><%=UserParty%></td>
				<td class="lblbold">User :</td><td class="lblLight"><%=UserName%></td>	
				<td class="lblbold">Year :</td><td class="lblLight"><%=sltYR%></td>
			</tr>
			<tr>
				<td colspan=6 valign = "top"><hr color=red></hr></td>
			</tr>
			
		</table>
	</td>
</tr>

<tr>
	<td>
		<table border="0" cellpadding="1" cellspacing="1" width=100%>
			<tr bgcolor="#e9eee9">
				<td class="lblbold">&nbsp;&nbsp;</td>
				<td class="lblbold" width="2%">&nbsp;Week&nbsp;</td>
				<td class="lblbold" width="18%">&nbsp;Period&nbsp;</td>
				<td class="lblbold" width="7%">&nbsp;Total Hrs Submitted&nbsp;</td>
				<td class="lblbold" width="9%">&nbsp;Pending Hrs For Approval&nbsp;</td>
				<td class="lblbold" width="7%">&nbsp;Rejected Hrs&nbsp;</td>
				<td class="lblbold" width="7%">&nbsp;Outstanding CAF Hrs&nbsp;</td>
				
				<td class="lblbold">&nbsp;&nbsp;</td>
				<td class="lblbold" width="2%">&nbsp;Week&nbsp;</td>
				<td class="lblbold" width="18%">&nbsp;Period&nbsp;</td>
				<td class="lblbold" width="7%">&nbsp;Total Hrs Submitted&nbsp;</td>
				<td class="lblbold" width="9%">&nbsp;Pending Hrs For Approval&nbsp;</td>
				<td class="lblbold" width="7%">&nbsp;Rejected Hrs&nbsp;</td>
				<td class="lblbold" width="7%">&nbsp;Outstanding CAF Hrs&nbsp;</td>
			</tr>
			<%
			SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
			Date dayYearStart1 = UtilDateTime.toDate("1", "1", sltYR, "0", "0", "0");
			Date dayYearStart2 = UtilDateTime.getThisWeekDay(dayYearStart1, 1);
			Date dayYearEnd1 = UtilDateTime.toDate("12", "31", sltYR, "0", "0", "0");
			Date dayYearEnd2 = UtilDateTime.getThisWeekDay(dayYearEnd1, 7);
			String DisplayText = "";
			long WeeksInYear = UtilDateTime.getDayDistance(dayYearEnd2,dayYearStart2)/7;
			int HalfWeeksInYear = 0;
			if (((WeeksInYear) % 2) == 1) {
				HalfWeeksInYear = (int)((WeeksInYear)/2 + 1);
			} else {
				HalfWeeksInYear = (int)((WeeksInYear)/2);
			}

			Iterator itActual1 = MstrResult.iterator();
			boolean NullData = true;
			boolean WithActual1 = false;
			ArrayList findActual1 = null;
			if (itActual1.hasNext()){
				findActual1 = (ArrayList)itActual1.next();
				WithActual1 = true;
			}
			Iterator itActual2 = MstrResult.iterator();
			ArrayList findActual2 = null;
			boolean WithActual2 = false;
			if (itActual2.hasNext()){
				findActual2 = (ArrayList)itActual2.next();
				Date FirstDayinLastHalfYear = UtilDateTime.getDiffDay(dayYearStart1,(HalfWeeksInYear) * 7);
				while (UtilDateTime.toDate2(findActual2.get(0) + " 00:00:00.000").before(FirstDayinLastHalfYear) && itActual2.hasNext()) {
					findActual2 = (ArrayList)itActual2.next();
					WithActual2 = true;
				}
			}
			
			Date DateDisplay = null;
			for (int i=0 ; i <= HalfWeeksInYear ; i++) {%>
				<tr bgcolor='e9eee9'>
				<%DateDisplay = UtilDateTime.getDiffDay(dayYearStart2,7*i);%>
				<td>&nbsp;</td>
				<td><a href="javascript:OpenReqURL('Edit','<%=Date_formater.format(DateDisplay)%>')"><%=i+1%></a></td>
				<td><a href="javascript:OpenReqURL('Edit','<%=Date_formater.format(DateDisplay)%>')"><%=Date_formater.format(DateDisplay)%> ~ <%=Date_formater.format(UtilDateTime.getDiffDay(DateDisplay,6))%></a></td>
				<%
				NullData = true;
				if (MstrResult.size() != 0) {
				//if (WithActual1) {
					if (findActual1.get(0).equals(Date_formater.format(DateDisplay))) {
						//DisplayText = "<td align=CENTER>"+findActual1[2].toString()+"</td>";
						if(!findActual1.get(1).toString().trim().equals("0.00")){
						DisplayText = "<td align=RIGHT>"+findActual1.get(1)+"</td>";
						out.println(DisplayText);
						}else out.println("<td align=RIGHT>&nbsp</td>");
						if(!findActual1.get(2).toString().trim().equals("0.00")){
						DisplayText = "<td align=RIGHT>"+findActual1.get(2)+"</td>";
						out.println(DisplayText);
						}else out.println("<td align=RIGHT>&nbsp</td>");
						if(!findActual1.get(3).toString().trim().equals("0.00")){
						DisplayText = "<td align=RIGHT>"+findActual1.get(3)+"</td>";
						out.println(DisplayText);
						}else out.println("<td align=RIGHT>&nbsp</td>");
						if(!findActual1.get(4).toString().trim().equals("0.00")){
						DisplayText = "<td align=RIGHT>"+findActual1.get(4)+"</td>";
						out.println(DisplayText);
						}else out.println("<td align=RIGHT>&nbsp</td>");
						NullData = false;
						if (itActual1.hasNext()){
							findActual1 = (ArrayList)itActual1.next();
							WithActual1 = true;
						}
					} 
				//}
				}
				if (NullData) {
					DisplayText = "<td align=RIGHT>NA</td>";
					out.println(DisplayText);
					DisplayText = "<td align=CENTER>&nbsp</td>";
					out.println(DisplayText);
					DisplayText = "<td align=CENTER>&nbsp</td>";
					out.println(DisplayText);
					DisplayText = "<td align=CENTER>&nbsp</td>";
					out.println(DisplayText);
				}%>
				<%if ((i+HalfWeeksInYear+1) > (int)WeeksInYear) {%>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				<%} else {
				DateDisplay = UtilDateTime.getDiffDay(dayYearStart2,7*(i+HalfWeeksInYear+1));%>
				<td>&nbsp;</td>
				<td><a href="javascript:OpenReqURL('Edit','<%=Date_formater.format(DateDisplay)%>')"><%=(i+HalfWeeksInYear+2)%></a></td>
				<td><a href="javascript:OpenReqURL('Edit','<%=Date_formater.format(DateDisplay)%>')"><%=Date_formater.format(DateDisplay)%> ~ <%=Date_formater.format(UtilDateTime.getDiffDay(DateDisplay,6))%></a></td>
				<%
				NullData = true;
				if (MstrResult.size() != 0){
				//if (WithActual2) {
					if (findActual2.get(0).equals(Date_formater.format(DateDisplay))) {
						if(!findActual2.get(1).toString().trim().equals("0.00")){
						DisplayText = "<td align=RIGHT>"+findActual2.get(1)+"</td>";
						out.println(DisplayText);
						}else out.println("<td align=RIGHT>&nbsp</td>");
						if(!findActual2.get(2).toString().trim().equals("0.00")){
						DisplayText = "<td align=RIGHT>"+findActual2.get(2)+"</td>";
						out.println(DisplayText);
						}else out.println("<td align=RIGHT>&nbsp</td>");
						if(!findActual2.get(3).toString().trim().equals("0.00")){
						DisplayText = "<td align=RIGHT>"+findActual2.get(3)+"</td>";
						out.println(DisplayText);
						}else out.println("<td align=RIGHT>&nbsp</td>");
						if(!findActual2.get(4).toString().trim().equals("0.00")){
						DisplayText = "<td align=RIGHT>"+findActual2.get(4)+"</td>";
						out.println(DisplayText);
						}else out.println("<td align=RIGHT>&nbsp</td>");
						NullData = false;
						if (itActual2.hasNext()){
							findActual2 = (ArrayList)itActual2.next();
							WithActual2 = true;
						}
					} 
				//}
				}
				if (NullData) {
					DisplayText = "<td align=RIGHT>NA</td>";
					out.println(DisplayText);
					DisplayText = "<td align=CENTER>&nbsp</td>";
					out.println(DisplayText);
					DisplayText = "<td align=CENTER>&nbsp</td>";
					out.println(DisplayText);
					DisplayText = "<td align=CENTER>&nbsp</td>";
					out.println(DisplayText);
				}
				}%>
				</tr>
			<%}%>
		</table>
	</td>
</tr>
</table>
<Form action="editTimeSheet.do" name="frm" method="post">
	<input type="hidden" name="UserId" id="UserId" value="<%=chkSelect%>">
	<input type="hidden" name="DepartmentId" id="DepartmentId" value="<%=chkParty%>">
	<input type="hidden" name="DataId" id="DataId" value="">
</Form>
<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
}catch (Exception e) {
	e.printStackTrace();
	}
	
%>
<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.component.domain.party.UserLogin"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta http-equiv="Page-Enter" content="blendTrans(Duration=0.2)">
<meta http-equiv="Page-Exit" content="blendTrans(Duration=0.2)">
<title>AO-SYSTEM</title>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language="JavaScript">
function set()
{
document.frm1.formaction.value="realtime";
}
	</script>
<%	if (AOFSECURITY.hasEntityPermission("BACKLOG_REPORT", "_CREATE", session)) {%>
<FORM name="frm1" action="viewBackLog.do" method=post>
<BR><BR>
<TABLE width=100% >
	<CAPTION class=pgheadsmall>BackLog Report
	</CAPTION>
	<tr>
		<td>
			<TABLE width=250 cellspacing=2 cellpadding=2 align=center FRAME=0 rules=none border=1>
				<tr>
					<TD class=lblbold align="center">Year:</TD>
					<td class="lblbold">
							<select name="cyear">
							<% 
							SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
							String myString = df.format(Calendar.getInstance().getTime());
							StringTokenizer st=new StringTokenizer(myString,"-");
							int currentyear=Integer.parseInt(st.nextToken());
							int currentmonth=Integer.parseInt(st.nextToken());
							//int currentyear=2005;
		//					currentyear-=1;
//							for(int i=0;i<5;i++){
							out.println("<option >"+currentyear);
							out.println("<option >"+(currentyear+1));
//							currentyear+=1;
//							}
							%>
							</select></td>
							<td>&nbsp;</td>
				</tr>
				<tr>
					<TD class=lblbold align="center">Month:
						
					</TD>
					<td class="lblbold" align='left'>
					<select name="cmonth">
<%					
out.println("<option >"+(currentmonth-5));
out.println("<option >"+(currentmonth-4));
out.println("<option >"+(currentmonth-3));
out.println("<option >"+(currentmonth-2));
					out.println("<option >"+(currentmonth-1));
					out.println("<option >"+currentmonth);
					out.println("<option >"+(currentmonth+1));
%>					</select></td>
							<td>&nbsp;</td>
					</tr>
<%							List partyList_dep=null;
try{
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	PartyHelper ph = new PartyHelper();
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
	if (partyList_dep == null) partyList_dep = new ArrayList();
	partyList_dep.add(0,ul.getParty());
}catch(Exception e){
	e.printStackTrace();
}
%>
				<tr>
				<td class="lblbold" align="center">Department:</td>
				<td class="lblbold" >
					<select name="departmentId">
					<%
					if (AOFSECURITY.hasEntityPermission("PAS_PM_REPORT", "_ALL", session)) {
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%
						}
					}%>
					</select>
				</td>
				</tr>
				<tr>
				<td class="lblbold" align="center">Type</td>
				<td class="lblbold" ><select name='type' >
				<option value='all'>All (Recurrring+OneTime)
				<option value='onetime'>OneTime
				<option value='recurring'>Recurring
				<option value='other'>Other
				</select>
				</td>
				<td>&nbsp;</td>

				</tr>
				<tr>
					<TD class=lblbold align=center >
						<INPUT class=button TYPE="submit" name=btnSave size='7' value='BackLog Since Last Update' >
					</TD>
					<TD class=lblbold align=center >
						<INPUT class=button TYPE="submit" name=btnSave value='Compute New BackLog'  onclick="javascript:set()">
						<input type="hidden" name="formaction" id="formaction"  value="draft">
					</TD>					
				</tr>
			</TABLE>
		</td>
	</tr>
</TABLE>
<BR><BR>
</Form>
<br>
<%}else{
	out.println("!!你没有相关访问权限!!");
}%>

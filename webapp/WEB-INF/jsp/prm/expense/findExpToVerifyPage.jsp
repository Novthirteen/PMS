<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (AOFSECURITY.hasEntityPermission("EXPENSE", "_VERIFY", session)) {
	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	List result = null;	
	result = (List)request.getAttribute("QryList");
	if(result ==null){
		result = new ArrayList();
		request.setAttribute("QryList",result);
	}
	
	Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
			
	String textuser = request.getParameter("textuser");
	String textproj = request.getParameter("textproj");
	String textstatus = request.getParameter("textstatus");
	String textcode = request.getParameter("textcode");
	String departmentId = request.getParameter("departmentId");
	String DateStart = request.getParameter("DateStart");
	String DateEnd = request.getParameter("DateEnd");
	String ClaimType = request.getParameter("ClaimType");
	if (textproj==null) textproj="";
	if (textstatus==null) textstatus="Approved";
	if (textuser==null) textuser="";
	if (textcode==null) textcode="";
	if (ClaimType==null) ClaimType="CN";
	if (DateStart==null) DateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
	if (DateEnd==null) DateEnd=Date_formater.format(nowDate);

	List partyList_dep=null;
	try{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
		if (departmentId == null) departmentId = ul.getParty().getPartyId();
		if (partyList_dep == null) partyList_dep = new ArrayList();
		partyList_dep.add(0,ul.getParty());
	}catch(Exception e){
		e.printStackTrace();
	}
	
	Integer offset = null;	
	if( request.getParameter("offset") == null || request.getParameter("offset").equals("") ){
		offset = new Integer(0);
	}else{
		offset = new Integer(request.getParameter("offset"));
	} 
	
	Integer length = new Integer(30);	

    request.setAttribute("offset", offset);
    request.setAttribute("length", length);	
    
    int i = offset.intValue()+1;
%>
<script language="javascript">
function FormOperation(aval, tval) {
	with (document.frm) {
		FormAction.value = aval;
		target = tval;
		submit();
	}
}
function fnSubmit1(start) {
	with (document.frm) {
		FormAction.value = "QueryForList";
		offset.value=start;
		submit();
	}
}
</script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<form name="frm" action="findExpToVerifyPage.do" method="post">
<input type="hidden" name="FormAction">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Expense Forms to Verify</CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">User Name:</td>
				<td class="lblLight"><input type="text" name="textuser" value="<%=textuser%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Department:</td>
				<td class="lblLight">
					<select name="departmentId">
						<%Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(departmentId)) {%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%} else{%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%}
						}%>
					</select>
				</td>
				<td class="lblbold">Status:</td>
				<td class="lblLight">
					<select name="textstatus">
					<option value="">(All)</option>
					<option value="Submitted" <%if (textstatus.equals("Submitted")) out.print("selected");%>>Submitted</option>
					<option value="Verified" <%if (textstatus.equals("Verified")) out.print("selected");%>>Verified</option>
					<option value="Approved" <%if (textstatus.equals("Approved")) out.print("selected");%>>Approved</option>
					<option value="Posted To F&A" <%if (textstatus.equals("Posted To F&A")) out.print("selected");%>>Posted To F&A</option>
					<option value="Confirmed" <%if (textstatus.equals("Confirmed")) out.print("selected");%>>F&A Confirmed</option>
					<option value="Claimed" <%if (textstatus.equals("Claimed") || textstatus.equals("Exported")) out.print("selected");%>>Claimed</option>
					/select>
				</td>
				<td class="lblbold">Entry Date:</td>
				<td class="lblLight">
					<input TYPE="text" maxlength="15" size="10" name="DateStart" value="<%=DateStart%>">
					<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.DateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
					~
					<input TYPE="text" maxlength="15" size="10" name="DateEnd" value="<%=DateEnd%>">
					<A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.DateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
				</td>
			</tr>
			<tr>
				<td class="lblbold">&nbsp;ER No.:</td>
				<td class="lblLight"><input type="text" name="textcode" value="<%=textcode%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">&nbsp;Project:</td>
				<td class="lblLight"><input type="text" name="textproj" value="<%=textproj%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold" align=right>Paid By :</td>
				<td class="lblLight">
					<select name="ClaimType">
						<option value="CY" <%if (ClaimType.equals("CY")) out.print("selected");%>>Customer</option>
						<option value="CN" <%if (ClaimType.equals("CN")) out.print("selected");%>>Company</option>
					</select>
				</td>
				<td class="lblbold">Include Exported Data</td>
				<td class="lblLight"><%String ExportFlag = request.getParameter("ExportFlag");
					if (ExportFlag == null) ExportFlag = "N";%>
					<input TYPE="RADIO" class="radiostyle" NAME="ExportFlag" VALUE="Y" <%if(ExportFlag.equals("Y")) out.print("CHECKED");%>>Yes
					<input TYPE="RADIO" class="radiostyle" NAME="ExportFlag" VALUE="N" <%if(ExportFlag.equals("N")) out.print("CHECKED");%>>No
				</td>
				
			</tr>
			<tr>
			<td  align="center">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript:FormOperation('QueryForList','_self')">
				</td>
			    <td colspan=5 align="left">
			    	<input TYPE="button" class="button" name="btnExport" value="Verify Selected" onclick="javascript:FormOperation('VerifySelection','_self')">
					<input TYPE="button" class="button" name="btnExport" value="Post Selected To F&A" onclick="javascript:FormOperation('ToFASelection','_self')">
					<input TYPE="button" class="button" name="btnExport" value="Export Selected" onclick="javascript:FormOperation('ExportSelection','_self')">
					<input TYPE="button" class="button" name="btnExport" value="Export All" onclick="javascript:FormOperation('ExportAll','_self')">
				</td>
				
				
			</tr>
			<tr>
				<td colspan=8 valign="top"><hr color=red></hr></td>
			</tr>
		</Table>
	</td>
</tr>
<tr>
	<td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr align="center" bgcolor="#e9eee9">
				<td class="lblbold" width="1%"><input type=checkbox class="checkboxstyle" name=chkAll value='' onclick="javascript:checkUncheckAllBox(document.frm.chkAll,document.frm.chk)">&nbsp;</td>
				<td align="center" class="lblbold" width="6%">&nbsp;Customer&nbsp;</td>
				<td align="center" class="lblbold" width="15%">&nbsp;Project&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;ER No.&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;Staff Name&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;Paid By&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;Expense Date&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;Entry Date&nbsp;</td>
				<td align="center" class="lblbold" width="4%">&nbsp;Entry Amount&nbsp;</td>
				<td align="center" class="lblbold" width="4%">&nbsp;Verified Amount&nbsp;</td>
				<td align="center" class="lblbold" width="4%">&nbsp;Claimed Amount&nbsp;</td>
				<td align="center" class="lblbold" width="4%">&nbsp;Status&nbsp;</td>
			</tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.expense.ExpenseMaster">
			<%ExpenseMaster em = (ExpenseMaster)p;%>
			<tr bgcolor="#e9eee9">
                <td align="center">
	                <input type=checkbox class="checkboxstyle" name=chk value="<%=em.getId()%>" onclick='javascript:checkTopBox(document.frm.chkAll,document.frm.chk)'>
                </td>
                <td align="left"><%=em.getProject().getCustomer().getDescription()%></td>
				<td align="left"><%=em.getProject().getProjId()%>:<%=em.getProject().getProjName()%></td>
                <td align="left">
					<a href="verifyExpense.do?DataId=<%=em.getId()%>"><%=em.getFormCode()%></a> 
                </td>
                <td align="left"><%=em.getExpenseUser().getName()%></td>
				<td align="left">
					<%if (em.getClaimType().equals("CY")) {
						out.println("Customer");
					} else {
						out.println("Company");
					}%>
                </td>
				<td align="left"><%=em.getExpenseDate()%></td>
				<td align="left"><%=em.getEntryDate()%></td>
				<%Iterator itAmt = em.getAmounts().iterator();
				float AmtStaff = 0;
				float AmtVerify = 0;
				float AmtClaim = 0;
				boolean verified = false;
				boolean claimed = false;
				ExpenseAmount ea = null;
				while (itAmt.hasNext()) {
					ea = (ExpenseAmount)itAmt.next();
					if (ea.getUserAmount() != null) AmtStaff = AmtStaff + ea.getUserAmount().floatValue();
					if (ea.getConfirmedAmount() != null && !verified) verified = true;
					if (ea.getConfirmedAmount() != null) AmtVerify = AmtVerify + ea.getConfirmedAmount().floatValue();
					if (ea.getPaidAmount() != null && !claimed) claimed = true;
					if (ea.getPaidAmount() != null) AmtClaim = AmtClaim + ea.getPaidAmount().floatValue();
				}
				%>
				<td align="right"><%=AmtStaff%></td>
				<td align="right"><%if (verified) {out.print(AmtVerify);} else {out.print("N/A");}%></td>
				<td align="right"><%if (claimed) {out.print(AmtClaim);} else {out.print("N/A");}%></td>
				<td align="center"><%=em.getStatus()%></td>
			</tr>
			</logic:iterate>
			<tr>
				<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<input type=hidden name="offset" value="<%=offset%>">
				<%
				int RecordSize = result.size();
				int l = 0;
				while ((l * length.intValue()) < RecordSize) {
					if (offset.intValue() == l*length.intValue()) {%>
					&nbsp;<%=l+1%>&nbsp;
					<%} else {%>
					&nbsp;<a href="javascript:fnSubmit1(<%=l*length.intValue()%>)" title="Click here to view next set of records"><%=l+1%></a>&nbsp;
					<%};
					l++;
				}%>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</form>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}
		Hibernate2Session.closeSession();
%>

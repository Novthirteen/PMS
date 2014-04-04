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
try{
if (AOFSECURITY.hasEntityPermission("EXPENSE", "_CLAIM", session)) {
	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	List result = null;	
	result = (List)request.getAttribute("QryList");
	if(result ==null){
		result = new ArrayList();
		request.setAttribute("QryList",result);
	}
	
	Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
	UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	
	String templateid = request.getParameter("template");
	if(templateid == null)templateid = ul.getParty().getPartyId();
	String textuser = request.getParameter("textuser");
	String textproj = request.getParameter("textproj");
	String textstatus = request.getParameter("textstatus");
	String textcode = request.getParameter("textcode");
	String departmentId = request.getParameter("departmentId");
	String DateStart = request.getParameter("DateStart");
	String DateEnd = request.getParameter("DateEnd");
	String ConfirmStart = request.getParameter("ConfirmStart");
	String ConfirmEnd = request.getParameter("ConfirmEnd");
	String ClaimStart = request.getParameter("ClaimStart");
	String ClaimEnd = request.getParameter("ClaimEnd");
	if (textproj==null) textproj="";
	if (textstatus==null) textstatus="Posted To F&A";
	if (textuser==null) textuser="";
	if (textcode==null) textcode="";
	if (DateStart==null) DateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
	if (DateEnd==null) DateEnd=Date_formater.format(nowDate);
	if (ConfirmStart==null) ConfirmStart="";
	if (ConfirmEnd==null) ConfirmEnd="";
	if (ClaimStart==null) ClaimStart="";
	if (ClaimEnd==null) ClaimEnd="";

	List partyList_dep=null;
	try{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		PartyHelper ph = new PartyHelper();
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
	
	Integer length = new Integer(40);	

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
<form name="frm" action="findExpToClaimPage.do" method="post">
<input type="hidden" name="FormAction" id="FormAction">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Expense Forms to Pay-Out</CAPTION>
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
					<option value="Posted To F&A" <%if (textstatus.equals("Posted To F&A")) out.print("selected");%>>Posted To F&A</option>
					<option value="Confirmed" <%if (textstatus.equals("Confirmed")) out.print("selected");%>>F&A Confirmed</option>
					<option value="F&A Rejected" <%if (textstatus.equals("F&A Rejected")) out.print("selected");%>>F&A Rejected</option>
					<option value="Claimed" <%if (textstatus.equals("Claimed") || textstatus.equals("Exported")) out.print("selected");%>>Claimed</option>
					</select>
				</td>
				
			</tr>
			<tr>
				<td class="lblbold">ER No.:</td>
				<td class="lblLight"><input type="text" name="textcode" value="<%=textcode%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Project:</td>
				<td class="lblLight"><input type="text" name="textproj" value="<%=textproj%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
				<td class="lblbold">Include Exported Data</td>
				<td class="lblLight"><%String ExportFlag = request.getParameter("ExportFlag");
					if (ExportFlag == null) ExportFlag = "N";%>
					<input TYPE="RADIO" class="radiostyle" NAME="ExportFlag" VALUE="Y" <%if(ExportFlag.equals("Y")) out.print("CHECKED");%>>Yes
					<input TYPE="RADIO" class="radiostyle" NAME="ExportFlag" VALUE="N" <%if(ExportFlag.equals("N")) out.print("CHECKED");%>>No
				</td>

			</tr>
			<tr>
				<td class="lblbold">Entry Date:</td>
				<td class="lblLight">
					<input TYPE="text" maxlength="15" size="10" name="DateStart" value="<%=DateStart%>">
					<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.DateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
					~
					<input TYPE="text" maxlength="15" size="10" name="DateEnd" value="<%=DateEnd%>">
					<A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.DateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
				</td>
				<td class="lblbold">Last Confirm Date:</td>
				<td class="lblLight">
					<input TYPE="text" maxlength="15" size="10" name="ConfirmStart" value="<%=ConfirmStart%>">
					<A href="javascript:ShowCalendar(document.frm.dimg3,document.frm.ConfirmStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg3 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
					<!-- ~
					<input TYPE="text" maxlength="15" size="10" name="ConfirmEnd" value="<%=ConfirmEnd%>">
					<A href="javascript:ShowCalendar(document.frm.dimg4,document.frm.ConfirmEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg4 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
					-->
				</td>
				<td class="lblbold">Last Claim Date:</td>
				<td class="lblLight">
					<input TYPE="text" maxlength="15" size="10" name="ClaimStart" value="<%=ClaimStart%>">
					<A href="javascript:ShowCalendar(document.frm.dimg5,document.frm.ClaimStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg5 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
					<!-- ~
					<input TYPE="text" maxlength="15" size="10" name="ClaimEnd" value="<%=ClaimEnd%>">
					<A href="javascript:ShowCalendar(document.frm.dimg6,document.frm.ClaimEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg6 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
					-->
				</td>
			</tr>
			<tr>
				<td class="lblbold">Using Template:</td>
				<td><select name="template">
				<option value="003" <%if(("003").equals(templateid))out.print("selected");%> >Beijing
				<option value="002" <%if(("002").equals(templateid))out.print("selected");%> >Shanghai
				</select>
				</td>
				<td colspan=4/>
			</tr>
			<tr><td colspan=6 /></tr>
			<tr>
			  
				<td colspan=8 align="left">
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript:FormOperation('QueryForList','_self')">
					<input TYPE="button" class="button" name="btnExport" value="Pay-Out Selected" onclick="javascript:FormOperation('VerifySelection','_self')">
					<input TYPE="button" class="button" name="btnConfirm" value="Confirm Selected" onclick="javascript:FormOperation('ConfirmSelection','_self')">
					<input TYPE="button" class="button" name="btnUnconfirm" value="Reject Selected" onclick="javascript:FormOperation('UnconfirmSelection','_self')">
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
			<tr bgcolor="#e9eee9">
				<td class="lblbold" width="1%"><input type="checkbox" class="checkboxstyle" name=chkAll value='' onclick="javascript:checkUncheckAllBox(document.frm.chkAll,document.frm.chk)">&nbsp;</td>
				<td align="center" class="lblbold" width="6%">&nbsp;Customer&nbsp;</td>
				<td align="center" class="lblbold" width="15%">&nbsp;Project&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;ER No.&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;Staff Name&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;Paid By&nbsp;</td>
				
				<td align="center" class="lblbold" width="5%">&nbsp;Entry Date&nbsp;</td>
				<td align="center" class="lblbold" width="4%">&nbsp;Entry Amount&nbsp;</td>
				<td align="center" class="lblbold" width="4%">&nbsp;Verified Amount&nbsp;</td>
				<td align="center" class="lblbold" width="4%">&nbsp;Claimed Amount&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;F&A Confirm Date&nbsp;</td>
				<td align="center" class="lblbold" width="5%">&nbsp;F&A Claim Date&nbsp;</td>
				<td align="center" class="lblbold" width="4%">&nbsp;Status&nbsp;</td>
			</tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.expense.ExpenseMaster">
			<%ExpenseMaster em = (ExpenseMaster)p;%>
			<tr bgcolor="#e9eee9">
                <td align="left">
	                <input type="checkbox" class="checkboxstyle" name=chk value="<%=em.getId()%>" onclick='javascript:checkTopBox(document.frm.chkAll,document.frm.chk)'>
                </td>
                <td align="left"><%=em.getProject().getCustomer().getDescription()%></td>
				<td align="left"><%=em.getProject().getProjId()%>:<%=em.getProject().getProjName()%></td>
                <td align="left">
					<a href="claimExpense.do?DataId=<%=em.getId()%>"><%=em.getFormCode()%></a> 
                </td>
                <td align="left"><%=em.getExpenseUser().getName()%></td>
				<td align="left">
					<%if (em.getClaimType().equals("CY")) {
						out.println("Customer");
					} else {
						out.println("Company");
					}%>
                </td>
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
				<td align="right"><%=em.getFAConfirmDate() != null ? Date_formater.format(em.getFAConfirmDate()) : "N/A"%></td>
				<td align="right"><%=em.getReceiptDate() != null ? Date_formater.format(em.getReceiptDate()) : "N/A"%></td>
				<td><%=em.getStatus()%></td>
			</tr>
			</logic:iterate> 		
			<tr>
				<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<input type="hidden" name="offset" id="offset" value="<%=offset%>">
				<%
				int RecordSize = 0;
				if (result!=null)
					RecordSize = result.size();
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
}catch(Exception e) {
			e.printStackTrace();
		}
%>

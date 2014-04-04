<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
	/*ProjectCostMaster findmaster = (ProjectCostMaster)request.getAttribute("findmaster");
	String DataId=request.getParameter("DataId");
	if(DataId == null ) DataId = "";
	if (findmaster != null) DataId = findmaster.getCostcode().toString();
	String Type=request.getParameter("Type");
    if (Type == null) Type = "";
    String tt = "";
    if (Type.equals("Expense")) {
		tt = "OTHER_COST";
	}else{
		tt = "PROCU_SUB";
	}
	*/
	List result = null;	
	result = (List)request.getAttribute("QryList");
	if(result ==null){
		result = new ArrayList();
		request.setAttribute("QryList",result);
	}
	String Type=request.getParameter("Type");
	String costType=request.getParameter("CostType");

    if (Type == null) Type = "";
    String tt = "";
    if (Type.equals("Expense")) {
		tt = "OTHER_COST";
	}else{
		tt = "PROCU_SUB";
	}
if (AOFSECURITY.hasEntityPermission(tt, "_VIEW", session)) {
	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	
	
	Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
	
	String textsrc = request.getParameter("textsrc");
	String texttype = request.getParameter("texttype");
	String departmentId = request.getParameter("departmentId");
	String DateStart = request.getParameter("DateStart");
	String DateEnd = request.getParameter("DateEnd");
	String textProj = request.getParameter("textProj");
	String textUser = request.getParameter("textUser");
	String textStatus = request.getParameter("textStatus");
	String textPAConfirm = request.getParameter("textPAConfirm");
	String textPaid = request.getParameter("textPaid");
	if (textPaid==null) textPaid="";
	if (textStatus==null) textStatus="";
	if (textPAConfirm==null) textPAConfirm="";
	if (textsrc==null) textsrc="";
	if (texttype==null) texttype="";
	if (departmentId == null) departmentId = "";
	if (textProj==null) textProj="";
	if (textUser==null) textUser="";
	if (DateStart==null) DateStart=Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
	if (DateEnd==null) DateEnd=Date_formater.format(nowDate);
	
	
    
	List partyList_dep=null;
	List CostTypeList = null;
	try{
		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		String statement = "select pct from ProjectCostType as pct where pct.typeaccount='"+Type+"' ";
		if (costType != null && costType.trim().length() != 0) {
			statement = statement + " and pct.typeid = '"+costType+"'";
		} else {
			statement = statement + " and pct.typeid != 'EAF'";
		}
		CostTypeList = hs.createQuery(statement).list();
		if (CostTypeList == null) CostTypeList = new ArrayList();
		
		PartyHelper ph = new PartyHelper();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
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
	
	Integer length = new Integer(15);

    request.setAttribute("offset", offset);
    request.setAttribute("length", length);
    
    int i = offset.intValue()+1;
%>
<script language="Javascript">
function fnSubmit1(start) {
	with (document.frm) {
		FormAction.value="QueryForList";
		offset.value=start;
		submit();
	}
}
function FormOperation(aval, tval) {
	with (document.frm) {
		FormAction.value = aval;
		target = tval;
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
<form name="frm" action="findCostSelfPage.do?Type=<%=Type%><%=costType != null && costType.trim().length() != 0 ? "&CostType=" + costType : ""%>" method="post">
<input type="hidden" name="FormAction" id="FormAction">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>
<%
if (Type.equals("Expense")) {
	if (costType != null && costType.equals("EAF")) {
		out.print("AirFare Cost Form List");
	} else {
		out.print("Other Cost Form List");
	}
}
if (Type.equals("ExtCost")) out.print("Procurement/SubContract Form List");%>
</CAPTION>
<tr>
	<td>
		<TABLE width="100%" >
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Ticket Code:</td>
				<td class="lblLight"><input type="text" name="textsrc" size="20" value="<%=textsrc%>"></td>
				<td class="lblbold">&nbsp;Cost <bean:message key="prm.projectCostMaintain.typeLable"/>:</td>
				<td class="lblLight">
					<select name="texttype">
					<%
						if (costType == null || !costType.equals("EAF")) {
					%>					
					<option value="">(All)</option>
					<%
						}
					%>
				<%
				Iterator itt = CostTypeList.iterator();
				while(itt.hasNext()){
					ProjectCostType pct = (ProjectCostType)itt.next();
					if (pct.getTypeid().equals(texttype)) {%>
					<option value="<%=pct.getTypeid()%>" selected><%=pct.getTypename()%></option>
					<%} else{%>
					<option value="<%=pct.getTypeid()%>"><%=pct.getTypename()%></option>
					<%}
				}%>
					</select>
				</td>
				<%
					if (costType != null && costType.equals("EAF")) {
				%>
				<td class="lblbold">&nbsp;Flight Date:</td>
				<%
					} else {
				%>
				<td class="lblbold">&nbsp;<bean:message key="prm.projectCostMaintain.costDateLable"/>:</td>
				<%
					}
				%>
				<td class="lblLight">
					<input TYPE="text" maxlength="15" size="10" name="DateStart" value="<%=DateStart%>">
					<A href="javascript:ShowCalendar(document.frm.dimg1,document.frm.DateStart,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
					~
					<input TYPE="text" maxlength="15" size="10" name="DateEnd" value="<%=DateEnd%>">
					<A href="javascript:ShowCalendar(document.frm.dimg2,document.frm.DateEnd,null,0,330)" onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif"></A>
				</td>
				
			</tr>
			<tr>
			<td class="lblbold">Department:</td>
				<td class="lblLight">
					<select name="departmentId">
						<option value="">All Related To You </option>
					<%
					if (AOFSECURITY.hasEntityPermission(tt, "_ALL", session)) {
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();%>
							
							<%if (p.getPartyId().equals(departmentId)) {%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%} else{%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%}
						}
					}%>
					</select>
				</td>
				<td class="lblbold">Project:</td>
				<td class="lblLight"><input type="text" name="textProj" size="20" value="<%=textProj%>"></td>
				<td class="lblbold">Staff:</td>
				<td class="lblLight"><input type="text" name="textUser" size="20" value="<%=textUser%>"></td>
				</tr>
				<tr>
					<td class="lblbold">Status:</td>
					<td class="lblLight">
						<select name="textStatus">
							<option value="">Select All</option>
							<option value="confirmed"<%if(textStatus.equals("confirmed"))out.print("selected");%>>Confirmed </option>
							<option value="unconfirmed"<%if(textStatus.equals("unconfirmed"))out.print("selected");%>>Not Confirmed </option>
							<option value="posted"<%if(textStatus.equals("posted"))out.print("selected");%>>Post To FA </option>
							<option value="paid"<%if(textStatus.equals("paid"))out.print("selected");%>>Paid </option>
					</td>
					<%
					if (costType != null && costType.equals("EAF")) {
					%>
					<td class="lblbold">PA Confimation:</td>
					<td class="lblLight">
						<select name="textPAConfirm">
							<option value="">Select All</option>
							<option value="confirmed"<%if(textPAConfirm.equals("confirmed"))out.print("selected");%>>Confirmed </option>
							<option value="unconfirmed"<%if(textPAConfirm.equals("unconfirmed"))out.print("selected");%>>Not Confirmed </option>
					</td>
					<%}%>
					<td class="lblbold">Paid By:</td>
					<td class="lblLight">
						<select name="textPaid">
							<option value="">Select All</option>
							<option value="CN"<%if(textPaid.equals("CN"))out.print("selected");%>>Company</option>
							<option value="CY"<%if(textPaid.equals("CY"))out.print("selected");%>>Customer</option>
					</td>
				</tr>
				<tr>
				<%
					if (costType != null && costType.equals("EAF") && (AOFSECURITY.hasEntityPermission("AIRFARE_PA", "_CONFIRM", session)) ) {
					%>
				<td  align="center">
					<input TYPE="button" class="button" name="btnConfirm" value="Billing Confirm" onclick="javascript:FormOperation('PAConfirm','_self')"> &nbsp; &nbsp; &nbsp;
				</td>
				<td  align="center">
					<input TYPE="button" class="button" name="btnUNConfirm" value="Billing Un-Confirm" onclick="javascript:FormOperation('PAUNConfirm','_self')"> &nbsp; &nbsp; &nbsp;
				</td>
				<%}else{%>
				<td colspan=3 align="left"/>
				<%}%>
				
				<td  align="center" nowrap>
					<input TYPE="button" class="button" name="btnSearch" value="Query" onclick="javascript:FormOperation('QueryForList','_self')">
					<input TYPE="button" class="button" name="btnNew" value="New" onclick="location.replace('projectCostMaintain.do?Type=<%=Type%><%=costType != null && costType.trim().length() != 0 ? "&CostType=" + costType : ""%>');">
				</td>
				<% if (AOFSECURITY.hasEntityPermission("AIRFARE_PA", "_CONFIRM", session)){%>
				<td  align="center">
					<input TYPE="button" class="button" name="btnPost" value="Post To F&A" onclick="javascript:FormOperation('PostToFA','_self')"> &nbsp; 
				</td>
				<td  align="center" nowrap colspan='2'>
					<input TYPE="button" class="button" name="btnPrint" value="Export Excel" onclick="javascript:FormOperation('ExcelPrint','_self')"> &nbsp; 
					<input TYPE="button" class="button" name="btnApproval" value="Confirm Selected" onclick="javascript:FormOperation('Confirm','_self')"> &nbsp; &nbsp; &nbsp;
				</td><% }%>
				
				</tr>
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
				<%
					if (costType != null && costType.equals("EAF")) {
				%>
				<td align="center" width="1%" class="lblbold"><input type=checkbox class="checkboxstyle" name=chkAll value='' onclick="javascript:checkUncheckAllBox(document.frm.chkAll,document.frm.chk)">&nbsp;</td>
				<td align="center" width="5%" class="lblbold">Ticket Code</td>	
				<td align="center" width="5%" class="lblbold">Flight No.</td>				
				<%
					} else {
				%>
				<td align="center" width="1%" class="lblbold"><bean:message key="prm.projectCostMaintain.costList.noLable"/> </td>
				<td align="center" width="5%" class="lblbold"><bean:message key="prm.projectCostMaintain.refNoLable"/></td>
				<%
					}
				%>	
				<td align="center" width="7%" class="lblbold">Staff</td>			
                <td align="center" width="10%" class="lblbold"><bean:message key="prm.projectCostMaintain.costDescriptionLable"/></td>
                <%
					if (costType != null && costType.equals("EAF")) {
				%>
				<td align="center" width="7%" class="lblbold">Paid By</td>
				<%
					} else {
				%>
                <td align="center" width="10%" class="lblbold">Cost <bean:message key="prm.projectCostMaintain.typeLable"/></td>
                <%
					}
				%>	
                <td align="center" width="5%" class="lblbold"><bean:message key="prm.projectCostMaintain.currencyLable"/></td>
                <%
					if (costType != null && costType.equals("EAF")) {
				%>
				<td align="center" width="5%" class="lblbold">Price</td>
				<%
					} else {
				%>
                <td align="center" width="6%" class="lblbold"><bean:message key="prm.projectCostMaintain.totalValueLable"/></td>
                <%
					}
				%>
				<%
					if (costType != null && costType.equals("EAF")) {
				%>
				<td align="center" width="6%" class="lblbold">Flight Date</td>
				<%
					} else {
				%>
                <td align="center" width="6%" class="lblbold"><bean:message key="prm.projectCostMaintain.costDateLable"/></td>
                 <%
					}
				%>
                <td align="center" width="6%" class="lblbold"><bean:message key="prm.projectCostMaintain.createDateLable"/></td>
                 <td align="center" width="6%" class="lblbold">Status</td>
                <td align="center" width="6%" class="lblbold"><bean:message key="prm.projectCostMaintain.approvalDateLable"/></td> 
                <%
					if (costType != null && costType.equals("EAF")) {
				%>
				 <td align="center" width="6%" class="lblbold">Billing Confirmation</td>

				 <td align="center" width="6%" class="lblbold">Export Date</td>
				<%}%>
              </tr>
           	<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.expense.ProjectCostMaster" >                
           	  <tr bgcolor="#e9eee9">  
                <%
					if (costType != null && costType.equals("EAF")) {
				%>
                <td align="center">
	                <input type=checkbox class="checkboxstyle" name=chk value="<%=((ProjectCostMaster) p).getCostcode()%>" onclick='javascript:checkTopBox(document.frm.chkAll,document.frm.chk)'>
                </td>
                <%
					} else {
				%>
                <td align="left">
                	<a href="projectCostMaintain.do?Type=<%=Type%><%=costType != null && costType.trim().length() != 0 ? "&CostType=" + costType : ""%>&DataId=<bean:write name="p" property="costcode"/>"><%= i++%></a>
                </td>
                <%
					}
				%>
				 <td align="left">
                	<%=((ProjectCostMaster) p).getFormCode()%>
                </td>
                <td align="left"> 
                  <a href="projectCostMaintain.do?Type=<%=Type%><%=costType != null && costType.trim().length() != 0 ? "&CostType=" + costType : ""%>&DataId=<bean:write name="p" property="costcode"/>"><bean:write name="p" property="refno"/></a> 
                </td>
                <td align="left">
                	<%=((ProjectCostMaster) p).getUserLogin().getName()%>
                </td>
                <td>
                    <bean:write name="p" property="costdescription"/>
                </td>
                <%
					if (costType != null && costType.equals("EAF")) {
				%>   
				<td align="center">
                 	<%if(((ProjectCostMaster) p).getClaimType().equals("CN")){ out.print("Company");}else{out.print("Customer");}%>
                </td>
				<%
					} else {
				%>     
                <td align="center">
                 	<%=((ProjectCostMaster) p).getProjectCostType().getTypename()%>
                </td>
                <%
					} 
				%> 
                
                <td align="center">
                 	<%=((ProjectCostMaster) p).getCurrency().getCurrName()%>
                </td>
                <td  align="right">
                   <bean:write name="p" property="totalvalue"/>
                </td>
                <td align="center">
                    <%=Date_formater.format(((ProjectCostMaster) p).getCostdate())%>
                </td>
                <td align="center">
                    <%=Date_formater.format(((ProjectCostMaster) p).getCreatedate())%>
                </td>
                <td align="center">
                    <%=((ProjectCostMaster) p).getPayStatus()%>
                </td>
				<td align="center">
                    <%if (((ProjectCostMaster) p).getApprovalDate() !=  null) out.print(Date_formater.format(((ProjectCostMaster) p).getApprovalDate()));%>
                </td>
                 <%
					if (costType != null && costType.equals("EAF")) {
				%>
				 <td align="center">
				  <%if (((ProjectCostMaster) p).getPAConfirm() !=  null) out.print(Date_formater.format(((ProjectCostMaster) p).getPAConfirm()));%>			 
				 </td>
				 <td align="center">
				  <%if (((ProjectCostMaster) p).getExportDate() !=  null) out.print(Date_formater.format(((ProjectCostMaster) p).getExportDate()));%>			 
				 </td>
				<%}%>
                </tr>
				</logic:iterate>
				<tr>
				<td width="100%" colspan="14" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<input type="hidden" name="offset" id="offset" value="<%=offset%>">
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
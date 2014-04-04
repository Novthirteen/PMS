<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld"prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld"prefix="tiles"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("CUST_PROJECT_MEMBER", "_CREATE", session)) {
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();   
//List depList=null;

String option = request.getParameter("option");
String id = request.getParameter("id");
String createFlag = request.getParameter("createFlag");

if (id == null) id = ""; 
String departmentId = request.getParameter("departmentId");
if (departmentId == null || "createFlag".equals(createFlag)) departmentId = ""; 
String action=request.getParameter("action");
String DataId = request.getParameter("hiddenDataId");
String memberId=request.getParameter("memberId");
if (memberId == null || "createFlag".equals(createFlag)) memberId = ""; 
String DateStart=request.getParameter("DateStart");
if (DateStart == null || "createFlag".equals(createFlag)) DateStart = "";
String DateEnd = request.getParameter("DateEnd"); 
if (DateEnd == null || "createFlag".equals(createFlag)) DateEnd = "";


List memList=null;
PartyHelper ph = new PartyHelper();
	List depList=ph.getAllPASUnits(hs);
try{
	//get all the department
	//PartyHelper ph = new PartyHelper();
	//List depList=ph.getAllOrgUnits(hs);
	memList = (List)request.getAttribute("memberResult");
	if (!"createFlag".equals(createFlag)) {
		if(memList==null){
			UserLoginHelper ulh = new UserLoginHelper();
		    memList = ulh.getAllUser(hs);
		} 
	} else {
		memList = new ArrayList();
	}
}catch(Exception e){
	out.println(e.getMessage());
}	

%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/memberSelect.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>

<script language="javascript">
function selmember(){
	
	var depId=document.SelForm.departmentId.value;
	document.SelForm.submit();
}
function checkDate() {
	var errormessage="";
	if(document.SelForm.DateStart.value=="")
	{
		errormessage="The start date couldn't be null";
    }
	else if(document.SelForm.DateEnd.value=="")
	{
		errormessage="The end date couldn't be null";
    }
	else if(document.SelForm.DateStart.value > document.SelForm.DateEnd.value)
	{
		errormessage="The end date is earlier than the start date";
    }
    
    return errormessage;
}
function fnUpdte() {
	var errormessage=checkDate();

	if (errormessage != "") {
	
		alert(errormessage);
		
	}
	else
	{
	document.SelForm.action.value="edit";
	document.SelForm.submit();
	}
}
function onClose() {
	window.parent.returnValue = "refresh";
	window.parent.close();
}
function fnCreate(){
	var errormessage=checkDate();

	if (errormessage != "") {
	
		alert(errormessage);
		
	}
	else
	{
	document.SelForm.action.value="create";
	document.SelForm.createFlag.value = "createFlag";
	document.SelForm.submit();
	}
}
</script>
<form action="selMember.do" method="POST" name="SelForm">

<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<input type="hidden" name="option" id="option" value="<%=option%>">
<input type="hidden" name="CALLBACKNAME" id="CALLBACKNAME">
<input type="hidden" name="hiddenDataId" id="hiddenDataId" value="<%=DataId%>">
<input type="hidden" name="hiddenAdd" id="hiddenAdd">
<input type="hidden" name="hiddenMemberId" id="hiddenMemberId">
<input type="hidden" name="hiddenDateStart" id="hiddenDateStart">
<input type="hidden" name="hiddenDateEnd" id="hiddenDateEnd">
<input type="hidden" name="id" id="id" value="<%=id%>">
<input type="hidden" name="depId" id="depId">
<input type="hidden" name="action" id="action">
<input type="hidden" name="createFlag" id="createFlag">


<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Project Member Select</CAPTION>
</table>

<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
	<tr bgcolor="e9eee9">
		<td class=lblbold>Select Department:</td>
		<td class=lblbold>
			&nbsp;
		<select name="departmentId" onchange="selmember()">
			<option >Select...</option>
			<%
			Iterator itd = depList.iterator();
			while(itd.hasNext()){
				Party p = (Party)itd.next();
				if( p.getPartyId().equals(departmentId) ){
					out.println("<option value=\""+p.getPartyId()+"\" selected>"+p.getDescription()+"</option>");
				}else{
					out.println("<option value=\""+p.getPartyId()+"\">"+p.getDescription()+"</option>");
				}
			
			}
			%>
			
		  </select>		
			
		</td>
	</tr>
	<input name="CALLBACKNAME" id="CALLBACKNAME" type="hidden" >
	<tr bgcolor="e9eee9">
		<td class=lblbold>select Member:</td>
		<td class=lblbold>
			&nbsp;
			
			<select name="memberId" >
			
			<%
			if(!memList.isEmpty()){
			
			Iterator it= memList.iterator();
			while(it.hasNext()){
				UserLogin ul = (UserLogin)it.next();
			   if(ul.getUserLoginId().equals(memberId)){
			%>
			<option value="<%=ul.getUserLoginId()%>" selected><%=ul.getName()%></option>
			<%
			   }else{
			%>
			       <option value="<%=ul.getUserLoginId()%>" ><%=ul.getName()%></option>
			<% }  
			}
			}
			else{
			%>
			<option selected>Select...</option>
		    <%   
		    }
		    %>
		  </select>	
			
		</td>
	</tr>
	<tr bgcolor="e9eee9">
	    <td class=lblbold>Start Date:</td>
	    <td class=lblbold>
			&nbsp;
		<input type="text" class="inputBox" name="DateStart" value="<%=DateStart%>">
        <A href="javascript:ShowCalendar(document.SelForm.dimg1,document.SelForm.DateStart,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
	</tr>
	<tr bgcolor="e9eee9">
	    <td class=lblbold>End Date:</td>
	    <td class=lblbold>
			&nbsp;
		<input type="text" class="inputBox" name="DateEnd" value="<%=DateEnd%>">
        <A href="javascript:ShowCalendar(document.SelForm.dimg2,document.SelForm.DateEnd,null,0,330)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg2 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
        </td>
	</tr>
	<tr>
		<td colspan=3 align=center>
			<%
				if (option != null && option.equalsIgnoreCase("edit")) {
			%>
		    	<input type=button  class=button value="Save" onclick="javascript:fnUpdte()">&nbsp;&nbsp;
		    <%
		    	} else {
		    %>
		    	<input type=button  class=button value="Save & Add Next" onclick="javascript:fnCreate()">&nbsp;&nbsp;
		    <%
		    	}
		    %>
			<input type=button name="save1" class=button value="Close" onclick="javascript:onClose()">
		  	<input type="hidden" value="<%=DataId%>" name="DataId" id="DataId">
			<input type="hidden" name="add" id="add" value="add">	
		</td>
		
	</tr>
</form>	
</table>

<%
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>

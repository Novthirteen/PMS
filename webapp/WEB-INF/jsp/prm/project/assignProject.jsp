<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (AOFSECURITY.hasEntityPermission("CUST_PROJECT_MEMBER", "_CREATE", session)) {
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

ProjectMaster CustProject = (ProjectMaster)request.getAttribute("ProjectResult");;

String DataId = request.getParameter("DataId");
int i=1;
CustProject = (ProjectMaster)request.getAttribute("ProjectResult");

String action = request.getParameter("action");
if(action == null) action = "create";
%>
<%
if(CustProject!= null){
	action="Update";
	String add = request.getParameter("add");
	if (add == null) add = "";
	String paId=request.getParameter("paId");
	/////////////////////////////////////////////////////
	//以下代码处理项目成员的增加工作
	/////////////////////////////////////////////////////
	
	try{
		if(add.equals("delete")){
			/////////////////////////////////////////////////////
			//一下代码处理项目成员的删除工作
			/////////////////////////////////////////////////////
			if(paId != null && !paId.equals("")){
			    Long Id=new Long(paId);
				tx = hs.beginTransaction();
				ProjectAssignment pa = (ProjectAssignment)hs.load(ProjectAssignment.class,Id);
				hs.delete(pa);
				tx.commit();
			}
	    }
	}catch(Exception e){
			out.println("Error:"+e.getMessage());
	}
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/memberSelect.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
function FnDelete() {
	document.EditForm.action.value = "delete";
	document.EditForm.submit();
}
function FnUpdate() {
	document.EditForm.action.value = "update";
	document.EditForm.submit();
}
function FnClose() {
	document.EditForm.action.value = "update";
	document.EditForm.projectStatus.value = "Close";
	document.EditForm.submit();
}

function showDialog(option, id, departmentId, memberId, DateStart, DateEnd) {
	var dataId = document.EditForm.Id.value;
	var param = "option="+option+"&hiddenDataId="+dataId;
	if (id != null) {
		param = param + "&id="+id;
	}
	if (departmentId != null) {
		param = param + "&departmentId="+departmentId;
	}
	if (memberId != null) {
		param = param + "&memberId="+memberId;
	}
	if (DateStart != null) {
		param = param + "&DateStart="+DateStart;
	}
	if (DateEnd != null) {
		param = param + "&DateEnd="+DateEnd;
	}
	
	v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectassignment.assignmember.title&selMember.do?"+param,
			null,
			'dialogWidth:600px;dialogHeight:350px;status:no;help:no;scroll:no');
	if (v == "refresh") {
		document.EditForm.submit();
	}
}

function onCloseDialog() {
	var formObj = document.forms["EditForm"];
	setValue("EditForm","hiddenDataId","DataId");
	setValue("EditForm","hiddenAdd","add");	
	setValue("EditForm","hiddenMemberId","memberId");
	setValue("EditForm","hiddenDateStart","DateStart");	
	setValue("EditForm","hiddenDateEnd","DateEnd");
	//formObj.elements["FormAction"].value = "create";
	formObj.submit();
}

</script>
<Form action="selMember.do" name="SelForm" method="post">
	<input type="hidden" name="CALLBACKNAME" value="">
	<input type="hidden" name="hiddenDataId" value="">
	<input type="hidden" name="departmentId" value="">
	<input type="hidden" name="memberId" value="">
	<input type="hidden" name="DateStart" value="">
	<input type="hidden" name="DateEnd" value="">
	<input type="hidden" name="id" value="">
	<input type="hidden" name="option" value="">
</Form>
<form action="assignProject.do" method="post" name="EditForm">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<input type="hidden" name="action" value="">
<input type="hidden" name="Id" value="<%=DataId%>">
<input type="hidden" name="DataId" value="<%=DataId%>">
<input type="hidden" name="add" value="">
<input type="hidden" name="memberId" value="">
<input type="hidden" name="DateStart" value="">
<input type="hidden" name="DateEnd" value="">
<input type="hidden" name="projectStatus" value="Open">
</form>
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>  Project Assignment </CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold" align=right>Project :</td><td class="lblLight"><%=CustProject.getProjId()%>&nbsp;:&nbsp;<%=CustProject.getProjName()%><input type="hidden" name="projectId" value="<%=CustProject.getProjId()%>"></td>
				<td class="lblbold" align=right>Contract No:</td><td class="lblLight"><%=CustProject.getContractNo()%>&nbsp;</td>	
				<td class="lblbold" align=right>Status :</td>
				<td class="lblLight"><%=CustProject.getProjStatus()%></td>	
			</tr>
			<tr>
			<td class="lblbold" align=right>Project Manager :</td>
			<td class="lblLight"><%=CustProject.getProjectManager().getName()%></td>
			<td class="lblbold" align=right>CAF Need :</td>
				<td class="lblLight"><% String NF = "";
				String CAFFlag = CustProject.getCAFFlag();
				if(CAFFlag.equals("Y")) NF = "YES";
				if(CAFFlag.equals("N")) NF = "NO";
				%>
				<%=NF%>
				</td>
			<td class="lblbold" align=right>Contract type :</td>
			<td class="lblLight"><% String NC = "";
				String OC = CustProject.getContractType();
				if(OC.equals("TM")) NC = "Time & Material";
				if(OC.equals("FP")) NC = "Fixed Price";
				%>
				<%=NC%>
				</td>
			<tr>
				<td class="lblbold" align=right>Customer :</td>
				<td class="lblLight"><%=CustProject.getCustomer().getDescription()%></td>
				
				<td class="lblbold" align=right>Start Date :</td>
				<td class="lblLight"><%=CustProject.getStartDate()%></td>	
				<td class="lblbold" align=right>End Date:</td>
				<td class="lblLight"><%=CustProject.getEndDate()%></td>
			</tr>
			<tr>
			<td class="lblbold" align=right>Parent Project :</td>
			<td class="lblLight"><%String ProjId = "";
				String ProjName = "";
				if (CustProject.getParentProject() != null) {
					ProjId = CustProject.getParentProject().getProjId();
					ProjName = CustProject.getParentProject().getProjName();
				}
				%>
			<div style="display:inline" id="labelParentProject"><%=ProjId%>:<%=ProjName%>&nbsp;</div></td>
			<td class="lblbold" align=right>
			Project Type :</td>
			<td class="lblLight"><%String PC = "";
			String OPC = CustProject.getProjectCategory().getId();
			if(OPC.equals("C")) PC = "External";
			if(OPC.equals("I")) PC = "Internal";
			%>
			<%=PC%>
			</td>
			</tr>
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
		</table>
	</td>
</tr>
</table>
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="wpsPortletTopTitle">
            Project Member Assignment Information
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
  <TD width='100%'>
    <table width='100%' border='0' cellspacing='0' cellpadding='0' >
      <tr>
        <td align="center" valign="center" width='100%'>
         
            <table width='100%' border='0' cellpadding='0' cellspacing='1'>
              <tr >
              	<td align="left" width="5%" class="bottomBox"> 
                </td>
                <td align="left" width="15%" class="bottomBox">
                 Name
                </td>
                <td align="left" width=25% class="bottomBox">
                E-Mail Address
                </td>
                <td align="left" width="20%" class="bottomBox">
                    Department
                </td>
                <td align="left" width="25%" class="bottomBox">
                    Duration
               </td>
               <td align="left" width="20%" class="bottomBox">
               </td>
              </tr>
              <%
				if(CustProject!=null){
					Query q=Hibernate2Session.currentSession().createQuery("select pa from ProjectAssignment as pa inner join pa.Project as p where p.projId = :DataId");
                    q.setParameter("DataId", DataId);
					List memberList=q.list();
					
                    if (memberList!=null){
                    request.setAttribute("projMembers",memberList);
				%>
				
				
				
				<!--==================== Show Project Member List ====================-->
				<logic:iterate id="pm" name="projMembers" type="com.aof.component.prm.project.ProjectAssignment" scope="request"> 
				<tr>
					<td align="left"><%= i++%> 
					</td>
					<td align="left">
					<%=((ProjectAssignment) pm).getUser().getName()%>
					</td>
					<td align="left">
					<%=((ProjectAssignment) pm).getUser().getEmail_addr()%>
					</td>
					<td align="left">
					<%=((ProjectAssignment) pm).getUser().getParty().getDescription()%>
					</td>
					<td align="left">
					<%=((ProjectAssignment) pm).getDateStart()%>~<%=((ProjectAssignment) pm).getDateEnd()%>
					</td>
					<td align="left">
					<a href="assignProject.do?DataId=<%=CustProject.getProjId()%>&paId=<%=((ProjectAssignment) pm).getId()%>&add=delete">Delete</a>
					&nbsp;&nbsp;
					<a href="JavaScript:onClick=showDialog('edit', '<%=((ProjectAssignment) pm).getId()%>', '<%=((ProjectAssignment) pm).getUser().getParty().getPartyId()%>', '<%=((ProjectAssignment) pm).getUser().getUserLoginId()%>', '<%=((ProjectAssignment) pm).getDateStart()%>', '<%=((ProjectAssignment) pm).getDateEnd()%>');">Edit</a>
					</td>
				</tr>
				</logic:iterate> 
				<%	
					}
				}
				%>
			  <tr><td colspan=6><hr size="1"></td></tr>
			  <tr><td COLSPAN=2>
				<form name="AddMemberForm" action="assignProject.do">
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" class="inputBox" value="Add Member" onclick="javascript:showDialog('add');">
				<input type="hidden" name="DataId">
				<input type="hidden" name="add">
				</form>
			   </td>
			   <td colspan=2></td>
			   <td>
			   <input type="button" class="inputBox" value="Back To List" onclick="location.replace('assignProject.do')">
			   </td>
			 </tr>
       </table>
  </td>
  </tr>                    
</table>
<%
}else{
String textproj = request.getParameter("textproj");
String textcust = request.getParameter("textcust");
String textstatus = request.getParameter("textstatus");
String departmentId = request.getParameter("departmentId");

if (textproj == null) textproj = "";
if (textcust == null) textcust = "";
if (textstatus == null) textstatus = "";
if (departmentId == null) departmentId = "";
				
List result = (List) request.getAttribute("ProjectList");
if(result ==null){
	result = new ArrayList();
	request.setAttribute("ProjectList",result);
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

int a = offset.intValue()+1;
SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
%>
<script language="javascript">
function fnSubmit1(start) {
	with (document.EditForm) {
		offset.value=start;
		submit();
	}
}
</script>
<form action="assignProject.do" method="post" name="EditForm">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall> Project List </CAPTION>
<form action="assignProject.do" method="post" name="EditForm">
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
			<tr>
				<td class="lblbold">Project:</td>
				<td class="lblLight"><input type="text" name="textproj" value="<%=textproj%>"></td>
				<td class="lblbold">Project Status:</td>
				<td class="lblLight">
					<select name="textstatus">
	<!--				    <option value=""></option> -->
				    <option value="WIP" <%if (textstatus.equals("WIP")) out.print("selected");%>>WIP</option>
				    <option value="Close" <%if (textstatus.equals("Close")) out.print("selected");%>>Close</option>
				    </select>
				</td>
				<td class="lblbold">Customer:</td>
				<td class="lblLight"><input type="text" name="textcust" value="<%=textcust%>"></td>
				<td class="lblbold">Department:</td>
				<td class="lblLight">
					<select name="departmentId">
					<option value ="" >All Related	to You</option>
					<%
					if (AOFSECURITY.hasEntityPermission("CUST_PROJECT_MEMBER", "_ALL", session)) {
						UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
						PartyHelper ph = new PartyHelper();
						List partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
						if (partyList_dep == null) partyList_dep = new ArrayList();
						partyList_dep.add(0,ul.getParty());
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(departmentId)) {%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
							<%} else{%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
							<%}
						}
					}%>
					</select>
				</td>
			<tr>
			    <td colspan=7 align="left"/>
				<td align="left">
					<input TYPE="submit" class="button" name="btnSearch" value="Query">
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
				<td class="lblbold">#</td>
				<td class="lblbold">Project Code</td>
				<td class="lblbold">Project Name</td>
				<td class="lblbold">Project Manager</td>
				<td class="lblbold">Customer</td>
				<td class="lblbold">Department</td>
				<td class="lblbold">Status</td>
				<td class="lblbold">Start Date</td>
				<td class="lblbold">End Date</td>
			</tr>
           	<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="ProjectList" type="com.aof.component.prm.project.ProjectMaster">
           	<tr bgcolor="#e9eee9">
           		<td><%=a++%></td>
           		<td><a href="assignProject.do?DataId=<bean:write name="p" property="projId"/>"><bean:write name="p" property="projId"/></a></td>
           		<td><bean:write name="p" property="projName"/></td>
           		<td><%=p.getProjectManager().getName()%></td>
           		<td><%=p.getCustomer().getDescription()%></td>
           		<td><%=p.getDepartment().getDescription()%></td>
           		<td><%=p.getProjStatus()%></td>
           		<td><%=p.getStartDate()%></td>
           		<td><%=p.getEndDate()%></td>
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
<%}
	Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
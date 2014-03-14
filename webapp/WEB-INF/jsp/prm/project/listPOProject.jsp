<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("CUST_CONT_PROJECT", "_VIEW", session)) {
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	List result = null;
	result = (List)request.getAttribute("QryList");
	if(result ==null){
		result = new ArrayList();
		request.setAttribute("QryList",result);
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
	List ptList=null;
	try{    
		ProjectHelper proh= new ProjectHelper();
		ptList=proh.getAllProjectType(hs);
	}catch(Exception e){
		out.println(e.getMessage());
	}  
	
	List partyList_dep=null;
	try{
		PartyHelper ph = new PartyHelper();
		UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		partyList_dep=ph.getAllSubPartysByPartyId(hs,ul.getParty().getPartyId());
		if (partyList_dep == null) partyList_dep = new ArrayList();
		partyList_dep.add(0,ul.getParty());
	}catch(Exception e){
		e.printStackTrace();
	}
%>
<script language="Javascript">
function fnSubmit1(start) {
	with (document.frm) {
		offset.value=start;
		submit();
	}
}
function showVendorDialog()
{
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&crm.dialogVendorList.do",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			document.getElementById("textvend").value=v.split("|")[1];
		}
	}
}
function showProjectDetail(DataId) {
	with(document.frm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.project.projectDetail.title&editPOProject.do?FormAction=dialogView&DataId="+DataId,
			null,
			'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:no');
	}
}
</script>

<form name="frm" action="listPOProject.do" method="post">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>PO Projects List</CAPTION>
<tr>
	<td>
	<TABLE width="100%">
			<tr>
				<td colspan=8><hr color=red></hr></td>
			</tr>
		<%
		String textcode = request.getParameter("textcode");
		String textdesc = request.getParameter("textdesc");
		String textstatus = request.getParameter("textstatus");
		String textvend = request.getParameter("textvend");
		String textcno = request.getParameter("textcno");
		String textdep = request.getParameter("textdep");
		if (textcode == null) textcode ="";
		if (textdesc == null) textdesc ="";
		if (textstatus == null) textstatus ="";
		if (textvend == null) textvend ="";
		if (textcno == null) textcno ="";
		if (textdep == null) textdep ="";
		%>
		<tr>
			<td class="lblbold">Code:</td>
			<td class="lblLight"><input type="text" name="textcode" size="15" value="<%=textcode%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
			<td class="lblbold">Description:</td>
			<td class="lblLight"><input type="text" name="textdesc" size="15" value="<%=textdesc%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
			<td class="lblbold">Vendor:</td>
			<td class="lblLight">
				<input type="text" name="textvend" size="15" value="<%=textvend%>" style="TEXT-ALIGN: right" class="lbllgiht">
				<a href="javascript:void(0)" onclick="showVendorDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
			</td>
	    </tr>
	    <tr>
	    <td class="lblbold">Status:</td>
		<td class="lblLight">
			<select name="textstatus" >
<!--			<option value="" <%if (textstatus.equals("")) out.print("selected");%>></option>	-->
				<option value="WIP" <%if (textstatus.equals("WIP")) out.print("selected");%>>WIP</option>
				<option value="PC" <%if (textstatus.equals("PC")) out.print("selected");%>>Project Completed</option>
				<option value="Close" <%if (textstatus.equals("Close")) out.print("selected");%>>Closed</option>
		    </select>
	    </td>
	    <td class="lblbold">PO No.:</td>
	    <td class="lblLight"><input type="text" name="textcno" size="15" value="<%=textcno%>" style="TEXT-ALIGN: right" class="lbllgiht"></td>
	    <td class="lblbold">Department:</td>
			<td class="lblLight">
				<select name="textdep">
					
					<%
					if (AOFSECURITY.hasEntityPermission("PAS_PM_REPORT", "_ALL", session)) {
						Iterator itd = partyList_dep.iterator();
						while(itd.hasNext()){
							Party p = (Party)itd.next();
							if (p.getPartyId().equals(textdep)) {
					%>
							<option value="<%=p.getPartyId()%>" selected><%=p.getDescription()%></option>
					<%
							} else{
					%>
							<option value="<%=p.getPartyId()%>"><%=p.getDescription()%></option>
					<%
							}
						}
					}
					%>
				</select>
			</td>
	    </tr>
	    <tr>
	        <td colspan=5/>
	    	<td  align="middle">
				<input type="submit" value="Query" class="button">
			    <input type="button" value="New" class="button" onclick="location.replace('editPOProject.do')">
			</td>
		</tr>
		<tr>
				<td colspan=8 valign="top"><hr color=red></hr></td>
		</tr>
	</table>
	</td>
</tr>
<tr>
	<td>
<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
  <TR bgcolor="#e9eee9">
  	<td class="lblbold">#&nbsp;</td>
    <td align="left" class="lblbold">Code</td>
    <td align="left" class="lblbold">Description</td>
    <td align="left" class="lblbold">Status</td>
	<td align="left" class="lblbold">PO No.</td>
    <td align="left" class="lblbold">Project Manager</td>
	<td align="left" class="lblbold">Vendor</td>
    <td align="left" class="lblbold">Department</td> 
    <td align="left" class="lblbold">CAF Need</td>
    <td align="left" class="lblbold">PO Type</td>
    <td align="left" class="lblbold">Parent Project</td>
  </tr>
  <logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.project.ProjectMaster" >                
  <tr bgcolor="#e9eee9">  
    <td align="left"><%=i++%></td>
    <td align="left"> 
    	<%
    		if (AOFSECURITY.hasEntityPermission("CUST_CONT_PROJECT", "_CREATE", session)) {
    	%>
		<a href="editPOProject.do?DataId=<bean:write name="p" property="projId"/>"><bean:write name="p" property="projId"/></a> 
		<%
			} else {
		%>
		<a href="#" onclick="showProjectDetail('<bean:write name="p" property="projId"/>');"><bean:write name="p" property="projId"/></a>
		<%
			}
		%>
    </td>
    <td align="left">
        <div class="tabletext">
        <p ><bean:write name="p" property="projName"/>
        </div>   
    </td>            
                <td align="left"> 
                  <div class="head4">                   
                    <p ><%=((ProjectMaster) p).getProjStatus()%>
                  </div>
                </td>
				<td align="left"> 
                  <div class="head4">                   
                    <p ><%=((ProjectMaster) p).getContractNo()%>
                  </div>
                </td>
				<td align="left"> 
                  <div class="head4">                   
                    <p ><%=((ProjectMaster) p).getProjectManager().getName()%>
                  </div>
                </td>
                <td align="left">
                    <div class="head4">
                    <p ><%=((ProjectMaster) p).getVendor().getDescription()%>
                    </div>
                </td>
                <td align="left">
                    <div class="head4">
                    <p > <%=((ProjectMaster) p).getDepartment().getDescription()%> 
                    </div>
                </td>
                <td align="left">
                    <div class="head4">
                    <p > <% String NF = "";
						String CAFFlag = ((ProjectMaster) p).getCAFFlag();
						if(CAFFlag.equals("Y")) NF = "YES";
						if(CAFFlag.equals("N")) NF = "NO";%>
						<%=NF%>
                    </div>
                </td>
                
                <td align="left"> 
                  <div class="head4">                   
                    <p ><%if (((ProjectMaster) p).getContractType().equals("FP")) out.print("Fixed Price"); else out.print("Time & Material");%>
                  </div>
                </td>
                 <td align="left">
                    <div class="head4">
                    <p > <%=((((ProjectMaster) p).getParentProject())==null) ? "":((ProjectMaster) p).getParentProject().getProjId()%> 
                    </div>
                </td>
               
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

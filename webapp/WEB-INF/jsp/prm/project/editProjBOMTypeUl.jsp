<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.util.Constants"%>
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
<%if (AOFSECURITY.hasEntityPermission("PMS", "_ST_MAINTENANCE", session)) {%>


<script language="JavaScript">
function fnContinue()
{
document.frm1.action = "editProjBOMSche.do";
document.frm1.formaction.value = "other";
document.frm1.submit();
}

function addLine()
{
	if(document.frm1.add_desc.value.length==0)
	{
	alert('please enter the type description!')
	return;
	}
	if(document.frm1.add_ul_name.value.length==0)
	{
		alert('please select a staff!')
		return;
	}
	document.frm1.formaction.value="add";
	document.frm1.submit();
}
function deleteLine(obj)
{
	var oRow = obj.parentNode.parentNode;//tr object
	document.frm1.formaction.value="delete";
	document.frm1.hid_id.value=oRow.id;
//	alert(document.frm1.hid_id.value)
	document.frm1.submit();
}

function showStaff() {
	var arr;
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
		document.frm1.add_ul_id.value=v.split("|")[0];
		document.frm1.add_ul_name.value=v.split("|")[1];
	}
}
</script>

<FORM name="frm1" action="EditProjBOMTypeUL.do" method=post>
<%try{
long start = System.currentTimeMillis();
long end = System.currentTimeMillis();
String actionflag = (String)request.getAttribute("actinflag");
String newflag = (String)request.getAttribute("newflag");

ProjPlanBomMaster master = (ProjPlanBomMaster)request.getAttribute("bommaster");
ProjectMaster pm = master.getProject();
String action = (String)request.getAttribute("formaction");
List list = (List)request.getAttribute("resultList");
if(list==null)
list = new LinkedList();
List childList = (List)request.getAttribute("childList");
if(childList==null)
	childList = new LinkedList();
	
%>
<input type="hidden" name="formaction" id="formaction" >
<input type="hidden" name="masterid" id="masterid" value="<%=master.getId()%>" >

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' align="center">
	<CAPTION align=center class=pgheadsmall>Assign Resource</CAPTION>
	<tr ><td colspan=7>&nbsp;</td></tr>
<tr align="center">
<td >&nbsp;</td>
<%if(master.getBid()!=null){%>
<td class=lblbold align="center">Bid : <%=master.getBid().getNo()%>
</td>
<td class=lblbold align="center">Bid Description : <%=master.getBid().getDescription()%>
</td>
<td class=lblbold align="center">Customer : <%=master.getBid().getProspectCompany().getDescription()%>
</td>
<%}%>
<%if(pm!=null){%>
<td class=lblbold align="center">Project : <%out.println(pm.getProjId());%>
</td>
<td class=lblbold align="center">Customer : <%=master.getProject().getCustomer().getDescription()%>
</td>
<%}%>
</tr>
</TABLE>
<table  border=0 width='100%' cellspacing='0' cellpadding='0' align="center">
	<tr ><td colspan=7>&nbsp;</td></tr>
<tr>
<td>
	<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
	  <TR>
	    <TD width='100%'>
	      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
	        <tr>
	          <TD align=left width='90%' class="topBox">customer servicetype	          </TD>
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
	                <td align="center" width="4%" class="bottomBox"> 
	                  <p align="cener"># 
	                </td>
	                <td align="center" width="8%" class="bottomBox"> 
	                  <p align="center">Description
	                </td>
	                        
	                <td align="center" width="8%" class="bottomBox"> 
	                  <p align="center">Service Type 
	                </td>
<!-- 	                <td align="center" width="10%" class="bottomBox">
	                    <p align="center">Service Rate
	                </td>
-->
	                <td align="center" width="8%" class="bottomBox"> 
	                  <p align="center">Staff 
	                </td>
<!-- 	                <td align="center" width="8%" class="bottomBox"> 
	                  <p align="center">Cost Level 
	                </td>
	                <td align="center" width="10%" class="bottomBox">
	                    <p align="center">Cost Rate
	                </td>
-->
	                <td align="center" width="10%" class="bottomBox">
	                    <p align="center">Action
	                </td>
	              </tr>
	              <%
	              if(childList.size()>0)//already created service type 
	              {
	              
					for(int i=0;i<childList.size();i++)
					{
					ProjPlanType ul = (ProjPlanType)childList.get(i);
	          %>
					<tr id="<%=ul.getId()%>" bgcolor="#e9eee9"> 
					<td class="lblbold" align="center"><input type="hidden" name="hid_status" id="hid_status" value="no"><%=(i+1)%>
						<input type="hidden" name="id" id="id" value="<%=ul.getId()%>"></td>
					<td class="lblbold" align="center"><%=ul.getDescription()%></td>
					<td class="lblbold" align="center"><%=ul.getParent().getDescription()%></td>
					<td class="lblbold" align="center"><%=ul.getStaff().getName()%></td>
					<td class="lblbold" align="center"><input type="button" value="Delete" onclick="javascript:deleteLine(this)"  class="button"></td>
					</tr>
					<%
						}
					
	              }
					%>
	                    </table>
	                </td>
	              </tr>
	            </table>
	         </td>
	        </tr>
	</table>

</td>
</tr>
	<tr ><td colspan=7>&nbsp;</td></tr>
	<tr ><td colspan=7>&nbsp;</td></tr>
	<tr ><td colspan=7>&nbsp;</td></tr>
	<tr ><td colspan=7>&nbsp;</td></tr>
<tr><td>
<table  width=350 >
<tr><td colspan="6"><hr ></hr></td></tr>
<tr align="left" bgcolor="#e9eee9">
<td class="lblbold" align="center">Description</td>
<td class="lblbold" align="center">Service Type</td>
<td class="lblbold" align="center">Service Rate</td>
<td class="lblbold" align="center" nowrap>Staff</td>
<td class="lblbold" align="center" nowrap>Action</td>
</tr>
<tr align="left">
	<td><input type="text" name="add_desc"  ></td>
	<td>
		<select name="add_st_id" onchange="javascript:fnChangeType(this)">
		<%for(int i=0;i<list.size();i++){
		ProjPlanType type = (ProjPlanType)list.get(i);
		%>
			<option value="<%=type.getId()%>"><%=type.getDescription()%>		
		<%}%>
		</select>
	</td>
	<td><input type="text" name="add_st_desc" readonly style="border:0px;text-align:right;background-color:#ffffff" 
		value="<%if(list.size()>0)out.println(((ProjPlanType)list.get(0)).getSTRate());%>">
	</td>
	<td nowrap><input type="hidden" name="add_ul_id" id="add_ul_id" value=""><input type="text" name="add_ul_name" style="text-align:center;border:0px;background-color:#ffffff"readonly>
		<a href='javascript: showStaff()'><img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0" /></a>
	</td>
	<td><input type="button" value="Add" onclick="javascript:addLine()" class="button"></td>
	</tr>
</table>
</td></tr>
</TABLE>
<br>

<table width="100%">
<tr><td>&nbsp;</td></tr>
<tr align="right"><td><input type="hidden" name="hid_id" id="hid_id">
<input type="button" value="Continue>>" onclick="javascript:fnContinue()" class="button">
<input type="button" value="BackToList" onclick="location.replace('findProjBOM.do?formaction=listsche')" class="button">
</td></tr>
</table>
<script language="javascript">

<%if(actionflag!=null){%>
var actionflag = "haha";
actionflag =  "<%=actionflag%>";
var array = actionflag.split('|');
alert(array[0]+" success!");
<%}%>
<%if(list.size()>0){%>
var arr =  new Array(<%=list.size()%>);
<%
	for(int i=0;i<list.size();i++)
	{
		ProjPlanType type = (ProjPlanType)list.get(i);
	%>
	arr[<%=i%>]= new Array(2);
	arr[<%=i%>][0] = <%=type.getId()%>;
	arr[<%=i%>][1] = <%=type.getSTRate()%>;
	<%
	}
	%>
<%}%>	

function fnChangeType(obj)
{
var id  = parseInt(document.frm1.add_st_id.value);
for(var i =0;i<arr.length;i++)
{
	if(arr[i][0] == id)
	{
	document.frm1.add_st_desc.value=arr[i][1];
	return;
	}
}
}

<%
end = System.currentTimeMillis();
System.out.println("takes:"+(end-start));
}catch(Exception e)
{ e.printStackTrace();}%>
</script>
</Form>
<%}else{
out.println("!!你没有相关访问权限!!");}%>
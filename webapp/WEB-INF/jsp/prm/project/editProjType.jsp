<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
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
<%if (AOFSECURITY.hasEntityPermission("PMS", "_ST_MAINTENANCE", session)) {

try{%>

<script language="JavaScript">

function showProjectDialog()
{
	var code,desc;
	var cid,cdesc;
	with(document.frm1)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&ProjectChooseDialogue.do?",
			null,
			'dialogWidth:600px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			cid = v.split("|")[2];
			cdesc = v.split("|")[3];
			labelProject.innerHTML=code+":"+desc;
			labelCustomer.innerHTML = cid+":"+cdesc;
			proj_id.value=code;
			proj_desc.value = desc;
			cust_id.value = cid;
			cust_desc.value = cdesc;
		}
	}
}

function goProjBOM()
{
document.frm1.action="editProjBOM.do";
document.frm1.submit;
}
function addLine()
{
	if(document.frm1.add_desc.value.length==0)
	{
	alert('please enter the type description!')
	return;
	}
	if(document.frm1.add_rate.value.length==0)
	{
	document.frm1.add_rate.value = 0;
//	alert('please enter the type description!')
//	return;
	}
	if(isNaN(parseFloat(document.frm1.add_rate.value)))
	{
	alert('please enter valid number!')
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
	document.frm1.submit();
}
function save()
{
	document.frm1.formaction.value="edit";
	document.frm1.submit();
}

function change(count)
{
	var status = document.getElementsByName("hid_status");
	status[count].value = "yes";
}

function showStaff(count) {
	var arr;
	v = window.showModalDialog(
	"system.showDialog.do?title=prm.timesheet.staffSelect.title&userList.do?openType=showModalDialog",
	null,
	'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
	if (v != null ) {
		if(count==-1)
		{
		document.frm1.add_member.value=v.split("|")[0];
		}
		else
		{
		arr = document.getElementsByName("member");
		arr[count].value = v.split("|")[0];
		change(count);
		}
	}
}

</script>

<FORM name="frm1" action="editProjType.do" method=post>
<%
String actionflag = (String)request.getAttribute("actinflag");
String newflag = (String)request.getAttribute("newflag");

ProjPlanBomMaster master = (ProjPlanBomMaster)request.getAttribute("bommaster");
ProjectMaster pm = master.getProject();
String action = (String)request.getAttribute("formaction");
boolean confirmflag = master.getReveConfirm()!=null?true:false;
List list = (List)request.getAttribute("resultList");
if(list==null)
list = new LinkedList();

List levelList = (List)request.getAttribute("level");
if(levelList==null)
levelList = new LinkedList();
List stList = (List)request.getAttribute("servicetype");
if(stList==null)
stList = new LinkedList();
//int gcount = 0;
int gap = 0; //for salary level list
%>
<input type="hidden" name="formaction" id="formaction" >
<input type="hidden" name="masterid" id="masterid" value="<%=master.getId()%>" >

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' align="center">
	<CAPTION align=center class=pgheadsmall>Project Precal Basic Data</CAPTION>
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
<%if(pm!=null){%><td class=lblbold align="center">Project : <%out.println(pm.getProjId());%>
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
	                  <p align="center">Service Type 
	                </td>
	                <td align="center" width="10%" class="bottomBox">
	                    <p align="center">Currency
	                </td>
	                <td align="center" width="10%" class="bottomBox">
	                    <p align="center">Service Rate
	                </td>
	                
	                <td align="center" width="8%" class="bottomBox"> 
	                  <p align="center">Department 
	                </td>

	                <td align="center" width="8%" class="bottomBox"> 
	                  <p align="center">Cost Type 
	                </td>
	                <td align="center" width="10%" class="bottomBox">
	                    <p align="center">Cost Rate(RMB)
	                </td>
	                <td align="center" width="10%" class="bottomBox">
	                    <p align="center">Tax Inclusive
	                </td>
	                <%if(!confirmflag){
	                	if(list.size()<=0){
	                %>
	                <td align="center" width="10%" class="bottomBox">
	                    <p align="center">Enable
	                </td>
	                <%}else{%>
	                <td align="center" width="10%" class="bottomBox">
	                    <p align="center">Action
	                </td>
	                <%}
	                }%>
	              </tr>
	              <%
	              if(list.size()>0)//already created service type 
	              {
	              
					for(int i=0;i<list.size();i++)
					{
					ProjPlanType ppt = (ProjPlanType)list.get(i);
	          %>
					<tr id="<%=ppt.getId()%>" bgcolor="#e9eee9"> 
					<td class="lblbold" align="center"><input type="hidden" name="hid_status" id="hid_status" value="no"><%=(gap+i+1)%>
						<input type="hidden" name="id" id="id" value="<%=ppt.getId()%>"></td>
					<td class="lblbold" align="center">
					<input type="text" name="desc" value="<%=ppt.getDescription()%>" 
						<%if(confirmflag){%>
						style="border:0px;text-align:center;background-color:#e9eee9" readonly
						<%}else{%>
						style="text-align:center;background-color:#ffffff;border-color:#7F9DB9"	onchange="javascript:change(<%=(gap+i)%>);"
						<%}%>
					 /> 
					</td>
					<td class="lblbold" align="center">
					<%if(ppt.getCurrency()!=null)out.println(ppt.getCurrency().getCurrId());%>
					</td>
					<td class="lblbold" align="center">
					<input type="text" name="rate" value="<%=ppt.getSTRate()%>" 
						<%if(confirmflag){%>
						style="border:0px;text-align:right;background-color:#e9eee9" readonly
						<%}else{%>
						style="text-align:right;background-color:#ffffff;border-color:#7F9DB9"	onchange="javascript:change(<%=(gap+i)%>);"
						<%}%>
					/> 
					</td>
					<td class="lblbold" align="center">
						<%=ppt.getSl().getParty().getDescription()%>
						</td>
					<td class="lblbold" align="center">
						<%=ppt.getSl().getDescription()%>
						</td>
					<td class="lblbold" align="center">
						<%=ppt.getSl().getRate()%>
						</td>
					<td class="lblbold" align="center">
						<%if(ppt.getTax()!=null)out.println("Y");else out.println("N");%>
					</td>
					<%if(!confirmflag){%>
					<td class="lblbold" align="center">
						<input type="button" value="Delete" onclick="javascript:deleteLine(this)"  class="button">
						</td>
					<%}%>
					</tr>
					<%
						}
					
	              }
	              else //still no service type
	              {
		              for(int i=0;i<stList.size();i++)
		              {
		              StandardServiceType sst  = (StandardServiceType)stList.get(i);
	              %>
   					<tr id="<%=sst.getId()%>" bgcolor="#e9eee9"> 
					<td class="lblbold" align="center"><input type="hidden" name="hid_status" id="hid_status" value="no"><%=(i+1)%>
						<input type="hidden" name="sstid" id="sstid" value="<%=sst.getId()%>"></td>
					<td class="lblbold" align="center">
						<input type="text" value="<%=sst.getDescription()%>" name="sstdesc" style="text-align:center;background-color:#ffffff;border-color:#7F9DB9">
					</td>
					<td class="lblbold" align="center">
						<input type="text" name="sstcurr_id" value="<%if(sst.getCurrency()!=null)out.println(sst.getCurrency().getCurrId());%>" 
						style="background-color:#e9eee9;text-align:center;border:0px" readonly>
					</td>
					<td class="lblbold" align="center">
						<input type="text" value="<%=sst.getRate()%>" name="sstrate" style="background-color:#ffffff;text-align:right;border-color:#7F9DB9"
						onchange="javascript:CheckDecimal(this)" >
					</td>
					<td>
						<select name="sl_dpt" onchange="javascript:fnChangeDpt(this,1)">
						</select>
					</td>
					<td class="lblbold" align="center">
						<select name="slid" onchange="javascript:fnSelect(this)">
						</select>
					</td>
					<td class="lblbold" align="center"><%if(levelList.size()>0)out.print(((SalaryLevel)levelList.get(0)).getRate());%></td>
					<td class="lblbold" align="center">
						<input type="checkbox" name="taxcheck" disabled value="<%=sst.getId()%>" style="border:0px;background-color:#e9eee9">
					</td>
					<td class="lblbold" align="center">
						<input type="checkbox" name="sstcheck" value="<%=sst.getId()%>" onClick="javascript:fnSyn(this)" style="border:0px;background-color:#e9eee9">
					</td>
					</tr>
	              <%}
	              gap = levelList.size();
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
<%if(!confirmflag){%>
<tr><td>
<table  width=300 >
<tr><td colspan="8"><hr ></hr></td></tr>
<tr align="left" bgcolor="#e9eee9">
<td class="lblbold" align="center">Service Type</td>
<td class="lblbold" align="center">Currency</td>
<td class="lblbold" align="center">Service Rate</td>
<td class="lblbold" align="center" nowrap>Department</td>
<td class="lblbold" align="center" nowrap>Cost Type</td>
<td class="lblbold" align="center" nowrap>Cost Rate</td>
<td class="lblbold" align="center" nowrap>Tax Inclusive</td>
<td class="lblbold" align="center" nowrap>Action</td>
</tr>
<tr align="left">
	<td align="center"><input type="text" name="add_desc" value="" style="background-color:#ffffff;border-color:#7F9DB9" onclick="javascript:this.value=''"></td>
	<td align="center">
		<select name="hid_curr_id" style="background-color:#ffffff">
		<%
		List currList = (List)request.getAttribute("currList");
		if(currList!=null)
		for(int i=0;i<currList.size();i++)
		{
			CurrencyType curr = (CurrencyType)currList.get(i);
			%>
			<option value="<%=curr.getCurrId()%>" <%if(curr.getCurrId().equalsIgnoreCase("rmb"))out.print("selected");%> ><%=curr.getCurrName()%>
			<%
		}
		%>
		</select>
	</td>
	<td align="center"><input type="text" name="add_rate" value="" style="background-color:#ffffff;border-color:#7F9DB9" 
	onchange="javascript:CheckDecimal(this)" onclick="javascript:this.value=''"></td>
	<td align="center"><input type="hidden" name="hid_sl_id" id="hid_sl_id" size="15">
		<select name="add_sl_dpt" onchange="javascript:fnChangeDpt(this,0)" style="background-color:#ffffff">
		</select>
	</td>
	<td id="label_sl" align="center">
		<select name="add_sldesc" onchange="javascript:fnChange(0,0,0)" style="background-color:#ffffff"  >
		</select>
	</td>
	<td align="center"><input type="text" size="10" name="add_slrate" value="<%if(levelList.size()>0)out.print(((SalaryLevel)levelList.get(0)).getRate());%>" 
		style="text-align:right;border:0px;background-color:#ffffff" readonly></td>
	<td align="center"><input type="checkbox" name="add_check"  style="border:0px;background-color:#ffffff"></td>
	<td align="center"><input type="button" value="Add" onclick="javascript:addLine()" class="button"></td>
	</tr>
</table>
</td></tr>
<%}%>
</TABLE>
<br>

<table width="100%">
<tr><td>&nbsp;</td></tr>
<tr align="right"><td><input type="hidden" name="hid_id" id="hid_id">
<%if((list.size()<1)&&(stList.size()>0)){%>
<input type="submit" value="create" onclick="javascript:document.frm1.formaction.value='insert'" class="button">
<%}else if(!confirmflag){%>
<input type="checkbox" name="email" value="y" style="border:0px;background-color:#ffffff">Send Email to Project Manager
<input type="submit" value="Save" onclick="javascript:document.frm1.formaction.value='edit'" class="button">
<%}%>
<input type="button" value="BackToList" onclick="location.replace('findProjBOM.do?formaction=listtype')" class="button">
</td></tr>
</table>
<script language="javascript">
<%if(levelList.size()>0){
%>
var arrDpt = new Array();
var arrLevel = new Array();
var lastDpt = "haha";
<%
	String s="haha";
	for(int i=0,j=0;i<levelList.size();)
	{
		SalaryLevel sl = (SalaryLevel)levelList.get(i);
		if(!s.equalsIgnoreCase(sl.getParty().getPartyId()))
		{
			s = sl.getParty().getPartyId();
			%>
			arrDpt[<%=j%>] = new Array(2);
			arrDpt[<%=j%>][0] = "<%=sl.getParty().getPartyId()%>"
			arrDpt[<%=j%>][1] = "<%=sl.getParty().getDescription()%>"
			<%
			j++;
		}
		else
		{
			%>
			arrLevel[<%=i%>] = new Array(4);
			arrLevel[<%=i%>][0] =  "<%=sl.getParty().getPartyId()%>"
			arrLevel[<%=i%>][1] =  "<%=sl.getDescription()%>"
			arrLevel[<%=i%>][2] =  "<%=sl.getRate()%>"
			arrLevel[<%=i%>][3] =  "<%=sl.getId()%>"
			<%
			i++;
		}
	}
	%>
	if(document.frm1.hid_sl_id!=null){
	document.frm1.hid_sl_id.value=arrLevel[0][3];
	}
	
	//dynamic genernate select box
	var obj = document.getElementsByName("add_sl_dpt");
	for(var i=0;i<arrDpt.length;i++)
	{
	var oOption = document.createElement("OPTION");
		obj[0].options.add(oOption)
		oOption.innerText = arrDpt[i][1];
		oOption.value = arrDpt[i][0];		
	}
	obj = document.getElementsByName("sl_dpt");
	for(var j=0;j<obj.length;j++)
	{
		for(var i=0;i<arrDpt.length;i++)
		{
			var oOption = document.createElement("OPTION");
			obj[j].options.add(oOption)
			oOption.innerText = arrDpt[i][1];
			oOption.value = arrDpt[i][0];		
		}			
	}
		
	obj = document.getElementsByName("add_sldesc");
	for(var i=0;i<arrLevel.length;i++)
	{
		var oOption = document.createElement("OPTION");
		if(arrLevel[i][0]==arrDpt[0][0]){
			obj[0].options.add(oOption)
			oOption.innerText = arrLevel[i][1];
			oOption.value = arrLevel[i][3];		
		}
	}

	obj = document.getElementsByName("slid")
	for(var j=0;j<obj.length;j++)
	{
			for(var i=0;i<arrLevel.length;i++)
		{
		var oOption = document.createElement("OPTION");
		if(arrLevel[i][0]==arrDpt[0][0]){
			obj[j].options.add(oOption)
			oOption.innerText = arrLevel[i][1];
			oOption.value = arrLevel[i][3];		
		}
	}			
   }
   
<%}%>	


function fnSelect(obj)
{
var id  = parseInt(obj.value);
var oTD = obj.parentNode.nextSibling;//td
for(var i =0;i<arrLevel.length;i++)
{
	if(arrLevel[i][3] == id)
	{
	oTD.innerText=arrLevel[i][2];
	document.frm1.hid_sl_id.value=arrLevel[i][3]
	return;
	}
}
}

function fnChange(slid,oTd,mark)
{
	if(mark==0){
	var id = parseInt(document.frm1.add_sldesc.value);
	for(var i =0;i<arrLevel.length;i++)
	{
		if(arrLevel[i][3] == id)
		{
		document.frm1.add_slrate.value=arrLevel[i][2];
		document.frm1.hid_sl_id.value=arrLevel[i][3]
		return;
		}
	}
   }
   else if(mark==1)
   {
	   var id = slid;
		for(var i =0;i<arrLevel.length;i++)
	{
		if(arrLevel[i][3] == id)
		{
		oTd.innerHTML=arrLevel[i][2];
		//document.frm1.hid_sl_id.value=arrLevel[i][3]
		return;
		}
	}
				   
   }
}

function fnChangeDpt(oSelect,mark)
{
var dpt_id  = oSelect.value;
var	obj = oSelect.parentNode.nextSibling.firstChild;//document.getElementsByName("add_sldesc");
var len = 0;
len = obj.options.length
	for(var i=0;i<len;i++)
	{
		obj.options.remove(0);
	}


	for(var i=0;i<arrLevel.length;i++)
	{
		var oOption = document.createElement("OPTION");
		if(arrLevel[i][0]==dpt_id){
			obj.options.add(oOption)
			oOption.innerText = arrLevel[i][1];
			oOption.value = arrLevel[i][3];		
		}
	}
	obj.item(0).selected = true;

	fnChange(obj.value,obj.parentNode.nextSibling,mark);//para is the td for rate

}


function fnSyn(obj)
{
if(obj.checked ==false)
	obj.parentNode.previousSibling.firstChild.disabled = true;	
if(obj.checked ==true)
	obj.parentNode.previousSibling.firstChild.disabled = false;
}

function CheckDecimal(obj)
{
	if(isNaN(parseInt(obj.value)))
	{
		alert('please enter a number!')
		obj.value = '';
	}
	if (obj.value=='')
	{
		obj.value = 0;	
	}
	if (obj.value==null)
	{
		obj.value = 0;	
	}
	
}

<%if(actionflag!=null){%>
var actionflag = "haha";
actionflag =  "<%=actionflag%>";
var array = actionflag.split('|');
alert(array[0]+" success!");
<%}%>

</script>
</Form>
<%
}catch(Exception e)
{ e.printStackTrace();}%>
<%}
else{
out.println("!!你没有相关访问权限!!");}
%>

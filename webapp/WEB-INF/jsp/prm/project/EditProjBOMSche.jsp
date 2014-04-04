<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.util.*"%>

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

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>

<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<link rel="stylesheet" type="text/css" href="includes/xmlTree/xmlTree.css"/>

<script type="text/javascript" src="includes/xmlTree/xmlTree.js"></script>
<%
if (AOFSECURITY.hasEntityPermission("PMS", "_BOM_MAINTENANCE", session)) {
	String actionflag = (String)request.getAttribute("actionflag");
	try{
%>
<form name="frm1" action="editProjBOMSche.do" method="post" >

<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"
	query =""
	>
</IFRAME>
		<%
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		DecimalFormat deFormat = new DecimalFormat();
		deFormat.setMaximumFractionDigits(1);
		deFormat.setMinimumFractionDigits(1);
		deFormat.setGroupingUsed(false);
	
		ProjPlanBomMaster master = (ProjPlanBomMaster)request.getAttribute("master");
		List VersionList = (List)request.getAttribute("VersionList");
		ProjectMaster pm = null;
		if(master!=null)
		pm = master.getProject();
		%>
<input type="hidden" name="masterid" id="masterid" value="<%=master.getId()%>">
<input type="hidden" name="formaction" id="formaction" value="edit">
<input type="hidden" name="mFlag" id="mFlag" value="false">
<table border="0" cellpadding="4" cellspacing="0" align ="center" width="400">
		<CAPTION class=pgheadsmall>Project BOM(Schedule Confirm)</CAPTION>
		<tr ><td colspan=10>&nbsp;</td></tr>
	    <tr align="left">
	    <%if(master.getBid()!=null){%>
	    <td class="lblbold"  align="right" nowrap>Bid :</td>
	    <td class="" align="left" nowrap><%=master.getBid().getNo()%></td>
	    <td class="lblbold"  align="right" nowrap>Bid Description:</td>
	    <td class=""  align="left" nowrap><%=master.getBid().getDescription()%></td>
	    <%}%>
	    <%if(pm!=null){%>
	    <td class="lblbold"  align="right" nowrap>Project ID:</td>
	    <td class=""  align="left" nowrap><%out.println(pm.getProjId());%></td>
	    <td class="lblbold"  align="right" nowrap>Project Description:</td>
	    <td class=""  align="left" nowrap><%=master.getProject().getProjName()%></td>
	    <%}%>
	    <td class="lblbold"  align="right">Version:</td>
	    <td class=""  align="left">
	    	<select name="version" id="version" onchange="javascript:FnViewHistory()">
	    <%
	    for(int i=0;i<VersionList.size();i++)
	    {
	    	int ver = ((Integer)VersionList.get(i)).intValue();
	    %>
	    <option value="<%=ver%>" 
	    <% 	if(ver == master.getVersion())
		    	out.print("selected");
		%>    	
	    ><%=ver%>
		<%	    }
	    %>
	    </select>
	    </td>
		    <td >&nbsp; </td>
	    </tr>
	</table>
	<hr/>
	<%
	List resultList  = (List)request.getAttribute("resultList");
	List stList = (List)request.getAttribute("servicetype");
	%>
	<br>
	<table>
	<tr><td>&nbsp;</td>
	<td>
	<table id="root"  border="0" cellpadding='0' cellspacing='1'	align="center" width="100%">
		<tr bgcolor='#e9eee9'>
		<td class="lblbold" align='center' nowrap rowspan="2">#</td>
		<td class="lblbold" align='center' nowrap rowspan="2">Description</td>
		<%for(int i=0;i<stList.size();i++){
			ProjPlanType type = (ProjPlanType)stList.get(i);
			%>
		<td class="lblbold" align='center' nowrap colspan="<%=type.getChildren().size()+2%>"><%=type.getDescription()%></td>
		<%}%>
		<td class="lblbold" align='center' nowrap rowspan="2"><font color="red">Old Man Day</font></td>
		<td class="lblbold" align='center' nowrap rowspan="2">Actual Man Day</td>
		<td class="lblbold" align='center' nowrap rowspan="2">Start Date</td>
		<td class="lblbold" align='center' nowrap rowspan="2">End Date</td>
		<td class="lblbold" align='center' nowrap rowspan="2">Predecessor</td>
		<td class="lblbold" align='center' nowrap rowspan="2">Document</td>
		</tr>
		<tr bgcolor="#e9eee9">
		<%
		for(int i=0;i<stList.size();i++){
			ProjPlanType type = (ProjPlanType)stList.get(i);
%>
		<td class=lblbold align=center ><font color="red">subTotal</font>
			<input type="hidden" name="p_servicetypeid" Id="p_servicetypeid" value="<%=type.getId()%>">
			<input type="hidden" name="p_strate" Id="p_strate" value="<%=type.getSTRate()%>">
			<input type="hidden" name="p_costrate" Id="p_costrate" value="<%if(type.getSl()!=null) out.println(type.getSl().getRate());%>">
		</td>
<%
			Iterator it = type.getChildren().iterator();
			while(it.hasNext()){
				ProjPlanType child = (ProjPlanType)it.next();
		%>
		<td class=lblbold align=center ><%=child.getDescription()%>
			<input type="hidden" name="c_servicetypeid" Id="c_servicetypeid" value="<%=child.getId()%>">
			<input type="hidden" name="c_strate" Id="c_strate" value="<%=child.getSTRate()%>">
			<input type="hidden" name="c_costrate" Id="c_costrate" value="<%if(child.getSl()!=null) out.println(child.getSl().getRate());%>">
		</td>
		<%}%>
		<td class=lblbold align=center>Sum
		</td>
		<%}%>
	</tr>
		<%
		for(int i=0;i<resultList.size();i++){
			ProjPlanBom ppb = (ProjPlanBom)resultList.get(i);
			ppb.getTypes();
			HashMap typeMap = new HashMap();
			if((ppb.getTypes()!=null)&&(ppb.getTypes().size()>0)){
				Iterator it = ppb.getTypes().iterator();
				while(it.hasNext()){
					ProjPlanBOMST st = (ProjPlanBOMST)it.next();
						typeMap.put(new Long(st.getType().getId()),st);
				}
			}
			int level =  ppb.getRanking().length()/3;
				
			boolean isLeaf = true;
		
			if(i < (resultList.size()-1)){
				ProjPlanBom ppbNext = (ProjPlanBom)resultList.get(i+1);
				if(ppb.getRanking().length() < ppbNext.getRanking().length()){
					isLeaf = false;
				}
			}
		%>
	<tr bgcolor='#e9eee9' id="id<%=i%>" row="<%=i%>" ranking="<%=ppb.getRanking()%>" level="<%=ppb.getRanking().length()/3%>" isLeaf="<%if(isLeaf)out.println(0);else out.println(1);%>"> <!-- isLeaf used to hide none leaf Node -->
		<td class="lblbold" align='center' nowrap ><input type="text" name="serial" id="serial<%=i%>" value="<%=i%>" size="5" readonly style="text-align:center;border:0px;background-color:#e9eee9"></td>
		<td id='bom_desc' style="margin-left:'<%=level*10%>px'" nowrap>
			<input size="1" type="text" readonly style="border:0px;margin-left:'<%=level*10%>px';background-color:#e9eee9">
			<%=ppb.getStepdesc()%>
			<input type="hidden" name="bom_id" id="bom_id" value="<%=ppb.getId()%>">
			<input type="hidden" name="bom_ranking" id="bom_ranking" value="<%=ppb.getRanking()%>">
			<input type="hidden" name="bom_stepdesc" id="bom_stepdesc" value="<%=ppb.getStepdesc()%>">
		</td>
		<%
			int colcount = -1; //actual col count from the very first service type
			int childcol =-1; //only col count for every service type
			double sumRow = 0; //the actual total for every task(row)
			double oldSum = 0;
			for(int j=0;j<stList.size();j++){//stList does not include those child service type
				ProjPlanType parent = (ProjPlanType)stList.get(j);
				colcount +=1;				
				double pday = 0;
				boolean tempDis =false;
				
				if(typeMap.get(new Long(parent.getId()))!=null){
					pday = ((ProjPlanBOMST)typeMap.get(new Long(parent.getId()))).getManday();
					tempDis = true;
					}
				oldSum +=pday;
		%>
		<td align="center">
			<input type="text"  size="5" name="st<%=i%>-<%=j%>" id="st<%=i%>-<%=j%>" group="<%=j%>" parentnode="true" col="0" row="<%=i%>" colcount="<%=colcount%>" oldvalue="<%=pday%>" value="<%=pday%>" childsize="<%=parent.getChildren().size()%>" readonly style="text-align:right;border:0px;background-color:#e9eee9" >
		<%if(tempDis){		%>
			<input type="hidden" name="p_hid_id<%=i%>" id="p_hid_id<%=i%>" value="<%=pday%>" >
		<%			}else{		%>	
			<input type="hidden" name="p_hid_id<%=i%>" id="p_hid_id<%=i%>" value="0">
		<%		}		%>	
		</td>
		<%
				Iterator it = parent.getChildren().iterator();
				int col = 0;	//only count the cols during every service type
				double now_day = 0; //
				while(it.hasNext()){
				col +=1;
				colcount +=1;
				childcol +=1;
				ProjPlanType ppt = (ProjPlanType)it.next();	
				double day =0;
				tempDis = false;
				if(typeMap.get(new Long(ppt.getId()))!=null){
					day = ((ProjPlanBOMST)typeMap.get(new Long(ppt.getId()))).getManday();
					now_day +=day;
					tempDis = true;
					}
				sumRow += day;
					
		%>
		<td align="center">
			<input type="text"  size="5" name="<%=ppb.getRanking()%>" id="<%=ppb.getRanking()%>" group="<%=j%>" row="<%=i%>" col=<%=col%> childcol="<%=childcol%>" colcount="<%=colcount%>" oldvalue="<%=deFormat.format(day)%>" value="<%=deFormat.format(day)%>" childsize="<%=ppt.getParent().getChildren().size()%>" 
			<%if(isLeaf){%>
			style="text-align:right;background-color:#ffffff;border-color:#7F9DB9"" onchange="javascript:fnReCal(this);ChangeDuration(this,1);fnChangeFlag()"
			<%}else{%>
			readonly style="text-align:right;border:0px;background-color:#e9eee9" 
			<%}%>
			>
		<%if(tempDis){
		%>
			<input type="hidden" name="c_hid_id<%=i%>" id="c_hid_id<%=i%>" value="<%=((ProjPlanBOMST)typeMap.get(new Long(ppt.getId()))).getId()%>">
		<%
				}else{
		%>	
			<input type="hidden" name="c_hid_id<%=i%>" id="c_hid_id<%=i%>" value="-1"><!--used to insert  bomst  -->
		<%
				}
		%>	
			<input type="hidden" name="st<%=i%>" id="st<%=i%>" value="<%=deFormat.format(day)%>" >
		</td>
		<%
				}
				%>
		<td align="center">
			<input type="text" size="5" name="sum<%=i%>" id="sum<%=i%>" group="<%=j%>" stop="1" replace="<%if(pday!=now_day)out.println("OK");else out.println(deFormat.format(now_day));%>" value="<%if(pday==now_day)out.println("OK");else out.println(deFormat.format(now_day));%>" readonly style="border:0px;background-color:#e9eee9;text-align:right"/>
		</td>
				<%
			}
		%>
		<td align="center"><%=deFormat.format(oldSum)%></td>
		<td align="center" class="lblbold"><input type="text" name="rowSum<%=i%>" id="rowSum<%=i%>" size="5" value="<%=deFormat.format(sumRow)%>" readonly style="border:0px;background-color:#e9eee9;font-weight: bold"></td>
		<td nowrap >
			<p align="center">
			<input type="hidden" name="dt<%=i%>" id="dt<%=i%>"
			value="<%if(ppb.getStart_time()!=null){out.println(df.format(ppb.getStart_time()));}
						else {out.println(df.format(Calendar.getInstance().getTime()));}%>" />
			<input type="text" size="10" name="date<%=ppb.getRanking()%>" id="date<%=ppb.getRanking()%>" col="0" hid="<%=i%>"
			value="<%if(ppb.getStart_time()!=null){out.println(df.format(ppb.getStart_time()));}
						else {out.println(df.format(Calendar.getInstance().getTime()));}%>" 
			<%if(!isLeaf) out.print("readonly");%> 
			style="background-color:<%if(isLeaf){out.print("#ffffff;border-color:#7F9DB9");}else{out.print("#e9eee9;border=0px");}%>"
			onchange="javascript:fnChkDate(this);ChangeSDByPre(null,this,1);fnChangeFlag()" />
	        <%
	        if(isLeaf){
	        %>
	        <a onclick="javascript:ShowCalendar(this.firstChild,this.parentNode.firstChild.nextSibling.nextSibling,null,0,530);
	        event.cancelBubble=true;">
	        	<img align=absMiddle border=0 id=dimg6 src="<%=request.getContextPath()%>/images/datebtn.gif" >
	        </a>
	        <%}%>
	    </td>
		<td nowrap >
			<p align="center">
			<input type="hidden" name="dt<%=i%>" id="dt<%=i%>" 
			value="<%if(ppb.getEnd_time()!=null){out.println(df.format(ppb.getEnd_time()));}
						else {out.println(df.format(Calendar.getInstance().getTime()));}%>" />
			<input type="text" size="10" name="date<%=ppb.getRanking()%>" id="date<%=ppb.getRanking()%>" col="1" hid="<%=i%>"
			value="<%if(ppb.getEnd_time()!=null){out.println(df.format(ppb.getEnd_time()));}
						else {out.println(df.format(Calendar.getInstance().getTime()));}%>" 
			<%if(!isLeaf) out.print("readonly");%> 
			style="background-color:#e9eee9;border=0px" onchange="javascript:fnChkDate(this);fnChangeFlag()"
			 />
		</td>
		<td align="center" nowrap>
			<input type="text" name="pre" id="pre<%=i%>" size="5"  row="<%=i%>" value="<%if(ppb.getPredecessor()!=null) out.println(ppb.getPredecessor());%>" style="text-align:center;background-color:#ffffff;border-color:#7F9DB9" onChange="fnPredecessor(this);fnChangeFlag()">
		</td>
		<td align="center" nowrap>
			<input size="30" type="text" name="document" id="document" value="<%if(ppb.getDocument()!=null)out.println(ppb.getDocument());%>" readonly style="background-color:#e9eee9;border:0px">
		</td>
	</tr>
	
	<%}
	%>
	<tr align="right">
		<table align="right">
			<tr>
				<td><input type="text" value="" name="totalReve" id="totalReve" style="border:0px;background-color:#ffffff;text-align:right"></td>
				<td><input type="text" name="totalCost" id="totalCost" style="border:0px;background-color:#ffffff;text-align:right"></td>
				<td><input type="text" name="totalMargin" id="totalMargin" style="border:0px;background-color:#ffffff;text-align:right"></td>
			</tr>
		</table>
	</tr>
</table>
</td><td colspan=2>&nbsp;</td></tr></table>

<table>
	<tr><td>

		<input type="submit" value="Save" onclick="javascript:document.frm1.formaction.value='edit'" class="button"/>
		<input type="submit" value="Save as BaseLine" onclick="javascript:document.frm1.formaction.value='editBaseLine'" class="button"/>
<%
	if(master.getEnable().equalsIgnoreCase("n")){
%>
		<input type="submit" value="Activate" onclick="javascript:document.frm1.formaction.value='setNew'" class="button"/>
<%}%>
<!-- 		<input type="submit" value="Confirm" onclick="document.frm1.formaction.value='confirm'" class="button"/>
-->
		<input type="button" value="Back to List" onclick="javascript:fnCheckSave();" class="button" />
	</td></tr>
</table>
<script language="javascript">
function fnChangeFlag()
{
	with(document.frm1)
	{
		mFlag.value = "true";
	}
}

function fnCheckSave()
{
	with(document.frm1)
	{
		if(mFlag.value == "true"){
		if(!window.confirm("Modifications have not been saved, Do you want to go on?"))
			return;
			}
		location.replace('findProjBOM.do?formaction=listsche');
	}
	
}
function fnReCal(obj) //input object is the input box for detail manday
{
	if(isNaN(parseInt(obj.value)))
	{
		alert('not a number!');
		obj.value = obj.oldvalue
		return;
	}
var arr = document.getElementsByName("st"+obj.row+"-"+obj.group);
var parent;
var iTemp = 0.00;//临时变量计算天数
var oTemp;//临时变量放置对象
oTemp = arr[0].parentNode.nextSibling.firstChild;
while(parseFloat(oTemp.stop)!=1)
{
	iTemp = iTemp + parseFloat(oTemp.value);
	oTemp = oTemp.parentNode.nextSibling.firstChild;
}
if(iTemp==parseFloat(arr[0].value))
{
	oTemp.value ="OK";
	oTemp.replace = iTemp;
	}
else{

	oTemp.value = iTemp;
	oTemp.replace = iTemp;
	}
	
	fnCalManDay(obj); //update parent node man day
	
	fnParentSum(obj.row);

	//wait for dealing with Start date and End date, Sorting task
	obj.oldvalue = obj.value; //reset old value


}

function fnCalManDay(obj)
{
var lastname = "haha";

var gap = 0;
gap = parseFloat(obj.value)-parseFloat(obj.oldvalue);
	
	for(var i=1;i<(obj.name.length/3);i++)
	{
		lastname = obj.name.substring(0,i*3);	

		var lastobj = document.getElementsByName(lastname);
		lastobj[obj.childcol].value = parseFloat(lastobj[obj.childcol].value)+gap;
		lastobj[obj.childcol].oldvalue = lastobj[obj.childcol].value;
		
		var array = document.getElementsByName("st"+lastobj[obj.childcol].row);
		array[obj.childcol].value = obj.value
		
		fnReCal(lastobj[obj.childcol]);

	}
}


function fnParentSum(row)
{
var arr = 	document.getElementsByName("sum"+row);
var array = document.getElementsByName("rowSum"+row);
array[0].value =0;
for(var i=0;i<arr.length;i++)
{
	if(isNaN(parseFloat(arr[i].value))){
		array[0].value = parseFloat(array[0].value) +　parseFloat(arr[i].replace);	
		}
	else{
		array[0].value = parseFloat(array[0].value) +　parseFloat(arr[i].value);
		}
}
}

function fnAdjustDate(obj,tempMin,flag) //compare with same level nodes and return the latest date
{
		//cycle for sibling
		var under = 1;
		var suffix = "001";
		var prefix = obj.name.substring(4,obj.name.length-3);
		var composeName = prefix+suffix;
		var arr = document.getElementsByName('date'+composeName);
		var min = tempMin;
		while(arr[0]!=null)
		{
			if(flag==0) //start date
			{
				if(min>arr[0].value)
					min = arr[0].value;		
			}
			if(flag==1) //end date
			{
				if(min<arr[0].value)
					min = arr[0].value;		
			}
			under = under+1;
			if(under.toString().length==1){
				suffix = "00"+under;
				}
			else{ 
			if(under.toString().length==2){
				suffix = "0"+under;
				}
				}
			composeName = prefix+suffix;
			arr = document.getElementsByName('date'+composeName)
		}
		return min;		
		
}

function fnChkDate(obj)
{
	if(!dataOneCheck(obj))
		return;

	var array = document.getElementsByName('dt'+obj.hid);
	array[parseInt(obj.col)].value = obj.value 

	var tempname  = obj.name.substring(4,obj.name.length);
	var lastname = "haha";


//the first parent
	var tempMin = fnAdjustDate(obj,obj.value,parseInt(obj.col));
	

//the other parents
	for(var i=tempname.length/3-1;i>0;i--)
	{	
		alert(i)
		lastname = tempname.substring(0,i*3);	
		var lastobj = document.getElementsByName('date'+lastname);
		lastobj[obj.col].value = tempMin;
	
		//reset the hidden value for the date	
		array = document.getElementsByName('dt'+lastobj[0].hid);
		array[obj.col].value = tempMin 
		
		tempMin = fnAdjustDate(lastobj[parseInt(obj.col)],tempMin,parseFloat(lastobj[obj.col].col));
	}	
	
}


function fnPredecessor(obj){
	
	var row = obj.row;
	var serial = document.getElementById("serial"+row);
	var tmpPred = obj.value;
	if(serial.value == obj.value){
		alert("Predecessor can not be self!");
		return;
	}
	
	var indexMax = <%=resultList.size()%>;
	
	if(obj.value >= indexMax){
		alert("Predecessor is out of range");
		return;
	}
	
	fnParePrede(obj, tmpPred, row);
}

function fnParePrede(obj,tmpPred,row){	
	
	var tmpObj = obj;
	var tmpValue = tmpPred;
	var parePred = document.getElementById("pre" + obj.value);
	var tmpRow = row;
	
	if(parePred.value == null || parePred.value.toString().length == 0){
		var pred = document.getElementById("pre" + tmpRow);
		ChangeSDByPre(pred,null,0); //predecessor input box
	}else if(parePred.value == tmpValue){
		alert("Linked error!");
		var pred = document.getElementById("pre" + tmpRow);
		pred.value = "";
		pred.focus();
		return;
	}else{
		fnParePrede(parePred, tmpValue,tmpRow);
	}
}



function ChangeSDByPre(obj,oInput,flag) //obj refers to predecessor input box object
{
		if((obj==null)&&(oInput!=null))
		{
			var arrTemp = document.getElementsByName('pre');
			obj = arrTemp[oInput.hid];//get the pre input box object
		}
		if((obj!=null)&&(oInput==null))
		{
			var arrTemp = document.getElementsByName('date'+obj.parentNode.parentNode.ranking);
			oInput = arrTemp[0]; //refers to the start date object current
		}

		var row = parseInt(obj.value); //当前行,事件对象必须含有row这个属性
		var oPre = document.getElementsByName('pre');//当前pre是oPre[row]
		var oPreED = document.getElementsByName('dt'+row); //获取pre的end date,
		
		var oTr = document.getElementById('id'+obj.row); //now current row object
		var arrDate = document.getElementsByName('date'+oTr.ranking);
		var arrHidDate = document.getElementsByName('dt'+obj.row);

	if(flag==0) //change predecessor
	{		
		
			var arrTemp = oPreED[1].value.split("-");
			var month = parseInt(arrTemp[1]);
			var day = parseInt(arrTemp[2]);
			
			if((arrTemp[1].length>1)&&(arrTemp[1].substring(0,1)=='0')){
			month = arrTemp[1].substring(1,2);}
			if((arrTemp[2].length>1)&&(arrTemp[2].substring(0,1)=='0')){
			day = arrTemp[2].substring(1,2);}
			
			var dd = new Date(arrTemp[0],(month-1),day)
			dd = new Date(dd.getTime()+86400000)

		arrDate[0].value = dd.getYear()+"-"+(dd.getMonth()+1)+"-"+dd.getDate();  //use PRE End date to set current start date
		arrHidDate[0].value = arrDate[0].value; 
	}
	
	if(flag==1) //change start date
	{
		arrHidDate[0].value = oInput.value; //set hidden object value
		
		if(oPreED[1].value!=oInput.value) //当前对象的start date 不等于pre的end date
		{
			if(window.confirm("Do you want delete predecessor?"))
			{
				oPre[obj.row].value="";//reset the pre to null
			}
		
		}
	}
	ChangeDuration(oInput);

}

function ChangeDuration(obj,flag) //if flag!=1 obj==start date input box;else obj = manday input box
{
	if(flag==1) //try to get the start date input box
	{
		var tempStart = document.getElementsByName('date'+obj.parentNode.parentNode.ranking);
		obj = tempStart[0]; 
	}
	var arrTemp = document.getElementsByName('rowSum'+obj.hid);
	var duration = arrTemp[0].value;
	
	var arrTemp = obj.value.split("-");
	var month = parseInt(arrTemp[1]);
	var day = parseInt(arrTemp[2]);
	
	if((arrTemp[1].length>1)&&(arrTemp[1].substring(0,1)=='0')){
	month = arrTemp[1].substring(1,2);}
	if((arrTemp[2].length>1)&&(arrTemp[2].substring(0,1)=='0')){
	day = arrTemp[2].substring(1,2);}

	month = month-1;
	var stdate = new Date(parseInt(arrTemp[0]),month,day);
	
	var end = GetEndDate(stdate,duration);

	var oTr = document.getElementById('id'+obj.hid); //get tr object to get ranking
	var arrDate = document.getElementsByName('date'+oTr.ranking); //start object and end object array
	arrDate[1].value = end.getYear()+"-"+(end.getMonth()+1)+"-"+end.getDate();//set end date object value
	arrDate = document.getElementsByName('dt'+obj.hid);
	arrDate[1].value = end.getYear()+"-"+(end.getMonth()+1)+"-"+end.getDate();//set end date object value
		
	//check whether there is linked nodes,then do cycle
	arr = document.getElementsByName('pre');
	for(var i=0;i<arr.length;i++)
	{
		if(parseInt(arr[i].value)==parseInt(obj.hid))
		{
			arrDate = document.getElementsByName('date'+arr[i].parentNode.parentNode.ranking)
			ChangeSDByPre(arr[i],arrDate[0],0)
		}
	}	
	
}

function GetEndDate(obj,duration) //start date object for input box
{
	var year = obj.getYear();
	var month = obj.getMonth();
	var day = obj.getDay();
	var date = obj.getDate();
	if((!isNaN(year)) &&(!isNaN(month))&&(!isNaN(day)))
	{
		if((obj.getDay()==6)||(obj.getDay()==0))
		{
			if(!window.confirm('Start Date is NOT Working day,are you sure to continue?'))
			return ;
		}
		

		var newDate = new Date(obj.getTime());
		for(var i=0;i<duration;)
		{
			newDate = new Date(newDate.getTime()+86400000)
			if((newDate.getDay()!=0)&&(newDate.getDay()!=6))
			{
					i = i+1;
			}
		}
		return newDate;
	}
	else {
		alert('null finish!')
		return null;
		}
}

function FnViewHistory()
{
	with(document.frm1)
	{
		if(mFlag.value == "true"){
		if(!window.confirm("Modifications have not been saved, Do you want to go on?"))
			return;
			}
	}

	document.frm1.formaction.value = 'viewHistory';
	document.frm1.submit();
}



<%if(actionflag!=null){%>
var actionflag = "haha";
actionflag =  "<%=actionflag%>";
var array = actionflag.split('|');
alert(array[0]+" success!");
<%}%>

</script>
</form>
<%}catch(Exception e){
	e.printStackTrace();
}
}else{
	out.println("!!你没有相关访问权限!!");
}%>


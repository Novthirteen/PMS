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
<%if (AOFSECURITY.hasEntityPermission("PMS", "_Prop_MAINTENANCE", session)) {%>
<script type="text/javascript" src="includes/xmlTree/xmlTree.js"></script>
<script language="vbs">
function rndNum(tot)
 tot=FormatNumber(tot,2,-1,0,-1)
 rndNum=tot
end function
</script>
<%
	String actionflag = (String)request.getAttribute("actionflag");
	try{
		NumberFormat numFormater = NumberFormat.getInstance();
		numFormater.setMaximumFractionDigits(2);
		numFormater.setMinimumFractionDigits(2);
%>

<form name="frm1" action="editProjBOMReve.do" method="post" >
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>
<%
String action = (String)request.getAttribute("formaction");
ProjPlanBomMaster master = (ProjPlanBomMaster)request.getAttribute("master");
ProjectMaster pm = master.getProject();
%>
<input type="hidden" name="masterid" value="<%=master.getId()%>">
<input type="hidden" name="formaction" value="edit">
<table border="0" cellpadding="4" cellspacing="0" align ="center">
    <tr>
    <td colspan=3>&nbsp;</td>
    <td class=pgheadsmall align='center'>Project BOM(Proposal Confirm)</td>
    <td colspan=2>&nbsp;</td>
    </tr>
  <tr><td>&nbsp;</td></tr>
    <tr>
	    <%if(master.getBid()!=null){%>
	    <td class="lblbold" width="10%" align="right">Bid :</td>
	    <td class="lblbold" width="10%" align="left"><%=master.getBid().getNo()%></td>
	    <td class="lblbold" width="30%" align="right">Bid Description:</td>
	    <td class="lblbold" width="30%" align="left"><%=master.getBid().getDescription()%></td>
	    <%}%>
    <% if (pm!=null){%>
    <td class="lblbold">Project ID:</td>
    <td class="lblbold"><%out.println(pm.getProjId());%></td>
	    <td class="lblbold" width="30%" align="right">Project Description:</td>
	    <td class="lblbold" width="30%" align="left"><%=pm.getProjName()%></td>
    <%}%>
    <td class="lblbold">Version:</td>
    <td class="lblbold"><%=master.getVersion()%></td>
    </tr>
  
</table>
<hr/>
<%
List resultList  = (List)request.getAttribute("resultList");
List stList = (List)request.getAttribute("servicetype");
String sttitle = null;
String stother = null;
double totalMD[] = new double[stList.size()];
%>
<table id="root" width="100%" cellpadding="1" border="0" cellspacing="1" align="center">
	<tr bgcolor="#d3d3d3" height="20">
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
		<td class="lblbold" align='center' nowrap>Description</td>
		<td class="lblbold" align='center' nowrap>Document</td>
		<%
		HashMap stmap = (HashMap)request.getAttribute("stmap");
		
		for(int i=0;i<stList.size();i++){
			ProjPlanType type = (ProjPlanType)stList.get(i);
			out.print("<td class=lblbold align=center width='10%'>"+type.getDescription()+"("+type.getSTRate()+")<input type=hidden name=servicetypeid value="+type.getId()+"><input type=hidden name=strate value="+type.getSTRate()+"></td>");
		}
		%>
		<td class="lblbold" align='center' nowrap>SubTotal(ManDay)</td>
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
	</tr>
	<%
	for(int i=0;i<resultList.size();i++){
	ProjPlanBom ppb = (ProjPlanBom)resultList.get(i);
	HashMap typeMap = new HashMap();
		if(ppb.getTypes().size()>0)
		{
			Iterator it = ppb.getTypes().iterator();
			while(it.hasNext())
				{
					ProjPlanBOMST st = (ProjPlanBOMST)it.next();
					typeMap.put(new Long(st.getType().getId()),st);
				}
		}
	int level =  ppb.getRanking().length()/3;
	String tr_name = "tr"+ppb.getId();
	
	boolean isNode = true;
	
	if(i < (resultList.size()-1)){
		ProjPlanBom ppbNext = (ProjPlanBom)resultList.get(i+1);
		if(ppb.getRanking().length() < ppbNext.getRanking().length()){
			isNode = false;
		}
	}
	%>
	<tr id="<%=tr_name%>" _id='<%=ppb.getId()%>'>
		<%
		String bgcolor = "";
		if(ppb.getRanking().length() == 3){
			bgcolor = "#b0c4de";
		} else if(ppb.getRanking().length() == 6){
			bgcolor = "#D6DFF9";
		} else {
			bgcolor = "#e9eee9";
		}
		%>
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
		<td id='bom_desc' bgcolor="<%=bgcolor%>" nowrap>
			<input type="text" size="1" readonly style="border:0px;margin-left:'<%=level*10%>px';background-color:<%=bgcolor%>">
			<%=ppb.getStepdesc()%>
			<input type="hidden" name="bom_id" value="<%=ppb.getId()%>">
		</td>
		<td bgcolor="<%=bgcolor%>" align="center">
			<input type="text" name="document" value="<%if(ppb.getDocument()!=null)out.println(ppb.getDocument());%>" readonly style="border:0px;background-color:<%=bgcolor%>">
		</td>
		<%
		double subTotalMD = 0;
		for(int j=0;j<stList.size();j++){
		ProjPlanType ppt = (ProjPlanType)stList.get(j);
		double day =0;
		%>
		<td bgcolor="<%=bgcolor%>" align="center">
			<%
			if(typeMap.get(new Long(ppt.getId()))!=null){
			
				day = ((ProjPlanBOMST)typeMap.get(new Long(ppt.getId()))).getManday();
				if(ppb.getRanking().length() == 3){
					totalMD[j] += day;
				}
				subTotalMD += day;
				%>
				<input type="hidden" name="hid_id<%=i%>" value="<%=((ProjPlanBOMST)typeMap.get(new Long(ppt.getId()))).getId()%>">
				<%}	else{
				%>	
				<input type="hidden" name="hid_id<%=i%>" value="-1">
				<%}%>	
			<!--
			<input type="text"  size="5" name="st<%=i%>" col="<%=j%>" row="<%=i%>" oldvalue="<%=day%>" value="<%=day%>" style="text-align:right;background-color:#ffffff" onchange="javascript:fnMDCal(this)">
			-->
			<input type="hidden" name="st<%=i%>" col="<%=j%>" row="<%=i%>" oldvalue="<%=day%>" value="<%=day%>">
			<%
			if((master.getReveConfirm()!=null)&&(master.getReveConfirm().equalsIgnoreCase("confirm"))){
			%>
			<input type="text"  size="5" name="<%=ppb.getRanking()%>" value="<%=day%>" readonly style="text-align:right;background-color:<%=bgcolor%>;border=0px">
			<%
			}else{
			%>
			<input type="text"  size="5" name="<%=ppb.getRanking()%>" col="<%=j%>" row="<%=i%>" oldvalue="<%=day%>" value="<%=day%>" <% if(!isNode) out.print("readonly");%> style="text-align:right;background-color:<% if(isNode){out.print("#ffffff");}else{out.print(bgcolor+";border=0px");}%>" onchange="javascript:fnMDCal(this)">
			<%
			}
			%>
		</td>
		<%
		}
		%>
		<td bgcolor="<%=bgcolor%>" align="center"><input type="text" name="sub"  row="<%=i%>" oldvalue="<%=subTotalMD%>" value="<%=subTotalMD%>" readonly style="border:0px;background-color:<%=bgcolor%>;text-align:right"></td>
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
	</tr>
	<%
	}
	%>
	<tr>
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
		<td>&nbsp;</td>
		<td class="lblbold" align="right">Total:</td>
		<%
		double allTotal =0;
		for(int col=0;col<stList.size();col++) {
		%>
		<td align="center"><input type="text" size="5" name="total" class="lblbold" col="<%=col%>" oldvalue="<%=totalMD[col]%>" value="<%=totalMD[col]%>" style="border:0px;background-color:#ffffff;text-align:right"></td>
		<%
		allTotal += totalMD[col];
		}
		%>
		<td align="center"><input type="text" name="allTotal" class="lblbold" oldvalue="<%=allTotal%>" value="<%=allTotal%>" style="border:0px;background-color:#ffffff;text-align:right"></td>
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
	</tr>
</table>
<br>
<table width='60%'>
	<tr>
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
		<td>
			<table border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
				<tr>
				    <td width='100%'>
				      	<table width='100%' border='0' cellspacing='0' cellpadding='0'>
				        	<tr>
				          		<td align=left width='90%' class="topBox">&nbsp;</td>
				        	</tr>
				      	</table>
				    </td>
			  	</tr>
			  	<tr>
				    <td width='100%'>
				        <table width='100%' border='0' cellspacing='0' cellpadding='0' >
				          	<tr>
					            <td align="center" valign="middle" width='100%'>
					            	<table width='100%' border='0' cellpadding='0' cellspacing='1'>
					                	<tr>
								            <td align="left" class="bottomBox"><p align="center">&nbsp;Service Type&nbsp;</td>
								            <td align="left" class="bottomBox"><p align="center">&nbsp;Currency&nbsp;</td>
								            <td align="left" class="bottomBox"><p align="center">&nbsp;Service Rate&nbsp;</td>
								            <td align="left" class="bottomBox"><p align="center">&nbsp;Cost Rate(RMB)&nbsp;</td>
								            <td align="left" class="bottomBox"><p align="center">&nbsp;Day&nbsp;</td>
								            <td align="left" class="bottomBox"><p align="center">&nbsp;Service Value(RMB)&nbsp;</td>
								            <td align="left" class="bottomBox"><p align="center">&nbsp;Cost Value(RMB)&nbsp;</td>
								            <td align="left" class="bottomBox"><p align="center">&nbsp;Gross Margin(RMB)&nbsp;</td>
								            <td align="left" class="bottomBox"><p align="center">&nbsp;Gross Margin(%)&nbsp;</td>
					          			</tr>
							          	<%
							          	double dayTotal = 0;
							          	double revenueTotal = 0;
							          	double costTotal = 0;
							          	double marginValueTotal = 0;
							          	double marginTotal = 0;
							          	
							          	String taxFlag = ((ProjPlanType)stList.get(0)).getTax();
							          	
							          	String taxDesc = "";
							          	
							          	if(taxFlag != null && taxFlag.equals("y")){
							          		taxDesc = "tax included";
							          	} else {
							          		taxDesc = "tax excluded";
							          	}
							          	
										for(int i=0;i<stList.size();i++){
										
											ProjPlanType type = (ProjPlanType)stList.get(i);
											
											double sr = 0;
											double revenue = 0;
											double cost = 0;
											double marginValue = 0;
											double margin = 0;
											
											if(taxFlag != null && taxFlag.equals("y")){
												sr = type.getSTRate();
								          		revenue = totalMD[i] * sr*(type.getCurrency().getCurrRate()).floatValue();
								          	} else {
								          		sr = type.getSTRate()*1.0505;
								          		revenue = totalMD[i] * sr*(type.getCurrency().getCurrRate()).floatValue();
								          	}
											cost = totalMD[i] * (type.getSl().getRate()).doubleValue();
											
											marginValue = revenue * 0.95 - cost;
											if(revenue == 0){
												margin = 0;
											} else{
												margin = marginValue / revenue;
											}
											
											dayTotal += totalMD[i];
											revenueTotal += revenue;
											costTotal += cost;
										%>
							          	<tr>
							          		<input type="hidden" id="currRate<%=i%>" value="<%=(type.getCurrency().getCurrRate()).floatValue()%>">
							          		<input type="hidden" id="tax<%=i%>" value="<%=taxFlag%>">
								          	<td nowrap><p align="left"><%=type.getDescription()%> (<%=taxDesc%>)</td>
								          	<td><p align="center"><input type="text"  size="5" name="currency" value="<%=type.getCurrency().getCurrName()%>" readonly style="text-align:center;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="12" id="serviceRate<%=i%>" value="<%=numFormater.format(sr)%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="12" id="costRate<%=i%>" value="<%=numFormater.format(type.getSl().getRate())%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="8" id="manday<%=i%>" value="<%=totalMD[i]%>" oldvalue="<%=totalMD[i]%>" readonly style="text-align:center;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="16" id="revenue<%=i%>" value="<%=numFormater.format(revenue)%>" oldvalue="<%=numFormater.format(revenue)%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="16" id="cost<%=i%>" value="<%=numFormater.format(cost)%>" oldvalue="<%=numFormater.format(cost)%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="16" id="marginValue<%=i%>" value="<%=numFormater.format(marginValue)%>" oldvalue="<%=numFormater.format(marginValue)%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="8" id="margin<%=i%>" value="<%=numFormater.format(margin*100) + "%"%>" oldvalue="<%=numFormater.format(margin*100) + "%"%>" readonly style="text-align:center;background-color:#ffffff;border=0px"></td>
							          	</tr>
					         			 <%
					         			 }
					         			 marginValueTotal = revenueTotal * 0.95 - costTotal;
										
										if(costTotal == 0){
					         			 	marginTotal = 0;
										} else{
											marginTotal = marginValueTotal / revenueTotal;
										}
					         			 %>
					         			 <tr>
					         				<td class="bottomBox" colspan="4"><p align="right">Total:</td>
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="10" id="dayTotal" value="<%=dayTotal%>" readonly style="text-align:center;background-color:#e9eee9;border=0px"></td>
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="16" id="revenueTotal" value="<%=numFormater.format(revenueTotal)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px"></td>
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="16" id="costTotal" value="<%=numFormater.format(costTotal)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px"></td>
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="16" id="marginValueTotal" value="<%=numFormater.format(marginValueTotal)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px"></td>
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="12" id="marginTotal" value="<%=numFormater.format(marginTotal*100) + "%"%>" readonly style="text-align:center;background-color:#e9eee9;border=0px"></td>
					         			 </tr>
					                </table>
					            </td>
				          </tr>
				        </table>
					</td>
				</tr>
			</table>
		</td>
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
	</tr>
</table>
<br>
<table width="100%">
	<tr><td align="right">
		<input type="button" class="button" value="View Project Precal" onclick="location.replace('editProjBOMCost.do?masterid=<%=master.getId()%>&formaction=view')"/>
		<%if((master.getReveConfirm()!=null)&&(master.getReveConfirm().equalsIgnoreCase("confirm"))){%>
		<%}else{%>
		<input type="submit" class="button" value="Save&Update" onclick="document.frm1.formaction.value='edit'"/>
		<input type="submit" class="button" value="Confirm" onclick="document.frm1.formaction.value='confirm'"/>		
		<%}%>
		<input type="button" class="button" value="Back to List" onclick="location.replace('findProjBOM.do?formaction=listreve')">
		<input type="hidden" name="dpt">
	</td></tr>
</table>

<script language="javascript">
var t = document.getElementById("root");//used to set global active Node

function fnMDCal(obj){
	if(isNaN(parseFloat(obj.value))){
	
		alert('please input a valid number');
		obj.focus();
		return;
		
	}else if(parseFloat(obj.value)<0){
	
		alert('minus number is not accepted');
		obj.focus();
		return;
		
	}else{
		
		var col = 0;
		col = parseInt(obj.col);
		
		var row = 0;
		row = parseInt(obj.row);
		
		var name =  obj.name;
		
		var size = name.length/3 - 1;
		var pName = new Array(size);
		
		for(var i = 0; i < size; i++){
			pName[i] = name.substring(0,(name.length-(i+1)*3));
		}
		
		// change hidden input's value
		var hid = document.getElementsByName("st"+row);
		hid[col].value = obj.value;
		
		//purevalue = records[v].value.replace(/,/g, "");
		
		// the changed value of MD
		var gap = parseFloat(obj.value.replace(/,/g, "")) - parseFloat(obj.oldvalue.replace(/,/g, ""));
		obj.oldvalue=obj.value;
		
		for(var j = 0; j <size; j++){
		
			var subTotal = document.getElementsByName(pName[j]);
			var pHid = document.getElementsByName("st"+subTotal[col].row);
			
			pHid[col].oldvalue = pHid[col].value;
			pHid[col].value = parseFloat(pHid[col].value.replace(/,/g, "")) + gap;
			
			subTotal[col].value = parseFloat(subTotal[col].value.replace(/,/g, "")) + gap;
		}
		
		var total = document.getElementsByName("total");
		total[col].oldvalue = total[col].value;
		total[col].value =  parseFloat(total[col].value.replace(/,/g, "")) + gap;
		
		var sub = document.getElementsByName("sub");
		sub[row].oldvalue = sub[row].value;
		sub[row].value =  parseFloat(sub[row].value.replace(/,/g, "")) + gap;
		
		for(var j = 0; j <size; j++){
			var subTotal = document.getElementsByName(pName[j]);
			sub[subTotal[col].row].value = parseFloat(sub[subTotal[col].row].value.replace(/,/g, "")) + gap;
		}
		
		var allTotal = document.getElementsByName("allTotal");
		allTotal[0].oldvalue = allTotal[0].value;
		allTotal[0].value =  parseFloat(allTotal[0].value.replace(/,/g, "")) + gap;
		
		var tax = document.getElementById("tax"+col);
		var currRate = document.getElementById("currRate"+col);
		var manday = document.getElementById("manday"+col);
		var serviceRate = document.getElementById("serviceRate"+col);
		var costRate = document.getElementById("costRate"+col);
		var revenue = document.getElementById("revenue"+col);
		var cost = document.getElementById("cost"+col);
		var marginValue = document.getElementById("marginValue"+col);
		var margin = document.getElementById("margin"+col);
		
		var dayTotal = document.getElementById("dayTotal");
		var revenueTotal = document.getElementById("revenueTotal");
		var costTotal = document.getElementById("costTotal");
		var marginValueTotal = document.getElementById("marginValueTotal");
		var marginTotal = document.getElementById("marginTotal");
		
		manday.value = parseFloat(manday.value.replace(/,/g, "")) + gap;
		if(tax != null && tax.value == "y"){
			revenue.value = parseFloat(manday.value)*parseFloat(serviceRate.value.replace(/,/g, ""))*parseFloat(currRate.value.replace(/,/g, ""));
		}else{
			revenue.value = parseFloat(manday.value)*parseFloat(serviceRate.value.replace(/,/g, ""))*parseFloat(currRate.value.replace(/,/g, ""))*1.0505;
		}
		cost.value = parseFloat(manday.value)*parseFloat(costRate.value.replace(/,/g, ""));
		marginValue.value = parseFloat(revenue.value.replace(/,/g, ""))*0.95 - parseFloat(cost.value.replace(/,/g, ""));
		
		if(parseFloat(revenue.value.replace(/,/g, "")) == 0){
			margin.value = 0;
		} else{
			margin.value = (parseFloat(marginValue.value.replace(/,/g, ""))/parseFloat(revenue.value.replace(/,/g, "")))*100;
			checkDeciNumber2(margin,1,1,'margin'+col,-100,100);
			margin.value = margin.value + "%";
		}
				
		checkDeciNumber2(revenue,1,1,'revenue'+col,-9999999999,9999999999);
		addComma(revenue, '.', '.', ',');
		checkDeciNumber2(cost,1,1,'cost'+col,-9999999999,9999999999);
		addComma(cost, '.', '.', ',');
		checkDeciNumber2(marginValue,1,1,'marginValue'+col,-9999999999,9999999999);
		addComma(marginValue, '.', '.', ',');
				
		var revenueGap = parseFloat(revenue.value.replace(/,/g, "")) - parseFloat(revenue.oldvalue.replace(/,/g, ""));
		var costGap = parseFloat(cost.value.replace(/,/g, "")) - parseFloat(cost.oldvalue.replace(/,/g, ""));
		
		revenue.oldvalue = revenue.value;
		cost.oldvalue = cost.value;
		
		dayTotal.value = parseFloat(dayTotal.value.replace(/,/g, "")) + gap;
		revenueTotal.value = parseFloat(revenueTotal.value.replace(/,/g, "")) + revenueGap;
		costTotal.value = parseFloat(costTotal.value.replace(/,/g, "")) + costGap;
		marginValueTotal.value = parseFloat(revenueTotal.value.replace(/,/g, ""))*0.95 - parseFloat(costTotal.value.replace(/,/g, ""));
		
		if(parseFloat(revenueTotal.value.replace(/,/g, "")) == 0){
			marginTotal.value = 0;
		} else{
			marginTotal.value = (parseFloat(marginValueTotal.value.replace(/,/g, ""))/parseFloat(revenueTotal.value.replace(/,/g, "")))*100;
			checkDeciNumber2(marginTotal,1,1,'marginTotal',-100,100);
			marginTotal.value = marginTotal.value + "%";
		}
		
		checkDeciNumber2(revenueTotal,1,1,'revenueTotal',-9999999999,9999999999);
		addComma(revenueTotal, '.', '.', ',');
		checkDeciNumber2(costTotal,1,1,'costTotal',-9999999999,9999999999);
		addComma(costTotal, '.', '.', ',');
		checkDeciNumber2(marginValueTotal,1,1,'marginValueTotal',-9999999999,9999999999);
		addComma(marginValueTotal, '.', '.', ',');
	}
}

function fnFormat(obj){

	var s = obj.value;
	
	var str = "";
	var arr ="";
	
	var list = s.split(".");
	
	for(var i = 0; i < list[0].length; i++){
		alert(list[0].charAt(i));
		str = str + list[0].charAt(i);
	}
	
	alert(list[1].charAt(0));
	alert(list[1].charAt(1));
	str = str + ".";
	str = str + list[1].charAt(0);
	str = str + list[1].charAt(1);
	
	obj.value="";
	for(var i = 0; i < str.length; i++){
		alert(str.charAt(i));
		obj.value = obj.value + "" + str.charAt(i);
	}
	return;
}

<%if(actionflag!=null){%>
var actionflag = "haha";
actionflag =  "<%=actionflag%>";
var array = actionflag.split('|');
alert(array[0]+" success!");
<%}%>

</script>
</form>

<%
	}catch(Exception e){
		e.printStackTrace();
	}
}else{
	out.println("没有权限访问");
}%>


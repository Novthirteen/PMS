<%@ page contentType="text/html; charset=gb2312" language="java" errorPage="" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<!-- 
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.util.*"%>
-->
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
		NumberFormat numFormater = NumberFormat.getInstance();
		numFormater.setMaximumFractionDigits(2);
		numFormater.setMinimumFractionDigits(2);
	
		//String action = (String)request.getAttribute("formaction");
				
		ProjPlanBomMaster master = (ProjPlanBomMaster)request.getAttribute("master");
%>

<form name="frm1" action="editProjBOMCost.do" method="post">
<input type="hidden" name="masterid" value="<%=master.getId()%>">
<input type="hidden" name="formaction" value="edit">
<table border="0" cellpadding="4" cellspacing="0" align ="center" width="100%">
	<CAPTION class=pgheadsmall>Project BOM(Precal Confirm)</CAPTION>
	<tr ><td colspan=10>&nbsp;</td></tr>
    <tr align="center">
    	<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
	    <%if(master.getBid()!=null){%>
	    <td class="lblbold" width="10%" align="right">Bid :</td>
	    <td class="lblbold" width="10%" align="left"><%=master.getBid().getNo()%></td>
	    <td class="lblbold" width="30%" align="right">Bid Description:</td>
	    <td class="lblbold" width="30%" align="left"><%=master.getBid().getDescription()%></td>
	    <%}%>
	    <%if(master.getProject()!=null){%>
	    <td class="lblbold" width="10%" align="right">Project ID:</td>
	    <td class="lblbold" width="10%" align="left"><%if(master.getProject()!=null)out.println(master.getProject().getProjId());%></td>
	    <td class="lblbold" width="10%" align="right">Project Description:</td>
	    <td class="lblbold" width="10%" align="left"><%if(master.getProject()!=null)out.println(master.getProject().getProjName());%></td>
	    <%}%>
	    <td class="lblbold" width="10%" align="right">Version:</td>
	    <td class="lblbold" width="10%" align="left"><%=master.getVersion()%></td>
	    <td >&nbsp;</td>
	    <td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
    </tr>
</table>
<hr/>
<%
List resultList  = (List)request.getAttribute("resultList");
List stList = (List)request.getAttribute("servicetype");
//String sttitle = null;
//String stother = null;
int totalMD[] = new int[stList.size()];
%>
<br>
<table id="root"  cellpadding="1" border="0" cellspacing="1" align="center" width="100%">
	<tr bgcolor="#d3d3d3" height="20">
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
		<td class="lblbold" align='center' nowrap >Description</td>
		<td class="lblbold" align='center' nowrap >Document</td>
		<%
		//HashMap stmap = (HashMap)request.getAttribute("stmap");
		//String strTotal = "";
		
		for(int i=0;i<stList.size();i++){
			ProjPlanType type = (ProjPlanType)stList.get(i);
		%>
		<td class=lblbold align=center ><%=type.getDescription()%>/<font color="red"><%=type.getSl().getDescription()%></font></td>
			<input type=hidden name=servicetypeid value="<%=type.getId()%>">
			<input type=hidden name=strate value="<%=type.getSTRate()%>">
			<input type=hidden name=costrate value="<%=type.getSl().getRate()%>">
		<%}%>
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
	</tr>
	<%
	for(int i=0;i<resultList.size();i++){
		ProjPlanBom ppb = (ProjPlanBom)resultList.get(i);
		HashMap typeMap = new HashMap();
		//System.out.println("the size is:"+ppb.getTypes().size());
		if(ppb.getTypes().size()>0){
			Iterator it = ppb.getTypes().iterator();
			while(it.hasNext()){
				ProjPlanBOMST st = (ProjPlanBOMST)it.next();
				typeMap.put(new Long(st.getType().getId()),st);
			}
		}
		//HashMap typeMap = ppb.getTypeMap();
		int level =  ppb.getRanking().length()/3;
		String tr_name = "tr"+ppb.getId();
	%>
	<tr id="<%=tr_name%>" _id='<%=ppb.getId()%>' bgcolor='#e9eee9'>
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
			<input size="1" type="text" readonly style="border:0px;margin-left:'<%=level*10%>px';background-color:<%=bgcolor%>">
			<%=ppb.getStepdesc()%>
			<input type="hidden" name="bom_id" value="<%=ppb.getId()%>">
		</td>
		<td bgcolor="<%=bgcolor%>" align="center" nowrap>
			<input size="30" type="text" name="document"  value="<%if(ppb.getDocument()!=null)out.println(ppb.getDocument());%>" readonly style="background-color:<%=bgcolor%>;border:0px">
		</td>
		<%
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
			%>
			<input type="hidden" name="hid_id<%=i%>" value="<%=((ProjPlanBOMST)typeMap.get(new Long(ppt.getId()))).getId()%>">
			<%
			}else{
			%>
			<input type="hidden" name="hid_id<%=i%>" value="-1">
			<%}%>	
			<input type="text"  size="5" name="st<%=i%>" col="<%=j%>" row="<%=i%>" oldvalue="<%=day%>" value="<%=day%>" readonly style="text-align:right;border:0px;background-color:<%=bgcolor%>" onchange="javascript:fnReCal(this)">
		</td>
		<%}%>
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
	</tr>
	<%}%>
	<tr align="right">
		<td class="lblbold" bgcolor="#ffffff" width="1%">&nbsp;</td>
		<td class="lblbold" colspan=2 align="right">Total:</td>
		<%for(int i=0;i<stList.size();i++){%>
		<td class="lblbold" align="right"><%=totalMD[i]%></td>
		<%}%>
	</tr>
</table>
<br>
<table border=0 cellspacing='0' cellpadding='0'>
	<tr>
		<td class="lblbold" bgcolor="#ffffff" width="1%" >&nbsp;</td>
		<td>
			<table border=0 cellspacing='0' cellpadding='0' class='boxoutside'>
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
										int dayTotal = 0;
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
							          		<td><p align="left"><%=type.getDescription()%> (<%=taxDesc%>)</td>
								          	<td><p align="center"><input type="text"  size="5" name="currency" value="<%=type.getCurrency().getCurrName()%>" readonly style="text-align:center;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="12" name="serviceRate" value="<%=numFormater.format(sr)%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="12" name="costRate" value="<%=numFormater.format(type.getSl().getRate())%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="8" name="manday" value="<%=totalMD[i]%>" readonly style="text-align:center;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="12" name="revenue" value="<%=numFormater.format(revenue)%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="12" name="cost" value="<%=numFormater.format(cost)%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="12" name="marginValue" value="<%=numFormater.format(marginValue)%>" readonly style="text-align:right;background-color:#ffffff;border=0px"></td>
								          	<td><p align="center"><input type="text"  size="8" name="margin" value="<%=numFormater.format(margin*100) + "%"%>" readonly style="text-align:center;background-color:#ffffff;border=0px"></td>
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
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="10" name="dayTotal" value="<%=dayTotal%>" readonly style="text-align:center;background-color:#e9eee9;border=0px"></td>
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="12" name="revenueTotal" value="<%=numFormater.format(revenueTotal)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px"></td>
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="12" name="costTotal" value="<%=numFormater.format(costTotal)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px"></td>
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="12" name="marginValueTotal" value="<%=numFormater.format(marginValueTotal)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px"></td>
					         			 	<td class="bottomBox"><p align="center"><input type="text"  size="12" name="marginTotal" value="<%=numFormater.format(marginTotal*100) + "%"%>" readonly style="text-align:center;background-color:#e9eee9;border=0px"></td>
					         			 </tr>
					                </table>
					            </td>
				          </tr>
				        </table>
					</td>
				</tr>
			</table>
		</td>
		<td class="lblbold" bgcolor="#ffffff" width="1%" >&nbsp;</td>
	</tr>
</table>

<br>
<table width="100%">
<tr><td align="right">
<input type="button" class="button" value="Project BOM Precalculation" onclick="fnDialog()">
<input type="button" class="button" value="Back to List" onclick="location.replace('findProjBOM.do?formaction=listreve')">
<input type="hidden" name="dpt" >
</td></tr></table>
<script language="javascript">

<%if(actionflag!=null){%>
var actionflag = "haha";
actionflag =  "<%=actionflag%>";
var array = actionflag.split('|');
alert(array[0]+" success!");
<%}%>

function fnDialog(){

	var param = "?formAction=view";
	var masterId = document.getElementById("masterid").value;
	param += "&masterId=" + masterId;
		
	v = window.showModalDialog(
		"system.showDialog.do?title=prm.pms.precal.title&editProjBOMPrecal.do" + param,
		null,
		'dialogWidth:1000px;dialogHeight:660px;status:no;help:no;scroll:no');
}

</script>
</form>
<%
	}catch(Exception e){
		e.printStackTrace();
	}
}else{
	out.println("!!你没有相关访问权限!!");
}%>
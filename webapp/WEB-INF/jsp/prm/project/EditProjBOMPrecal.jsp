<%@ page contentType="text/html; charset=gb2312"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.aof.component.prm.project.ProjPlanType"%>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try{
if (AOFSECURITY.hasEntityPermission("PMS", "_BOM_MAINTENANCE", session)) {

	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);
	
	String masterId = (String) request.getAttribute("masterId");
	List stList = (List)request.getAttribute("stList");
	List valueList = (List)request.getAttribute("valueList");

	if(valueList == null){
		valueList = new ArrayList();
	}
	
	String actionFlag = (String)request.getAttribute("actionFlag");
	if(actionFlag == null){
		actionFlag = "";
	}
%>
<HTML>
	<HEAD>
		
		<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		
		<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunctions.js'></script>
		
		<script language="javascript">
		
			<%if(actionFlag != null && actionFlag.length() > 0){%>
			alert("updaate success!");
			<%}%>
		
			function fnSave() {
				document.iForm.formAction.value = "update";
				document.iForm.submit();
			}
			
			function fnExport(){
				document.iForm.formAction.value = "export";
				document.iForm.submit();
			}
			
			function onClose() {
				window.parent.close();
			}
			
			function fnChange(obj){
				
				if(isNaN(parseFloat(obj.value))){
	
					alert('please input a valid number');
					obj.focus();
					return;
					
				}else if(parseFloat(obj.value)<0){
				
					alert('minus number is not accepted');
					obj.focus();
					return;
					
				}else{
					var col = obj.col;
					
					var manDay = document.getElementById("manDay" + col);
					var directRate = document.getElementById("directRate" + col);
					var indirRate = document.getElementById("indirRate" + col);
					var costRate = document.getElementById("costRate" + col);
					var saleRate = document.getElementById("saleRate" + col);
					var rev = document.getElementById("rev" + col);
					var nhrRev = document.getElementById("nhrRev" + col);
					var otherRev = document.getElementById("otherRev" + col);
					var totalRev = document.getElementById("totalRev" + col);
					var csc = document.getElementById("csc" + col);
					var tax = document.getElementById("tax" + col);
					var margin = document.getElementById("margin" + col);
					var cost = document.getElementById("cost" + col);
					var profit = document.getElementById("profit" + col);
					var indirCost = document.getElementById("indirCost" + col);
					var beforeTax = document.getElementById("beforeTax" + col);
					var corpTax = document.getElementById("corpTax" + col);
					var ifo = document.getElementById("ifo" + col);
					var ifoPer1 = document.getElementById("ifoPer1" + col);
					var marginPer = document.getElementById("marginPer" + col);
					var grossProfit = document.getElementById("grossProfit" + col);
					var ifoPer2 = document.getElementById("ifoPer2" + col);
					
					var allRev = document.getElementById("allRev");
					var allNhrRev = document.getElementById("allNhrRev");
					var allOtherRev = document.getElementById("allOtherRev");
					var allTotalRev = document.getElementById("allTotalRev");
					var allCsc = document.getElementById("allCsc");
					var allTax = document.getElementById("allTax");
					var allMargin = document.getElementById("allMargin");
					var allCost = document.getElementById("allCost");
					var allProfit = document.getElementById("allProfit");
					var allIndirCost = document.getElementById("allIndirCost");
					var allBeforeTax = document.getElementById("allBeforeTax");
					var allCorpTax = document.getElementById("allCorpTax");
					var allIfo = document.getElementById("allIfo");
					var allIfoPer1 = document.getElementById("allIfoPer1");
					var allMarginPer = document.getElementById("allMarginPer");
					var allGrossProfit = document.getElementById("allGrossProfit");
					var allIfoPer2 = document.getElementById("allIfoPer2");
					
					costRate.value = parseFloat(indirRate.value.replace(/,/g, "")) + parseFloat(directRate.value.replace(/,/g, ""));
					rev.value = parseFloat(saleRate.value.replace(/,/g, "")) * parseFloat(manDay.value);
					otherRev.value = parseFloat(rev.value) * 0.0505;
					totalRev.value = parseFloat(rev.value) + parseFloat(nhrRev.value.replace(/,/g, "")) + parseFloat(otherRev.value);
					tax.value = parseFloat(totalRev.value) * 0.05
					margin.value = parseFloat(totalRev.value) - parseFloat(csc.value.replace(/,/g, "")) - parseFloat(tax.value);
					cost.value = parseFloat(costRate.value) * parseFloat(manDay.value);
					profit.value = parseFloat(margin.value) - parseFloat(cost.value);
					indirCost.value = parseFloat(totalRev.value) * 0.2;
					beforeTax.value = parseFloat(profit.value) - parseFloat(indirCost.value);
					corpTax.value = parseFloat(beforeTax.value) * 0.075;
					ifo.value = parseFloat(beforeTax.value) - parseFloat(corpTax.value);
					if(parseFloat(totalRev.value) == 0){
						ifoPer1.value = 0.00;
					} else {
						ifoPer1.value = parseFloat(ifo.value)/parseFloat(totalRev.value);
					}
					if(parseFloat(totalRev.value) == 0){
						ifoPer1.value = 0.00;
					} else {
						marginPer.value = parseFloat(margin.value)/parseFloat(totalRev.value);
					}
					if(parseFloat(totalRev.value) == 0){
						grossProfit.value = 0.00;
					} else {
						grossProfit.value = parseFloat(profit.value)/parseFloat(totalRev.value);
					}
					ifoPer2.value = parseFloat(ifoPer1.value);
					
					var nhrRevGap = parseFloat(nhrRev.value) - parseFloat(nhrRev.oldvalue.replace(/,/g, ""));
					nhrRev.oldvalue = nhrRev.value;
					var totalRevGap = parseFloat(totalRev.value) - parseFloat(totalRev.oldvalue.replace(/,/g, ""));
					totalRev.oldvalue = totalRev.value;
					var cscGap = parseFloat(csc.value) - parseFloat(csc.oldvalue.replace(/,/g, ""));
					csc.oldvalue = csc.value;
					var taxGap = parseFloat(tax.value) - parseFloat(tax.oldvalue.replace(/,/g, ""));
					tax.oldvalue = tax.value;
					var marginGap = parseFloat(margin.value) - parseFloat(margin.oldvalue.replace(/,/g, ""));
					margin.oldvalue = margin.value;
					var costGap = parseFloat(cost.value) - parseFloat(cost.oldvalue.replace(/,/g, ""));
					cost.oldvalue = cost.value;
					var profitGap = parseFloat(profit.value) - parseFloat(profit.oldvalue.replace(/,/g, ""));
					profit.oldvalue = profit.value;
					var indirCostGap = parseFloat(indirCost.value) - parseFloat(indirCost.oldvalue.replace(/,/g, ""));
					indirCost.oldvalue = indirCost.value;
					var beforeTaxGap = parseFloat(beforeTax.value) - parseFloat(beforeTax.oldvalue.replace(/,/g, ""));
					beforeTax.oldvalue = beforeTax.value;
					var corpTaxGap = parseFloat(corpTax.value) - parseFloat(corpTax.oldvalue.replace(/,/g, ""));
					corpTax.oldvalue = corpTax.value;
					var ifoGap = parseFloat(ifo.value) - parseFloat(ifo.oldvalue.replace(/,/g, ""));
					ifo.oldvalue = ifo.value;
					
					allNhrRev.value = parseFloat(allNhrRev.value.replace(/,/g, "")) + nhrRevGap;
					allTotalRev.value = parseFloat(allTotalRev.value.replace(/,/g, "")) + totalRevGap;
					allCsc.value = parseFloat(allCsc.value.replace(/,/g, "")) + cscGap;
					allTax.value = parseFloat(allTax.value.replace(/,/g, "")) + taxGap;
					allMargin.value = parseFloat(allMargin.value.replace(/,/g, "")) + marginGap;
					allCost.value = parseFloat(allCost.value.replace(/,/g, "")) + costGap;
					allProfit.value = parseFloat(allProfit.value.replace(/,/g, "")) + profitGap;
					allIndirCost.value = parseFloat(allIndirCost.value.replace(/,/g, "")) + indirCostGap;
					allBeforeTax.value = parseFloat(allBeforeTax.value.replace(/,/g, "")) + beforeTaxGap;
					allCorpTax.value = parseFloat(allCorpTax.value.replace(/,/g, "")) + corpTaxGap;
					allIfo.value = parseFloat(allIfo.value.replace(/,/g, "")) + ifoGap;
					if(parseFloat(allTotalRev.value) == 0){
						allIfoPer1 = 0.00;
					}else{
						allIfoPer1.value = parseFloat(allIfo.value)/parseFloat(allTotalRev.value);
					}
					if(parseFloat(allTotalRev.value) == 0){
						allMarginPer.value = 0.00;
					}else{
						allMarginPer.value = parseFloat(allMargin.value)/parseFloat(allTotalRev.value);
					}
					if(parseFloat(allTotalRev.value) == 0){
						allGrossProfit.value = 0.00;
					}else{
						allGrossProfit.value = parseFloat(allProfit.value)/parseFloat(allTotalRev.value);
					}
					allIfoPer2.value = parseFloat(allIfoPer1.value);
					
					checkDeciNumber2(indirRate,1,1,'indirRate'+col,-9999999999,9999999999);
					addComma(indirRate, '.', '.', ',');
					checkDeciNumber(costRate,1,1,"costRate"+col,-9999999999,9999999999);
					addComma(costRate, '.', '.', ',');
					checkDeciNumber2(nhrRev,1,1,"nhrRev"+col,-9999999999,9999999999);
					addComma(nhrRev, '.', '.', ',');
					checkDeciNumber2(otherRev,1,1,'otherRev'+col,-9999999999,9999999999);
					addComma(otherRev, '.', '.', ',');
					checkDeciNumber2(totalRev,1,1,"totalRev"+col,-9999999999,9999999999);
					addComma(totalRev, '.', '.', ',');
					checkDeciNumber2(csc,1,1,"csc"+col,-9999999999,9999999999);
					addComma(csc, '.', '.', ',');
					checkDeciNumber2(tax,1,1,"tax"+col,-9999999999,9999999999);
					addComma(tax, '.', '.', ',');
					checkDeciNumber2(margin,1,1,"margin"+col,-9999999999,9999999999);
					addComma(margin, '.', '.', ',');
					checkDeciNumber2(cost,1,1,"cost"+col,-9999999999,9999999999);
					addComma(cost, '.', '.', ',');
					checkDeciNumber2(profit,1,1,"profit"+col,-9999999999,9999999999);
					addComma(profit, '.', '.', ',');
					checkDeciNumber2(indirCost,1,1,"indirCost"+col,-9999999999,9999999999);
					addComma(indirCost, '.', '.', ',');
					checkDeciNumber2(beforeTax,1,1,"beforeTax"+col,-9999999999,9999999999);
					addComma(beforeTax, '.', '.', ',');
					checkDeciNumber2(corpTax,1,1,"corpTax"+col,-9999999999,9999999999);
					addComma(corpTax, '.', '.', ',');
					checkDeciNumber2(ifo,1,1,"ifo"+col,-9999999999,9999999999);
					addComma(ifo, '.', '.', ',');
					
					ifoPer1.value = parseFloat(ifoPer1.value) * 100;
					checkDeciNumber2(ifoPer1,1,1,"ifoPer1"+col,-9999999999,9999999999);
					ifoPer1.value = ifoPer1.value + "%";
					
					marginPer.value = parseFloat(marginPer.value) * 100;
					checkDeciNumber2(marginPer,1,1,"marginPer"+col,-9999999999,9999999999);
					marginPer.value = marginPer.value + "%";
					
					grossProfit.value = parseFloat(grossProfit.value) * 100;
					checkDeciNumber2(grossProfit,1,1,"grossProfit"+col,-9999999999,9999999999);
					grossProfit.value = grossProfit.value + "%";
					
					ifoPer2.value = ifoPer1.value;
					
					
					checkDeciNumber2(allNhrRev,1,1,"allNhrRev",-9999999999,9999999999);
					addComma(allNhrRev, '.', '.', ',');
					checkDeciNumber2(allTotalRev,1,1,"allTotalRev",-9999999999,9999999999);
					addComma(allTotalRev, '.', '.', ',');
					checkDeciNumber2(allCsc,1,1,"allCsc",-9999999999,9999999999);
					addComma(allCsc, '.', '.', ',');
					checkDeciNumber2(allTax,1,1,"allTax",-9999999999,9999999999);
					addComma(allTax, '.', '.', ',');
					checkDeciNumber2(allMargin,1,1,"allMargin",-9999999999,9999999999);
					addComma(allMargin, '.', '.', ',');
					checkDeciNumber2(allCost,1,1,"allCost",-9999999999,9999999999);
					addComma(allCost, '.', '.', ',');
					checkDeciNumber2(allProfit,1,1,"allProfit",-9999999999,9999999999);
					addComma(allProfit, '.', '.', ',');
					checkDeciNumber2(allIndirCost,1,1,"allIndirCost",-9999999999,9999999999);
					addComma(allIndirCost, '.', '.', ',');
					checkDeciNumber2(allBeforeTax,1,1,"allBeforeTax",-9999999999,9999999999);
					addComma(allBeforeTax, '.', '.', ',');
					checkDeciNumber2(allCorpTax,1,1,"allCorpTax",-9999999999,9999999999);
					addComma(allCorpTax, '.', '.', ',');
					checkDeciNumber2(allIfo,1,1,"allIfo",-9999999999,9999999999);
					addComma(allIfo, '.', '.', ',');
					
					allIfoPer1.value = parseFloat(allIfoPer1.value) * 100;
					checkDeciNumber2(allIfoPer1,1,1,"allIfoPer1",-9999999999,9999999999);
					allIfoPer1.value = allIfoPer1.value + "%";
					
					allMarginPer.value = parseFloat(allMarginPer.value) * 100;
					checkDeciNumber2(allMarginPer,1,1,"allMarginPer",-9999999999,9999999999);
					allMarginPer.value = allMarginPer.value + "%";
					
					allGrossProfit.value = parseFloat(allGrossProfit.value) * 100;
					checkDeciNumber2(allGrossProfit,1,1,"allGrossProfit",-9999999999,9999999999);
					allGrossProfit.value = allGrossProfit.value + "%";
					
					allIfoPer2.value = allIfoPer1.value;
				}
			}
		</script>
	</HEAD>
	<BODY>
		<form name="iForm" action="editProjBOMPrecal.do" method="post">
		
			<input type="hidden" name="formAction" id="formAction" value="view">
			<input type="hidden" name="masterId" id="masterId" value="<%=masterId%>">
			
			<table border="0" cellpadding="4" cellspacing="0" align ="center" width="100%">
				<CAPTION class=pgheadsmall>Project BOM Pre-Calculation</CAPTION>
			</table>
			<hr/>
			<br>
			<table width='100%' border='0' cellpadding='0' cellspacing='1'>
			
            	<tr height="20">
            		<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#4682b4" width="20%">&nbsp;</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	ProjPlanType tmpType = (ProjPlanType)stList.get(i);
		            %>
		            <input type="hidden" name="stId" id="stId" value="<%=tmpType.getId()%>">
		            <td align="center" class="lblbold" bgcolor="#4682b4" width="10%"><%=tmpType.getDescription()%></td>
		          	<%}%>
		          	<td align="center" class="lblbold" bgcolor="#4682b4" width="10%">Total</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>NR OF Man-days USED FOR PROJECT&nbsp;</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	int[] manDay = (int[]) valueList.get(0);
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="10" name="manDay<%=i%>" id="manDay<%=i%>" value="<%=manDay[i]%>" readonly style="text-align:center;background-color:#e9eee9;border=0px">
		            </td>
		          	<%}%>
		          	<td align="right" class="lblLight" bgcolor="#e9eee9">&nbsp;</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>Fully Loaded DIRECT Cost Rate per day of resource</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double directRate = (((ProjPlanType) stList.get(i)).getSl().getRate()).doubleValue();
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<input type="text"  size="12" name="directRate<%=i%>" id="directRate<%=i%>" value="<%=numFormater.format(directRate)%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		            </td>
		          	<%}%>
		          	<td align="right" class="lblLight" bgcolor="#b0c4de">&nbsp;</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>Fully Loaded EXPENSE Cost Rate per day of resource</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	ProjPlanType type = (ProjPlanType)stList.get(i);
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="12" name="indirRate" id="indirRate<%=i%>" col="<%=i%>" value="<%=numFormater.format(type.getIndirectRate())%>" style="text-align:right;background-color:#ffffff" onchange="fnChange(this)">
		            </td>
		          	<%}%>
		          	<td align="right" class="lblLight" bgcolor="#e9eee9">&nbsp;</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>Fully Loaded Cost Rate per day of resource</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	ProjPlanType type = (ProjPlanType)stList.get(i);
		            	double costRate = (type.getSl().getRate()).doubleValue() + type.getIndirectRate();
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<input type="text"  size="12" name="costRate<%=i%>" id="costRate<%=i%>" value="<%=numFormater.format(costRate)%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		            </td>
		          	<%}%>
		          	<td align="right" class="lblLight" bgcolor="#b0c4de">&nbsp;</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>Sales Rate per resource</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            
		            	ProjPlanType type = (ProjPlanType)stList.get(i);
		            	double stRate = type.getSTRate();
						float currRate = (type.getCurrency().getCurrRate()).floatValue();
						String tax = type.getTax();
		
						double rate = stRate * currRate;
						if (tax != null && tax.equals("y")) {
							rate = rate / 1.05;
						}
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="12" name="saleRate<%=i%>" id="saleRate<%=i%>" value="<%=numFormater.format(rate)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		            </td>
		          	<%}%>
		          	<td align="right" class="lblLight" bgcolor="#e9eee9">&nbsp;</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>Hour related revenue (TM projects)</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] revenue = (double[]) valueList.get(2);
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<input type="text"  size="12" name="rev<%=i%>" id="rev<%=i%>" value="<%=numFormater.format(revenue[i])%>" oldvalue="<%=numFormater.format(revenue[i])%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		            </td>
		          	<%
		          	}
		          	double allRevenue = ((Double) valueList.get(11)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#b0c4de">
		          		<input type="text"  size="12" name="allRev" id="allRev" value="<%=numFormater.format(allRevenue)%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>Non-hour related revenue (FPP projects)</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	ProjPlanType type = (ProjPlanType)stList.get(i);
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="12" name="nhrRev<%=i%>" id="nhrRev<%=i%>" col="<%=i%>" value="<%=numFormater.format(type.getNhrRevenue())%>" oldvalue="<%=numFormater.format(type.getNhrRevenue())%>" style="text-align:right;background-color:#ffffff" onchange="fnChange(this)">
		            </td>
		          	<%
		          	}
		          	double allNhrRev = ((Double) valueList.get(14)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#e9eee9">
		          		<input type="text"  size="12" name="allNhrRev" id="allNhrRev" value="<%=numFormater.format(allNhrRev)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>Other Revenue<br>(e.g. licence , maintenance or the rate is exclude tax etc)</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] otherRev = (double[]) valueList.get(3);
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<input type="text"  size="12" name="otherRev<%=i%>" id="otherRev<%=i%>" value="<%=numFormater.format(otherRev[i])%>" oldvalue="<%=numFormater.format(otherRev[i])%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		            </td>
		          	<%
		          	}
		          	double allOtherRev = ((Double) valueList.get(13)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#b0c4de">
		          		<input type="text"  size="12" name="allOtherRev" id="allOtherRev" value="<%=numFormater.format(allOtherRev)%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>Total revenue (include business tax)</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] totalRevenue = (double[]) valueList.get(4);
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="12" name="totalRev<%=i%>" id="totalRev<%=i%>" value="<%=numFormater.format(totalRevenue[i])%>" oldvalue="<%=numFormater.format(totalRevenue[i])%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		            </td>
		          	<%
		          	}
		          	double allTotalRev = ((Double) valueList.get(12)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#e9eee9">
		          		<input type="text"  size="12" name="allTotalRev" id="allTotalRev" value="<%=numFormater.format(allTotalRev)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>Coding Subcontract</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	ProjPlanType type = (ProjPlanType)stList.get(i);
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<input type="text"  size="12" name="csc<%=i%>" id="csc<%=i%>" col="<%=i%>" value="<%=numFormater.format(type.getCodingSubContr())%>" oldvalue="<%=numFormater.format(type.getCodingSubContr())%>" style="text-align:right;background-color:#ffffff" onChange="fnChange(this)">
		            </td>
		          	<%
		          	}
		          	double allCsc = ((Double) valueList.get(15)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#b0c4de">
		          		<input type="text"  size="12" name="allCsc" id="allCsc" value="<%=numFormater.format(allCsc)%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>Business tax (for China portion)<br>or other taxes levied on revenue</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] totalRevenue = (double[]) valueList.get(4);
						double tax = totalRevenue[i] * 0.05;
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="12" name="tax<%=i%>" id="tax<%=i%>" value="<%=numFormater.format(tax)%>" oldvalue="<%=numFormater.format(tax)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		            </td>
		          	<%
		          	}
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#e9eee9">
		          		<input type="text"  size="12" name="allTax" id="allTax" value="<%=numFormater.format(allTotalRev * 0.05)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>Contribution margin</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] margin = (double[]) valueList.get(5);
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<input type="text"  size="12" name="margin<%=i%>" id="margin<%=i%>" value="<%=numFormater.format(margin[i])%>" oldvalue="<%=numFormater.format(margin[i])%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		            </td>
		          	<%
		          	}
		          	double allMargin = ((Double) valueList.get(16)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#b0c4de">
		          		<input type="text"  size="12" name="allMargin" id="allMargin" value="<%=numFormater.format(allMargin)%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>DIRECT Cost of resources used</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] cost = (double[]) valueList.get(1);
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="12" name="cost<%=i%>" id="cost<%=i%>" value="<%=numFormater.format(cost[i])%>" oldvalue="<%=numFormater.format(cost[i])%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		            </td>
		          	<%
		          	}
		          	double allCost = ((Double) valueList.get(10)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#e9eee9">
		          		<input type="text"  size="12" name="allCost" id="allCost" value="<%=numFormater.format(allCost)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>Gross Profit</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] profit = (double[]) valueList.get(6);
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<input type="text"  size="12" name="profit<%=i%>" id="profit<%=i%>" value="<%=numFormater.format(profit[i])%>" oldvalue="<%=numFormater.format(profit[i])%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		            </td>
		          	<%
		          	}
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#b0c4de">
		          		<input type="text"  size="12" name="allProfit" id="allProfit" value="<%=numFormater.format(allMargin - allCost)%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>INDIRECT Cost of resources used</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] totalRevenue = (double[]) valueList.get(4);
						double indirCost = totalRevenue[i] * 0.2;
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="12" name="indirCost<%=i%>" id="indirCost<%=i%>" value="<%=numFormater.format(indirCost)%>" oldvalue="<%=numFormater.format(indirCost)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		            </td>
		          	<%
		          	}
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#e9eee9">
		          		<input type="text"  size="12" name="allIndirCost" id="allIndirCost" value="<%=numFormater.format(allTotalRev * 0.15)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>Profit before Corporate Tax</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] beforTax = (double[]) valueList.get(7);
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<input type="text"  size="12" name="beforeTax<%=i%>" id="beforeTax<%=i%>" value="<%=numFormater.format(beforTax[i])%>" oldvalue="<%=numFormater.format(beforTax[i])%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		            </td>
		          	<%
		          	}
		          	double allBeforTax = ((Double) valueList.get(17)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#b0c4de">
		          		<input type="text"  size="12" name="allBeforeTax" id="allBeforeTax" value="<%=numFormater.format(allBeforTax)%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>Corporte tax</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] corpTax = (double[]) valueList.get(8);
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="12" name="corpTax<%=i%>" id="corpTax<%=i%>" value="<%=numFormater.format(corpTax[i])%>" oldvalue="<%=numFormater.format(corpTax[i])%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		            </td>
		          	<%
		          	}
		          	double allCorpTax = ((Double) valueList.get(18)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#e9eee9">
		          		<input type="text"  size="12" name="allCorpTax" id="allCorpTax" value="<%=numFormater.format(allCorpTax)%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>IFO</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            	double[] ifo = (double[]) valueList.get(9);
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<input type="text"  size="12" name="ifo<%=i%>" id="ifo<%=i%>" value="<%=numFormater.format(ifo[i])%>" oldvalue="<%=numFormater.format(ifo[i])%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		            </td>
		          	<%
		          	}
		          	double allIfo = ((Double) valueList.get(19)).doubleValue();
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#b0c4de">
		          		<input type="text"  size="12" name="allIfo" id="allIfo" value="<%=numFormater.format(allIfo)%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>IFO %</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            
		            	double ifoPer = 0;
		            	
						double[] totalRevenue = (double[]) valueList.get(4);
						double[] profit = (double[]) valueList.get(6);
						
						if (totalRevenue[i] != 0) {
							ifoPer = ((profit[i] - totalRevenue[i] * 0.15) * 0.925) / totalRevenue[i];
						}
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<input type="text"  size="12" name="ifoPer1<%=i%>" id="ifoPer1<%=i%>" value="<%=ifoPer == 0 ? "0.00" : (numFormater.format(ifoPer * 100) + "%")%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		            </td>
		          	<%
		          	}
		          	%>
		          	<td align="center" class="lblLight" bgcolor="#e9eee9">
		          		<input type="text" size="12" name="allIfoPer1" id="allIfoPer1" value="<%=allTotalRev == 0 ? "0.00" : (numFormater.format((allIfo / allTotalRev) * 100) + "%")%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>Contribution Margin as % of Revenue</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            
		            	double marginPer = 0;

						double[] totalRevenue = (double[]) valueList.get(4);
						double[] margin = (double[]) valueList.get(5);
		
						if (totalRevenue[i] != 0) {
							marginPer = margin[i] / totalRevenue[i];
						}
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
		            	<font color=blue>
		            		<input type="text" size="12" name="marginPer<%=i%>" id="marginPer<%=i%>" value="<%=marginPer == 0 ? "0.00" : (numFormater.format(marginPer * 100) + "%")%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
		            	</font>
		            </td>
		          	<%}%>
		          	<td align="center" class="lblLight" bgcolor="#b0c4de">
						<font color=blue>
							<input type="text" size="12" name="allMarginPer" id="allMarginPer" value="<%=allTotalRev == 0 ? "0.00" : (numFormater.format((allMargin / allTotalRev) * 100) + "%")%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
						</font>
					</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#e9eee9" nowrap>Gross Profit as % of Revenue</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            
						double profitPer = 0;

						double[] totalRevenue = (double[]) valueList.get(4);
						double[] profit = (double[]) valueList.get(6);
		
						if (totalRevenue[i] != 0) {
							profitPer = profit[i] / totalRevenue[i];
						}
		            %>
		            <td align="center" class="lblLight" bgcolor="#e9eee9">
		            	<font color=blue>
		            		<input type="text" size="12" name="grossProfit<%=i%>" id="grossProfit<%=i%>" value="<%=profitPer == 0 ? "0.00" : (numFormater.format(profitPer * 100) + "%")%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		            	</font>
		            </td>
		          	<%}%>
		          	<td align="center" class="lblLight" bgcolor="#e9eee9">
		          		<font color=blue>
		          			<input type="text" size="12" name="allGrossProfit" id="allGrossProfit" value="<%=allTotalRev == 0 ? "0.00" : (numFormater.format(((allMargin - allCost) / allTotalRev) * 100) + "%")%>" readonly style="text-align:right;background-color:#e9eee9;border=0px">
		          		</font>
		          	</td>
      			</tr>
      			
      			<tr height="20">
      				<td bgcolor="#ffffff" width="1%">&nbsp;</td>
		            <td align="left" class="lblbold" bgcolor="#b0c4de" nowrap>IFO%</td>
		            <%
		            for(int i = 0; i < stList.size(); i++){
		            
						double ifoPer = 0;

						double[] totalRevenue = (double[]) valueList.get(4);
						double[] profit = (double[]) valueList.get(6);
		
						if (totalRevenue[i] != 0) {
							ifoPer = ((profit[i] - totalRevenue[i] * 0.15) * 0.925) / totalRevenue[i];
						}
		            %>
		            <td align="center" class="lblLight" bgcolor="#b0c4de">
			            <font color=blue>
			            	<input type="text" size="12" name="ifoPer2<%=i%>" id="ifoPer2<%=i%>" value="<%=ifoPer == 0 ? "0.00" : (numFormater.format(ifoPer * 100) + "%")%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
			            </font>
		            </td>
		          	<%}%>
		          	<td align="center" class="lblLight" bgcolor="#b0c4de">
			          	<font color=blue>
			          		<input type="text" size="12" name="allIfoPer2" id="allIfoPer2" value="<%=allTotalRev == 0 ? "0.00" : (numFormater.format((allIfo / allTotalRev) * 100) + "%")%>" readonly style="text-align:right;background-color:#b0c4de;border=0px">
			          	</font>
		          	</td>
      			</tr>

            </table>
            <br>
            <table width='100%' border='0'>
				<tr><td align="right">
					<input type="button" class="button" value="Save" onclick="fnSave()">
					<input type="button" class="button" value="Export to Excel" onclick="fnExport()">
					<input type="button" class="button" value="Close" onclick="onClose()">
				</td></tr>
			</table>
			<br>
		</form>
	</BODY>
</HTML>
<%	
	}else{
		out.println("!!你没有相关访问权限!!");
	}
}catch(Exception e){
	e.printStackTrace();
}
%>
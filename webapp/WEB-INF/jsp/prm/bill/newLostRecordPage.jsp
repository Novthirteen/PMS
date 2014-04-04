<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language="javascript">
function showBillingDialog() {
	with(document.newForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.billing.dialog.title&FindBillingInstruction.do?action=showDialog",
			null,
			'dialogWidth:750px;dialogHeight:500px;status:no;help:no;scroll:no');
			
		if (v != null && v != "") {
			var vv = v.split("$");
			document.getElementById("labelBillCode").innerHTML = vv[1];		
			document.getElementById("billId").value = vv[0];
			document.getElementById("labelProject").innerHTML = vv[2] + ":" + vv[3];
			document.getElementById("projectId").value = vv[2];
			document.getElementById("amount").value = vv[6];			
			if (vv[7] == "FP") {
				document.getElementById("labelContractType").innerHTML = "Fixed Price";
			} else {
				document.getElementById("labelContractType").innerHTML = "Time & Material";
			}
			document.getElementById("labelDepartment").innerHTML = vv[9];
			document.getElementById("labelProjectManager").innerHTML = vv[11];
		}
	}
}

function checkSubmit() {
	if (document.newForm.billId.value == "") {
		alert("Bill Code can not be ignored");
		return false;
	}
	
	if (document.newForm.amount.value == ""
		|| document.newForm.amount.value == "0.00") {
		alert("Amount Value can not be ignored or zero");
		
		return false;
	} else {
		removeComma(document.newForm.amount);
	}

	return true;
}

function onCurrSelect(){
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	
	with(document.newForm) {
		exchangeRate.value = RateArr[currency.selectedIndex];
		labelCurrencyRate.innerHTML=exchangeRate.value;
	}
}
</script>
<%
	ProjectBill pb = null;
	if (pi != null && pi.getBilling() != null) {
		pb = pi.getBilling();
	}
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	NumberFormat numFormat = NumberFormat.getInstance();
	numFormat.setMaximumFractionDigits(2);
	numFormat.setMinimumFractionDigits(2);
%>
<form name="newForm" action="editLost.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" id="formAction" value="new">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>Lost Record Maintenance</CAPTION>
		<tr>
			<td>
				<TABLE width="100%">
					<TR>
    					<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
            				Lost Record Detail
          				</TD>
  					</TR>
  					<%
  						if (request.getAttribute("ErrorMessage") != null) {
  					%>
  					<TR>
    					<TD align=left colspan="4" width='100%'>
            				<font color="red" size="4">
            					<%=(String)request.getAttribute("ErrorMessage")%>
            				</font>
          				</TD>
  					</TR>
  					<%
  						}
  					%>
					<tr>
						<td class="lblbold" align=right width="15%">Bill Code:</td>
						<td class="lblLight" width="35%">							
							<div style="display:inline" id="labelBillCode"><%=pb != null && pb.getBillCode() != null ? pb.getBillCode() : ""%></div>
							<input type="hidden" name="billId" id="billId" value="<%=pb != null && pb.getId() != null ? String.valueOf(pb.getId()) : ""%>">
							<a href="javascript:void(0)" onclick="showBillingDialog();event.returnValue=false;">
							<img align="absmiddle" alt="select" src="images/select.gif" border="0"/></a>
						</td>
					
						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject"><%=pi != null && pi.getProject().getProjName() != null ? pi.getProject().getProjName() : ""%></div>
							<input type="hidden" name="projectId" id="projectId" value="<%=pi != null && pi.getProject().getProjId() != null ? pi.getProject().getProjId() : ""%>">
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Contract Type:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelContractType">
							<%
								if (pi != null && pi.getProject() != null && pi.getProject().getContractType() != null) {
									if (pi.getProject().getContractType().equals("FP")) {
							%>
									Fixed Price
							<%
									} else {
							%>
									Time & Material
							<%
									}
								}
							%>
							</div>
						</td>
					
						<td class="lblbold" align=right width="15%">Department:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelDepartment">
							<%=pi != null && pi.getProject() != null ? pi.getProject().getDepartment().getDescription() : ""%>
							</div>
						</td>
					</tr>
					<tr>	
						<td class="lblbold" align=right width="15%">Project Manager:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProjectManager">
							<%=pi != null && pi.getProject() != null ? pi.getProject().getProjectManager().getName() : ""%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="15%">Amount:</td>
						<td class="lblLight" width="35%">
							<input type="text" name="amount" id="amount" size="30" value="<%=pi != null ? numFormat.format(pi.getAmount()) : ""%>" style="TEXT-ALIGN: right<%=request.getAttribute("ErrorMessage") != null ? ";background-color:#FFAFD3" : ""%>" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
						</td>
					</tr>

				      <tr>
				        <td align="right" class="lblbold">
				          <span class="tabletext">Currency:&nbsp;</span>
				        </td>
				        <td align="left">				       
				          <select name="currency" id="currency" onchange="javascript:onCurrSelect()">
						  <%				
						  	 
							  for (int i0 = 0; i0 < currencyList.size(); i0++) {
								CurrencyType curr = (CurrencyType)currencyList.get(i0);
								if(curr.getCurrId().equals("RMB")){
								 exchangeRate = curr.getCurrRate();
							%>	
								<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
							<%  }else{%>
								<option value="<%=curr.getCurrId()%>"><%=curr.getCurrName()%></option>
							<%  }%>
						  <%}%> 
						  </select>
						 
				        </td>
				        <td align="right" class="lblbold">
				          <span class="tabletext">Exchange Rate(RMB):&nbsp;</span>
				        </td>
						<td class="lblLight" width="35%">
							<div style="display:none" id="labelCurrencyRate"></div>	
							<input type="text" name="exchangeRate" id="exchangeRate" value="<%if(exchangeRate !=null) out.print(exchangeRate); %>">		
						</td>
				      </tr>
			
					<tr>
						<td class="lblbold" align=right width="15%">Create User:</td>
						<td class="lblLight" width="35%"></td>
						<td class="lblbold" align=right width="15%">Create Date:</td>
						<td class="lblLight" width="35%"></td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
							<textarea name="note" cols="130" rows="3"><%=pi != null && pi.getNote() != null ? pi.getNote() : ""%></textarea>							
						</td>
					</tr>
					<tr>
						<td colspan=4>
							<input type="submit" class="button" name="Save" value="Save">
							<input type="button" value="Back to List" name="Back" class="button" onclick="document.backForm.submit();">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
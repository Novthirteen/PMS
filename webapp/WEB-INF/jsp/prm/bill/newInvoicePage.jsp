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
			'dialogWidth:750px;dialogHeight:650px;status:no;help:no;scroll:no');
			
		if (v != null && v != "") {
			var vv = v.split("$");
			document.getElementById("labelBillCode").innerHTML = vv[1];		
			document.getElementById("billId").value = vv[0];
			document.getElementById("labelProject").innerHTML = vv[2] + ":" + vv[3];
			document.getElementById("projectId").value = vv[2];
			if (document.getElementById("billAddressId").value == "") {
				document.getElementById("labelBillAddress").innerHTML = vv[5];
				document.getElementById("billAddressId").value = vv[4];
			}
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

function showCustomerDialog()
{
	var code,desc;
	with(document.newForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.billto.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			document.getElementById("labelBillAddress").innerHTML = desc;			
			document.getElementById("billAddressId").value=code;
		}
	}
}

function checkSubmit() {
	if (document.newForm.invoiceCode.value == "") {
		alert("Invoice Code can not be ignored");
		return false;
	}
	
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
	
	if (document.newForm.invoiceDate.value == "") {
		alert("Invoice Date can not be ignored ");
		return false;
	} 

	return true;
}

function onCurrSelect(){
	
	var rateStr = "<%=rateStr%>";
	var RateArr = rateStr.split("$");
	
	with(document.newForm) {
		currencyRate.value = RateArr[currency.selectedIndex];
	}
	
}
</script>
<%
	ProjectBill pb = null;
	if (pi != null && pi.getBilling() != null) {
		pb = pi.getBilling();
	}
	if (pb == null) {
		pb = (ProjectBill)request.getAttribute("ProjectBill");
	}
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	NumberFormat numFormat = NumberFormat.getInstance();
	numFormat.setMaximumFractionDigits(2);
	numFormat.setMinimumFractionDigits(2);
	Float defaultCurrRate = null;
%>
<form name="newForm" action="editInvoice.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" value="new">
	<input type="hidden" name="process" value="maintenance">
	<input type="hidden" name="invoiceType" value="<%=Constants.INVOICE_TYPE_NORMAL%>">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>Invoice Maintenance</CAPTION>
		<tr>
			<td>
				<TABLE width="100%">
					<TR>
    					<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
            				Invoice Detail
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
						<td class="lblbold" align=right width="15%">Invoice Code:</td>
						<td class="lblLight" width="35%">
							<input type="text" name="invoiceCode" size="30" value="<%=(pi != null && pi.getInvoiceCode() != null) ? pi.getInvoiceCode() : ""%>" style="TEXT-ALIGN: left" class="lbllgiht">
						</td>
						<td class="lblbold" align=right width="15%">Bill Code:</td>
						<td class="lblLight" width="35%">							
							<div style="display:inline" id="labelBillCode"><%=pb != null && pb.getBillCode() != null ? pb.getBillCode() : ""%></div>
							<input type="hidden" name="billId" value="<%=pb != null && pb.getId() != null ? String.valueOf(pb.getId()) : ""%>">
							<a href="javascript:void(0)" onclick="showBillingDialog();event.returnValue=false;">
							<img align="absmiddle" alt="select" src="images/select.gif" border="0"/></a>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject">
								<%
									String projNm = "";
									String projId = "";
									String projContractType = "";
									String projDep = "";
									String projPM = "";
									String projBillAddr = "";
									String projBillAddrId = "";
									String amount = "";
									if (pi != null && pi.getProject() != null) {
										projNm = pi.getProject().getProjName();
										projId = pi.getProject().getProjId();
										projContractType = pi.getProject().getContractType();
										projDep = pi.getProject().getDepartment().getDescription();
										projPM = pi.getProject().getProjectManager().getName();
										amount = numFormat.format(pi.getAmount());
									} else {
										if (pb != null && pb.getProject() != null) {
											projNm = pb.getProject().getProjName();
											projId = pb.getProject().getProjId();
											projContractType = pb.getProject().getContractType();
											projDep = pb.getProject().getDepartment().getDescription();
											projPM = pb.getProject().getProjectManager().getName();
											amount = numFormat.format(pb.getRemainingAmount());
										}
									}
									
									if (pi != null && pi.getBillAddress() != null && pi.getBillAddress().getDescription() != null) {
										projBillAddr = pi.getBillAddress().getDescription();
										projBillAddrId = pi.getBillAddress().getPartyId();
									} else {
										if (pb != null && pb.getBillAddress() != null && pb.getBillAddress().getDescription() != null) {
											projBillAddr = pb.getBillAddress().getDescription();
											projBillAddrId = pb.getBillAddress().getPartyId();
										}
									}
								%>
								<%=projNm%>
							</div>
							<input type="hidden" name="projectId" value="<%=projId%>">
						</td>
						
						<td class="lblbold" align=right width="15%">Contract Type:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelContractType">
							<%
								if (projContractType != null) {
									if (projContractType.equals("FP")) {
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
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Department:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelDepartment">
							<%=projDep%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="15%">Project Manager:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProjectManager">
							<%=projPM%>
							</div>
						</td>
					</tr>
					<tr>						
						<td class="lblbold" align=right width="15%">Bill Address:</td>
						<td class="lblLight" width="35%">							
							<div style="display:inline" id="labelBillAddress">
							<%=projBillAddr%>
							</div>
							<input type="hidden" name="billAddressId" value="<%=projBillAddrId%>">		
							<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>					
						</td>
						
						<td class="lblbold" align=right width="15%">Amount:</td>
						<td class="lblLight" width="35%">
							<input type="text" name="amount" size="30" value="<%=amount%>" style="TEXT-ALIGN: right<%=request.getAttribute("ErrorMessage") != null ? ";background-color:#FFAFD3" : ""%>" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Currency:</td>
						<td class="lblLight" width="35%">
					          <select name="currency" onchange="javascript:onCurrSelect()">
							  <%						
				
							      CurrencyType defaultCurr = null;
								  for (int i0 = 0; i0 < currencyList.size(); i0++) {
									CurrencyType curr = (CurrencyType)currencyList.get(i0);
									if(pi!= null && pi.getCurrency() != null && curr.getCurrId().equals(pi.getCurrency().getCurrId())){
									defaultCurrRate = pi.getCurrency().getCurrRate();
								%>
									<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
								<%  }else if(pi== null && curr.getCurrId().equals("RMB")){
									defaultCurrRate = curr.getCurrRate();
								%>	
									<option value="<%=curr.getCurrId()%>" selected><%=curr.getCurrName()%></option>
												
								<%  }else{%>
									<option value="<%=curr.getCurrId()%>"><%=curr.getCurrName()%></option>
								<%}}%>
							  </select>

						</td>
						<td class="lblbold" align=right width="15%">Exchange Rate(RMB):</td>
						<td class="lblLight" width="35%">	
							<input type="text" name="currencyRate" size="30" value="<%if(defaultCurrRate != null) out.print(defaultCurrRate.floatValue());%>" style="TEXT-ALIGN: right" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Exchange Rate',-99999,99999)">
						</td>
					</tr>
					<tr>						
						<td class="lblbold" align=right width="15%">Invoice Date:</td>
						<td class="lblLight" width="35%">							
							<input  type="text" name="invoiceDate" size="12" value="<%=dateFormat.format(new Date())%>">
							<A href="javascript:ShowCalendar(document.newForm.dimg1,document.newForm.invoiceDate,null,0,330)" onclick=event.cancelBubble=true;>
								<IMG align=absMiddle border=0 id=dimg1 src="<%=request.getContextPath()%>/images/datebtn.gif" >
							</A>					
						</td>
						
						<td class="lblbold" align=right width="15%">EMS No/Contactor:</td>
						<td class="lblLight" width="35%"></td>
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
							<input type="submit" class="button" name="Save" value="Continue >>">
							<input type="button" value="Back to List" name="Back" class="button" onclick="document.backForm.submit();">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
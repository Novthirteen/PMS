<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>

<%

	String formAction = request.getParameter("formAction");
	ProjectPayment pp = (ProjectPayment)request.getAttribute("ProjectPayment");
	if(pp == null) pp = new ProjectPayment();
	
	String payCode = request.getParameter("payCode");
	String project = request.getParameter("project");
	String vendor = request.getParameter("vendor");
	String department = request.getParameter("department");
	String status = request.getParameter("status");

	if (payCode == null) {
		payCode = "";
	}
	if (project == null) {
		project = "";
	}
	if (vendor == null) {
		vendor = "";
	}
	if (department == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			department = userLogin.getParty().getPartyId();
		}
	}
	if (status == null) {
		status = "";
	}

%>
<script language="javascript">


function showDetail(payId, payType) {
		if (payType == "<%=Constants.PAYMENT_TYPE_NORMAL%>") {
			v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payment.dialog.title&EditPaymentInstruction.do?action=dialogView&payId=" + payId,
				null,
			'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
		} else {
			v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payment.dialog.title&EditPaymentInstruction.do?formAction=dialogView&payId=" + payId,
				null,
			'dialogWidth:600px;dialogHeight:400px;status:no;help:no;scroll:auto');
		}
	}
function showVendorDialog()
{
	var code,desc;
	with(document.editForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payto.dialog.title&crm.dialogVendorList.do",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelPayAddress.innerHTML=desc;			
			payAddr.value=code;
		}
	}
}

function checkSubmit() {
	if (document.updateForm.amount.value == ""
		|| document.updateForm.amount.value == "0.00") {
		alert("Amount Value can not be ignored or zero");
		
		return false;
	} else {
		removeComma(document.updateForm.amount);
	}
	
	if (document.updateForm.invoiceDate.value == "") {
		alert("Invoice Date can not be ignored");
		return false;
	}
	
	return true;
}

function onCurrSelect(){
	document.getElementById("currencyRate").value = document.currency.options[document.currency.selectedIndex].value;
}

function doDelete() {
	if (confirm("Are you sure to delete this payment instrcution ?")) {
		document.delForm.submit();
	}
}

function doConfirm(){
	//alert("document.form1.payCode.value="+document.form1.payCode.value);
	if(document.form1.payCode.value==""){
	alert("Please select a supplier invoice first");
	return false;
	}
	else{
	removeComma(document.updateForm.amount);
	removeComma(document.form1.payAmount);
	}
	if(parseFloat(document.updateForm.amount.value) > <%=pp.getCalAmount()%> || parseFloat(document.updateForm.amount.value) > parseFloat(document.updateForm.remainAmount.value)){
		alert("Settlement Amount Invalid");
		return false;
	}
	else{
	document.form1.amount.value = document.updateForm.amount.value;
	document.form1.formAction.value='confirm';
	document.form1.submit();
	}
}


function showCostMaster(pcmId) {
		var param = "invoiceId=" + "<%=pp.getId()%>" + "&formAction=createCM";
		if (pcmId != null) {
			param = "pcmId=" + pcmId + "&formAction=editCM";
		}
		v = window.showModalDialog(
		"system.showDialog.do?title=prm.projectInvoice.addreceipt.dialog.title&settleSupplierInvoice.do?" + param,
			null,
		'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
		
		document.updateForm.formAction.value = "view";
		document.updateForm.submit();
		//document.pcmForm.submit();
}
	
function doDeleteCostMaster(code) {
	if (confirm("Do you really want to cancel this?")) {
		document.pcmForm.pcmId.value = code;
		document.pcmForm.formAction.value = "delete";
		document.pcmForm.submit();
		}
}

function showSI(dataId){
	var param = "DataId=" + dataId + "&FormAction=dialogView";
	v = window.showModalDialog(
		"system.showDialog.do?title=prm.projectInvoice.addreceipt.dialog.title&editSupplierInvoice.do?" + param,
			null,
		'dialogWidth:800px;dialogHeight:600px;status:no;help:no;scroll:auto');
	
}
</script>
<%

	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	
	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);	
	
	boolean canUpdate = true;
	if (pp != null && pp.getStatus()!= null){
		if (pp.getStatus().equals(Constants.PAYMENT_STATUS_COMPLETED) || "dialogView".equals(formAction)) {
			canUpdate = false;
		}
	}
	request.getSession().setAttribute("VendorIdForInvoice",pp.getPayAddress().getPartyId());
	com.aof.component.prm.payment.ProjectPaymentMaster ppm = (ProjectPaymentMaster)request.getAttribute("ProjectPaymentMaster");
	if(ppm == null) ppm = new ProjectPaymentMaster(); 

%>

<form name="form1" action="editPaymentInvoice.do" method="post">
	<input type="hidden" name="formAction" value="">
	
	<input type="hidden" name="invoice" id="invoice" value="<%=Invoice%>">
	<input type="hidden" name="project" id="project" value="<%=Project%>">
	<input type="hidden" name="payAddress" id="payAddress" value="<%=PayAddress%>">
	<input type="hidden" name="status" id="status" value="<%=Status%>">
	<input type="hidden" name="department" id="department" value="<%=Department%>">
	<!-- invoiceId getCostcode -->
	<input type="hidden" name="payAmount" id="payAmount" value="">
	<!-- payCode getRefno -->
	<input type="hidden" name="amount" id="amount" value="">
</form>
<form name="updateForm" action="editPaymentInvoice.do" method="post" onsubmit="return checkSubmit();">

	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="payAmount" id="payAmount" value="">
    <input type="hidden" name="payId" id="payId" value="<%=pp.getId()%>">
	<input type="hidden" name="remainAmount" id="remainAmount"  value="">
	<input type="hidden" name="formAction" id="formAction" value="update">
	<!-- invoiceId getCostcode -->
	<input type="hidden" name="confirmId" id="confirmId" value="">
	<input type="hidden" name="invoiceType" id="invoiceType" value="<%=Constants.PAYMENT_INVOICE_TYPE_NORMAL%>">
	<!-- payCode getRefno -->
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<%
			if ("dialogView".equals(formAction)) {
		%>
			<CAPTION align=center class=pgheadsmall>
			Payment 
			</CAPTION>
		<%
			}
		%>

		<CAPTION align=center class=pgheadsmall>Payment Maintenance</CAPTION>

		<tr>
			<td>
				<TABLE width="100%">
					<TR>
    					<TD align=left colspan="4" class="wpsPortletTopTitle">
            				Payment Detail
          				</TD>
  					</TR>
  					<%
  						if (request.getAttribute("ErrorMessage") != null) {
  					%>
  					<TR>
    					<TD align=left colspan="4">
            				<font color="red" size="4">
            					<%=(String)request.getAttribute("ErrorMessage")%>
            				</font>
          				</TD>
  					</TR>
  					<%
  						}
  					%>
					<tr>
					  <td class="lblbold" align=right>Payment Code:</td>
					  <td class="lblLight"><a href="#" onclick="showDetail('<%=pp.getId()%>', '<%=pp.getType()%>');"><%=pp.getPaymentCode()%></a> </td>
						<td class="lblbold" align=right>Status:</td>
						<td class="lblLight"><%=pp.getStatus() == null ? "Draft" : pp.getStatus()%></td>
						<input type="hidden" name="invoiceCode" id="invoiceCode" value="<%=pp.getPaymentCode()%>">
					</tr>
					<tr>
						<td class="lblbold" align=right width="16%">Project:</td>
						<td class="lblLight" width="30%">
							<div style="display:inline" id="labelProject">
								<%=pp.getProject() != null ?pp.getProject().getProjId():""%>:<%=pp.getProject() != null ? pp.getProject().getProjName() : ""%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="21%">Contract Type:</td>
						<td class="lblLight" width="33%">
							<div style="display:inline" id="labelContractType">
								<%
									String contractType = (pp.getProject() == null)?"":pp.getProject().getContractType();
									if ( contractType!=null && contractType.equals("FP")) {
								%>
									Fixed Price
								<%
									} else if(contractType!=null){
								%>
									Time & Material
								<%
									}
								%>
							</div>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="16%">Department:</td>
						<td class="lblLight" width="30%">
							<div style="display:inline" id="labelDepartment">
								<%=pp.getProject() == null?"":pp.getProject().getDepartment().getDescription()%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="21%">Project Manager:</td>
						<td class="lblLight" width="33%">
							<div style="display:inline" id="labelProjectManager">
								<%=pp.getProject() == null?"":pp.getProject().getProjectManager().getName()%>
							</div>
						</td>
					</tr>
					<tr>				
						<td class="lblbold" align=right width="16%">Pay To:</td>
						<td class="lblLight" width="30%">							
							<div style="display:inline" id="labelPayAddress">
								<%=pp.getPayAddress() != null ? pp.getPayAddress().getDescription() : ""%>
							</div>
							<input type="hidden" name="payAddressId" id="payAddressId" value="<%=pp.getPayAddress() == null?"":pp.getPayAddress().getPartyId()%>">	
							<%
								if (canUpdate) {
							%>
							<a href="javascript:void(0)" onclick="showVendorDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
							<%
								}
							%>
						</td>
						
						<td class="lblbold" align=right width="21%">Amount:</td>
						<td class="lblLight" width="33%">
							<%
								if (canUpdate) {
							%>
							<input type="text" name="amount" size="30" value="<%=UtilFormat.format(pp.getCalAmount())%>" style="TEXT-ALIGN: right<%=request.getAttribute("ErrorMessage") != null ? ";background-color:#FFAFD3" : ""%>" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Amount Value',-9999999999,9999999999);addComma(this, '.', '.', ',');">
							<%
								} else {
							%>
							<%=UtilFormat.format(pp.getCalAmount())%>
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="16%">Currency:</td>
						<td class="lblLight" width="30%">
							<%
								if (canUpdate) {
							%>
							<select name="currency" onchange="javascript:onCurrSelect()">
								<%									
									for (int i0 = 0; i0 < currencyList.size(); i0++) {
										CurrencyType curr = (CurrencyType)currencyList.get(i0);
										String isSelected = "";
										
								%>
										<option value="<%=curr.getCurrId()%>" <%=isSelected%>><%=curr.getCurrName()%></option>
								<%
									}
								%>
							</select>
							<%
								} else {
							%>
							<%=new String("RMB")%>
							<%
								}
							%>
						</td>
						<td class="lblbold" align=right width="21%">Exchange Rate(RMB):</td>
						<td class="lblLight" width="33%">	
							<%
								if (canUpdate) {
							%>						
							<input type="text" readonly name="currencyRate" id="currencyRate" size="30" value="1.0" style="TEXT-ALIGN: right" class="lbllgiht" onblur="checkDeciNumber2(this,1,1,'Exchange Rate',-99999,99999)">			
							<%
								} else {
							%>
							<%=new String("1.0")%>
							<%
								}
							%>
						</td>
					</tr>					
					<tr>
						<td class="lblbold" align=right width="16%">Create User:</td>
						<td class="lblLight" width="30%">
							<%=pp.getCreateUser()== null ? "" : pp.getCreateUser().getName()%>
						</td>
						<td class="lblbold" align=right width="21%">Create Date:</td>
						<td class="lblLight" width="33%">							
							<%=pp.getCreateDate()== null ? "" :  dateFormat.format(pp.getCreateDate())%>			
						</td>
					</tr>
					<tr>
						<td/>
						<td/>
						<td class="lblbold" align=right width="16%">Remaining Amount:</td>
						<td class="lblLight" width="30%">
							<%=UtilFormat.format(pp.getRemainingAmount(pp.getId()))%>
						</td>
					</tr>
					
					<tr>
						<td height="48" colspan=4>
						    <div align="left">
						        <%
								if ("dialogView".equals(formAction)) {
							%>
						        <input type="button" class="button" name="Close" value="Close" onclick="window.parent.close();">
						        <%
								} else {
							%>
						        <%
									if (canUpdate &&  (request.getAttribute("ErrorMessage") == null) ) {
									}
								}
							%>
					            <input type="button" value="Back to List" name="Back" class="button" onclick="document.back1Form.submit();">
				            </div></td>
					</tr>
										
				</table>
			</td>
		</tr>
	</table>
</form>
<form name="back1Form" action="FindPaymentInstruction.do" method="post">
	<input type="hidden" name="action" id="action" value="query">
	<input type="hidden" name="payCode" id="payCode" value="<%=payCode%>">
	<input type="hidden" name="project" id="project" value="<%=project%>">
	<input type="hidden" name="vendor" id="vendor" value="<%=vendor%>">
	<input type="hidden" name="department" id="department" value="<%=department%>">
	<input type="hidden" name="status" id="status" value="<%=status%>">
</form>

<form name="pcmForm" action="editPaymentInvoice.do">
<input type="hidden" name="pcmId" id="pcmId">
<input type="hidden" name="formAction" id="formAction">
<input type="hidden" name="payId" id="action" value="<%=pp.getId()%>">
<table width="987">
<TR>
	<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
		Settlement Details:</TD>
</TR>
<tr>
	<td colspan="4">
		<TABLE border=0 width='100%' cellspacing='2' cellpadding='2' class=''>
			<tr bgcolor="#e9eee9">
				<td align="center" class="lblbold">#&nbsp;</td>
			  	<td align="center" class="lblbold">Payment Code</td>
			  	<td align="center" class="lblbold">Supplier Invoice Code</td>
			  	<td align="center" class="lblbold">Payment Amount</td>
			    <td align="center" class="lblbold">Currency</td>
			    <td align="center" class="lblbold">Exchange Rate</td>
			    <td align="center" class="lblbold">Create Date</td>
                <td align="center" class="lblbold"></td>
			 <%
				if (true || "receipt".equals(request.getParameter("process"))) {
			 %>
			    <td bgcolor="#FFFFFF" class="lblbold">&nbsp;</td>
			 <%
			 	}
			 %>
		  </tr>				 		 
			 <%
			 	if (pp.getInvoices() != null) {
			 		Iterator iterator = pp.getInvoices().iterator();
			 		int count = 1;
			 		while(iterator.hasNext()) {
			 			ProjectCostMaster pcm = (ProjectCostMaster)iterator.next();
			 			if(!pcm.getPayStatus().equalsIgnoreCase(Constants.INVOICE_STATUS_CANCELED)){
			 %>
			 <TR bgcolor="#e9eee9">
			 	<td align="right"><%=count++%></td>
		    	<td align="right"> 
					<%=pp.getPaymentCode()%>
		    	</td>
		    	<td align="right"> 
					<a href=# onClick="showSI('<%=pcm.getRefno()%>');"><%=pcm.getRefno()%></a>
		    	</td>
		    	<td align="right"> 
					<%=numFormater.format(pcm.getTotalvalue())%>
		    	</td>
		    	<td align="right"> 
					<%=pcm.getCurrency() != null ? pcm.getCurrency().getCurrName() : ""%>
		    	</td>
		    	<td align="right"> 
					<%=UtilFormat.format(pcm.getExchangerate()) %>
		    	</td>
		    	<td align="right"> 
					<%=pcm.getCreatedate()!=null?UtilFormat.format(pcm.getCreatedate()):""%>
		    	</td>
		   	 <%
				if (true || "receipt".equals(request.getParameter("process"))) {
			 %>
		    	<td align="center"> 
					<a href="#" onclick="showCostMaster('<%=pcm.getCostcode()%>');">Edit</a>
					&nbsp;
					<a href="#" onclick="doDeleteCostMaster('<%=pcm.getCostcode()%>');">Cancel</a>
		    	</td>
		     <%
		     	}
		     %>
		     </tr>
			 <%
			 		}
			 	  } 	
			 	}
			 %>
			 <%
			 	if (true || (AOFSECURITY.hasEntityPermission("PROJ_RECEIPT", "_CREATE", session)
			 	&& "receipt".equals(request.getParameter("process")))) {
			 %>
			 <tr>
				<td colspan="10" align="left">
					<input type="button" value="Add Supplier Invoice" name="add" class="button" 	onclick="showCostMaster()">
				</td>
			</tr>
			<%
				}
			%>
		</table>
	</td>
</tr>
</table>
</form>
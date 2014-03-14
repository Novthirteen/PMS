<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/projectSelect.js'></script>
<script language="javascript">
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
</script>
<%
try {
String action = request.getParameter("action");
boolean canUpdate = true;
if ((action != null && action.equals("dialogView"))
    || pp.isFreezed()) {
	canUpdate = false;
}
	
String category = request.getParameter("category");
if (category == null) category = Constants.TRANSACATION_CATEGORY_CAF;

NumberFormat numFormater = NumberFormat.getInstance();
numFormater.setMaximumFractionDigits(2);
numFormater.setMinimumFractionDigits(2);	

DateFormat dateFormater = new SimpleDateFormat("yyyy/MM/dd");
request.getSession().setAttribute("VendorIdForInvoice",pp.getPayAddress().getPartyId());
request.getSession().setAttribute("poProjId",pp.getProject().getProjId());
%>
<script language="javascript">
	function post(){
		document.editForm.action.value="post";
		document.editForm.submit();
	}
	function removeSupplierInv(){
		document.deleteSuppInvForm.action.value="removeSupInv";
		document.deleteSuppInvForm.submit();
	}
	function doAddInv(){
		var param = "paymentId=" + "<%=pp.getId()%>" + "&formAction=view";
		v = window.showModalDialog(
		"system.showDialog.do?title=prm.projectPayment.settleSupplierInvoice.dialog.title&settleSupplierInvoice.do?" + param,
			null,
		'dialogWidth:800px;dialogHeight:400px;status:no;help:no;scroll:auto');
		if(v==null||v!="justView"){
			document.editForm.action.value = "view";
			document.editForm.submit();
		}
	}
	function doDelete() {
		if (confirm("Are you sure to delete this payment instrcution ?")) {
			document.delForm.submit();
		}
	}
	
	function doAdd() {
		document.editForm.action.value = "addTransaction";
		document.editForm.submit();
	}
	
	function doRemove() {
		document.editForm.action.value = "removeTransaction";
		document.editForm.submit();
	}

	function changeCategory(category) {
		document.editForm.action.value = "<%= action != null && action.equals("dialogView") ? "dialogView" : "view"%>";
		document.editForm.category.value = category;
		document.editForm.submit();
	}
	function showExpDetail(em_id) {
		var windowprops	= "width=950,height=390,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,location=no,scrollbars=yes,status=no,menubars=no,toolbars=no,resizable=no";
		var url = "editExpense.do?FormAction=showArAndApDetail&DataId="+em_id;
		window.open(url, "showExp", windowprops);
	}
	function ExportExcel() {
		document.rptForm.submit();
	}
	function ClosePay() {
		
		document.editForm.action.value = "close";
		document.editForm.submit();
	}
	function removeSupplierInv(tran){
		with(document.deleteSuppInvForm){
			action.value = "removeSupplierInvoice";
			paymentId.value = tran;
			submit();
	}
}
</script>
<%
	if (canUpdate) {
%>
<form name="delForm" action="EditPaymentInstruction.do" method="post">
	<input type="hidden" name="action" value="delete">
	<input type="hidden" name="payId" value="<%=pp.getId()%>">
	<input type="hidden" name="payCode" value="<%=payCode%>">
	<input type="hidden" name="project" value="<%=project%>">
	<input type="hidden" name="vendor" value="<%=vendor%>">
	<input type="hidden" name="department" value="<%=department%>">
	<input type="hidden" name="status" value="<%=status%>">
</form>
<%	
	}
%>
<form name="rptForm" action="EditPaymentInstruction.do" method="post">
	<input type="hidden" name="action" value="ExportToExcel">
	<input type="hidden" name="payId" value="<%=pp.getId()%>">
</form>
<form name="deleteSuppInvForm" action="EditPaymentInstruction.do" method="post">
	<input type="hidden" name="paymentId" value="">
	<input type="hidden" name="action" value="">
	<input type="hidden" name="payId" value="<%=pp.getId()%>">
	<input type="hidden" name="category" value="<%=category%>">
</form>
<form name="editForm" action="EditPaymentInstruction.do" method="post">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="action" value="updateHead">
	<input type="hidden" name="category" value="<%=category%>">
	<input type="hidden" name="payId" value="<%=pp.getId()%>">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>
			<%
				if (canUpdate && !"dialogView".equals(action)) {
			%>
			Payment Instruction Maintenance
			<%
				} else {
			%>
			Payment Instruction
			<%
				}
			%>
		</CAPTION>
		<tr>
			<td>
				<TABLE width="100%">
					<TR>
    					<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
            				Payment Instruction Head
          				</TD>
  					</TR>
					<tr>
						<td class="lblbold" align=right width="15%">Payment Code:</td>
						<td class="lblLight" width="35%">
							<%=pp.getPaymentCode()%>
						</td>
						
						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject">
								<%=pp.getProject().getProjId()%>:<%=pp.getProject().getProjName() != null ? pp.getProject().getProjName() : ""%>
							</div>
						</td>
					</TR>
					<tr>
						<td class="lblbold" align=right width="15%">Contract Type:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelContractType">
								<%
									String contractType = pp.getProject().getContractType();
									if (contractType.equals("FP")) {
										out.println("Fixed Price");
									} else {
										out.println("Time & Material");
									}
								%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="15%">Department:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelDepartment">
								<%=pp.getProject().getDepartment().getDescription()%>
							</div>							
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Project Manager:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelPM">
								<%=pp.getProject().getProjectManager().getName()%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="15%">Payment Address:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelPayAddress">
								<%=pp.getPayAddress().getDescription() != null ? pp.getPayAddress().getDescription() : ""%>
							</div>
							<%
								if (canUpdate) {
							%>
							<input type=hidden name="payAddr" value="<%=pp.getPayAddress().getPartyId()%>">
							<a href="javascript:void(0)" onclick="showVendorDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Total Amount:</td>
						<td class="lblLight" width="35%">
							<%=numFormater.format(pp.getCalAmount() != null ? pp.getCalAmount().doubleValue() : 0D)%>
						</td>
						
						<td class="lblbold" align=right width="15%">Currency:</td>
						<td class="lblLight" width="35%">RMB</td>					
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Create Date:</td>
						<td class="lblLight" width="35%">
							<%=dateFormater.format(pp.getCreateDate())%>
						</td>
						<td class="lblbold" align=right width="15%">Create User:</td>
						<td class="lblLight" width="35%">
							<%=pp.getCreateUser().getName()%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Offset Remaining Amount:</td>
						
						<td name ="RemainAmt" class="lblLight" width="35%">
							<%=numFormater.format(pp.getCalAmount().doubleValue()-pp.getSettledAmount().doubleValue())%>
						</td>
						<td class="lblbold" align=right width="15%">Status:</td>
						<td class="lblLight" width="35%">
							<%=pp.getStatus()%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
						<%
							if (canUpdate) {
						%>
							<textarea name="note" cols="130" rows="3"><%=pp.getNote() != null ? pp.getNote() : ""%></textarea>	
						<%
							} else {
						%>
							<%=pp.getNote() != null ? pp.getNote() : ""%>
						<%
							}
						%>
						</td>
					</tr>
					<tr>
						<td colspan=4>
						<%
							if (canUpdate) {
						%>
							<input type="submit" class="button" name="save" value="Save">
						<%
								if (pp.getSettleRecords() == null || pp.getSettleRecords().size() == 0) {
						%>
							<input type="button" class="button" name="delete" value="Delete" onclick="doDelete();">
						<%
								}
							}
						%>
						<%
							if (!"dialogView".equals(action)) {
						%>
						<input type="button" value="Back to List" name="Back" class="button" onclick="document.backForm.submit();">
						<%
							}
						%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<table width=100%>
		<tr>
			<td>
				<hr color=red></hr>
			</td>
		</tr>
	</table>
	<table width="100%">
		<TR>
			<TD align=left colspan="10" width='100%' class="wpsPortletTopTitle">
			Supplier Invoice Mapping List
			</TD>
		</TR>
			<%@ include file="paymentSupplierInvPage.jsp" %>
		<tr>
			<TD align="left" colspan="10">
				<%if(!pp.getStatus().equals("Completed")){%>
					<input type="button" class="button" name="addInv" value="Add Supplier Invoice" onclick="doAddInv();">&nbsp;
				<%}%>
				<input type="button" value="Post Selected To FA" name="PostToFA" class="button" onclick="post();">&nbsp;
				<%
					if (!canUpdate){
				%>
						<input type="button" value="Payment Excel Form" name="Print" class="button" onclick="javascript:ExportExcel()">
				<%
					}
				%>
			</TD>
		</tr>
  	</table>
	<table width=100%>
		<tr>
			<td>
				<hr color=red></hr>
			</td>
		</tr>
	</table>
			
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<tr>
			<td>
				<TABLE width="100%">
  					<TR>
    					<TD>
    						<table width="100%">
    							<TR>
    								<TD>
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							<nobr>
		    							<%
			    							if (Constants.TRANSACATION_CATEGORY_CAF.equals(category)) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">CAF</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="changeCategory('<%=Constants.TRANSACATION_CATEGORY_CAF%>');"><font size="2px">CAF</font></a>
			    						<%
			    							}
			    						%>
			    						<%
			    							if (pp.getCAFDetails() == null) {
			    						%>
			    							<font color="red" size="1px">(0)</font>
			    						<%
			    							} else {
			    								System.out.println("CAF Amount:"+pp.getCAFAmount());
												out.println("<font size='1px'>(" + numFormater.format(pp.getCAFAmount()) + ")</font>");
			    							}
			    						%>
		    							</nobr>
		    							
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							<nobr>
		    							<%
			    							if (Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE.equals(category)) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">Acceptance</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="changeCategory('<%=Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE%>');"><font size="2px">Acceptance</font></a>
			    						<%
			    							}
			    						%>
			    						<%
			    							if (pp.getPaymentDetails() == null) {
			    						%>
			    							<font color="red" size="1px">(0)</font>
			    						<%
			    							} else {
			    								System.out.println("Acceptance Amount:"+numFormater.format(pp.getPaymentAmount()));
												out.println("<font size='1px'>(" + numFormater.format(pp.getPaymentAmount()) + ")</font>");
			    							}
			    						%>
		    							</nobr>
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							<nobr>
		    							<%
			    							if (Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT.equals(category)) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">Credit-Down-Payment</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="changeCategory('<%=Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT%>');"><font size="2px">Credit-Down-Payment</font></a>
			    						<%
			    							}
			    						%>
			    						<%
			    							if (pp.getCreditDownPaymentDetails() == null) {
			    						%>
			    							<font color="red" size="1px">(0)</font>
			    						<%
			    							} else {
												out.println("<font size='1px'>(" + numFormater.format(pp.getCreditDownPaymentAmount()) + ")</font>");
			    							}
			    						%>
		    							</nobr>
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    						</TD>
  								</TR>
  							</Table>
          				</TD>
  					</TR>
  					
  					<TR>
			    		<TD>
				    		<table width="100%">
	    						<TR>
	    							<TD align=left colspan="12" width='100%' class="wpsPortletTopTitle">
			            			Payment Instruction Detail
			            			</TD>
  								</TR>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_CAF.equals(category)) {
  								%>
  									<%@ include file="CAFPaymentInstructionListPage.jsp" %>
  								<%
  									}
  								%>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE.equals(category)) {
  								%>
  									<%@ include file="AcceptancePaymentInstructionListPage.jsp" %>
  								<%
  									}
  								%>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT.equals(category)) {
  								%>
  									<%@ include file="CreditDownPaymentInstructionListPage.jsp" %>
  								<%
  									}
  								%>
  								<%
  									if (canUpdate) {
										//if (pp.getInvoices() == null) {
								%>
  								<tr>
									<TD align="left" colspan="12">
										<input type="button" class="button" name="remove" value="remove from payment list" onclick="doRemove();">
									</TD>
								</tr>
								<%
										//}
									}
								%>
								<tr>
									<TD align="left" colspan="12">
										<%
											if ("dialogView".equals(action)) {
										%>
											<input type="button" class="button" name="close" value="close" onclick="self.close();">
										<%
											}
										%>
									</TD>
								</tr>
								<%
									if (canUpdate) {
								%>
								<TR>
	    							<TD align=left colspan="12" width='100%'class="wpsPortletTopTitle">
			            			Pending Payment List
			            			</TD>
  								</TR>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_CAF.equals(category)) {
  								%>
  									<%@ include file="CAFPaymentPendingListPage.jsp" %>
  								<%
  									}
  								%>

  								<%
  									if (Constants.TRANSACATION_CATEGORY_EXPENSE.equals(category)) {
  								%>
  									<%@ include file="ExpensePaymentPendingListPage.jsp" %>
  								<%
  									}
  								%>

  								<%
  									if (Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE.equals(category)) {
  								%>
  									<%@ include file="AcceptancePaymentPendingListPage.jsp" %>
  								<%
  									}
  								%>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT.equals(category)) {
  								%>
  									<%@ include file="CreditDownPaymentPendingListPage.jsp" %>
  								<%
  									}
  								%>
  								<%
									if (canUpdate) {
								%>
  								<tr>
									<TD align="left" colspan="12">
										<input type="button" class="button" name="add" value="add to payment list" onclick="doAdd();">
									</TD>
								</tr>
								<%
									}
								%>
								<%
									}
								%>
  							</Table>
			          	</TD>
			  		</TR>
  				</TABLE>
  			</td>
  		</tr>
  		
  		
  	</table>	
</form>
<%
	} catch(Exception e) {
		e.printStackTrace();
	}
%>
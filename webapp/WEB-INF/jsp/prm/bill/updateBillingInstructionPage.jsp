<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/projectSelect.js'></script>
<script language="javascript">
function showCustomerDialog()
{
	var code,desc;
	with(document.editForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectInvoice.billto.dialog.title&crm.dialogCustomerList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelBillAddress.innerHTML=desc;			
			billAddr.value=code;
		}
	}
}
</script>
<%
try {
String action = request.getParameter("action");
boolean canUpdate = true;
if ((action != null && action.equals("dialogView"))
    || pb.isFreezed()) {
	canUpdate = false;
}
	
String category = request.getParameter("category");
if (category == null) category = Constants.TRANSACATION_CATEGORY_CAF;

NumberFormat numFormater = NumberFormat.getInstance();
numFormater.setMaximumFractionDigits(2);
numFormater.setMinimumFractionDigits(2);	

DateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
%>
<script language="javascript">
	function doDelete() {
	if (confirm("Do you want to delete?")) {
		document.delForm.submit();
	}
	}
	
	function doAdd() {
		document.editForm.action.value = "add";
		document.editForm.submit();
	}
	
	function doRemove() {
	if (confirm("Do you want to remove?")) {
		document.editForm.action.value = "remove";
		document.editForm.submit();
		}
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
	function showOtherCostDetail(em_id) {
		var windowprops	= "width=950,height=390,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,location=no,scrollbars=yes,status=no,menubars=no,toolbars=no,resizable=no";
		var url = "projectCostMaintain.do?FormAction=showArAndApDetail&DataId="+em_id;
		window.open(url, "showExp", windowprops);
	}
	function ExportExcel() {
		document.rptForm.submit();
	}
	function CloseBilling() {
		//alert(document.editForm.action.value);
		document.editForm.action.value = "close";
		//alert(document.editForm.action.value);
		document.editForm.submit();
	}
</script>
<%
	if (!"dialogView".equals(action) && !pb.getStatus().equals("Closed")) {
%>
<form name="createInvoiceForm" id="createInvoiceForm" action="editInvoice.do" method="post">
	<input type="hidden" name="formAction" value="view">
	<input type="hidden" name="process" value="maintenance">
	<input type="hidden" name="billId" value="<%=pb.getId()%>">
</form>
<%
	}
%>
<%
	if (canUpdate) {
%>
<form name="delForm" action="EditBillingInstruction.do" method="post">
	<input type="hidden" name="action" value="delete">
	<input type="hidden" name="billId" value="<%=pb.getId()%>">
	<input type="hidden" name="billCode" value="<%=billCode%>">
	<input type="hidden" name="project" value="<%=project%>">
	<input type="hidden" name="customer" value="<%=customer%>">
	<input type="hidden" name="department" value="<%=department%>">
	<input type="hidden" name="status" value="<%=status%>">
</form>
<%	
	}
%>
<form name="rptForm" action="pas.report.Billingprint.do" method="post">
	<input type="hidden" name="action" value="ExportToExcel">
	<input type="hidden" name="billId" value="<%=pb.getId()%>">
	<input type="hidden" name="category" value="<%=category%>">
</form>
<form name="editForm" action="EditBillingInstruction.do" method="post">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="action" value="updateHead">
	<input type="hidden" name="category" value="<%=category%>">
	<input type="hidden" name="billId" value="<%=pb.getId()%>">
	
	<table width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>
			<%
				if (canUpdate && !"dialogView".equals(action)) {
			%>
			Billing Instruction Maintenance
			<%
				} else {
			%>
			Billing Instruction
			<%
				}
			%>
		</CAPTION>
		<tr>
			<td>
				<TABLE width="100%">
					<TR>
    					<TD align=left colspan="4" width='100%' class="wpsPortletTopTitle">
            				Billing Instruction Head
          				</TD>
  					</TR>
					<tr>
						<td class="lblbold" align=right width="15%">Bill Code:</td>
						<td class="lblLight" width="35%">
							<%=pb.getBillCode()%>
						</td>
						
						<td class="lblbold" align=right width="15%">Project:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelProject">
								<%=pb.getProject().getProjId()%>:<%=pb.getProject().getProjName() != null ? pb.getProject().getProjName() : ""%>
							</div>
						</td>
					</TR>
					<tr>
						<td class="lblbold" align=right width="15%">Contract Type:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelContractType">
								<%
									String contractType = pb.getProject().getContractType();
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
								<%=pb.getProject().getDepartment().getDescription()%>
							</div>							
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Project Manager:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelPM">
								<%=pb.getProject().getProjectManager().getName()%>
							</div>
						</td>
						
						<td class="lblbold" align=right width="15%">Bill Address:</td>
						<td class="lblLight" width="35%">
							<div style="display:inline" id="labelBillAddress">
								<%=pb.getBillAddress().getDescription() != null ? pb.getBillAddress().getDescription() : ""%>
							</div>
							<%
								if (canUpdate) {
							%>
							<input type=hidden name="billAddr" value="<%=pb.getBillAddress().getPartyId()%>">
							<a href="javascript:void(0)" onclick="showCustomerDialog();event.returnValue=false;">
							<img align="absmiddle" alt="<bean:message key="helpdesk.call.select"/>" src="images/select.gif" border="0"/></a>
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Total Amount:</td>
						<td class="lblLight" width="35%">
							<%=numFormater.format(pb.getCalAmount() != null ? pb.getCalAmount().doubleValue() : 0D)%>
						</td>
						
						<td class="lblbold" align=right width="15%">Currency:</td>
						<td class="lblLight" width="35%">RMB</td>					
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Create Date:</td>
						<td class="lblLight" width="35%">
							<%=dateFormater.format(pb.getCreateDate())%>
						</td>
						<td class="lblbold" align=right width="15%">Create User:</td>
						<td class="lblLight" width="35%">
							<%=pb.getCreateUser().getName()%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Remaining Amount:</td>
						<td class="lblLight" width="35%">
							<%=numFormater.format(pb.getRemainingAmount())%>
						</td>
						<td class="lblbold" align=right width="15%">Status:</td>
						<td class="lblLight" width="35%">
							<%=pb.getStatus()%>
						</td>
					</tr>
					<tr>
						<td class="lblbold" align=right width="15%">Note:</td>
						<td class="lblLight" width="85%" colspan="3">
						<%
							if (canUpdate) {
						%>
							<textarea name="note" cols="130" rows="3"><%=pb.getNote() != null ? pb.getNote() : ""%></textarea>	
						<%
							} else {
						%>
							<%=pb.getNote() != null ? pb.getNote() : ""%>
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
								if (pb.getInvoices() == null || pb.getInvoices().size() == 0) {
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
						<% if ((pb.getCAFAmount()!=0d) || (pb.getAllowanceAmount()!=0d) || (pb.getExpenseAmount()!=0d) || (pb.getBillingAmount()!=0d) || (pb.getDownPaymentAmount()!=0d) ) {%>
						<input type="button" value="Billing Excel Form" name="Print" class="button" onclick="javascript:ExportExcel()">
						<%}%>
						<%
							if (!pb.getStatus().equals("Closed")) {
						%>
						<%
							if (pb.getCalAmount() == null || pb.getCalAmount().doubleValue() == 0L) {
						%>
						<input type="button" value="Close Billing" name="closeBilling" class="button" onclick="javascript:CloseBilling();">
						<%
							}
						%>
						<input type="button" value="Create Invoice" name="createInvoice" class="button" onclick="javascript:document.createInvoiceForm.submit();">
						<%
							}
						%>
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
			    							if (pb.getCAFDetails() == null) {
			    						%>
			    							<font color="red" size="1px">(0)</font>
			    						<%
			    							} else {
												out.println("<font size='1px'>(" + numFormater.format(pb.getCAFAmount()) + ")</font>");
			    							}
			    						%>
		    							</nobr>
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							<nobr>
		    							<%
			    							if (Constants.TRANSACATION_CATEGORY_ALLOWANCE.equals(category)) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">Allowance</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="changeCategory('<%=Constants.TRANSACATION_CATEGORY_ALLOWANCE%>');"><font size="2px">Allowance</font></a>		
			    						<%
			    							}
			    						%>
			    						<%
			    							if (pb.getAllowanceDetails() == null) {
			    						%>
			    							<font color="red" size="1px">(0)</font>
			    						<%
			    							} else {
												out.println("<font size='1px'>(" + numFormater.format(pb.getAllowanceAmount()) + ")</font>");
			    							}
			    						%>
		    							</nobr>
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							<nobr>
		    							<%
			    							if (Constants.TRANSACATION_CATEGORY_EXPENSE.equals(category)) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">Expense</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="changeCategory('<%=Constants.TRANSACATION_CATEGORY_EXPENSE%>');"><font size="2px">Expense</font></a>
			    						<%
			    							}
			    						%>
			    						<%
			    							if (pb.getExpenseDetails() == null) {
			    						%>
			    							<font color="red" size="1px">(0)</font>
			    						<%
			    							} else {
												out.println("<font size='1px'>(" + numFormater.format(pb.getExpenseAmount()) + ")</font>");
			    							}
			    						%>
		    							</nobr>
		    							<span style="color:#999999">&nbsp;|&nbsp;</span>
		    							<nobr>
		    							<%
			    							if (Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE.equals(category)) {
			    						%>
			    						<span style="color:#1E90FF"><font size="4px">Acceptance</font></span>
			    						<%	
			    							} else {
			    						%>
			    						<a href="#" onclick="changeCategory('<%=Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE%>');"><font size="2px">Acceptance</font></a>
			    						<%
			    							}
			    						%>
			    						<%
			    							if (pb.getBillingDetails() == null) {
			    						%>
			    							<font color="red" size="1px">(0)</font>
			    						<%
			    							} else {
												out.println("<font size='1px'>(" + numFormater.format(pb.getBillingAmount()) + ")</font>");
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
			    							if (pb.getCreditDownPaymentDetails() == null) {
			    						%>
			    							<font color="red" size="1px">(0)</font>
			    						<%
			    							} else {
												out.println("<font size='1px'>(" + numFormater.format(pb.getCreditDownPaymentAmount()) + ")</font>");
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
			            			Billing Instruction Detail
			            			</TD>
  								</TR>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_CAF.equals(category)) {
  								%>
  									<%@ include file="CAFBillingInstructionListPage.jsp" %>
  								<%
  									}
  								%>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_ALLOWANCE.equals(category)) {
  								%>
  									<%@ include file="AllowanceBillingInstructionListPage.jsp" %>
  								<%
  									}
  								%>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_EXPENSE.equals(category)) {
  								%>
  									<%@ include file="ExpenseBillingInstructionListPage.jsp" %>
  								<%
  									}
  								%>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE.equals(category)) {
  								%>
  									<%@ include file="AcceptanceBillingInstructionListPage.jsp" %>
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
										//if (pb.getInvoices() == null) {
								%>
  								<tr>
									<TD align="left" colspan="12">
										<input type="button" class="button" name="remove" value="remove from billing list" onclick="doRemove();">
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
											<input type="button" class="button" name="close" value="close" onclick="window.parent.close();">
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
			            			Pending Billing List
			            			</TD>
  								</TR>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_CAF.equals(category)) {
  								%>
  									<%@ include file="CAFBillingPendingListPage.jsp" %>
  								<%
  									}
  								%>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_ALLOWANCE.equals(category)) {
  								%>
  									<%@ include file="AllowanceBillingPendingListPage.jsp" %>
  								<%
  									}
  								%>
  								
  								<%
  									if (Constants.TRANSACATION_CATEGORY_EXPENSE.equals(category)) {
  								%>
  									<%@ include file="ExpenseBillingPendingListPage.jsp" %>
  								<%
  									}
  								%>

  								<%
  									if (Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE.equals(category)) {
  								%>
  									<%@ include file="AcceptanceBillingPendingListPage.jsp" %>
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
										<input type="button" class="button" name="add" value="add to billing list" onclick="doAdd();">
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
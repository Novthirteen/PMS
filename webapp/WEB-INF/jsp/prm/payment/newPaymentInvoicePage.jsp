<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.prm.payment.*"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.prm.expense.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/app.tld" prefix="app" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
try {
if (AOFSECURITY.hasEntityPermission("PAYMENT_INVOICE", "_CREATE", session)) {
	
	List currencyList = (List)request.getAttribute("Currency");
	if(currencyList == null) currencyList = new ArrayList(); 
	String Invoice = request.getParameter("invoice");
	String Payment = request.getParameter("payment");
	String Project = request.getParameter("project");
	String PayAddress = request.getParameter("payAddress");
	String Status = request.getParameter("status");
	String Department = request.getParameter("department");
	
	if (Invoice == null) {
		Invoice = "";
	}
	if (Payment == null) {
		Payment = "";
	}
	if (Project == null) {
		Project = "";
	}
	if (PayAddress == null) {
		PayAddress = "";
	}
	if (Status == null) {
		Status = "";
	}
	if (Department == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			Department = userLogin.getParty().getPartyId();
		}
	}
	
	ProjectPayment pp = (ProjectPayment)request.getAttribute("ProjectPayment");
	if(pp == null)	pp = new ProjectPayment();
	ProjectCostMaster pcm = (ProjectCostMaster)request.getAttribute("ProjectCostMaster");
	if(pcm == null)	pcm = new ProjectCostMaster();	
	ProjectPaymentMaster ppm = (ProjectPaymentMaster)request.getAttribute("ProjectPaymentMaster");
	if(ppm == null)	ppm = new ProjectPaymentMaster();	
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<LINK href="/AOF/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="/AOF/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="/AOF/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<LINK href="/AOF/includes/layout_one/css/screen.css" rel=stylesheet type=text/css>

<script language="javascript">
		<%
		if ("Closing".equals((String)request.getAttribute("Closing"))) {
		%>
			window.parent.close();
		<%
		}
		%>
function showPaymentDialog() {
	with(document.newForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payment.dialog.title&FindPaymentInstruction.do?action=showDialog",
			null,
			'dialogWidth:750px;dialogHeight:650px;status:no;help:no;scroll:no');
			
		if (v != null && v != "") {
			var vv = v.split("$");
			document.getElementById("labelPayCode").innerHTML = vv[1];		
			document.getElementById("payId").value = vv[0];
			document.getElementById("labelProject").innerHTML = vv[2] + ":" + vv[3];
			document.getElementById("projectId").value = vv[2];
			if (document.getElementById("payAddressId").value == "") {
				document.getElementById("labelPayAddress").innerHTML = vv[5];
				document.getElementById("payAddressId").value = vv[4];
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

function OnSettleCheck(){
	document.updateForm.refno.value = document.updateForm.siCode.value;
	document.updateForm.payno.value = document.newForm.payId.value;	
	
	if(document.updateForm.refno == null || document.updateForm.refno.value == ''){
		alert("Please select a supplier invoice.");
		return false;
	}
	if(document.updateForm.settleAmount == null){
		alert("Settlement Amount Invalid");
		return false;	
	}
	removeComma(document.updateForm.settleAmount);
	removeComma(document.updateForm.siRemainAmount);
	if(document.updateForm.settleAmount.value == 0){
		alert("Settlement Amount Invalid");
		return false;
	}
	var amount1 = document.updateForm.siRemainAmount.value;
	var amount2 = <%=pp.getRemainingAmount(pp.getId())%>;
	if(parseFloat(document.updateForm.settleAmount.value) > parseFloat(amount1) ){
		alert("Settlement Amount Invalid.")
		return false;
	}
	if( parseFloat(document.updateForm.settleAmount.value) > parseFloat(amount2)){
		alert("Settlement Amount Invalid.")
		return false;
	}	
	document.updateForm.submit();
	
}

function showSupplierInvoiceDialog()    
{
	var code,desc;
	with(document.updateForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&dialogSupplierInvoiceList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {	
			labelSICode.innerHTML = v.split("|")[1];
			document.updateForm.siCode.value = v.split("|")[1];
			//document.form1.payCode.value = v.split("|")[1];
			//document.updateForm.amount.value = v.split("|")[7];
			labelPayDate.innerHTML = v.split("|")[6];
			labelVendor.innerHTML = v.split("|")[2];
			labelSIAmount.innerHTML = v.split("|")[3];	
			//document.updateForm.payAmount.value = v.split("|")[3];
			//document.form1.payAmount.value = v.split("|")[3];				
			labelCurrency.innerHTML = v.split("|")[4];
			labelExchangeRate.innerHTML = v.split("|")[5];
			labelRemainAmount.innerHTML = v.split("|")[7];
			
			siRemainAmount.value = v.split("|")[7];	
			settleAmount.value = v.split("|")[7];
			var temp = document.getElementById("amt").value;
			removeComma(document.getElementById("amt"));
			removeComma(settleAmount);
			 
			
			if (parseFloat(settleAmount.value) > parseFloat(document.getElementById("amt").value)){		
				settleAmount.value = temp;
			}
			//document.updateForm.remainAmount.value = v.split("|")[7];
			labelPayType.innerHTML = v.split("|")[9];				
		}
	}
}

function showVendorDialog()
{
	var code,desc;
	with(document.newForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.projectPayment.payto.dialog.title&crm.dialogVendorList.do",
			null,
			'dialogWidth:500px;dialogHeight:500px;status:no;help:no;scroll:no');
		if (v != null) {
			code=v.split("|")[0];
			desc=v.split("|")[1];
			labelPayAddress.innerHTML=desc;			
			payAddressId.value=code;
		}
	}
}

function checkSubmit() {	
	if (document.newForm.payId.value == "") {
		alert("Payment Code can not be ignored");
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
		alert("Pay Date can not be ignored ");
		return false;
	} 

	return true;
}

function onCurrSelect(){
}
</script>

<form name="newForm" action="editPaymentInvoice.do" method="post" onsubmit="return checkSubmit();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="includes/date/calendar.htm" style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
	<input type="hidden" name="formAction" value="new">
	<input type="hidden" name="invoiceType" value="<%=Constants.PAYMENT_INVOICE_TYPE_NORMAL%>">
	<TABLE width=100% cellpadding="1" border="0" cellspacing="1">
		<CAPTION align=center class=pgheadsmall>
		Payment Settlement 
		</CAPTION>
		<TR>
			<TD>
				<table width="100%">
					<tr>
    					<td align=left colspan="4" class="wpsPortletTopTitle">Payment Instruction Information: </td>
  					</tr>
  					<%if (request.getAttribute("ErrorMessage") != null) { %>
  					<tr>
    					<td align=left colspan="4">
            				<font color="red" size="4">
            					<%=(String)request.getAttribute("ErrorMessage")%>
            				</font>
          				</td>
  					</tr>
  					<%
  						}
  					%>
					
					<tr>
					  	<td class="lblbold" align=right>Payment Code:</td>
				  	  <td class="lblLight"><div style="display:inline" id="labelPayCode"><%=pp != null && pp.getPaymentCode() != null ? pp.getPaymentCode() : ""%></div>
					  		<input type="hidden" name="payId" value="<%=pp != null && pp.getId() != null ? String.valueOf(pp.getId()) : ""%>">                       	  </td>
					  	<td class="lblbold" align=right width="17%">Project:</td>
					  	<td><%=pp.getProject()==null?"":pp.getProject().getProjName()%></td>
					</tr>
					
					<tr>						
						<td class="lblbold" align=right width="14%">Pay To:</td>
					  <td class="lblLight" width="35%">							
							<div style="display:inline" id="labelPayAddress"><%=pp.getPayAddress()==null?"":pp.getPayAddress().getDescription()%></div>
							<input type="hidden" name="payAddressId" value="<%=""%>">		
						</td>
						<td class="lblbold" align=right width="17%">Payment Amount:</td>
						<td class="lblLight" width="34%">
							<div style="display:inline" id="labelPayAmount"><%=pp.getCalAmount()==null?"":UtilFormat.format(pp.getCalAmount())%></div>
						</td>
					</tr>
					
					<tr>
						<td class="lblbold" align=right width="14%">Currency:</td>
						<td class="lblLight" width="35%">RMB</td>
						<td class="lblbold" align=right width="17%">Exchange Rate(RMB):</td>
						<td class="lblLight" width="34%">1.0
						</td>
					</tr>

					<tr>						
						<td class="lblbold" align=right width="14%">Remain Amount:</td>
					  <td class="lblLight" width="35%" ><%=UtilFormat.format(pp.getRemainingAmount(pp.getId()))%>							
					  <input type="hidden" name="amt" value="<%=UtilFormat.format(pp.getRemainingAmount(pp.getId()))%>">
						</td>						
						<td class="lblbold" align=right width="17%">Status:</td>
						<td class="lblLight" width="34%"><%=pp.getStatus()==null?"":pp.getStatus()%></td>
					</tr>	
									
					<tr>
						<td class="lblbold" align=right width="14%">Create User:</td>
						<td class="lblLight" width="35%"><%=pp.getCreateUser()==null?"":pp.getCreateUser().getName()%></td>
						<td class="lblbold" align=right width="17%">Create Date:</td>
						<td class="lblLight" width="34%"><%=pp.getCreateDate()==null?"":UtilFormat.format(pp.getCreateDate())%></td>
					</tr>
				</table>				
			</TD>
		</TR>
	</TABLE>
</form>

<form name='updateForm' action='editPaymentInvoice.do'>
	<table width='100%'>
		<tr>
			<td align=left colspan="4"  class="wpsPortletTopTitle">Supplier Invoice Information:</td>
		</tr>
	    
		<tr>
		  <td class="lblbold" align=right>Supplier Invoice Code:</td>
		  <input type="hidden" name="siCode" value="<%=ppm.getPayCode()==null?"":ppm.getPayCode()%>">
		  <td><div style="display:inline" id="labelSICode"><%=ppm.getPayCode()==null?"":ppm.getPayCode()%></div>
		      <a href="javascript:void(0)" onclick="showSupplierInvoiceDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a> </td>
		  <td align=right font="bold" class="lblbold" width='23%'>Payment Type:&nbsp;</td>
			<td align=left width='35%'><div style="display:inline" id="labelPayType"><%=ppm.getPayType()==null?"":ppm.getPayType()%></div></td>
		</tr>							
		<tr>
			<td align=right font="bold" class="lblbold" width='18%'>Currency: &nbsp;</td>
			<td align=left width='24%'><div style="display:inline" id="labelCurrency"><%=ppm.getCurrency()==null?"":ppm.getCurrencyString()%></div></td>
			<td align=right font="bold" class="lblbold" width='23%'>Exchange Rate: &nbsp;</td>
			<td align=left width='35%'><div style="display:inline" id="labelExchangeRate"><%=ppm.getExchangeRate()%></div></td>
		</tr>							
		<tr>
			<td align=right font="bold" class="lblbold" width='18%'>Payment Amount: &nbsp;</td>
			<td align=left width='24%'><div style="display:inline" id="labelSIAmount"><%=UtilFormat.format(ppm.getPayAmount())%></div></td>
			<td align=right font="bold" class="lblbold" width='23%'>Remain Amount: &nbsp;</td>
			<td align=left width='35%'><div style="display:inline" id="labelRemainAmount"><%=UtilFormat.format(ppm.getRemainAmount())%></div></td>

		</tr>							
		<tr>
		  <td align=right font="bold" class="lblbold">Vendor: &nbsp;</td>
		  <td align=left><div style="display:inline" id="labelVendor"><%=ppm.getVendorId()==null?"":ppm.getVendorString()%></div></td>
		  <td align=right font="bold" class="lblbold">Supplier Invoice Date: &nbsp;</td>
		  <td align=left><div style="display:inline" id="labelPayDate"><%=ppm.getPayDate()==null?"":ppm.getPayDateString()%></div></td>
		</tr>							
	</table>
<input type="hidden" name='siRemainAmount' value="<%=ppm.getRemainAmount()%>">
<input type='hidden' name='refno' value=''>
<input type='hidden' name='payno' value=''>
<input type='hidden' name='formAction' value='newCM'>
<input type='hidden' name='' value=''>
<input type='hidden' name='' value=''>
<input type='hidden' name='' value=''>
<input type='hidden' name='' value=''>
<input type='hidden' name='' value=''>
<table width='100%'>
	<tr>
		<td align=left colspan="4"  class="wpsPortletTopTitle">Settlement:</td>
	</tr>							
	<tr>
	  <td width="17%" align=right class="lblbold" font="bold">Settle Amount:</td>
	  <td width="24%" align=left>
	    <input type="text" name="settleAmount" size="30" value="<%=UtilFormat.format(new Double(pcm.getTotalvalue()))%>" style="TEXT-ALIGN: right" class="lbllgiht"  onblur="checkDeciNumber2(this,1,1,'Amount',-9999999999,9999999999); addComma(this, '.', '.', ',');">
	  </td>
	  <td width="31%" align=right class="lblbold">Currency:</td>
	  <td width="28%" class="lblLight"><select name="cmCurrency" onchange="javascript:onCurrSelect()">
          <%
									Float defaultCurrRate1 = null;
									for (int i0 = 0; i0 < currencyList.size(); i0++) {
										CurrencyType curr = (CurrencyType)currencyList.get(i0);
										String isSelected = "";
										if (i0 == 0) {
											defaultCurrRate1 = curr.getCurrRate();
										}
										if (pcm.getCurrency() != null && pcm.getCurrency().getCurrId().equals(curr.getCurrId())) {
											isSelected = "selected";
											defaultCurrRate1 = curr.getCurrRate();
										}
								%>
          <option value="<%=curr.getCurrId()%>" <%=isSelected%>><%=curr.getCurrName()%></option>
          <%}%>
        </select>
      </td>
	</tr>
	<tr>
	  <td class="lblbold" align=right>Posted Payment Code: </td>
	  <td class="lblLight"><div style="display:inline" id="pcmFormCode"><%=pcm.getFormCode()==null?"":pcm.getFormCode()%></div>
	  <input type='hidden' name='pcmId' value='<%=pcm.getCostcode()==null?"":pcm.getCostcode().toString()%>'></td>
	  <td align=right class="lblbold" font="bold"  colspan="2"><input type="button" class="button" name="Save" value="Save" onclick='OnSettleCheck();'>&nbsp;&nbsp;&nbsp;&nbsp;
          <input name="Cancel" type="button" class="button" value="Close" onclick="self.close();">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      </td>
	</tr>							
</table>
</form>

<%

}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception ex) {ex.printStackTrace();}
%>
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
	Object toClose = request.getAttribute("toClose");
	if(toClose != null){
%>
	<script>window.parent.close();</script>
<%	}else{
	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	boolean isUpdate;
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	String paymentId = String.valueOf((Long)request.getAttribute("paymentId"));
	ProjectPayment pp = (ProjectPayment)hs.load(ProjectPayment.class, (Long)request.getAttribute("paymentId"));
	if(request.getAttribute("tranId")==null){
		isUpdate = false;
	}else{
		isUpdate = true;
	}
	
	ProjPaymentTransaction ppt = null;	
	if(isUpdate){
		Long tranId = (Long)request.getAttribute("tranId");
		ppt = (ProjPaymentTransaction)hs.load(ProjPaymentTransaction.class, tranId);
	}
%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunctions.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<LINK href="includes/layout_one/css/screen.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>

<script language="javascript">
function showSupplierInvoiceDialog()    
{
	var code,desc;
	with(document.SIForm)
	{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&dialogSupplierInvoiceList.do",
			null,
			'dialogWidth:500px;dialogHeight:600px;status:no;help:no;scroll:no');
		if (v != null) {	
			labelInvCode.innerHTML = v.split("|")[1];
			document.SIForm.invCode.value = v.split("|")[1];
			
			labelPayDate.innerHTML = v.split("|")[6];
			document.SIForm.payDate.value = v.split("|")[6];
			
			labelVendor.innerHTML = v.split("|")[2];
			document.SIForm.vendor.value = v.split("|")[2];
			
			labelAmt.innerHTML = v.split("|")[3];	
			document.SIForm.amt.value = v.split("|")[3];
		
			labelCurrency.innerHTML = v.split("|")[4];
			document.SIForm.currency.value = v.split("|")[4];
			
			labelRate.innerHTML = v.split("|")[5];
			document.SIForm.rate.value = v.split("|")[5];
			
			labelRemainAmt.innerHTML = v.split("|")[7];
			document.SIForm.remainAmt.value = v.split("|")[7];
			
			labelType.innerHTML = v.split("|")[9];
			document.SIForm.type.value = v.split("|")[9];
			
			var paymentRemainingAmount = <%=pp==null?"0":String.valueOf(pp.getCalAmount().doubleValue()-pp.getSettledAmount().doubleValue())%>;
			document.SIForm.place.value = v.split("|")[7];
			removeComma(document.SIForm.place);
			if(parseFloat(document.SIForm.place.value)>paymentRemainingAmount){
				document.SIForm.settleAmt.value = paymentRemainingAmount;
			}else{
				document.SIForm.settleAmt.value = v.split("|")[7];
			}
			var temp = document.SIForm.amt.value;
			removeComma(document.SIForm.amt);
			removeComma(settleAmt);
			 
			if (parseFloat(settleAmt.value) > parseFloat(document.SIForm.amt.value)){		
				settleAmt.value = temp;
			}
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
</script>
<%if(!isUpdate){%>
<script language="javascript">
function OnSettleCheck(){
	document.SIForm.Save.disabled = true;
	document.SIForm.Cancel.disabled = true;
	if(document.SIForm.invCode == null || document.SIForm.invCode.value == ''){
		alert("Please select a supplier invoice.");
		return false;
	}
	if(document.SIForm.settleAmt == null){
		alert("Settlement Amount Invalid");
		return false;	
	}
	removeComma(document.SIForm.settleAmt);
	removeComma(document.SIForm.remainAmt);
	if(document.SIForm.settleAmt.value == 0){
		alert("Settlement Amount Invalid");
		return false;
	}
	var amount1 = document.SIForm.remainAmt.value;
	var amount2 = <%=pp==null?"0":String.valueOf(pp.getCalAmount().doubleValue()-pp.getSettledAmount().doubleValue())%>;
	if(parseFloat(document.SIForm.settleAmt.value) > parseFloat(amount1) ){
		alert("Settlement Amount Invalid.")
		return false;
	}
	//if( parseFloat(document.SIForm.settleAmt.value) > parseFloat(amount2)){
	//	alert("Settlement Amount Invalid.")
	//	return false;
	//}
}
</script>
<form name='SIForm' action='settleSupplierInvoice.do' onSubmit="return OnSettleCheck();">
<table width='100%'>
	<caption align=center class="pgheadsmall">Supplier Invoice</caption>
	<tr>
		<td font="bold" class="lblbold" colspan="4">&nbsp; Select Supplier Invoice: &nbsp;&nbsp;<a href="javascript:void(0)" onclick="showSupplierInvoiceDialog();event.returnValue=false;"><img align="absmiddle" alt="<bean:message key="helpdesk.call.select" />" src="images/select.gif" border="0" /></a></td>
	</tr>
    <tr>
		<td width="100%" colspan=4><hr color=red></hr></td>
	</tr>
	<tr>
	  	<td class="lblbold" align=right width="25%">Supplier Invoice Code:&nbsp;</td>
	  	<td width="20%"><div style="display:inline" id="labelInvCode"></div></td>
		<td align=right font="bold" class="lblbold" width="15%">Currency:&nbsp;</td>
		<td align=left width="40%"><div style="display:inline" id="labelCurrency"></div></td>
	</tr>							
	<tr>	
		<td align=right class="lblbold">Exchange Rate:&nbsp;</td>
		<td align=left><div style="display:inline" id="labelRate"></div></td>
		<td align=right class="lblbold">Payment Amount:&nbsp;</td>
		<td align=left><div style="display:inline" id="labelAmt"></div></td>
	</tr>							
	<tr>	
		<td align=right class="lblbold">Remain Amount:&nbsp;</td>
		<td align=left><div style="display:inline" id="labelRemainAmt"></div></td>
	  	<td align=right class="lblbold">Vendor:&nbsp;</td>
	  	<td align=left><div style="display:inline" id="labelVendor"></div></td>
	</tr>							
	<tr>	
	  	<td align=right class="lblbold">Supplier Invoice Date:&nbsp;</td>
	  	<td align=left><div style="display:inline" id="labelPayDate"></div></td>
  		<td align="right" class="lblbold">Payment Type:&nbsp;</td>
  		<td><div style="display:inline" id="labelType"></div></td>
  	</tr>
  	<tr>
  		<td align=right class="lblbold">Settle Amount (RMB)&nbsp;:</td>
  		<td align=left>
    		<input type="text" name="settleAmt" size="30" value="" style="TEXT-ALIGN: right" class="lbllgiht"  onblur="checkDeciNumber2(this,1,1,'Amount',-9999999999,9999999999); addComma(this, '.', '.', ',');">
  		</td>
  		<td colspan="2"/>
	</tr>
	<tr>
		<td class="lblbold" align=right width="15%">Note:&nbsp;</td>
		<td class="lblLight" width="85%" colspan="3">
			<textarea name="note" cols="77" rows="3"></textarea>
		</td>
	</tr>
	<tr>
  		<td align=left class="lblbold" colspan="4"><input type="submit" class="button" name="Save" value="Save">&nbsp;&nbsp;&nbsp;&nbsp;
      		<input name="Cancel" type="button" class="button" value="Close" onclick="window.returnValue='justView';self.close();">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  		</td>
	</tr>
	<tr>
		<td width="100%" colspan=4><hr color=red></hr></td>
	</tr>
</table>
<input type="hidden" name="place"  id="place"value="">
<input type="hidden" name="invCode" id="invCode" value="">
<input type="hidden" name="vendor" id="vendor" value="">
<input type="hidden" name="type" id="type" value="">
<input type="hidden" name="payDate" id="payDate" value="">
<input type="hidden" name="currency" id="currency" value="">
<input type="hidden" name="rate" id="rate" value="">
<input type="hidden" name="amt" id="amt" value="">
<input type="hidden" name="paymentId" id="paymentId" value="<%=paymentId%>">
<input type="hidden" name="tranId" id="tranId" value="">
<input type="hidden" name="formAction" id="formAction" value="save">
<input type="hidden" name="remainAmt" id="remainAmt" value="">
</form>

<%}else{%>

<script language="javascript">
function OnSettleCheck(){
	document.SIForm.Save.disable = true;
	document.SIForm.Cancel.disable = true;
	if(document.SIForm.settleAmt == null){
		alert("Settlement Amount Invalid");
		return false;	
	}
	removeComma(document.SIForm.settleAmt);
	removeComma(document.SIForm.remainAmt);
	if(document.SIForm.settleAmt.value == 0){
		alert("Settlement Amount Invalid");
		return false;
	}
	var amount1 = parseFloat(document.SIForm.remainAmt.value)+<%=ppt.getAmount().doubleValue()%>;
	var amount2 = <%=pp==null?"0":String.valueOf(pp.getCalAmount().doubleValue()-pp.getSettledAmount().doubleValue()+ppt.getAmount().doubleValue())%>;
	if(parseFloat(document.SIForm.settleAmt.value) > parseFloat(amount1) ){
		alert("Settlement Amount Invalid.")
		return false;
	}
	if( parseFloat(document.SIForm.settleAmt.value) > parseFloat(amount2)){
		alert("Settlement Amount Invalid.")
		return false;
	}
}
</script>
<form name='SIForm' action='settleSupplierInvoice.do' onSubmit="return OnSettleCheck();">
<table width='100%'>
	<caption align=center class="pgheadsmall">Supplier Invoice</caption>
	<tr>
	  	<td class="lblbold" align=right width="25%">Supplier Invoice Code:&nbsp;</td>
	  	<td width="20%"><%=ppt.getInvoice().getPayCode()%></td>
		<td align=right font="bold" class="lblbold" width="15%">Currency:&nbsp;</td>
		<td align=left width="40%"><%=ppt.getCurrency().getCurrName()%></td>
	</tr>
	<tr>	
		<td align=right class="lblbold">Exchange Rate:&nbsp;</td>
		<td align=left><%=ppt.getInvoice().getExchangeRate()%></td>
		<td align=right class="lblbold">Invoice Amount:&nbsp;</td>
		<td align=left><%=numFormater.format(ppt.getInvoice().getPayAmount())%></td>
	</tr>							
	<tr>	
		<td align=right class="lblbold">Remain Amount:&nbsp;</td>
		<td align=left><%=numFormater.format(ppt.getInvoice().getSettledRemainingAmount())%></td>
	  	<td align=right class="lblbold">Vendor:&nbsp;</td>
	  	<td align=left><%=ppt.getInvoice().getVendorId().getDescription()%></td>
	</tr>							
	<tr>	
	  	<td align=right class="lblbold">Supplier Invoice Date:&nbsp;</td>
	  	<td align=left><%=ppt.getInvoice().getPayDate()==null?"":dateFormat.format(ppt.getInvoice().getPayDate())%></td>
  		<td align="right" class="lblbold">Payment Type:&nbsp;</td>
  		<td><%=ppt.getInvoice().getPayType()%></td>
  	</tr>
  	<tr>
  		<td align=right class="lblbold">Settle Amount (RMB)&nbsp;:</td>
  		<td align=left>
  			<%if(!ppt.getPostStatus().equals("Post")&&!ppt.getPostStatus().equals("Paid")){%>
    			<input type="text" name="settleAmt" size="30" value="<%=ppt.getAmount()%>" style="TEXT-ALIGN: right" class="lbllgiht"  onblur="checkDeciNumber2(this,1,1,'Amount',-9999999999,9999999999); addComma(this, '.', '.', ',');">
    		<%}else{%>
    			<%=ppt.getAmount()%>
    		<%}%>
  		</td>
  		<td colspan="2"/>
	</tr>
	<tr>
		<td class="lblbold" align=right width="15%">Note:&nbsp;</td>
		<td class="lblLight" width="85%" colspan="3">
			<%if(!ppt.getPostStatus().equals("Post")&&!ppt.getPostStatus().equals("Paid")){%>
				<textarea name="note" cols="77" rows="3"><%=ppt.getNote()%></textarea>
			<%}else{%>
				<%=ppt.getNote()%>
			<%}%>
		</td>
	</tr>
	<tr>
  		<td align=left class="lblbold" colspan="4">
  			<%if(!ppt.getPostStatus().equals("Post")&&!ppt.getPostStatus().equals("Paid")){%>
  				<input type="submit" class="button" name="Save" value="Save">&nbsp;&nbsp;&nbsp;&nbsp;
  			<%}%>
      		<input name="Cancel" type="button" class="button" value="Close" onclick="window.returnValue='justView';self.close();">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  		</td>
	</tr>
	<tr>
		<td width="100%" colspan=4><hr color=red></hr></td>
	</tr>
</table>
<input type='hidden' name="tranId" id="tranId" value='<%=ppt.getId()%>'>
<input type='hidden' name="formAction" id="formAction" value='update'>
<input type='hidden' name="remainAmt" id="remainAmt" value='<%=ppt.getInvoice().getSettledRemainingAmount()%>'>
<input type='hidden' name="settledAmt" id="settledAmt" value='<%=ppt.getAmount()%>'>
</form>
<%}%>
<%
}
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception ex) {ex.printStackTrace();}
%>
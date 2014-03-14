<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.aof.component.prm.payment.ProjPaymentTransaction"%>
<script language="javascript">
function viewInvoice(tranId){
	var param = "paymentId=" + "<%=pp.getId()%>" + "&tranId=" +tranId+ "&formAction=view";
	var v = window.showModalDialog(
	"system.showDialog.do?title=prm.projectPayment.settleSupplierInvoice.dialog.title&settleSupplierInvoice.do?" + param,
		null,
	'dialogWidth:800px;dialogHeight:400px;status:no;help:no;scroll:auto');
	if(v==null||v!="justView"){
		if(document.editForm.action!=null){
			document.editForm.action.value = "view";
		}
		if(document.editForm.formAction!=null){
			document.editForm.formAction.value = "view";
		}		
		document.editForm.submit();
	}
}
</script>
<tr align="center" bgcolor="#e9eee9">
	<td align="center" class="lblbold"><input type=checkbox class="checkboxstyle" name=chkAll value='' onclick="javascript:checkUncheckAllBox(document.editForm.chkAll,document.editForm.chk)"></td>
	<td align="center" class="lblbold">&nbsp;Invoice Code&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Settle Amount&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Vendor&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Currency&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Exchange Rate&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Status&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Pay Date&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;Create Date&nbsp;</td>
	<td align="center" class="lblbold">&nbsp;&nbsp;</td>
</tr>
<%
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		NumberFormat numFormat = NumberFormat.getInstance();
		numFormat.setMaximumFractionDigits(2);
		numFormat.setMinimumFractionDigits(2);
		Iterator invIte = null;
		if (pp.getSettleRecords()!=null) {
			invIte = pp.getSettleRecords().iterator();
			while(invIte.hasNext()){
				ProjPaymentTransaction ppt = (ProjPaymentTransaction)invIte.next();
%>
<tr align="center" bgcolor="#e9eee9">
	<td align="center">
		<%if(ppt.getPostStatus().equals("Draft")||ppt.getPostStatus().equals("Rejected")){%>
			<input type=checkbox class="checkboxstyle" name=chk value="<%=ppt.getId()%>" onclick='javascript:checkTopBox(document.editForm.chkAll,document.editForm.chk)'>
		<%}%>
	</td>
	<TD align="left">
		<a href="#" onclick="viewInvoice('<%=ppt.getId()%>');"><%=ppt.getInvoice().getPayCode()!=null ? ppt.getInvoice().getPayCode():""%></a>
	</TD>
	<TD align="left">
		<%=numFormat.format(ppt.getAmount())%>
	</TD>
	<TD align="left">
		<%=ppt.getInvoice().getVendorId().getDescription()%>
	</TD>
	<TD align="left">
		<%=ppt.getCurrency().getCurrName() != null ? ppt.getCurrency().getCurrName() : ""%>
	</TD>
	<TD align="left">
		<%=ppt.getCurrency().getCurrRate()%>
	</TD>
	<TD align="left">
		<%=ppt.getPostStatus()%>
	</TD>
	<TD align="left">
		<%=ppt.getPayDate() != null ? format.format(ppt.getPayDate()) : ""%>
	</TD>
	<TD align="left">
		<%=ppt.getCreateDate() != null ? format.format(ppt.getCreateDate()) : ""%>
	</TD>
	<TD align="left">
		<%if(ppt.getPostStatus().equals("Draft")||ppt.getPostStatus().equals("Rejected")){%>
			<a href="#" onclick="removeSupplierInv('<%=ppt.getId()%>');">Remove</a>
		<%}%>
	</TD>
</TR>
<%
			}
		} else {
%>
<tr align="center">
	<td colspan="9">
		<font color="red">No Record Found</font>
	<td>
</tr>
<%
		}
		
%>
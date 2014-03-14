<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.payment.*"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
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
if (AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT", "_VIEW", session)) {
	String category = request.getParameter("category");
	if(category == null)
		category = "";
	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);	
	
	DateFormat dateFormater = new SimpleDateFormat("yyyy/MM/dd");
	
	boolean canUpdate = false;
%>
<HTML>
	<HEAD>
		<title>AO-SYSTEM</title>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		<script language="javascript">
			function showExpDetail(em_id) {
				var windowprops	= "width=950,height=390,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,location=no,scrollbars=yes,status=no,menubars=no,toolbars=no,resizable=no";
				var url = "editExpense.do?FormAction=showArAndApDetail&DataId="+em_id;
				window.open(url, "showExp", windowprops);
			}
		</script>
	</HEAD>
	
	<BODY>
		<table width=100% cellpadding="1" border="0" cellspacing="1" >
			<br>
<%
		if (category.equals(Constants.TRANSACATION_CATEGORY_EXPENSE)) {
%>
		<CAPTION align=center class=pgheadsmall>Payment Expense Detail</CAPTION>
		<TR>
			<td colspan="12"><hr color="red"></hr></td>
  		</TR>
  		<%@ include file="ExpensePaymentPendingListPage.jsp" %>
<%
		}
%>
<%
		if (category.equals(Constants.TRANSACATION_CATEGORY_CAF)) {
%>
		<CAPTION align=center class=pgheadsmall>Payment CAF Detail</CAPTION>
		<TR>
			<td colspan="12"><hr color="red"></hr></td>
  		</TR>
  		<%@ include file="CAFPaymentPendingListPage.jsp" %>
<%
		}
%>

<%
		if (category.equals(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE)) {
%>
		<CAPTION align=center class=pgheadsmall>Payment Acceptance Detail</CAPTION>
		<TR>
			<td colspan="12"><hr color="red"></hr></td>
  		</TR>
  		<%@ include file="AcceptancePaymentPendingListPage.jsp" %>
<%
		}
%>
<%
		if (Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT.equals(category)) {
%>
	<%@ include file="PaymentCreditDownPaymentPendingListPage.jsp" %>
<%
	}
%>

<%
		if (category.equals("")) {
%>
		<CAPTION align=center class=pgheadsmall>Check Billing</CAPTION>
		<TR>
			<td colspan="12"><hr color="red"></hr></td>
  		</TR>
  		<%@ include file="CheckBillingListPage.jsp" %>
<%
		}
%>
		<TR>
			<td colspan="12">
				&nbsp;&nbsp;<input type="button" class="button" name="Close" value="Close" onclick="self.close();">
			</td>
  		</TR>
  		<TR>
			<td colspan="12">
				&nbsp;
			</td>
  		</TR>
		</table>
	</body>
</html>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
<%@ page contentType="text/html; charset=gb2312"%>
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
if (AOFSECURITY.hasEntityPermission("PROJECT_BILLING", "_VIEW", session)) {
	String category = request.getParameter("category");
	NumberFormat numFormater = NumberFormat.getInstance();
	numFormater.setMaximumFractionDigits(2);
	numFormater.setMinimumFractionDigits(2);	
	
	DateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");
	
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
			function showOtherCostDetail(em_id) {
				var windowprops	= "width=950,height=390,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,location=no,scrollbars=yes,status=no,menubars=no,toolbars=no,resizable=no";
				var url = "projectCostMaintain.do?FormAction=showArAndApDetail&DataId="+em_id;
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
		<CAPTION align=center class=pgheadsmall>Billing Expense Detail</CAPTION>
		<TR>
			<td colspan="12"><hr color="red"></hr></td>
  		</TR>
  		<%@ include file="ExpenseBillingPendingListPage.jsp" %>
<%
		}
%>
<%
		if (category.equals(Constants.TRANSACATION_CATEGORY_CAF)) {
%>
		<CAPTION align=center class=pgheadsmall>Billing CAF Detail</CAPTION>
		<TR>
			<td colspan="12"><hr color="red"></hr></td>
  		</TR>
  		<%@ include file="CAFBillingPendingListPage.jsp" %>
<%
		}
%>
<%
		if (category.equals(Constants.TRANSACATION_CATEGORY_ALLOWANCE)) {
%>
		<CAPTION align=center class=pgheadsmall>Billing Allowance Detail</CAPTION>
		<TR>
			<td colspan="12"><hr color="red"></hr></td>
  		</TR>
  		<%@ include file="AllowanceBillingPendingListPage.jsp" %>
<%
		}
%>
<%
		if (category.equals(Constants.TRANSACATION_CATEGORY_BILLING_ACCEPTANCE)) {
%>
		<CAPTION align=center class=pgheadsmall>Billing Acceptance Detail</CAPTION>
		<TR>
			<td colspan="12"><hr color="red"></hr></td>
  		</TR>
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
		<TR>
			<td colspan="12">
				&nbsp;&nbsp;<input type="button" class="button" name="Close" value="Close" onclick="window.parent.close();">
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
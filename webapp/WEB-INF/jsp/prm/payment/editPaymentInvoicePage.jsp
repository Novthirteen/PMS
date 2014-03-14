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

	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	
	Set pcmSet = (Set)request.getAttribute("ProjectCostMasterSet");
	List currencyList = (List)request.getAttribute("Currency");
	
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
%>

<form name="backForm" action="findPaymentInvoice.do" method="post">

	<input type="hidden" name="formAction" value="query">
	<input type="hidden" name="invoice" value="<%=Invoice%>">
	<input type="hidden" name="payment" value="<%=Payment%>">
	<input type="hidden" name="project" value="<%=Project%>">
	<input type="hidden" name="payAddress" value="<%=PayAddress%>">
	<input type="hidden" name="status" value="<%=Status%>">
	<input type="hidden" name="department" value="<%=Department%>">
</form>
	<%@ include file="updatePaymentInvoicePage.jsp" %>
<%

}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception ex) {//ex.printStackTrace();
	}
%>
<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.payment.*"%>
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
if (AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT", "_CREATE", session)) {
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
<form name="backForm" action="FindPaymentInstruction.do" method="post">
	<input type="hidden" name="action" value="query">
	<input type="hidden" name="payCode" value="<%=payCode%>">
	<input type="hidden" name="project" value="<%=project%>">
	<input type="hidden" name="vendor" value="<%=vendor%>">
	<input type="hidden" name="department" value="<%=department%>">
	<input type="hidden" name="status" value="<%=status%>">
</form>
<%
	ProjectPayment pp = (ProjectPayment)request.getAttribute("ProjectPayment");
	if (pp == null) {
%>
		<%@ include file="newPaymentInstructionPage.jsp" %>
<%		
	} else{
%>
		<%@ include file="updatePaymentInstructionPage.jsp" %>
<%
	}
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
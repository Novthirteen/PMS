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
try{
if (AOFSECURITY.hasEntityPermission("PROJECT_DOWNPAYMENT", "_CREATE", session)) {
	String billCode = request.getParameter("billCode");
	String project = request.getParameter("project");
	String customer = request.getParameter("customer");
	String department = request.getParameter("department");
	String status = request.getParameter("status");
	
	if (department == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			department = userLogin.getParty().getPartyId();
		}
	}

	if (billCode == null) {
		billCode = "";
	}
	if (project == null) {
		project = "";
	}
	if (customer == null) {
		customer = "";
	}
	if (status == null) {
		status = "";
	}
%>
<form name="backForm" action="FindDownpaymentInstruction.do" method="post">
	<input type="hidden" name="formAction" value="query">
	<input type="hidden" name="billCode" value="<%=billCode%>">
	<input type="hidden" name="project" value="<%=project%>">
	<input type="hidden" name="customer" value="<%=customer%>">
	<input type="hidden" name="department" value="<%=department%>">
	<input type="hidden" name="status" value="<%=status%>">
</form>
<%
	ProjectBill pb = (ProjectBill)request.getAttribute("ProjectBill");
	if (pb == null) {
%>
		<%@ include file="newDownpaymentInstructionPage.jsp" %>
<%		
	} else {
%>
		<%@ include file="updateDownpaymentInstructionPage.jsp" %>
<%
	}
}else{
	out.println("!!你没有相关访问权限!!");
}
}catch (Exception e){
	e.printStackTrace();
}
%>
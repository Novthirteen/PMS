<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.prm.payment.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (AOFSECURITY.hasEntityPermission("PROJECT_PAYMENT", "_VIEW", session)) {
	String payCode = request.getParameter("payCode");
	String project = request.getParameter("project");
	//String customer = request.getParameter("customer");
	String vendor =request.getParameter("vendor");
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
		department = "";
	}
	if (status == null) {
		status = "";
	}
%>
<HTML>
	<HEAD>
	
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
<%
	//ProjectBill pb = (ProjectBill)request.getAttribute("ProjectBill");
	ProjectPayment pp = (ProjectPayment)request.getAttribute("ProjectPayment");
%>
		<%@ include file="updatePaymentInstructionPage.jsp" %>
		
	</body>
</html>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
%>

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
try {
if (AOFSECURITY.hasEntityPermission("PROJ_INVOICE", "_CREATE", session)) {

	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	
	ProjectInvoice pi = (ProjectInvoice)request.getAttribute("ProjectInvoice");
	List currencyList = (List)request.getAttribute("Currency");
	
	String Invoice = request.getParameter("invoice");
	String Billing = request.getParameter("billing");
	String Project = request.getParameter("project");
	String BillAddress = request.getParameter("billAddress");
	String Status = request.getParameter("status");
	//String DateFrom = request.getParameter("dateFrom");
	//String DateTo = request.getParameter("dateTo");
	String Department = request.getParameter("department");
	String rateStr ="";
	//Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();

	//if (DateFrom == null || DateFrom.trim().length() == 0) DateFrom = Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
	//if (DateTo == null || DateTo.trim().length() == 0) DateTo = Date_formater.format(nowDate);
	
	//Date dayStart = UtilDateTime.toDate2(DateFrom + " 00:00:00.000");
	//Date dayEnd = UtilDateTime.toDate2(DateTo + " 00:00:00.000");
	
	if (Invoice == null) {
		Invoice = "";
	}
	if (Billing == null) {
		Billing = "";
	}
	if (Project == null) {
		Project = "";
	}
	if (BillAddress == null) {
		BillAddress = "";
	}
	if (Status == null) {
		Status = "";
	}
	if (Department == null) {
		Department = "";
	}
%>
<HTML>
	<HEAD>
	
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
	<%@ include file="updateInvoicePage.jsp" %>
	</body>
</html>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception ex) {ex.printStackTrace();}
%>
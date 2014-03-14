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
	//List currencyList = (List)request.getAttribute("Currency");
	
	String Invoice = request.getParameter("invoice");
	String Billing = request.getParameter("billing");
	String Project = request.getParameter("project");
	String BillAddress = request.getParameter("billAddress");
	String Status = request.getParameter("status");
	//String DateFrom = request.getParameter("dateFrom");
	//String DateTo = request.getParameter("dateTo");
	String Department = request.getParameter("department");
	if (Department == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			Department = userLogin.getParty().getPartyId();
		}
	}
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

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

ProjectHelper projHelper = new ProjectHelper();
List currencyList = projHelper.getAllCurrency(hs);
if(currencyList==null){
	currencyList = new ArrayList();
}
Iterator itCurr = currencyList.iterator();
String rateStr = "";
while(itCurr.hasNext()){
	com.aof.component.prm.project.CurrencyType curr = (com.aof.component.prm.project.CurrencyType)itCurr.next();
	rateStr = rateStr+curr.getCurrRate().toString()+"$";
}
%>
<%
	if ("maintenance".equals(request.getParameter("process"))) {
%>
<form name="backForm" action="findInvoice.do" method="post">

<%
	} else if ("confirmation".equals(request.getParameter("process"))) {
%>
<form name="backForm" action="findInvoiceConfirm.do" method="post">
<%
	} else if ("receipt".equals(request.getParameter("process"))) {
%>
<form name="backForm" action="findReceipt.do" method="post">
<%
	}
%>
	<input type="hidden" name="formAction" value="query">
	<input type="hidden" name="process" value="<%=request.getParameter("process")%>">
	<input type="hidden" name="invoice" value="<%=Invoice%>">
	<input type="hidden" name="billing" value="<%=Billing%>">
	<input type="hidden" name="project" value="<%=Project%>">
	<input type="hidden" name="billAddress" value="<%=BillAddress%>">
	<input type="hidden" name="status" value="<%=Status%>">
	<input type="hidden" name="department" value="<%=Department%>">
</form>
<%
	if (pi == null || pi.getId() == null) {
%>
	<%@ include file="newInvoicePage.jsp" %>
<%
	} else {
%>
	<%@ include file="updateInvoicePage.jsp" %>
<%
	}
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception ex) {ex.printStackTrace();}
%>
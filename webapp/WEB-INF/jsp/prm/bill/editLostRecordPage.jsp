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
if (AOFSECURITY.hasEntityPermission("PROJ_LOST", "_CREATE", session)) {

	SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
	
	ProjectInvoice pi = (ProjectInvoice)request.getAttribute("ProjectInvoice");
	
	String qryBillCode = request.getParameter("qryBillCode");
	String qryProject = request.getParameter("qryProject");
	//String qryDateFrom = request.getParameter("qryDateFrom");
	//String qryDateTo = request.getParameter("qryDateTo");
	String qryDepartment = request.getParameter("qryDepartment");
	
	if (qryDepartment == null) {
		UserLogin userLogin = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		if (userLogin != null) {
			qryDepartment = userLogin.getParty().getPartyId();
		}
	}
	
	//Date nowDate = (java.util.Date)UtilDateTime.nowTimestamp();
	
	//if (qryDateFrom == null || qryDateFrom.trim().length() == 0) qryDateFrom = Date_formater.format(UtilDateTime.getDiffDay(nowDate,-30));
	//if (qryDateTo == null || qryDateTo.trim().length() == 0) qryDateTo = Date_formater.format(nowDate);
	
	//Date dayStart = UtilDateTime.toDate2(qryDateFrom + " 00:00:00.000");
	//Date dayEnd = UtilDateTime.toDate2(qryDateTo + " 00:00:00.000");
	CurrencyType currency = null;
	Float exchangeRate = null;
	if(pi != null){
	   currency = pi.getCurrency();
	   exchangeRate = pi.getCurrencyRate();
	}
	List currencyList = (List)request.getAttribute("Currency");
	if(currencyList==null){
		currencyList = new ArrayList();
	}
	Iterator itCurr = currencyList.iterator();
	String rateStr = "";
	while(itCurr.hasNext()){
		com.aof.component.prm.project.CurrencyType curr = (com.aof.component.prm.project.CurrencyType)itCurr.next();
		rateStr = rateStr+curr.getCurrRate().toString()+"$";
	}
	
	if (qryProject == null) {
		qryProject = "";
	}
	if (qryBillCode == null) {
		qryBillCode = "";
	}
	if (qryDepartment == null) {
		qryDepartment = "";
	}
%>
<form name="backForm" action="findLost.do" method="post">
	<input type="hidden" name="formAction" value="query">
	<input type="hidden" name="qryBillCode" value="<%=qryBillCode%>">
	<input type="hidden" name="qryProject" value="<%=qryProject%>">
	<input type="hidden" name="qryDepartment" value="<%=qryDepartment%>">
</form>
<%
	if (pi == null || pi.getId() == null) {
%>
	<%@ include file="newLostRecordPage.jsp" %>
<%
	} else {
%>
	<%@ include file="updateLostRecordPage.jsp" %>
<%
	}
}else{
	out.println("!!你没有相关访问权限!!");
}
} catch(Exception ex) {ex.printStackTrace();}
%>
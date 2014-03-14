<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="org.apache.commons.logging.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.webapp.action.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="net.sf.hibernate.*"%>
<%@ page import="net.sf.hibernate.type.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/VIJSFunction.js'></script>
<%
if (AOFSECURITY.hasEntityPermission("SALES_FUNNEL", "_CREATE", session)) {	
	NumberFormat Num_formater = NumberFormat.getInstance();
	Num_formater.setMaximumFractionDigits(2);
	Num_formater.setMinimumFractionDigits(2);
	SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	String bidActId = request.getParameter("bidActId");
	String bidId = request.getParameter("bidId");
	String formAction = request.getParameter("FormAction");
	Set BidActDetailList = (Set)request.getAttribute("BidActDetailList");
	BidMaster bm = (BidMaster)request.getAttribute("bidMaster");
	if(BidActDetailList==null){
		BidActDetailList = new HashSet();
	}
	if(formAction == null){
		formAction = "view";
	}
%>
<HTML>
	<HEAD>
	
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		
<script language="javascript">

</script>
	</HEAD>

<form action="EditBidActDet.do" method="post" name="EditForm">
<table width=100% cellpadding="1" border="0" cellspacing="1">
	<CAPTION align=center class=pgheadsmall>Bid Activity List</CAPTION>
	<tr>
		<td align="left" class="lblbold" bgcolor="#e9eee9" width="20%">Assignee</td>
		<td align="left" class="lblbold" bgcolor="#e9eee9" width="20%">Action Date</td>
		<td align="left" class="lblbold" bgcolor="#e9eee9" width="15%">Hours</td>
		<td align="left" class="lblbold" bgcolor="#e9eee9"  >Your Efforts</td>
		<td align="left" class="lblbold" bgcolor="#e9eee9"  >Action</td>
	</tr>
	<%
		Iterator itst = BidActDetailList.iterator();
		int cc = 0;
		int sumHr = 0;
		if (BidActDetailList.size()> 0){
			int count =0;
			
			while (itst.hasNext()){
				BidActDetail bad = (BidActDetail)itst.next();
				sumHr = bad.getHours().intValue()+sumHr;
	%>
		<tr >
	        <td bgcolor="#e9eef9">
		       	<div style="display:inline" id="AssigneeName"><%=bad.getAssignee().getName()%></div>
	        </td>
	        <td bgcolor="#e9eef9"><%=formater.format(bad.getActionDate())%></td>
        	<td bgcolor="#e9eef9"><%=Num_formater.format(bad.getHours())%>
        	</td>
        	<td bgcolor="#e9eef9">
				<textarea name="actionDesc" cols="60" rows="2" disabled><%=bad.getDescription()%></textarea>
			</td>
			<td bgcolor="#e9eef9">&nbsp;</td>
			<td>&nbsp;</td>
        </tr>
	<%
				count=count+1;
				cc=cc+1;
			}
		}
	%>

	
		<tr>
			<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
		</tr>
	    <tr>
	    	<td colspan = 3>
				<input type="button" value="Close" class="loginButton" onclick="window.close()">
			</td>
        </tr>		
		
</table>
</form>
</HTML>
<%	
	}else{
		out.println("!!你没有相关访问权限!!");
	}
%>
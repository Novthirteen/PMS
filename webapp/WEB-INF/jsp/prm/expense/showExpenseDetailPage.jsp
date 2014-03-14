<%@ page contentType="text/html; charset=gb2312"%>
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
<%
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();

SimpleDateFormat Date_formater = new SimpleDateFormat("yyyy-MM-dd");
ExpenseMaster findmaster = (ExpenseMaster)request.getAttribute("findmaster");
List DateList = (List)request.getAttribute("DateList");
if(DateList==null){
	DateList = new ArrayList();
} 

List detailList = (List)request.getAttribute("detailList");
if(detailList==null){
	detailList = new ArrayList();
}

List ExpTypeList = hs.createQuery("select et from ExpenseType as et order by et.expSeq ASC").list();
if(ExpTypeList==null){
	ExpTypeList = new ArrayList();
}

List CommentsList = (List)request.getAttribute("CommentsList");
if(CommentsList==null){
	CommentsList = new ArrayList();
}

List AmountList = (List)request.getAttribute("AmountList");
if(AmountList==null){
	AmountList = new ArrayList();
}
UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
%>
<HTML>
	<HEAD>
		<title>AO-SYSTEM</title>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
	</HEAD>
	
	<BODY>
		<table width=100% cellpadding="1" border="0" cellspacing="1" >
			<CAPTION align=center class=pgheadsmall>Expense Detail</CAPTION>
			<tr>
				<td>
					<TABLE width="100%">
						<tr>
							<td colspan=8><hr color=red></hr></td>
						</tr>
						<tr>
							<td class="lblbold" align=right>Form Code :</td>
							<td class="lblLight"><%=findmaster.getFormCode()%></td>
							<td class="lblbold" align=right>Deparment :</td>
							<td class="lblLight"><%=findmaster.getExpenseUser().getParty().getDescription()%></td>
							<td class="lblbold" align=right>User:</td>
							<td class="lblLight"><%=ul.getName()%></td>
							<td class="lblbold" align=right>Status:</td>
							<td class="lblLight"><%=findmaster.getStatus()%>
						</tr>
						<tr>
							<td class="lblbold" align=right>Entry Period:</td>
							<td class="lblLight"><%=Date_formater.format(findmaster.getEntryDate())%>&nbsp;</td>
							<td class="lblbold" align=right>Expense Period:</td>
							<td class="lblLight"><%=Date_formater.format(findmaster.getExpenseDate())%>&nbsp;</td>
							<td class="lblbold" align=right>Currency:</td>
							<td class="lblLight"><%=findmaster.getExpenseCurrency().getCurrId()%></td>
							<td class="lblbold" align=right>Exchange Rate(RMB):</td>
							<td class="lblLight"><%=findmaster.getCurrencyRate()%></td>
						</tr>
						<tr>
							<td class="lblbold" align=right>Project:</td>
							<td class="lblLight">
								<%=findmaster.getProject().getProjId()%>:<%=findmaster.getProject().getProjName()%>								
							</td>
							<td class="lblbold" align=right>Customer:</td>
							<td class="lblLight">
								<%=findmaster.getProject().getCustomer().getDescription()%>&nbsp;
							</td>
							<td class="lblbold" align=right>Paid By :</td>
							<td class="lblLight">
								<%if (findmaster.getClaimType().equals("CY")) {
									out.println("Customer");
								} else {
									out.println("Company");
								}%>
							</td>
							<td class="lblbold" align=right>&nbsp;</td>
							<td class="lblLight">&nbsp;</td>
						</tr>
						<tr>
							<td colspan=8><hr color=red></hr></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table border="0" cellpadding="2" cellspacing="2" width="100%">
						<tr bgcolor="#e9eee9">
							<td class="lblbold" align="center">&nbsp;</td>
							<%
								int ExpLevel= 0;
								Iterator itExpType = ExpTypeList.iterator();
								while(itExpType.hasNext()){
									ExpenseType et = (ExpenseType)itExpType.next();
									ExpLevel= et.getExpSeq().length();
							%>
							<td class="lblbold" align="center">
								<%=et.getExpDesc()%>
							</td>
							<%
								}
							%>
							<td class="lblbold" align="center">Total</td>
							<td class="lblbold" align="center">Comments</td>
						</tr>
						
						<%
							boolean NullData = true;
							int i=0;
							float RowTotal = 0;
							Iterator itDetail = detailList.iterator();
							ExpenseDetail ed = null;
							if (itDetail.hasNext()) {
								ed = (ExpenseDetail)itDetail.next();
							}

							Iterator itCmts = CommentsList.iterator();
							ExpenseComments ec = null;
							if (itCmts.hasNext()) {
								ec = (ExpenseComments)itCmts.next();
							}

							Iterator itDate = DateList.iterator();
							while(itDate.hasNext()){
								Date fd = (Date)itDate.next();
						%>
						<tr bgcolor="#e9eee9">
							<td class="lblbold">
								<%=Date_formater.format(fd)%>								
						</td>
						<%
								itExpType = ExpTypeList.iterator();
								RowTotal = 0;
								while(itExpType.hasNext()){
									ExpenseType et = (ExpenseType)itExpType.next();
									NullData = false;
									if (ed != null) {
										if (ed.getExpenseDate().equals(fd) && ed.getExpType().equals(et)) {
											RowTotal = RowTotal + ed.getUserAmount().floatValue();
						%>
							<td>
								<%=ed.getUserAmount()%>
							</td>
						<%
											if (itDetail.hasNext()) {
												ed = (ExpenseDetail)itDetail.next();
											}
										} else {
											NullData = true;
										}
									} else {
										NullData = true;
									}
									if (NullData) {
						%>
							<td>&nbsp;</td>
						<%	
									}
								}
						%>
							<td class="lblbold">
								<%=RowTotal%>
							</td>
						<%
								NullData = false;
								if (ec != null) {
									if (ec.getExpenseDate().equals(fd)) {
						%>
							<td>
								<%=ec.getComments()%>
							</td>
						<%
										if (itCmts.hasNext()) {
											ec = (ExpenseComments)itCmts.next();
										}
									} else {
										NullData = true;
									}
								} else {
									NullData = true;
								}
								if (NullData) {
						%>
							<td>&nbsp;</td>
						<%
								}
						%>
						<% 
								i++;
							}
						%>
						<tr align="center" bgcolor="#e9eee9">
							<td align="left" class="lblbold">Total (Staff):</td>
						<%
							Iterator itAmt = AmountList.iterator();
							ExpenseAmount ea = null;
							if (itAmt.hasNext()) {
								ea = (ExpenseAmount)itAmt.next();
							}
							itExpType = ExpTypeList.iterator();
							RowTotal = 0;
							while(itExpType.hasNext()){
								ExpenseType et = (ExpenseType)itExpType.next();
								String AmtStr = "&nbsp;";
								String RecId = "";
								if (ea != null) {
									if (ea.getExpType().equals(et)) {
										RecId = ea.getId().toString();
										if (ea.getUserAmount() != null) {
											AmtStr = ea.getUserAmount().toString();
											RowTotal = RowTotal + ea.getUserAmount().floatValue();
										}
										if (itAmt.hasNext()) {
											ea = (ExpenseAmount)itAmt.next();
										}
									}
								} 
						%>
							<td align="left" class="lblbold">
								<%=AmtStr%>
							</td>
						<%
							}
						%>
							<td align="left" class="lblbold"><%=RowTotal%></td>
							<td>&nbsp;</td>
						</tr>
						<tr align="center" bgcolor="#e9eee9">
							<td align="left" class="lblbold">Total (Verified):</td>
						<%
							itAmt = AmountList.iterator();
							if (itAmt.hasNext()) {
								ea = (ExpenseAmount)itAmt.next();
							}
							itExpType = ExpTypeList.iterator();
							RowTotal = 0;
							while(itExpType.hasNext()){
								ExpenseType et = (ExpenseType)itExpType.next();
								String AmtStr = "0";
								String RecId = "";
								if (ea != null) {
									if (ea.getExpType().equals(et)) {
										RecId = ea.getId().toString();
										if (ea.getConfirmedAmount() != null) {
											AmtStr = ea.getConfirmedAmount().toString();
											RowTotal = RowTotal + ea.getConfirmedAmount().floatValue();
										}
										if (itAmt.hasNext()) {
											ea = (ExpenseAmount)itAmt.next();
										}
									}
								} 
						%>
							<td align="left" class="lblbold"><%=AmtStr%></td>
						<%
							}
						%>
							<td align="left" class="lblbold"><%=RowTotal%></td>
							<td>&nbsp;</td>
						</tr>
						<tr align="center" bgcolor="#e9eee9">
							<td align="left" class="lblbold">Total (Claimed):</td>
						<%
							itAmt = AmountList.iterator();
							if (itAmt.hasNext()) {
								ea = (ExpenseAmount)itAmt.next();
							}
							itExpType = ExpTypeList.iterator();
							RowTotal = 0;
							while(itExpType.hasNext()){
								ExpenseType et = (ExpenseType)itExpType.next();
								String AmtStr = "&nbsp;";
								if (ea != null) {
									if (ea.getExpType().equals(et)) {
										if (ea.getPaidAmount() != null) {
											AmtStr = ea.getPaidAmount().toString();
											RowTotal = RowTotal + ea.getPaidAmount().floatValue();
										} else {
											AmtStr = ea.getConfirmedAmount().toString();
											RowTotal = RowTotal + ea.getConfirmedAmount().floatValue();
										}
										if (itAmt.hasNext()) {
											ea = (ExpenseAmount)itAmt.next();
										}
									}
								} 
						%>
							<td align="left" class="lblbold">
								<%=AmtStr%>
							</td>
						<%
							}
						%>
							<td align="left" class="lblbold" id='tTot'>
								<%=RowTotal%>
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr align="center">
							<td align="left" colspan="7">
								<input type="button" class="button" name="close" value="Close" onclick="window.parent.close();">
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>
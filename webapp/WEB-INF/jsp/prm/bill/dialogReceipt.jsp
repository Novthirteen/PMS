<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.webapp.action.PageBean"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld"prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld"prefix="tiles"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>

<script>
function returnValue() {
    
	var formObj = document.frm;
	var count;
	count=0;
	if (formObj.chk != null) {
		if(formObj.chk.length) {
			for(var i=0;i<formObj.chk.length;i++) {
				if(formObj.chk[i].checked) {
					count++;
					window.parent.returnValue = formObj.chk[i].value + "|" + 
												formObj.receiptNo[i].value + "|" +
												formObj.receiptAmount[i].value + "|" +
												formObj.customerString[i].value + "|" +
												formObj.currencyString[i].value + "|" +
												formObj.exchangeRate[i].value + "|" +
												formObj.receiptDateString[i].value + "|" +
												formObj.remainAmount[i].value+"|"+
												formObj.faReceiptno[i].value+"|"+
												formObj.receiptType[i].value;
					window.parent.close();
				}
			}
		} else {
			if(formObj.chk.checked) {
				count++;
				window.parent.returnValue = formObj.chk.value + "|" + 
												formObj.receiptNo.value + "|" +
												formObj.receiptAmount.value + "|" +
												formObj.customerString.value + "|" +
												formObj.currencyString.value + "|" +
												formObj.exchangeRate.value + "|" +
												formObj.receiptDateString.value + "|" +
												formObj.remainAmount.value+"|"+
												formObj.faReceiptno.value+"|"+
												formObj.receiptType.value;
				window.parent.close();
			}
		}
	}
	if(count==0){
		alert("Choose a option")
		return;
	}
}
function fnSubmit1()
{
	var formObj = document.frm;
	formObj.elements["pageNumber"].value = "";
	formObj.submit();
}
</script>
<%
NumberFormat numFormat = NumberFormat.getInstance();
	numFormat.setMaximumFractionDigits(2);
	numFormat.setMinimumFractionDigits(2);
if (true) {
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	String receiptNo = request.getParameter("ReceiptNo");
	String receiptCustomer = request.getParameter("ReceiptCustomer");
	ReceiptService service = new ReceiptService();
	if (receiptNo == null) receiptNo ="";
	if (receiptCustomer == null) receiptCustomer ="";
	String pageNumber=request.getParameter("pageNumber");
	if(pageNumber == null ) pageNumber = "";
	
	/*
	PageBean pageBean = (PageBean)request.getAttribute("UserPageBean");
	if(pageBean == null){
		request.setAttribute("UserPageBean",new PageBean());
	} 
	*/
%>
<form action="dialogReceiptList.do" method="POST" name=frm>
<title>Receipt Selection</title>
<input type="hidden" name="pageNumber" value="<%=pageNumber%>">
<input type="hidden" name="FormAction">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Receipt Select</CAPTION>
</table>
<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
	<tr bgcolor="e9eee9">
		<td class=lblbold>
			&nbsp;					
		</td>
		<td class=lblbold>Receipt No.</td>
		<td class=lblbold>Receipt Currency.</td>
		<td class=lblbold>Receipt Amount</td>
		<td class=lblbold>Remaining Amount (RMB)</td>
		<td class=lblbold>Customer</td>
	</tr>
		<bean:define id="offset" name="UserPageBean" property="offset" />
		<bean:define id="maxPage" name="UserPageBean"  property="maxPage" />		

		<logic:iterate id="ItemList"  name="UserPageBean" property="itemList" type="com.aof.component.prm.Bill.ProjectReceiptMaster" indexId="index" length="<%=maxPage.toString()%>" offset="<%=offset.toString()%>" >								
			<tr class="listbody">
			
				<td>
				<input type=radio name=chk value="<bean:write property="receiptNo" name="ItemList"/>"/>
				</td> 
				<td><bean:write property="receiptNo" name="ItemList"/></td>
				<%
					String no =  ItemList.getReceiptNo();
				%>
				<td><%=ItemList.getCurrency().getCurrId()%></td>
				<td><%=numFormat.format(ItemList.getReceiptAmount())%></td>
				<td><%=numFormat.format(ItemList.getRemainAmount())%></td>
				<td><bean:write property="customerString" name="ItemList"/></td>
				<input type="hidden" name="receiptNo" value="<bean:write name="ItemList" property="receiptNo"/>">
				<input type="hidden" name="receiptType" value="<bean:write name="ItemList" property="receiptType"/>">
				<input type="hidden" name="receiptAmount" value="<%=numFormat.format(ItemList.getReceiptAmount())%>">
				<input type="hidden" name="customerString" value="<bean:write name="ItemList" property="customerString"/>">
				<input type="hidden" name="currencyString" value="<bean:write name="ItemList" property="currencyString"/>">
				<input type="hidden" name="exchangeRate" value="<bean:write name="ItemList" property="exchangeRate"/>">
				<input type="hidden" name="faReceiptno" value="<bean:write name="ItemList" property="faReceiptNo"/>">
				<input type="hidden" name="receiptDateString" value="<%=ItemList.getReceiptDate()==null?"":formatter.format(ItemList.getReceiptDate())%>"/>
				<%
				Double remainAmount = new Double(0.0);
				if(no != null && !no.equals("")){
					ProjectReceiptMaster prm = service.getView(no);
					//System.out.print("prm = " + prm + " " + no + " ");
					remainAmount = service.getRemainAmount(prm);
					//System.out.println("RemainAmout = "+remainAmount);
				}
				%>
				<input type="hidden" name="remainAmount" value="<%=numFormat.format(remainAmount.doubleValue())%>">
			</tr>
		</logic:iterate>
	<tr>
		<td colspan=5 align=center>
			<input type=button name="save" class=button value="Select" onclick="javascript:returnValue()">&nbsp;&nbsp;
			&nbsp;&nbsp;
			<input type=button name="close" class=button value="Cancel" onclick="javascript:window.parent.close()">
		</td>
	</tr>
	<tr>
		<td colspan=5 align=center>
		<bean:define id="totalPage" name="UserPageBean" property="allPage" />
		Total Pages: <%=totalPage %> &nbsp;&nbsp;
		<logic:iterate id="PageNumberList"  name="PageNumberList" >
			<logic:equal name="PageNumberList" property="pageLink" value="0">
				<bean:write name="PageNumberList" property="pageNumber" />
			</logic:equal>					
			<logic:notEqual name="PageNumberList" property="pageLink" value="0">
				<html:link page="/dialogReceiptList.do" paramId="pageNumber" paramName="PageNumberList" paramProperty="pageLink">
					<bean:write name="PageNumberList" property="pageNumber" />
				</html:link>
			</logic:notEqual>
			&nbsp
		</logic:iterate>
		</td>
	</tr>	
	<tr>
      <td colspan=5>
         <table align=center border=0 cellspacing=1 cellpadding=5  rules=none>
         <tr>
          <td class=LblBold>Search for Receipt No.</td>
          <td><input type="text" name="ReceiptNo" size=15 maxlength=20 value='<%=receiptNo%>'></td>
          <td><input type="button" class="button" name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
		 <tr>
          <td class=LblBold>Search for Customer</td>
          <td><input type="text" name="ReceiptCustomer" size=15 maxlength=20 value='<%=receiptCustomer%>'></td>
          <td><input type='button' class='button' name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
		 <tr>
		  <td class=LblBold>Customer Filter</td>
   		  <td><input class='checkboxstyle' type='checkbox' name='custFilter' value='1'>Show All Customers</td>
   		  <td><input type='button' class='button' name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
   		 </tr>
         </table>
      </td>
   </tr>

</table>
</form> 
<%
	Hibernate2Session.closeSession();
	service.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>

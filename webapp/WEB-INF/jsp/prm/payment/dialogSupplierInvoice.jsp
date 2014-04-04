<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="com.aof.component.prm.payment.*"%>
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
												formObj.payCode[i].value + "|" +
												formObj.vendorString[i].value + "|" +
												formObj.payAmount[i].value + "|" +
												formObj.currencyString[i].value + "|" +
												formObj.exchangeRate[i].value + "|" +
												formObj.payDateString[i].value + "|" +
												formObj.remainAmount[i].value+"|"+
												formObj.faPaymentno[i].value+"|"+
												formObj.payType[i].value;
					window.parent.close();
				}
			}
		} else {
			if(formObj.chk.checked) {
				count++;
				window.parent.returnValue = formObj.chk.value + "|" + 
												formObj.payCode.value + "|" +
												formObj.vendorString.value + "|" +
												formObj.payAmount.value + "|" +
												formObj.currencyString.value + "|" +
												formObj.exchangeRate.value + "|" +
												formObj.payDateString.value + "|" +
												formObj.remainAmount.value+"|"+
												formObj.faPaymentno.value+"|"+
												formObj.payType.value;
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
if (true) {
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	String payCode = request.getParameter("PayCode");
	String payVendor = request.getParameter("PayVendor");
	PaymentMasterService service = new PaymentMasterService();
	if (payCode == null) payCode ="";
	if (payVendor == null) payVendor ="";
	String pageNumber=request.getParameter("pageNumber");
	if(pageNumber == null ) pageNumber = "";
	
	/*
	PageBean pageBean = (PageBean)request.getAttribute("UserPageBean");
	if(pageBean == null){
		request.setAttribute("UserPageBean",new PageBean());
	} 
	*/
%>
<form action="dialogSupplierInvoiceList.do" method="POST" name=frm>
<title>Supplier Invoice Selection</title>
<input type="hidden" name="pageNumber" id="pageNumber" value="<%=pageNumber%>">
<input type="hidden" name="FormAction" id="FormAction">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Supplier Invoice Select</CAPTION>
</table>
<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
	<tr bgcolor="e9eee9">
		<td class=lblbold>&nbsp;
								
		</td>
		<td class=lblbold>Payment Code</td>
		<td class=lblbold>Payment Amount</td>
		<td class=lblbold>Remaining Amount</td>
		<td class=lblbold>Vendor</td>
	</tr>
		<bean:define id="offset" name="UserPageBean" property="offset" />
		<bean:define id="maxPage" name="UserPageBean"  property="maxPage" />		

		<logic:iterate id="ItemList"  name="UserPageBean" property="itemList" type="com.aof.component.prm.payment.ProjectPaymentMaster" indexId="index" length="<%=maxPage.toString()%>" offset="<%=offset.toString()%>" >								
			<tr class="listbody">
			
				<td>
				<input type=radio name=chk value="<bean:write property="payCode" name="ItemList"/>"/>
				</td> 
				<td><bean:write property="payCode" name="ItemList"/></td>
				<%
					String no =  ItemList.getPayCode();
				%>
				<td><bean:write property="payAmount" name="ItemList"/></td>
				<td><bean:write property="remainAmountString" name="ItemList"/></td>
				<td><bean:write property="vendorString" name="ItemList"/></td>
				<input type="hidden" name="payCode" id="payCode" value="<bean:write name="ItemList" property="payCode"/>">
				<input type="hidden" name="payType" id="payType" value="<bean:write name="ItemList" property="payType"/>">
				<input type="hidden" name="payAmount" id="payAmount" value="<bean:write name="ItemList" property="amountString"/>">
				<input type="hidden" name="vendorString" id="vendorString" value="<bean:write name="ItemList" property="vendorString"/>">
				<input type="hidden" name="currencyString" id="currencyString" value="<bean:write name="ItemList" property="currencyString"/>">
				<input type="hidden" name="exchangeRate" id="exchangeRate" value="<bean:write name="ItemList" property="exchangeRate"/>">
				<input type="hidden" name="faPaymentno" id="faPaymentno" value="<bean:write name="ItemList" property="faPaymentNo"/>">
				<input type="hidden" name="payDateString" id="payDateString" value="<%=ItemList.getPayDate()==null?"":formatter.format(ItemList.getPayDate())%>"/>
				
				<input type="hidden" name="remainAmount" id="remainAmount" value="<bean:write name="ItemList" property="remainAmountString"/>">
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
				<html:link page="/dialogSupplierInvoiceList.do" paramId="pageNumber" paramName="PageNumberList" paramProperty="pageLink">
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
          <td class=LblBold>Search for Pay Code</td>
          <td><input type="text" name="PayCode" size=15 maxlength=20 value='<%=payCode%>'></td>
          <td><input type="button" class="button" name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
		 <tr>
          <td class=LblBold>Search for Vendor</td>
          <td><input type="text" name="PayVendor" size=15 maxlength=20 value='<%=payVendor%>'></td>
          <td><input type='button' class='button' name='btn1' value='Go' onclick='javascript:fnSubmit1()'></td>
         </tr>
		 <tr>
		  <td class=LblBold>Vendor Filter</td>
   		  <td><input class='checkboxstyle' type='checkbox' name='vendorFilter' value='1'>Show Vendors</td>
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

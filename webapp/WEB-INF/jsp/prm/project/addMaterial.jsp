<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.Bill.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld"prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld"prefix="tiles"%>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
	String close = (String)request.getAttribute("CLOSE");
	if (close != null && close.equals("TRUE")) {
%>

<script language="javascript">
	window.close();
</script>

<%
	} else {
%>
<%
//if (AOFSECURITY.hasEntityPermission("CUST_PROJECT_MEMBER", "_CREATE", session)) {
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();   
//List depList=null;

String option = request.getParameter("option");
String projId = request.getParameter("hiddenDataId");
String action = (String)request.getAttribute("action");
BillingMaterial material  = (BillingMaterial)request.getAttribute("BillingMaterial");
List ItemList = (List)request.getAttribute("TransactionList");
if(ItemList==null)
	ItemList = new LinkedList();
boolean mark =false;
if((action!=null)&&(action.equalsIgnoreCase("edit")))
	mark = true;
String billcode="";
if((material!=null)&&(material.getBillling()!=null))
	billcode = material.getBillling().getBillCode();
boolean flag=true;
if((billcode==null)||(billcode.length()<1))
flag=false;
List servicetype = (List)request.getAttribute("servicetype");
SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
if(servicetype==null)
servicetype = new LinkedList();
NumberFormat nf = NumberFormat.getInstance();
nf.setMaximumFractionDigits(2);
nf.setMinimumFractionDigits(0);
NumberFormat Num_formater = NumberFormat.getInstance();
Num_formater.setMaximumFractionDigits(0);
Num_formater.setMinimumFractionDigits(0);

%>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>

<form action="addMaterial.do" method="POST" name="selForm">

<IFRAME frameBorder=0 id=CalFrame marginHeight=0 
	marginWidth=0 noResize 
	scrolling=no src="includes/date/calendar.htm" 
	style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100">
</IFRAME>

<input type="hidden" name="option" value="<%=option%>">
<input type="hidden" name="projId" value="<%=projId%>">
<table width=100% align=center>
	<CAPTION align=center class=pgheadsmall>Service Delivery Detail</CAPTION>
</table>
<input type="hidden" name='stlength' value="<%=servicetype.size()%>">

<table width=100% align=center Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
<% if(mark){%>
<TR>
<td align="left" width='10' class="lblbold">Index:</td>
<td width='10'><%=material.getIndex()%></td>
<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
</TR>
<tr >
<input type="hidden" name='materialid' value='<%=material.getId()%>'>
<td align="left" width='10' class="lblbold">Acceptance Date:</td>
<td colspan=2><input type="text" name='modifydate' class="inputBox" size='10' value='<%=formater.format(material.getCreateDate())%>'>
          <A href="javascript:ShowCalendar(document.selForm.dimg6,document.selForm.modifydate,null,0,530)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg6 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A>
</td>
<td align="left" width='10'&nbsp;></td>
<td width='10'>&nbsp;</td>
<td width='10'>&nbsp;</td>
</tr>
<tr>
<td align="left" width='10' class="lblbold">Service Delivery Description:</td>
<td align="center" colspan='3' ><input type="text" size='100' name = 'descname' value='<%=material.getDescription()%>'></td>
<td width='10'>&nbsp;</td>
</tr >
<%}else{%>
<tr><td align="left" width='10' class="lblbold">Index:</td>
<td >&nbsp;</td><td >&nbsp;</td><td >&nbsp;</td><td >&nbsp;</td>
</tr>
<tr >
<td align="left" width='10' class="lblbold">Acceptance Date:</td>
<td colspan=2><input type="text" name='modifydate' class="inputBox" size='10' value='<%=formater.format(Calendar.getInstance().getTime())%>'>
          <A href="javascript:ShowCalendar(document.selForm.dimg6,document.selForm.modifydate,null,0,530)" 
							onclick=event.cancelBubble=true;><IMG align=absMiddle border=0 id=dimg6 src="<%=request.getContextPath()%>/images/datebtn.gif" ></A></td>
<td align="left" >&nbsp;</td>
<td >&nbsp;</td>
<td >&nbsp;</td>
</tr>
<tr>
<td align="left" width='10' class="lblbold">Service Delivery Description:</td>
<td colspan='3'><input type="text" name = 'descname' size='100'></td>
<td width='10'>&nbsp;</td>
</tr >
<%}%>
<tr>
	<td colspan=5 valign="top"><hr color=red></hr></td>
</tr>
<tr>
<td class=wpsPortletTopTitle align="center" width='10' nowrap>Item</td>
<td class=wpsPortletTopTitle align="center" width='10' nowrap>UnitPrice</td>
<td class=wpsPortletTopTitle align="center" width='10' nowrap>Quantity</td>
<td class=wpsPortletTopTitle align="center" width='10' nowrap>SubTotal</td>
<td class=wpsPortletTopTitle align="center" width='10' nowrap>Description</td>
</tr>
<%if(mark){
	String read="";
	if(flag)
		read="readonly='true'";
	for(int i=0;i<ItemList.size();i++){		
		MOBillTransactionDetail tr = (MOBillTransactionDetail)ItemList.get(i);
		long trid = tr.getTransactionId().longValue();	
		System.out.println("trid:"+trid);
		long typeid = tr.getSerivcetypeid().longValue();		
		String type = tr.getDesc();	//service type description
		long index = tr.getTransactionIndex().longValue();
		double subtotal = tr.getSubtotal().doubleValue();
		String desc = tr.getDesc2();
		long quantity = tr.getQuantity().longValue();
		double price = tr.getPrice().doubleValue();
%>
		<tr>
		<input type="hidden" name='record'>
		<input type="hidden" name='typeid' value='<%=typeid%>' >
		<input type="hidden" name='trid' value='<%=trid%>'>
		<td ><input type="text" size='30' name = 'type'     value='<%=type%>'   readonly='true' style='border:0px;background-color:#e9eee9'></td>
		<td ><input type="text" size='30' name = 'price'    value='<%=nf.format(price)%>'  readonly='true' style='border:0px;background-color:#e9eee9;text-align:right'></td>
		<td ><input type="text" size='30' name = 'quantity' oldvalue='<%=nf.format(quantity)%>' value='<%=nf.format(quantity)%>' onchange="javascript:changeprice('<%=i%>')"  <%=read%> style='text-align:right'></td>
		<td ><input type="text" size='30' name = 'subtotal' value='<%=nf.format(subtotal)%>' readonly='true' style='border:1px;background-color:#e9eee9;text-align:right'></td>
		<td ><input type="text" size='30' name = 'desc'     value='<%=desc%>' <%=read%> ></td>
		</tr>
<%}}else{%>
<%
	for(int i=0;i<servicetype.size();i++)
		{
				ServiceType st = (ServiceType)servicetype.get(i);
				Long stid = st.getId();
				String type = st.getDescription();
				double price = st.getRate().doubleValue();
				int quantity = st.getEstimateManDays().intValue();
				String desc = st.getDescription();
%>
		<tr>
		<input type="hidden" name='record'>
		<input type="hidden" name='typeid' value='<%=stid%>' >
		<td width='10'><input type="text"  size='30' name = 'type'     value='<%=type%>'   readonly='true' style='border:0px;background-color:#e9eee9'></td>
		<td width='10'><input type="text"  size='30' name = 'price'    value='<%=nf.format(price)%>'  readonly='true' style='border:0px;background-color:#e9eee9;text-align:right'></td>
		<td width='10'><input type="text"  size='30' name = 'quantity' oldvalue='0' value='0' onchange="javascript:changeprice('<%=i%>')"   style='text-align:right'></td>
		<td width='10'><input type="text"  size='30' name = 'subtotal' value='0' readonly='true' style='border:0px;background-color:#e9eee9;text-align:right'></td>
		<td width='10'><input type="text"  size='30' name = 'desc'     value=''  ></td>
		</tr>
<%			}}
%>
<tr>
<td colspan='2'></td>
<td class="lblbold">Total :</td>
<%if(mark){%>
<td ><input type="text" name = 'total' style='border:0px;background-color:#ffffff;text-align:right' 	value='<%=material.getAmount()%>' ></td>
<%}else{%>
<td ><input type="text" name = 'total' style='border:0px;background-color:#ffffff;text-align:right' 	value='0' ></td>
<%}%>
</tr>
	<tr>
		<td  align=center>
		<%
		if(mark){
		%>
			<tr>
				<td><input type=button  class=button value="Save & Update" onclick="javascript:fnClose()">&nbsp;&nbsp;</td>
	    	<%if(!flag){%>
				<input type="hidden" name="formAction" value="update">
			<%}%>
				<td><input type=button  class=button value="Export Excel" onclick="exportExcel()"></td>
				<input type="hidden" name="excelAction" value="exportNo">
				<input type="hidden" name="projectId" value="<%=projId%>">
				<input type="hidden" name="materialIndex" value="<%=material.getIndex()%>">
			</tr>
		<%}else{%>
			<tr>
	    	<td><input type=button  class=button value="Save & Close" onclick="javascript:fnClose()">&nbsp;&nbsp;</td>
			<input type="hidden" name="formAction" value="insert">
			</tr>
		<%}%>
		</td>
	</tr>
</form>	

<script language="javascript">

function Sum()
{
	var oSubTotal;
	var oRecord ;
	var amount = 0.00;
	oRecord = document.getElementsByName('record');
	for(var i=0;i<oRecord.length;i++)
	{
	oSubTotal = document.getElementsByName('subtotal');
	amount = amount + parseFloat(oSubTotal[i].value.replace(/,/g, ""));
	}
	var oTotal = document.getElementsByName('total');
	oTotal[0].value = amount;
}		
function changeprice(count){
	var oQuantity ;
	oQuantity = document.getElementsByName('quantity');
	var quantity = 0;
	quantity = parseInt(oQuantity[count].value.replace(/,/g, ""));
	if(isNaN(quantity))
	{
	alert('Invalid quantity!');
	oQuantity[count].value = oQuantity[count].oldvalue.replace(/,/g, "");
	}
	else{
	var oPrice ;
	oPrice = document.getElementsByName('price');
	var price = 0.00;
	price = oPrice[count].value.replace(/,/g, "");	
	var total = 0.00
	var oSubTotal;
	oSubTotal = document.getElementsByName('subtotal');
	total = price*quantity;
	oSubTotal[count].value = total;
	oQuantity[count].oldvalue = oQuantity[count].value;	
	Sum();
	}
}

function fnClose() {
	var total = parseFloat(document.selForm.total.value);
	var err;
	if(	total<=0)
	{
	err='Total Amount can not be zero!';
	}	
	if(	document.selForm.descname.value.length<1 )
	{
	err='Please input Acceptance Description!';
	}
	if(document.selForm.modifydate.value==""){
	err='Please input Accept Date!';
	}
	if (err!=null){
	alert(err);
	}else{
	document.selForm.submit();
	}
}

function exportExcel() {
	var formObj = document.selForm;

	selForm.excelAction.value="exportYes";
	
//	document.getElementsByName('formAction').value = "ExportToExcel";
//	alert(document.getElementsByName('formAction').value);
	formObj.target = "_self";
	selForm.submit();
}

</script>
<%
	Hibernate2Session.closeSession();
//}else{
//	out.println("!!你没有相关访问权限!!");
}
//}
%>
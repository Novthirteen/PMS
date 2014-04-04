<%@ page contentType="text/html; charset=gb2312"%>

<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>

<script>

function fnReturn(){
		var formObj = document.frm;
		var count;
		count=0;
		if(formObj.chk.length) {
			for(var i=0;i<formObj.chk.length;i++) {
				if(formObj.chk[i].checked) {
					count++;
					window.parent.returnValue = formObj.chk[i].value;
					window.parent.close();
				}
			}
		} else {
			if(formObj.chk.checked) {
				count++;
				window.parent.returnValue = formObj.chk.value;
				window.parent.close();
			}
		}
		if(count==0){
			alert("Choose a option")
			return;
		}
		
		alert(window.parent.returnValue)
	}
	
	function fnQuery(){
		document.frm.submit();
	}


function showBOMDetailDialog(bomid)
{
	var code,desc;
	var cid,cdesc;
	var depid,depname;
	with(document.frm)
	{
	var param = "?formaction=dialogueView"
	if(bomid!=null)
	{
	param = param +"&masterid="+bomid;	
	}
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.call.actionTrack.body&editProjBOM.do"+param,
			null,
			'dialogWidth:600px;dialogHeight:600px;status:no;help:no;scroll:no');
	}
}

</script>

<%
try{

	if (true|| AOFSECURITY.hasEntityPermission("USER_LOGIN", "_VIEW", session)) {

		String lStrOpt=request.getParameter("rad");
		String srchproj=request.getParameter("srchproj");

		if(lStrOpt == null ) lStrOpt = "2";
		if(srchproj == null ) srchproj = "";
%>
<title>BOM Selection</title>

<form action="BOMChooseDialogue.do" name=frm method="POST">

	<input type="hidden" name="formAction" id="formAction">
	<input type="hidden" name="bom" id="bom" value="<%=(String)request.getAttribute("bom")%>">
	
	<table width=100% align=center>
		<CAPTION align=center class=pgheadsmall>BOM Select</CAPTION>
		<tr><td align='center' colspan=5></td></tr>
		<tr><td colspan=5><hr ></td></tr>
		<tbody>
			<tr bgcolor="e9eee9">
				<td class=lblbold align="center" width="50%" nowrap bgcolor="#4BEEE9">Customer Name</td>
				<td class=lblbold align="left" width="20%" nowrap>Bid Name</td>
				<td class=lblbold align="left" width="10%" nowrap>Bid Code</td>	
				<td class=lblbold align="left" width="10%" nowrap>Action</td>	
			</tr>
		</tbody>
		<tbody align="center">
			<tr><td>
				<A HREF="#A">A</A>&nbsp;
				<A HREF="#B">B</A>&nbsp;
				<A HREF="#C">C</A>&nbsp;
				<A HREF="#D">D</A>&nbsp;
				<A HREF="#E">E</A>&nbsp;
				<A HREF="#F">F</A>&nbsp;
				<A HREF="#G">G</A>&nbsp;
				<A HREF="#H">H</A>&nbsp;
				<A HREF="#I">I</A>&nbsp;
				<A HREF="#J">J</A>&nbsp;
				<A HREF="#K">K</A>&nbsp;
				<A HREF="#L">L</A>&nbsp;
				<A HREF="#M">M</A>&nbsp;
				<A HREF="#N">N</A>&nbsp;
				<A HREF="#O">O</A>&nbsp;
				<A HREF="#P">P</A>&nbsp;
				<A HREF="#Q">Q</A>&nbsp;
				<A HREF="#R">R</A>&nbsp;
				<A HREF="#S">S</A>&nbsp;
				<A HREF="#T">T</A>&nbsp;
				<A HREF="#U">U</A>&nbsp;
				<A HREF="#V">V</A>&nbsp;
				<A HREF="#W">W</A>&nbsp;
				<A HREF="#X">X</A>&nbsp;
				<A HREF="#Y">Y</A>&nbsp;
				<A HREF="#Z">Z</A>
			</td></tr>
		</tbody>
	</table>
	
	<table align="center" width=100%  Frame=box rules=none border=1 bordercolordark=black bordercolorlight=white bgcolor=white>
		<tr><td>
			<div style="word-break : break-all;width:850px;height:340px;overflow:auto;">
				<table width=100% align="center">
					<%
					SQLResults sr = (SQLResults)request.getAttribute("result");
					String pre = " ";
					if(sr!=null){
					for(int i=0;i<sr.getRowCount();i++)	{
						long mst_id = sr.getLong(i,"mst_id");
						String bomId = sr.getString(i,"bom_id");
						String custDesc = sr.getString(i,"cust_desc");
						String bidNo = sr.getString(i,"bid_no");
						String bidDesc = sr.getString(i,"bid_desc");		
						int template_id = sr.getInt(i,"template_id");				
						if(!(custDesc.startsWith(pre.toLowerCase())||(custDesc.startsWith(pre.toUpperCase()))))	{
							pre = custDesc.substring(0,1).toUpperCase();
						%>
						<tr>
							<td>&nbsp;</td>
							<td><a name="<%=pre%>"><%=pre%></a></td>
							<td>&nbsp;</td>
						</tr>
						<%}%>
						<tr class="listbody">
							<td width="5%"><input type=radio name=chk style="border:0px;background-color:#ffffff" value="<%=bomId%>|<%=bidNo%>|<%=bidDesc%>|<%=template_id%>">&nbsp;</td>
							<td width="50%"><%=custDesc%></td>
							<td width="30%"><%=bidDesc%>&nbsp;&nbsp;</td>
							<td width="10%" ><%=bidNo%></td>
							<td width="10%" ><input size="8" type="button" value="Detail" onclick="javascript:showBOMDetailDialog(<%=mst_id%>)" class="button"></td>
						</tr>
					<%}
					}%>
				</table>
			</div>		
		</td></tr>
	</table>
	
	<table align="center">
		<tr ><td>&nbsp;</td></tr>
		<tr>
			<td class=lblbold colspan=6>&nbsp;</td>
			<td colspan=4 align=center>
				<input type=button name="save" class=button value="Select" onclick="fnReturn()">
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type=button name="close" class=button value="Cancel" onclick="window.parent.close()">
			</td>
		</tr>		
		<tr>
			<td class=lblbold colspan=4>&nbsp;</td>
	      	<td colspan=4>
	         	<table align=center border=0 cellspacing=1 cellpadding=5  rules=none>
	         		<tr>
			        	<td class=LblBold>Search for</td>
			          	<td><input type=text name=srchproj size=15 maxlength=20 value="<%=srchproj%>"></td>
			          	<td><input type=button class=button name="btnQuery" value="Go" onclick="fnQuery()"></td>
	         		</tr>
	         		<tr>
	          			<td class=LblBold>Exact</td>
	          			<td colspan=2>
	            			<input type=radio name='rad' value='1' <%=lStrOpt.equals("1") ? "checked" : "" %>>&nbsp;Yes&nbsp;&nbsp;&nbsp;
	            			<input type=radio name=rad value='2' <%=lStrOpt.equals("2") ? "checked" : "" %>>&nbsp;No
	          			</td>
	         		</tr>
	         	</table>
	      	</td>
	   	</tr>
	</table>
</form> 
<%
	}else{
		out.println("!!你没有相关访问权限!!");
	}
}catch(Exception e){
	e.printStackTrace();
}
%>

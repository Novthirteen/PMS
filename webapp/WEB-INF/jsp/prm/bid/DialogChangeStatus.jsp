<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<%@ page import="com.aof.util.*"%>

<HTML>
	<HEAD>
		<LINK href="includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
		<LINK href="includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
		
		<script language="javascript">
			
			function onClose() {
				var txtReason = document.iForm.reason.value;				
				window.parent.returnValue = txtReason;
				window.parent.close();
			}
			
			function loadParam() {
				var txtReason = document.iForm.reason.value;				
				window.parent.returnValue = txtReason;
			}
			
			function textCounter(field, countfield, maxlimit) { 
				if (field.value.length > maxlimit) {
					field.value = field.value.substring(0, maxlimit); 
				} else {
					countfield.value = maxlimit - field.value.length;
				}
			} 
		</script>
	</HEAD>
	<BODY onunload="loadParam()">
		<form name="iForm" action="" method="post">
			<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
			<table width=102% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Change Bid Status</CAPTION>
				<tr>
					<td align="left" class="lblbold" bgcolor="#e9eee9">Reason for changing Bid status</td>
				</tr>
				<tr>
					<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
				</tr>
				<tr>
					<td align="center">
			        	<textarea name="reason" rows="5" cols="70" onKeyDown="textCounter(this.form.reason,this.form.remLen,500);" onKeyUp="textCounter(this.form.reason,this.form.remLen,500);" style="background-color:#ffffff"></textarea>
					</td>
				</tr>
				<tr>
        			<td>
        				(<input readonly type=text name="remLen" size="2" maxlength="4" value="500" class="lblbold" style="text-align:center;border=0px"> words left you can key in.)
        			</td>
        		</tr>
				<tr>
					<td align="right"><input type="button" value="Submit" class="loginButton" onclick="javascript:onClose()"></td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>
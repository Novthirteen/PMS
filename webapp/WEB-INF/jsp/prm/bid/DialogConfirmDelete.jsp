<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

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
		</script>
	</HEAD>
	<BODY onunload="loadParam()">
		<form name="iForm" action="" method="post">
			<table width=102% cellpadding="1" border="0" cellspacing="1">
				<CAPTION align=center class=pgheadsmall>Delete Bid</CAPTION>
				<tr>
					<td align="left" class="lblbold" bgcolor="#e9eee9">Reason for delete</td>
				</tr>
				<tr>
					<td colspan=8 valign="bottom"><hr color="#B5D7D6"></hr></td>
				</tr>
				<tr>
					<td align="center">
			        	<textarea name="reason" rows="5" cols="70" style="background-color:#ffffff"></textarea>
					</td>
				</tr>
				<tr>
					<td align="right"><input type="button" value="Submit" class="loginButton" onclick="javascript:onClose()"></td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>
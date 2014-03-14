<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<head>
<META content=no-cache http-equiv=Pragma>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<SCRIPT>
function onForgetPwd(){
 if (document.logonForm.username.value=="")
 {
 alert ("user ID can't be ignore");
 return false;
 }
}


function showBidDialog()
{
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.servicelevel.category.dialog.title&<%=request.getContextPath()%>/rolepage/staff/dialog.jsp?",
			null,
			'dialogWidth:710px;dialogHeight:580px;status:no;help:no;scroll:no');
}

//showBidDialog();
</SCRIPT>
<%
String sendPwd=(String)request.getAttribute("SendPwdByEmail");
%>
</head>
<table width="100%" height="377">
  <tr>
    <td height="12" vAlign="top" width="100%"> 
	<TABLE CLASS="PortalHeader" WIDTH="100%" BORDER=0 CELLSPACING=0 CELLPADDING=0 width="100%">
	<TR VALIGN=top>
		<TD CLASS="PortalTitle" WIDTH="24%" ROWSPAN=2>
			<IMG SRC="<%=request.getContextPath()%>/icons/ecblank.gif" BORDER=0 HEIGHT=1 WIDTH=1 ALT=""><BR>
			<IMG SRC='<%=request.getContextPath()%>/images/logo2.jpg'  BORDER=0>
		</TD>
	</TR>
	</TABLE>
    </td>
  </tr>
  <tr>
    <td height="287" vAlign="top" width="100%">
      <table border="0" cellPadding="0" cellSpacing="0" width="100%">
        <tbody>
          <tr>
            <td>
                <table border="0" cellPadding="4" cellSpacing="0" width="100%" height="1">
                  <tbody>
                    <tr class="wpsTableAdminHead">
                      <td align="left" noWrap height="1" ><span class="tabletext">Welcome Log into the Project Management System</span></td>
                    </tr>
                  </tbody>
                </table>
                <table border="0" cellPadding="0" cellSpacing="4" width="100%">
                  <tbody>
                    <tr height="1">
                      <td class="wpsAdminHeadSeparator" height="1"><img alt border="0" height="1" src="<%=request.getContextPath()%>/images/dot.gif"></td>
                    </tr>
                  </tbody>
                </table>
                <table border="0" cellPadding="0" cellSpacing="0" width="100%">
                  <tbody>
                    <tr>
                      <td align="left" vAlign="top">
		            <table width='100%' border='0' cellspacing='0' cellpadding='0' class='boxbottom'>
		              <tr>
		                <td align="center" valign="center" width='100%'>
		                <html:form action="/logon" focus="username" >
                       <table width='100%' border='0' cellpadding='0' cellspacing='2'>
                          <tr> 
                            <td>&nbsp; </td>
                          </tr>
                          <tr> 
                            <td>&nbsp; </td>
                          </tr>
                          <tr> 
                            <td align="right"> <span class="tabletext">Login ID:&nbsp;</span> 
                            </td>
                            <td> 
                              <input type="text" class="inputBox" name="username" size="20">
                            </td>
                          </tr>
                          <tr> 
                            <td height="2">&nbsp; </td>
                          </tr>
                          <tr> 
                            <td align="right"><span class="tabletext">Password:</span></td>
                            <td align="left"> 
                              <input type="password" class="inputBox" name="password" value="" size="20">
                            </td>
                          </tr>
                          <tr> 
                            <td height="2">&nbsp; </td>
                          </tr>
                          <tr> 
                            <td align="right"><span class="tabletext">Language:</span></td>
                            <td align="left"> 
                              <select name="locale">
                              	<option value="">Previous Setting</option>
                              	<option value="zh">ÖÐÎÄ</option>
                              	<option value="en">english</option>
                              </select>
                            </td>
                          </tr>
                          <tr> 
                            <td height="2">&nbsp; </td>
                          </tr>
                          <tr> 
                            <td align="right">&nbsp; </td>
                            <td align="left"> 
                              <input type="submit" value="Login" class="loginButton" name="submit"/>
                              <input type="submit" value="Forget Password?" class="loginButton" name="ForgetPwd"  onclick="javascript:onForgetPwd()"/>
                            </td>
                          </tr>
                          <tr> 
                          <td align="right">&nbsp;</td>
                            <td align="left"></td>
                          </tr>
                          <tr>
                          <td colspan=2 align="left"><input type="text" size="30" style="border:0px;background-color:#ffffff">&nbsp; 
                          <font size="1">If you can not access
													PAS, please contact with</font><A
														title="Send an email with a link to this page"
														href="mailto:ling.xia@atosorigin.com?subject=Can not access to PAS&body=Please write down your problem here">
														<font size="1">Administrator</font></A>.</td>
												</tr>
                        </table>
		                  </html:form>
		                </td>
		              </tr>
		            </table>
                        <table border="0" width="100%" cellPadding="8" cellSpacing="0">
                          <tbody>
                           <%
if ( sendPwd!=null && sendPwd.length()>0){
out.println("<br><tr><td colspan='21' class=lblerr align='center'>Your password has been sent to your mailbox, please check it!</td></tr>");
request.setAttribute("SendPwdByEmail","");
}else{
%>
                            <tr>
                              <td colSpan="2">
                              </td>
                            </tr>
                            <%}%>
                            <tr>
                              <td colSpan="2"><div class="tabletext"></div></td>
                            </tr>
                          </tbody>
                        </table>
                      
                      </td>
                      <td height="100%">
                  <div align="center"></div>
                </td>
                    </tr>
                  </tbody>
                </table>
                <table border="0" cellPadding="0" cellSpacing="4" width="100%">
                  <tbody>
                    <tr height="1">
                      <td class="wpsAdminHeadSeparator" height="1"><img alt border="0" height="1" src="./images/dot.gif"></td>
                    </tr>
                  </tbody>
                </table>
            </td>
          </tr>
        </tbody>
      </table>
    </td>
  </tr>
</table>